local addonTable = select(2, ...)  -- ← ... файлын эхэнд авна

-- Бүх логик ADDON_LOADED дотор байх бөгөөд profile merge дууссан үед ажиллана
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
    if addon ~= "Vermilion" then return end

    local V, C, L, _ = addonTable:unpack()  -- ← addonTable-с авна

-- Profile-с ирсэн C["Raid"] болон Enable-г шалгана
if not C["Raid"] or C["Raid"]["Enable"] == false then
    print("Raid: Disabled")
    self:UnregisterEvent(event)  -- Бүртгэлээ цуцална
    return
end

    -- Default values (profile-д байхгүй бол ашиглана)
    C["Raid"].Width = C["Raid"].Width or 70
    C["Raid"].Height = C["Raid"].Height or 36
    C["Raid"].Spacing = C["Raid"].Spacing or 8
    C["Raid"].ManabarShow = C["Raid"].ManabarShow ~= false  -- default true

    local CreateFrame = CreateFrame
    local LibGroupTalents = LibStub("LibGroupTalents-1.0", true)
    local LCG = LibStub("LibCustomGlow-1.0", true)
    local HealComm = LibStub("LibHealComm-4.0", true)
    local ResComm = LibStub:GetLibrary("LibResComm-1.0", true)
    local SpecAbsorbs = LibStub("SpecializedAbsorbs-1.0", true)

    -- ============================================================
    -- RESURRECTION TRACKING
    -- ============================================================
    local ResUnits = {}

    if ResComm then
        ResComm:RegisterCallback(
            "ResComm_ResStart",
            function(event, caster, duration, target)
                if target then
                    ResUnits[target] = true
                end
            end
        )
        ResComm:RegisterCallback(
            "ResComm_ResEnd",
            function(event, caster, target)
                if target then
                    ResUnits[target] = nil
                end
            end
        )
    end

    -- ============================================================
    -- RAID HEADER (Anchor)
    -- ============================================================
    local RaidAnchor = CreateFrame("Frame", "RaidFrameAnchor", UIParent)
    RaidAnchor:SetSize(120, 40)
    RaidAnchor:SetPoint("BOTTOM", UIParent, "BOTTOM", -90, -272)
    RaidAnchor:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
    })
    RaidAnchor:SetBackdropBorderColor(0, 1, 0, 1)

    local Header = CreateFrame("Frame", "VermilionRaidHeader", UIParent)
    Header:SetSize(500, 500)
    Header:ClearAllPoints()
    Header:SetPoint("TOPLEFT", RaidAnchor, "TOPLEFT", 0, 0)

    RaidAnchor:SetMovable(true)
    RaidAnchor:EnableMouse(true)
    RaidAnchor:RegisterForDrag("LeftButton")
    RaidAnchor:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    RaidAnchor:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    RaidAnchor:SetClampedToScreen(true)

    -- ============================================================
    -- RANGE
    -- ============================================================
    local function UpdateRange(self)
        if not self or not self.unit then return end

        -- DEAD
        if UnitIsDeadOrGhost(self.unit) then
            self.bg:SetAlpha(0.35)
            self.Health:SetAlpha(0.35)
            if self.Power then self.Power:SetAlpha(0.35) end
            self.Name:SetAlpha(0.5)
            self.Health.Value:SetAlpha(0.5)
            self.Role:SetAlpha(0.5)
            return
        end

        -- OFFLINE
        if not UnitIsConnected(self.unit) then
            self.bg:SetAlpha(0.25)
            self.Health:SetAlpha(0.25)
            if self.Power then self.Power:SetAlpha(0.25) end
            self.Name:SetAlpha(0.4)
            self.Health.Value:SetAlpha(0.4)
            self.Role:SetAlpha(0.4)
            return
        end

        -- OUT OF RANGE
        if not UnitInRange(self.unit) then
            self.bg:SetAlpha(0.45)
            self.Health:SetAlpha(0.45)
            if self.Power then self.Power:SetAlpha(0.45) end
            self.Name:SetAlpha(0.7)
            self.Health.Value:SetAlpha(0.7)
            self.Role:SetAlpha(0.7)
            return
        end

        -- NORMAL
        self.bg:SetAlpha(1)
        self.Health:SetAlpha(1)
        if self.Power then self.Power:SetAlpha(1) end
        self.Name:SetAlpha(1)
        self.Health.Value:SetAlpha(1)
        self.Role:SetAlpha(1)
        if self.Debuff then self.Debuff:SetAlpha(1) end
    end

    -- ============================================================
    -- HoT / Tank CD (stub — та өөрсдийн кодыг холбох боломжтой)
    -- ============================================================
    -- Хэрэв танд UpdateRaidHoTs функц байгаа бол энд холбоно уу
    if not UpdateRaidHoTs then
        UpdateRaidHoTs = function() end
    end
    if not UpdateRaidTankCD then
        UpdateRaidTankCD = function() end
    end

    -- ============================================================
    -- STATUS
    -- ============================================================
    local function UpdateStatus(self)
        if not self or not self.unit then
            if self and self.RaidIcon then
                self.RaidIcon:Hide()
            end
            return
        end

        -- RESURRECT INDICATOR
        if self.ResIndicator then
            local name = UnitName(self.unit)
            if name and ResUnits[name] then
                self.ResIndicator:Show()
            else
                self.ResIndicator:Hide()
            end
        end

        local isTank = false
        local isHealer = false
        local isDamager = false
        local role = UnitGroupRolesAssigned and UnitGroupRolesAssigned(self.unit)

        if role == "TANK" then
            isTank = true
        elseif role == "HEALER" then
            isHealer = true
        elseif role == "DAMAGER" then
            isDamager = true
        end

        -- HoT / Tank CD callbacks
        UpdateRaidHoTs(self)
        UpdateRaidTankCD(self)

        -- RAID TARGET ICON
        if self.RaidIcon then
            local raidTarget = GetRaidTargetIndex(self.unit)
            if raidTarget then
                SetRaidTargetIconTexture(self.RaidIcon, raidTarget)
                self.RaidIcon:Show()
            else
                self.RaidIcon:Hide()
            end
        end

        -- fallback role detection via spec
        if not isTank and not isHealer and not isDamager then
            local _, class = UnitClass(self.unit)
            local spec = nil
            if LibGroupTalents then
                spec = LibGroupTalents:GetUnitTalentSpec(self.unit)
            end

            if class == "PALADIN" then
                if spec == 1 then         -- Holy
                    isHealer = true
                elseif spec == 2 then     -- Prot
                    isTank = true
                else
                    isDamager = true
                end
            elseif class == "WARRIOR" then
                if spec == 3 then         -- Prot
                    isTank = true
                else
                    isDamager = true
                end
            elseif class == "DRUID" then
                if spec == 3 or spec == "restoration" then
                    isHealer = true
                elseif spec == 2 or spec == "feral combat" then
                    isDamager = true
                else
                    isDamager = true
                end
            elseif class == "SHAMAN" then
                if spec == 3 then         -- Resto
                    isHealer = true
                else
                    isDamager = true
                end
            elseif class == "PRIEST" then
                if spec == 1 or spec == 2 then  -- Disc/Holy
                    isHealer = true
                else
                    isDamager = true
                end
            elseif class == "DEATHKNIGHT" then
                if spec == 1 then         -- Blood
                    isTank = true
                else
                    isDamager = true
                end
            else
                isDamager = true
            end
        end

        -- ROLE ICON
        if isTank then
            self.Role:SetTexture("Interface\\AddOns\\Vermilion\\Media\\Raid\\blizz-tank.blp")
        elseif isHealer then
            self.Role:SetTexture("Interface\\AddOns\\Vermilion\\Media\\Raid\\blizz-healer.blp")
        else
            self.Role:SetTexture("Interface\\AddOns\\Vermilion\\Media\\Raid\\blizz-dps.blp")
        end
        self.Role:SetTexCoord(0, 1, 0, 1)
        self.Role:SetAlpha(1)
        self.Role:Show()

        -- DEAD
        if UnitIsDeadOrGhost(self.unit) then
            self.Health:SetValue(0)
            self.Name:SetText("Dead")
            self.Health:SetStatusBarColor(0.4, 0.4, 0.4)
            return
        end

        -- OFFLINE
        if not UnitIsConnected(self.unit) then
            self.Name:SetText("Offline")
            self.Health:SetStatusBarColor(0.2, 0.2, 0.2)
            return
        end

        -- HEALTH
        local hp = UnitHealth(self.unit)
        local hpmax = UnitHealthMax(self.unit)
        self.Health:SetMinMaxValues(0, hpmax)
        self.Health:SetValue(hp)
        local name = UnitName(self.unit)
        if name then self.Name:SetText(name) end
        self.Health.Value:SetText(hp)
        local _, class = UnitClass(self.unit)
        if class and RAID_CLASS_COLORS[class] then
            local c = RAID_CLASS_COLORS[class]
            self.Health:SetStatusBarColor(c.r, c.g, c.b)
        end

        -- Incoming Heal
        if HealComm and self.HealPrediction then
            local guid = UnitGUID(self.unit)
            if guid then
                local incoming = HealComm:GetHealAmount(guid, HealComm.ALL_HEALS) or 0
                local hp2 = UnitHealth(self.unit)
                local hpmax2 = UnitHealthMax(self.unit)
                local amount = math.min(incoming, hpmax2 - hp2)
                if amount > 0 then
                    local tex = self.Health:GetStatusBarTexture()
                    local width = (self.Health:GetWidth() * amount) / hpmax2
                    self.HealPrediction:ClearAllPoints()
                    self.HealPrediction:SetPoint("TOPLEFT", tex, "TOPRIGHT", 0, 0)
                    self.HealPrediction:SetPoint("BOTTOMLEFT", tex, "BOTTOMRIGHT", 0, 0)
                    self.HealPrediction:SetWidth(width)
                    if self.Power then
                        self.HealPrediction:SetHeight(C["Raid"].Height - 6)
                    else
                        self.HealPrediction:SetHeight(C["Raid"].Height)
                    end
                    self.HealPrediction:Show()
                else
                    self.HealPrediction:Hide()
                end
            end
        end

        -- ABSORB
        if SpecAbsorbs and self.AbsorbBar then
            local guid = UnitGUID(self.unit)
            if guid then
                local absorb = SpecAbsorbs.UnitTotal(guid) or 0
                local hp2 = UnitHealth(self.unit)
                local hpmax2 = UnitHealthMax(self.unit)
                if absorb > 0 and hpmax2 > 0 then
                    local absorbWidth = (self.Health:GetWidth() * absorb) / hpmax2
                    local hpWidth = (self.Health:GetWidth() * hp2) / hpmax2
                    if absorbWidth > hpWidth then
                        absorbWidth = hpWidth
                    end
                    self.AbsorbBar:ClearAllPoints()
                    self.AbsorbBar:SetPoint("TOPLEFT", self.Health, "TOPLEFT", hpWidth - absorbWidth, 0)
                    self.AbsorbBar:SetWidth(absorbWidth)
                    self.AbsorbBar:SetHeight(self.Health:GetHeight())
                    self.AbsorbBar:Show()
                else
                    self.AbsorbBar:Hide()
                end
            end
        end

        -- POWER
        if self.Power then
            local power = UnitPower(self.unit)
            local powermax = UnitPowerMax(self.unit)
            self.Power:SetMinMaxValues(0, powermax)
            self.Power:SetValue(power)
            local powerType = select(2, UnitPowerType(self.unit))
            local color = PowerBarColor[powerType]
            if color then self.Power:SetStatusBarColor(color.r, color.g, color.b) end
        end

        -- DISPEL HIGHLIGHT
        local texture = nil
        local dtype = nil
        local dispelType = nil
        for i = 1, 40 do
            local _, _, icon, _, debuffType = UnitDebuff(self.unit, i)
            if not icon then break end
            -- first debuff fallback
            if not texture then
                texture = icon
                dtype = debuffType
            end
            local canDispel = false
            if V.Class == "MAGE" then
                canDispel = (debuffType == "Curse")
            elseif V.Class == "PRIEST" then
                canDispel = (debuffType == "Magic") or (debuffType == "Disease")
            elseif V.Class == "PALADIN" then
                canDispel = (debuffType == "Magic") or (debuffType == "Disease") or (debuffType == "Poison")
            elseif V.Class == "DRUID" then
                canDispel = (debuffType == "Curse") or (debuffType == "Poison")
            elseif V.Class == "SHAMAN" then
                if debuffType == "Poison" or debuffType == "Disease" then
                    canDispel = true
                elseif debuffType == "Curse" and GetSpellInfo(51886) then
                    canDispel = true
                end
            end
            if canDispel then
                texture = icon
                dtype = debuffType
                dispelType = debuffType
                break
            end
        end

        if texture then
            self.Debuff.Icon:SetTexture(texture)
            self.Debuff:Show()
        else
            self.Debuff:Hide()
        end
        if dtype and DebuffTypeColor[dtype] then
            local c = DebuffTypeColor[dtype]
            self.DebuffGlow:SetBackdropBorderColor(c.r, c.g, c.b, 1)
            self.DebuffGlow:Show()
        else
            self.DebuffGlow:Hide()
        end
        if dispelType then
            local c = DebuffTypeColor[dispelType]
            self.DispelHighlight:SetVertexColor(c.r, c.g, c.b, 1)
            if LCG and not self.Glowing then
                LCG.PixelGlow_Start(self, {c.r, c.g, c.b, 1}, 8, 0.3, nil, 2, 2, 2, true, "RaidDispel")
                self.Glowing = true
            end
        else
            self.DispelHighlight:SetVertexColor(0, 0, 0, 0)
            if LCG and self.Glowing then
                LCG.PixelGlow_Stop(self, "RaidDispel")
                self.Glowing = nil
            end
        end
    end

    -- ============================================================
    -- AGGRO
    -- ============================================================
    local function UpdateAggro(self)
        local threat = UnitThreatSituation(self.unit)
        if threat and threat >= 2 then
            self.AggroGlow:Show()
        else
            self.AggroGlow:Hide()
        end
    end

    -- ============================================================
    -- GROUP LABELS
    -- ============================================================
    local GroupLabels = {}
    local function UpdateGroupLabels()
        local inRaid = GetNumRaidMembers()
        local inParty = GetNumPartyMembers()

        -- SOLO
        if inRaid == 0 and inParty == 0 then
            GroupLabels[1]:Show()
            GroupLabels[1]:ClearAllPoints()
            GroupLabels[1]:SetPoint("BOTTOM", Header, "TOP", 0, 8)
            GroupLabels[1]:SetText("Party")
            for i = 2, 5 do
                GroupLabels[i]:Hide()
            end
            return
        end

        -- PARTY
        if inParty > 0 and inRaid == 0 then
            GroupLabels[1]:Show()
            GroupLabels[1]:ClearAllPoints()
            GroupLabels[1]:SetPoint("BOTTOM", Header, "TOP", 0, 8)
            GroupLabels[1]:SetText("Party")
            for i = 2, 5 do
                GroupLabels[i]:Hide()
            end
            return
        end

        -- RAID
        for i = 1, 5 do
            local hasMembers = false
            for j = 1, inRaid do
                local _, _, subgroup = GetRaidRosterInfo(j)
                if subgroup == i then
                    hasMembers = true
                    break
                end
            end
            if hasMembers then
                GroupLabels[i]:Show()
                GroupLabels[i]:ClearAllPoints()
                GroupLabels[i]:SetPoint("BOTTOM", Header, "TOPLEFT", ((i - 1) * (C["Raid"].Width + 7)) + (C["Raid"].Width / 2), 8)
                GroupLabels[i]:SetText("Group " .. i)
            else
                GroupLabels[i]:Hide()
            end
        end
    end

    -- ============================================================
    -- CREATE RAID FRAME
    -- ============================================================
    local function CreateRaidFrame(index)
        local frame = CreateFrame("Button", "VermilionRaid" .. index, Header, "SecureUnitButtonTemplate")
        frame:SetSize(C["Raid"].Width, C["Raid"].Height)
        frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        frame:SetAttribute("type1", "target")
        frame:SetAttribute("*type2", "menu")
        frame:SetAttribute("toggleForVehicle", true)
        frame:SetAttribute("unitpopup", "RAID_PLAYER")

        frame:SetScript("OnEnter", function(self)
            self.Highlight:Show()
            if not self.unit then return end
            GameTooltip_SetDefaultAnchor(GameTooltip, self)
            GameTooltip:SetUnit(self.unit)
        end)
        frame:SetScript("OnLeave", function(self)
            self.Highlight:Hide()
            GameTooltip:Hide()
        end)

        -- BACKDROP
        frame.bg = CreateFrame("Frame", nil, frame)
        frame.bg:SetPoint("TOPLEFT", -2, 2)
        frame.bg:SetPoint("BOTTOMRIGHT", 2, -2)
        frame.bg:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        frame.bg:SetBackdropColor(0, 0, 0, 0.8)
        frame.bg:SetBackdropBorderColor(0, 0, 0)

        frame.Highlight = CreateFrame("Frame", nil, frame)
        frame.Highlight:SetFrameStrata("HIGH")
        frame.Highlight:SetFrameLevel(frame:GetFrameLevel() + 20)
        frame.Highlight:SetPoint("TOPLEFT", -3, 3)
        frame.Highlight:SetPoint("BOTTOMRIGHT", 3, -3)
        frame.Highlight:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
        })
        frame.Highlight:SetBackdropBorderColor(1, 1, 1, 1)
        frame.Highlight:Hide()

        -- AGGRO
        frame.AggroGlow = CreateFrame("Frame", nil, frame)
        frame.AggroGlow:SetPoint("TOPLEFT", -5, 5)
        frame.AggroGlow:SetPoint("BOTTOMRIGHT", 5, -5)
        frame.AggroGlow:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 14,
        })
        frame.AggroGlow:SetBackdropBorderColor(1, 0, 0)
        frame.AggroGlow:Hide()

        -- HEALTH
        frame.Health = CreateFrame("StatusBar", nil, frame)
        frame.Health:SetFrameLevel(frame:GetFrameLevel() + 1)
        frame.Health:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        if C["Raid"].ManabarShow then
            frame.Health:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            frame.Health:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
            frame.Health:SetHeight(C["Raid"].Height - 6)
        else
            frame.Health:SetAllPoints(frame)
        end

        -- Res Indicator
        frame.ResIndicator = frame:CreateTexture(nil, "OVERLAY")
        frame.ResIndicator:SetTexture("Interface\\Icons\\Spell_Holy_Resurrection")
        frame.ResIndicator:SetSize(18, 18)
        frame.ResIndicator:SetPoint("CENTER", frame.Health, "CENTER", 0, 0)
        frame.ResIndicator:Hide()

        -- Incoming Heal & Absorb
        frame.HealPrediction = CreateFrame("Frame", nil, frame.Health)
        frame.HealPrediction:SetFrameLevel(frame.Health:GetFrameLevel() + 5)
        frame.HealPrediction.Texture = frame.HealPrediction:CreateTexture(nil, "ARTWORK")
        frame.HealPrediction.Texture:SetAllPoints()
        frame.HealPrediction.Texture:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        frame.HealPrediction.Texture:SetVertexColor(0, 1, 0, 0.50)
        frame.HealPrediction:Hide()

        frame.AbsorbBar = CreateFrame("Frame", nil, frame.Health)
        frame.AbsorbOverlay = frame.AbsorbBar
        frame.AbsorbBar:SetFrameLevel(frame.Health:GetFrameLevel() + 4)
        frame.AbsorbBar.Texture = frame.AbsorbBar:CreateTexture(nil, "OVERLAY")
        frame.AbsorbBar.Texture:SetAllPoints()
        frame.AbsorbBar.Texture:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        frame.AbsorbBar.Texture:SetVertexColor(1, 0.85, 0, 0.60)
        frame.AbsorbBar:Hide()

        -- POWER
        if C["Raid"].ManabarShow then
            frame.Power = CreateFrame("StatusBar", nil, frame)
            frame.Power:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
            frame.Power:SetPoint("TOPLEFT", frame.Health, "BOTTOMLEFT", 0, -1)
            frame.Power:SetPoint("TOPRIGHT", frame.Health, "BOTTOMRIGHT", 0, -1)
            frame.Power:SetHeight(5)
        end

        -- ROLE
        frame.Role = frame.bg:CreateTexture(nil, "OVERLAY", nil, 7)
        frame.Role:SetSize(15, 15)
        frame.Role:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

        -- Raid Icon
        frame.RaidIconFrame = CreateFrame("Frame", nil, frame)
        frame.RaidIconFrame:SetFrameStrata("HIGH")
        frame.RaidIconFrame:SetFrameLevel(frame:GetFrameLevel() + 100)
        frame.RaidIconFrame:SetSize(20, 20)
        frame.RaidIconFrame:SetPoint("BOTTOM", frame.Health, "TOP", 0, -8)
        frame.RaidIcon = frame.RaidIconFrame:CreateTexture(nil, "OVERLAY")
        frame.RaidIcon:SetAllPoints()
        frame.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
        frame.RaidIcon:Hide()

        -- HOT ICON
        frame.HotIconFrame = CreateFrame("Frame", nil, frame)
        frame.HotIconFrame:SetFrameStrata("HIGH")
        frame.HotIconFrame:SetFrameLevel(frame:GetFrameLevel() + 50)
        frame.HotIconFrame:SetAllPoints(frame)
        frame.HotIcon = frame.HotIconFrame:CreateTexture(nil, "OVERLAY")
        frame.HotIcon:SetSize(14, 14)
        frame.HotIcon:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, -2)
        frame.HotIcon:SetTexture("Interface\\Icons\\Spell_Holy_Renew")
        frame.HotIcon:Hide()

        -- TANK CD ICON
        frame.TankCDFrame = CreateFrame("Frame", nil, frame)
        frame.TankCDFrame:SetFrameStrata("HIGH")
        frame.TankCDFrame:SetFrameLevel(frame:GetFrameLevel() + 50)
        frame.TankCDFrame:SetAllPoints(frame)
        frame.TankCDIcon = frame.TankCDFrame:CreateTexture(nil, "OVERLAY")
        frame.TankCDIcon:SetSize(14, 14)
        frame.TankCDIcon:SetPoint("TOPRIGHT", frame.Health, "TOPRIGHT", -2, -2)
        frame.TankCDIcon:SetTexture("Interface\\Icons\\Spell_Holy_PainSupression")
        frame.TankCDIcon:Hide()

        -- READY CHECK
        frame.ReadyCheck = frame:CreateTexture(nil, "OVERLAY")
        frame.ReadyCheck:SetSize(14, 14)
        frame.ReadyCheck:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
        frame.ReadyCheck:Hide()

        -- DEBUFF
        frame.Debuff = CreateFrame("Frame", nil, frame)
        frame.Debuff:SetSize(18, 18)
        frame.Debuff:SetPoint("CENTER", frame.Health, "CENTER", 0, 0)
        frame.Debuff:SetFrameStrata("HIGH")
        frame.Debuff:SetFrameLevel(frame:GetFrameLevel() + 50)
        frame.Debuff.Icon = frame.Debuff:CreateTexture(nil, "OVERLAY")
        frame.Debuff.Icon:SetAllPoints()
        frame.Debuff.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        frame.Debuff:Hide()

        frame.DebuffGlow = CreateFrame("Frame", nil, frame)
        frame.DebuffGlow:SetPoint("TOPLEFT", frame, -3, 3)
        frame.DebuffGlow:SetPoint("BOTTOMRIGHT", frame, 3, -3)
        frame.DebuffGlow:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 14,
        })
        frame.DebuffGlow:Hide()

        frame.DispelHighlight = frame.Health:CreateTexture(nil, "OVERLAY")
        frame.DispelHighlight:SetAllPoints()
        frame.DispelHighlight:SetTexture(C.Media.Texture)
        frame.DispelHighlight:SetVertexColor(0, 0, 0, 0)

        -- NAME
        frame.Name = frame:CreateFontString(nil, "OVERLAY")
        frame.Name:SetParent(frame.bg)
        frame.Name:SetFont(C.Media.Font, C.Media.Font_Size)
        frame.Name:SetShadowOffset(V.Mult, -V.Mult)
        frame.Name:SetPoint("CENTER", frame.Health, "CENTER", 0, 8)

        -- HP TEXT
        frame.Health.Value = frame.Health:CreateFontString(nil, "OVERLAY")
        frame.Health.Value:SetFont(C.Media.Font, C.Media.Font_Size)
        frame.Health.Value:SetShadowOffset(V.Mult, -V.Mult)
        frame.Health.Value:SetPoint("BOTTOM", frame.Health, "BOTTOM", 0, 2)

        -- EVENTS
        frame:RegisterEvent("READY_CHECK")
        frame:RegisterEvent("READY_CHECK_CONFIRM")
        frame:RegisterEvent("UNIT_HEALTH")
        frame:RegisterEvent("UNIT_MAXHEALTH")
        frame:RegisterEvent("UNIT_POWER")
        frame:RegisterEvent("UNIT_MAXPOWER")
        frame:RegisterEvent("UNIT_AURA")
        frame:RegisterEvent("RAID_TARGET_UPDATE")
        frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
        frame:RegisterEvent("PLAYER_TARGET_CHANGED")
        frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
        frame:RegisterEvent("RAID_ROSTER_UPDATE")
        frame:RegisterEvent("UNIT_CONNECTION")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")

        frame:SetScript("OnEvent", function(self, event, unit)
            if event == "RAID_TARGET_UPDATE" then
                if self.unit then UpdateStatus(self) end
                return
            end

            if event == "UNIT_AURA" then
                if not unit or unit == self.unit then
                    UpdateStatus(self)
                    UpdateRange(self)
                end
                return
            end

            local inRaid = GetNumRaidMembers() > 0
            local inParty = GetNumPartyMembers() > 0

            -- SOLO
            if not inRaid and not inParty then
                if index == 1 then
                    self.unit = "player"
                    self:Show()
                    self:ClearAllPoints()
                    self:SetPoint("TOPLEFT", Header, "TOPLEFT", 0, 0)
                else
                    self:Hide()
                    return
                end
            -- PARTY
            elseif inParty and not inRaid then
                if index == 1 then
                    self.unit = "player"
                elseif index <= GetNumPartyMembers() + 1 then
                    self.unit = "party" .. (index - 1)
                else
                    self:Hide()
                    return
                end
                self:Show()
                local row = index - 1
                self:ClearAllPoints()
                self:SetPoint("TOPLEFT", Header, "TOPLEFT", 0, -row * (C["Raid"].Height + C["Raid"].Spacing))
            -- RAID
            elseif inRaid then
                if index <= GetNumRaidMembers() then
                    self.unit = "raid" .. index
                    self:Show()
                    local _, _, subgroup = GetRaidRosterInfo(index)
                    subgroup = subgroup or 1
                    local group = subgroup - 1
                    local row = 0
                    for i = 1, index - 1 do
                        local _, _, g = GetRaidRosterInfo(i)
                        if g == subgroup then
                            row = row + 1
                        end
                    end
                    self:ClearAllPoints()
                    self:SetPoint("TOPLEFT", Header, "TOPLEFT", group * (C["Raid"].Width + 7), -row * (C["Raid"].Height + C["Raid"].Spacing))
                else
                    self:Hide()
                    return
                end
            end

            self:SetAttribute("unit", self.unit)
            if self.unit then
                -- ЗАСАВ: UnitIsUnit(self.unit, "player")  → хаалт зөв!
                self:SetAttribute("unitpopup", UnitIsUnit(self.unit, "player") and "SELF" or "RAID_PLAYER")
            end

            UpdateGroupLabels()
            UpdateStatus(self)
            UpdateAggro(self)
            UpdateRange(self)

            if event == "READY_CHECK" or event == "READY_CHECK_CONFIRM" then
                local status = GetReadyCheckStatus(self.unit)
                if status == "ready" then
                    self.ReadyCheck:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
                    self.ReadyCheck:Show()
                elseif status == "notready" then
                    self.ReadyCheck:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady")
                    self.ReadyCheck:Show()
                else
                    self.ReadyCheck:Hide()
                end
            end
        end)

        -- ЗАСАВ: arg1 → ... ашиглах
        frame:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = (self.elapsed or 0) + elapsed
            if self.elapsed > 0.1 then
                UpdateRange(self)
                UpdateStatus(self)
                self.elapsed = 0
            end
        end)

        return frame
    end

    -- ============================================================
    -- LABELS (GroupLabels)
    -- ============================================================
    for i = 1, 5 do
        GroupLabels[i] = Header:CreateFontString(nil, "OVERLAY")
        GroupLabels[i]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        GroupLabels[i]:SetWidth(C["Raid"].Width)
        GroupLabels[i]:SetJustifyH("CENTER")
        GroupLabels[i]:SetText("Group " .. i)
    end

    -- ============================================================
    -- CREATE ALL RAID FRAMES
    -- ============================================================
    local Frames = {}
    for i = 1, 25 do
        Frames[i] = CreateRaidFrame(i)
        Frames[i]:GetScript("OnEvent")(Frames[i], "PLAYER_ENTERING_WORLD")
    end

    UpdateGroupLabels()

    -- ============================================================
    -- SLASH COMMAND
    -- ============================================================
    SLASH_VermilionRAID1 = "/raidmove"
    SlashCmdList["VermilionRAID"] = function()
        if InCombatLockdown() then
            print("Combat!")
            return
        end
        if Header.isMoving then
            Header:SetMovable(false)
            Header:EnableMouse(false)
            Header:RegisterForDrag(nil)
            Header:SetScript("OnDragStart", nil)
            Header:SetScript("OnDragStop", nil)
            Header.isMoving = false
            print("Raid Locked")
        else
            Header:SetMovable(true)
            Header:EnableMouse(true)
            Header:RegisterForDrag("LeftButton")
            Header:SetScript("OnDragStart", function(self) self:StartMoving() end)
            Header:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
            Header.isMoving = true
            print("Raid Unlocked")
        end
    end

    print("Raid: Initialized successfully")

    self:UnregisterEvent(event)
end)
