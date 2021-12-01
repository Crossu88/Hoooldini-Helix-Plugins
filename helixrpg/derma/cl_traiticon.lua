local PANEL = {}

PANEL.Activated = false
PANEL.Selectable = true
PANEL.InactiveColor = Color(155, 155, 155, 155)
PANEL.ActiveColor = Color(255, 255, 255, 255)
PANEL.UnselectableColor = Color(75, 75, 75, 155)

function PANEL:Init()
	self:SetColor( self.UnselectableColor )
end

function PANEL:SetActivated( state )
	self.Activated = state

	if ( state ) then
		self:SetColor( self.ActiveColor )
		self:OnActivated()
	else
		self:SetColor( self.InactiveColor )
		self:OnDeactivated()
	end
end

function PANEL:GetActivated()
	return self.Activated
end

function PANEL:SetSelectable( state )
	self.Selectable = state

	if ( !self.Activated ) then 
		if ( !state ) then
			self:SetColor( self.UnselectableColor )
		else
			self:SetColor( self.InactiveColor )
		end
	end
end

function PANEL:GetSelectable()
	return self.Selectable
end

function PANEL:OnCursorEntered()
	if ( !self.Activated and self.Selectable ) then
		surface.PlaySound( "helix/ui/rollover.wav" )
		self:SetColor( self.ActiveColor )
	end
end

function PANEL:OnCursorExited()
	if ( !self.Activated and self.Selectable ) then
		self:SetColor( self.InactiveColor )
	end
end

function PANEL:DoClick()
	if ( self.Selectable ) then
		surface.PlaySound( "helix/ui/press.wav" )
		self:SetActivated( !self.Activated )
	end

	self:OnClick()
end

function PANEL:OnActivated()

end

function PANEL:OnDeactivated()

end

function PANEL:OnClick()

end

vgui.Register("ixTraitIcon", PANEL, "DImageButton")