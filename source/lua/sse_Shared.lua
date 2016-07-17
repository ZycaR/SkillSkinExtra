--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016
]]

if Server then
    -- SkillSkin Globals Colors Settings .. load once and for server only
    Script.Load("lua/sse_SkillSkinConfig.lua")
    Script.Load("lua/Server.lua")
elseif Client then
    Script.Load("lua/Client.lua")
elseif Predict then
    Script.Load("lua/Predict.lua")
end