PLUGIN.name = "Melee SWEP Compatibility"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds compatibility for TFA Bash Base, CW Melee, and TFA NMRIH Melee weapons to Helix."

--[[
	FUNCTION: PLUGIN:PlayerSwitchWeapon( client, _, wep )
	DESCRIPTION: When the player switches to a weapon using the CW 2.0 base, it will set the
	weapon to be lowered if safe, or raised if anything else.
]]

function PLUGIN:PlayerSwitchWeapon( client, _, wep )
	local meleeBases = {}
	meleeBases["tfa_melee_base"] = true
	meleeBases["tfa_nmrimelee_base"] = true
	meleeBases["cw_melee_base"] = true

	if meleeBases[wep.Base] then
	    wep.IsAlwaysRaised = true
	end
end
