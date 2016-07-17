--[[
 	Shine SkillSkinExtra plugin
	ZycaR (c) 2016
]]

local Plugin = Plugin
local Shine = Shine

function Plugin:Initialise()
    self.Enabled = true
    self:UpdateMenuEntry(true)
    return true
end

function Plugin:UpdateMenuEntry( visible )
    if self.MenuEntry then
        self.MenuEntry:SetIsVisible( visible )
        return
    end

    Shine.VoteMenu:EditPage( "Main",
        function( Menu )
            self.MenuEntry = Menu:AddSideButton( "Skin Toggle",
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