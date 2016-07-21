--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016
]]

Script.Load("lua/sse_SkillSkinMessage.lua")

local plugin = Plugin
local shine = Shine

Plugin.sse = {
    name = "Loading ..",
    enabled = 0.1,
    playtime = 0.1,
    percent = 0
}

function Plugin:Initialise()
    self.Enabled = true
    self:UpdateMenuEntry(true)
    
    Shared.Message("initialize")
    return true
end

function Plugin:GetMenuEntryLabel()
    local data = self.sse
    if data.enabled <= 0 then   return "Enable Skin"    end
    if data.playtime <= 0 then  return "Skin N/A"       end

    return string.format("%s (%0.1f%%)", data.name, data.percent)
end

function Plugin:UpdateMenuEntry( visible )
    if self.MenuEntry then
        self.MenuEntry:SetIsVisible( visible )
        self.MenuEntry:SetText( self:GetMenuEntryLabel() )
        return
    end

    Shine.VoteMenu:EditPage( "Main",
        function( Menu )
            self.MenuEntry = Menu:AddSideButton( plugin:GetMenuEntryLabel(),
                function() Menu.GenericClick( "sse_toggle" ) end
            )
            self.MenuEntry:SetIsVisible( visible )
        end
    )
end

function Plugin:Cleanup()
    self:UpdateMenuEntry(false)
    self.BaseClass.Cleanup(self)
    self.Enabled = false
end

-- update shine button text according netwrok message

function OnSetPlayerSkin(params)
    if Client and params and
       Client.GetLocalPlayer() and
       params.steamId == Client.GetSteamId()
    then
        plugin.sse.name = params.name
        plugin.sse.enabled = params.enabled
        plugin.sse.playtime = params.playtime
        plugin.sse.percent = params.percent
        
        if plugin.MenuEntry then plugin:UpdateMenuEntry( true ) end
	    
        --Shared.Message(string.format("Percent: %0.2fh - Enabled: %d", plugin.ssePercent, plugin.sseEnabled))
    end
end

Client.HookNetworkMessage("SetPlayerSkin", OnSetPlayerSkin)
