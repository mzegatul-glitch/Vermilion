local V, C, L, _ = select(2, ...):unpack()
if C.Minimap.Enable ~= true then return end

local _G = _G
local unpack = unpack
local pairs = pairs
local tonumber = tonumber
local IsAddOnLoaded = IsAddOnLoaded
local Mail = MiniMapMailFrame
local MailBorder = MiniMapMailBorder
local MailIcon = MiniMapMailIcon
local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

-- Minimap anchor frame
local MinimapAnchor = CreateFrame("Frame", "MinimapAnchor", UIParent)
MinimapAnchor:CreatePanel("ClassColor", C.Minimap.Size, C.Minimap.Size, unpack(C.Position.Minimap))

-- Hidden frames
local HiddenFrames = {
    "GameTimeFrame",
    "MinimapBorder",
    "MinimapCluster",
    "MinimapZoomIn",
    "MinimapZoomOut",
    "MinimapBorderTop",
    "BattlegroundShine",
    "MiniMapWorldMapButton",
    "MinimapZoneTextButton",
    "MiniMapTrackingBackground",
    "MiniMapVoiceChatFrameBackground",
    "MiniMapVoiceChatFrameBorder",
    "MiniMapVoiceChatFrame",
    "MinimapNorthTag",
    "MiniMapBattlefieldBorder",
    "MiniMapMailBorder",
    "MiniMapTracking",
}

for i, FrameName in pairs(HiddenFrames) do
    local Frame = _G[FrameName]
    Frame:Hide()

    if Frame.UnregisterAllEvents then
        Frame:UnregisterAllEvents()
    end
end

-- Clear North tag texture (outside loop - one call only)
local North = _G["MinimapNorthTag"]
if North then
    North:SetTexture(nil)
end

-- Parent Minimap into our frame
Minimap:SetParent(MinimapAnchor)
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPLEFT", MinimapAnchor, "TOPLEFT", 0, 0)
Minimap:SetPoint("BOTTOMRIGHT", MinimapAnchor, "BOTTOMRIGHT", 0, 0)
Minimap:SetSize(MinimapAnchor:GetWidth(), MinimapAnchor:GetWidth())

-- Backdrop
MinimapBackdrop:ClearAllPoints()
MinimapBackdrop:SetPoint("TOPLEFT", MinimapAnchor, "TOPLEFT", 2, -2)
MinimapBackdrop:SetPoint("BOTTOMRIGHT", MinimapAnchor, "BOTTOMRIGHT", -2, 2)
MinimapBackdrop:SetSize(MinimapAnchor:GetWidth(), MinimapAnchor:GetWidth())

-- Mail icon
Mail:ClearAllPoints()
Mail:SetPoint("TOPRIGHT", Minimap, 6, 10)
Mail:SetFrameLevel(Minimap:GetFrameLevel() + 2)
Mail:SetScale(1.2)
MailBorder:Hide()
MailIcon:SetTexture("Interface\\Addons\\Vermilion\\Media\\Textures\\Mail")

-- Battlefield frame
MiniMapBattlefieldFrame:SetParent(Minimap)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", 4, -4)

-- Instance difficulty
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- Calendar invites icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent(Minimap)
GameTimeCalendarInvitesTexture:SetPoint("BOTTOM", 0, 5)

-- LFG icon
local function UpdateLFG()
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -2)
    MiniMapLFGFrameBorder:Hide()
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)

-- Mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
    if delta > 0 then
        MinimapZoomIn:Click()
    elseif delta < 0 then
        MinimapZoomOut:Click()
    end
end)

-- Clock
if not IsAddOnLoaded("Blizzard_TimeManager") then
    LoadAddOn("Blizzard_TimeManager")
end

local ClockFrame, ClockTime = TimeManagerClockButton:GetRegions()
ClockFrame:Hide()
ClockTime:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
ClockTime:SetShadowOffset(0, 0)
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -5)
TimeManagerClockButton:SetScript("OnShow", nil)
TimeManagerClockButton:Hide()
TimeManagerClockButton:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        if self.alarmFiring then
            PlaySound("igMainMenuQuit")
            TimeManager_TurnOffAlarm()
        else
            ToggleTimeManager()
        end
    else
        ToggleCalendar()
    end
end)

-- Square minimap shape for other addons
function GetMinimapShape()
    return "SQUARE"
end

-- Border texture
MinimapBackdrop:SetBackdrop(V.Backdrop)
MinimapBackdrop:SetBackdropColor(0.05, 0.05, 0.05, 0)
MinimapBackdrop:SetBackdropBorderColor(unpack(C.Media.Border_Color))
MinimapBackdrop:SetOutside(Minimap, 3, 3)

-- Square mask (hide round border)
Minimap:SetMaskTexture(C.Media.Blank)
MinimapBorder:Hide()

-- WorldMap scale
WorldMapFrame:HookScript("OnShow", function(self)
    self:SetScale(1.3)
end)

-- Minimap size update function (called from config when size changes)
function UpdateMinimapSize()
    if not MinimapAnchor then return end

    local size = tonumber(C.Minimap.Size) or 150

    MinimapAnchor:SetWidth(size)
    MinimapAnchor:SetHeight(size)
    Minimap:SetSize(size, size)

    MinimapBackdrop:ClearAllPoints()
    MinimapBackdrop:SetPoint("TOPLEFT", MinimapAnchor, "TOPLEFT", 2, -2)
    MinimapBackdrop:SetPoint("BOTTOMRIGHT", MinimapAnchor, "BOTTOMRIGHT", -2, 2)
    MinimapBackdrop:SetSize(size, size)

    MinimapBackdrop:SetBackdrop(V.Backdrop)
    MinimapBackdrop:SetBackdropColor(0.05, 0.05, 0.05, 0)
    MinimapBackdrop:SetBackdropBorderColor(unpack(C.Media.Border_Color))
    MinimapBackdrop:SetOutside(Minimap, 3, 3)
end

-- Initialize on ADDON_LOADED
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
    if addon == "Vermilion" then
        UpdateMinimapSize()
        self:UnregisterEvent("ADDON_LOADED") -- only need once
    end
end)
