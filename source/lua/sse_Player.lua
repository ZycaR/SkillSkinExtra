--[[
 	SkillSkinExtra
	ZycaR (c) 2016
]]

Script.Load("lua/sse_SkillSkinMixin.lua")

local ns2_OnInitialized = Player.OnInitialized
function Player:OnInitialized()
    InitMixin(self, SkillSkinsMixin)
    ns2_OnInitialized(self)
end

if Server then

    -- Copy SkillSkinExtra data from player to spectator and back for respawn purpose
    local ns2_CopyPlayerDataFrom = Player.CopyPlayerDataFrom
    function Player:CopyPlayerDataFrom(player)
        ns2_CopyPlayerDataFrom(self, player)

        self.sseR = player.sseR
        self.sseG = player.sseG
        self.sseB = player.sseB
        self.sseChannel = player.sseChannel
    end

end

-- Modder's version of AddMixinNetworkVars()
Shared.LinkClassToMap("Player", Player.kMapName, SkillSkinsMixin.networkVars)