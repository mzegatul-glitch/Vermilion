-- ============================================================
-- Vermilion
-- Style/ScrollBar.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame

function V.StyleScrollBar(scrollbar)
	if not scrollbar or scrollbar.VermilionStyled then return end

	V.SetBackdrop(scrollbar)

	local thumb = scrollbar:GetThumbTexture()
	if thumb then
		thumb:SetTexture(V.GetStyleTexture())
		thumb:SetSize(12, 20)
		thumb:SetVertexColor(0.5, 0.5, 0.5, 1)
	end

	scrollbar.VermilionStyled = true
end

function V.CreateScrollBar(parent, width)
	local sb = CreateFrame("Slider", nil, parent)
	sb:SetWidth(width or 14)
	sb:SetOrientation("VERTICAL")
	sb:SetValueStep(1)
	sb:SetMinMaxValues(0, 1)
	sb:SetValue(0)
	sb:EnableMouseWheel(true)

	V.StyleScrollBar(sb)

	return sb
end
