ITEM.name = "Attachment Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A holographic sight."
ITEM.category = "Attachments"
ITEM.attCategory = "Sight"
ITEM.attClass = "md_eotech"
ITEM.requiredAtt = nil

ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (inventory.vars and inventory.vars.isGun) then
			local hostItem = inventory.vars.item
			local activeAtt = hostItem:GetData("activeAtt", {})
			local hostWeapon = hostItem:GetData("weapon")

			if (hostItem and hostWeapon) then
				hostWeapon:detachSpecificAttachment(self.attClass)
				table.RemoveByValue(activeAtt, self.attClass)
			else
				table.RemoveByValue(activeAtt, self.attClass)
			end		
	end
end)

function ITEM:OnTransferred( oldInv, newInv )
	if (self and self:GetOwner()) then
		local owner = self:GetOwner()
		local activeWep = owner:GetActiveWeapon()
		local hostItem, hostWeapon, activeAtt

		if (newInv.vars and newInv.vars.isGun) then
			hostItem = newInv.vars.item
			activeAtt = hostItem:GetData("activeAtt", {})
			local hostWeapon = hostItem:GetData("weapon")

			if (hostItem and hostWeapon) then
				hostWeapon:attachSpecificAttachment(self.attClass)
				table.insert(activeAtt, self.attClass)
			else
				table.insert(activeAtt, self.attClass)
			end	
		end

		if (oldInv.vars and oldInv.vars.isGun) then
			hostItem = oldInv.vars.item
			activeAtt = hostItem:GetData("activeAtt", {})
			local hostWeapon = hostItem:GetData("weapon")

			if (hostItem and hostWeapon) then
				hostWeapon:detachSpecificAttachment(self.attClass)
				table.RemoveByValue(activeAtt, self.attClass)
			else
				table.RemoveByValue(activeAtt, self.attClass)
			end	
		end

		if hostItem then
			hostItem:SetData("activeAtt", activeAtt)
		end
	end
end