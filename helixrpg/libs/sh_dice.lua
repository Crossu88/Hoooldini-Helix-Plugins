
-- @module ix.dice

ix.dice = ix.dice or {}

function ix.dice.CalcDice( dicetext )

	local result = 0

	if string.find( dicetext, "d" ) then

		local rtab = {}

		for i in string.gmatch( dicetext, "[%d]+" ) do
			table.insert( rtab, tonumber( i ) )
		end

		for x = 1, rtab[1] do
			result = result + math.random( 1, rtab[2] )
		end

		if ( dicetext[1] == '-' ) then result = result * -1 end

	else

		result = result + tonumber( dicetext )

	end


	return result

end

function ix.dice.Roll( rolltext, client )
	rolltext = rolltext or ""
	local newtext = rolltext
	local result = 0

	rolltext = string.gsub( rolltext, " ", "" )

	if ( rolltext[1] != '-' and rolltext[1] != '+' ) then
		rolltext = '+'..rolltext
	end

	local parsepatterns = {
		"%+[%d]+d[%d]+",
		"%-[%d]+d[%d]+",
		"%+[%d]+",
		"%-[%d]+"
	}

	for _, v in pairs( parsepatterns ) do
		for i in string.gmatch( rolltext, v ) do
			result = result + ix.dice.CalcDice( i )
			rolltext = string.gsub( rolltext, i, "" )
		end
	end

	local stat, statname = "", ""
	local character = client:GetCharacter()

	for i in string.gmatch( rolltext, "[%a]+" ) do
		for k, v in pairs(ix.attributes.list) do
			if ix.util.StringMatches(k, i) or ix.util.StringMatches(v.name, i) then
				result = result + character:GetAttribute(k)
				newtext = string.gsub( newtext, i, v.name )
				break
			end
		end

		for k, v in pairs(ix.skills.list) do
			if ix.util.StringMatches(k, i) or ix.util.StringMatches(v.name, i) then
				result = result + character:GetSkill(k)
				newtext = string.gsub( newtext, i, v.name )
				break
			end
		end
	end

	return result, newtext

end

-- [[ LOCAL FUNCTIONS ]] --

--[[
	FUNCTION: rollDice
	DESCRIPTION: A helper function that calculates pieces of a dice roll string. Handles both dice and bonuses.
]]--

local function rollDice( dicetext )

	local result = 0

	if string.find( dicetext, "d" ) then

		local rtab = {}

		for i in string.gmatch( dicetext, "[%d]+" ) do
			table.insert( rtab, tonumber( i ) )
		end

		for x = 1, rtab[1] do
			result = result + math.random( 1, rtab[2] )
		end

		if ( dicetext[1] == '-' ) then result = result * -1 end

	else

		result = result + tonumber( dicetext )

	end


	return result

end

--[[
	FUNCTION: calcDice
	DESCRIPTION: A helper function that takes a dice roll string (e.g. 2d8 + 4) and calculates a result.
]]--

local function calcDice( rolltext )

	rolltext = rolltext or ""
	local result = 0

	rolltext = string.gsub( rolltext, " ", "" )

	if ( rolltext[1] != '-' and rolltext[1] != '+' ) then
		rolltext = '+'..rolltext
	end

	local parsepatterns = {
		"%+[%d]+d[%d]+",
		"%-[%d]+d[%d]+",
		"%+[%d]+",
		"%-[%d]+"
	}

	for _, v in pairs( parsepatterns ) do
		for i in string.gmatch( rolltext, v ) do
			result = result + rollDice( i )
			rolltext = string.gsub( rolltext, i, "" )
		end
	end

	return result

end