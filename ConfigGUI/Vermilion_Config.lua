-- ============================================================
-- Vermilion Config GUI
-- ============================================================
-- Original Author: Fernir, Tukz, Tohveli, Shestak
-- Profile System Integration by Vermilion
-- ============================================================

local _G = _G
local unpack = unpack
local print = print
local format = string.format
local pairs, type = pairs, type
local CreateFrame = CreateFrame
local tinsert = table.insert

local Locale = GetLocale()
local name = UnitName("player")
local realm = GetRealmName()

if Locale == "enGB" then
    Locale = "enUS"
end

Print = function(...)
    print("|cffe60000Vermilion|r:", ...)
end

-- ============================================================
-- Group Management
-- ============================================================

local ALLOWED_GROUPS = {
    ["General"] = 1,
    ["ActionBar"] = 2,
    ["Announcements"] = 3,
    ["Automation"] = 4,
    ["Bag"] = 5,
    ["Blizzard"] = 6,
    ["Aura"] = 7,
    ["Chat"] = 8,
    ["Cooldown"] = 9,
    ["Error"] = 10,
    ["Filger"] = 11,
    ["Loot"] = 12,
    ["Minimap"] = 13,
    ["Misc"] = 14,
    ["Nameplate"] = 15,
    ["PowerBar"] = 16,
    ["PulseCD"] = 17,
    ["Skins"] = 18,
    ["Tooltip"] = 19,
    ["Unitframe"] = 20,
    ["Raid"] = 21,
    ["Profiles"] = 22,
}

local CustomOrder = {
    ["ActionBar"] = {
        "BottomBars", "ButtonSize", "ButtonSpace", "Enable", "EquipBorder", "Hotkey",
        "Macro", "OutOfMana", "OutOfRange", "PetBarHide", "PetBarHorizontal", "RightBars",
        "Selfcast", "ShowGrid", "SplitBars", "StanceBarHide", "StanceBarHorizontal", "ToggleMode"
    },
    ["Announcements"] = {
        "Bad_Gear", "Feasts", "Interrupt", "Portals", "PullCountdown", "SaySapped", "Spells", "SpellsFromAll", "Toys"
    },
    ["Automation"] = {
        "AutoCollapse", "AutoInvite", "DeclineDuel", "LoggingCombat", "Resurrection", "ScreenShot", "SellGreyRepair", "TabBinder"
    },
    ["Bag"] = {
        "BagColumns", "BankColumns", "ButtonSize", "ButtonSpace", "Enable", "HideSoulBag"
    },
    ["Blizzard"] = {
        "Capturebar", "ClassColor", "DarkTextures", "DarkTexturesColor", "Durability", "MoveAchievements", "Reputations"
    },
    ["Aura"] = {
        "Enable", "BuffSize", "CastBy", "ClassColorBorder"
    },
    ["Chat"] = {
        "CombatLog", "DamageMeterSpam", "Enable", "Filter", "Height", "Outline", "Spam",
        "FadeTime", "Sticky", "TabsMouseover", "TabsOutline", "WhispSound", "Width"
    },
    ["Cooldown"] = {
        "Enable", "FontSize", "Threshold"
    },
    ["Error"] = {
        "Black", "White", "Combat"
    },
    ["Filger"] = {
        "BuffsSize", "CooldownSize", "Enable", "MaxTestIcon", "PvPSize", "ShowTooltip", "TestMode"
    },
    ["General"] = {
        "AutoScale", "BubbleFontSize", "BubbleBackdrop", "ReplaceBlizzardFonts", "TranslateMessage", "UIScale", "MultisampleCheck", "WelcomeMessage"
    },
    ["Loot"] = {
        "ConfirmDisenchant", "AutoGreed", "LootFilter", "IconSize", "Enable", "GroupLoot", "Width"
    },
    ["Minimap"] = {
        "CollectButtons", "Enable", "Ping", "Size"
    },
    ["Misc"] = {
        "AFKCamera", "AlreadyKnown", "Armory", "BGSpam", "DurabilityWarninig", "EnhancedMail", "HatTrick", "InviteKeyword", "ItemLevel", "SpeedyLoad", "ProcGlow"
    },
    ["Nameplate"] = {
        "AdditionalHeight", "AdditionalWidth", "AuraSize", "BadColor", "ClassIcons", "Combat",
        "Enable", "EnhanceThreat", "GoodColor", "HealthValue", "EnemyWidth", "EnemyHeight",
        "FriendlyWidth", "FriendlyHeight", "NameAbbreviate", "NearColor", "CastBarName", "Auras"
    },
    ["PowerBar"] = {
        "Enable", "FontOutline", "Height", "DKRuneBar", "Combo", "Mana", "Rage", "Rune", "RuneCooldown", "ValueAbbreviate", "Width"
    },
    ["PulseCD"] = {
        "Enable", "Size", "Sound", "AnimationScale", "HoldTime", "Threshold"
    },
    ["Skins"] = {
        "Spy", "ChatBubble", "CLCRet", "DBM", "MinimapButtons", "Recount", "Skada", "WeakAuras", "WorldMap"
    },
    ["Tooltip"] = {
        "Achievements", "ArenaExperience", "Cursor", "Enable", "HealthValue", "HideCombat",
        "HideButtons", "InstanceLock", "ItemCount", "ItemIcon", "QualityBorder", "RaidIcon",
        "Rank", "SpellID", "Talents", "Target", "Title", "WhoTargetting"
    },
    ["Unitframe"] = {
        "ComboFrame", "SmoothBars", "AuraOffsetY", "BetterPowerColors", "CastBarScale", "ClassHealth",
        "ClassIcon", "CombatFeedback", "Enable", "EnhancedFrames", "GroupNumber", "PvPIcon",
        "LargeAuraSize", "Outline", "PercentHealth", "Scale", "SmallAuraSize"
    },
    ["Raid"] = {
        "Enable", "Width", "Height", "HealthHeight", "PowerHeight", "HorizontalSpacing",
        "VerticalSpacing", "Scale", "Backdrop", "BackdropAlpha", "BorderClassColor", "HealthClassColor"
    },
    ["Profiles"] = {},
}

-- ============================================================
-- Helpers
-- ============================================================

local function PrettyName(text)
    text = text:gsub("^UIConfig", "")
    
    local groups = {
        "General", "ActionBar", "Announcements", "Automation", "Bag", "Blizzard", "Aura",
        "Chat", "Cooldown", "Error", "Filger", "Loot", "Minimap", "Misc", "Nameplate",
        "PowerBar", "PulseCD", "Skins", "Tooltip", "Unitframe", "Raid",
    }

    for _, g in ipairs(groups) do
        if text ~= g then
            text = text:gsub("^" .. g, "")
        end
    end

    text = text:gsub("(%l)(%u)", "%1 %2")
    return text
end

local function Local(o)
    local V, L, _ = Vermilion:unpack()
    V.option = PrettyName(o)
end

local function NewButton(text, parent)
    local result = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    local label = result:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetText(text)
    result:SetWidth(label:GetWidth())
    result:SetHeight(label:GetHeight())
    result:SetFontString(label)
    result:SetNormalTexture("")
    result:SetHighlightTexture("")
    result:SetPushedTexture("")
    return result
end

local function NormalButton(text, parent)
    local V, C, L, _ = Vermilion:unpack()
    local result = CreateFrame("Button", nil, parent)

    result:SetSize(100, 23)
    result:SetBackdrop(V.Backdrop)
    result:SetBackdropColor(unpack(C.Media.Backdrop_Color))
    result:SetBackdropBorderColor(unpack(C.Media.Border_Color))

    local label = result:CreateFontString(nil, "OVERLAY")
    label:SetFont(C.Media.Font, 12, C.Media.Font_Style)
    label:SetPoint("CENTER")
    label:SetText(text)
    result:SetFontString(label)

    local hl = result:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    hl:SetBlendMode("ADD")
    hl:SetAlpha(0.15)

    result:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(V.Color.r, V.Color.g, V.Color.b)
    end)

    result:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(unpack(C.Media.Border_Color))
    end)

    return result
end

-- ============================================================
-- Static Popups
-- ============================================================

StaticPopupDialogs["PERCHAR"] = {
    text = L_GUI_PER_CHAR,
    OnAccept = function()
        if UIConfigAllCharacters:GetChecked() then
            VermilionDB.GUIConfigAll[realm][name] = true
        else
            VermilionDB.GUIConfigAll[realm][name] = false
        end
        ReloadUI()
    end,
    OnCancel = function()
        UIConfigCover:Hide()
        UIConfigAllCharacters:SetChecked(not UIConfigAllCharacters:GetChecked())
    end,
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    preferredIndex = 3,
}

StaticPopupDialogs["RESET_PERCHAR"] = {
    text = L_GUI_RESET_CHAR,
    OnAccept = function()
        VermilionDB.GUIConfig = VermilionDB.GUIConfigSettings
        ReloadUI()
    end,
    OnCancel = function()
        if UIConfig and UIConfig:IsShown() then
            UIConfigCover:Hide()
        end
    end,
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    preferredIndex = 3,
}

StaticPopupDialogs["RESET_ALL"] = {
    text = L_GUI_RESET_ALL,
    OnAccept = function()
        VermilionDB.GUIConfigSettings = nil
        VermilionDB.GUIConfig = nil
        ReloadUI()
    end,
    OnCancel = function()
        UIConfigCover:Hide()
    end,
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    preferredIndex = 3,
}

-- ============================================================
-- SetValue - Core Setting Function
-- ============================================================

function SetValue(group, option, value)
    local V, C, L, _ = Vermilion:unpack()

    -- 1. Update C table
    if C and C[group] then
        C[group][option] = value
    end

    -- 2. Save to profile database
    if V and V.GetActiveProfile then
        local profile = V.GetActiveProfile()
        if profile and VermilionDB then
            if not VermilionDB.Profiles then
                VermilionDB.Profiles = {}
            end
            if not VermilionDB.Profiles[profile] then
                VermilionDB.Profiles[profile] = {}
            end
            if not VermilionDB.Profiles[profile][group] then
                VermilionDB.Profiles[profile][group] = {}
            end
            VermilionDB.Profiles[profile][group][option] = value
        end
    end

    -- 3. Update GUI element
    local frameName = "UIConfig" .. group .. option
    local frame = _G[frameName]
    if frame then
        if frame.SetChecked then
            frame:SetChecked(value)
        elseif frame.SetText then
            frame:SetText(tostring(value))
        end
    end

    -- 4. Refresh if needed
    if group == "Minimap" and option == "Size" then
        if UpdateMinimapSize then
            UpdateMinimapSize()
        end
    end
end

-- ============================================================
-- Config Window
-- ============================================================

local VISIBLE_GROUP = nil
local lastbutton = nil

local function ShowGroup(group, button)
    local V, _ = Vermilion:unpack()

    if lastbutton then
        lastbutton:SetText(string.sub(lastbutton:GetText(), 11, -3))
    end
    if VISIBLE_GROUP then
        _G["UIConfig" .. VISIBLE_GROUP]:Hide()
    end
    if _G["UIConfig" .. group] then
        local o = "UIConfig" .. group
        Local(o)
        _G["UIConfigTitle"]:SetText(V.option)
        
        local height = _G["UIConfig" .. group]:GetHeight()
        _G["UIConfig" .. group]:Show()
        
        local scrollamntmax = 600
        local scrollamntmin = scrollamntmax - 10
        local max = height > scrollamntmax and height - scrollamntmin or 1

        if max == 1 then
            _G["UIConfigGroupSlider"]:SetValue(1)
            _G["UIConfigGroupSlider"]:Hide()
        else
            _G["UIConfigGroupSlider"]:SetMinMaxValues(0, max)
            _G["UIConfigGroupSlider"]:Show()
            _G["UIConfigGroupSlider"]:SetValue(1)
        end
        _G["UIConfigGroup"]:SetScrollChild(_G["UIConfig" .. group])

        local x
        if UIConfigGroupSlider:IsShown() then
            _G["UIConfigGroup"]:EnableMouseWheel(true)
            _G["UIConfigGroup"]:SetScript("OnMouseWheel", function(self, delta)
                if UIConfigGroupSlider:IsShown() then
                    if delta == -1 then
                        x = _G["UIConfigGroupSlider"]:GetValue()
                        _G["UIConfigGroupSlider"]:SetValue(x + 10)
                    elseif delta == 1 then
                        x = _G["UIConfigGroupSlider"]:GetValue()
                        _G["UIConfigGroupSlider"]:SetValue(x - 30)
                    end
                end
            end)
        else
            _G["UIConfigGroup"]:EnableMouseWheel(false)
        end

        VISIBLE_GROUP = group
        lastbutton = button
    end
end

local loaded
function CreateUIConfig()
    if InCombatLockdown() and not loaded then
        Print("|cffffe02e" .. ERR_NOT_IN_COMBAT .. "|r")
        return
    end

    local V, C, L, _ = Vermilion:unpack()

    if UIConfigMain then
        ShowGroup("General")
        UIConfigMain:Show()
        return
    end

    -- ========================================================
    -- Main Frame
    -- ========================================================
    local UIConfigMain = CreateFrame("Frame", "UIConfigMain", UIParent)
    UIConfigMain:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 200)
    UIConfigMain:SetSize(780, 720)
    UIConfigMain:SetBackdrop(V.Backdrop)
    UIConfigMain:SetBackdropColor(unpack(C["Media"].Backdrop_Color))
    UIConfigMain:SetBackdropBorderColor(V.Color.r, V.Color.g, V.Color.b)
    UIConfigMain:SetFrameStrata("DIALOG")
    UIConfigMain:SetFrameLevel(20)
    tinsert(UISpecialFrames, "UIConfigMain")

    UIConfigMain:SetMovable(true)
    UIConfigMain:EnableMouse(true)
    UIConfigMain:RegisterForDrag("LeftButton")
    UIConfigMain:SetScript("OnDragStart", function(self) self:StartMoving() end)
    UIConfigMain:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- Title Bar
    local TitleBoxVer = CreateFrame("Frame", "TitleBoxVer", UIConfigMain)
    TitleBoxVer:SetSize(180, 24)
    TitleBoxVer:SetPoint("TOPLEFT", UIConfigMain, "TOPLEFT", 23, -15)
    local TitleBoxVerText = TitleBoxVer:CreateFontString("UIConfigTitleVer", "OVERLAY", "GameFontNormal")
    TitleBoxVerText:SetPoint("CENTER")
    TitleBoxVerText:SetText("|cffe60000Vermilion|r")

    local TitleBox = CreateFrame("Frame", "TitleBox", UIConfigMain)
    TitleBox:SetSize(540, 24)
    TitleBox:SetPoint("TOPLEFT", TitleBoxVer, "TOPRIGHT", 15, 0)
    local TitleBoxText = TitleBox:CreateFontString("UIConfigTitle", "OVERLAY", "GameFontNormal")
    TitleBoxText:SetPoint("LEFT", TitleBox, "LEFT", 15, 0)

    -- Options Frame
    local UIConfig = CreateFrame("Frame", "UIConfig", UIConfigMain)
    UIConfig:SetPoint("TOPLEFT", TitleBox, "BOTTOMLEFT", 10, -15)
    UIConfig:SetSize(520, 600)

    local UIConfigBG = CreateFrame("Frame", "UIConfigBG", UIConfig)
    UIConfigBG:SetPoint("TOPLEFT", -10, 10)
    UIConfigBG:SetPoint("BOTTOMRIGHT", 10, -10)

    -- Category Group Frame
    local groups = CreateFrame("ScrollFrame", "UIConfigCategoryGroup", UIConfig)
    groups:SetPoint("TOP", TitleBoxVer, "BOTTOM", 10, -15)
    groups:SetSize(140, 600)

    local groupsBG = CreateFrame("Frame", "groupsBG", UIConfig)
    groupsBG:SetPoint("TOPLEFT", groups, -10, 10)
    groupsBG:SetPoint("BOTTOMRIGHT", groups, 10, -10)

    local UIConfigCover = CreateFrame("Frame", "UIConfigCover", UIConfigMain)
    UIConfigCover:SetPoint("TOPLEFT", 0, 0)
    UIConfigCover:SetPoint("BOTTOMRIGHT", 0, 0)
    UIConfigCover:SetFrameLevel(UIConfigMain:GetFrameLevel() + 20)
    UIConfigCover:EnableMouse(true)
    UIConfigCover:SetScript("OnMouseDown", function(self) print(L_GUI_MAKE_SELECTION) end)
    UIConfigCover:Hide()

    -- Category Slider
    local slider = CreateFrame("Slider", "UIConfigCategorySlider", groups)
    slider:SetPoint("TOPRIGHT", 0, 0)
    slider:SetSize(20, 600)
    slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
    slider:SetOrientation("VERTICAL")
    slider:SetValueStep(20)
    slider:SetScript("OnValueChanged", function(self, value) groups:SetVerticalScroll(value) end)

    if not slider.bg then
        slider.bg = CreateFrame("Frame", nil, slider)
        slider.bg:SetPoint("TOPLEFT", slider:GetThumbTexture(), "TOPLEFT", 10, -7)
        slider.bg:SetPoint("BOTTOMRIGHT", slider:GetThumbTexture(), "BOTTOMRIGHT", -7, 7)
        slider:GetThumbTexture():SetAlpha(0)
    end

    -- Build category list
    local function sortMyTable(a, b)
        return ALLOWED_GROUPS[a] < ALLOWED_GROUPS[b]
    end

    local function pairsByKey(t, f)
        local a = {}
        for n in pairs(t) do tinsert(a, n) end
        table.sort(a, sortMyTable)
        local i = 0
        local iter = function()
            i = i + 1
            if a[i] == nil then return nil
            else return a[i], t[a[i]] end
        end
        return iter
    end

    local child = CreateFrame("Frame", nil, groups)
    child:SetPoint("TOPLEFT")
    local offset = 5
    
    for i in pairsByKey(ALLOWED_GROUPS) do
        local o = "UIConfig" .. i
        Local(o)
        local button = NewButton(V.option, child)
        button:SetSize(125, 16)
        button:SetPoint("TOPLEFT", 5, -offset)
        button:SetScript("OnClick", function(self)
            ShowGroup(i, button)
            self:SetText(format("|cff%02x%02x%02x%s|r", V.Color.r * 255, V.Color.g * 255, V.Color.b * 255, V.option))
        end)
        offset = offset + 20
    end
    
    child:SetSize(125, offset)
    slider:SetValue(1)
    groups:SetScrollChild(child)

    local x
    _G["UIConfigCategoryGroup"]:EnableMouseWheel(true)
    _G["UIConfigCategoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
        if _G["UIConfigCategorySlider"]:IsShown() then
            if delta == -1 then
                x = _G["UIConfigCategorySlider"]:GetValue()
                _G["UIConfigCategorySlider"]:SetValue(x + 10)
            elseif delta == 1 then
                x = _G["UIConfigCategorySlider"]:GetValue()
                _G["UIConfigCategorySlider"]:SetValue(x - 20)
            end
        end
    end)

    -- Options Scroll Frame
    local group = CreateFrame("ScrollFrame", "UIConfigGroup", UIConfig)
    group:SetPoint("TOPLEFT", 0, 5)
    group:SetSize(520, 600)

    local optionSlider = CreateFrame("Slider", "UIConfigGroupSlider", group)
    optionSlider:SetPoint("TOPRIGHT", 0, 0)
    optionSlider:SetSize(20, 600)
    optionSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
    optionSlider:SetOrientation("VERTICAL")
    optionSlider:SetValueStep(20)
    optionSlider:SetScript("OnValueChanged", function(self, value) group:SetVerticalScroll(value) end)

    -- Build option frames
    for i in pairs(ALLOWED_GROUPS) do
        if i ~= "Profiles" then
            local frame = CreateFrame("Frame", "UIConfig" .. i, UIConfigGroup)
            frame:SetPoint("TOPLEFT")
            frame:SetWidth(225)

            local offset = 5

            if type(C[i]) ~= "table" then
                Error(i .. " GroupName not found in config table.")
                return
            end

            local sortedKeys = {}
            
            if CustomOrder[i] then
                for _, keyName in ipairs(CustomOrder[i]) do
                    if C[i][keyName] ~= nil then
                        tinsert(sortedKeys, keyName)
                    end
                end
                for j in pairs(C[i]) do
                    local found = false
                    for _, keyName in ipairs(CustomOrder[i]) do
                        if j == keyName then found = true break end
                    end
                    if not found then tinsert(sortedKeys, j) end
                end
            else
                for j in pairs(C[i]) do tinsert(sortedKeys, j) end
            end

            for _, j in ipairs(sortedKeys) do
                local value = C[i][j]
                
                if type(value) == "boolean" then
                    local button = CreateFrame("CheckButton", "UIConfig" .. i .. j, frame, "InterfaceOptionsCheckButtonTemplate")
                    local o = "UIConfig" .. i .. j
                    Local(o)
                    _G["UIConfig" .. i .. j .. "Text"]:SetText(V.option)
                    _G["UIConfig" .. i .. j .. "Text"]:SetFontObject(GameFontHighlight)
                    _G["UIConfig" .. i .. j .. "Text"]:SetWidth(460)
                    _G["UIConfig" .. i .. j .. "Text"]:SetJustifyH("LEFT")
                    button:SetChecked(value)
                    button:SetScript("OnClick", function(self)
                        SetValue(i, j, self:GetChecked() and true or false)
                    end)
                    button:SetPoint("TOPLEFT", 5, -offset)
                    offset = offset + 25

                elseif type(value) == "number" or type(value) == "string" then
                    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    local o = "UIConfig" .. i .. j
                    Local(o)
                    label:SetText(V.option or tostring(j))
                    label:SetSize(460, 20)
                    label:SetJustifyH("LEFT")
                    label:SetPoint("TOPLEFT", 5, -offset)

                    local editbox = CreateFrame("EditBox", "UIConfig" .. i .. j .. "Edit", frame)
                    editbox:SetAutoFocus(false)
                    editbox:SetMultiLine(false)
                    editbox:SetSize(220, 22)
                    editbox:SetMaxLetters(255)
                    editbox:SetTextInsets(3, 0, 0, 0)
                    editbox:SetFontObject(GameFontHighlight)
                    editbox:SetPoint("TOPLEFT", 8, -(offset + 20))
                    editbox:SetText(value)
                    editbox:SetBackdrop(V.Backdrop)
                    editbox:SetBackdropColor(unpack(C["Media"].Backdrop_Color))

                    local okbutton = CreateFrame("Button", nil, frame)
                    okbutton:SetHeight(editbox:GetHeight())
                    okbutton:SetPoint("LEFT", editbox, "RIGHT", 2, 0)
                    local oktext = okbutton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    oktext:SetText(OKAY)
                    oktext:SetPoint("CENTER", okbutton, "CENTER", -1, 0)
                    okbutton:SetWidth(oktext:GetWidth() + 5)
                    okbutton:Hide()

                    if type(value) == "number" then
                        editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
                        editbox:SetScript("OnChar", function(self) okbutton:Show() end)
                        editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(i, j, tonumber(self:GetText())) end)
                        okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(i, j, tonumber(editbox:GetText())) end)
                    else
                        editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
                        editbox:SetScript("OnChar", function(self) okbutton:Show() end)
                        editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(i, j, tostring(self:GetText())) end)
                        okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(i, j, tostring(editbox:GetText())) end)
                    end

                    offset = offset + 45

                elseif type(value) == "table" then
                    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    local o = "UIConfig" .. i .. j
                    Local(o)
                    label:SetText(V.option or tostring(j))
                    label:SetSize(440, 20)
                    label:SetJustifyH("LEFT")
                    label:SetPoint("TOPLEFT", 5, -offset)

                    local colorbutton = CreateFrame("Button", "UIConfig" .. i .. j .. "ColorPicker", frame)
                    colorbutton:SetHeight(20)
                    colorbutton:SetBackdrop(V.Backdrop)
                    colorbutton:SetBackdropBorderColor(unpack(value))
                    colorbutton:SetBackdropColor(value[1], value[2], value[3], 0.3)
                    colorbutton:SetPoint("LEFT", label, "RIGHT", 2, 0)

                    local colortext = colorbutton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    colortext:SetText(COLOR)
                    colortext:SetPoint("CENTER")
                    colortext:SetJustifyH("CENTER")
                    colorbutton:SetWidth(colortext:GetWidth() + 5)

                    local function round(number, decimal)
                        return (("%%.%df"):format(decimal)):format(number)
                    end

                    colorbutton:SetScript("OnMouseDown", function(self)
                        if ColorPickerFrame:IsShown() then return end
                        local newR, newG, newB, newA
                        local r, g, b, a = self:GetBackdropBorderColor()
                        r, g, b, a = round(r, 2), round(g, 2), round(b, 2), round(a, 2)
                        local originalR, originalG, originalB, originalA = r, g, b, a

                        local function ShowColorPicker(r, g, b, a, changedCallback)
                            ColorPickerFrame.func = changedCallback
                            ColorPickerFrame.opacityFunc = changedCallback
                            ColorPickerFrame.cancelFunc = changedCallback
                            ColorPickerFrame:SetColorRGB(r, g, b)
                            a = tonumber(a)
                            ColorPickerFrame.hasOpacity = (a ~= nil and a ~= 1)
                            ColorPickerFrame.opacity = a
                            ColorPickerFrame.previousValues = {originalR, originalG, originalB, originalA}
                            ColorPickerFrame:Hide()
                            ColorPickerFrame:Show()
                        end

                        local function myColorCallback(restore)
                            if restore ~= nil then
                                newR, newG, newB, newA = unpack(restore)
                            else
                                newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
                            end
                            value = {newR, newG, newB, newA}
                            SetValue(i, j, value)
                            self:SetBackdropBorderColor(newR, newG, newB, newA)
                            self:SetBackdropColor(newR, newG, newB, 0.3)
                        end

                        ShowColorPicker(originalR, originalG, originalB, originalA, myColorCallback)
                    end)

                    offset = offset + 25
                end
            end

            frame:SetHeight(offset)
            frame:Hide()
        end
    end

    -- ========================================================
    -- Profiles Frame
    -- ========================================================
    local function UpdateProfileList()
        local V, C, L, _ = Vermilion:unpack()
        if not _G["UIConfigProfiles"] then return end
        
        local frame = _G["UIConfigProfiles"]
        if frame.dynamicElements then
            for _, el in pairs(frame.dynamicElements) do
                if el.Hide then el:Hide() end
            end
        end
        frame.dynamicElements = {}
        
        local activeProfile = V.GetActiveProfile()
        local offset = 10

        -- Profile Dropdown
        if not frame.profileDropdown then
            local dropdownLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            dropdownLabel:SetPoint("TOPLEFT", 10, -offset)
            dropdownLabel:SetText("Active Profile:")
            frame.dropdownLabel = dropdownLabel
            
            local dropdown = CreateFrame("Frame", "VermilionProfileDropdown", frame, "UIDropDownMenuTemplate")
            dropdown:SetPoint("TOPLEFT", 0, -(offset + 18))
            UIDropDownMenu_SetWidth(dropdown, 250)
            frame.profileDropdown = dropdown
        end
        
        UIDropDownMenu_SetText(frame.profileDropdown, "|cff388bdb" .. activeProfile .. "|r")
        UIDropDownMenu_Initialize(frame.profileDropdown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            for pName, _ in pairs(VermilionDB.Profiles) do
                info.text = pName
                info.checked = (pName == activeProfile)
                info.func = function()
                    V.SetProfile(pName)
                    ReloadUI()
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        offset = offset + 60

        -- Create New Profile
        if not frame.createLabel then
            local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            lbl:SetPoint("TOPLEFT", 10, -offset)
            lbl:SetText("Create New Profile")
            frame.createLabel = lbl
        else
            frame.createLabel:SetPoint("TOPLEFT", 10, -offset)
        end
        offset = offset + 18
        
        if not frame.createEdit then
            local edit = CreateFrame("EditBox", nil, frame)
            edit:SetSize(220, 20)
            edit:SetAutoFocus(false)
            edit:SetFontObject(GameFontHighlight)
            edit:SetBackdrop(V.Backdrop)
            edit:SetBackdropColor(0, 0, 0, 0.5)
            edit:SetBackdropBorderColor(unpack(C["Media"].Border_Color))
            edit:SetTextInsets(5, 5, 0, 0)
            frame.createEdit = edit
            
            local btn = NormalButton("Create", frame)
            btn:SetSize(100, 22)
            btn:SetScript("OnClick", function()
                local newName = frame.createEdit:GetText()
                if newName and newName ~= "" and not VermilionDB.Profiles[newName] then
                    V.CreateProfile(newName, activeProfile)
                    frame.createEdit:SetText("")
                    Print("|cff388bdb" .. newName .. "|r created.")
                    UpdateProfileList()
                end
            end)
            frame.createBtn = btn
        end
        frame.createEdit:SetPoint("TOPLEFT", 20, -offset)
        frame.createBtn:SetPoint("LEFT", frame.createEdit, "RIGHT", 5, 0)
        offset = offset + 30

        -- Rename Profile
        if not frame.renameLabel then
            local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            lbl:SetText("Rename Profile")
            frame.renameLabel = lbl
        end
        frame.renameLabel:SetPoint("TOPLEFT", 10, -offset)
        offset = offset + 18
        
        if not frame.renameEdit then
            local edit = CreateFrame("EditBox", nil, frame)
            edit:SetSize(220, 20)
            edit:SetAutoFocus(false)
            edit:SetFontObject(GameFontHighlight)
            edit:SetBackdrop(V.Backdrop)
            edit:SetBackdropColor(0, 0, 0, 0.5)
            edit:SetBackdropBorderColor(unpack(C["Media"].Border_Color))
            edit:SetTextInsets(5, 5, 0, 0)
            frame.renameEdit = edit
            
            local btn = NormalButton("Rename", frame)
            btn:SetSize(100, 22)
            btn:SetScript("OnClick", function()
                local newName = frame.renameEdit:GetText()
                if newName and newName ~= "" and newName ~= activeProfile then
                    if V.RenameProfile(activeProfile, newName) then
                        Print("|cff388bdb" .. activeProfile .. "|r renamed to |cff388bdb" .. newName .. "|r.")
                        ReloadUI()
                    else
                        Print("|cffff0000Rename failed.|r")
                    end
                end
            end)
            frame.renameBtn = btn
        end
        frame.renameEdit:SetPoint("TOPLEFT", 20, -offset)
        frame.renameEdit:SetText(activeProfile)
        frame.renameBtn:SetPoint("LEFT", frame.renameEdit, "RIGHT", 5, 0)
        offset = offset + 35

        -- Save Profile
        if not frame.saveBtn then
            local btn = NormalButton("Save Profile", frame)
            btn:SetWidth(330)
            btn:SetHeight(22)
            btn:SetScript("OnClick", function()
                if V.SaveProfile() then
                    Print("|cff388bdb" .. activeProfile .. "|r saved.")
                end
            end)
            frame.saveBtn = btn
        end
        frame.saveBtn:SetPoint("TOPLEFT", 20, -offset)
        offset = offset + 30

        -- Delete Profile
        if not frame.deleteBtn then
            local btn = NormalButton("|cffff0000Delete Profile|r", frame)
            btn:SetWidth(330)
            btn:SetHeight(22)
            btn:SetScript("OnClick", function()
                local profileCount = 0
                for _ in pairs(VermilionDB.Profiles) do profileCount = profileCount + 1 end
                if profileCount <= 1 then
                    Print("|cffff0000Cannot delete the last profile.|r")
                    return
                end
                StaticPopupDialogs["VERMILION_DELETE_PROFILE"] = {
                    text = "Delete profile |cff388bdb" .. activeProfile .. "|r?\n\nThis cannot be undone.",
                    button1 = ACCEPT,
                    button2 = CANCEL,
                    OnAccept = function()
                        V.DeleteProfile(activeProfile)
                        for pName, _ in pairs(VermilionDB.Profiles) do
                            V.SetProfile(pName)
                            break
                        end
                        ReloadUI()
                    end,
                    timeout = 0,
                    whileDead = 1,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("Vermilion_DELETE_PROFILE")
            end)
            frame.deleteBtn = btn
        end
        frame.deleteBtn:SetPoint("TOPLEFT", 20, -offset)
        offset = offset + 40

        -- Import/Export
        if not frame.ioLabel then
            local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            lbl:SetText("Import / Export")
            frame.ioLabel = lbl
        end
        frame.ioLabel:SetPoint("TOPLEFT", 10, -offset)
        offset = offset + 18
        
        if not frame.ioBox then
            local scrollFrame = CreateFrame("ScrollFrame", "VermilionProfileIOScroll", frame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetSize(330, 80)
            scrollFrame:SetBackdrop(V.Backdrop)
            scrollFrame:SetBackdropColor(0, 0, 0, 0.5)
            scrollFrame:SetBackdropBorderColor(unpack(C["Media"].Border_Color))
            frame.ioScroll = scrollFrame
            
            local editBox = CreateFrame("EditBox", "VermilionProfileIOEdit", scrollFrame)
            editBox:SetMultiLine(true)
            editBox:SetAutoFocus(false)
            editBox:SetFontObject(GameFontHighlightSmall)
            editBox:SetWidth(310)
            editBox:SetTextInsets(5, 5, 5, 5)
            editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            scrollFrame:SetScrollChild(editBox)
            frame.ioBox = editBox
        end
        frame.ioScroll:SetPoint("TOPLEFT", 20, -offset)
        offset = offset + 90
        
        if not frame.exportBtn then
            local btn = NormalButton("Export", frame)
            btn:SetSize(160, 22)
            btn:SetScript("OnClick", function()
                local data = V.ExportProfile(activeProfile)
                if data then
                    frame.ioBox:SetText(data)
                    frame.ioBox:HighlightText()
                    frame.ioBox:SetFocus()
                    Print("Profile exported.")
                end
            end)
            frame.exportBtn = btn
        end
        frame.exportBtn:SetPoint("TOPLEFT", 20, -offset)
        
        if not frame.importBtn then
            local btn = NormalButton("Import", frame)
            btn:SetSize(160, 22)
            btn:SetScript("OnClick", function()
                local data = frame.ioBox:GetText()
                if data and data ~= "" then
                    local importName = activeProfile .. " (Import)"
                    if V.ImportProfile(importName, data) then
                        V.SetProfile(importName)
                        Print("|cff388bdb" .. importName .. "|r imported.")
                        ReloadUI()
                    else
                        Print("|cffff0000Import failed.|r")
                    end
                end
            end)
            frame.importBtn = btn
        end
        frame.importBtn:SetPoint("LEFT", frame.exportBtn, "RIGHT", 10, 0)
        offset = offset + 30

        if not frame.ioHint then
            local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            lbl:SetText("Ctrl+C = Copy, Ctrl+V = Paste")
            lbl:SetJustifyH("LEFT")
            lbl:SetTextColor(0.8, 0.8, 0.8)
            frame.ioHint = lbl
        end
        frame.ioHint:SetPoint("TOPLEFT", 20, -offset)
        offset = offset + 35
        
        frame:SetHeight(offset + 20)
    end

    local profilesFrame = CreateFrame("Frame", "UIConfigProfiles", UIConfigGroup)
    profilesFrame:SetPoint("TOPLEFT")
    profilesFrame:SetSize(520, 500)
    profilesFrame:Hide()
    profilesFrame:SetScript("OnShow", UpdateProfileList)

    -- ========================================================
    -- Buttons
    -- ========================================================
    local reset = NormalButton(DEFAULT, UIConfigMain)
    reset:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 30, -25)
    reset:SetScript("OnClick", function(self)
        UIConfigCover:Show()
        if VermilionDB.GUIConfigAll[realm][name] == true then
            StaticPopup_Show("RESET_PERCHAR")
        else
            StaticPopup_Show("RESET_ALL")
        end
    end)

    local close = NormalButton(CLOSE, UIConfigMain)
    close:SetPoint("TOPRIGHT", UIConfig, "BOTTOMRIGHT", 10, -25)
    close:SetScript("OnClick", function(self)
        PlaySound("igMainMenuOption")
        UIConfigMain:Hide()
    end)

    local load = NormalButton(APPLY, UIConfigMain)
    load:SetPoint("RIGHT", close, "LEFT", -4, 0)
    load:SetScript("OnClick", function(self)
        ReloadUI()
    end)

    local totalreset = NormalButton(L_GUI_BUTTON_RESET or "Reset", UIConfigMain)
    totalreset:SetWidth(120)
    totalreset:SetPoint("TOPLEFT", groupsBG, "BOTTOMLEFT", 0, -15)
    totalreset:SetScript("OnClick", function(self)
        VermilionDB.GUIConfig = {}
        if VermilionDB.GUIConfigAll[realm][name] == true then
            VermilionDB.GUIConfigAll[realm][name] = {}
        end
        VermilionDB.GUIConfigSettings = {}
    end)

    local movers = NormalButton("Move UI", UIConfigMain)
    movers:SetWidth(90)
    movers:SetPoint("LEFT", totalreset, "RIGHT", 4, 0)
    movers:SetScript("OnClick", function()
        if SlashCmdList.MOVING then
            SlashCmdList.MOVING("")
        end
    end)

    -- Per-character checkbox
    if VermilionDB.GUIConfigAll then
        local button = CreateFrame("CheckButton", "UIConfigAllCharacters", TitleBox, "InterfaceOptionsCheckButtonTemplate")
        button:SetScript("OnClick", function(self)
            StaticPopup_Show("PERCHAR")
            UIConfigCover:Show()
        end)
        button:SetPoint("RIGHT", TitleBox, "RIGHT", -3, 0)
        button:SetHitRectInsets(0, 0, 0, 0)

        local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetText("Per Character")
        label:SetPoint("RIGHT", button, "LEFT")

        if VermilionDB.GUIConfigAll[realm][name] == true then
            button:SetChecked(true)
        else
            button:SetChecked(false)
        end
    end

    -- Background styling
    local bgSkins = {TitleBox, TitleBoxVer, UIConfigBG, groupsBG}
    for _, sb in pairs(bgSkins) do
        sb:SetBackdrop(V.Backdrop)
        sb:SetBackdropColor(unpack(C["Media"].Backdrop_Color))
        sb:SetBackdropBorderColor(unpack(C["Media"].Border_Color))
    end

    ShowGroup("General")
    loaded = true
end

-- ============================================================
-- Slash Commands
-- ============================================================

SLASH_CONFIG1 = "/config"
SLASH_CONFIG2 = "/cfg"
SLASH_CONFIG3 = "/configui"
SLASH_CONFIG4 = "/kc"
SLASH_CONFIG5 = "/Vermilion"

function SlashCmdList.CONFIG(msg, editbox)
    if not UIConfigMain or not UIConfigMain:IsShown() then
        PlaySound("igMainMenuOption")
        CreateUIConfig()
        HideUIPanel(GameMenuFrame)
    else
        PlaySound("igMainMenuOption")
        UIConfigMain:Hide()
    end
end

SLASH_RESETCONFIG1 = "/resetconfig"

function SlashCmdList.RESETCONFIG()
    if UIConfigMain and UIConfigMain:IsShown() then
        UIConfigCover:Show()
    end

    if VermilionDB.GUIConfigAll[realm][name] == true then
        StaticPopup_Show("RESET_PERCHAR")
    else
        StaticPopup_Show("RESET_ALL")
    end
end

-- ============================================================
-- Interface Options Panel
-- ============================================================

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "|cffe60000Vermilion|r"

frame:SetScript("OnShow", function(self)
    if self.show then return end
    local V, _ = Vermilion:unpack()
    
    local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Info:")

    local subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetWidth(380)
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetText("UI Site: |cff2eb6ffhttps://Vermilion.github.io/Vermilion/|r\nGitHub: |cff2eb6ffhttps://github.com/Vermilion/Vermilion|r")

    local title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title2:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -16)
    title2:SetText("Credits:")

    local subtitle2 = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle2:SetWidth(380)
    subtitle2:SetPoint("TOPLEFT", title2, "BOTTOMLEFT", 0, -8)
    subtitle2:SetJustifyH("LEFT")
    subtitle2:SetText("Vermilion, Fernir, Tukz, Tohveli, Shestak, and many others...")

    local version = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    version:SetPoint("BOTTOMRIGHT", -16, 16)
    version:SetText("Version: " .. V.Version)

    self.show = true
end)

InterfaceOptions_AddCategory(frame)

-- ============================================================
-- Game Menu Button
-- ============================================================

local UIConfigButton = CreateFrame("Frame")
UIConfigButton:RegisterEvent("PLAYER_LOGIN")
UIConfigButton:SetScript("OnEvent", function(self, event)
    local Menu = GameMenuFrame
    local Continue = GameMenuButtonContinue
    local ContinueX = Continue:GetWidth()
    local ContinueY = Continue:GetHeight()
    local Interface = GameMenuButtonUIOptions
    local KeyBinds = GameMenuButtonKeybindings

    Menu:SetHeight(GameMenuFrame:GetHeight() + 21)

    local button = CreateFrame("BUTTON", "GameMenuVermilionButton", Menu, "GameMenuButtonTemplate")
    button:SetSize(ContinueX, ContinueY)
    button:SetPoint("TOP", Interface, "BOTTOM", 0, -1)
    button:SetText("|cffe60000Vermilion|r")

    button:SetScript("OnClick", function(self)
        if UIConfigMain and UIConfigMain:IsShown() then
            UIConfigMain:Hide()
        else
            CreateUIConfig()
            HideUIPanel(Menu)
        end
    end)

    KeyBinds:ClearAllPoints()
    KeyBinds:SetPoint("TOP", button, "BOTTOM", 0, -1)
end)
