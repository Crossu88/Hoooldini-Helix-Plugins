local PLUGIN = PLUGIN

PLUGIN.name = "Disable Ammo Counter"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Disables the default ammo counter."

function PLUGIN:CanDrawAmmoHUD( weapon )
    return false
end