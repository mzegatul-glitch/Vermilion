-- ============================================================
-- Vermilion
-- Style/CheckBox.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local function ResizeTexture(tex, size)
	if tex then
		tex:SetSize(size, size)
	end
end

function V.StyleCheckBox(check, size)
	if not check or check.VermilionStyled then return end

	size = size or 16
	check:SetSize(size, size)

	ResizeTexture(check:GetNormalTexture(), size)
	ResizeTexture(check:GetPushedTexture(), size)
	ResizeTexture(check:GetHighlightTexture(), size)
	ResizeTexture(check:GetCheckedTexture(), size)
	ResizeTexture(check:GetDisabledCheckedTexture(), size)

	check.VermilionStyled = true
end
