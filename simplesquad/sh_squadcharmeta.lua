local CHARMETA = ix.meta.character or {}

-- [[ FUNCTIONS ]] --

--[[ 
	FUNCTION: CHARMETA:GetSquad()
	DESCRIPTION: Returns the character's current squad or nil
]]--

function CHARMETA:GetSquad()
	local squadInfo = self:GetData("squadInfo")
	local squad = nil

	if squadInfo then
		squad = squadInfo.squad
	end
	
	return squad
end

--[[ 
	FUNCTION:CHARMETA:ClearSquadInfo()
	DESCRIPTION: Clears a character's squad info.
]]--

function CHARMETA:ClearSquadInfo()
	self:SetData("squadInfo", nil)
end

--[[ 
	FUNCTION: CHARMETA:SetSquadColor(color)
	DESCRIPTION: Sets the squad color of a character, which appears to other players.
]]--

function CHARMETA:SetSquadColor(color)
	local squadInfo = self:GetData("squadInfo", nil)
	local client = self:GetPlayer()
	local colorTable = {
		red = Color(255, 100, 100),
		green = Color(100, 255, 100),
		blue = Color(150, 150, 255),
		yellow = Color(255, 255, 100),
		white = Color(255, 255, 255),
	}

	if (colorTable[color]) then
		squadInfo.color = colorTable[color]

		self:SetData("squadInfo", squadInfo)

		for _, v in pairs(ix.squadsystem.squads[squadInfo.squad]) do
			if v.member == client then
				v.color = colorTable[color]
			end
		end

		client:Notify("You have set your color to "..color..'.')
	else
		client:Notify("Invalid color.")
	end

	ix.squadsystem.SyncSquad(squadInfo.squad)
end

--[[ 
	FUNCTION: CHARMETA:SetSquadColor(color)
	DESCRIPTION: Sets the squad color of a character, which appears to other players.
]]--

function CHARMETA:SetSquadIcon(icon)
	local squadInfo = self:GetData("squadInfo", nil)
	local client = self:GetPlayer()

	self:SetData("squadInfo", squadInfo)

	for _, v in pairs(ix.squadsystem.squads[squadInfo.squad]) do
		if v.member == client then
			v.icon = icon
		end
	end

	client:Notify("You have changed your icon.")

	ix.squadsystem.SyncSquad(squadInfo.squad)
end