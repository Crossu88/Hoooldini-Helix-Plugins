
ITEM.name = "Deployables Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A deployable."
ITEM.category = "Deployables"
ITEM.class = "ent_jack_turret_rifle"

ITEM.functions.use = {
	name = "Deploy",
	tip = "useTip",
	icon = "icon16/add.png",
	OnRun = function(item)
		local trace = item.player:GetEyeTrace()
		local pos, ang = trace.HitPos, trace.HitNormal:Angle()

		local ent = ents.Create(item.class)
		ent:SpawnFunction(item.player, trace)

		return true
	end,
}
