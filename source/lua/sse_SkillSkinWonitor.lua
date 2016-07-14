//
//	SkillSkinExtra NS2 Mod
//	ZycaR (c) 2016
//

local kWonitorRequestUrl = "http://apheriox.com/wonitor/getPlayerStats.php"

if Server then

    local function SetPlayerParams(params)
        Shared.Message(string.format("SteamID: %s -  Client: %s - Playtime: %0.2fh",
            ToString(params.steamId), ToString(params.clientId), params.playtime))

        if params.clientId then
            local client = Server.GetClientById(params.clientId)
            local player = client and client:GetControllingPlayer()

            if player and GetRankByPlaytime then
                local color, channel, name = GetRankByPlaytime(params.playtime)

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
                    local seconds = tonumber(stats.playtime) or 0.0
                    local params = {
                        steamId = steamId,
                        clientId = clientIds[steamId],
                        playtime = seconds / 3600,
                    }
                    wonitorData[steamId] = params
                    SetPlayerParams(params)
                end
            end
        end
    end

    local function RequestWonitor(steamIds, clientIds)
        local params = {
            steamId = table.concat(steamIds, ","),
            serverIp = IPAddressToString( Server.GetIpAddress() ),
            serverPort = Server.GetPort(),
        }
        
        Shared.Message("Request wonitor data for: " .. params.steamId)
        Shared.SendHTTPRequest(kWonitorRequestUrl, "GET", params, WonitorResponse(clientIds) )
    end

    function RequestWonitorForClient(client)
        local steamId = client:GetUserId()
        local clientId = client:GetId()
        local data = wonitorData[steamId]
        
        if data and data.steamId == steamId then
            SetPlayerParams(data)
        else // missing wonitor data or invalid ones
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

end