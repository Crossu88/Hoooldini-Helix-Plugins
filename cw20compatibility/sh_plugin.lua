PLUGIN.name = "CW 2.0 Compatibility"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds compatibility for Customizable Weaponry 2.0 to Helix."

-- [[ INCLUDES ]] --

ix.util.Include("sh_cwmeta.lua")

--[[ FUNCTIONS ]]--

if (SERVER) then

	--[[
		FUNCTION: PLUGIN:KeyPress( client, key )
		DESCRIPTION: This detects whether or not the client is switching firemodes. If the firemode
		is set to safe, the weapon is considered lowered in the script.
	]]

	function PLUGIN:KeyPress( client, key )
		if CustomizableWeaponry then 
			local wep = client:GetActiveWeapon()

			if (client:KeyDown(IN_USE) and client:KeyDown(IN_RELOAD)) and wep.Base == "cw_base" then
				timer.Simple( 0.05, function() 
					if wep.FireMode == "safe" then
						client:SetWepRaised(false, weapon)
					else
						client:SetWepRaised(true, weapon)
					end
				end )
			end
		end
	end

	--[[
		FUNCTION: PLUGIN:PlayerSwitchWeapon( client, _, wep )
		DESCRIPTION: When the player switches to a weapon using the CW 2.0 base, it will set the
		weapon to be lowered if safe, or raised if anything else.
	]]

	function PLUGIN:PlayerSwitchWeapon( client, _, wep )
		if CustomizableWeaponry then 
			if wep.Base == "cw_base" then
				timer.Simple( 0.05, function() 
					if wep.FireMode == "safe" then
						client:SetWepRaised(false, weapon)
					else
						client:SetWepRaised(true, weapon)
					end
				end )

				timer.Simple( 0.3, function()
					wep.CanCustomize = false
				end)
			end
		end
	end

	--[[
		FUNCTION: PLUGIN:CanTransferItem( item, oldInv, newInv )
		DESCRIPTION: This is used to make sure that only attachments can be put into weapon inventories.
		Then is also makes sure that there are no categories taking the same slot as any other attached attachments,
		and makes sure it is also possible to attach the attachment before allowing to be transfered.
	]]

	function PLUGIN:CanTransferItem( item, oldInv, newInv )
		if (newInv.vars and newInv.vars.isGun) then
			if item.attClass then
				local items = newInv:GetItems()
				local hostItem = newInv.vars.item
				local weapon = hostItem:GetData("weapon", nil)

				if !(weapon and weapon:canAttachSpecificAttachment(item.attClass)) then
					return false
				end

				for _, v in pairs(items) do
					if (v.id != self.id) then
						local itemTable = ix.item.instances[v.id]

						if (!itemTable) then
							client:NotifyLocalized("tellAdmin", "wid!xt")

							return false
						else
							if ( itemTable.attCategory == item.attCategory ) then
								return false
							end
						end
					end
				end
				return true
			end
		end
	end
end