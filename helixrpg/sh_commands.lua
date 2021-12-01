-- [[ COMMANDS ]] --

--[[
	COMMAND: /Roll
	DESCRIPTION: Allows the player to roll an arbitrary amount of dice and apply bonuses as needed.
]]--

ix.command.Add("Roll", {
	syntax = "<dice roll>",
	description = "Calculates a dice roll (e.g. 2d6 + 2) and shows the result.",
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, rolltext)
		result, rolltext = ix.dice.Roll( rolltext, client )

		ix.chat.Send( client, "rollgeneric", tostring( result ), nil, nil,{
			roll = "( "..rolltext.." )"
		} )
	end
})

--[[
	COMMAND: /RollStat
	DESCRIPTION: Rolls a d20 and applies modifiers to the dice roll for the stat provided.
]]--

ix.command.Add("RollStat", {
	syntax = "<stat>",
	description = "Rolls and adds a bonus for the stat provided.",
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, stat)
		local character = client:GetCharacter()
		local statname
		local bonus = 0

		for k, v in pairs(ix.attributes.list) do
			if ix.util.StringMatches(k, stat) or ix.util.StringMatches(v.name, stat) then
				stat = k
				statname = v.name
				bonus = character:GetAttribute(stat, 0)
			end
		end

		if not (statname) then
			for k, v in pairs(ix.skills.list) do
				if ix.util.StringMatches(k, stat) or ix.util.StringMatches(v.name, stat) then
					stat = k
					statname = v.name
					bonus = character:GetSkill(stat, 0)
				end
			end
		end

		if not statname then client:Notify( "Provided stat is invalid." ) return end

		if (character and character:GetAttribute(stat, 0)) then
			local roll = tostring(math.random(1, 20))

			ix.chat.Send(client, "roll20", (roll + bonus).." ( "..roll.." + "..bonus.." )", nil, nil, {
				rolltype = statname
			})
		end
	end
})

--[[
	COMMAND: /RollAttack
	DESCRIPTION: Automatically makes an attack roll based on the weapon that the player is holding.
]]--

ix.command.Add("RollAttack", {
	syntax = nil,
	description = "Makes an attack roll and adds any modifiers.",
	arguments = nil,
	OnRun = function(self, client, stat)
		local critcolor = Color( 255, 30, 30 )
		local character = client:GetCharacter()
		local weapon = client:GetActiveWeapon()
		local statTable = weapon.ixItem.HRPGStats or weapon.HRPGStats

		if (character and statTable) then
			local bonus = character:GetAttribute( statTable.mainAttribute, 0 )
			local roll = math.random(1, 20)
			local dmg = calcDice( statTable.rollDamage )

			local chatdata = {
				damage = dmg,
				color = nil
			}

			if ( roll == 20 ) then 
				chatdata.damage = dmg * 2
				chatdata.color = critcolor 
			end

			ix.chat.Send(client, "roll20attack", (roll + bonus).." ( "..roll.." + "..bonus.." )", nil, nil, chatdata)
		end
	end
})

ix.command.Add("GetSkill", {
	syntax = "<skill>",
	description = "Gets a skill.",
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, skill)
		--[[for k, v in pairs( ix.skills.list ) do
			print(k)
			print(v)
		end]]
		char = client:GetCharacter()

		skilltab = char:GetAttributes()

		if ( table.IsEmpty(skilltab) ) then
			print( "Skill table is empty")
		else
			for k, v in pairs( skilltab ) do 
				print(k)
				print(v)
			end
		end
	end
})

if SERVER then
	util.AddNetworkString( "ixTestDerma" )
else
	net.Receive( "ixTestDerma", function()
		local frame = vgui.Create( "DFrame" )
		frame:SetPos( 500, 500 )
		frame:SetSize( 200, 300 )
		frame:SetTitle( "Frame" )
		frame:MakePopup()
		 
		local grid = vgui.Create( "DGrid", frame )
		grid:SetPos( 10, 30 )
		grid:SetCols( 5 )
		grid:SetColWide( 36 )
		 
		for i = 1, 30 do
			local but = vgui.Create( "DButton" )
			but:SetText( i )
			but:SetSize( 30, 20 )
			grid:AddItem( but )
		end
	end)
end

ix.command.Add("DermaTest", {
	syntax = "",
	description = "Tests Derma",
	OnRun = function(self, client, skill)
		net.Start( "ixTestDerma" )
		net.Send(client)
	end
})
