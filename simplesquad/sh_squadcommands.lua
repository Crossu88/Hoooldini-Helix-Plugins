ix.command.Add("printsquads", {
	syntax = "<none>",
	description = "Prints the squads.",
	OnRun = function(self, client)
		for k, v in pairs(ix.squadsystem.squads) do
			print(k.." = {")
			for i, j in pairs(v) do
				print("     "..i.." = "..util.TypeToString(j.member)..", "..util.TypeToString(j.color))
			end
			print('}')
		end
	end
})

ix.command.Add("printsquads", {
	syntax = "<none>",
	description = "Prints the squads.",
	OnRun = function(self, client)
		for k, v in pairs(ix.squadsystem.squads) do
			print(k.." = {")
			for i, j in pairs(v) do
				print("     "..i.." = "..util.TypeToString(j.member)..", "..util.TypeToString(j.color))
			end
			print('}')
		end
	end
})

ix.command.Add("clearsquadinfo", {
	syntax = "<player>",
	description = "Clears squad info of target.",
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		target:ClearSquadInfo()
	end
})

ix.command.Add("printsquadinfo", {
	syntax = "<player>",
	description = "prints squad info of target.",
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		local squadInfo = target:GetData("squadInfo")

		print(squadInfo)
		print(type(squadInfo))

		if squadInfo then
			print(squadInfo.squad)
			print(squadInfo.color)
		else
			print("no squad info")
		end
	end
})

ix.command.Add("syncallsquads", {
	syntax = "<none>",
	description = "Resyncs all squads.",
	OnRun = function(self, client)
		for k, _ in pairs(ix.squadsystem.squads) do
			ix.squadsystem.SyncSquad(k)
		end
	end
})