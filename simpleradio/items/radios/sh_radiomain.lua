ITEM.name = "Radio"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.description = "A radio channel with the frequencies: main, command, and support"
ITEM.defaultFreq = "main" -- The default frequency the player will be set to
ITEM.freqList = { -- Radios can only support one main channel, and two additional channels.
	"main",
	"command",
	"support"
}