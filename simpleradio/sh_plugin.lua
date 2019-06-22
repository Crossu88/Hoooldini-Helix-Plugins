PLUGIN.name = "Simple Radio"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Simple radios for Helix."

if SERVER then
	util.AddNetworkString( "radioReceive" )
end

if CLIENT then
	net.Receive( "my_message", function( len, pl )
		LocalPlayer():EmitSound("npc/metropolice/vo/off" .. math.random(1, 3) .. ".wav", math.random(50, 60), math.random(80, 120))
	end )
end

local colorTable = { -- Optional color table for giving frequencies different colors.
	main = Color(80, 180, 255),
	command = Color(255, 255, 85),
	support = Color(100, 255, 50)
}

local RADIO_CHATCOLOR = Color(100, 255, 50)

ix.chat.Register("radio", { -- Sets up and registers the radio chat.
	format = "[%s] %s: \"%s\"",
	OnGetColor = function(self, speaker, text)
		return RADIO_CHATCOLOR
	end,
	OnCanHear = function(self, speaker, listener)
		local listenerRadio = listener:GetCharacter():GetData("RadioInfo")
		local speakerRadio = speaker:GetCharacter():GetData("RadioInfo")
		local canHear = false

		if (listenerRadio and table.HasValue(listenerRadio.freqList, speakerRadio.lastFreq)) then -- If the listener has the frequency, allow them to hear the transmission.
			canHear = true
			net.Start("radioReceive")
			net.Send(listener)
		end

		return canHear
	end,
	CanSay = function(self, speaker, text)
		local speakerRadio = speaker:GetCharacter():GetData("RadioInfo")
		local canSpeak = false

		if (speakerRadio) then -- If the speaker has RadioInfo set up, they have a radio and can speak.
			canSpeak = true
		end

		return canSpeak
	end,
	OnChatAdd = function(self, speaker, text, anonymous, info)
		local character = speaker:GetCharacter()
		local name = character:GetName()
		local radioInfo = character:GetData("RadioInfo")
		local channel = string.upper(radioInfo.lastFreq)

		chat.AddText((colorTable[radioInfo.lastFreq] or self.color), string.format(self.format, channel, name, text))
	end
})

--Radios must have at least one primary channel, and can have two additional channels past that.

ix.command.Add("r", {
	description = "Radio over your primary frequency.",
	superAdminOnly = false,
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, text)
		local char = client:GetCharacter()
		local radioInfo = char:GetData("RadioInfo")

		if (radioInfo) then
			radioInfo.lastFreq = radioInfo.freqList[1]
			char:SetData("RadioInfo", radioInfo) 

			ix.chat.Send(client, "radio", text, false, nil, nil)

			client:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
		end
	end
})

ix.command.Add("r1", {
	description = "Radio over additional channel 1.",
	superAdminOnly = false,
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, text)
		local char = client:GetCharacter()
		local radioInfo = char:GetData("RadioInfo")

		if (radioInfo and #radioInfo.freqList > 1) then
			radioInfo.lastFreq = radioInfo.freqList[2]
			char:SetData("RadioInfo", radioInfo) 

			ix.chat.Send(client, "radio", text, false, nil, nil)

			client:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
		end
	end
})

ix.command.Add("r2", {
	description = "Radio over additional channel 2.",
	superAdminOnly = false,
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, text)
		local char = client:GetCharacter()
		local radioInfo = char:GetData("RadioInfo")

		if (radioInfo and #radioInfo.freqList > 2) then
			radioInfo.lastFreq = radioInfo.freqList[3]
			char:SetData("RadioInfo", radioInfo) 

			ix.chat.Send(client, "radio", text, false, nil, nil)

			client:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
		end
	end
})

function PLUGIN:HUDPaint() -- Draws the channels in the top right.
	local scrw = ScrW()
	local char = LocalPlayer():GetCharacter()

	--draw.SimpleText("⮟★", "Trebuchet24", scrw - 50, 50, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

	if (char and char:GetData("RadioInfo")) then
		local freqList = char:GetData("RadioInfo").freqList
		draw.SimpleText("Frequencies: " .. table.concat(freqList, ", "), "BudgetLabel", scrw - 50, 0, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
	end
end