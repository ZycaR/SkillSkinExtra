//
//	Shine SkillSkinExtra plugin
//	ZycaR (c) 2016
//

local Shine = Shine
local Plugin = Plugin

Plugin.Version = "1.0"
Plugin.HasConfig = false --Does this plugin have a config file?
Plugin.ConfigName = "SkillsSkinExtra.json" --What's the name of the file?
Plugin.DefaultState = true --Should the plugin be enabled when it is first added to the config?
Plugin.NS2Only = false --Set to true to disable the plugin in NS2: Combat if you want to use the same code for both games in a mod.
Plugin.DefaultConfig = {}
Plugin.CheckConfig = false --Should we check for missing/unused entries when loading?
Plugin.CheckConfigTypes = false --Should we check the types of values in the config to make sure they match our default's types?

function Plugin:Initialise()
    self.Enabled = true
    return true
end

function Plugin:Cleanup()
    self.BaseClass.Cleanup( self )
    self.Enabled = false
end