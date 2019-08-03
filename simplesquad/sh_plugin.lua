PLUGIN.name = "Simple Squad"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "A simple squad system for military themed servers."

-- [[ INCLUDES ]] --

ix.util.Include("sh_squadcore.lua")
ix.util.Include("sh_squadcharmeta.lua")
ix.util.Include("sh_squadcommands.lua")
ix.util.Include("cl_squadderma.lua")

if CLIENT then

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
					draw.SimpleTextOutlined( "★", "Trebuchet24", screenpos.x, screenpos.y, v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 5, Color( 0, 0, 0, alpha ) )
				else
					draw.SimpleTextOutlined( "⮟", "Trebuchet24", screenpos.x, screenpos.y, v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 5, Color( 0, 0, 0, alpha ) )
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