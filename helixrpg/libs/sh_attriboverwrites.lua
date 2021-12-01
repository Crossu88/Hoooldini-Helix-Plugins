do
	-- attribute manipulation should be done with methods from the ix.attributes library
	ix.char.RegisterVar("attributes", {
		field = "attributes",
		fieldType = ix.type.text,
		default = {},
		index = 4,
		category = "attributes",
		isLocal = true,
		OnDisplay = function(self, container, payload)
			local totalPoints = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or 10
			local maxPoints = hook.Run("GetMaximumAttributePoints", LocalPlayer(), payload) or 10

			if (totalPoints < 1) then
				return
			end

			local attributes = container:Add("DPanel")
			attributes:Dock(TOP)

			local y
			local total = 0

			payload.attributes = {}

			-- total spendable attribute points
			local totalBar = attributes:Add("ixAttributeBar")
			totalBar:SetMax(totalPoints)
			totalBar:SetValue(totalPoints)
			totalBar:Dock(TOP)
			totalBar:DockMargin(2, 2, 2, 2)
			totalBar:SetText(L("attribPointsLeft"))
			totalBar:SetReadOnly(true)
			totalBar:SetColor(Color(20, 120, 20, 255))

			y = totalBar:GetTall() + 4

			for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
				payload.attributes[k] = 0

				local bar = attributes:Add("ixAttributeBar")
				bar:SetMax(maxPoints)
				bar:Dock(TOP)
				bar:DockMargin(2, 2, 2, 2)
				bar:SetText(L(v.name))
				bar.OnChanged = function(this, difference)
					if ((total + difference) > totalPoints) then
						return false
					end

					total = total + difference
					payload.attributes[k] = payload.attributes[k] + difference

					totalBar:SetValue(totalBar.value - difference)
				end

				if (v.noStartBonus) then
					bar:SetReadOnly()
				end

				y = y + bar:GetTall() + 4
			end

			attributes:SetTall(y)
			return attributes
		end,
		OnValidate = function(self, value, data, client)
			if (value != nil) then
				if (istable(value)) then
					local count = 0

					for _, v in pairs(value) do
						count = count + v
					end

					if (count > (hook.Run("GetDefaultAttributePoints", client, count) or 10)) then
						return false, "unknownError"
					end
				else
					return false, "unknownError"
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			return !table.IsEmpty(ix.attributes.list)
		end
	})
end