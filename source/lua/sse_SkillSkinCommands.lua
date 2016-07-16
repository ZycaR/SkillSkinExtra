//
//	SkillSkinExtra NS2 Mod
//	ZycaR (c) 2016
//
// NOTE: Server only.

local function ToColorValue(color)
    return Clamp( tonumber(color), 0, 255 )
end

// Send playtime request to wonitor
local function OnClientConnect(client)
    if client and not client:GetIsVirtual() then
        RequestWonitorForClient(client)
    end
end
Event.Hook("ClientConnect", OnClientConnect)

// Toggle show / hide of skill skins
local function OnCommandToggleSkillSkins(client)
    if client and not client:GetIsVirtual() then
        local player = client:GetControllingPlayer()
        
        local toggle = ConditionalValue(player.sseChannel == kSkillSkinsDisabled, kSkillSkinsEnabled, kSkillSkinsDisabled)
        Print("SkillSkinsExtra: " .. ToString(toggle))
        
        SetupWonitorForClient(client, toggle)
    end
end
Event.Hook( "Console_sse_toggle", OnCommandToggleSkillSkins )

// Sync playtime for all players
local function OnCommandSyncWonitor(client)
    if Shared.GetCheatsEnabled() then
        Print("SkillSkinsExtra Sync Wonitor.")
        local players = GetEntitiesWithMixin("SkillSkins")
        RequestWonitorForPlayers(players)
    end
end
Event.Hook( "Console_sse_sync", OnCommandSyncWonitor )


// Set map mask channel (sse_channel 1)
local function OnCommandSetChannel(client, channel)
    if Shared.GetCheatsEnabled() then

        local skillSkinChannel = Clamp( tonumber(channel), 0.0, 3.0 )
        Print("SkillSkinsExtra Channel = " .. tostring( skillSkinChannel ) )
        
        for _, player in ipairs(GetEntitiesWithMixin("SkillSkins")) do
            player.sseChannel = channel
        end
    end
end
Event.Hook( "Console_sse_channel", OnCommandSetChannel )
    
// Set skill skin color values (sse_color 255,0,255)
local function OnCommandSetColor(client, color)
    if Shared.GetCheatsEnabled() then

        local rgb = StringSplit( color, ",", 3)
        local r,g,b = ToColorValue(rgb[1]), ToColorValue(rgb[2]), ToColorValue(rgb[3])
        Print("SkillSkinsExtra Color = " .. string.format("(%d, %d, %d)", r, g, b ))

        for _, player in ipairs(GetEntitiesWithMixin("SkillSkins")) do
            player.sseR = r
            player.sseG = g
            player.sseB = b
        end
    end
end
Event.Hook( "Console_sse_color", OnCommandSetColor )
