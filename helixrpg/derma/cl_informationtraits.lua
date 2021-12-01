do
	hook.Add( "CreateCharacterInfoCategory", "TraitsCharacterInfo", function( PANEL )

		-- no need to update since we aren't showing the attributes panel
		local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (character) then
			PANEL.traits = PANEL:Add("ixCategoryPanel")
			PANEL.traits:SetText("Traits")
			PANEL.traits:Dock(TOP)
			PANEL.traits:DockMargin(0, 0, 0, 8)

			PANEL.tile = PANEL.traits:Add("DIconLayout")
			PANEL.tile:Dock( TOP )
			PANEL.tile:SetSpaceY( 2 )
			PANEL.tile:SetSpaceX( 2 )

			local traitTable = character:GetTraits()

			--PrintTable( traitTable )

			local traitCount, rowCount, tileSize = 0, 0, 0

			tileSize = ( PANEL:GetWide() - 16 ) / 8

			for k, _ in SortedPairs(traitTable) do
				local traitData = ix.traits.list[k]

				local ListItem = PANEL.tile:Add( "ixTraitIcon" )
				ListItem:SetSize( tileSize, tileSize )
				ListItem:SetImage( traitData.icon or "icon16/bomb.png")
				ListItem:SetActivated(true)
				ListItem:SetSelectable(false)
				ListItem:SetHelixTooltip(function(tooltip)
					local title = tooltip:AddRow("name")
					title:SetImportant()
					title:SetText(traitData.name)
					title:SizeToContents()
					title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

					local description = tooltip:AddRow("description")
					description:SetText(traitData.description)
					description:SizeToContents()
				end)

				traitCount = traitCount + 1
			end

			--[[for i=1, 3 do 
				for k, v in SortedPairsByMemberValue(ix.traits.list, "name") do -- Make a loop to create a bunch of panels inside of the DIconLayout
					local ListItem = PANEL.tile:Add( "ixTraitIcon" ) -- Add DPanel to the DIconLayout
					ListItem:SetSize( tileSize, tileSize ) -- Set the size of it
					ListItem:SetImage( v.icon or "icon16/bomb.png")
					ListItem:SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(v.name)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(v.description)
						description:SizeToContents()
					end)
					-- You don't need to set the position, that is done automatically.
					traitCount = traitCount + 1
				end
			end]]--

			rowCount = math.ceil( traitCount / 8 )

			PANEL.tile:SetTall( ( 2 * ( rowCount - 1 ) ) + ( rowCount * tileSize ) )

			PANEL.traits:SizeToContents()
		end

	end)
end