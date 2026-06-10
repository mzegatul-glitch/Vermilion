-- ============================================================
-- Vermilion
-- Style/Backdrop.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame
local max = math.max

function V.SetTemplate(frame, template, alpha)
	if not frame then return end

	template = template or "Default"

	local backdrop = V.Style.Backdrops[template] or V.Style.Backdrops.Default

	frame:SetBackdrop(backdrop)

	local r, g, b, a = V.GetBackdropColor(alpha)
	frame:SetBackdropColor(r, g, b, a)

	frame:SetBackdropBorderColor(V.GetBorderColor())
end

function V.SetBackdrop(frame, alpha, template)
	if not frame then return end
	V.SetTemplate(frame, template or "Default", alpha)
end

function V.CreateBackdrop(frame, alpha, template, offset)
	if not frame or frame.Backdrop then return frame and frame.Backdrop end

	offset = offset or 2

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", offset, -offset)
	bg:SetFrameLevel(max((frame:GetFrameLevel() or 1) - 1, 0))
	bg:SetFrameStrata(frame:GetFrameStrata())

	V.SetTemplate(bg, template or "Default", alpha)

	frame.Backdrop = bg
	frame.backdrop = frame.backdrop or bg

	return bg
end
