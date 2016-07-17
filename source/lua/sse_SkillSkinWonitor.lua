--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016

NOTE: Server only.
]]

local kWonitorRequestUrl = "http://apheriox.com/wonitor/getPlayerStats.php"
local kWonitorSetupUrl   = "http://apheriox.com/wonitor/setPlayerConfig.php"

local function SetPlayerParams(params)
    Shared.Message(string.format("SteamID: %d -  Client: %s - Playtime: %0.2fh - Enabled: %d",
        params.steamId, ToString(params.clientId), params.playtime, params.enabled))

    if params.clientId then
        local client = Server.GetClientById(params.clientId)
        local player = client and client:GetControllingPlayer()

        if player and GetRankByPlaytime then
            local color, channel, name = GetRankByPlaytime(params.playtime, params.enabled)
            player.sseR = color.r
            player.sseG = color.g
            player.sseB = color.b
            player.sseChannel = channel
         end
    end
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
                local params = {
                    steamId = steamId,
                    clientId = clientIds[steamId],
                    playtime = (tonumber(stats.playtime) or 0.0) / 3600,
                    enabled = tonumber(stats.skinsEnabled) or 0
                }
                wonitorData[steamId] = params
                SetPlayerParams(params)
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