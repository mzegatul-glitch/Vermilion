local V, C, L, _ = select(2, ...):unpack()

local _G = _G
local unpack, pairs, print = unpack, pairs, print
local InCombatLockdown = InCombatLockdown
local CreateFrame, UIParent = CreateFrame, UIParent
local floor = math.floor
local Symbola = "Interface\\AddOns\\Vermilion\\Media\\Fonts\\Symbola.ttf"
-- Movement Function(by Allez)
V.MoverFrames = {
	AchievementAnchor,
	ActionBarAnchor,
	BuffsAnchor,
	COOLDOWN_Anchor,
	LootRollAnchor,
	MinimapAnchor,
	PVE_PVP_CC_Anchor,
	PVE_PVP_DEBUFF_Anchor,
	P_BUFF_ICON_Anchor,
	P_PROC_ICON_Anchor,
	PetActionBarAnchor,
	PlayerCastbarAnchor,
	PlayerFrameAnchor,
	PowerBarAnchor,
	PulseCDAnchor,
	RightActionBarAnchor,
	SPECIAL_P_BUFF_ICON_Anchor,
	ShiftHolder,
	T_BUFF_Anchor,
	T_DEBUFF_ICON_Anchor,
	T_DE_BUFF_BAR_Anchor,
	TargetCastbarAnchor,


	TargetFrameAnchor,
	PetFrameAnchor,
	ToTFrameAnchor,
	Boss1FrameAnchor,
	Boss2FrameAnchor,
	Boss3FrameAnchor,
	Boss4FrameAnchor,
	
	TooltipAnchor,
	TotemHolder,
	VehicleAnchor,
	WatchFrameAnchor,
}

local moving = false
local selectedMover
local movers = {}

local function MoverFadeOthers(active, alpha)
	for _, mover in pairs(movers) do
		if mover ~= active then
			mover:SetAlpha(alpha)
		end
	end
end

local function CreateConfigButton(parent, text, width, height, font)
	local button = CreateFrame("Button", nil, parent)

	button:SetSize(width or 24, height or 24)
	button:SetTemplate("ARTWORK")

	button.Text = button:CreateFontString(nil, "OVERLAY")
	button.Text:SetPoint("CENTER")
	button.Text:SetFont(font or C.Media.Font, 13, C.Media.Font_Style)
	button.Text:SetText(text)

	-- Hover Glow
	button.Glow = button:CreateTexture(nil, "HIGHLIGHT")
	button.Glow:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	button.Glow:SetVertexColor(V.Color.r, V.Color.g, V.Color.b)
	button.Glow:SetBlendMode("ADD")
	button.Glow:SetAlpha(0)
	button.Glow:SetPoint("TOPLEFT", 3, -3)
	button.Glow:SetPoint("BOTTOMRIGHT", -3, 3)

	button:SetScript("OnEnter", function(self)
		self.Glow:SetAlpha(1)
	end)

	button:SetScript("OnLeave", function(self)
		self.Glow:SetAlpha(0)
	end)
	return button
end

local ConfigBox = CreateFrame("Frame", "Vermilion_MoverConfig", UIParent)
table.insert(UISpecialFrames, "Vermilion_MoverConfig")
ConfigBox:EnableMouse(true)
ConfigBox:SetSize(260, 140)
ConfigBox:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
ConfigBox:SetBackdrop(V.Backdrop)
ConfigBox:SetBackdropColor(0, 0, 0, .85)
ConfigBox:SetFrameLevel(20)
ConfigBox:SetBackdropBorderColor(V.Color.r, V.Color.g, V.Color.b)
ConfigBox:SetFrameStrata("DIALOG")
ConfigBox:Hide()
ConfigBox:SetMovable(true)
ConfigBox:EnableMouse(true)
ConfigBox:RegisterForDrag("LeftButton")
ConfigBox:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
ConfigBox:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)

ConfigBox.Title = ConfigBox:CreateFontString(nil, "OVERLAY")
ConfigBox.Title:SetFont(C.Media.Font, 18, C.Media.Font_Style)
ConfigBox.Title:SetPoint("TOP", 0, 8)
ConfigBox.Title:SetText("Move Config")

ConfigBox.FrameName = ConfigBox:CreateFontString(nil, "OVERLAY")
ConfigBox.FrameName:SetFont(C.Media.Font, 14, C.Media.Font_Style)
ConfigBox.FrameName:SetPoint("TOP", 0, -12)
ConfigBox.FrameName:SetText("")

ConfigBox.Close = CreateConfigButton(ConfigBox, "❌", 32, 32, Symbola)
ConfigBox.Close.Text:SetFont(Symbola, 21, "")
ConfigBox.Close:SetPoint("TOPRIGHT", -4, -4)
ConfigBox.Close:SetScript("OnClick", function()
	for _, mover in pairs(movers) do
		mover:Hide()
	end
	if grid then
		grid:Hide()
		grid = nil
	end
	ConfigBox:Hide()
	moving = false
end)

ConfigBox:SetScript("OnHide", function()
	for _, mover in pairs(movers) do
		mover:Hide()
	end
	if V.GridFrame then
		V.GridFrame:Hide()
		V.GridFrame = nil
	end
	moving = false
end)

ConfigBox.XBox = CreateFrame("EditBox", nil, ConfigBox)
ConfigBox.XBox:SetSize(50, 24)
ConfigBox.XBox:SetPoint("BOTTOMRIGHT", -11, 11)
ConfigBox.XBox:SetFont(C.Media.Font, 14, C.Media.Font_Style)
ConfigBox.XBox:SetAutoFocus(false)
ConfigBox.XBox:SetJustifyH("CENTER")

ConfigBox.XBoxBG = CreateFrame("Frame", nil, ConfigBox)
ConfigBox.XBoxBG:SetFrameLevel(ConfigBox.XBox:GetFrameLevel() - 1)
ConfigBox.XBoxBG:SetPoint("TOPLEFT", ConfigBox.XBox, -3, 3)
ConfigBox.XBoxBG:SetPoint("BOTTOMRIGHT", ConfigBox.XBox, 3, -3)
ConfigBox.XBoxBG:SetTemplate("Overlay")

ConfigBox.XLabel = ConfigBox:CreateFontString(nil, "OVERLAY")
ConfigBox.XLabel:SetFont(C.Media.Font, 12, C.Media.Font_Style)
ConfigBox.XLabel:SetPoint("RIGHT", ConfigBox.XBox, "LEFT", -4, 0)
ConfigBox.XLabel:SetText("X")
ConfigBox.XBox:SetScript("OnEnterPressed", function(self)
	if not selectedMover then return end
	local x = tonumber(self:GetText())
	if not x then return end
	local _, _, rp, _, y = selectedMover:GetPoint()
	selectedMover:ClearAllPoints()
	selectedMover:SetPoint("TOPLEFT", UIParent, rp, x, y)
	UpdateCoordinates(selectedMover)
	self:ClearFocus()
end)
ConfigBox.YBox = CreateFrame("EditBox", nil, ConfigBox)
ConfigBox.YBox:SetSize(50, 24)
ConfigBox.YBox:SetPoint("BOTTOMRIGHT", -11, 71)
ConfigBox.YBox:SetFont(C.Media.Font, 14, C.Media.Font_Style)
ConfigBox.YBox:SetAutoFocus(false)
ConfigBox.YBox:SetJustifyH("CENTER")
ConfigBox.YBoxBG = CreateFrame("Frame", nil, ConfigBox)
ConfigBox.YBoxBG:SetFrameLevel(ConfigBox.YBox:GetFrameLevel() - 1)
ConfigBox.YBoxBG:SetPoint("TOPLEFT", ConfigBox.YBox, -3, 3)
ConfigBox.YBoxBG:SetPoint("BOTTOMRIGHT", ConfigBox.YBox, 3, -3)
ConfigBox.YBoxBG:SetTemplate("Overlay")
ConfigBox.YLabel = ConfigBox:CreateFontString(nil, "OVERLAY")
ConfigBox.YLabel:SetFont(C.Media.Font, 12, C.Media.Font_Style)
ConfigBox.YLabel:SetPoint("RIGHT", ConfigBox.YBox, "LEFT", -4, 0)
ConfigBox.YLabel:SetText("Y")
ConfigBox.YBox:SetScript("OnEnterPressed", function(self)
	if not selectedMover then return end
	local y = tonumber(self:GetText())
	if not y then return end
	local _, _, rp, x, _ = selectedMover:GetPoint()
	selectedMover:ClearAllPoints()
	selectedMover:SetPoint("TOPLEFT", UIParent, rp, x, y)
	UpdateCoordinates(selectedMover)
	self:ClearFocus()
end)

local function UpdateCoordinates(mover)
	if not mover then return end
	local _, _, _, x, y = mover:GetPoint()
	ConfigBox.XBox:SetText(floor(x))
	ConfigBox.YBox:SetText(floor(y))
end

local function MoveSelected(dx, dy)
	if not selectedMover then return end
	local _, _, rp, x, y = selectedMover:GetPoint()
	selectedMover:ClearAllPoints()
	selectedMover:SetPoint("TOPLEFT", UIParent, rp, x + dx, y + dy)
if selectedMover.frame then
	local ap, _, rp, x2, y2 = selectedMover:GetPoint()
	SavedPositions[selectedMover.frame:GetName()] = {ap, "UIParent", rp, x2, y2}
end

UpdateCoordinates(selectedMover)
end
-- UP
ConfigBox.Up = CreateConfigButton(ConfigBox, "⏫", 30, 30, Symbola)
ConfigBox.Up:SetPoint("BOTTOM", ConfigBox, "BOTTOM", 20, 68)
ConfigBox.Up:SetScript("OnClick", function()
	MoveSelected(0, IsShiftKeyDown() and 10 or 1)
end)

-- LEFT
ConfigBox.Left = CreateConfigButton(ConfigBox, "⏪", 30, 30, Symbola)
ConfigBox.Left:SetPoint("BOTTOM", ConfigBox, "BOTTOM", -10, 38)
ConfigBox.Left:SetScript("OnClick", function()
	MoveSelected(-(IsShiftKeyDown() and 10 or 1), 0)
end)

-- RESET
ConfigBox.Reset = CreateConfigButton(ConfigBox, "↺", 30, 30, Symbola)
ConfigBox.Reset:SetPoint("BOTTOM", ConfigBox, "BOTTOM", 20, 38)
ConfigBox.Reset:SetScript("OnClick", function()
	if not selectedMover then
		print("NO SELECTED MOVER")
		return
	end
	local frame = selectedMover.frame
	SavedPositions[frame:GetName()] = nil
	if selectedMover.defaultPoint then
		selectedMover:ClearAllPoints()
		selectedMover:SetPoint(unpack(selectedMover.defaultPoint))
		frame:ClearAllPoints()
		frame:SetPoint(unpack(selectedMover.defaultPoint))
	else
	end
	UpdateCoordinates(selectedMover)
end)
-- RIGHT
ConfigBox.Right = CreateConfigButton(ConfigBox, "⏩", 30, 30, Symbola)
ConfigBox.Right:SetPoint("BOTTOM", ConfigBox, "BOTTOM", 50, 38)
ConfigBox.Right:SetScript("OnClick", function()
	MoveSelected(IsShiftKeyDown() and 10 or 1, 0)
end)
-- DOWN
ConfigBox.Down = CreateConfigButton(ConfigBox, "⏬", 30, 30, Symbola)
ConfigBox.Down:SetPoint("BOTTOM", ConfigBox, "BOTTOM", 20, 8)
ConfigBox.Down:SetScript("OnClick", function()
	MoveSelected(0, -(IsShiftKeyDown() and 10 or 1))
end)
local GridFrame
local function ToggleGrid()
	SlashCmdList.GRIDONSCREEN()
end
ConfigBox.Grid = CreateConfigButton(ConfigBox, "Grid", 90, 30)
ConfigBox.Grid:SetPoint("TOPLEFT", 8, -42)
ConfigBox.Grid:SetScript("OnClick", ToggleGrid)

ConfigBox.AuraWatch = CreateConfigButton(ConfigBox, "Aura", 90, 30)
ConfigBox.AuraWatch:SetPoint("LEFT", 8, -16)

ConfigBox.AuraWatch:SetScript("OnClick", function()
	print("AuraWatch Config - WIP")
end)

ConfigBox.TotalReset = CreateConfigButton(ConfigBox, "Reset", 90, 30)
ConfigBox.TotalReset:SetPoint("BOTTOMLEFT", 8, 8)

ConfigBox.TotalReset:SetScript("OnClick", function()
	StaticPopup_Show("VERMILION_RESET_MOVERS")
end)

local placed = {
	"Butsu",
	"StuffingFrameBags",
	"StuffingFrameBank",
	"alDamageMeterFrame",
	"PlayerFrame",
	"TargetFrame",
}

local SetPosition = function(mover)
	local ap, _, rp, x, y = mover:GetPoint()
	SavedPositions[mover.frame:GetName()] = {ap, "UIParent", rp, x, y}
end

local OnDragStart = function(self)
	self:StartMoving()
	self:SetScript("OnUpdate", function(frame)
		UpdateCoordinates(frame)
	end)
	self.frame:ClearAllPoints()
	self.frame:SetAllPoints(self)
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	self:SetScript("OnUpdate", nil)
	SetPosition(self)
	UpdateCoordinates(self)
end

local CreateMover = function(frame)
	local mover = CreateFrame("Frame", nil, UIParent)
	mover:SetBackdrop(V.Backdrop)
	mover:SetBackdropColor(unpack(C.Media.Backdrop_Color))
	mover:SetBackdropBorderColor(.18, .71, 1, 1)
	mover:SetAllPoints(frame)
	mover:SetFrameStrata("TOOLTIP")
	mover:EnableMouse(true)
	mover:SetMovable(true)
	mover:SetClampedToScreen(true)
	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", OnDragStart)
	mover:SetScript("OnDragStop", OnDragStop)
	-- Hover
	mover:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(V.Color.r, V.Color.g, V.Color.b)
		if V.ShowOverlayGlow then
			V.ShowOverlayGlow(self, "AutoCastGlow")
		end
		MoverFadeOthers(self, .4)
	end)
	mover:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(.18, .71, 1)
		if V.HideOverlayGlow then
			V.HideOverlayGlow(self, "AutoCastGlow")
		end
		MoverFadeOthers(nil, 1)
	end)
	
	-- Ctrl+RightClick = Reset
	-- Shift+RightClick = Hide
	mover:SetScript("OnMouseUp", function(self, button)
		if button ~= "RightButton" then return end
		if IsControlKeyDown() then
			SavedPositions[self.frame:GetName()] = nil
			if self.defaultPoint then
				self:ClearAllPoints()
				self:SetPoint(unpack(self.defaultPoint))
				self.frame:ClearAllPoints()
				self.frame:SetPoint(unpack(self.defaultPoint))
			end
				UpdateCoordinates(self)
				SetPosition(self)
		elseif IsShiftKeyDown() then
			self:Hide()
		end
	end)
	mover.frame = frame
	if frame.DefaultPoint then
	mover.defaultPoint = frame.DefaultPoint
	else
	local p1, _, p3, p4, p5 = frame:GetPoint()
	mover.defaultPoint = {p1, UIParent, p3, p4, p5}
	end
	-- Select mover
	mover:SetScript("OnMouseDown", function(self)
		selectedMover = self
		ConfigBox.FrameName:SetText(self.frame:GetName())
			UpdateCoordinates(self)
			local _, _, _, x, y = self:GetPoint()
			ConfigBox.XBox:SetText(floor(x))
			ConfigBox.YBox:SetText(floor(y))
		MoverFadeOthers(self, .4)
		self:SetAlpha(1)
	end)
	mover.name = mover:CreateFontString(nil, "OVERLAY")
	mover.name:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
	mover.name:SetPoint("CENTER")
	mover.name:SetTextColor(1, 1, 1)
	mover.name:SetText(frame:GetName())
	mover.name:SetWidth(frame:GetWidth() - 4)
	movers[frame:GetName()] = mover
	return mover
end
local GetMover = function(frame)
	if movers[frame:GetName()] then
		return movers[frame:GetName()]
	else
		return CreateMover(frame)
	end
end
local InitMove = function(msg)
	if InCombatLockdown() then print("|cffffe02e"..ERR_NOT_IN_COMBAT.."|r") return end
	if msg and (msg == "reset" or msg == "куыуе") then
		SavedPositions = {}
		for i, v in pairs(placed) do
			if _G[v] then
				_G[v]:SetUserPlaced(false)
			end
		end
		ReloadUI()
		return
	end
	if not moving then
		for i, v in pairs(V.MoverFrames) do
			local mover = GetMover(v)
			if mover then mover:Show() end
		end
		ConfigBox:ClearAllPoints()
		ConfigBox:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
		ConfigBox:Show()
		moving = true
	else
		for i, v in pairs(movers) do
			v:Hide()
		end
		ConfigBox:Hide()
		moving = false
	end
end
local RestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			RestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end
	for frame_name, point in pairs(SavedPositions) do
		if _G[frame_name] then
			_G[frame_name]:ClearAllPoints()
			_G[frame_name]:SetPoint(unpack(point))
		end
	end
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	RestoreUI(self)
end)

SlashCmdList.MOVING = InitMove
SLASH_MOVING1 = "/mm"
SLASH_MOVING2 = "/moveui"

StaticPopupDialogs["VERMILION_RESET_MOVERS"] = {
	text = "Reset all mover positions?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()

		SavedPositions = {}

		for _, mover in pairs(movers) do
			if mover.defaultPoint then
				mover:ClearAllPoints()
				mover:SetPoint(unpack(mover.defaultPoint))

				mover.frame:ClearAllPoints()
				mover.frame:SetPoint(unpack(mover.defaultPoint))
			end
		end

		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS,
}

