-- ============================================================
-- Vermilion
-- Style/Slider.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

function V.StyleSlider(slider)
	if not slider or slider.VermilionStyled then return end

	V.SetBackdrop(slider)

	local thumb = slider:GetThumbTexture()
	if thumb then
		thumb:SetTexture(V.GetStyleTexture())
		thumb:SetSize(12, 18)
		thumb:SetVertexColor(V.GetClassColor())
	end

	slider.VermilionStyled = true
end
