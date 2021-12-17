
-- @module ix.backgrounds

ix.backgrounds = ix.backgrounds or {}
ix.backgrounds.list = ix.backgrounds.list or {}

function ix.backgrounds.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		BACKGROUND = ix.backgrounds.list[niceName] or {}
			if (PLUGIN) then
				BACKGROUND.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v)

			BACKGROUND.name = BACKGROUND.name or "Unknown"
			BACKGROUND.description = BACKGROUND.description or "No description available."

			ix.backgrounds.list[niceName] = BACKGROUND
		BACKGROUND = nil
	end
end

function ix.backgrounds.Setup(client)
	local character = client:GetCharacter()

	if (character) then
		for k, v in pairs(ix.backgrounds.list) do
			if (v.OnSetup) then
				v:OnSetup(client, character:GetBackground(k, false))
			end
		end
	end
end

do
	
	-- Character meta for traits
	-- @classmod Character

	local charMeta = ix.meta.character

	if (SERVER) then

		-- Network string for trait updates
		util.AddNetworkString("ixBackgroundUpdate")

		-- Assigns the given background to the character.
		-- @realm: Server
		-- @string: key - The name of the background to set.
		function charMeta:SetBackground(key)
			local background = ix.backgrounds.list[key]
			local client = self:GetPlayer()

			if ( background ) then
				local backgroundTable = self:GetBackgrounds()

				for k, v in pairs( backgroundTable ) do
					backgroundTable[k] = false
				end

				backgroundTable[key] = true

				if IsValid( client ) then
					net.Start( "ixBackgroundUpdate" )
						net.WriteUInt( self:GetID(), 32 )
						net.WriteString( key )
						net.WriteBool( true )
					net.Send( client )
				end

				self:SetBackgrounds(backgroundTable)
			end
		end

		-- Find a character's background.
		-- @realm: Server
		-- @return: The name of the character's background.
		function charMeta:GetBackground()
			local backgroundTable = self:GetBackgrounds()

			for k, v in pairs( backgroundTable ) do	
				if ( v ) then return k end
			end

			return false
		end
	else
		net.Receive( "ixTraitUpdate", function()
			local id = net.ReadUInt(32)
			local character = ix.char.loaded[id]

			if ( character ) then
				local key = net.ReadString()
				local value = net.ReadBool()
				local backgroundTable = character:GetBackgrounds()

				for k, v in pairs( backgroundTable ) do
					backgroundTable[k] = false
				end

				backgroundTable[key] = value
			end
		end)
	end

end

do
	ix.char.RegisterVar("background", {   
		field = "background",
		fieldType = ix.type.string,
		default = "none",
		index = 6,
		category = "backgrounds",
		isLocal = true,
		OnDisplay = function(self, container, payload)

			payload.background = "none"

			local bgTraits = {}

			local function addTrait(trait)
				bgTraits[trait] = true
				payload.traits[trait] = true
			end

			local function clearTraits()
				for _, v in pairs(bgTraits) do
					payload.traits[v] = nil
					bgTraits = {}
				end
			end

			local main = container:Add("Panel")
			main:DockMargin(0, 0, 4, 0)
			main:Dock(FILL)

			local bginfoHeight = ( ScrH() * 0.2 ) 

			local bginfo = main:Add("Panel")
			bginfo:SetTall( bginfoHeight )
			bginfo:Dock(TOP)

			local bgpicture = bginfo:Add("DPanel")
			bgpicture:DockMargin(2, 2, 2, 2)
			bgpicture:SetSize( bginfoHeight, bginfoHeight )
			bgpicture:Dock(RIGHT)

			local bgpictureIcon = bgpicture:Add( "DImage" )
			bgpictureIcon:SetImage( "icon16/help.png" )
			bgpictureIcon:DockMargin(16, 16, 16, 16)
			bgpictureIcon:Dock(FILL)

			local bginfoLeft = bginfo:Add("Panel")
			bginfoLeft:SetTall( bginfoHeight )
			bginfoLeft:Dock(FILL)

			local bgpanel = bginfoLeft:Add("DPanel")
			bgpanel:DockMargin(2, 2, 2, 2)
			bgpanel:Dock(TOP)

			local bgdropdown = bgpanel:Add("DComboBox")
			bgdropdown:Dock(FILL)

			for k, v in SortedPairsByMemberValue(ix.backgrounds.list, "name") do 
				bgdropdown:AddChoice( L(v.name), v )
			end

			local descPanel = bginfoLeft:Add("DPanel")
			descPanel:DockMargin(2, 2, 2, 2)
			descPanel:Dock(FILL)

			local descScroll = descPanel:Add("DScrollPanel")	
			descScroll:Dock(FILL)

			local descLabel = descPanel:Add("DLabel")
			descLabel:DockMargin(2, 2, 2, 2)
			descLabel:Dock(TOP)
			descLabel:SetWrap(true)
			descLabel:SetTextInset( 4, 0 )
			descLabel:SetText( "" )

			local bgtraitPanel = main:Add("DPanel")
			bgtraitPanel:DockMargin(2, 2, 2, 2)
			bgtraitPanel:Dock(TOP)

			local bgtraitList = bgtraitPanel:Add("ixTraitList")
			bgtraitList:DockMargin(32, 32, 32, 32)
			bgtraitList:SetColumns( 6 )

			function bgdropdown:OnSelect( index, value, data )
				descLabel:SetText( data.description )
				descLabel:SizeToContents()
				bgpictureIcon:SetImage( data.icon or "icon16/help.png" )

				payload.background = L(data.name)

				clearTraits()

				bgtraitList:Clear()

				for k, v in pairs( data.traits ) do
					local traits = ix.traits.list
					addTrait(v)
					bgtraitList:AddTrait( traits[v], true, false )
				end
			end

			return main
		end,
		OnValidate = function(self, value, data, client)
			if (value != nil) then
				if not (isstring(value)) then
					return false, "unknownError"
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			return !table.IsEmpty(ix.traits.list)
		end
	})

	hook.Add( "DoPluginIncludes", "HRPGLoadBackgrounds", function( path, PLUGIN )
		ix.backgrounds.LoadFromDir(path.."/backgrounds") 
	end)
end