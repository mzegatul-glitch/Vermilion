-- ============================================================
-- Vermilion
-- Style/Border.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame
local pairs = pairs

function V.CreateSimpleBorder(frame, template, offset)
	if not frame or frame.SimpleBorder then return frame and frame.SimpleBorder end

	offset = offset or 2

	local border = CreateFrame("Frame", nil, frame)
	border:SetPoint("TOPLEFT", frame, "TOPLEFT", -offset, offset)
	border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", offset, -offset)
	border:SetFrameLevel((frame:GetFrameLevel() or 1) + 1)
	border:SetFrameStrata(frame:GetFrameStrata())

	V.SetTemplate(border, template or "BorderOnly", 0)

	frame.SimpleBorder = border
	frame.border = frame.border or border

	return border
end

-- If Core/Border.lua has a stronger texture-border V.CreateBorder, keep it.
if not V.CreateBorder then
	function V.CreateBorder(frame, template, offset)
		return V.CreateSimpleBorder(frame, template, offset)
	end
end

function V.SetBorderColor(frame, r, g, b, a)
	if not frame then return end

	if frame.SetBackdropBorderColor then
		frame:SetBackdropBorderColor(r, g, b, a or 1)
	end

	if frame.border and frame.border.SetBackdropBorderColor then
		frame.border:SetBackdropBorderColor(r, g, b, a or 1)
	end

	if frame.SimpleBorder and frame.SimpleBorder.SetBackdropBorderColor then
		frame.SimpleBorder:SetBackdropBorderColor(r, g, b, a or 1)
	end

	if frame.BorderTextures then
		for _, tex in pairs(frame.BorderTextures) do
			tex:SetVertexColor(r, g, b, a or 1)
		end
	end
end

function V.ResetBorderColor(frame)
	if not frame then return end

	local r, g, b, a = V.GetBorderColor()
	V.SetBorderColor(frame, r, g, b, a)
end
