local PLUGIN = PLUGIN

PLUGIN.name = "Ranks"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Ease of use for setting up ranks."

local rankTable = {
	Infantry = {
		{ fullRank = "Recruit", rank = "Rct." },
		{ fullRank = "Private", rank = "Pvt." },
		{ fullRank = "Private First Class", rank = "Pfc." },
		{ fullRank = "Lance Corporal", rank = "LCpl." },
		{ fullRank = "Corporal", rank = "Cpl." },
		{ fullRank = "Sergeant", rank = "Sgt." },
		{ fullRank = "Staff Sergeant", rank = "SSgt." },
		{ fullRank = "Sergeant First Class", rank = "Sfc." },
		{ fullRank = "Master Sergeant", rank = "MSgt." },
		{ fullRank = "Second Lieutenant", rank = "2Lt." },
		{ fullRank = "First Lieutenant", rank = "1Lt." },
		{ fullRank = "Captain", rank = "Cpt." },
		{ fullRank = "Major", rank = "Maj." },
		{ fullRank = "Lieutenant Colonel", rank = "LtCol." },
		{ fullRank = "Colonel", rank = "Col." }
	},
	Specialist = {
		{ fullRank = "Recruit", rank = "Rct." },
		{ fullRank = "Private", rank = "Pvt." },
		{ fullRank = "Private First Class", rank = "Pfc." },
		{ fullRank = "Specialist", rank = "Spc." },
		{ fullRank = "Senior Specialist", rank = "SSpc." },
		{ fullRank = "Master Specialist", rank = "MSpc." },
		{ fullRank = "Technical Sergeant", rank = "TSgt." }
	},
	Engineering = {
		{ fullRank = "Recruit", rank = "Rct." },
		{ fullRank = "Private", rank = "Pvt." },
		{ fullRank = "Private First Class", rank = "Pfc." },
		{ fullRank = "Specialist", rank = "Spc." },
		{ fullRank = "Senior Specialist", rank = "SSpc." },
		{ fullRank = "Master Specialist", rank = "MSpc." },
		{ fullRank = "Technical Sergeant", rank = "TSgt." }
	},
	Fleet = {
		{ fullRank = "Cadet", rank = "CDT." },
		{ fullRank = "Crewman", rank = "CM."},
		{ fullRank = "Crewman First Class", rank = "CFC."},
		{ fullRank = "Petty Officer Third Class", rank = "PO3."},
		{ fullRank = "Petty Officer Second Class", rank = "PO2."},
		{ fullRank = "Petty Officer First Class", rank = "PO1."},
		{ fullRank = "Chief Petty Officer", rank = "CPO."},
		{ fullRank = "Senior Chief Petty Officer", rank = "SCPO."},
		{ fullRank = "Master Chief Petty Officer", rank = "MCPO."},
		{ fullRank = "Second Lieutenant", rank = "2LT." },
		{ fullRank = "First Lieutenant", rank = "1LT." },
		{ fullRank = "Captain", rank = "CPT." },
		{ fullRank = "Major", rank = "MAJ." },
		{ fullRank = "Lieutenant Colonel", rank = "LTC." },
		{ fullRank = "Colonel", rank = "COL." }
	},
	Aerospace = {
		{ fullRank = "Cadet", rank = "CDT."},
		{ fullRank = "Junior Flight Officer", rank = "JFO."},
		{ fullRank = "Flight Officer Third Class", rank = "FO3."},
		{ fullRank = "Flight Officer Second Class", rank = "FO2."},
		{ fullRank = "Flight Officer First Class", rank = "FO1."},
		{ fullRank = "Chief Flight Officer", rank = "CFO."},
		{ fullRank = "Wing Commander", rank = "WCM."}

	},
	Medical = {
		{ fullRank = "Hospitalman Recruit", rank = "HR."},
		{ fullRank = "Hospitalman Apprentice", rank = "HA."},
		{ fullRank = "Hospitalman", rank = "HM."},
		{ fullRank = "Hospital Corpsman Third Class", rank = "HC3."},
		{ fullRank = "Hospital Corpsman Second Class", rank = "HC2."},
		{ fullRank = "Hospital Corpsman First Class", rank = "HC1."},
		{ fullRank = "Chief Hospital Corpsman", rank = "CHC."}
	},
}

local teamTable = {
	Infantry = FACTION_INFANTRY,
	Specialist = FACTION_INFANTRY,
	Engineering = FACTION_ENGINEERS,
	Fleet = FACTION_FLEET,
	Aerospace = FACTION_FLEET,
	Medical = FACTION_MEDICAL
} 

function PLUGIN:SetupRank(client, character)
	local faction = client:Team()
	if faction != FACTION_EVENT and faction != FACTION_OPFOR then // Doesn't set up the rank if the character is a part of these factions
		local name = character:GetName()

		name = string.gsub(name, "%w+%.%s", "") // Removes any rank set by player

		local rankinfo = {}

		if faction == FACTION_RECRUIT then
			character:SetName("Rct. "..name)

			rankinfo = {
				paygrade = 1,
				division = "Infantry",
				fullRank = "Recruit",
				rank = "Rct."
			}
		elseif faction == FACTION_INFANTRY then
			character:SetName("Pvt. "..name)

			rankinfo = {
				paygrade = 2,
				division = "Infantry",
				fullRank = "Private",
				rank = "Pvt."
			}
		else
			character:SetName("Cmn. "..name)

			rankinfo = {
				paygrade = 2,
				division = "Fleet",
				fullRank = "Crewman",
				rank = "Cmn."
			}
		end

		character:SetData("rankinfo", rankinfo)
	end
end

-- Called after the player's loadout has been set.
function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	if !character:GetData("rankinfo") then
		self:SetupRank(client, character)
	end
end

function PLUGIN:SetRank(character, newrank)
	local name = character:GetName()
	local rankinfo = character:GetData("rankinfo")
	local division = rankinfo.division
	local rankfound = false

	for k, v in pairs(rankTable[division]) do
		if v.fullRank == newrank or v.rank == newrank then
			rankinfo.paygrade = k
			rankinfo.rank = v.rank
			rankinfo.fullRank = v.fullRank

			rankfound = true

			name = string.gsub(name, "%w+%.", v.rank) // Replaces the old rank with the new one.

			character:SetName(name)

			character:GetPlayer():Notify("Your rank has been set to "..v.fullRank..'.', character:GetPlayer())
			break
		end
	end

	return rankfound
end

function PLUGIN:TransferDivision(character, newdivision)
	for k, _ in pairs(teamTable) do
		if ix.util.StringMatches(k, newdivision) then
			newdivision = k
		end
	end

	if !rankTable[newdivision] then return false end // If the division does not exist, return false.
	
	local name = character:GetName()
	local rankinfo = character:GetData("rankinfo")
	local paygrade = rankinfo.paygrade
	local ply = character:GetPlayer()

	if rankinfo.division != newdivision then
		rankinfo.division = newdivision

		if paygrade < #rankTable[newdivision] then // Checks to make sure rank with equal paygrade exists.
			rankinfo.rank = rankTable[newdivision][paygrade].rank
			rankinfo.fullRank = rankTable[newdivision][paygrade].fullRank
		else
			rankinfo.rank = rankTable[newdivision][#rankTable[newdivision]].rank
			rankinfo.fullRank = rankTable[newdivision][#rankTable[newdivision]].fullRank
		end

		if teamTable[newdivision] != character:GetPlayer():Team() then
			character:SetFaction(teamTable[newdivision])

			local faction = teamTable[newdivision]
		end

		ply:SetWhitelisted(teamTable[newdivision], true)

		name = string.gsub(name, "%w+%.", rankinfo.rank) // Replaces the old rank with the new one.

		character:SetName(name)

		character:SetData("rankinfo", rankinfo)

		character:GetPlayer():Notify("You have been transfered to "..newdivision..'.', character:GetPlayer())
	end

	return true
end

function PLUGIN:Promote(character)
	local name = character:GetName()
	local rankinfo = character:GetData("rankinfo")
	local newpaygrade = rankinfo.paygrade + 1 // Paygrade acts as key for the rank table.
	local ply = character:GetPlayer()

	if (newpaygrade) > #rankTable[rankinfo.division] then return false end // If no rank exists above the character's current rank, return false.

	local newrank = rankTable[rankinfo.division][rankinfo.paygrade + 1].rank
	local newfullRank = rankTable[rankinfo.division][rankinfo.paygrade + 1].fullRank // Acquires new rank information from the rank table.

	name = string.gsub(name, "%w+%.", newrank) // Replaces the old rank with the new one.

	character:SetName(name)

	if teamTable[rankinfo.division] != ply:Team() then // Moves recruits into the infantry faction and whitelists them to both infantry and fleet.
		character:SetFaction(teamTable[rankinfo.division])
		ply:SetWhitelisted(teamTable[rankinfo.division], true)
	end

	local newrankinfo = {
		paygrade = newpaygrade,
		division = rankinfo.division,
		fullRank = newfullRank,
		rank = newrank
	} // Sets up new rank info for character.

	character:SetData("rankinfo", newrankinfo)

	ply:Notify("Congratulations, you have been promoted to "..newfullRank..'.', ply)
	return true
end

function PLUGIN:Demote(character)
	local name = character:GetName()
	local rankinfo = character:GetData("rankinfo")
	local newpaygrade = rankinfo.paygrade - 1 // Paygrade acts as key for the rank table.

	if (newpaygrade) < 1 then return false end // If no rank exists below the character's current rank, return false.

	local newrank = rankTable[rankinfo.division][newpaygrade].rank
	local newfullRank = rankTable[rankinfo.division][newpaygrade].fullRank // Acquires new rank information from the rank table.

	name = string.gsub(name, "%w+%.", newrank) // Replaces the old rank with the new one.

	character:SetName(name)

	local newrankinfo = {
		paygrade = newpaygrade,
		division = rankinfo.division,
		fullRank = newfullRank,
		rank = newrank
	} // Sets up new rank info for character.

	character:SetData("rankinfo", newrankinfo)

	character:GetPlayer():Notify("You have been demoted to "..newfullRank..'.', character:GetPlayer()) // Notifies the target player.

	return true
end

ix.command.Add("CharSetDivision", {
	description = "Change a character's division.",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, text)
		if !PLUGIN:TransferDivision(target, text) then
			client:Notify("Can not transfer target to division.")
		end
	end
})

ix.command.Add("CharSetRank", {
	description = "Change a character's rank.",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, text)
		if !PLUGIN:SetRank(target, text) then
			client:Notify("Can not set target's rank to the one specified.")
		end
	end
})

ix.command.Add("CharDemote", {
	description = "Demote a character.",
	superAdminOnly = true,
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		if !PLUGIN:Demote(target) then
			client:Notify("Can not demote the target character.")
		end
	end
})

ix.command.Add("CharPromote", {
	description = "Promote a character.",
	superAdminOnly = true,
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		if !PLUGIN:Promote(target) then
			client:Notify("Can not promote the target character.")
		end
	end
})


ix.command.Add("CharResetRank", {
	description = "Resets a character's rank for debug purposes.",
	superAdminOnly = true,
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		PLUGIN:SetupRank(client, target)
	end
})

ix.command.Add("Whitelist", {
	description = "Sets whitelist.",
	superAdminOnly = true,
	OnRun = function(self, client)
		PLUGIN:SetupRank(client, target)
	end
})