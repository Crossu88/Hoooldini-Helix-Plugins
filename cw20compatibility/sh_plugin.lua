PLUGIN.name = "CW 2.0 Compatibility"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds compatibility for Customizable Weaponry 2.0 to Helix."

-- [[ INCLUDES ]] --

ix.util.Include("sh_cwmeta.lua")

if (SERVER) then

	util.AddNetworkString("attSound")

	--[[ FUNCTIONS ]]--

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
						client:SetWepRaised( false, weapon )
					else
						client:SetWepRaised( true, weapon )
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
				local owner
				local items = newInv:GetItems()
				local hostItem = newInv.vars.item
				local weapon = hostItem:GetData("weapon", nil)
				local activeAtts = hostItem:GetData("activeAtt", {})
				local returnval = true

				if (isfunction(newInv.GetOwner)) then
					owner = newInv:GetOwner()
				end

				if not weapon then
					owner:Give( hostItem.class, true )
					weapon = owner:GetWeapon( hostItem.class )

					if table.IsEmpty( activeAtts ) then
						for k, v in pairs( activeAtts ) do
							weapon:attachSpecificAttachment( hostItem.class )
						end
					end

					local canAttach = weapon:canAttachSpecificAttachment( item.attClass )

					if !canAttach then 
						returnval = false
					else
						net.Start("attSound")
							net.WriteString("cw/attach.wav")
						net.Send(owner)
					end
					
					owner:StripWeapon( hostItem.class )
				else
					local canAttach = weapon:canAttachSpecificAttachment( item.attClass )

					if !canAttach then returnval = false end
				end

				for _, v in pairs(items) do
					if (v.id != self.id) then
						local itemTable = ix.item.instances[v.id]

						if (!itemTable) then
							client:NotifyLocalized("tellAdmin", "wid!xt")

							returnval = false
						else
							if ( itemTable.attCategory == item.attCategory ) then
								returnval = false
							end
						end
					end
				end
				return returnval
			end
		end
		
		if (oldInv.vars and oldInv.vars.isGun) then
			local owner
			local hostItem = oldInv.vars.item
			local weapon = hostItem:GetData("weapon", nil)

			if (isfunction(oldInv.GetOwner)) then
				owner = newInv:GetOwner()
			end

			if weapon == nil then
				net.Start("attSound")
					net.WriteString("cw/detach.wav")
				net.Send(owner)
			end

			return true
		end
	end

else
	net.Receive("attSound", function( len, pl )
		local soundstr = net.ReadString()
		surface.PlaySound( soundstr )
	end)
end