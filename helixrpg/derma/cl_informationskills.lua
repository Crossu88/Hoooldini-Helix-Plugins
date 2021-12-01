do
	hook.Add( "CreateCharacterInfoCategory", "SkillsCharacterInfo", function( PANEL )

		-- no need to update since we aren't showing the attributes panel
		local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (character) then
			PANEL.skills = PANEL:Add("ixCategoryPanel")
			PANEL.skills:SetText(L("skills"))
			PANEL.skills:Dock(TOP)
			PANEL.skills:DockMargin(0, 0, 0, 8)

			local boost = character:GetBoosts()
			local bFirst = true

			for k, v in SortedPairsByMemberValue(ix.skills.list, "name") do
				local skillBoost = 0

				if (boost[k]) then
					for _, bValue in pairs(boost[k]) do
						skillBoost = skillBoost + bValue
					end
				end

				local bar = PANEL.skills:Add("ixAttributeBar")
				bar:Dock(TOP)

				if (!bFirst) then
					bar:DockMargin(0, 3, 0, 0)
				else
					bFirst = false
				end

				local value = character:GetSkill(k, 0)

				if (skillBoost) then
					bar:SetValue(value - skillBoost or 0)
				else
					bar:SetValue(value)
				end

				local maximum = v.maxValue or ix.config.Get("maxSkills", 100)
				bar:SetMax(maximum)
				bar:SetReadOnly()
				bar:SetText(Format("%s [%.1f/%.1f] (%.1f%%)", L(v.name), value, maximum, value / maximum * 100))

				if (skillBoost) then
					bar:SetBoost(skillBoost)
				end
			end

			PANEL.skills:SizeToContents()
		end

	end)
end