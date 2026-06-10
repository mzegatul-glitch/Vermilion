-- ============================================================
-- Vermilion
-- Style/StatusBar.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame

function V.StyleStatusBar(bar)
	if not bar or bar.VermilionStyled then return end

	bar:SetStatusBarTexture(V.GetStyleTexture())

	if not bar.Backdrop then
		V.CreateBackdrop(bar, 0.8)
	end

	bar.VermilionStyled = true
end

function V.CreateStatusBar(parent, width, height)
	local bar = CreateFrame("StatusBar", nil, parent)
	bar:SetSize(width or 100, height or 12)
	bar:SetMinMaxValues(0, 1)
	bar:SetValue(1)

	V.StyleStatusBar(bar)

	return bar
end
