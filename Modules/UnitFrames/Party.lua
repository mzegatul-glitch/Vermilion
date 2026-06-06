local V, C, L, _ = select(2, ...):unpack()
if C.Unitframe.EnhancedFrames ~= true then return end

-- Шаардлагатай хувьсагчид болон хэмжээнүүд (Vermilion загвар)
local PARTY_WIDTH = C.Unitframe.PartyWidth or 140
local PARTY_HEIGHT = C.Unitframe.PartyHeight or 28
local PARTY_POWER_HEIGHT = C.Unitframe.PartyPowerHeight or 10
local PORTRAIT_SIZE = PARTY_HEIGHT + PARTY_POWER_HEIGHT + 6

local PartyFrame = CreateFrame("Frame", "PartyFrameCustom", UIParent)
PartyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PartyFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
PartyFrame:RegisterEvent("UNIT_HEALTH")
PartyFrame:RegisterEvent("UNIT_MAXHEALTH")
PartyFrame:RegisterEvent("UNIT_MANA")
PartyFrame:RegisterEvent("UNIT_MAXMANA")
PartyFrame:RegisterEvent("UNIT_RAGE")
PartyFrame:RegisterEvent("UNIT_MAXRAGE")
PartyFrame:RegisterEvent("UNIT_ENERGY")
PartyFrame:RegisterEvent("UNIT_MAXENERGY")
PartyFrame:RegisterEvent("UNIT_RUNIC_POWER")
PartyFrame:RegisterEvent("UNIT_MAXRUNIC_POWER")

local partyUnits = {}

-- 1. СТИЛЬ БОЛОН ЗАГВАР ОРУУЛАХ ФУНКЦУУД
local function CreateBackdropAndBorder(frame)
    if not frame or frame.Styled then return end
    
    -- Арын дэвсгэр (Backdrop)
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetVertexColor(0.1, 0.1, 0.1, 0.6)
    frame.BG = bg

    -- Хүрээ (Border)
    if not frame.Border then
        frame:CreateBorder()
    end
    frame.Styled = true
end

-- 2. ПАРТИ ФРЕЙМҮҮДИЙГ ҮҮСГЭХ (ХӨДӨЛГӨДӨГ АНКЕРТАЙ ХОЛБОХ)
local function CreatePartyFrames()
    -- Хэрэв Movers.lua дээр PartyFrameAnchor үүссэн бол түүнийг ашиглана, байхгүй бол өөрөө үүсгэнэ
    local Anchor = _G["PartyFrameAnchor"] or CreateFrame("Frame", "PartyFrameAnchor", UIParent)
    if not _G["PartyFrameAnchor"] then
        Anchor:SetSize(PARTY_WIDTH + PORTRAIT_SIZE + 10, (PARTY_HEIGHT + PARTY_POWER_HEIGHT + 20) * 4)
        Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 120, -250)
    end

    for i = 1, 4 do
        local unit = "party"..i
        local frame = CreateFrame("Button", "PartyFrameCustomMember"..i, UIParent, "SecureUnitButtonTemplate")
        frame:SetSize(PARTY_WIDTH + PORTRAIT_SIZE + 10, PARTY_HEIGHT + PARTY_POWER_HEIGHT + 12)
        
        -- Байршил заах (Дээд талын гишүүнээс хамаарч цуварч байрлана)
        if i == 1 then
            frame:SetPoint("TOPLEFT", Anchor, "TOPLEFT", 0, 0)
        else
            frame:SetPoint("TOPLEFT", partyUnits[i-1], "BOTTOMLEFT", 0, -15)
        end

        -- Кликийн тохиргоо (Target хийх)
        frame:RegisterForClicks("AnyUp")
        frame:SetAttribute("type1", "target")
        frame:SetAttribute("unit", unit)
        RegisterUnitWatch(frame)

        -- Хөрөг зураг (Portrait)
        local portrait = frame:CreateTexture(nil, "ARTWORK")
        portrait:SetSize(PORTRAIT_SIZE, PORTRAIT_SIZE)
        portrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
        portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        
        local portraitBorder = CreateFrame("Frame", nil, frame)
        portraitBorder:SetPoint("TOPLEFT", portrait)
        portraitBorder:SetPoint("BOTTOMRIGHT", portrait)
        CreateBackdropAndBorder(portraitBorder)
        frame.Portrait = portrait

        -- Амьд явах зурвас (Health Bar)
        local hp = CreateFrame("StatusBar", nil, frame)
        hp:SetSize(PARTY_WIDTH, PARTY_HEIGHT)
        hp:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 8, 0)
        hp:SetStatusBarTexture(C.Media.Texture)
        CreateBackdropAndBorder(hp)
        frame.HealthBar = hp

        -- Амьд явах бичиг (Health Text)
        local hpText = hp:CreateFontString(nil, "OVERLAY")
        hpText:SetFont(C.Media.Font, 10, C.Media.Font_Style)
        hpText:SetPoint("CENTER", hp, "CENTER", 0, 0)
        frame.HealthText = hpText

        -- Мана / Эрчим хүчний зурвас (Power Bar)
        local mp = CreateFrame("StatusBar", nil, frame)
        mp:SetSize(PARTY_WIDTH, PARTY_POWER_HEIGHT)
        mp:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -6)
        mp:SetStatusBarTexture(C.Media.Texture)
        CreateBackdropAndBorder(mp)
        frame.PowerBar = mp

        -- Нэр (Name)
        local name = hp:CreateFontString(nil, "OVERLAY")
        name:SetFont(C.Media.Font, 11, C.Media.Font_Style)
        name:SetPoint("BOTTOMLEFT", hp, "TOPLEFT", 0, 3)
        frame.NameText = name

        partyUnits[i] = frame
    end
end

-- 3. МЭДЭЭЛЛИЙГ ШИНЭЧЛЭХ ФУНКЦ (Update)
local function UpdatePartyFrame(frame, unit)
    if not UnitExists(unit) then return end

    -- Нэр болон Классын өнгө оруулах
    local name = UnitName(unit)
    local _, class = UnitClass(unit)
    local classColor = RAID_CLASS_COLORS[class]

    if name then
        frame.NameText:SetText(name)
        if classColor then
            frame.NameText:SetTextColor(classColor.r, classColor.g, classColor.b)
        else
            frame.NameText:SetTextColor(1, 0.8, 0)
        end
    end

    -- Хөрөг зураг шинэчлэх
    SetPortraitTexture(frame.Portrait, unit)

    -- Хэрэв үхсэн эсвэл Оффлайн бол
    if UnitIsDeadOrGhost(unit) then
        frame.HealthBar:SetValue(0)
        frame.HealthText:SetText("|cffFF0000ҮХСЭН|r")
    elseif not UnitIsConnected(unit) then
        frame.HealthBar:SetValue(0)
        frame.HealthText:SetText("|cff808080OFFLINE|r")
    else
        -- Амь (Health) шинэчлэх
        local hpMin = UnitHealth(unit)
        local hpMax = UnitHealthMax(unit)
        frame.HealthBar:SetMinMaxValues(0, hpMax)
        frame.HealthBar:SetValue(hpMin)
        
        -- Класс өнгөөр Хелф барыг будах
        if classColor then
            frame.HealthBar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
        else
            frame.HealthBar:SetStatusBarColor(0.2, 0.8, 0.2)
        end

        if hpMax > 0 then
            local percent = math.floor((hpMin / hpMax) * 100)
            frame.HealthText:SetText(V.ShortValue(hpMin) .. " - " .. percent .. "%")
        end
    end

    -- Мана / Эрчим хүч (Power) шинэчлэх
    local mpMin = UnitPower(unit)
    local mpMax = UnitPowerMax(unit)
    local powerType, powerToken = UnitPowerType(unit)
    frame.PowerBar:SetMinMaxValues(0, mpMax)
    frame.PowerBar:SetValue(mpMin)

    -- Мана барын өнгийг төрлөөр нь будах (Мана бол Цэнхэр, Рэйж бол Улаан г.м)
    local powerColor = PowerBarColor[powerToken] or PowerBarColor[powerType]
    if powerColor then
        frame.PowerBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
    else
        frame.PowerBar:SetStatusBarColor(0, 0.5, 1)
    end
end

-- Бүх партиг зэрэг шинэчлэх гогцоо
local function UpdateAllPartyMembers()
    for i = 1, 4 do
        UpdatePartyFrame(partyUnits[i], "party"..i)
    end
end

-- 4. ЭВЕНТҮҮДИЙГ ХҮЛЭЭЖ АВАХ Скрипт
PartyFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        CreatePartyFrames()
        UpdateAllPartyMembers()
    elseif event == "PARTY_MEMBERS_CHANGED" then
        UpdateAllPartyMembers()
    -- Хэрэв тодорхой нэг гишүүний амь эсвэл мана өөрчлөгдвөл зөвхөн түүнийг шинэчилнэ
    elseif arg1 and string.match(arg1, "party%d") then
        for i = 1, 4 do
            if arg1 == "party"..i then
                UpdatePartyFrame(partyUnits[i], arg1)
                break
            end
        end
    end
end)