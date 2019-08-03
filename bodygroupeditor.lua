PLUGIN.name = "Body Group Editor"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds integration to for the bodygroup editor addon into helix and saves bodygroups by model."

-- [[ CONFIGURATION OPTIONS ]] --

ix.config.Add("enableFlag", true, "Whether or not the b flag is required for use.", nil, {
	category = "Body Group Editor"
})

-- [[ FLAGS ]] --

ix.flag.Add("b", "Access to the bodygroup editor.")

-- [[ FUNCTIONS ]] --

--[[
	FUNCTION: PLUGIN:CanUseBodyGroupEditor( client )
	DESCRIPTION: Determines whether or not the client can access the bodygroup editor.
]]--

function PLUGIN:CanUseBodyGroupEditor( client )
	char = client:GetCharacter()

	if ( ix.config.Get("enableFlag") and !char:HasFlags("b") ) then return false end
end

--[[
	FUNCTION: PLUGIN:EditPlayerBodyGroups( id, val, client )
	DESCRIPTION: Called when the player edits their bodygroups through the bodygroup editor.
]]--

function PLUGIN:EditPlayerBodyGroups( id, val, client )
	local mdl = client:GetModel()
	local char = client:GetCharacter()
	local grouptable = char:GetData( "bodygrouptable", {} )
	local ixgroups = char:GetData( "groups", {} )
	local curgroups = nil

	grouptable[mdl] = grouptable[mdl] or {}

	ixgroups[id] = val

	char:SetData( "groups", ixgroups )

	grouptable[mdl][id] = val

	char:SetData( "bodygrouptable", grouptable )
end

--[[
	FUNCTION: EditPlayerSkin( val, client )
	DESCRIPTION: Called when the player edits their skin through the bodygroup editor.
]]--

function PLUGIN:EditPlayerSkin( val, client )
	local mdl = client:GetModel()
	local char = client:GetCharacter()
	local grouptable = char:GetData( "bodygrouptable", {} )

	grouptable[mdl] = grouptable[mdl] or {}

	client:SetSkin( val )
	char:SetData( "skin", val )

	grouptable[mdl]["skin"] = val
	char:SetData( "bodygrouptable", grouptable )
end

--[[
	FUNCTION: PLUGIN:PlayerLoadedCharacter( client, character, lastChar )
	DESCRIPTION: Loads the character's edited bodygroups when their character
	has loaded.
]]--

function PLUGIN:PlayerLoadedCharacter( client, character, lastChar )
	local mdl = client:GetModel()
	local tab = character:GetData( "bodygrouptable", {} )
	local ixgroups = character:GetData( "groups", {} )

	if ( !table.IsEmpty(tab) and tab[mdl] ) then

		for k, v in pairs(tab[mdl]) do

			if ( k != "skin" ) then

				client:SetBodygroup( k, v )
				ixgroups[k] = v

			else

				character:SetData( "skin", v )
				client:SetSkin( v )

			end

		end

		character:SetData( "groups", ixgroups )
	end
end

--[[
	FUNCTION: PLUGIN:PlayerModelChanged( client, model )
	DESCRIPTION: When the player changes their model, it sets their bodygroups to the saved
	bodygroups.
]]--

function PLUGIN:PlayerModelChanged( client, model )
	local char = client:GetCharacter()

	if char and char.SetData then
		local tab = char:GetData( "bodygrouptable", {} )
		local ixgroups = char:GetData( "groups", {} )

		if ( !table.IsEmpty(tab) and tab[model] ) then

			for k, v in pairs(tab[model]) do

				if ( k != "skin" ) then

					client:SetBodygroup( k, v )
					ixgroups[k] = v

				else

					char:SetData( "skin", v )
					client:SetSkin( v )

				end

			end

			char:SetData( "groups", ixgroups )
		end
	end	
end