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
        "AutoScale", "BubbleFontSize", "BubbleBackdrop", "ReplaceBlizzardFonts", "TranslateMessage", "UIScale", "MultisampleCheck", "WelcomeMessage", "Profiles"
    },
    ["Loot"] = {
        "ConfirmDisenchant", "AutoGreed", "LootFilter", "IconSize", "Enable", "GroupLoot", "Width"
    },
    ["Minimap"] = {
        "CollectButtons", "Enable", "Ping", "Size"
    },
    ["Misc"] = {
        "AFKCamera", "AlreadyKnown", "Armory", "BGSpam", "DurabilityWarninig", 
        "EnhancedMail", "HatTrick", "InviteKeyword", "ItemLevel", "SpeedyLoad", "ProcGlow"
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
local ProfileButton = NormalButton("Profiles", UIConfig)

ProfileButton:SetSize(100, 22)

ProfileButton:SetPoint("LEFT", MoveUIButton, "RIGHT", 5, 0)

ProfileButton:SetScript("OnClick", function()
    V.Profiles:Toggle()
end)
-- ============================================================
-- SetValue - Core Setting Function
-- ============================================================

function SetValue(group, option, value)
    local V, C, L, _ = Vermilion:unpack()

    -- 1. Update C table
    if C and C[group] then
        C[group][option] = value
    end

    -- 2. Save to VermilionDB.Settings (ЭНЭ НЭМЭХ)
    if VermilionDB and VermilionDB.Settings then
        local realm = GetRealmName()
        local name = UnitName("player")
        
        if not VermilionDB.Settings[realm] then
            VermilionDB.Settings[realm] = {}
        end
        if not VermilionDB.Settings[realm][name] then
            VermilionDB.Settings[realm][name] = {}
        end
        if not VermilionDB.Settings[realm][name][group] then
            VermilionDB.Settings[realm][name][group] = {}
        end
        print(group, option, value)
        VermilionDB.Settings[realm][name][group][option] = value
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

local VISIBLE_GROUP
local lastbutton

local function ShowGroup(group, button)
    local V, _ = Vermilion:unpack()
        local classColor = RAID_CLASS_COLORS and RAID_CLASS_COLORS[V.Class]

    if not classColor then
        classColor = {
            r = V.Color.r,
            g = V.Color.g,
            b = V.Color.b
        }
    end
if lastbutton and lastbutton ~= button then
    lastbutton.Selected = false

if lastbutton.GroupName then
    lastbutton:SetText(format(
        "|cff%02x%02x%02x%s|r",
        classColor.r * 255,
        classColor.g * 255,
        classColor.b * 255,
        lastbutton.GroupName
    ))
end

    if lastbutton.SelectedBar then
        lastbutton.SelectedBar:SetAlpha(0)
    end

    if lastbutton.Glow then
        lastbutton.Glow:SetAlpha(0)
    end
end

    if VISIBLE_GROUP and _G["UIConfig" .. VISIBLE_GROUP] then
        _G["UIConfig" .. VISIBLE_GROUP]:Hide()
    end

    local frame = _G["UIConfig" .. group]

    if not frame then
        return
    end

    local o = "UIConfig" .. group
    Local(o)

    if _G["UIConfigTitle"] then
        _G["UIConfigTitle"]:SetText(V.option)
    end

    frame:Show()

if _G["UIConfigTitle"] then
    _G["UIConfigTitle"]:SetText(
        format(
            "|cff%02x%02x%02x%s|r",
            classColor.r * 255,
            classColor.g * 255,
            classColor.b * 255,
            V.option
        )
    )
end

if button then

    if lastbutton then
        lastbutton.Selected = false

        if lastbutton.Glow then
            lastbutton.Glow:SetAlpha(0)
        end
    end

    button.Selected = true

    
if button.SelectedBar then
    button.SelectedBar:SetVertexColor(
        classColor.r,
        classColor.g,
        classColor.b
    )

    button.SelectedBar:SetAlpha(1)
end

button:SetText("|cffffffff" .. (button.GroupName or V.option) .. "|r")

end

    VISIBLE_GROUP = group
    lastbutton = button
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
-- V2 Layout
-- ========================================================

local categoryCount = 0
for _ in pairs(ALLOWED_GROUPS) do
    categoryCount = categoryCount + 1
end

local CATEGORY_W = 150
local CATEGORY_H = 22
local CATEGORY_GAP = 4

local HEADER_H = 28

local FOOTER_H = 28
local PAD = 8

local totalCategoryH =
    categoryCount * CATEGORY_H +
    (categoryCount - 1) * CATEGORY_GAP

local OPTION_W = 550

local MAIN_W =
    CATEGORY_W +
    OPTION_W +
    PAD * 4
local HEADER_W = CATEGORY_W + PAD + OPTION_W
local MAIN_H =
    HEADER_H +
    totalCategoryH +
    FOOTER_H +
    PAD * 4

-- ========================================================
-- Main Frame
-- ========================================================

local   UIConfigMain = CreateFrame("Frame", "UIConfigMain", UIParent)
        UIConfigMain:SetPoint("CENTER")
        UIConfigMain:SetSize(MAIN_W, MAIN_H)
        --UIConfigMain:SetBackdrop(V.Backdrop)
        --UIConfigMain:SetBackdropColor(unpack(C.Media.Backdrop_Color))
        --UIConfigMain:SetBackdropBorderColor(V.Color.r, V.Color.g, V.Color.b)
        UIConfigMain:SetFrameStrata("DIALOG")
        UIConfigMain:SetFrameLevel(20)
        --UIConfigMain:CreateBorder()
        tinsert(UISpecialFrames, "UIConfigMain")
        UIConfigMain:SetMovable(true)
        UIConfigMain:EnableMouse(true)
        UIConfigMain:RegisterForDrag("LeftButton")
        UIConfigMain:SetScript("OnDragStart", function(self) self:StartMoving() end)
        UIConfigMain:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
-- ========================================================
-- Header
-- ========================================================

local Header = CreateFrame("Frame", nil, UIConfigMain)
Header:SetPoint("TOPLEFT", PAD, -PAD)
Header:SetSize(HEADER_W, HEADER_H)
Header:CreateBorder()
local bg = Header:CreateTexture(nil, "BACKGROUND")
bg:SetPoint("TOPLEFT", -1, 1)
bg:SetPoint("BOTTOMRIGHT", 1, -1)
bg:SetTexture("Interface\\Buttons\\WHITE8X8")
bg:SetVertexColor(0, 0, 0, 0.7)

local Logo = Header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Logo:SetPoint("LEFT", 10, 0)
Logo:SetText("|cffe60000Vermilion|r")
Logo:SetFont(C.Media.Font, 18, "OUTLINE")
local   TitleBoxText = Header:CreateFontString("UIConfigTitle", "OVERLAY", "GameFontNormal")
        TitleBoxText:SetPoint("CENTER")
        TitleBoxText:SetFont(C.Media.Font, 18, C.Media.Font_Style)
local   CloseButton = V.CreateCloseButton(Header, 24, 24, 24)
        CloseButton:SetPoint("RIGHT", -4, 0)
        CloseButton:SetScript("OnClick", function() UIConfigMain:Hide() end)

-- ========================================================
-- Category Area
-- ========================================================

local groups = CreateFrame("Frame", "UIConfigCategoryGroup", UIConfigMain)
groups:SetPoint("TOPLEFT", Header, "BOTTOMLEFT", 0, -PAD)
groups:SetSize(CATEGORY_W, totalCategoryH)

--groups:CreateBorder()
--local bg = groups:CreateTexture(nil, "BACKGROUND")
--bg:SetAllPoints()
--bg:SetTexture("Interface\\Buttons\\WHITE8X8")
--bg:SetVertexColor(0, 0, 0, 0.7)
-- ========================================================
-- Option Area
-- ========================================================
local   UIConfig = CreateFrame("Frame", "UIConfig", UIConfigMain)
        UIConfig:SetPoint("TOPLEFT", groups, "TOPRIGHT", PAD, 0)
        UIConfig:SetSize(OPTION_W, totalCategoryH)
UIConfig:CreateBorder()

local bg = UIConfig:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetTexture("Interface\\Buttons\\WHITE8X8")
bg:SetVertexColor(0, 0, 0, 0.7)
-- ========================================================
-- Category Sorting
-- ========================================================
local function sortMyTable(a, b)
    return ALLOWED_GROUPS[a] < ALLOWED_GROUPS[b]
end
local function pairsByKey(t)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, sortMyTable)
    local i = 0
    return function()
        i = i + 1
        if a[i] then
            return a[i], t[a[i]]
        end
    end
end
-- ========================================================
-- Category Build
-- ========================================================

local child = CreateFrame("Frame", nil, groups)
child:SetAllPoints()

local offset = 0
for i in pairsByKey(ALLOWED_GROUPS) do
    local o = "UIConfig" .. i
    Local(o)
    local   button = NewButton(V.option, child)
            button.GroupName = V.option
            button:SetText(format("|cff%02x%02x%02x%s|r", V.Color.r * 255, V.Color.g * 255, V.Color.b * 255, V.option))
            button.SelectedBar = button:CreateTexture(nil, "BORDER")
            button.SelectedBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
            button.SelectedBar:SetAllPoints(button)
            button.SelectedBar:SetAlpha(0)
            button:SetSize(CATEGORY_W, CATEGORY_H)
            button:SetPoint("TOPLEFT", 0, -offset)
            button:SetScript("OnClick", function(self) ShowGroup(i, button)
            
            
        end
    )
    button:SetSize(CATEGORY_W - 0, 22)
    V.StyleConfigButton(button)
    offset = offset + CATEGORY_H + CATEGORY_GAP
end

    -- Build option frames
    for i in pairs(ALLOWED_GROUPS) do
        if i ~= "Profiles" then
            local frame = CreateFrame("Frame", "UIConfig" .. i, UIConfig)
            frame:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 10, -10)
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
-- Buttons
-- ========================================================
local BUTTON_W = 114
local BUTTON_H = 24
local function CreateFooterButton(text, parent)
    local V, C = Vermilion:unpack()

    local button = CreateFrame("Button", nil, parent)
    button:SetSize(BUTTON_W, BUTTON_H)

    local label = button:CreateFontString(nil, "OVERLAY")
    label:SetFont(C.Media.Font, 12, C.Media.Font_Style)
    label:SetPoint("CENTER")
    label:SetText(text)

    button:SetFontString(label)

    V.StyleConfigButton(button)

    return button
end
local reset = CreateFooterButton(DEFAULT, UIConfigMain)
reset:SetPoint("TOPLEFT", groups, "BOTTOMLEFT", 0, -6)
reset:SetScript("OnClick", function()

    StaticPopupDialogs["VERMILION_RESET_PROFILE"] = {
        text = "Reset current profile settings?",
        button1 = YES,
        button2 = NO,
        OnAccept = function()
            local realm = GetRealmName()
            local name = UnitName("player")

            if VermilionDB.Settings
                and VermilionDB.Settings[realm]
                and VermilionDB.Settings[realm][name] then
                VermilionDB.Settings[realm][name] = {}
            end

            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show("VERMILION_RESET_PROFILE")
end)

local totalreset = CreateFooterButton("Reset All", UIConfigMain)
totalreset:SetPoint("LEFT", reset, "RIGHT", 5, 0)
totalreset:SetScript("OnClick", function()

    StaticPopupDialogs["VERMILION_RESET_ALL"] = {
        text = "Reset ALL Vermilion settings?",
        button1 = YES,
        button2 = NO,
        OnAccept = function()
            VermilionDB.Settings = {}
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show("VERMILION_RESET_ALL")
end)

local movers = CreateFooterButton("Move UI", UIConfigMain)
movers:SetPoint("LEFT", totalreset, "RIGHT", 4, 0)
movers:SetScript("OnClick", function()
    if SlashCmdList.MOVING then
        SlashCmdList.MOVING("")
    end
end)

local ProfileButton = CreateFooterButton("Profiles", UIConfigMain)
ProfileButton:SetPoint("LEFT", movers, "RIGHT", 5, 0)
ProfileButton:SetScript("OnClick", function()
    local V, _ = Vermilion:unpack()

    if V.Profiles and V.Profiles.Toggle then
        V.Profiles:Toggle()
    elseif V.LoadProfiles then
        V.LoadProfiles()
    end
end)

local close = CreateFooterButton(CLOSE, UIConfigMain)
close:SetPoint("TOPRIGHT", UIConfig, "BOTTOMRIGHT", 0, -6)
close:SetScript("OnClick", function()
    PlaySound("igMainMenuOption")
    UIConfigMain:Hide()
end)

local load = CreateFooterButton(APPLY, UIConfigMain)
load:SetPoint("RIGHT", close, "LEFT", -4, 0)
load:SetScript("OnClick", function()
    ReloadUI()
end)
end
-- ============================================================
-- Slash Commands
-- ============================================================

SLASH_CONFIG1 = "/config"
SLASH_CONFIG2 = "/cfg"
SLASH_CONFIG3 = "/configui"
SLASH_CONFIG4 = "/Vc"
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
local V, C, L, _ = Vermilion:unpack()
local UIConfigButton = CreateFrame("Frame")
UIConfigButton:RegisterEvent("PLAYER_LOGIN")
UIConfigButton:SetScript("OnEvent", function(self)
    local Menu = GameMenuFrame
    -- Remove Blizzard textures
    for i = 1, Menu:GetNumRegions() do
        local region = select(i, Menu:GetRegions())
        if region and region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end
    -- Menu backdrop
    Menu:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 3,})
    Menu:SetBackdropColor(0.05, 0.05, 0.05, 0.0)
    Menu:SetBackdropBorderColor(0.2, 0.2, 0.2, 0)
    -- Create Vermilion button
    local VermilionButton = CreateFrame("Button", "GameMenuVermilionButton", Menu)
    VermilionButton:SetScript("OnClick", function()
        HideUIPanel(GameMenuFrame)
        if UIConfigMain and UIConfigMain:IsShown() then
            UIConfigMain:Hide()
        else
            CreateUIConfig()
        end
    end)
    local text = VermilionButton:CreateFontString(nil, "OVERLAY")
text:SetFont(C.Media.Font, 12, C.Media.Font_Style)
text:SetPoint("CENTER")
text:SetText("Vermilion")
VermilionButton:SetFontString(text)
local Width = GameMenuButtonOptions:GetWidth()
local Height = GameMenuButtonOptions:GetHeight()
local MoversButton = CreateFrame("Button", "GameMenuMoversButton", Menu)

local MoversText = MoversButton:CreateFontString(nil, "OVERLAY")
MoversText:SetFont(C.Media.Font, 12, C.Media.Font_Style)
MoversText:SetPoint("CENTER")
MoversText:SetText("Move UI")

MoversButton:SetFontString(MoversText)

V.StyleConfigButton(MoversButton)

MoversButton:SetScript("OnClick", function()
    HideUIPanel(GameMenuFrame)
    SlashCmdList.MOVING()
end)

local text = AddonListButton:CreateFontString(nil, "OVERLAY")
text:SetFont(C.Media.Font, 12, C.Media.Font_Style)
text:SetPoint("CENTER")
text:SetText(L_ADDON_LIST)
AddonListButton:SetFontString(text)


    local Buttons = {
        GameMenuButtonOptions,
        GameMenuButtonSoundOptions,
        GameMenuButtonUIOptions,
        VermilionButton,
        AddonListButton,
        MoversButton,
        GameMenuButtonKeybindings,
        GameMenuButtonMacros,
        GameMenuButtonLogout,
        GameMenuButtonQuit,
        
        GameMenuButtonContinue,
        
    }
for _, Button in ipairs(Buttons) do
    Button:SetNormalTexture(nil)
    Button:SetPushedTexture(nil)
    Button:SetHighlightTexture(nil)
    Button:SetDisabledTexture(nil)
    V.StyleConfigButton(Button)
end
    local Width = 160
    local Height = 26
    
    for i, Button in ipairs(Buttons) do
        Button:SetSize(Width, Height)
        Button:ClearAllPoints()
        if i == 1 then
            Button:SetPoint("TOP", Menu, "TOP", 0, -8)
        else
            Button:SetPoint("TOP", Buttons[i - 1], "BOTTOM", 0, -4)
        end
        V.StyleConfigButton(Button)
    end
    -- Resize menu automatically
    local TotalHeight =
        20 +
        (#Buttons * Height) +
        ((#Buttons - 1) * 4) +
        0
    Menu:SetHeight(TotalHeight)

    if GameMenuFrameHeader then
        GameMenuFrameHeader:ClearAllPoints()
        GameMenuFrameHeader:SetAlpha(0)
    end
    self:UnregisterEvent("PLAYER_LOGIN")
end)

-- ============================================================
-- Macro Frame
-- ============================================================

local MacroSkin = CreateFrame("Frame")
MacroSkin:RegisterEvent("ADDON_LOADED")

MacroSkin:SetScript("OnEvent", function(self, _, addon)

    if addon ~= "Blizzard_MacroUI" then
        return
    end

    ------------------------------------------------
    -- Main Frame
    ------------------------------------------------

    V.StripTextures(MacroFrame)

    MacroFrame:SetBackdrop(V.Backdrop)
    MacroFrame:SetBackdropColor(unpack(C.Media.Backdrop_Color))
    MacroFrame:SetBackdropBorderColor(unpack(C.Media.Border_Color))

    ------------------------------------------------
    -- Buttons
    ------------------------------------------------

    local Buttons = {
        MacroNewButton,
        MacroDeleteButton,
        MacroExitButton,
        MacroEditButton,
        MacroPopupOkayButton,
        MacroPopupCancelButton,
    }

    for _, button in ipairs(Buttons) do
        V.SkinButton(button)
    end
MacroFrameTab1:SetHeight(22)
MacroFrameTab2:SetHeight(22)

MacroFrameTab1:SetWidth(120)
MacroFrameTab2:SetWidth(120)
    ------------------------------------------------
    -- Tabs
    ------------------------------------------------

    for i = 1, 2 do
        local tab = _G["MacroFrameTab"..i]

        if tab then
            V.StripTextures(tab)
            V.StyleConfigButton(tab)
        end
    end

    ------------------------------------------------
    -- Macro Buttons
    ------------------------------------------------

    local START = MacroFrame

    for i = 1, 36 do
        local button = _G["MacroButton"..i]

        if button then
            button:ClearAllPoints()

            local col = (i - 1) % 7
            local row = math.floor((i - 1) / 7)

            button:SetPoint(
                "TOPLEFT",
                START,
                "TOPLEFT",
                24 + col * 46,
                -70 - row * 46
            )
        end
    end

    ------------------------------------------------
    -- Popup
    ------------------------------------------------

    if MacroPopupFrame then

        V.StripTextures(MacroPopupFrame)

        MacroPopupFrame:SetBackdrop(V.Backdrop)
        MacroPopupFrame:SetBackdropColor(unpack(C.Media.Backdrop_Color))
        MacroPopupFrame:SetBackdropBorderColor(unpack(C.Media.Border_Color))

        for i = 1, NUM_MACRO_ICONS_SHOWN do

            local button = _G["MacroPopupButton"..i]

            if button then

                V.StripTextures(button)
                V.CreateBorder(button)

                local icon = _G["MacroPopupButton"..i.."Icon"]

                if icon then
                    icon:SetTexCoord(.08, .92, .08, .92)
                end
            end
        end

        if MacroPopupEditBox and MacroPopupEditBox.SetBackdrop then
            MacroPopupEditBox:SetBackdrop(V.Backdrop)
            MacroPopupEditBox:SetBackdropColor(0, 0, 0, .30)
            MacroPopupEditBox:SetBackdropBorderColor(unpack(C.Media.Border_Color))
        end
    end

    ------------------------------------------------
    -- Scroll Frames
    ------------------------------------------------

    if MacroButtonScrollFrame then
        V.StripTextures(MacroButtonScrollFrame)
    end

    if MacroFrameScrollFrame then
        V.StripTextures(MacroFrameScrollFrame)
    end

    if MacroFrameTextBackground then
        MacroFrameTextBackground:Hide()
    end

    ------------------------------------------------
    -- ScrollBars
    ------------------------------------------------

    local ScrollBars = {
        "MacroButtonScrollFrameScrollBar",
        "MacroFrameScrollFrameScrollBar",
        "MacroPopupScrollFrameScrollBar",
    }

    for _, name in ipairs(ScrollBars) do

        local sb = _G[name]

        if sb then

            V.StripTextures(sb)
            V.StyleScrollBar(sb)
            sb:ClearAllPoints()
            sb:SetPoint("TOPLEFT", sb:GetParent(), "TOPRIGHT", 2, 0)
            sb:SetPoint("BOTTOMLEFT", sb:GetParent(), "BOTTOMRIGHT", 2, 0)
            local up = _G[name.."ScrollUpButton"]
            if up then
                V.StripTextures(up)
                up:SetNormalTexture("")
                up:SetPushedTexture("")
                up:SetHighlightTexture("")
                up:SetDisabledTexture("")
                up:Hide()
                up:EnableMouse(false)
            end

            local down = _G[name.."ScrollDownButton"]
            if down then
                V.StripTextures(down)
                down:SetNormalTexture("")
                down:SetPushedTexture("")
                down:SetHighlightTexture("")
                down:SetDisabledTexture("")
                down:Hide()
                down:EnableMouse(false)
            end
        end
    end

    ------------------------------------------------
    -- Selected Macro Background
    ------------------------------------------------

    if MacroFrameSelectedMacroBackground then
        V.StripTextures(MacroFrameSelectedMacroBackground)
    end

    if MacroFrameSelectedMacroButton then
        V.StripTextures(MacroFrameSelectedMacroButton)
    end

    ------------------------------------------------

    self:UnregisterEvent("ADDON_LOADED")

end)