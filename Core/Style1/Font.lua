-- ============================================================
-- Vermilion
-- Style/Font.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

function V.SetFont(fontString, size, style, font)
	if not fontString then return end

	fontString:SetFont(font or V.GetStyleFont(), size or C.Media.Font_Size or 12, style or V.GetStyleFontFlag())
	fontString:SetShadowColor(0, 0, 0, 0)
	fontString:SetShadowOffset(0, 0)
end

function V.CreateFontString(parent, size, text, style)
	if not parent then return end

	local fs = parent:CreateFontString(nil, "OVERLAY")
	V.SetFont(fs, size, style)
	fs:SetText(text or "")
	fs:SetJustifyH("CENTER")

	return fs
end

-- old compatibility
V.SetFontString = V.SetFontString or function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName or V.GetStyleFont(), fontHeight or 12, fontStyle or V.GetStyleFontFlag())
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0, 0)
	fs:SetShadowOffset(0, 0)

	return fs
end
