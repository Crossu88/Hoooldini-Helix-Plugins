local PLUGIN = PLUGIN

PLUGIN.name = "Faction Items"
PLUGIN.author = "Hoooldini"
PLUGIN.description = "Spawns players with faction items."

function PLUGIN:OnCharacterCreated(client, character)
	local faction = ix.faction.Get(character:GetFaction())

	if (faction and faction.Items) then
		for _, v in pairs(faction.Items) do
			character:GetInventory():Add(v, 1)
		end
	end
end