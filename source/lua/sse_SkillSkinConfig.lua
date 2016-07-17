//
//	SkillSkinExtra NS2 Mod
//	ZycaR (c) 2016
//
Script.Load("lua/ConfigFileUtility.lua")

local kConfigFileName = "SkillSkinConfig.json"

// ColorSkinMixin Globals
kSkillSkinsDisabled = 0
kSkillSkinsEnabled = 1

local kDisabledConfig = { Color = {  r =  0, g =  0, b =  0}, Channel = 0.0, Name = "disabled" }
local kDefaultConfig = {
    channel = kSkillSkinsDisabled,
    ranks = { // defined as exponential function ( 4^x )
        { Min =     0.0, Max =    16.0, Color = {  r =  60, g =  20, b =  79}, Channel = 1.0, Name = "rokie" },
        { Min =    16.0, Max =    64.0, Color = {  r =   0, g =   0, b = 255}, Channel = 1.0, Name = "blue" },
        { Min =    64.0, Max =   256.0, Color = {  r = 255, g =   0, b =   0}, Channel = 1.0, Name = "red" },
        { Min =   256.0, Max =  1024.0, Color = {  r =   0, g = 255, b =   0}, Channel = 1.0, Name = "green" },
        { Min =  1024.0, Max =  4096.0, Color = {  r = 218, g = 165, b =  32}, Channel = 1.0, Name = "elite" },
        { Min =  4096.0, Max = 16384.0, Color = {  r = 255, g = 255, b = 255}, Channel = 1.0, Name = "white" }
    }
}

if Server then

    local config = LoadConfigFile(kConfigFileName, kDefaultConfig, true)

    function GetRankByPlaytime(playtime, enabled)
        if enabled > 0 and config.ranks then
            for _, rank in ipairs(config.ranks) do
                if rank.Min <= playtime and rank.Max >= playtime then
                    return rank.Color, rank.Channel, rank.Name
                end
            end
        end
        return kDisabledConfig.Color, kDisabledConfig.Channel, kDisabledConfig.Name
    end

end