ATTRIBUTE.name = "Constitution"
ATTRIBUTE.description = "Your body's ability to endure trauma and remain healthy."

function ATTRIBUTE:OnSetup(client, value)
	client:SetMaxHealth(ix.config.Get("defaultMaxHealth") + (value * ix.config.Get("constitutionMultiplier")))
end