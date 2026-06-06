local V, C, L, _ = select(2, ...):unpack()
if C.Skins.WorldMap ~= true or IsAddOnLoaded("Mapster") or IsAddOnLoaded("Aurora") then return end

local floor = math.floor
local select = select
local CreateFrame = CreateFrame
local GetPlayerMapPosition = GetPlayerMapPosition
local IsInInstance = IsInInstance
local GetCursorPosition = GetCursorPosition
local GetUnitSpeed = GetUnitSpeed

-- WorldMap tweaks
if not InCombatLockdown() then
	local WorldMap_Tweak = CreateFrame("Frame")

	WorldMap_Tweak:RegisterEvent("PLAYER_LOGIN")
	WorldMap_Tweak:SetScript("OnEvent", function()
		BlackoutWorld:Hide()
	end)

	BlackoutWorld:Hide()

	WorldMapFrame:EnableKeyboard(false)
	WorldMapFrame:EnableMouse(true)
	WorldMapFrame:SetAttribute("UIPanelLayout-area", "center")
	WorldMapFrame:SetAttribute("UIPanelLayout-allowOtherPanels", true)

	UIPanelWindows["WorldMapFrame"] = { area = "center" }

	BlackoutWorld.Show = function()
		UIPanelWindows["WorldMapFrame"] = { area = "center" }
		WorldMapFrame:EnableKeyboard(false)
		WorldMapFrame:EnableMouse(true)
		WorldMapFrame:SetAttribute("UIPanelLayout-area", "center")
		WorldMapFrame:SetAttribute("UIPanelLayout-allowOtherPanels", true)
	end

	WorldMapFrame:HookScript("OnShow", function(self)
		self:SetScale(1.17)
		self:SetAlpha(0.90)
		if WorldMapTooltip then
			WorldMapTooltip:SetScale(1 / 0.80)
		end
	end)

	-- Shift + Drag Move
	WorldMapFrame:SetMovable(true)
	WorldMapFrame:SetClampedToScreen(true)
	WorldMapFrame:RegisterForDrag("LeftButton")

	WorldMapFrame:SetScript("OnDragStart", function(self)
		if IsShiftKeyDown() then
			self:StartMoving()
		end
	end)

	WorldMapFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	-- Resize Button
	local resize = CreateFrame("Button", nil, WorldMapFrame)
	resize:SetPoint("BOTTOMRIGHT", -6, 6)
	resize:SetSize(24, 24)

	resize.tex = resize:CreateTexture(nil, "OVERLAY")
	resize.tex:SetAllPoints()
	resize.tex:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")

	resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

	local startScale, startX

	resize:SetScript("OnMouseDown", function(self)
		startScale = WorldMapFrame:GetScale()
		startX = GetCursorPosition()

		self:SetScript("OnUpdate", function()
			local x = GetCursorPosition()
			local diff = (x - startX) / 700

			local newScale = startScale + diff

			if newScale < 0.7 then
				newScale = 0.7
			elseif newScale > 2 then
				newScale = 2
			end

			WorldMapFrame:SetScale(newScale)
		end)
	end)

	resize:SetScript("OnMouseUp", function(self)
		self:SetScript("OnUpdate", nil)
	end)

	-- Mousewheel Zoom
	WorldMapFrame:EnableMouseWheel(true)
	WorldMapFrame:SetScript("OnMouseWheel", function(self, delta)
		local scale = self:GetScale()

		if delta > 0 then
			scale = scale + 0.05
		else
			scale = scale - 0.05
		end

		if scale < 0.7 then
			scale = 0.7
		elseif scale > 2 then
			scale = 2
		end

		self:SetScale(scale)
	end)
end

-- Coordinates
local WorldMap_Coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
local Font_Height = select(2, WorldMapQuestShowObjectivesText:GetFont()) * 1.1

WorldMap_Coords:SetFrameLevel(90)
WorldMap_Coords:FontString("PlayerText", C.Media.Font, Font_Height, C.Media.Font_Style)
WorldMap_Coords:FontString("MouseText", C.Media.Font, Font_Height, C.Media.Font_Style)

WorldMap_Coords.PlayerText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
WorldMap_Coords.MouseText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())

WorldMap_Coords.PlayerText:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "BOTTOMLEFT", 5, 5)
WorldMap_Coords.MouseText:SetPoint("BOTTOMLEFT", WorldMap_Coords.PlayerText, "TOPLEFT", 0, 5)

local int = 0

WorldMapFrame:HookScript("OnUpdate", function()
	int = int + 1

	if int >= 3 then
		local x, y = GetPlayerMapPosition("player")

		x = floor(100 * x)
		y = floor(100 * y)

		if x ~= 0 and y ~= 0 then
			WorldMap_Coords.PlayerText:SetText(PLAYER .. ": " .. x .. ", " .. y)
		else
			WorldMap_Coords.PlayerText:SetText(" ")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local cx, cy = GetCursorPosition()

		local adjustedX = (cx / scale - (centerX - (width / 2))) / width
		local adjustedY = (centerY + (height / 2) - cy / scale) / height

		if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
			adjustedX = floor(100 * adjustedX)
			adjustedY = floor(100 * adjustedY)

			WorldMap_Coords.MouseText:SetText(MOUSE_LABEL .. ": " .. adjustedX .. ", " .. adjustedY)
		else
			WorldMap_Coords.MouseText:SetText(" ")
		end

		int = 0
	end
end)

-- Fade while moving
local fader = CreateFrame("Frame")
local moving = false

fader:SetScript("OnUpdate", function()
	if not WorldMapFrame:IsShown() then return end

	local speed = GetUnitSpeed("player")

	if speed and speed > 0 then
		if not moving then
			UIFrameFadeOut(WorldMapFrame, 0.3, WorldMapFrame:GetAlpha(), 0.35)
			moving = true
		end
	else
		if moving then
			UIFrameFadeIn(WorldMapFrame, 0.3, WorldMapFrame:GetAlpha(), 0.90)
			moving = false
		end
	end
end)

-- Party/Raid class icons
local function UpdateBlip(frame)
	if not frame or not frame.unit or not frame.icon then return end

	local _, class = UnitClass(frame.unit)
	if not class then return end

	frame.icon:SetTexture("Interface\\TARGETINGFRAME\\UI-Classes-Circles")

	local coords = CLASS_ICON_TCOORDS[class]
	if coords then
		frame.icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	end
end

for i = 1, MAX_PARTY_MEMBERS do
	local frame = _G["WorldMapParty" .. i]
	if frame then
		frame:HookScript("OnShow", UpdateBlip)
	end
end

for i = 1, MAX_RAID_MEMBERS do
	local frame = _G["WorldMapRaid" .. i]
	if frame then
		frame:HookScript("OnShow", UpdateBlip)
	end
end

-- Dropdown fix
WorldMapContinentDropDownButton:HookScript("OnClick", function()
	DropDownList1:SetScale(C.General.UIScale)
end)

WorldMapZoneDropDownButton:HookScript("OnClick", function(self)
	DropDownList1:SetScale(C.General.UIScale)
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 2, -4)
end)
