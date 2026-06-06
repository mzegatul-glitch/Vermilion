local f = CreateFrame("Frame")
local DISPLAY_HOLD = 2.0
local TICK_RATE = 0.15


local function TargetValid()
  return UnitExists("target")
     and not UnitIsDead("target")
     and not UnitIsFriend("player", "target")
end

local function ThreatColor(status)
  if type(GetThreatStatusColor) == "function" and status then
    local r,g,b = GetThreatStatusColor(status)
    if r then return r,g,b end
  end
  if status == 3 then return 1, 0.2, 0.2 end
  if status == 2 then return 1, 0.6, 0.1 end
  if status == 1 then return 1, 1, 0.2 end
  return 0.8, 0.8, 0.8
end
TargetFrameNumericalThreat:Hide()

hooksecurefunc(TargetFrameNumericalThreat, "Show", function(self)
	self:Hide()
end)
TargetFrameNumericalThreatBG:Hide()
TargetFrameNumericalThreatValue:Hide()
local function EnsureUI()
  if f.ui then return true end
  if not _G.TargetFrame then return false end

  local parent = _G.TargetFrame 

  local ui = CreateFrame("Frame", "MyTargetThreatNumeric", parent)
  ui:SetSize(47.6, 17)
  ui:SetPoint("BOTTOM", parent, "TOP", 40.4, -80)
  ui:SetFrameStrata(parent:GetFrameStrata() or "LOW")
  ui:SetFrameLevel(parent:GetFrameLevel() + 50)
  ui:Hide()

  local bg = ui:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
  bg:SetPoint("TOPLEFT", ui, "TOPLEFT", 7, -3)
  bg:SetPoint("BOTTOMRIGHT", ui, "BOTTOMRIGHT", -6, 3)

  local border = ui:CreateTexture(nil, "ARTWORK")
  border:SetTexture("Interface\\Addons\\Vermilion\\Media\\Unitframes\\NumericThreatBorder")
  border:SetAllPoints(ui)
  border:SetTexCoord(0, 0.765625, 0, 0.5625)


  local text = ui:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  text:SetPoint("TOP", ui, "TOP", 0, 0)
  text:SetText("")

  ui.bg = bg
  ui.text = text
  f.ui = ui


  ui.text:SetText("OK")
  ui.bg:SetVertexColor(0.2, 0.8, 0.2, 0.85)
  ui:Show()

  return true
end

f.lastText, f.lastStatus, f.lastTime = nil, nil, 0

local function ReadThreatNow()
  if type(UnitDetailedThreatSituation) == "function" then
    local isTanking, status, scaledPct = UnitDetailedThreatSituation("player", "target")
    if scaledPct ~= nil then
      return string.format("%.0f%%", scaledPct), status
    end
    if isTanking and status ~= nil then
      return "100%", status
    end
  end
  return nil
end

local function Update()
  if not EnsureUI() then return end
  local ui = f.ui

  if not TargetValid() then
    ui:Hide()
    return
  end

  local now = GetTime()
  local text, status = ReadThreatNow()

  if text then
    f.lastText, f.lastStatus, f.lastTime = text, status, now
  else
    if not f.lastText or (now - f.lastTime) > DISPLAY_HOLD then
      ui:Hide()
      return
    end
    text, status = f.lastText, f.lastStatus
  end

  ui.text:SetText(text)
  ui.text:SetTextColor(1, 1, 1)
  local r,g,b = ThreatColor(status)
  ui.bg:SetVertexColor(r,g,b,0.85)
  ui:Show()
end

local function StartTicker()
  if f.ticker then return end
  if C_Timer and C_Timer.NewTicker then
    f.ticker = C_Timer.NewTicker(TICK_RATE, Update)
  else
    f:SetScript("OnUpdate", function(self, elapsed)
      self._acc = (self._acc or 0) + elapsed
      if self._acc >= TICK_RATE then
        self._acc = 0
        Update()
      end
    end)
  end
end

f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_ENTERING_WORLD" then
    EnsureUI()
    StartTicker()
    Update()
  else
    Update()
  end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
f:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
