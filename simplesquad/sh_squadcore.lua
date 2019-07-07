-- [[ GLOBAL VARIABLES ]] --

ix.squadsystem = ix.squadsystem or {}
ix.squadsystem.squads = ix.squadsystem.squads or {}

-- [[ FUNCTIONS ]] --

--[[ 
	FUNCTION: ix.squadsystem.SyncSquad(squad)
	DESCRIPTION: Syncs all members of the provided squad.
]]--

function ix.squadsystem.SyncSquad(squad)
	local squadTable = ix.squadsystem.squads[squad]

	if !(squadTable) or table.IsEmpty(ix.squadsystem.squads[squad]) then
		ix.squadsystem.squads[squad] = nil
	else
		for k, v in pairs(squadTable) do
			net.Start("SquadSync")
				net.WriteTable(squadTable)
			net.Send(v.member)
		end		
	end
end

--[[
	FUNCTION: ix.squadsystem.GiveEmptySquad(client)
	DESCRIPTION: Gives the client an empty squad. This is used
	to clear the version of the squad the client has so that
	they don't draw squad markers over anyone's head.
]]--

function ix.squadsystem.GiveEmptySquad(client)
	net.Start("SquadSync")
		net.WriteTable({})
	net.Send(client)
end

--[[
	FUNCTION: ix.squadsystem.SetSquadLeader(client)
	DESCRIPTION: Sets the designated user to be the squad
	leader of their squad.
]]--

function ix.squadsystem.SetSquadLeader(client)
	local char = client:GetCharacter()
	local squadName = char:GetSquad()
	local squad = ix.squadsystem.squads[squadName]

	if (squadName and squad) then
		for k, v in pairs(squad) do
			if v.member == client then
				local v1, v2 = squad[1], squad[k]

				ix.squadsystem.squads[squadName][1] = v2
				ix.squadsystem.squads[squadName][k] = v1

				client:Notify("You have been promoted to squad leader.")

				break
			end
		end
	end

	ix.squadsystem.SyncSquad(squadName)
end

--[[
	FUNCTION: ix.squadsystem.CreateSquad(client, squad)
	DESCRIPTION: Creates a squad with the designated name.
]]--

function ix.squadsystem.CreateSquad(client, squad)
	if !(ix.squadsystem.squads[squad]) then -- Prevents the creation of the squad if it already exists.
		ix.squadsystem.InitializeSquadInfo(client, squad)

		local tab = { -- player information that will be inserted into the squad table.
			member = client,
			color = client:GetCharacter():GetData("squadInfo").color
		}

		ix.squadsystem.squads[squad] = {tab}

		ix.squadsystem.SyncSquad(squad)

		client:Notify("You have created "..squad..'.')
	else
		client:Notify("Squad already exists.")
	end
end

--[[
	FUNCTION: ix.squadsystem.JoinSquad(client, squad)
	DESCRIPTION: Makes the designated client join the designated squad.
]]--

function ix.squadsystem.JoinSquad(client, squad) -- Replacing client with ply here to use client later.
	if (ix.squadsystem.squads[squad]) then -- Can only join a squad if it exists.
		ix.squadsystem.InitializeSquadInfo(client, squad)

		local tab = { -- player information that will be inserted into the squad table.
			member = client,
			color = client:GetCharacter():GetData("squadInfo").color
		}

		if ix.squadsystem.squads[squad] then
			table.insert(ix.squadsystem.squads[squad], tab)
		end

		ix.squadsystem.SyncSquad(squad)

		client:Notify("You have joined "..squad..'.')
	else
		client:Notify("Squad does not exist.")
	end
end

--[[
	FUNCTION: ix.squadsystem.InitializeSquadInfo(client, group)
	DESCRIPTION: Initializes a client's squad info and sets their squad
	to the provided squad.
]]--

function ix.squadsystem.InitializeSquadInfo(client, group) -- Squad is referred to as group here so that I can use the variable "squad" later in the function.
	local char = client:GetCharacter()
	local groupInfo = { -- Decided to keep it consistent here too by using group instead of squad.
		squad = group,
		color = Color(255, 255, 255) -- Default color is white.
	}

	if char:GetSquad() then
		ix.squadsystem.LeaveSquad(client)
	end

	char:SetData("squadInfo", groupInfo)
end

--[[
	FUNCTION: ix.squadsystem.LeaveSquad(client, character)
	DESCRIPTION: Makes the provided user leave their current
	squad.
]]--

function ix.squadsystem.LeaveSquad(client, character)
	local isKick = false

	if character then
		isKick = true
	else
		character = client:GetCharacter()
	end

	if character and character:GetSquad() then
		local squadName = character:GetSquad()
		local squad = ix.squadsystem.squads[squadName]

		ix.squadsystem.GiveEmptySquad(client)

		if squad then
			for k, v in pairs(squad) do
				if v.member == client then
					table.remove(ix.squadsystem.squads[squadName], k)
				end
			end

			ix.squadsystem.SyncSquad(squadName)

			if isKick then
				client:Notify("You have been removed from "..squadName..'.')
			else
				client:Notify("You have left "..squadName..'.')
			end
		end
	else
		client:Notify("You are not a part of a squad.")
	end

	character:ClearSquadInfo()
end