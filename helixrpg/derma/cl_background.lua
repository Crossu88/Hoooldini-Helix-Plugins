--[[do
	hook.Add( "OnCharacterMenuCreated", "AddBackgroundStep", function( PANEL ) 

		local padding = ScreenScale(32)

		local charpanel = PANEL.newCharacterPanel

		local parent = PANEL:GetParent()
		local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
		local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
		local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

		charpanel.background = charpanel:AddSubpanel("background")
		charpanel.background:SetTitle("Background")

		local backgroundModelList = charpanel.background:Add("Panel")
		backgroundModelList:Dock(LEFT)
		backgroundModelList:SetSize(halfWidth, halfHeight)

		local backgroundBack = backgroundModelList:Add("ixMenuButton")
		backgroundBack:SetText("return")
		backgroundBack:SetContentAlignment(4)
		backgroundBack:SizeToContents()
		backgroundBack:Dock(BOTTOM)
		backgroundBack.DoClick = function()
			charpanel.progress:DecrementProgress()
			charpanel:SetActiveSubpanel("attributes")
		end

		charpanel.backgroundModel = backgroundModelList:Add("ixModelPanel")
		charpanel.backgroundModel:Dock(FILL)
		charpanel.backgroundModel:SetModel(charpanel.factionModel:GetModel())
		charpanel.backgroundModel:SetFOV(modelFOV - 13)
		charpanel.backgroundModel.PaintModel = charpanel.backgroundModel.Paint

		charpanel.backgroundPanel = charpanel.background:Add("Panel")
		charpanel.backgroundPanel:SetWide(halfWidth + padding * 2)
		charpanel.backgroundPanel:Dock(RIGHT)

	end)
end]]--