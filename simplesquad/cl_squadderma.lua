local PANEL = {}

function PANEL:Init()
	local text = nil

	self:SetTitle(L("Create a squad"))
	self:SetSize(330, 100)
	self:Center()
	self:MakePopup()

	self.textentry = self:Add("DTextEntry")
	self.textentry:Dock(TOP)
	self.textentry:SetTall(25)
	self.textentry:DockMargin(0, 5, 0, 0)
	self.textentry.OnChange = function( self )
		 text = self:GetValue()
	end

	self.submit = self:Add("DButton")
	self.submit:Dock(BOTTOM)
	self.submit:DockMargin(0, 5, 0, 0)
	self.submit:SetTall(25)
	self.submit:SetText(L("Create"))
	self.submit.DoClick = function()
		local tab = {
			LocalPlayer(),
			text
		}
	
		if text then
			net.Start("CreateSquad")
				net.WriteTable(tab)
			net.SendToServer()

			self:Close()
		end
	end
end

function PANEL:Think()
	self:MoveToFront()
end

vgui.Register("ixSquadCreate", PANEL, "DFrame")

PANEL = {}

function PANEL:Init()
	local selected = nil

	self:SetTitle(L("Join a squad"))
	self:SetSize(220, 330)
	self:Center()
	self:MakePopup()

	self.submit = self:Add("DButton")
	self.submit:Dock(BOTTOM)
	self.submit:DockMargin(0, 5, 0, 0)
	self.submit:SetTall(25)
	self.submit:SetText(L("Join"))
	self.submit.DoClick = function()
		local tab = {
			LocalPlayer(),
			selected
		}
	
		if selected then
			net.Start("JoinSquad")
				net.WriteTable(tab)
			net.SendToServer()

			self:Close()
		end
	end

	self.squadlist = self:Add("DListView")
	self.squadlist:Dock(FILL)
	self.squadlist:DockMargin(0, 5, 0, 0)
	self.squadlist:SetTall(225)
	self.squadlist:AddColumn("Squad")

	for k, v in pairs(ix.squadsystem.squads) do
		self.squadlist:AddLine(k, "Squad")
	end

	self.squadlist.OnRowSelected = function( panel, rowIndex, row )
		selected = row:GetValue( 1 )
	end
end

function PANEL:Think()
	self:MoveToFront()
end

vgui.Register("ixSquadJoin", PANEL, "DFrame")

PANEL = {}

function PANEL:Init()
	local selected = {}
	local members = {}

	self:SetTitle(L("Manage Your Squad"))
	self:SetSize(220, 330)
	self:Center()
	self:MakePopup()

	self.kick = self:Add("DButton")
	self.kick:Dock(BOTTOM)
	self.kick:DockMargin(0, 5, 0, 0)
	self.kick:SetTall(25)
	self.kick:SetText(L("Kick"))
	self.kick.DoClick = function()
		if squad then
			net.Start("SquadKick")
				net.WriteTable(selected)
			net.SendToServer()

			self:Close()
		end
	end

	self.promote = self:Add("DButton")
	self.promote:Dock(BOTTOM)
	self.promote:DockMargin(0, 5, 0, 0)
	self.promote:SetTall(25)
	self.promote:SetText(L("Promote"))
	self.promote.DoClick = function()
		if squad then
			net.Start("SquadPromote")
				net.WriteTable(selected)
			net.SendToServer()

			self:Close()
		end
	end

	self.members = self:Add("DListView")
	self.members:Dock(FILL)
	self.members:DockMargin(0, 5, 0, 0)
	self.members:SetTall(225)
	self.members:AddColumn("Members")

	for k, v in pairs(squad) do
		members[v.member:Nick()] = v.member
	end

	for k, v in pairs(members) do
		self.members:AddLine(k, "Squad")
	end

	self.members.OnRowSelected = function( panel, rowIndex, row )
		selected[1] = members[row:GetValue( 1 )]
	end
end

function PANEL:Think()
	self:MoveToFront()
end

vgui.Register("ixSquadManage", PANEL, "DFrame")