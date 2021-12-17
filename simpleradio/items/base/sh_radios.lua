ITEM.name = "Radio"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.isRadio = true
ITEM.defaultFreq = "main" -- The default frequency the player will be set to
ITEM.freqList = { -- Radios can only support one main channel, and two additional channels.
	"main",
	"command",
	"support"
}

-- [[ ITEM FUNCTIONS & HOOKS ]] --

--[[
	FUNCTION: Toggle
	DESCRIPTION: Toggles power of the radio and sets up the RadioInfo of the player.
]]--

ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle Power",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		local status = item:GetData("equip", false)
		local char = item.player:GetCharacter()

		item.player:EmitSound("buttons/button14.wav", 70, 150)

		if status then -- Checks to see if the radio is on.
			char:SetData("RadioInfo", nil) -- Removes RadioInfo from the player's data
			item:SetData("equip", false)
		else
			local radioInfo = { -- Sets up RadioInfo for player's data
				lastFreq = item.defaultFreq,
				freqList = item.freqList
			}

			char:SetData("RadioInfo", radioInfo)
			item:SetData("equip", true)
		end

		return false
	end,
	OnCanRun = function(item) -- Everything under here just makes sure we aren't requipping two radios.
		local items = item.player:GetCharacter():GetInventory():GetItems()
		local char = item.player:GetCharacter()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (!itemTable) then
					char:NotifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if (itemTable.isRadio and itemTable:GetData("equip")) then
						char:Notify("You can not equip more than one radio at a time.")

						return false
					end
				end
			end
		end
	end
}

-- [[ FUNCTIONS ]] --

--[[
	FUNCTION: ITEM:PaintOver(item, w, h)
	DESCRIPTION: Paints a square on the bottom right of the inventory icon.
	Code is identical to ZeMysticalTaco's radio plugin.
]]

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if item:GetData("equip", false) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end
end

