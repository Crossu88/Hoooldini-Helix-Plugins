ATTRIBUTE.name = "Agility"
ATTRIBUTE.description = "Your ability to move with speed and dexterity."

function ATTRIBUTE:OnSetup(client, value)
	client:SetRunSpeed(ix.config.Get("runSpeed") + (value * ix.config.Get("agilityMultiplier")))
end
