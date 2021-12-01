hook.Add("CreateCharacterInfo", "BackgroundCharacterInfo", function( PANEL )
	local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

	PANEL.background = PANEL:Add("ixListRow")
	PANEL.background:SetList(PANEL.list)
	PANEL.background:Dock(TOP)
end)

hook.Add("UpdateCharacterInfo", "UpdateBackgroundInfo", function( PANEL, character )
	PANEL.background:SetLabelText(L("background"))
	PANEL.background:SetText(L(character:GetBackground()))
	PANEL.background:SizeToContents()
end)