--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016
	
NOTE: Shared message from server to clients.
Should be included in any file working with message
]]

if not kSetPlayerSkinMessage then

    kMaxRankNameLength = 20
    kSetPlayerSkinMessage =
    {
        steamId = "integer",
        name = string.format("string (%d)", kMaxRankNameLength * 4 ),
        playtime = "float",
        percent = "float (0 to 100 by 0.1)",
        enabled = "integer"
    }
    Shared.RegisterNetworkMessage("SetPlayerSkin", kSetPlayerSkinMessage)
    
end