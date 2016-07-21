--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016

NOTE: Server only.
]]

Script.Load("lua/sse_SkillSkinMessage.lua")
local kWonitorRequestUrl = "http://apheriox.com/wonitor/getPlayerStats.php"
local kWonitorSetupUrl   = "http://apheriox.com/wonitor/setPlayerConfig.php"

local function SetPlayerParams(params)
    --Shared.Message(string.format("SteamID: %d -  Client: %s - Playtime: %0.2fh - Enabled: %d",
    --    params.steamId, ToString(params.clientId), params.playtime, params.enabled))

    if params and params.clientId then
        local client = Server.GetClientById(params.clientId)
        local player = client and client:GetControllingPlayer()

        if player then
            player.sseR = params.color.r
            player.sseG = params.color.g
            player.sseB = params.color.b
            player.sseChannel = params.channel
            return true
         end
    end
    return false
end

local wonitorData = {}
function GetWonitorDataBySteamId(steamId)
    return wonitorData[steamId]
end

local function WonitorResponse(clientIds)
    return function (response)
        local data = json.decode(response)
        if data then
            for sid, stats in pairs(data) do
                local steamId = tonumber(sid)
                local playtime = (tonumber(stats.playtime) or 0.0) / 3600
                local enabled = tonumber(stats.skinsEnabled) or 0
                local rank = GetRankByPlaytime(playtime, enabled)

                local params = {
                    steamId = steamId,
                    clientId = clientIds[steamId],
                    playtime = playtime,
                    enabled = enabled,
                    color = rank.Color,
                    channel = rank.Channel,
                    name = rank.Name,
                    percent = (playtime - rank.Min) / (rank.Max - rank.Min) * 100.0
                }
                wonitorData[steamId] = params
                
                if SetPlayerParams(params) then
                    Server.SendNetworkMessage("SetPlayerSkin", params, true)
                    --Server.SendNetworkMessage("SetPlayerSkin", {
                    --    steamId = params.steamId,
                    --    name = params.name,
                    --    playtime = params.playtime,
                    --    percent = params.percent,
                    --    enabled = params.enabled
                    --}, true)
                end
            end
        end
    end
end

local function RequestWonitor(steamIds, clientIds, url)
    local params = {
        steamId = table.concat(steamIds, ",")
        --serverIp = IPAddressToString( Server.GetIpAddress() )
        --serverPort = Server.GetPort()
    }
    Shared.SendHTTPRequest(kWonitorRequestUrl, "GET", params, WonitorResponse(clientIds) )
end

function SetupWonitorForClient(client, value)
    local steamId = client:GetUserId()
    local clientId = { [steamId] = client:GetId() }
    
    local params = {
        steamId = steamId,
        skinsEnabled = value
    }
    Shared.SendHTTPRequest(kWonitorSetupUrl, "GET", params, WonitorResponse(clientId) )
end

function RequestWonitorForClient(client)
    local steamId = client:GetUserId()
    local clientId = client:GetId()
    local data = wonitorData[steamId]
    
    if data and data.steamId == steamId then
        -- update clientId for reconnected players
        wonitorData[steamId].clientId = clientId
        SetPlayerParams(wonitorData[steamId])
    else -- missing wonitor data or invalid ones
        RequestWonitor( { steamId }, { [steamId] = clientId } )
    end
end

function RequestWonitorForPlayers(players)
    local steamIds = {}
    local clientIds = {}
    
    for i,player in pairs(players) do
        local sid = player:GetSteamId()
        local cid = player:GetClientIndex()
        
        if sid > 0 and cid > 0 then
            table.insert(steamIds, sid)
            clientIds[sid] = cid
        end
    end
    
    RequestWonitor(steamIds, clientIds)
end