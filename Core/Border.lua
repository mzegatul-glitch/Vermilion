-- ============================================================
-- Vermilion
-- Core/Border.lua
-- UI Framework
-- ============================================================

local V, C, _ = select(2, ...):unpack()

local _G = _G
local floor = math.floor
local pairs, type = pairs, type
local unpack = unpack

----------------------------------------------------------
-- Constants
----------------------------------------------------------

local BORDER_TEXTURE = "Interface\\AddOns\\Vermilion\\Media\\Border\\Border.blp"
local BORDER_SIZE    = 12
local TEXTURE_SIZE   = 64
local CORNER_SIZE    = 12
local OFFSET_SIZE    = 6
local BORDER_LAYER   = "OVERLAY"

borderedObjects = borderedObjects or {}

local sections = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT",
    "LEFT",
    "RIGHT",
}

-- ============================================================
-- Border
-- ============================================================

local function SetBackdropBorderColor(self, r, g, b, a)

    local t = self.BorderTextures
    if not t then
        return
    end

    if not r or not g or not b or a == 0 then
        r, g, b = unpack(C.Media.Border_Color)
    end

    for _, tex in pairs(t) do
        tex:SetVertexColor(r, g, b)
    end
end

local function GetBorderColor(self)

    return self.BorderTextures and self.BorderTextures.TOPLEFT:GetVertexColor()

end

local function SetBorderParent(self, parent)

    local t = self.BorderTextures
    if not t then
        return
    end

    parent = parent or (type(self.overlay) == "table" and self.overlay or self)

    for _, tex in pairs(t) do
        tex:SetParent(parent)
    end

    self:SetBorderSize(self:GetBorderSize())

end

local function GetBorderParent(self)

    return self.BorderTextures and self.BorderTextures.TOPLEFT:GetParent()

end

local function SetBorderSize(self, size, dL, dR, dT, dB)

    local t = self.BorderTextures

    if not t then
        return
    end

    size = size or BORDER_SIZE

    dL = dL or t.LEFT.offset or 0
    dR = dR or t.RIGHT.offset or 0
    dT = dT or t.TOP.offset or 0
    dB = dB or t.BOTTOM.offset or 0

    for _, tex in pairs(t) do
        tex:SetSize(size, size)
    end

    local d = floor(size * (OFFSET_SIZE / CORNER_SIZE) + .5)

    local parent = t.TOPLEFT:GetParent()

    t.TOPLEFT:SetPoint("TOPLEFT", parent, -d - dL, d + dT)
    t.TOPRIGHT:SetPoint("TOPRIGHT", parent, d + dR, d + dT)

    t.BOTTOMLEFT:SetPoint("BOTTOMLEFT", parent, -d - dL, -d - dB)
    t.BOTTOMRIGHT:SetPoint("BOTTOMRIGHT", parent, d + dR, -d - dB)

    t.LEFT.offset = dL
    t.RIGHT.offset = dR
    t.TOP.offset = dT
    t.BOTTOM.offset = dB

end

local function GetBorderSize(self)

    local t = self.BorderTextures

    if not t then
        return
    end

    return t.TOPLEFT:GetWidth(),
        t.LEFT.offset,
        t.RIGHT.offset,
        t.TOP.offset,
        t.BOTTOM.offset

end

function V.CreateBorder(self, size, offset, parent, layer)

    if type(self) ~= "table" or not self.CreateTexture or self.BorderTextures then
        return
    end

    local t = {}

    for i = 1, #sections do

        local tex = self:CreateTexture(nil, layer or BORDER_LAYER)

        tex:SetTexture(BORDER_TEXTURE)

        t[sections[i]] = tex

    end

    local ONE = CORNER_SIZE / TEXTURE_SIZE
    local TWO = (TEXTURE_SIZE - CORNER_SIZE) / TEXTURE_SIZE

    t.TOPLEFT:SetTexCoord(0, ONE, 0, ONE)
    t.TOP:SetTexCoord(ONE, TWO, 0, ONE)
    t.TOPRIGHT:SetTexCoord(TWO, 1, 0, ONE)

    t.RIGHT:SetTexCoord(TWO, 1, ONE, TWO)

    t.BOTTOMRIGHT:SetTexCoord(TWO, 1, TWO, 1)
    t.BOTTOM:SetTexCoord(ONE, TWO, TWO, 1)
    t.BOTTOMLEFT:SetTexCoord(0, ONE, TWO, 1)

    t.LEFT:SetTexCoord(0, ONE, ONE, TWO)

    t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT")
    t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT")

    t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT")
    t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT")

    t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT")
    t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT")

    t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT")
    t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT")

    self.BorderTextures = t

    self.SetBackdropBorderColor = SetBackdropBorderColor
    self.SetBorderParent = SetBorderParent
    self.SetBorderSize = SetBorderSize

    self.GetBorderColor = GetBorderColor
    self.GetBorderParent = GetBorderParent
    self.GetBorderSize = GetBorderSize

    if self.GetBackdrop then

        local backdrop = self:GetBackdrop()

        if type(backdrop) == "table" then

            backdrop.edgeFile = nil

            if backdrop.insets then

                backdrop.insets.left = 0
                backdrop.insets.right = 0
                backdrop.insets.top = 0
                backdrop.insets.bottom = 0

            end

            self:SetBackdrop(backdrop)

        end

    end

    table.insert(borderedObjects, self)

    self:SetBackdropBorderColor()

    self:SetBorderParent(parent)

    self:SetBorderSize(size, offset)

end

_G.CreateBorder = V.CreateBorder

-- ============================================================
-- Backdrop
-- ============================================================

-- CreateBackdrop()
-- SetTemplate()
-- SetTransparent()

-- ============================================================
-- Shadow
-- ============================================================

-- CreateShadow()
-- CreatePixelShadow()

-- ============================================================
-- Button
-- ============================================================

-- StyleButton()
-- CreateButton()

-- ============================================================
-- Panel
-- ============================================================

-- CreatePanel()

-- ============================================================
-- EditBox
-- ============================================================

-- StyleEditBox()

-- ============================================================
-- DropDown
-- ============================================================

-- StyleDropDown()

-- ============================================================
-- Slider
-- ============================================================

-- StyleSlider()

-- ============================================================
-- ScrollFrame
-- ============================================================

-- StyleScrollFrame()

-- ============================================================
-- CheckBox
-- ============================================================

-- StyleCheckBox()

-- ============================================================
-- StatusBar
-- ============================================================

-- StyleStatusBar()