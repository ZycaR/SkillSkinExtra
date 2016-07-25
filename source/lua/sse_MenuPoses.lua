--[[
 	SkillSkinExtra
	ZycaR (c) 2016
]]

local ns2_Update = MenuPoses.Update
function MenuPoses:Update(deltaTime)
    ns2_Update(self, deltaTime)
    
    -- set parameters to properly render menu poses models according skil skin
    local model = model.renderModel
    local player = Client.GetLocalPlayer()
    if MainMenu_GetIsOpened() and model ~= nil and player ~= nil then
        model:SetMaterialParameter( "skillColorR", ColorValue(player.sseR) )
        model:SetMaterialParameter( "skillColorG", ColorValue(player.sseG) )
        model:SetMaterialParameter( "skillColorB", ColorValue(player.sseB) )
        model:SetMaterialParameter( "skillColorChannel", player.sseChannel )
    end
end
