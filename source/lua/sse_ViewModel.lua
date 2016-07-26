--[[
 	SkillSkinExtra
	ZycaR (c) 2016
]]

if Client then

    local ns2_OnUpdateRender = ViewModel.OnUpdateRender
    function ViewModel:OnUpdateRender()
        ns2_OnUpdateRender(self)
        
        -- set parameters to properly render menu poses models according skil skin
        local model = self:GetRenderModel()
        local player = Client.GetLocalPlayer()
        
        if model ~= nil and player ~= nil then
            model:SetMaterialParameter( "skillColorR", ColorValue(player.sseR) )
            model:SetMaterialParameter( "skillColorG", ColorValue(player.sseG) )
            model:SetMaterialParameter( "skillColorB", ColorValue(player.sseB) )
            
            local offset = ConditionalValue(player.GetIsMale and player:GetIsMale(), 1.0, 2.0)
            model:SetMaterialParameter( "skillColorChannel", player.sseChannel * offset )
        end
    end

end