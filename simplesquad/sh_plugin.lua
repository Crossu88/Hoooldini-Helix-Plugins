PLUGIN.name = "Simple Squad"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "A simple squad system for military themed servers."

ix.util.Include("sh_squadnetworking.lua")
ix.util.Include("sh_squadcore.lua")
ix.util.Include("sh_squadcharmeta.lua")
ix.util.Include("sh_squadcommands.lua")
ix.util.Include("cl_squadderma.lua")

if CLIENT then
	function PLUGIN:HUDPaint()
		for k, v in pairs(squad) do
			if (v and v.member and v.member != LocalPlayer() and IsValid(v.member)) then
				local headbone = v.member:LookupBone("ValveBiped.Bip01_Head1")
				local headpos = v.member:GetBonePosition(headbone)
				local sqrdist = LocalPlayer()GetPos():DistToSqr( v.member:GetPos() )
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
end

function PLUGIN:OnCharacterDisconnect(client, character)
	if character:GetSquad() then
		ix.squadsystem.LeaveSquad(client)
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	if (lastChar and lastChar:GetSquad()) then
		ix.squadsystem.LeaveSquad(client, lastChar)
	end
end