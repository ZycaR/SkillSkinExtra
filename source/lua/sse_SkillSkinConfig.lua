--[[
 	SkillSkinExtra
	ZycaR (c) 2016
]]

Script.Load("lua/ConfigFileUtility.lua")
local kConfigFileName = "SkillSkinConfig.json"

-- ColorSkinMixin Globals
kSkillSkinsDisabled = 0.0
kSkillSkinsEnabled = 1.0

local kDisabledConfig = { 
        Min = 0.0, Max = 65536.0, Color = {  r =  0, g =  0, b =  0}, Channel = kSkillSkinsDisabled, Name = "N/A"
}
local kDefaultConfig = {
    channel = kSkillSkinsDisabled,
    ranks = { -- defined as exponential function ( 4^x )
        { Min =     0.0, Max =    16.0, Color = {  r =  60, g =  20, b =  79}, Channel = kSkillSkinsEnabled, Name = "Hamster" },
        { Min =    16.0, Max =    64.0, Color = {  r =  32, g =  46, b = 212}, Channel = kSkillSkinsEnabled, Name = "Blue" },
        { Min =    64.0, Max =   256.0, Color = {  r = 255, g =   0, b =   0}, Channel = kSkillSkinsEnabled, Name = "Red" },
        { Min =   256.0, Max =  1024.0, Color = {  r =  32, g = 127, b =  16}, Channel = kSkillSkinsEnabled, Name = "Green" },
        { Min =  1024.0, Max =  4096.0, Color = {  r = 218, g = 165, b =  32}, Channel = kSkillSkinsEnabled, Name = "Elite" },
        { Min =  4096.0, Max = 16384.0, Color = {  r = 255, g = 255, b = 255}, Channel = kSkillSkinsEnabled, Name = "Admin" }
    }
}

if Server then

    local config = LoadConfigFile(kConfigFileName, kDefaultConfig, true)

    function GetRankByPlaytime(playtime, enabled)
        if enabled > 0 and config.ranks then
            for _, rank in ipairs(config.ranks) do
                if rank.Min <= playtime and rank.Max >= playtime then
                    return rank
                end
            end
        end
        return kDisabledConfig
    end

end