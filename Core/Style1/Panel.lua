-- ============================================================
-- Vermilion
-- Style/Panel.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame

function V.CreatePanel(parent, name, width, height, point, relativeTo, relativePoint, x, y, alpha)
	local frame = CreateFrame("Frame", name, parent or UIParent)

	if width and height then
		frame:SetSize(width, height)
	end

	if point then
		frame:SetPoint(point, relativeTo or parent or UIParent, relativePoint or point, x or 0, y or 0)
	end

	V.SetBackdrop(frame, alpha)

	return frame
end
