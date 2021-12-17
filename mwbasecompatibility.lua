local PLUGIN = PLUGIN

PLUGIN.name = "Modern Warfare Base Compatibility"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds some compatibility features for MW Base."

local MWBase = weapons.GetStored( "mg_base" )

function PLUGIN:PluginLoaded( uniqueID, pluginTable )
    MWBase.IsAlwaysRaised = true;
end