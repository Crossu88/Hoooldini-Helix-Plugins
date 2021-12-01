--[[-- main scoreboard panel
local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.scoreboard)) then
		ix.gui.scoreboard:Remove()
	end

	self:Dock(FILL)

	self.factions = {}
	self.nextThink = 0

	for i = 1, #ix.faction.indices do
		local faction = ix.faction.indices[i]

		local panel = self:Add("ixScoreboardFaction")
		panel:SetFaction(faction)
		panel:Dock(TOP)

		self.factions[i] = panel
	end

	ix.gui.scoreboard = self
end

function PANEL:Think()
	if (CurTime() >= self.nextThink) then
		for i = 1, #self.factions do
			local factionPanel = self.factions[i]

			factionPanel:Update()
		end

		self.nextThink = CurTime() + 0.5
	end
end

vgui.Register("ixScoreboard", PANEL, "DScrollPanel")

hook.Add("CreateMenuButtons", "ixScoreboard", function(tabs)
	tabs["character sheet"] = function(container)
		container:Add("ixScoreboard")
	end
end)]]--