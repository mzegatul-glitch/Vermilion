--[[
  ClassColoredHealthBars v1.9 FIXED
  Class colors + heal prediction (LibHealComm-4.0)
  + absorb bars (SpecializedAbsorbs-1.0)
  on Player, Target and Focus Blizzard frames.
]]

local HealComm         = LibStub("LibHealComm-4.0", true)
local SpecAbsorbs      = LibStub("SpecializedAbsorbs-1.0", true)
local myGUID           = nil
local MAX_OVERFLOW     = 1.05

-- ============================================================
-- Units
-- ============================================================
local units = { "player", "target", "focus" }

local barForUnit = {
    player = _G.PlayerFrameHealthBar,
    target = _G.TargetFrameHealthBar,
    focus  = _G.FocusFrameHealthBar,
}

-- ============================================================
-- Prediction bars
-- ============================================================
local prediction = {}

local function CreatePredictionBars(unit)
    local bar = barForUnit[unit]
    if not bar then return end

    -- Prevent duplicate creation
    if prediction[unit] then
        return
    end

    local myBar = bar:CreateTexture(nil, "OVERLAY", nil, 1)
    myBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    myBar:SetVertexColor(0, 1, 0, 0.5)
    myBar:Hide()

    local otherBar = bar:CreateTexture(nil, "OVERLAY", nil, 1)
    otherBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    otherBar:SetVertexColor(0, 0.5, 0, 0.5)
    otherBar:Hide()

    local absorbBar = bar:CreateTexture(nil, "OVERLAY", nil, 2)
    absorbBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    absorbBar:SetVertexColor(1, 0.85, 0, 0.6)
    absorbBar:Hide()

    prediction[unit] = {
        myBar     = myBar,
        otherBar  = otherBar,
        absorbBar = absorbBar,
    }
end

-- ============================================================
-- Fill bars
-- ============================================================
local function UpdateFillBar(previousTexture, bar, amount, ratio)
    if amount <= 0 then
        bar:Hide()
        return previousTexture
    end

    bar:ClearAllPoints()

    bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", 0, 0)
    bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", 0, 0)

    bar:SetWidth(math.max(1, amount * ratio))
    bar:Show()

    return bar
end

local function UpdateAbsorbBar(healthBar, bar, amount, ratio)
    if amount <= 0 then
        bar:Hide()
        bar:SetWidth(0)
        return
    end

    bar:Hide()
    bar:ClearAllPoints()

    local tex = healthBar:GetStatusBarTexture()

    bar:SetPoint("TOPRIGHT", tex, "TOPRIGHT", 0, 0)
    bar:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", 0, 0)

    bar:SetWidth(math.max(1, amount * ratio))
    bar:Show()
end

-- ============================================================
-- Core update
-- ============================================================
local function UpdatePrediction(unit)
    local bar  = barForUnit[unit]
    local pred = prediction[unit]

    if not bar or not pred then
        return
    end

    local guid       = UnitGUID(unit)
    local health     = UnitHealth(unit)
    local maxHealth  = UnitHealthMax(unit)

    if maxHealth == 0 then
        pred.myBar:Hide()
        pred.otherBar:Hide()
        pred.absorbBar:Hide()
        return
    end

    local width = bar:GetWidth()

    if width <= 0 then
        return
    end

    local ratio = width / maxHealth

    -- Blizzard incoming heals
local myHeal = 0
local allHeal = 0

-- HealComm support
if HealComm and guid then

	local direct = HealComm.ALL_HEALS
	local hot    = HealComm.OVERTIME_HEALS

	allHeal =
		(HealComm:GetHealAmount(guid, direct) or 0)
		+ (HealComm:GetHealAmount(guid, hot) or 0)

	myHeal =
		(HealComm:GetHealAmount(
			guid,
			direct,
			nil,
			myGUID
		) or 0)

		+

		(HealComm:GetHealAmount(
			guid,
			hot,
			nil,
			myGUID
		) or 0)
end

    -- Dead units
    if UnitIsDeadOrGhost(unit) then
        myHeal      = 0
        allHeal     = 0
    end

    -- Overflow clamp
    local overflow = maxHealth * MAX_OVERFLOW - health

    if allHeal > overflow then
        allHeal = overflow
    end

    if allHeal < 0 then
        allHeal = 0
    end

    -- Split my heal / others
    if allHeal < myHeal then
        myHeal  = allHeal
        allHeal = 0
    else
        allHeal = allHeal - myHeal
    end

    -- Absorbs
    local absorbAmount = 0

    if SpecAbsorbs and SpecAbsorbs.UnitTotal and guid then
        absorbAmount = SpecAbsorbs.UnitTotal(guid) or 0
    end

    -- Dead units hide absorbs
    if UnitIsDeadOrGhost(unit) then
        absorbAmount = 0
    end

    -- Clamp absorb to missing HP
    local missingHealth = (maxHealth * 1.30) - health

    if absorbAmount > missingHealth then
        absorbAmount = missingHealth
    end

    -- Draw heal bars
    local prev = bar:GetStatusBarTexture()

    prev = UpdateFillBar(prev, pred.myBar, myHeal, ratio)
    prev = UpdateFillBar(prev, pred.otherBar, allHeal, ratio)

    -- Draw absorb bar
    UpdateAbsorbBar(bar, pred.absorbBar, absorbAmount, ratio)
end

local function UpdateAll()
    for _, unit in ipairs(units) do
        UpdatePrediction(unit)
    end
end

-- ============================================================
-- HealComm callbacks
-- ============================================================
local healCommCallbackFrame = {}

local function HealComm_HealUpdate(event, casterGUID, spellID, healType, _, ...)
    local count = select("#", ...)

    for i = 1, count do
        local targetGUID = select(i, ...)

        for _, unit in ipairs(units) do
            if UnitGUID(unit) == targetGUID then
                UpdatePrediction(unit)
            end
        end
    end
end

local function HealComm_Modified(event, guid)
    for _, unit in ipairs(units) do
        if UnitGUID(unit) == guid then
            UpdatePrediction(unit)
        end
    end
end

local function RegisterHealCommCallbacks()
    if not HealComm then
        return
    end

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_HealStarted",
        HealComm_HealUpdate
    )

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_HealUpdated",
        HealComm_HealUpdate
    )

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_HealDelayed",
        HealComm_HealUpdate
    )

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_HealStopped",
        HealComm_HealUpdate
    )

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_ModifierChanged",
        HealComm_Modified
    )

    HealComm.RegisterCallback(
        healCommCallbackFrame,
        "HealComm_GUIDDisappeared",
        HealComm_Modified
    )
end

-- ============================================================
-- Absorb callbacks
-- ============================================================
local absorbCallbackFrame = {}

local function SpecAbsorbs_UnitUpdated(event, guid)
    for _, unit in ipairs(units) do
        if UnitGUID(unit) == guid then
            UpdatePrediction(unit)
        end
    end
end

local function RegisterAbsorbCallbacks()
    if not SpecAbsorbs then
        return
    end

    SpecAbsorbs.RegisterCallback(
        absorbCallbackFrame,
        "UnitUpdated",
        SpecAbsorbs_UnitUpdated
    )

    SpecAbsorbs.RegisterCallback(
        absorbCallbackFrame,
        "UnitCleared",
        SpecAbsorbs_UnitUpdated
    )
end

-- ============================================================
-- Initialize
-- ============================================================
local callbacksRegistered = false

local function InitializeAll()
    myGUID = UnitGUID("player")

    for _, unit in ipairs(units) do
        CreatePredictionBars(unit)
    end

    if not callbacksRegistered then
        RegisterHealCommCallbacks()
        RegisterAbsorbCallbacks()

        callbacksRegistered = true
    end

    UpdateAll()
end

-- ============================================================
-- Events
-- ============================================================
local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_FOCUS")

f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("UNIT_HEAL_PREDICTION")

f:SetScript("OnEvent", function(_, event, arg1)

    if event == "PLAYER_LOGIN"
    or event == "PLAYER_ENTERING_WORLD"
    then
        InitializeAll()

    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdatePrediction("target")

    elseif event == "UNIT_FOCUS"
    and arg1 == "player"
    then
        UpdatePrediction("focus")

    elseif event == "UNIT_HEALTH"
    or event == "UNIT_MAXHEALTH"
    or event == "UNIT_HEAL_PREDICTION"
    then
        if arg1 and prediction[arg1] then
            UpdatePrediction(arg1)
        end
    end
end)