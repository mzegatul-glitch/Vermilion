-- ============================================================
-- Vermilion
-- Style/Texture.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

function V.CreateOverlay(frame, alpha)
	if not frame or frame.Overlay then return frame and frame.Overlay end

	local overlay = frame:CreateTexture(nil, "BORDER")
	overlay:SetAllPoints(frame)
	overlay:SetTexture(C.Media.Blank)
	overlay:SetVertexColor(0, 0, 0, alpha or 0.25)

	frame.Overlay = overlay
	frame.overlay = frame.overlay or overlay

	return overlay
end

function V.CreateBackground(frame, r, g, b, a)
	if not frame then return end

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(frame)
	bg:SetTexture(C.Media.Blank)
	bg:SetVertexColor(r or 0, g or 0, b or 0, a or 0.7)

	return bg
end

function V.BG(parent, r, g, b, a)
	return V.CreateBackground(parent, r, g, b, a)
end

function V.HL(parent, r, g, b, a)
	if not parent then return end

	local hl = parent:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints(parent)
	hl:SetTexture(V.GetStyleTexture())
	hl:SetVertexColor(r or 1, g or 1, b or 1, a or 0.18)

	return hl
end
