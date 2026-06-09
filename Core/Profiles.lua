local V, C, L, P = select(2,...):unpack()
-- Profiles.lua-ийн эхэнд нэмэх (local V, C, L, P = select(2,...):unpack()-ийн дараа)

local Profiles = CreateFrame("Frame", "Vermilion_Profiles", UIParent)

-- ============================================================
-- Layout constants
-- ============================================================
local W         = 380                       -- Base width for the content area (excluding scrollbar and padding)
local PAD       = 12                        -- Outer padding around the entire frame
local SB_GAP    = 6                         -- Gap between content area and scrollbar
local SB_W      = 14                        -- Scrollbar width
local RIGHT_PAD = PAD + SB_GAP + SB_W       -- Total right-side padding including scrollbar
local TOTAL_W   = W + PAD + RIGHT_PAD       -- Total width of the frame including content and scrollbar

local HEADER_H  = 28        -- Header height
local LABEL_H   = -10       -- Section label height
local ROW_H     = 26        -- Height of each profile row
local ROW_GAP   = 5         -- Gap between profile rows
local MAX_ROWS  = 6         -- Max number of profile rows to show without scrolling
local BTN_H     = 22        -- Button height (used in multiple places)
local BTN_PAD   = -10         -- Gap between buttons in the Import/Export section
local STATUS_H  = 20        -- Status text height in the Import/Export section
local STATUS_PAD= 6        -- EditBox padding top/bottom within the section
local EB_PAD    = 0         -- EditBox top/bottom padding within the section
local EB_H_SF   = 140       -- EditBox height in the Import/Export section
local GAP       = 10        -- Gap between sections
local SF_INSET  = 8         -- ScrollFrame inset from the section frame edges
local BTN_GAP   = 6         -- Gap between buttons in the same row

local LIST_H    = MAX_ROWS * (ROW_H + ROW_GAP)                                          -- Height of the profile list area based on max rows
local IMPORT_H  = STATUS_PAD + STATUS_H + EB_PAD + EB_H_SF + EB_PAD + BTN_H + BTN_PAD   -- Height of the Import/Export section based on its contents
local ROW_INSET   = 2                                                                   -- Inset for each profile row from the left and right edges of the list
local LISTSF_W    = W - SF_INSET * 2                                                    --ROW_INSET * 2                                                              -- Width of the ScrollFrame within the profile list section
local ROW_W       = LISTSF_W - ROW_INSET - 2                                            -- Width of each profile row, accounting for insets and scrollbar gap
local TOTAL_H   = PAD + HEADER_H + PAD + LABEL_H + LIST_H + GAP + LABEL_H + IMPORT_H + PAD -- Total height of the frame based on all sections and padding

-- Vermilion-д тохируулах
local Texture   = C.Media.Texture or "Interface\\AddOns\\Vermilion\\Media\\Textures\\UI-StatusBar.BLP"
local R, G, B   = V.Color.r or 0.3, V.Color.g or 0.6, V.Color.b or 0.9
local Prefix    = "Vermilion:Profile:"

-- ============================================================
-- Font helper (Vermilion style)
-- ============================================================
local function GetFont()
    return C.Media.Font or "Fonts\\ARIALN.ttf"
end

local function SetFontString(fs, size)
    fs:SetFont(GetFont(), size or 12, C.Media.Font_Style or "")
    fs:SetShadowColor(0, 0, 0)
    fs:SetShadowOffset(1, -1)
end

-- ============================================================
-- Quick-Switch Slots (PvP / PvE)
-- ============================================================
local SLOTS       = { "pvp", "pve" }
local SLOT_LABELS = { pvp = "|cffff6666PvP|r", pve = "|cff66ccffPvE|r" }
local SLOT_H      = STATUS_PAD + STATUS_H + BTN_PAD + BTN_H + BTN_GAP + BTN_H + BTN_PAD

local function SlotRoot()
    if not VermilionDB.QuickSlots then VermilionDB.QuickSlots = {} end
    if not VermilionDB.QuickSlots[V.Realm] then VermilionDB.QuickSlots[V.Realm] = {} end
    if not VermilionDB.QuickSlots[V.Realm][V.Name] then VermilionDB.QuickSlots[V.Realm][V.Name] = {} end
    return VermilionDB.QuickSlots[V.Realm][V.Name]
end

function Profiles:SaveSlot(slot)
    local vars, sets = {}, {}
    V.CopyTable(VermilionDB.Variables[V.Realm][V.Name], vars)
    V.CopyTable(VermilionDB.Settings[V.Realm][V.Name], sets)
    SlotRoot()[slot] = { Variables = vars, Settings = sets }
    self:RefreshSlotButtons()
end

function Profiles:LoadSlot(slot)
    local data = SlotRoot()[slot]
    if not data then return end
V.CopyTable(data.Variables, VermilionDB.Variables[V.Realm][V.Name])
V.CopyTable(data.Settings, VermilionDB.Settings[V.Realm][V.Name])
	
    ReloadUI()
end

function Profiles:RefreshSlotButtons()
    if not self.slotBtns then return end
    local root = SlotRoot()
    for _, slot in ipairs(SLOTS) do
        local btns = self.slotBtns[slot]
        if btns then
            if root[slot] then
                btns.loadLabel:SetText("Load " .. SLOT_LABELS[slot])
            else
                btns.loadLabel:SetText("|cff555555Load " .. slot .. " (empty)|r")
            end
        end
    end
end

-- ============================================================
-- Helpers
-- ============================================================
local function BG(parent, r, g, b, a)
    local t = parent:CreateTexture(nil, "BACKGROUND")
    t:SetDrawLayer("BORDER", 7)
    t:SetAllPoints()
    t:SetTexture(Texture)
    t:SetVertexColor(r, g, b, a)
    return t
end

local function HL(parent, r, g, b, a)
    local t = parent:CreateTexture(nil, "OVERLAY")
    t:SetAllPoints()
    t:SetTexture(Texture)
    t:SetVertexColor(r, g, b, a or 0.25)
    t:Hide()
    return t
end

local function MakeScrollBar(sectionFrame, topY, botY, onScroll)
    local sb = CreateFrame("Slider", nil, sectionFrame:GetParent())
    sb:SetPoint("TOPLEFT", sectionFrame, "TOPRIGHT", SB_GAP, topY)
    sb:SetPoint("BOTTOMLEFT", sectionFrame, "BOTTOMRIGHT", SB_GAP, botY)
    sb:SetWidth(SB_W)
    sb:SetOrientation("VERTICAL")
    sb:SetValueStep(1)
    sb:CreateBorder()
    BG(sb, 0.08, 0.08, 0.08, 0.9)
    sb:SetThumbTexture(Texture)
    sb:SetMinMaxValues(0, 1)
    sb:SetValue(0)
    sb:EnableMouseWheel(true)
    local thumb = sb:GetThumbTexture()
    thumb:SetSize(SB_W, 20)
    thumb:SetTexture(Texture)
    thumb:SetVertexColor(123/255, 132/255, 137/255)
    sb:SetScript("OnValueChanged", function(self) onScroll(self:GetValue()) end)
    sb:SetScript("OnMouseWheel", function(self, d)
        local lo, hi = self:GetMinMaxValues()
        self:SetValue(math.max(lo, math.min(hi, self:GetValue() - d)))
    end)
    return sb
end

-- ============================================================
-- Export / Import
-- ============================================================
function Profiles:Export()
   local s = {
    Settings = VermilionDB.Settings[V.Realm][V.Name],
    Variables = VermilionDB.Variables[V.Realm][V.Name],
    QuickSlots = SlotRoot(),
}
    return Prefix .. V.Serializer:Encode(s)
end

function Profiles:Import()
    local eb = self.IE.eb
    local status = self.IE.status

    local code = eb:GetText()

    if code == eb.exportCode then
        status:SetText("|cffff0000You are already using this profile.|r")
        return
    end

    code = code:gsub(Prefix, "")

    local ok, tbl = V.Serializer:Decode(code)

    if not ok or type(tbl) ~= "table" then
        status:SetText("|cffff0000Invalid profile code.|r")
        return
    end

    if tbl.Settings then
        wipe(VermilionDB.Settings[V.Realm][V.Name])

        V.CopyTable(
            tbl.Settings,
            VermilionDB.Settings[V.Realm][V.Name]
        )
    end

    if tbl.Variables then
        wipe(VermilionDB.Variables[V.Realm][V.Name])

        V.CopyTable(
            tbl.Variables,
            VermilionDB.Variables[V.Realm][V.Name]
        )
    end

    if tbl.QuickSlots then
        VermilionDB.QuickSlots = VermilionDB.QuickSlots or {}
        VermilionDB.QuickSlots[V.Realm] = VermilionDB.QuickSlots[V.Realm] or {}
        VermilionDB.QuickSlots[V.Realm][V.Name] = {}

        V.CopyTable(
            tbl.QuickSlots,
            VermilionDB.QuickSlots[V.Realm][V.Name]
        )
    end

    ReloadUI()
end




-- ============================================================
-- Gather profiles
-- ============================================================
local function GetAllProfiles(currentKey)
    local list = {}
    if not VermilionDB or not VermilionDB.Variables then return list end
    for realm, chars in pairs(VermilionDB.Variables) do
        if type(chars) == "table" then
            for name, data in pairs(chars) do
                if type(data) == "table" then
                    table.insert(list, { realm = realm, name = name, key = realm .. "-" .. name })
                end
            end
        end
    end
    table.sort(list, function(a, b)
        if a.key == currentKey then return true end
        if b.key == currentKey then return false end
        return a.key < b.key
    end)
    return list
end
-- ============================================================
-- Refresh
-- ============================================================
function Profiles:Refresh()
    if self.Rows then
        for _, r in ipairs(self.Rows) do
            r:Hide()
            r:SetParent(nil)
        end
    end
    self.Rows = {}

    local currentKey = V.Realm .. "-" .. V.Name
    local profiles = GetAllProfiles(currentKey)
    local sc = self.listSC

    for i, p in ipairs(profiles) do
        local cur = (p.key == currentKey)
        local row = CreateFrame("Frame", nil, sc)
        row:SetSize(ROW_W, ROW_H)
        row:SetPoint("TOPLEFT", sc, ROW_INSET, -((i - 1) * (ROW_H + ROW_GAP)) - ROW_INSET)
        row:CreateBorder()

        if cur then
            BG(row, R * 0.3, G * 0.3, B * 0.3, 0.7)
        else
            BG(row, i % 2 == 0 and 0.12 or 0.08, i % 2 == 0 and 0.12 or 0.08, i % 2 == 0 and 0.12 or 0.08, 0.9)
        end

        local lbl = row:CreateFontString(nil, "OVERLAY")
        SetFontString(lbl, 12)
        lbl:SetPoint("LEFT", row, 8, 0)
        lbl:SetWidth(ROW_W - 108)
        lbl:SetJustifyH("LEFT")

        if cur then
            local meta = VermilionDB.ProfileMeta and VermilionDB.ProfileMeta[V.Realm] and VermilionDB.ProfileMeta[V.Realm][V.Name]
            local copiedStr = ""
            if meta and meta.copiedFrom then
                copiedStr = " |cffaaaaaa- Copied from |r|cffffff00" .. meta.copiedFrom .. "|r"
            end
            lbl:SetText("|cffffd700" .. p.key .. "|r |cff00cc4c(You)|r" .. copiedStr)
        else
            lbl:SetText(p.key)
        end

        if not cur then
            local btn = CreateFrame("Button", nil, row)
            btn:SetSize(56, ROW_H - 8)
            btn:SetPoint("RIGHT", row, -(26 + 10), 0)
            btn:CreateBorder()
            BG(btn, 0.05, 0.28, 0.05, 1)
            local hl = HL(btn, 0.2, 0.8, 0.2, 0.3)
            local t = btn:CreateFontString(nil, "OVERLAY")
            SetFontString(t, 12)
            t:SetPoint("CENTER")
            t:SetText("|cff00cc4cCopy|r")
            btn:SetScript("OnEnter", function() hl:Show() end)
            btn:SetScript("OnLeave", function() hl:Hide() end)
            btn:SetScript("OnClick", function()
                StaticPopup_Show("VERMILION_COPY_PROFILE", p.key, nil, { key = p.key })
            end)
        end

        local del = CreateFrame("Button", nil, row)
        del:SetSize(26, ROW_H - 8)
        del:SetPoint("RIGHT", row, -6, 0)
        del:CreateBorder()
        local dt = del:CreateFontString(nil, "OVERLAY")
        SetFontString(dt, 12)
        dt:SetPoint("CENTER")
        if cur then
            BG(del, 0.18, 0.18, 0.18, 0.6)
            dt:SetText("|cff555555X|r")
        else
            BG(del, 0.38, 0.05, 0.05, 1)
            local hl = HL(del, 1, 0.2, 0.2, 0.3)
            dt:SetText("|cffff4444X|r")
            del:SetScript("OnEnter", function() hl:Show() end)
            del:SetScript("OnLeave", function() hl:Hide() end)
            del:SetScript("OnClick", function()
                StaticPopup_Show("VERMILION_DELETE_PROFILE_ROW", p.key, nil, { key = p.key })
            end)
        end

        table.insert(self.Rows, row)
    end

    local totalH = math.max(#profiles * (ROW_H + ROW_GAP) + ROW_INSET * 2, 1)
    sc:SetSize(ROW_W + ROW_INSET * 2, totalH)
    if #profiles == 0 then
    self.listEmpty:Show()
else
    self.listEmpty:Hide()
end

    local listSF_H = LIST_H - SF_INSET * 2
    local maxScroll = math.max(0, totalH - listSF_H)
    self.listSB:SetMinMaxValues(0, maxScroll)
    self.listSB:SetValue(0)
    if maxScroll > 0 then
        self.listSF:SetScript("OnMouseWheel", function(_, d)
            local cur = self.listSF:GetVerticalScroll()
            local new = math.max(0, math.min(maxScroll, cur - d * (ROW_H + ROW_GAP)))
            self.listSF:SetVerticalScroll(new)
            self.listSB:SetValue(new)
        end)
    else
        self.listSF:SetScript("OnMouseWheel", nil)
    end

    -- Export box
    local code = self:Export()
    self.IE.eb.exportCode = code
    self.IE.eb:SetText(code)
    self.IE.eb:SetCursorPosition(0)
    self.IE.eb:HighlightText()
    
    local class = select(2, UnitClass("player"))
    -- V.Colors.class байгаа эсэхийг шалгах
    local classColor = V.Colors and V.Colors.class and V.Colors.class[V.Class] or {1, 1, 1}
    local cc = V.RGBToHex and V.RGBToHex(unpack(classColor)) or "|cffffffff"
    self.IE.status:SetText("Export for: " .. cc .. V.Class .. "|r |cffaaaaaa- |r" .. cc .. V.Name .. "|r  |cffaaaaaa(click box, Ctrl+C)|r")

    -- Refresh quick-slot button states
    self:RefreshSlotButtons()
end

-- ============================================================
-- Toggle
-- ============================================================
function Profiles:Toggle()
    if self:IsShown() then
        self:Hide()
    else
        self:Refresh()
        self:Show()
    end
end

-- ============================================================
-- Toggle
-- ============================================================
function Profiles:DeleteProfile(key)
    local realm, name = strsplit("-", key)

    if realm and name then
        if VermilionDB.Settings and VermilionDB.Settings[realm] then
            VermilionDB.Settings[realm][name] = nil
        end

        if VermilionDB.Variables and VermilionDB.Variables[realm] then
            VermilionDB.Variables[realm][name] = nil
        end

        if VermilionDB.ProfileMeta and VermilionDB.ProfileMeta[realm] then
            VermilionDB.ProfileMeta[realm][name] = nil
        end

        if VermilionDB.QuickSlots and VermilionDB.QuickSlots[realm] then
            VermilionDB.QuickSlots[realm][name] = nil
        end
    end

    self:Refresh()
end
-- ============================================================
-- CopyProfile
-- ============================================================
function Profiles:CopyProfile(key)

    local realm, char = strsplit("-", key)

    if not realm or not char then
        return
    end

    if not VermilionDB.Settings[realm] then return end
    if not VermilionDB.Settings[realm][char] then return end

    wipe(VermilionDB.Settings[V.Realm][V.Name])
    wipe(VermilionDB.Variables[V.Realm][V.Name])

    V.CopyTable(
        VermilionDB.Settings[realm][char],
        VermilionDB.Settings[V.Realm][V.Name]
    )

    V.CopyTable(
        VermilionDB.Variables[realm][char],
        VermilionDB.Variables[V.Realm][V.Name]
    )

    VermilionDB.ProfileMeta = VermilionDB.ProfileMeta or {}
    VermilionDB.ProfileMeta[V.Realm] = VermilionDB.ProfileMeta[V.Realm] or {}
    VermilionDB.ProfileMeta[V.Realm][V.Name] = {
        copiedFrom = key,
        created = time(),
        modified = time(),
        version = 1,
    }

    ReloadUI()
end
-- ============================================================
-- Enable
-- ============================================================
function Profiles:Enable()
    local LIST_H_local = MAX_ROWS * (ROW_H + ROW_GAP)
    local TOTAL_H_local = PAD + HEADER_H + PAD
        + LABEL_H + LIST_H_local + GAP
        + LABEL_H + IMPORT_H + GAP
        + LABEL_H + SLOT_H + PAD

    self:SetSize(TOTAL_W, TOTAL_H_local)
    self:SetFrameStrata("DIALOG")
    self:SetPoint("CENTER", UIParent, 0, 60)
    self:CreateBorder()
    --BG(self, 0.08, 0.08, 0.08, 0.9)
    self:SetResizable(true)
    self:SetMinResize(420, 500)
    self:SetMaxResize(1000, 900)
    
    self:Hide()

    if V.CreateMoverFrame then
        V.CreateMoverFrame(self)
    else    
        self:SetMovable(true)
        self:EnableMouse(true)
        self:RegisterForDrag("LeftButton")
        self:SetScript("OnDragStart", function() self:StartMoving() end)
        self:SetScript("OnDragStop", function() self:StopMovingOrSizing() end)
        
    end
    -- Header
    local header = CreateFrame("Frame", nil, self)
    header:SetHeight(HEADER_H)
    header:SetPoint("TOPLEFT", self, PAD, -PAD)
    header:SetPoint("TOPRIGHT", self, -PAD, -PAD)
    header:CreateBorder()
    BG(header, R * 0, G * 0, B * 0, 0.7)

    local title = header:CreateFontString(nil, "OVERLAY")
    SetFontString(title, 14)
    title:SetPoint("CENTER", header)
    title:SetText("|cffFFCC66Profile Manager|r")
    table.insert(UISpecialFrames, "Vermilion_Profiles")
    local closeBtn = V.CreateCloseButton(header, 32, 32, 28)
    closeBtn:SetPoint("TOPRIGHT", 0, 0)
    closeBtn:SetScript("OnClick", function()
        Profiles:Hide()
        if V.GUI and not V.GUI:IsShown() then V.GUI:Toggle() end
    end)

    local topY = -(PAD + HEADER_H + PAD)

    local function SectionLabel(text)
        local lbl = self:CreateFontString(nil, "OVERLAY")
        SetFontString(lbl, 12)
        lbl:SetPoint("TOPLEFT", self, PAD, topY)
        lbl:SetText("|cffbbbbbb" .. text .. "|r")
        topY = topY - LABEL_H - 2
    end

    local function Section(h)
        local f = CreateFrame("Frame", nil, self)
        f:SetHeight(h)
        f:SetPoint("TOPLEFT", self, PAD, topY)
        f:SetPoint("TOPRIGHT", self, -RIGHT_PAD, topY)
        topY = topY - h - GAP
        return f
    end

    -- Profile list
    SectionLabel("")
    local listFrame = Section(LIST_H_local)
    self.listFrame = listFrame
    listFrame:CreateBorder()
    BG(listFrame, 0.05, 0.05, 0.05, 0.8)

    local listSF = CreateFrame("ScrollFrame", nil, listFrame)
    listSF:SetPoint("TOPLEFT", listFrame, SF_INSET, -SF_INSET)
    listSF:SetPoint("BOTTOMRIGHT", listFrame, -SF_INSET, SF_INSET)
    listSF:EnableMouseWheel(true)
    self.listSF = listSF

    local listSC = CreateFrame("Frame", nil, listSF)
    listSC:SetSize(ROW_W, 1)
    listSF:SetScrollChild(listSC)
    self.listSC = listSC

    self.listSB = MakeScrollBar(listFrame, 0, 0, function(v)
        listSF:SetVerticalScroll(v)
    end)

    self.listEmpty = listFrame:CreateFontString(nil, "OVERLAY")
    SetFontString(self.listEmpty, 12)
    self.listEmpty:SetPoint("CENTER", listFrame)
    self.listEmpty:SetText("|cffaaaaaaNo profiles found in the database.|r")
    self.listEmpty:Hide()

    -- Quick-Switch Slots
    SectionLabel("")
    local slotFrame = Section(SLOT_H)
    --slotFrame:CreateBorder()
    --BG(slotFrame, 0.05, 0.05, 0.05, 0.8)

    self.slotBtns = {}
    local contentW = self:GetWidth() - (PAD * 2)
    local colW = math.floor((contentW - BTN_GAP) / 2)

    local leftX = 0
    local rightX = colW + BTN_GAP

    for i, slot in ipairs(SLOTS) do
    local xOff = (i == 1) and leftX or rightX

        local lbl = SLOT_LABELS[slot]

        local saveB = CreateFrame("Button", nil, slotFrame)
        saveB:SetSize(colW, BTN_H)
        saveB:SetPoint("TOPLEFT",slotFrame,xOff,-6)
        saveB:CreateBorder()
        V.StyleConfigButton(saveB)
        local st = saveB:CreateFontString(nil, "OVERLAY")
        SetFontString(st, 12)
        st:SetPoint("CENTER")
        st:SetText("Save -> " .. lbl)
        saveB:SetScript("OnClick", function()
            Profiles:SaveSlot(slot)
            slotStatus:SetText(lbl .. "|cffaaaaaa slot saved.|r")
        end)

        local loadB = CreateFrame("Button", nil, slotFrame)
        loadB:SetSize(colW, BTN_H)
        loadB:SetPoint("TOPLEFT", slotFrame, xOff, -(BTN_H + BTN_GAP + 8))
        V.StyleConfigButton(loadB)
        local lt = loadB:CreateFontString(nil, "OVERLAY")
        SetFontString(lt, 12)
        lt:SetPoint("CENTER")
        lt:SetText("|cff555555Load " .. slot .. " (empty)|r")
        loadB:SetScript("OnClick", function()
            if not SlotRoot()[slot] then
                slotStatus:SetText("|cffff0000No " .. slot .. " slot saved yet.|r")
                return
            end
            Profiles:LoadSlot(slot)
        end)

        self.slotBtns[slot] = { save = saveB, load = loadB, loadLabel = lt }
    end

    -- Export / Import
    --SectionLabel("Export / Import")
    local importFrame = Section(IMPORT_H)
    self.IE = {}
    importFrame:CreateBorder()
    BG(importFrame, 0.05, 0.05, 0.05, 0.8)

    local status = importFrame:CreateFontString(nil, "BORDER")
    status:SetDrawLayer("BORDER", 7)
    SetFontString(status, 12)
    status:SetPoint("TOPLEFT", importFrame, SF_INSET, -STATUS_PAD)
    status:SetPoint("TOPRIGHT", importFrame, -SF_INSET, -STATUS_PAD)
    status:SetHeight(STATUS_H)
    status:SetJustifyH("LEFT")
    status:SetJustifyV("TOP")
    self.IE.status = status

    local contentW = self:GetWidth() - (PAD * 2)
    local colW = math.floor((contentW - BTN_GAP) / 2)

    local leftX = 0
    local rightX = colW + BTN_GAP

    -- Apply
    local applyBtn = CreateFrame("Button", nil, importFrame)
    applyBtn:SetSize(colW, BTN_H)
    applyBtn:SetPoint("BOTTOMLEFT", importFrame, leftX, BTN_PAD - 20)
    V.StyleConfigButton(applyBtn)

    local at = applyBtn:CreateFontString(nil, "OVERLAY")
    SetFontString(at, 12)
    at:SetPoint("CENTER")
    at:SetText("|cff00cc4cApply (Import)|r")

    applyBtn:SetScript("OnClick", function()
        Profiles:Import()
    end)

    -- Reset
    local resetBtn = CreateFrame("Button", nil, importFrame)
    resetBtn:SetSize(colW, BTN_H)
    resetBtn:SetPoint("BOTTOMLEFT", importFrame, rightX, BTN_PAD - 20)
    V.StyleConfigButton(resetBtn)

    local rt = resetBtn:CreateFontString(nil, "OVERLAY")
    SetFontString(rt, 12)
    rt:SetPoint("CENTER")
    rt:SetText("|cff6699ffReset|r")

    resetBtn:SetScript("OnClick", function()
        local eb = self.IE.eb
        eb:SetText(eb.exportCode)
        eb:SetCursorPosition(0)
        eb:HighlightText()

        local classColor = V.Colors and V.Colors.class and V.Colors.class[V.Class] or {1, 1, 1}
        local cc2 = V.RGBToHex and V.RGBToHex(unpack(classColor)) or "|cffffffff"

        self.IE.status:SetText("Export for: " .. cc2 .. V.Class .. "|r |cffaaaaaa- |r" .. cc2 .. V.Name .. "|r  |cffaaaaaa(click box, Ctrl+C)|r")
    end)

    local ebTop = -(STATUS_PAD + STATUS_H + EB_PAD)
    local ebBot = BTN_PAD + BTN_H + EB_PAD

    local ebSF = CreateFrame("ScrollFrame", nil, importFrame)
    ebSF:SetPoint("TOPLEFT", importFrame, SF_INSET, ebTop)
    ebSF:SetPoint("BOTTOMRIGHT", importFrame, -SF_INSET, ebBot)
    ebSF:EnableMouseWheel(true)

    local ebSB = CreateFrame("Slider", nil, self)
    ebSB:SetPoint("TOPLEFT", importFrame, "TOPRIGHT", SB_GAP, 0)
    ebSB:SetPoint("BOTTOMLEFT", importFrame, "BOTTOMRIGHT", SB_GAP, 0)
    ebSB:SetWidth(SB_W)
    ebSB:SetOrientation("VERTICAL")
    ebSB:SetValueStep(1)
    ebSB:CreateBorder()
    BG(ebSB, 0.08, 0.08, 0.08, 0.9)
    ebSB:SetThumbTexture(Texture)
    ebSB:SetMinMaxValues(0, 1)
    ebSB:SetValue(0)
    ebSB:EnableMouseWheel(true)
    local thumb = ebSB:GetThumbTexture()
    thumb:SetSize(SB_W, 20)
    thumb:SetTexture(Texture)
    thumb:SetVertexColor(123/255, 132/255, 137/255)
    ebSB:SetScript("OnValueChanged", function(self) ebSF:SetVerticalScroll(self:GetValue()) end)
    ebSB:SetScript("OnMouseWheel", function(self, d)
        local lo, hi = self:GetMinMaxValues()
        self:SetValue(math.max(lo, math.min(hi, self:GetValue() - d)))
    end)
    self.IE.ebSB = ebSB

    local eb = CreateFrame("EditBox", nil, ebSF)
    eb:SetMultiLine(true)
    eb:SetAutoFocus(false)
    eb:SetFontObject(ChatFontNormal)
    eb:SetWidth(ROW_W)
    eb:SetHeight(EB_H_SF * 3)
    eb:SetTextInsets(4, 4, 4, 4)
    eb:EnableMouse(true)
    ebSF:SetScrollChild(eb)

    eb:SetScript("OnTextChanged", function(self)
        local maxScroll = math.max(0, self:GetHeight() - ebSF:GetHeight())
        ebSB:SetMinMaxValues(0, maxScroll)
        if self:GetText() ~= self.exportCode then
            status:SetText("|cffffff00Paste a profile code here and click Apply to import.|r")
        end
    end)
    ebSF:SetScript("OnMouseWheel", function(_, d)
        local cur = ebSF:GetVerticalScroll()
        local _, max = ebSB:GetMinMaxValues()
        local new = math.max(0, math.min(max, cur - d * 20))
        ebSF:SetVerticalScroll(new)
        ebSB:SetValue(new)
    end)
    eb:SetScript("OnMouseUp", function(self)
        self:HighlightText()
        self:SetFocus()
    end)
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    self.IE.eb = eb
end
StaticPopupDialogs["VERMILION_COPY_PROFILE"] = {
    text = "Copy profile from\n|cffffff00%s|r ?",
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,

    OnAccept = function(self, data)
        Profiles:CopyProfile(data.key)
    end,
}
StaticPopupDialogs["VERMILION_DELETE_PROFILE_ROW"] = {
    text = "Delete profile\n|cffffff00%s|r ?",
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,

    OnAccept = function(self, data)
        if data and data.key then
            Profiles:DeleteProfile(data.key)
        end
    end,
}
V.Profiles = Profiles
