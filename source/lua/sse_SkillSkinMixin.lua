--[[
 	SkillSkinExtra
	ZycaR (c) 2016
]]

if Server then
    Script.Load("lua/sse_SkillSkinWonitor.lua")
    Script.Load("lua/sse_SkillSkinCommands.lua")
end

SkillSkinsMixin = CreateMixin( SkillSkinsMixin )
SkillSkinsMixin.type = "SkillSkins"

SkillSkinsMixin.kShaderName = {
    "shaders/SkillSkins_marine.surface_shader",
    "shaders/SkillSkins_alien.surface_shader",
    "shaders/SkillSkins_alien_alpha.surface_shader"
}
SkillSkinsMixin.kMaskList = {
    "models/marine/body_sseMap.dds",
    "models/marine/hands/hands_sseMap.dds",
    "models/alien/alien_sseMap.dds",
    "models/alien/alien2_sseMap.dds"
}

SkillSkinsMixin.networkVars =
{
    sseR = "integer (0 to 255)",
    sseG = "integer (0 to 255)",
    sseB = "integer (0 to 255)",
    sseChannel = "float (0.0 to 3.0 by 1.0)"
}

SkillSkinsMixin.expectedMixins =
{
	Model = "Needed for setting material parameters"
}

SkillSkinsMixin.expectedCallbacks = {}
SkillSkinsMixin.optionalCallbacks = {}

function SkillSkinsMixin:__initmixin()
    local wonitor = Server and GetWonitorDataBySteamId and GetWonitorDataBySteamId(self:GetSteamId())
    if wonitor and GetRankByPlaytime then
        --Shared.Message(string.format("Playtime: %0.2fh - Enabled: %d", wonitor.playtime, wonitor.enabled))

        local rank = GetRankByPlaytime(wonitor.playtime, wonitor.enabled)
        self.sseR, self.sseG, self.sseB = rank.Color.r, rank.Color.g, rank.Color.b
        self.sseChannel = rank.Channel
    else
        self.sseR, self.sseG, self.sseB = 0, 0, 0
        self.sseChannel = kSkillSkinsDisabled
    end
end

if Client then

    -- precache shaders
    for _, shader in ipairs(SkillSkinsMixin.kShaderName) do
        Shared.PrecacheSurfaceShader(shader)
    end
    
    -- precache textures
    for _, mask in ipairs(SkillSkinsMixin.kMaskList) do
        PrecacheAsset(mask)
    end

    function SkillSkinsMixin:OnUpdateRender()
        local model = self:GetRenderModel()
        if model ~= nil then
                
            model:SetMaterialParameter( "skillColorR", ColorValue(self.sseR) )
            model:SetMaterialParameter( "skillColorG", ColorValue(self.sseG) )
            model:SetMaterialParameter( "skillColorB", ColorValue(self.sseB) )
            model:SetMaterialParameter( "skillColorEnabled", self.sseChannel )
            
            --local dump = string.format("(%0.3f, %0.3f, %0.3f)", self.sseR, self.sseG, self.sseB )
            --Print("\t Color = " .. dump )
        end
    end
    
end -- Client

