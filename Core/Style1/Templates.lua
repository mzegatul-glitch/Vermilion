-- ============================================================
-- Vermilion
-- Style/Templates.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

V.Style = V.Style or {}

V.Style.Backdrops = {
	Default = {
		bgFile = C.Media.Blank,
		edgeFile = C.Media.Blizz,
		edgeSize = 14,
		insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 },
	},

	Pixel = {
		bgFile = C.Media.Blank,
		edgeFile = C.Media.Blank,
		edgeSize = V.Mult or 1,
		insets = { left = V.Mult or 1, right = V.Mult or 1, top = V.Mult or 1, bottom = V.Mult or 1 },
	},

	BorderOnly = {
		edgeFile = C.Media.Blizz,
		edgeSize = 14,
		insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 },
	},

	Shadow = {
		edgeFile = C.Media.Glow,
		edgeSize = 3,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	},
}

-- Old compatibility
V.Backdrop = V.Backdrop or V.Style.Backdrops.Default
V.Border = V.Border or V.Style.Backdrops.BorderOnly
V.PixelBorder = V.PixelBorder or V.Style.Backdrops.Pixel
V.ShadowBackdrop = V.ShadowBackdrop or V.Style.Backdrops.Shadow

function V.GetStyleTexture()
	return C.Media.Texture or C.Media.Blank or "Interface\\Buttons\\WHITE8X8"
end

function V.GetStyleFont()
	return C.Media.Font or "Fonts\\ARIALN.ttf"
end

function V.GetStyleFontFlag()
	return C.Media.Font_Style or ""
end

function V.GetBackdropColor(alpha)
	local r, g, b, a = unpack(C.Media.Backdrop_Color or {0.02, 0.02, 0.02, 0.8})
	return r, g, b, alpha or a or 0.8
end

function V.GetBorderColor()
	return unpack(C.Media.Border_Color or {0.6, 0.6, 0.6, 1})
end

function V.GetClassColor()
	if V.Color then
		return V.Color.r or V.Color[1] or 1, V.Color.g or V.Color[2] or 1, V.Color.b or V.Color[3] or 1
	end

	return V.GetBorderColor()
end
