-- [[ HOOKS ]] --

function PLUGIN:GetMaximumAttributePoints()

	return ix.config.Get( "maxAttributes", 5 )

end

function PLUGIN:GetMaximumSkillPoints()

	return ix.config.Get( "maxSkills", 10 )

end

function PLUGIN:GetDefaultTraitPoints()

	return ix.config.Get( "maxTraits", 3 )

end

function PLUGIN:GetDefaultAttributePoints( client )

	return ix.config.Get( "startingAttributePoints", 10 )

end

function PLUGIN:GetDefaultSkillPoints( client )

	return ix.config.Get( "startingSkillPoints", 20 )

end

function PLUGIN:PlayerDeath( victim, inflictor, attacker )
	local character = victim:GetCharacter()
	local bonus = character:GetAttribute("con", 0)
	local roll = tostring(math.random(0, 100))

	local receivers = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsAdmin() or v:IsSuperAdmin() then
			table.insert(receivers, v)
		end
	end

	ix.chat.Send(victim, "roll", (roll + bonus).." ( "..roll.." + "..bonus.." ) for their Injury Saving Throw", nil, receivers, { max = maximum })
end