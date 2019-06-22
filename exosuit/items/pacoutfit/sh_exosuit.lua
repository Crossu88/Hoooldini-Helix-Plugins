ITEM.name = "Military Exo-skeleton"
ITEM.description = "A military exo-skeleton designed to enhances the wearer's movement."
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "exosuit"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Skin"] = 0,
					["Invert"] = false,
					["LightBlend"] = 1,
					["CellShade"] = 0,
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["IgnoreZ"] = false,
					["AimPartUID"] = "",
					["Passes"] = 1,
					["Name"] = "skeleton",
					["NoTextureFiltering"] = false,
					["DoubleFace"] = false,
					["PositionOffset"] = Vector(0, 0, 0),
					["IsDisturbing"] = false,
					["Fullbright"] = false,
					["EyeAngles"] = false,
					["DrawOrder"] = 0,
					["TintColor"] = Vector(0, 0, 0),
					["UniqueID"] = "3683478860",
					["Translucent"] = false,
					["LodOverride"] = -1,
					["BlurSpacing"] = 0,
					["Alpha"] = 1,
					["Material"] = "",
					["UseWeaponColor"] = false,
					["UsePlayerColor"] = false,
					["UseLegacyScale"] = false,
					["Bone"] = "head",
					["Color"] = Vector(255, 255, 255),
					["Brightness"] = 1,
					["BoneMerge"] = true,
					["BlurLength"] = 0,
					["Position"] = Vector(0, 0, 0),
					["AngleOffset"] = Angle(0, 0, 0),
					["AlternativeScaling"] = false,
					["Hide"] = false,
					["OwnerEntity"] = false,
					["Scale"] = Vector(1, 1, 1),
					["ClassName"] = "model",
					["EditorExpand"] = false,
					["Size"] = 1,
					["ModelFallback"] = "",
					["Angles"] = Angle(0, 0, 0),
					["TextureFilter"] = 3,
					["Model"] = "models/player/sold/aa.mdl",
					["BlendMode"] = "",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "3629330432",
			["AimPartUID"] = "",
			["Hide"] = false,
			["Duplicate"] = false,
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["IsDisturbing"] = false,
			["Name"] = "exosuit",
			["EditorExpand"] = true,
		},
	},
}

function ITEM:OnEquipped()
	local client = self.player
	local char = client:GetCharacter()

	char:AddBoost("exostr", "agi", 10)
	char:AddBoost("exoagi", "agi", 10)
	char:SetData("exosuit", true)
end

function ITEM:OnUnequipped()
	local client = self.player
	local char = client:GetCharacter()

	char:AddBoost("exostr", "agi")
	char:AddBoost("exoagi", "agi")
	char:SetData("exosuit", false)
end