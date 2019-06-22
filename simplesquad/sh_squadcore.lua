ix.squadsystem = ix.squadsystem or {}
ix.squadsystem.squads = ix.squadsystem.squads or {}

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

function ix.squadsystem.GiveEmptySquad(client)
	net.Start("SquadSync")
		net.WriteTable({})
	net.Send(client)
end

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

	ix.squadsystem.SyncSquad(squad)
end

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

function ix.squadsystem.LeaveSquad(client, character)
	character = character or client:GetCharacter()

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

			client:Notify("You have left "..squadName..'.')
		end
	else
		client:Notify("You are not a part of a squad.")
	end

	character:ClearSquadInfo()
end