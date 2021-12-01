local PANEL = {}

function PANEL:Init()
	self.TraitList = {}
	self.TraitCount = 0
	self.Columns = 8
	self.Updated = false
	self.ResizeParent = true

	self:Dock(FILL)
	self.Updated = false
end

function PANEL:Think()
	if not self.Updated then self:FormatToContents() end
end

function PANEL:Clear()
	for k, v in pairs( self.TraitList ) do
		v:Remove()
		self.TraitList[k] = nil
	end
end

function PANEL:SizeToParent()
	local parent = self:GetParent()
	local w, h = parent:GetSize()
	local ml, mu, mr, md = self:GetDockMargin()
	local marginX, marginY = ml + mr, mu + md

	w, h = w - marginX, h - marginY

	self:SetSize( w, h )
end

function PANEL:SizeParentY( height )
	if not self.ResizeParent then return end

	local parent = self:GetParent()
	local _, mu, _, md = self:GetDockMargin()
	local marginY = mu+ md

	if parent:GetTall() < height then
		parent:SetTall( height + marginY )
	end
end

function PANEL:FormatToContents()
	local traitCount = table.Count( self.TraitList )
	local rowCount = math.ceil( traitCount / self.Columns )
	local gapX, gapY = 0, 0
	local w, h = self:GetSize()
	local tileSize = math.floor(( w - gapX ) / self.Columns)
	local panelHeight = ( rowCount * tileSize ) + gapY

	self:SizeToParent()

	for k, v in pairs( self.TraitList ) do
		v:SetSize( tileSize, tileSize )
	end

	self:SizeParentY( panelHeight )

	self.Updated = true
end

function PANEL:AddTrait( data, bActive, bSelectable )
	bActive = bActive or false
	bSelectable = bSelectable or false

	self.TraitList[data.name] = self:Add( "ixTraitIcon" )
	self.TraitList[data.name]:SetImage( data.icon or "icon16/bomb.png" )
	self.TraitList[data.name]:SetActivated( bActive )
	self.TraitList[data.name]:SetSelectable( bSelectable )

	self.TraitList[data.name]:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(data.name)
		title:SizeToContents()
		title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

		local description = tooltip:AddRow("description")
		description:SetText(data.description)
		description:SizeToContents()
	end)

	self.TraitCount = self.TraitCount + 1

	self.Updated = false

	return self.TraitList[data.name]
end

function PANEL:AllowParentResize( state )
	self.ResizeParent = state
end

function PANEL:SetColumns( columns )
	self.Columns = columns
	self.Updated = false
end

function PANEL:GetColumns( columns )
	return self.Columns
end

function PANEL:GetTraitList()
	return self.TraitList
end

vgui.Register( "ixTraitList", PANEL, "DIconLayout" )