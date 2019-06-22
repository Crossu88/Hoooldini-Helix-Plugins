PLUGIN.name = "Exosuit"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Adds and exosuit with special abilities."

--[[
	WARNING: The original developer of the exosuit script was a horrible person and
	coded to prevent themselves from picking the bugs crawling under their skin while
	on methamphetamines. I tried my best to clean it up, but I could only do so much. 
	If you wish to keep your sanity, turn back. This is your last chance.
	-Hoooldini
]]--

if (CLIENT) then
	wallrun_angle = CreateConVar("cl_wallrun_angle", 10, {FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "Tilt intensity when wallrunning. Default is 10")
	wallrun_anglespeed = CreateConVar("cl_wallrun_anglespeed", 0.2, {FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "How fast the tilt is. Default is 0.2")
	wallrun_angleresetspeed = CreateConVar("cl_wallrun_angleresetspeed", 0.2, {FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "How fast the tilt resets. Default is 0.5")
	local AEWallrunDirection = 0
	local AEIsSliding = false

	function PLUGIN:Think(ply)
		local ply = LocalPlayer()
		local wallrunangle = wallrun_angle:GetFloat()
		local wallrunanglespeed = wallrun_anglespeed:GetFloat()
		local wallrunangleresetspeed = wallrun_angleresetspeed:GetFloat()
		if !IsValid( ply ) then return end
		if AEWallrunDirection == 0 and AEIsSliding == false then

		if ply:EyeAngles().roll > 0 then ply:SetEyeAngles( Angle(ply:EyeAngles().p, ply:EyeAngles().y, ply:EyeAngles().r-wallrunangleresetspeed ) )

		elseif ply:EyeAngles().roll < 0 then ply:SetEyeAngles( Angle(ply:EyeAngles().p, ply:EyeAngles().y, ply:EyeAngles().r+wallrunangleresetspeed ) )

		end
		if ply:EyeAngles().roll > -1 and ply:EyeAngles().roll < 1 and ply:EyeAngles().roll != 0 then ply:SetEyeAngles( Angle(ply:EyeAngles().p, ply:EyeAngles().y, 0 ) ) --anti retard code
		--print("Slow down there buddy")
		end
		end

		if AEWallrunDirection == 1 then
		ply:SetEyeAngles( Angle(ply:EyeAngles().x, ply:EyeAngles().y, math.Clamp(ply:EyeAngles().z+wallrunanglespeed, -wallrunangle,wallrunangle) ) ) 
		end

		if AEWallrunDirection == 2 then
		ply:SetEyeAngles( Angle(ply:EyeAngles().x, ply:EyeAngles().y, math.Clamp(ply:EyeAngles().z-wallrunanglespeed, -wallrunangle, 0) ) ) 
		end
		if AEIsSliding == true then ply:SetEyeAngles( Angle(ply:EyeAngles().x, ply:EyeAngles().y, math.Clamp(ply:EyeAngles().z-1.5, -ply:GetVelocity():Length()/80, 5) ) )
		--elseif AEIsSliding == false then if ply:EyeAngles().roll > 0 and ply.IsSliding == false and ply.AEWallrunDirection  then ply:SetEyeAngles( Angle(ply:EyeAngles().p, ply:EyeAngles().y, ply:EyeAngles().r+1 ) ) end end
		end
	end

	net.Receive( "wallrun_eyeangle", function()
	--print("received")
	AEWallrunDirection = net.ReadInt(32)
	end)

	net.Receive( "slide_eyeangle", function()
	--print("received")
	AEIsSliding = net.ReadBool()
	end)

	function PLUGIN:PopulateToolMenu()
		spawnmenu.AddToolMenuOption( "Options", "BO3", "BO3MenuServer", "Server", "", "", function( panel )
			panel:ClearControls()
			panel:AddControl( "Header", { Description = "0 = Infinite\n" }  )
			panel:AddControl( "Checkbox", { Label = "Players Spawn with Exosuit", Command = "sv_bo3_spawnwithexosuit" } )
			panel:AddControl( "Header", { Description = "Abilities Toggle" }  )
			panel:AddControl( "Checkbox", { Label = "Enable Wallrunning", Command = "sv_wallrun_enabled" } )
			panel:AddControl( "Checkbox", { Label = "Enable Thrust Jumping", Command = "sv_thrustjump_enabled" } )
			panel:AddControl( "Checkbox", { Label = "Enable Sliding", Command = "sv_sliding_enabled" } )
			panel:AddControl( "Header", { Description = "Wallrun Settings" }  )
			panel:AddControl( "Checkbox", { Label = "Enable Skybox Wallrunning", Command = "sv_wallrun_skybox" } )
			panel:AddControl( "Checkbox", { Label = "Can Wallrun Twice in a Row on the Same Wall?", Command = "sv_wallrun_samewall" } )
			panel:NumSlider( "Max Wallrun Duration (v2)", "sv_wallrun_timemomentum", 0, 20 )
			panel:NumSlider( "Wallrun End Fall Speed", "sv_wallrun_fallspeed", 0, 20 )
			panel:NumSlider( "Minimum Velocity to Wallrun", "sv_wallrun_minimumvelocity", 0, 800 )
			panel:NumSlider( "Maximum Velocity while Wallrunning", "sv_wallrun_maxvelocity", 0, 5000 )
			panel:NumSlider( "Wallrun Jump Delay", "sv_wallrun_jumpdelay", 0, 5 )
			panel:NumSlider( "Wallrun Jump Force", "sv_wallrun_jumpforce", 0, 10 )
			panel:NumSlider( "Wall Detection Trace Length", "sv_wallrun_tracelength", 0, 200 )
			panel:NumSlider( "Max Amount of Wallruns without touching the ground", "sv_wallrun_maxamount", 0, 50 )
			panel:NumSlider( "NPC Damage Dodge Chance", "sv_wallrun_dodgechance", 0, 100 )
			panel:AddControl( "Header", { Description = "Thrust Jump Settings" }  )
			panel:NumSlider( "Thrust Jump Max Energy", "sv_thrustjump_energy", 0, 200 )
			panel:NumSlider( "Thrust Jump Power", "sv_thrustjump_power", 0, 3000 )
			panel:NumSlider( "Thrust Jump Recharge Cooldown Time", "sv_thrustjump_cooldowntime", 0, 10 )
			panel:NumSlider( "Thrust Jump Recharge Time Scale", "sv_thrustjump_energyrechargescale", 0, 10 )
			panel:AddControl( "Checkbox", { Label = "Print Energy to Chat", Command = "sv_thrustjump_debuginfo" } )
			panel:AddControl( "Header", { Description = "Sliding Settings" }  )
			panel:NumSlider( "Sliding Speed", "sv_sliding_speed", 0, 200 )
			panel:NumSlider( "Sliding Energy Consumption", "sv_sliding_energyconsumption", 0, 15 )
		end )
		spawnmenu.AddToolMenuOption( "Options", "BO3", "BO3MenuClient", "Client", "", "", function( panel )
			panel:ClearControls()
			panel:AddControl( "Header", { Description = "View Options" }  )
			panel:NumSlider( "Tilt Intensity", "cl_wallrun_angle", 0, 50 )
			panel:NumSlider( "Tilt Start Speed", "cl_wallrun_anglespeed", 0, 5 )
			panel:NumSlider( "Tilt End Speed", "cl_wallrun_angleresetspeed", 0, 5 )
		end)
	end
end



if (SERVER) then
	sound.Add( {
		name = "WallrunME",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 150 },
		sound = "me/wallrun.wav"
	} )

	sound.Add( {
		name = "WallrunBO3",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/wallrun_loop.wav"
	} )

	sound.Add( {
		name = "WallrunJump1BO3",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/wallrun_jump.wav"
	} )

	sound.Add( {
		name = "WallrunJump2BO3",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/wallrun_jump2.wav"
	} )

	sound.Add( {
		name = "WallrunContactBO3",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/wallrun_contact.wav"
	} )

	sound.Add( {
		name = "ThrustJump0",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/thrust_jump.wav"
	} )

	sound.Add( {
		name = "ThrustJump1",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/thrust_jump2.wav"
	} )

	sound.Add( {
		name = "ThrustJump2",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/thrust_jump3.wav"
	} )

	sound.Add( {
		name = "SlideBO3",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 100, 105 },
		sound = "bo3/slide.wav"
	} )

	util.AddNetworkString( "wallrun_eyeangle" )
	util.AddNetworkString( "slide_eyeangle" )

	local jumpforcefix = false

	wallrun_toggle_convar = CreateConVar("sv_wallrun_enabled", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Toggles wallrun")
	wallrun_samewall_convar = CreateConVar("sv_wallrun_samewall", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Can a player wallrun on the same wall twice in a row?")
	wallrun_jumpforce_convar = CreateConVar("sv_wallrun_jumpforce", 150, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Wallrun jump force times X, 150 is the default value. Can be float")
	wallrun_time_convar = CreateConVar("sv_wallrun_time", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Time before a wallrun stops. 2.7 is the default value")
	wallrun_fallspeed_convar = CreateConVar("sv_wallrun_fallspeed", 1.25, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How fast a player falls")
	wallrun_timemomentum_convar = CreateConVar("sv_wallrun_timemomentum", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Player will begin losing altitude while wallrunning past this timer and must trigger another wallrun. 0 disables this")
	wallrun_minimumvelocity_convar = CreateConVar("sv_wallrun_minimumvelocity", 100, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Minimum velocity needed to start a wallrun. 100 is default.")
	wallrun_velocity_convar = CreateConVar("sv_wallrun_maxvelocity", 700, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Wallrunning maximum velocity. 700 is default.")
	wallrun_maxamount = CreateConVar("sv_wallrun_maxamount", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How many times can a player wallrun without touching the ground? 0 is infinite")
	wallrun_jumpdelay = CreateConVar("sv_wallrun_jumpdelay", 0.05, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "When starting a wallrun, how long a player has to wait before they can jump off. Default is 0.05")
	wallrun_jumphold = CreateConVar("sv_wallrun_jumphold", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "If enabled, a player won't jump off a wallrun automatically if they were holding spacebar. They have to press it instead.")
	wallrun_tracelength = CreateConVar("sv_wallrun_tracelength", 40, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How long is the trace that determines if a wall is close. 40 is default. Do not fuck with this too much, 35 is the best value and 40 is easy mode")
	wallrun_skybox = CreateConVar("sv_wallrun_skybox", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Can a player wallrun on a skybox texture?")
	wallrun_dodgechance = CreateConVar("sv_wallrun_dodgechance", 25, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Chance to dodge damage from NPC while wallrunning. 100(%) is guaranteed to dodge, 25(%) is 1/4 chance to dodge")

	thrustjump_toggle_convar = CreateConVar("sv_thrustjump_enabled", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Toggles thrust jumping")
	thrustjump_energy = CreateConVar("sv_thrustjump_energy", 5, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Maximum energy for thrust jumping")
	thrustjump_energyrechargescale = CreateConVar("sv_thrustjump_energyrechargescale", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Recharge speed scaler. 1 is default. 2 is twice as fast and so on")
	thrustjump_debuginfo = CreateConVar("sv_thrustjump_debuginfo", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Print debug shit to every players chatbox")
	thrustjump_cooldowntime = CreateConVar("sv_thrustjump_cooldowntime", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Cooldown before energy starts recharging. 1 is default.")
	thrustjump_power = CreateConVar("sv_thrustjump_power", 780, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Thrust jumping power. Default is 780")

	slide_toggle = CreateConVar("sv_sliding_enabled", 1, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Toggles sliding")
	slide_speed = CreateConVar("sv_sliding_speed", 74, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Sliding velocity. 74 is default")
	slide_energyconsumption = CreateConVar("sv_sliding_energyconsumption", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How much energy should sliding consume")

	if jumpforcefix == false then 
		if wallrun_jumpforce_convar:GetFloat() > 5 then 
			RunConsoleCommand( "sv_wallrun_jumpforce", "1.25" ) 
		end
	end

	function PLUGIN:PlayerSpawn(ply)
		ply.IsSliding = false
		ply.IsWallrunning = false
		ply.WallrunTimer = CurTime()+2.7
		ply.SlidingSpeed = 74
		ply.SlidingDirection = nil
		ply.SlideEyeAngle = nil 
		ply.WallrunEyeAngle = nil 
		ply.WallrunJumpoffDelay = 0
		ply.WallrunNext = CurTime()+0.5
		ply.WallrunCurrentDuration = CurTime()
		ply.WallrunSound = false
		ply.ResetWallrunVelocity = false
		ply.WallrunGroundCheck = false
		ply.LastWallAngle = nil
		ply.TransmittedNet = false --1: left, 2: right, 0: stop
		ply.TransmittedNetStop = false
		ply.WallrunCounter = 0
		ply.WallrunCounterFake = 0
		ply.WallrunCounterC = false
		ply.ReleasedJump = false
		ply.WallrunContactDelay = CurTime()+1.5
		ply.WallrunThrustJumpSafe = CurTime()+0.25
		ply.WallrunDescentVelocity = 0
		ply.WallGrab = CurTime()
		ply.WallGrabKeyHeld = false
		ply.WallGrabKeyCount = 0
		ply.WallGrabbing = false

		ply.exoSlam = false

		ply.ThrustJumpBeganJump = false
		ply.ThrustJumpReleasedJump = false
		ply.ThrustJumpCooldown = CurTime()+1
		ply.ThrustJumpEnergy = 5
		ply.ThrustJumpViewPunched = false
		ply.ThrustJumpCount = 0

		ply.SlideInitialPos = 0
		ply.TransmittedNetSlide = false
	end  

	function PLUGIN:SetupMove(ply, movedata, cmd)
		if !ply:GetCharacter() or !ply:GetCharacter():GetData("exosuit") or ply:GetCharacter():GetData("exosuit") == nil then return end

		if ply.SlidingSpeed == 0 and ply:KeyDown( IN_DUCK ) then 
			ply:SetAbsVelocity( Vector(0, 0, 0) ) 
		end

		if (ply:KeyDown( IN_FORWARD )) and (ply:KeyDown( IN_DUCK )) and (ply:KeyDown( IN_SPEED )) and ply.IsSliding == false and ply:IsOnGround() and slide_toggle:GetBool() == true and ply:GetVelocity():Length() > 124 then 
			ply.IsSliding = true ply.SlideInitialPos = ply:GetPos().z ply.SlidingSpeed = slide_speed:GetFloat() ply:ConCommand("-speed") ply.SlidingDirection = ply:GetForward() ply.SlideEyeAngle = ply:EyeAngles()

			if slide_energyconsumption:GetFloat() > 0 then 
				if ply.ThrustJumpEnergy-slide_energyconsumption:GetFloat() <= 0 then 
					ply.SlidingSpeed = 0 ply.IsSliding = false 
				else 
					ply.ThrustJumpEnergy = ply.ThrustJumpEnergy-slide_energyconsumption:GetFloat() 
					ply.ThrustJumpCooldown = CurTime()+thrustjumpcooldowntime 
					ply:EmitSound( "SlideBO3" ) 
				end 
			else 
				ply:EmitSound( "SlideBO3" )
			end
		end

		if ply.IsSliding == true and ply:KeyDown( IN_DUCK ) and ply:IsOnGround() then
			ply:SetVelocity( ply.SlidingDirection* ply.SlidingSpeed )
			ply.SlidingSpeed = math.Clamp(ply.SlidingSpeed-1, 0, 10000)

			if ply.TransmittedNetSlide == false then
				net.Start( "slide_eyeangle")
				net.WriteBool(true)
				net.Send( ply )
				ply.TransmittedNetSlide = true
				ply:ViewPunch( Angle( -5, -1, 0 ) ) 
			end 
		else 
			ply.IsSliding = false ply.SlidingSpeed = 0 
		end

		if ply.SlidingSpeed == 0 or ply:KeyDown( IN_DUCK ) == false then 
			ply.SlidingSpeed = 0 ply.IsSliding = false

			if ply.TransmittedNetSlide == true then
				net.Start( "slide_eyeangle")
				net.WriteBool(false)
				net.Send( ply )
				ply.TransmittedNetSlide = false 
			end 
		end


		if thrustjump_debuginfo:GetBool() then
			ply:ChatPrint(ply.ThrustJumpEnergy) 
		end
	 
		--wallrun
		wallrunjumpdelay = wallrun_jumpdelay:GetFloat()
		wallruntracelength = wallrun_tracelength:GetFloat()
		thrustjumpmaxenergy = thrustjump_energy:GetFloat()
		thrustjumpenergyrechargescale = thrustjump_energyrechargescale:GetFloat()
		thrustjumpcooldowntime = thrustjump_cooldowntime:GetFloat()
		thrustjumppower = thrustjump_power:GetFloat()

		if ply.IsWallrunning == false then
			ply.WallrunJumpoffDelay = CurTime()+wallrunjumpdelay ply.WallrunTimer = CurTime()+wallrun_time_convar:GetFloat() ply:StopSound("WallrunBO3") ply.WallrunSound = false ply.WallrunCounterC = false ply.ReleasedJump = false 
		end

		if ply:KeyDown( IN_DUCK ) and !ply:OnGround() then
			if ply.exoSlam then return end

			local height = 200

			local plyPos = ply:GetPos()

			local trace = {
				start = plyPos,
				endpos = plyPos:Sub( Vector(0, 0, 100) )
			}

			local tr = util.TraceLine( trace )


			if !tr.Hit then
				ply.exoSlam = true //Set the players squish variable so they can not jump out of slamming down
				ply:SetVelocity( -ply:GetVelocity() )
				ply:SetVelocity( Vector(0,0,130*-height) )
			end
		end

		if (ply:KeyDown( IN_FORWARD )) and (ply:KeyDown( IN_JUMP )) and ply.IsWallrunning == false and CurTime() > ply.WallrunNext then
			ply.IsWallrunning = true
		end

		if ply:IsOnGround() then 
			ply.ThrustJumpBeganJump = false ply.ThrustJumpReleasedJump = false ply.ThrustJumpCount = 0
		end

		if CurTime() > ply.ThrustJumpCooldown and ply:IsOnGround() or ply.WallrunSound then 
			ply.ThrustJumpEnergy = math.Clamp(ply.ThrustJumpEnergy+0.1*thrustjumpenergyrechargescale, 0, thrustjumpmaxenergy) ply.ThrustJumpCount = 0 
		end

		if (ply:KeyDown( IN_JUMP )) and ply:IsOnGround() == true then
			ply.ThrustJumpBeganJump = true
		end

		if ply.ThrustJumpBeganJump then
			if !(ply:KeyDown( IN_JUMP )) then 
				ply.ThrustJumpReleasedJump = true
			end
		end

		if ply:GetVelocity().z < -5 then 
			ply.ThrustJumpReleasedJump = true 
		end

		if ply.IsWallrunning == true and wallrun_toggle_convar:GetBool() == true then
			if wallrun_jumphold:GetBool() == false then 
				ply.ReleasedJump = true 
			end

			if !(ply:KeyDown( IN_JUMP )) then 
				ply.ReleasedJump = true 
			end

			if (ply:KeyDown( IN_DUCK )) or ply:WaterLevel() >= 2 then 
				ply.IsWallrunning = false 
				ply.ResetWallrunVelocity = false 
				ply.WallrunGroundCheck = false 
				ply.WallrunCounterC = false 
				return 
			end

			if !IsValid( ply ) or ((ply:GetVelocity():Length() < wallrun_minimumvelocity_convar:GetFloat() and ply.WallGrabbing == false) or (Vector(ply:GetVelocity().x,ply:GetVelocity().y,0):Length() < wallrun_minimumvelocity_convar:GetFloat() and ply.WallGrabbing == false )) then 
				ply.IsWallrunning = false 
				ply.ResetWallrunVelocity = false 
				ply.WallrunGroundCheck = false 
				ply.WallrunCounterC = false 
				return 
			end

			if ply.WallrunCounter > wallrun_maxamount:GetInt() and wallrun_maxamount:GetInt() != 0 then return end

			if ply:GetVelocity().z < -5 and ply.LastWallAngle==nil and wallrun_samewall_convar:GetBool() == false then return end

			--if CurTime()+wallrunjumpdelay-0.02 < ply.WallrunJumpoffDelay then end

			local dir_left = ply:EyeAngles():Right() * -wallruntracelength
			local dir_right = ply:EyeAngles():Right() * wallruntracelength
			local dir_behind = ply:EyeAngles():Forward() * -wallruntracelength
			local pos = ply:GetPos() + Vector( 0, 0, 45 )
			local trl = util.TraceLine( { start = pos, endpos = pos + dir_left, filter = ply } ) 
			local trr = util.TraceLine( { start = pos, endpos = pos + dir_right, filter = ply } )
			local trb = util.TraceLine( { start = pos, endpos = pos + dir_behind, filter = ply } )
			local angleSin = math.sin( CurTime() * 15 ) * 0.2
		
			if (trl.Hit and ( trl.Entity:IsWorld() or trl.Entity:GetClass() == 'prop_physics' )) or (trb.Hit and ply.WallrunSound == true and ( trb.Entity:IsWorld() or trb.Entity:GetClass() == 'prop_physics')) and CurTime() > ply.WallrunNext and (CurTime() < ply.WallrunTimer or wallrun_time_convar:GetFloat() == 0) and ply:IsOnGround() == false and ply.LastWallAngle != trl.HitNormal then
				if trl.HitSky == true and wallrun_skybox:GetBool() == false then 
					ply.IsWallrunning = false 
					ply.ResetWallrunVelocity = false 
					ply.WallrunGroundCheck = false 
					ply.WallrunCounterC = false 
					return 
				end

				if ply.WallrunCounterC == false and CurTime() > ply.WallrunNext then 
					ply.WallrunCounter = ply.WallrunCounter+1 
					ply.WallrunCounterFake=ply.WallrunCounterFake+1 
					ply.WallrunCounterC = true 
				end

				if ply.WallrunSound == false then
					if CurTime() > ply.WallrunContactDelay then 
						ply:EmitSound("WallrunContactBO3") ply.WallrunCounterFake = 0 
					end

					ply:EmitSound( "WallrunBO3" )  
					ply.WallrunSound = true 
					ply.WallGrab = CurTime()+9999 
					ply.WallrunCurrentDuration = CurTime()+wallrun_timemomentum_convar:GetFloat() 

					if ply.WallrunCounter > 1 then 
						ply:ViewPunch( Angle( math.Clamp(2*-ply:GetVelocity().z/1000,0,20), 0, math.Clamp(ply.WallrunCounter,-5, 5) ) ) 
					end 
				end
					
				if ply:GetVelocity().z < 0 then
					ply.WallrunGroundCheck = true
				end

				if ply.WallrunEyeAngle == nil then 
					ply.WallrunEyeAngle = ply:EyeAngles() 
				end

				ply:SetVelocity( Vector( 0, 0, 380 ) ) 
				
				if ply.TransmittedNet == false then
					net.Start( "wallrun_eyeangle")
					net.WriteInt( 1, 32 )
					net.Send( ply )
					ply.TransmittedNet = true
				end
				
				if CurTime() > ply.WallrunJumpoffDelay and (ply:KeyDown( IN_JUMP )) and ply.IsWallrunning == true and ply.ReleasedJump==true then
					ply.TransmittedNet = false
					ply.IsWallrunning = false
					ply.WallrunNext = CurTime()+0.5 
					ply:EmitSound(table.Random({"WallrunJump1BO3","WallrunJump2BO3"}))
					ply.WallrunThrustJumpSafe = CurTime()+0.25
					ply.WallrunDescentVelocity = 0

					if wallrun_samewall_convar:GetBool() == false then  
						ply.LastWallAngle = trl.HitNormal 
					end
				end	
			elseif trr.Hit and ( trr.Entity:IsWorld() or trr.Entity:GetClass() == 'prop_physics' ) or (trb.Hit and ply.WallrunSound == true and ( trb.Entity:IsWorld() or trb.Entity:GetClass() == 'prop_physics')) and CurTime() > ply.WallrunNext and (CurTime() < ply.WallrunTimer or wallrun_time_convar:GetFloat() == 0) and ply:IsOnGround() == false and ply.LastWallAngle != trr.HitNormal  then --hurr durr copypaste =D
				if trr.HitSky == true and wallrun_skybox:GetBool() == false then 
					ply.IsWallrunning = false ply.ResetWallrunVelocity = false ply.WallrunGroundCheck = false ply.WallrunCounterC = false 
					return 
				end

				if ply.WallrunCounterC == false and CurTime() > ply.WallrunNext then 
					ply.WallrunCounter = ply.WallrunCounter+1 ply.WallrunCounterFake=ply.WallrunCounterFake+1 ply.WallrunCounterC = true 
				end

				if ply.WallrunSound == false then
					if CurTime() > ply.WallrunContactDelay then 
						ply:EmitSound("WallrunContactBO3") ply.WallrunCounterFake = 0 
					end

					ply:EmitSound( "WallrunBO3" )
					ply.WallrunSound = true ply.WallGrab = CurTime()+9999 
					ply.WallrunCurrentDuration = CurTime()+wallrun_timemomentum_convar:GetFloat() 

					if ply.WallrunCounter > 1 then 
						ply:ViewPunch( Angle( math.Clamp(2*-ply:GetVelocity().z/500,0,20), 0, math.Clamp(-ply.WallrunCounter,-5, 5) ) ) 
					end 
				end

				if ply:GetVelocity().z < 0 then
					ply.WallrunGroundCheck = true 
				end

				if ply.WallrunNext == 0 then
					ply.WallrunNext = CurTime()+0.5 
				end

				ply:SetVelocity( Vector( 0, 0, 380 ) )
				ply.WallrunGroundCheck = true

				if ply.TransmittedNet == false then
					net.Start( "wallrun_eyeangle")
					net.WriteInt( 2, 32 )
					net.Send( ply )
					ply.TransmittedNet = true
				end
				
				if CurTime() > ply.WallrunJumpoffDelay and (ply:KeyDown( IN_JUMP )) and ply.IsWallrunning == true and ply.ReleasedJump == true then
					ply.IsWallrunning = false
					ply.WallrunNext = CurTime()+0.5
					ply:EmitSound(table.Random({"WallrunJump1BO3","WallrunJump2BO3"}))
					ply.WallrunThrustJumpSafe = CurTime()+0.25
					ply.WallrunDescentVelocity = 0

					if wallrun_samewall_convar:GetBool() == false then 
						ply.LastWallAngle = trr.HitNormal 
					end

					ply.TransmittedNet = false
				end
			elseif trb.Hit == false then 
				ply.IsWallrunning = false ply.ResetWallrunVelocity = false ply.WallrunGroundCheck = false ply.TransmittedNet = false ply.WallrunDescentVelocity = 0
			end

			ply.WallrunContactDelay = CurTime()+1.5-ply.WallrunCounterFake/5

			if ply.WallrunSound == true then 
				ply.WallrunThrustJumpSafe = CurTime()+0.25 
			end	
		end

		--thrust jump, i was retarded enough to put this before wallrun
		if ply:IsOnGround() == false and ply.ThrustJumpReleasedJump == true and (ply:KeyDown( IN_JUMP )) and ply.ThrustJumpEnergy > 0 and CurTime() > ply.WallrunThrustJumpSafe and ply.WallrunSound == false and ply:WaterLevel() < 2 and thrustjump_toggle_convar:GetBool() then
			if ply.IsWallrunning then 
				ply.ThrustJumpCooldown = CurTime() else ply.ThrustJumpCooldown = CurTime()+thrustjumpcooldowntime 
			end

			if ply.ThrustJumpViewPunched == false then 
				ply:ViewPunch( Angle( 1.5, 0, 0 ) ) ply.ThrustJumpViewPunched = true ply:EmitSound("ThrustJump" .. tostring(ply.ThrustJumpCount))  ply.ThrustJumpCount = math.Clamp(ply.ThrustJumpCount+1, 0, 2)
			end

			ply:SetVelocity( Vector( 0, 0, thrustjumppower ) )
			ply.ThrustJumpEnergy = math.Clamp(ply.ThrustJumpEnergy-0.1, 0, thrustjumpmaxenergy)
		elseif ply:IsOnGround() == false and ply.ThrustJumpReleasedJump == true then 
			ply.ThrustJumpViewPunched = false 
			if ply.ThrustJumpCount > 0 and ply.WallrunSound == false then 
				if ply.IsWallrunning then 
					ply.ThrustJumpCooldown = CurTime() 
				else 
					ply.ThrustJumpCooldown = CurTime()+thrustjumpcooldowntime 
				end 
			end 
		end

		if ply.IsWallrunning == false then
			if ply.TransmittedNetStop == false then
					net.Start( "wallrun_eyeangle")
					net.WriteInt( 0, 32 )
					net.Send( ply )
					ply.TransmittedNetStop = true
			end
		else 
			ply.TransmittedNetStop = false
		end

		if ply:IsOnGround() == true then 
			ply.IsWallrunning = false ply:StopSound("WallrunBO3") ply.WallrunGroundCheck = false ply.LastWallAngle = nil ply.TransmittedNet = false ply.WallrunCounter = 0 ply.WallrunCounterC = false ply.WallrunDescentVelocity = 0 
		end
	end

	function PLUGIN:EntityTakeDamage(target, dmg)
		if target == dmg:GetAttacker() then return false end --and dmg:GetDamageType() == DMG_CRUSH

		if target:IsPlayer() then
			wallrundodgechance = wallrun_dodgechance:GetFloat()
			if dmg:GetAttacker():IsNPC() and target.WallrunSound == true then
				if math.random(0,100) < wallrundodgechance then
					return true 
				else 
					return false 
				end
			end
		end
	end

	function PLUGIN:GetFallDamage(ply, speed)
		if ply:GetCharacter():GetData("exosuit") then
			return 0
		end
	end

	function PLUGIN:OnPlayerHitGround(ply)
		if ply.exoSlam == true then
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamageType(DMG_CRUSH)
			dmgInfo:SetDamage(200)
			dmgInfo:SetAttacker(ply)

			--util.BlastDamageInfo( dmgInfo, ply:GetPos(), 300 )

			local targets = ents.FindInSphere(ply:GetPos(), 300)

			for k, v in pairs(targets) do
				if !(v == ply) and IsValid(v) then
					v:TakeDamageInfo( dmgInfo )
				end
			end

			util.ScreenShake( ply:GetPos(), 5, 5, 1, 5000 ) //Shake the screen on hit
			
			//Squish effect
			local effect = EffectData()
			effect:SetOrigin( ply:GetPos() )
			util.Effect( "cball_explode", effect, true, true )

			ply:EmitSound( "weapons/physcannon/energy_sing_explosion2.wav", 75, 100, 1, CHAN_AUTO )
		end
		ply.exoSlam = false
	end

	function PLUGIN:Think()
		wallrunvelocityconvar = wallrun_velocity_convar:GetFloat()
		wallrunfallspeed = wallrun_fallspeed_convar:GetFloat()
		local oldvelo = Vector( 0, 0, 0 ) 
		local accvelo = 250
		local accmult = 2
		for k, ply in pairs(player.GetAll()) do
			if ply:GetVelocity().z < 0 and ply.WallrunGroundCheck == true and ply.IsWallrunning == true and ply:IsOnGround() == false and (CurTime() < ply.WallrunCurrentDuration or wallrun_timemomentum_convar:GetFloat() == 0) then 
				ply:SetLocalVelocity(Vector(   math.Clamp(ply:GetVelocity().x, -wallrunvelocityconvar, wallrunvelocityconvar), math.Clamp(ply:GetVelocity().y, -wallrunvelocityconvar, wallrunvelocityconvar), -1.2   )) ply.ResetWallrunVelocity = true
			elseif ply:GetVelocity().z < 0 and ply.WallrunGroundCheck == true and ply.IsWallrunning == true and ply:IsOnGround() == false and (CurTime() > ply.WallrunCurrentDuration and wallrun_timemomentum_convar:GetFloat() != 0) then 
				ply.WallrunDescentVelocity = ply.WallrunDescentVelocity-wallrunfallspeed ply:SetLocalVelocity(Vector(   math.Clamp(ply:GetVelocity().x, -wallrunvelocityconvar, wallrunvelocityconvar), math.Clamp(ply:GetVelocity().y, -wallrunvelocityconvar, wallrunvelocityconvar), ply.WallrunDescentVelocity   )) 
			end 

			if CurTime() > ply.WallrunJumpoffDelay and (ply:KeyDown( IN_JUMP )) and ply.ReleasedJump==true then
				oldvelo = ply:GetVelocity()
				ply:SetLocalVelocity(Vector(0,0,0))
				if ply.WallGrabbing then
					ply:SetVelocity( Vector(ply:GetAimVector().x*2,ply:GetAimVector().y*2,ply:GetAimVector().z*2)*math.Clamp(oldvelo:Length(), 200, 999999)*wallrun_jumpforce_convar:GetFloat() )
				else
					ply:SetVelocity( Vector(ply:GetAimVector().x,ply:GetAimVector().y,0)*math.Clamp(oldvelo:Length(), 250, 999999)*wallrun_jumpforce_convar:GetFloat()+Vector(0,0,250) ) 
				end
			end

			if (ply:KeyDown( IN_SPEED ) and ply:KeyDown( IN_FORWARD )) then 
				accvelo = 550 accmult = 4 
			elseif (ply:KeyDown( IN_FORWARD )) then 
				accvelo = 250 accmult = 2 
			end

			if ply:KeyDown( IN_BACK ) and ply.WallGrabKeyHeld == false and ply.IsWallrunning then 
				ply.WallGrabKeyHeld = true ply.WallGrab = CurTime()+0.2 ply.WallGrabKeyCount = ply.WallGrabKeyCount+1 
			elseif !ply:KeyDown( IN_BACK ) and ply.WallGrabKeyHeld == true then 
				ply.WallGrabKeyHeld = false 
			end

			if ply.WallGrabKeyHeld == true and ply.IsWallrunning then 
				ply.WallGrab = CurTime()+0.2 
			end 

			if CurTime() > ply.WallGrab or ply.IsWallrunning == false then 
				ply.WallGrabKeyCount = 0 
			end

			if ply:KeyDown( IN_BACK ) and CurTime() < ply.WallGrab and ply.IsWallrunning and ply.WallGrabKeyCount >= 2 then 
				ply:SetLocalVelocity(Vector(0,0,0)) ply:StopSound("WallrunBO3") ply:EmitSound("ThrustJump2") ply:ViewPunch( Angle( 1.5, 0, 0 ) ) ply.WallGrabKeyCount = 0 ply.WallGrabbing = true 
			end

			if ply.IsWallrunning == true and ply.WallGrabbing == true then 
				ply:SetLocalVelocity(Vector(0,0,-1.2)) 
			elseif ply.IsWallrunning == false and ply.WallGrabbing == true then 
				ply.WallGrabbing = false 
			end

			if (ply:KeyDown( IN_FORWARD )) and ply.IsWallrunning == true and ply:GetVelocity():Length() < accvelo then 
				ply:SetVelocity(Vector(ply:GetAimVector().x* accmult,ply:GetAimVector().y*accmult,0)) 
			end
		end
	end
end