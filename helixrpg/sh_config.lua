-- [[ CONFIGURATION OPTIONS ]] --

ix.config.Add("startingAttributePoints", 10, "The starting amount of attribute points a character has on creation.", nil, {
	data = { min = 0, max = 30 },
	category = "characters"
})

ix.config.Add("startingSkillPoints", 20, "The starting amount of attribute points a character has on creation.", nil, {
	data = { min = 0, max = 100 },
	category = "characters"
})

ix.config.Add("startingTraits", 3, "The starting amount of attribute points a character has on creation.", nil, {
	data = { min = 0, max = 10 },
	category = "characters"
})

ix.config.Add("maxAttributes", 5, "The max amount of points a attribute can have by default.", nil, {
	data = {min = 0, max = 100},
	category = "characters"
})

ix.config.Add("maxSkills", 10, "The max amount of points a skill can have by default.", nil, {
	data = { min = 0, max = 100 },
	category = "characters"
})