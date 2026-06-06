local V, C, L, _ = select(2, ...):unpack()

-- 3.3.5а Секюр Арена Фрейм модуль
local _G = _G
local CreateFrame, UIParent = CreateFrame, UIParent
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitPower, UnitPowerMax = UnitPower, UnitPowerMax
local UnitName, UnitClass, UnitExists = UnitName, UnitClass, UnitExists
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

-- 1. АНКЕР ФРЕЙМ (Глобаль)
ArenaFrameAnchor = CreateFrame("Frame", "ArenaFrameAnchor", UIParent)
ArenaFrameAnchor:SetSize(150, 220)
ArenaFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -200, -250)
ArenaFrameAnchor.DefaultPoint = { "TOPRIGHT", "UIParent", "TOPRIGHT", -200, -250 }

local function UpdateArenaFrame(self)
    local unit = self.unit
    if not unit or not UnitExists(unit) then return end
    
    -- Хүний цус мана шинэчлэх
    self.Health:SetMinMaxValues(0, UnitHealthMax(unit))
    self.Health:SetValue(UnitHealth(unit))
    self.Power:SetMinMaxValues(0, UnitPowerMax(unit))
    self.Power:SetValue(UnitPower(unit))
    
    local name = UnitName(unit)
    local _, class = UnitClass(unit)
    local color = RAID_CLASS_COLORS[class]
    
    self.Name:SetText(name)
    if color then self.Name:SetTextColor(color.r, color.g, color.b) end
end

local function OnArenaEvent(self, event, ...)
    local arg1 = ...
    if event == "PLAYER_ENTERING_WORLD" or event == "ARENA_OPPONENT_UPDATE" then
        if UnitExists(self.unit) then
            self:Show()
            UpdateArenaFrame(self)
        else
            self:Hide()
        end
    elseif arg1 == self.unit then
        UpdateArenaFrame(self)
    end
end

-- 5 дайсны фрейм үүсгэх
local arenaFrames = {}
for i = 1, 5 do
    local unit = "arena"..i
    local frame = CreateFrame("Button", "VermilionArenaFrame"..i, UIParent, "SecureUnitButtonTemplate")
    frame:SetSize(140, 32)
    frame.unit = unit
    
    if i == 1 then
        frame:SetPoint("TOPLEFT", ArenaFrameAnchor, "TOPLEFT", 0, 0)
    else
        frame:SetPoint("TOPLEFT", arenaFrames[i-1], "BOTTOMLEFT", 0, -10)
    end
    
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("type1", "target")
    frame:SetAttribute("unit", unit)
    
    frame:SetBackdrop(V.Backdrop)
    frame:SetBackdropColor(unpack(C.Media.Backdrop_Color))
    frame:SetBackdropBorderColor(unpack(C.Media.Border_Color or {0.15, 0.15, 0.15, 1}))
    
    local health = CreateFrame("StatusBar", nil, frame)
    health:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    health:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 10)
    health:SetStatusBarTexture(C.Media.Texture or "Interface\\TargetingFrame\\UI-StatusBar")
    health:SetStatusBarColor(0.8, 0.2, 0.2) -- Дайсан учраас Улаан өнгөөр
    frame.Health = health
    
    local power = CreateFrame("StatusBar", nil, frame)
    power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -2)
    power:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    power:SetStatusBarTexture(C.Media.Texture or "Interface\\TargetingFrame\\UI-StatusBar")
    power:SetStatusBarColor(0.2, 0.4, 1)
    frame.Power = power
    
    local name = health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("LEFT", health, "LEFT", 4, 0)
    name:SetFont(C.Media.Font, 12, C.Media.Font_Style)
    frame.Name = name
    
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("ARENA_OPPONENT_UPDATE")
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("UNIT_POWER")
    frame:RegisterEvent("UNIT_MAXPOWER")
    frame:SetScript("OnEvent", OnArenaEvent)
    
    arenaFrames[i] = frame
end