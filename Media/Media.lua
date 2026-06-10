-- ============================================================
-- Vermilion
-- Media/Media.lua
-- Media Registry
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local LibStub = LibStub
local pairs = pairs

local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
local path = "Interface\\AddOns\\Vermilion\\Media\\"

V.Media = V.Media or {}

-- ============================================================
-- Fonts
-- ============================================================

V.Media.Fonts = {
	Default = path .. "Fonts\\Kimberley.ttf",
	Symbol  = path .. "Fonts\\Symbola.ttf",
}

-- ============================================================
-- Borders
-- ============================================================

V.Media.Borders = {
	Vermilion = path .. "Border\\Vermilion.blp",
	Glow      = path .. "Border\\Vermilion_Glow.blp",
	Pixel     = "Interface\\Buttons\\WHITE8X8",
}

-- ============================================================
-- Textures
-- ============================================================

V.Media.Textures = {
	Blank          = path .. "Textures\\Blank.tga",
	Empty          = path .. "Textures\\Empty.tga",
	Mail           = path .. "Textures\\Mail.tga",
	StatusBar      = path .. "Textures\\StatusBar.blp",
	GroupIndicator = path .. "Textures\\GroupIndicator.blp",
	GoldDragon     = path .. "Textures\\GoldDragon.png",
}

-- ============================================================
-- Unitframes
-- ============================================================

V.Media.StatusBar = {	Vermilion = path .. "Unitframes\\Vermilion.blp",}

-- ============================================================
-- Raid Icons
-- ============================================================

V.Media.RaidIcons = {
	Tank   = path .. "RaidIcons\\Tank.tga",
	Healer = path .. "RaidIcons\\Healer.tga",
	DPS    = path .. "RaidIcons\\DPS.tga",
}

-- ============================================================
-- Sounds
-- ============================================================

V.Media.Sounds = {
	Proc    = path .. "Sounds\\Proc.ogg",
	Warning = path .. "Sounds\\Warning.ogg",
	Whisper = path .. "Sounds\\Whisper.ogg",
}

-- ============================================================
-- Backward Compatibility
-- Old C.Media keys still work
-- ============================================================

C.Media = C.Media or {}

C.Media.Blank        = V.Media.Textures.Blank
C.Media.Texture      = V.Media.Textures.StatusBar
C.Media.Font         = V.Media.Fonts.Default
C.Media.SymbolFont   = V.Media.Fonts.Symbol
C.Media.Blizz        = V.Media.Borders.Vermilion
C.Media.Border_Glow  = V.Media.Borders.Glow
C.Media.Glow         = V.Media.Borders.Glow
C.Media.Proc_Sound   = V.Media.Sounds.Proc
C.Media.Warning_Sound= V.Media.Sounds.Warning
C.Media.Whisp_Sound  = V.Media.Sounds.Whisper

-- ============================================================
-- LibSharedMedia Register
-- ============================================================

if LSM then
	for name, mediaPath in pairs(V.Media.Fonts) do
		LSM:Register("font", "Vermilion_" .. name, mediaPath)
	end

	for name, mediaPath in pairs(V.Media.Borders) do
		LSM:Register("border", "Vermilion_" .. name, mediaPath)
	end

	for name, mediaPath in pairs(V.Media.Textures) do
		LSM:Register("statusbar", "Vermilion_" .. name, mediaPath)
	end

	for name, mediaPath in pairs(V.Media.Sounds) do
		LSM:Register("sound", "Vermilion_" .. name, mediaPath)
	end
end
