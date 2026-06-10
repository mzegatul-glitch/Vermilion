-- ============================================================
-- Vermilion
-- Style/API.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame
local ipairs = ipairs
local getmetatable = getmetatable

function V.SetOutside(obj, anchor, xOffset, yOffset)
	if not obj then return end

	anchor = anchor or obj:GetParent()
	xOffset = xOffset or 2
	yOffset = yOffset or xOffset

	obj:ClearAllPoints()
	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

function V.SetInside(obj, anchor, xOffset, yOffset)
	if not obj then return end

	anchor = anchor or obj:GetParent()
	xOffset = xOffset or 2
	yOffset = yOffset or xOffset

	obj:ClearAllPoints()
	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

local handled = {}

local function AddAPI(object)
	if not object or handled[object] then return end

	local mt = getmetatable(object).__index
	if not mt then return end

	mt.SetOutside = mt.SetOutside or V.SetOutside
	mt.SetInside = mt.SetInside or V.SetInside

	if V.SetTemplate then mt.SetTemplate = mt.SetTemplate or V.SetTemplate end
	if V.CreateBackdrop then mt.CreateBackdrop = mt.CreateBackdrop or V.CreateBackdrop end
	if V.CreateOverlay then mt.CreateOverlay = mt.CreateOverlay or V.CreateOverlay end
	if V.StyleButton then mt.StyleButton = mt.StyleButton or V.StyleButton end
	if V.StyleCheckBox then mt.StyleCheckBox = mt.StyleCheckBox or V.StyleCheckBox end
	if V.StyleEditBox then mt.StyleEditBox = mt.StyleEditBox or V.StyleEditBox end

	handled[object] = true
end

local objectTypes = {
	"Frame",
	"Button",
	"CheckButton",
	"EditBox",
	"Slider",
	"StatusBar",
}

for _, objectType in ipairs(objectTypes) do
	AddAPI(CreateFrame(objectType))
end
