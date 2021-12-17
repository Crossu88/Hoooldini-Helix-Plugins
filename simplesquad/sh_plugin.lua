PLUGIN.name = "Simple Squad"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "A simple squad system for military themed servers."

-- [[ INCLUDES ]] --

ix.util.Include("sh_squadcore.lua")
ix.util.Include("sh_squadcharmeta.lua")
ix.util.Include("sh_squadcommands.lua")
ix.util.Include("cl_squadderma.lua")

if CLIENT then
	local matTable = {
	none = Material( "vgui/squadsystem/squadicon.vmt" ),
	tl = Material( "vgui/squadsystem/squadicontl.vmt" ),
	lead = Material( "vgui/squadsystem/squadiconleader.vmt" ),
	saw = Material( "vgui/squadsystem/squadiconsaw.vmt" ),
	eng = Material( "vgui/squadsystem/squadiconeng.vmt" ),
	med = Material( "vgui/squadsystem/squadiconmed.vmt" ),
	dmr = Material( "vgui/squadsystem/squadicondmr.vmt" )
	}

	--[[ NETWORKING ]] --

	squad = squad or {}

	ix.squadsystem.squads = ix.squadsystem.squads or {}

	net.Receive( "CreateSquad", function()
		vgui.Create("ixSquadCreate")
	end)

	net.Receive( "ManageSquad", function()
		vgui.Create("ixSquadManage")
	end)

	net.Receive( "JoinSquad", function()
		ix.squadsystem.squads = net.ReadTable()
		vgui.Create("ixSquadJoin")
	end)

	net.Receive("SquadSync", function()
		squad = net.ReadTable()
	end)

	--[[
		FUNCTION: PLUGIN:HUDPaint()
		DESCRIPTION: Draws a symbol over other character's head depending
		on whether or not they are squad leader.
	]]--

	-- [[ FUNCTIONS ]] --

	function PLUGIN:HUDPaint()
		for k, v in pairs(squad) do
			if (v and v.member and v.member != LocalPlayer() and IsValid(v.member)) then
				local headbone = v.member:LookupBone("ValveBiped.Bip01_Head1")
				local headpos = v.member:GetBonePosition(headbone)
				local sqrdist = LocalPlayer():GetPos():DistToSqr( v.member:GetPos() )
				local maxdist = 524.934
				local alpha = 255

				if sqrdist > (maxdist*maxdist) then
					alpha = 0
				else
					alpha = 255
				end

				headpos:Add( Vector(0, 0, 15) )

				local screenpos = headpos:ToScreen()

				if k == 1 then
					surface.SetDrawColor( v.color )
					surface.SetMaterial( matTable["lead"] ) -- If you use Material, cache it!
					surface.DrawTexturedRect( screenpos.x - 16, screenpos.y, 32, 32 )
				else
					surface.SetDrawColor( v.color )
					surface.SetMaterial( matTable[v.icon] ) -- If you use Material, cache it!
					surface.DrawTexturedRect( screenpos.x - 16, screenpos.y, 32, 32 )
				end
			end
		end
	end
else
	--[[ NETWORKING ]] --

	util.AddNetworkString("CreateSquad")
	util.AddNetworkString("JoinSquad")
	util.AddNetworkString("ManageSquad")
	util.AddNetworkString("SquadKick")
	util.AddNetworkString("SquadPromote")
	util.AddNetworkString("SquadSync")

	net.Receive( "CreateSquad", function( len, pl )
		local tab = net.ReadTable()

		print("CreateSquad")

		ix.squadsystem.CreateSquad(tab[1], tab[2])
	end )

	net.Receive( "JoinSquad", function( len, pl )
		local tab = net.ReadTable()

		ix.squadsystem.JoinSquad(tab[1], tab[2])
	end)

	net.Receive("SquadKick", function()
		local tab = net.ReadTable()
		local client = tab[1]

		ix.squadsystem.LeaveSquad(client)
	end)

	net.Receive("SquadPromote", function()
		local tab = net.ReadTable()
		local client = tab[1]

		ix.squadsystem.SetSquadLeader(client)
	end)

	net.Receive("SquadSync", function()
		squad = net.ReadTable()
	end)
end

-- [[ FUNCTIONS ]] --

--[[
	FUNCTION: PLUGIN:OnCharacterDisconnect(client, character)
	DESCRIPTION: Forces a player to leave their squad upon disconnecting.
]]--

function PLUGIN:OnCharacterDisconnect(client, character)
	if character:GetSquad() then
		ix.squadsystem.LeaveSquad(client)
	end
end

--[[
	FUNCTION: PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	DESCRIPTION: Forces a player to leave their squad when switching characters.
]]--

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	if (lastChar and lastChar:GetSquad()) then
		ix.squadsystem.LeaveSquad(client, lastChar)
	end
end

--[[
	CHAT: Squad Radio
	DESCRIPTION: Allows the user to speak to their squad.
]]--

ix.chat.Register("squadradio", { -- Sets up and registers the radio chat.
	format = "[%s] %s: \"%s\"",
	indicator = "chatTalking",
	description = "Talk over your squad net.",
	CanHear = function(self, speaker, listener)
    	local canHear = false

    	local listenSquadInfo = listener:GetCharacter():GetData("squadInfo")
    	local speakSquadInfo = speaker:GetCharacter():GetData("squadInfo")

    	if ( listenSquadInfo != nil and speakSquadInfo != nil and ix.util.StringMatches(listenSquadInfo.squad, speakSquadInfo.squad) ) then
    		canHear = true
    	end

		return canHear
	end,
	CanSay = function(self, speaker, text)
		local squadInfo = speaker:GetCharacter():GetData("squadInfo")
		local squad = squadInfo["squad"]
		local canSpeak = false

		if (squadInfo) and (ix.squadsystem.squads[squad]) then -- If the speaker has RadioInfo set up, they have a radio and can speak.
			canSpeak = true
		end

		return canSpeak
	end,
	OnChatAdd = function(self, speaker, text, anonymous, info)
		local character = speaker:GetCharacter()
		local name = character:GetName()
		local color = info.color
		local icon = info.icon
		local squad = info.squad

		if ( icon != "lead" and icon != "tl" ) then
			color = Color(color.r + 50, color.g + 50, color.b + 50)
		end
		
		if (speaker != LocalPlayer()) then
	        surface.PlaySound( "npc/metropolice/vo/off" .. math.random(1, 3) .. ".wav" )
	    end

		chat.AddText(color, string.format(self.format, string.upper(squad), name, text))
	end
})

--[[
	COMMAND: /s
	DESCRIPTION: Broadcasts a message over the equipped radio's primary frequency.
]]--

ix.command.Add("s", {
	description = "Radio over your squad net.",
	superAdminOnly = false,
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, text)
		local char = client:GetCharacter()
		local squadInfo = char:GetData("squadInfo")
		local squad = squadInfo["squad"]

		if (squadInfo) and (ix.squadsystem.squads[squad]) then -- If the speaker has RadioInfo set up, they have a radio and can speak.
			client:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))

			ix.chat.Send(client, "squadradio", text, false, nil, { color = squadInfo["color"], icon = squadInfo["icon"], squad = squadInfo["squad"] })
		end
	end
})

ix.command.Add("squad", {
	description = "Radio over your squad net.",
	superAdminOnly = false,
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, text)
		local char = client:GetCharacter()
		local squadInfo = char:GetData("squadInfo")
		local squad = squadInfo["squad"]

		if (squadInfo) and (ix.squadsystem.squads[squad]) then -- If the speaker has RadioInfo set up, they have a radio and can speak.
			client:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))

			ix.chat.Send(client, "squadradio", text, false, nil, { color = squadInfo["color"], icon = squadInfo["icon"], squad = squadInfo["squad"] })
		end
	end
})