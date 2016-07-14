//
//	SkillSkinExtra NS2 Mod
//	ZycaR (c) 2016
//

Script.Load("lua/sse_SkillSkinsMixin.lua")

local ns2_OnInitialized = Player.OnInitialized
function Player:OnInitialized()
    InitMixin(self, SkillSkinsMixin)
    ns2_OnInitialized(self)
end

// Modder's version of AddMixinNetworkVars()
Shared.LinkClassToMap("Player", Player.kMapName, SkillSkinsMixin.networkVars)