//
//	SkillSkinExtra NS2 Mod
//	ZycaR (c) 2016
//

Script.Load("lua/sse_SkillSkinWonitor.lua")

SkillSkinsMixin = CreateMixin( SkillSkinsMixin )
SkillSkinsMixin.type = "SkillSkins"

SkillSkinsMixin.kShaderName = "shaders/SkillSkins.surface_shader"
SkillSkinsMixin.kMaskList = {
    "models/marine/male/male_body_sseMap.dds"
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
    self.sseR, self.sseG, self.sseB = 0, 0, 0
    self.sseChannel = kSkillSkinsDisabled
end

if Client then

    // precache textures and shader
    for _, mask in ipairs(SkillSkinsMixin.kMaskList) do
        PrecacheAsset(mask)
    end
    Shared.PrecacheSurfaceShader(SkillSkinsMixin.kShaderName)

    function SkillSkinsMixin:OnUpdateRender()
        local model = self:GetRenderModel()
        if model ~= nil then
                
            model:SetMaterialParameter( "skillColorR", ColorValue(self.sseR) )
            model:SetMaterialParameter( "skillColorG", ColorValue(self.sseG) )
            model:SetMaterialParameter( "skillColorB", ColorValue(self.sseB) )
            model:SetMaterialParameter( "skillColorChannel", self.sseChannel )
            
            //local dump = string.format("(%0.3f, %0.3f, %0.3f)", self.sseR, self.sseG, self.sseB )
            //Print("\t Color = " .. dump )
        end
    end
    
end // Client

if Server then

    // Send playtime request to wonitor
    local function OnClientConnect(client)
        if client and not client:GetIsVirtual() then
            RequestWonitorForClient(client)
        end    
    end
    Event.Hook("ClientConnect", OnClientConnect)

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
    
    local function ToColorValue(color)
        return Clamp( tonumber(color), 0, 255 )
    end
    
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

    local function OnCommandSyncWonitor(client)
        if Shared.GetCheatsEnabled() then
            Print("SkillSkinsExtra Sync Wonitor.")
            local players = GetEntitiesWithMixin("SkillSkins")
            RequestWonitorForPlayers(players)
        end
    end
    Event.Hook( "Console_sse_sync", OnCommandSyncWonitor )

end