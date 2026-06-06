local V, C, L, _ = select(2, ...):unpack()
if C.Bag.Enable ~= true then return end

local match = string.match
local tonumber = tonumber
local select = select
local ipairs = ipairs
local floor = math.floor
local setmetatable = setmetatable
local collectgarbage = collectgarbage
local wipe = table.wipe
local GetCoinTextureString = GetCoinTextureString
local CreateFrame, UIParent = CreateFrame, UIParent
local GetContainerItemCooldown = GetContainerItemCooldown
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetName = GetName
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local Loader = CreateFrame("Frame")

Loader:RegisterEvent("ADDON_LOADED")
local Loader = CreateFrame("Frame")

Loader:RegisterEvent("ADDON_LOADED")

Loader:SetScript("OnEvent", function(self, event, addon)

	if addon ~= "Vermilion" then
		return
	end

	if not StuffingBankSnapshotDB then
		StuffingBankSnapshotDB = {}
	end
end)

Loader:SetScript("OnEvent", function(self, event, addon)

	if addon ~= "Vermilion" then
		return
	end

	VermilionDB = VermilionDB or {}

	VermilionDB.BankSnapshot =
		VermilionDB.BankSnapshot or {}

	--print(
	--	"Snapshot loaded:",
	--	#VermilionDB.BankSnapshot
	--)
end)
local InitFrame = CreateFrame("Frame")

InitFrame:RegisterEvent("PLAYER_LOGIN")

InitFrame:SetScript("OnEvent", function()

	if not VermilionDB then
		VermilionDB = {}
	end

	if not VermilionDB.BankSnapshot then
		VermilionDB.BankSnapshot = {}
	end

	--print("Snapshot DB Ready")

end)

--[[
A featureless, 'pure' version of Stuffing.
This version should work on absolutely everything,
but I've removed pretty much all of the options.

All credits of this bags script is by Stuffing and his author Hungtar.
--]]

local BAGS_BACKPACK = {0, 1, 2, 3, 4}
local BAGS_BANK = {-1, 5, 6, 7, 8, 9, 10, 11}
local ST_NORMAL = 1
local ST_SOULBAG = 2
local ST_SPECIAL = 3
local ST_QUIVER = 4
local bag_bars = 1
local hide_soulbag = C.Bag.HideSoulBag

-- Hide bags options in default interface
InterfaceOptionsDisplayPanelShowFreeBagSpace:Hide()

Stuffing = CreateFrame("Frame", nil, UIParent)
Stuffing:RegisterEvent("ADDON_LOADED")
Stuffing:RegisterEvent("PLAYER_ENTERING_WORLD")
Stuffing:SetScript("OnEvent", function(this, event, ...)
	if IsAddOnLoaded("AdiBags") or IsAddOnLoaded("cargBags_Nivaya") or IsAddOnLoaded("cargBags") or IsAddOnLoaded("Bagnon") or IsAddOnLoaded("Combuctor") then return end
	Stuffing[event](this, ...)
end)

local function Stuffing_OnShow()
	Stuffing:PLAYERBANKSLOTS_CHANGED(29)

	for i = 0, #BAGS_BACKPACK - 1 do
		Stuffing:BAG_UPDATE(i)
	end

	Stuffing:Layout()
	Stuffing:SearchReset()
	PlaySound("igBackPackOpen")
	collectgarbage("collect")
end

local function StuffingBank_OnHide()
	CloseBankFrame()
	if Stuffing.frame:IsShown() then
		Stuffing.frame:Hide()
	end
	PlaySound("igBackPackClose")
end

local function Stuffing_OnHide()
	if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
		Stuffing.bankFrame:Hide()
	end
	PlaySound("igBackPackClose")
end

local function Stuffing_Open()
	if not Stuffing.frame:IsShown() then
		Stuffing.frame:Show()
	end
end

local function Stuffing_Close()
	Stuffing.frame:Hide()
end

local function Stuffing_Toggle()
	if Stuffing.frame:IsShown() then
		Stuffing.frame:Hide()
	else
		Stuffing.frame:Show()
	end
end

local function Stuffing_ToggleBag(id)
	if id == -2 then
		ToggleKeyRing()
		return
	end
	Stuffing_Toggle()
end

-- bag slot stuff
local trashButton = {}
local trashBag = {}

-- mostly from carg.bags_Aurora
local QUEST_ITEM_STRING = nil

function Stuffing:SlotUpdate(b)
	local count = _G[b.frame:GetName().."Count"]

	if count then
		count:SetDrawLayer("OVERLAY")
		count:SetAlpha(1)
		count:Show()
	end

	local texture, itemCount, locked = GetContainerItemInfo(b.bag, b.slot)
	local clink = GetContainerItemLink(b.bag, b.slot)

	if b.cooldown and StuffingFrameBags and StuffingFrameBags:IsShown() then
		local start, duration, enable = GetContainerItemCooldown(b.bag, b.slot)
		CooldownFrame_SetTimer(b.cooldown, start, duration, enable)
	end

	if(clink) then
		local iType
		b.name, _, b.rarity, _, _, iType = GetItemInfo(clink)

		if QUEST_ITEM_STRING == nil then
			-- GetItemInfo returns a localized item type.
			-- this is to figure out what that string is.
			local t = {GetAuctionItemClasses()}
			QUEST_ITEM_STRING = t[#t]	-- #t == 12
		end

		if iType and iType == QUEST_ITEM_STRING then
			--V.Print(iType .. " " .. b.name)
			b.qitem = true
		else
			b.qitem = nil
		end

	else
		b.name, b.rarity, b.qitem = nil, nil, nil
	end

SetItemButtonTexture(b.frame, texture)
SetItemButtonCount(b.frame, itemCount)
SetItemButtonDesaturated(b.frame, locked)
if not b.iLevelBG then

	b.iLevelBG = CreateFrame(
		"Frame",
		nil,
		b.frame
	)

	b.iLevelBG:SetAllPoints(b.frame)
	b.iLevelBG:SetFrameLevel(
		b.frame:GetFrameLevel() + 20
	)

	b.iLevel = b.iLevelBG:CreateFontString(
		nil,
		"ARTWORK"
	)

	b.iLevel:SetFont(
		STANDARD_TEXT_FONT,
		11,
		"OUTLINE"
	)

	b.iLevel:SetPoint(
		"BOTTOMRIGHT",
		b.frame,
		"BOTTOMRIGHT",
		-1,
		2
	)

	b.iLevel:SetJustifyH("RIGHT")

	b.iLevel:SetShadowColor(
		0,
		0,
		0,
		1
	)

	b.iLevel:SetShadowOffset(
		1,
		-1
	)
end

if clink then

	local itemName, _, quality, itemLevel,
		_, _, _, equipSlot, _, _, itemType =
		GetItemInfo(clink)

	local isEquip =
		(
			itemType == "Armor"
			or itemType == "Weapon"
		)
		and equipSlot
		and equipSlot ~= ""

	if isEquip
	and itemLevel
	and itemLevel > 0 then

		local r, g, bq =
			GetItemQualityColor(
				quality or 1
			)

		b.iLevel:SetFormattedText(
	"|cff%s%d|r",
	select(
		4,
		GetItemQualityColor(
			quality or 1
		)
	),
	itemLevel
)
		b.iLevel:SetTextColor(r, g, bq)
		b.iLevel:Show()
		b.iLevel:Raise()

	else

		b.iLevel:SetText("")
		b.iLevel:Hide()
	end

else

	b.iLevel:SetText("")
	b.iLevel:Hide()
end

	if b.Glow then
		b.Glow:Hide()
		if b.rarity then
			if b.rarity > 1 then
				b.Glow:SetVertexColor(GetItemQualityColor(b.rarity))
				b.Glow:Show()
			elseif b.qitem then
				b.Glow:SetVertexColor(1, 1, 0)
				b.Glow:Show()
			end
		end
	end

	b.frame:Show()
end

function Stuffing:BagSlotUpdate(bag)
	if not self.buttons then
		return
	end

	for _, b in ipairs(self.bagframe_buttons) do
		b.frame:SetAlpha(1)
		b.frame:Show()

		local icon = _G[b.frame:GetName().."IconTexture"]
		if icon then
			icon:SetAlpha(1)
			icon:Show()
		end
	end

	for _, v in ipairs(self.buttons) do
		if v.bag == bag then
			self:SlotUpdate(v)
		end
	end
end

function Stuffing:BagFrameSlotNew(slot, p)

	for _, v in ipairs(self.bagframe_buttons) do
		if v.slot == slot then
			return v, false
		end
	end

	local ret = {}

	if slot > 3 then

		ret.slot = slot
		slot = slot - 4

		ret.frame = CreateFrame(
			"CheckButton",
			"StuffingBBag"..slot,
			p,
			"BankItemButtonBagTemplate"
		)

		ret.frame:StripTextures()
		ret.frame:SetID(slot + 4)

		table.insert(
			self.bagframe_buttons,
			ret
		)

		BankFrameItemButton_Update(
			ret.frame
		)

		BankFrameItemButton_UpdateLocked(
			ret.frame
		)

		if not ret.frame.tooltipText then
			ret.frame.tooltipText = ""
		end

	else

		ret.frame = CreateFrame(
			"CheckButton",
			"StuffingFBag"..slot.."Slot",
			p,
			"BagSlotButtonTemplate"
		)

		ret.frame:StripTextures()

		ret.slot = slot

		table.insert(
			self.bagframe_buttons,
			ret
		)
	end

	ret.frame:CreateBackdrop(2)

	ret.frame:SetNormalTexture("")
	ret.frame:SetPushedTexture("")
	ret.frame:SetHighlightTexture("")
	ret.frame:SetCheckedTexture("")

	ret.icon =
		_G[
			ret.frame:GetName()
			.."IconTexture"
		]

	if ret.icon then

		ret.icon:SetTexCoord(
			0.08,
			0.92,
			0.08,
			0.92
		)

		ret.icon:ClearAllPoints()

		ret.icon:SetPoint(
			"TOPLEFT",
			ret.frame,
			2,
			-2
		)

		ret.icon:SetPoint(
			"BOTTOMRIGHT",
			ret.frame,
			-2,
			2
		)

		ret.icon:SetDrawLayer(
			"ARTWORK"
		)

		ret.icon:SetAlpha(1)
		ret.icon:Show()
	end

	return ret
end
function Stuffing:SlotNew(bag, slot)
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			v.lock = false
			return v, false
		end
	end

	local tpl = "ContainerFrameItemButtonTemplate"

	if bag == -1 then
		tpl = "BankItemButtonGenericTemplate"
	end

	local ret = {}

	if #trashButton > 0 then
		local f = -1
		for i, v in ipairs(trashButton) do
			local b, s = v:GetName():match("(%d+)_(%d+)")

			b = tonumber(b)
			s = tonumber(s)

			if b == bag and s == slot then
				f = i
				break
			else
				v:Hide()
			end
		end

		if f ~= -1 then
			ret.frame = trashButton[f]
			table.remove(trashButton, f)
			ret.frame:Show()
		end
	end

	if not ret.frame then
		ret.frame = CreateFrame("Button", "StuffingBag"..bag.."_"..slot, self.bags[bag], tpl)

		local c = _G[ret.frame:GetName().."Count"]
		c:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
		c:SetPoint("BOTTOMRIGHT", 1, 1)
	end

	if 1 == 1 and not ret.Glow then
		-- from carg.bags_Aurora
		local glow = ret.frame:CreateTexture(nil, "OVERLAY")
		glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		glow:SetBlendMode("ADD")
		glow:SetAlpha(.8)
		glow:SetPoint("CENTER", ret.frame)
		ret.Glow = glow
	end

	ret.bag = bag
	ret.slot = slot
	ret.frame:SetID(slot)

	ret.cooldown = _G[ret.frame:GetName().."Cooldown"]
	ret.cooldown:SetInside()
	ret.cooldown:Show()

	self:SlotUpdate(ret)

	return ret, true
end

-- from OneBag
local BAGTYPE_QUIVER = 0x0001 + 0x0002
local BAGTYPE_SOUL = 0x004
local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400

function Stuffing:BagType(bag)
	local bagType = select(2, GetContainerNumFreeSlots(bag))

	if bagType and bit.band(bagType, BAGTYPE_QUIVER) > 0 then
		return ST_QUIVER
	elseif bagType and bit.band(bagType, BAGTYPE_SOUL) > 0 then
		return ST_SOULBAG
	elseif bagType and bit.band(bagType, BAGTYPE_PROFESSION) > 0 then
		return ST_SPECIAL
	end

	return ST_NORMAL
end

function Stuffing:BagNew(bag, f)
	for i, v in pairs(self.bags) do
		if v:GetID() == bag then
			v.bagType = self:BagType(bag)
			return v
		end
	end

	local ret

	if #trashBag > 0 then
		local f = -1
		for i, v in pairs(trashBag) do
			if v:GetID() == bag then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret = trashBag[f]
			table.remove(trashBag, f)
			ret:Show()
			ret.bagType = self:BagType(bag)
			return ret
		end
	end

	ret = CreateFrame("Frame", "StuffingBag"..bag, f)
	ret.bagType = self:BagType(bag)

	ret:SetID(bag)
	return ret
end

function Stuffing:SearchUpdate(str)
	str = string.lower(str)

	for _, b in ipairs(self.buttons) do
		if b.name then
			if not string.find(string.lower(b.name), str) then
				SetItemButtonDesaturated(b.frame, true)
				if b.Glow then
					b.Glow:Hide()
				end
			else
				SetItemButtonDesaturated(b.frame, false)
				if b.Glow then
					b.Glow:Show()
					b.Glow:SetVertexColor(0.8, 0.8, 0.3)
				end
			end
		end
	end
end

function Stuffing:SearchUpdate(str)
	str = string.lower(str)

	for _, b in ipairs(self.buttons) do
		if b.frame and not b.name then
			b.frame:SetAlpha(0.2)
		end
		if b.name then
			setName = setName or ""
			local ilink = GetContainerItemLink(b.bag, b.slot)
			local _, equipSlot = select(6, GetItemInfo(ilink))
			local minLevel = select(5, GetItemInfo(ilink))
			equipSlot = _G[equipSlot] or ""
			if not string.find(string.lower(b.name), str) and not string.find(string.lower(equipSlot), str) then
				if minLevel > V.Level then
					_G[b.frame:GetName().."IconTexture"]:SetVertexColor(0.5, 0.5, 0.5)
				end
				SetItemButtonDesaturated(b.frame, true)
				b.frame:SetAlpha(0.2)
			else
				if minLevel > V.Level then
					_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 0.1, 0.1)
				end
				SetItemButtonDesaturated(b.frame, false)
				b.frame:SetAlpha(1)
			end
		end
	end
end

function Stuffing:SearchReset()
	for _, b in ipairs(self.buttons) do
		if (b.level and b.level > V.Level) then
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 0.1, 0.1)
		end

		local count = _G[b.frame:GetName().."Count"]
		if count then
			count:Show()
			count:SetAlpha(1)
		end

		b.frame:SetAlpha(1)
		SetItemButtonDesaturated(b.frame, false)
	end
end

-- Drop down menu stuff from Postal
local Stuffing_DDMenu = CreateFrame("Frame", "StuffingDropDownMenu")
Stuffing_DDMenu.displayMode = "MENU"
Stuffing_DDMenu.info = {}
Stuffing_DDMenu.HideMenu = function()
	if UIDROPDOWNMENU_OPEN_MENU == Stuffing_DDMenu then
		CloseDropDownMenus()
	end
end

local function DragFunction(self, mode)
	for index = 1, select("#", self:GetChildren()) do
		local frame = select(index, self:GetChildren())
		if frame:GetName() and frame:GetName():match("StuffingBag") then
			if mode then
				frame:Hide()
			else
				frame:Show()
			end
		end
	end
end

function Stuffing:CreateBagFrame(w)
	local n = "StuffingFrame" .. w
	local f = CreateFrame("Frame", n, UIParent)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(5)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		if IsShiftKeyDown() then
			self:StartMoving()
			DragFunction(self, true)
		end
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		DragFunction(self, false)
	end)

	if w == "Bank" then
		f:SetPoint(unpack(C.Position.Bank))
	else
		f:SetPoint(unpack(C.Position.Bag))
	end

	if w == "Bank" then
		-- Buy button
		f.b_purchase = CreateFrame("Button", "StuffingPurchaseButton"..w, f)
		f.b_purchase:SetSize(80, 20)
		f.b_purchase:SetPoint("TOPLEFT", 10, -4)
		f.b_purchase:RegisterForClicks("AnyUp")
		f.b_purchase:SetScript("OnClick", function(self) StaticPopup_Show("CONFIRM_BUY_BANK_SLOT") end)
		f.b_purchase:FontString("text", C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
		f.b_purchase.text:SetPoint("CENTER")
		f.b_purchase.text:SetText("|cff2eb6ff"..BANKSLOTPURCHASE.."|r")
		f.b_purchase:SetFontString(f.b_purchase.text)
		local _, full = GetNumBankSlots()
		if full then
			f.b_purchase:Hide()
		else
			f.b_purchase:Show()
		end
	end

	-- close button
	f.b_close = CreateFrame("Button", "Stuffing_CloseButton"..w, f, "UIPanelCloseButton")
	f.b_close:SetSize(32, 32)
	f.b_close:RegisterForClicks("AnyUp")
	f.b_close:SetPoint("TOPRIGHT", -3, -3)
	f.b_close:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if Stuffing_DDMenu.initialize ~= Stuffing.Menu then
				CloseDropDownMenus()
				Stuffing_DDMenu.initialize = Stuffing.Menu
			end
			ToggleDropDownMenu(nil, nil, Stuffing_DDMenu, self:GetName(), 0, 0)
			return
		end
		self:GetParent():Hide()
	end)

	local tooltip_hide = function()
		GameTooltip:Hide()
	end

	local tooltip_show = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT", 19, 7)
		GameTooltip:ClearLines()
		GameTooltip:SetText(L_BAG_RIGHT_CLICK_CLOSE)
	end

	f.b_close:HookScript("OnEnter", tooltip_show)
	f.b_close:HookScript("OnLeave", tooltip_hide)

	-- create the bags frame
	local fb = CreateFrame("Frame", n.."BagsFrame", f)
	-- fb position handled in Layout()
	fb:SetFrameStrata("MEDIUM")
	f.bags_frame = fb

	return f
end

function Stuffing:InitBank()
	if self.bankFrame then
		return
	end

	local f = self:CreateBagFrame("Bank")
	f:SetScript("OnHide", StuffingBank_OnHide)
	self.bankFrame = f
end

function Stuffing:InitBags()
	if self.frame then return end

	self.buttons = {}
	self.bags = {}
	self.bagframe_buttons = {}

	local f = self:CreateBagFrame("Bags")
	f:SetScript("OnShow", Stuffing_OnShow)
	f:SetScript("OnHide", Stuffing_OnHide)

	-- search editbox(tekKonfigAboutPanel.lua)
	local editbox = CreateFrame("EditBox", nil, f)
	editbox:Hide()
	editbox:SetAutoFocus(true)
	editbox:SetHeight(32)

	local left = editbox:CreateTexture(nil, "BACKGROUND")
	left:SetSize(8, 20)
	left:SetPoint("LEFT", -5, 0)
	left:SetTexture("Interface\\Common\\Common-Input-Border")
	left:SetTexCoord(0, 0.0625, 0, 0.625)

	local right = editbox:CreateTexture(nil, "BACKGROUND")
	right:SetSize(8, 20)
	right:SetPoint("RIGHT", 0, 0)
	right:SetTexture("Interface\\Common\\Common-Input-Border")
	right:SetTexCoord(0.9375, 1, 0, 0.625)

	local center = editbox:CreateTexture(nil, "BACKGROUND")
	center:SetHeight(20)
	center:SetPoint("RIGHT", right, "LEFT", 0, 0)
	center:SetPoint("LEFT", left, "RIGHT", 0, 0)
	center:SetTexture("Interface\\Common\\Common-Input-Border")
	center:SetTexCoord(0.0625, 0.9375, 0, 0.625)

	local resetAndClear = function(self)
		self:GetParent().detail:Show()
		self:GetParent().gold:Show()
		self:ClearFocus()
		Stuffing:SearchReset()
	end

	local updateSearch = function(self, t)
		if t == true then
			Stuffing:SearchUpdate(self:GetText())
		end
	end

	editbox:SetScript("OnEscapePressed", resetAndClear)
	editbox:SetScript("OnEnterPressed", resetAndClear)
	editbox:SetScript("OnEditFocusLost", editbox.Hide)
	editbox:SetScript("OnEditFocusGained", editbox.HighlightText)
	editbox:SetScript("OnTextChanged", updateSearch)
	editbox:SetText(SEARCH)

	local detail = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	detail:SetPoint("TOPLEFT", f, 11, -10)
	detail:SetPoint("RIGHT", f, -140, -10)
	detail:SetHeight(13)
	detail:SetJustifyH("LEFT")
	detail:SetText("|cff2eb6ff"..SEARCH.."|r")
	editbox:SetAllPoints(detail)

	local gold = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	gold:SetJustifyH("RIGHT")
	gold:SetPoint("RIGHT", f.b_close, "LEFT", -10, 0)

	f:SetScript("OnEvent", function(self)
		self.gold:SetText(V.FormatMoney(GetMoney()))
	end)
	f:RegisterEvent("PLAYER_MONEY")
	f:RegisterEvent("PLAYER_LOGIN")
	f:RegisterEvent("PLAYER_TRADE_MONEY")
	f:RegisterEvent("TRADE_MONEY_CHANGED")

	local OpenEditbox = function(self)
		self:GetParent().detail:Hide()
		self:GetParent().gold:Hide()
		self:GetParent().editbox:Show()
		self:GetParent().editbox:HighlightText()
	end

	local button = CreateFrame("Button", nil, f)
	button:EnableMouse(1)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAllPoints(detail)
	button:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			OpenEditbox(self)
		else
			if self:GetParent().editbox:IsShown() then
				self:GetParent().editbox:Hide()
				self:GetParent().editbox:ClearFocus()
				self:GetParent().detail:Show()
				self:GetParent().gold:Show()
				Stuffing:SearchReset()
			end
		end
	end)

	local tooltip_hide = function()
		GameTooltip:Hide()
	end

	local tooltip_show = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -12, 11)
		GameTooltip:ClearLines()
		GameTooltip:SetText(L_BAG_RIGHT_CLICK_SEARCH)
	end

	button:SetScript("OnEnter", tooltip_show)
	button:SetScript("OnLeave", tooltip_hide)

	f.editbox = editbox
	f.detail = detail
	f.button = button
	f.gold = gold
	self.frame = f
-- Gold Hover
local goldHover = CreateFrame("Button", nil, f)

goldHover:SetPoint("TOPLEFT", gold, "TOPLEFT", -4, 4)
goldHover:SetPoint("BOTTOMRIGHT", gold, "BOTTOMRIGHT", 4, -4)

goldHover:SetFrameLevel(500)
goldHover:EnableMouse(true)

goldHover:RegisterForClicks(
	"LeftButtonUp",
	"RightButtonUp"
)

goldHover:SetScript("OnEnter", function(self)

	GameTooltip:SetOwner(
		self,
		"ANCHOR_TOPRIGHT"
	)

	GameTooltip:ClearLines()

	GameTooltip:AddLine("Character Gold")
	GameTooltip:AddLine(" ")

	local total = 0
	local realm = GetRealm()

	if VermilionDB
	and VermilionDB.BagSyncLite
	and VermilionDB.BagSyncLite[realm]
	then

		for charName, data in pairs(
			VermilionDB.BagSyncLite[realm]
		) do

			total = total + (data.gold or 0)

			local color =
				RAID_CLASS_COLORS[data.class]

			local hex = "|cffffffff"

			if color then
				hex = string.format(
					"|cff%02x%02x%02x",
					color.r * 255,
					color.g * 255,
					color.b * 255
				)
			end

			GameTooltip:AddDoubleLine(
				hex .. charName .. "|r",
				GetCoinTextureString(
					data.gold or 0
				),
				1,1,1,
				1,1,1
			)
		end
	end

	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine(
		"|cffFFD100Total|r",
		GetCoinTextureString(total),
		1,1,1,
		1,1,1
	)

	GameTooltip:Show()
end)

goldHover:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

goldHover:SetScript("OnClick", function(self, btn)

	if btn == "RightButton" then

		local player = UnitName("player")
		local realm = GetRealm()

		if VermilionDB
		and VermilionDB.BagSyncLite
		and VermilionDB.BagSyncLite[realm]
		and VermilionDB.BagSyncLite[realm][player]
		then

			VermilionDB.BagSyncLite[realm][player].gold = 0
		end
	end
end)

end
function Stuffing:Layout(lb)
	local slots = 0
	local rows = 0
	local off = 26
	local cols, f, bs

	if lb then
		bs = BAGS_BANK
		cols = C.Bag.BankColumns
		f = self.bankFrame
		f:SetAlpha(1)
	else
		bs = BAGS_BACKPACK
		cols = C.Bag.BagColumns
		f = self.frame

		f.gold:SetText(V.FormatMoney(GetMoney(), C.Media.Font_Size))
		f.editbox:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
		f.detail:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
		f.gold:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)

		f.detail:ClearAllPoints()
		f.detail:SetPoint("TOPLEFT", f, 12, -8)
		f.detail:SetPoint("RIGHT", f, -140, 0)
	end

	f:SetClampedToScreen(1)
	f:SetBackdrop(V.Backdrop)
	f:SetBackdropColor(unpack(C.Media.Backdrop_Color))
	f:SetBackdropBorderColor(unpack(C.Media.Border_Color))

	-- bag frame stuff
	local fb = f.bags_frame
	if bag_bars == 1 then
		fb:SetClampedToScreen(1)
		fb:SetBackdrop(V.Backdrop)
		fb:SetBackdropColor(unpack(C.Media.Backdrop_Color))
		fb:SetBackdropBorderColor(unpack(C.Media.Border_Color))

		fb:ClearAllPoints()
		fb:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, 0)

		local bsize = C.Bag.ButtonSize - 6 

		local w = 2 * 10
		w = w +((#bs - 1) * bsize)
		w = w +((#bs - 2) * 4)

		fb:SetHeight(2 * 10 + bsize)
		fb:SetWidth(w)
		fb:Show()
	else
		fb:Hide()
	end

	local idx = 0
	for _, v in ipairs(bs) do
		if(not lb and v <= 3 ) or(lb and v ~= -1) then
			local bsize = C.Bag.ButtonSize - 6
			local b = self:BagFrameSlotNew(v, fb)
			local xoff = 10

			xoff = xoff +(idx * bsize) -- 31)
			xoff = xoff +(idx * 4)

			b.frame:ClearAllPoints()
			b.frame:SetPoint("LEFT", fb, "LEFT", xoff, 0)
			b.frame:SetSize(bsize, bsize)

			-- Lets see what bag we are hovering over.
			local btns = self.buttons
			b.frame:HookScript("OnEnter", function(self)
				local bag
				if isBank then bag = v else bag = v + 1 end

				for ind, val in ipairs(btns) do
					if val.bag == bag then
						val.frame:SetAlpha(1)
					else
						val.frame:SetAlpha(0.2)
					end
				end
			end)

			b.frame:HookScript("OnLeave", function(self)
				for _, btn in ipairs(btns) do
					btn.frame:SetAlpha(1)
				end
			end)

			

			idx = idx + 1
		end
	end

	for _, i in ipairs(bs) do
		local x = GetContainerNumSlots(i)
		if x > 0 then
			if not self.bags[i] then
				self.bags[i] = self:BagNew(i, f)
			end

			if not (hide_soulbag == true and self.bags[i].bagType == ST_SOULBAG) then
				slots = slots + GetContainerNumSlots(i)
			end
		end
	end

	rows = floor(slots / cols)
	if(slots % cols) ~= 0 then
		rows = rows + 1
	end

	f:SetWidth(cols * C.Bag.ButtonSize +(cols - 1) * C.Bag.ButtonSpace + 10 * 2)
	f:SetHeight(rows * C.Bag.ButtonSize +(rows - 1) * C.Bag.ButtonSpace + off + 10 * 2)

	local idx = 0
	for _, i in ipairs(bs) do
		local bag_cnt = GetContainerNumSlots(i)
		local specialType = select(2, GetContainerNumFreeSlots(i))
		if bag_cnt > 0 then
			self.bags[i] = self:BagNew(i, f)
			local bagType = self.bags[i].bagType

			if not (hide_soulbag == true and bagType == ST_SOULBAG) then
				self.bags[i]:Show()
				for j = 1, bag_cnt do
					local b, isnew = self:SlotNew(i, j)
					local xoff
					local yoff
					local x =(idx % cols)
					local y = floor(idx / cols)

					if isnew then
						table.insert(self.buttons, idx + 1, b)
					end

					xoff = 10 +(x * C.Bag.ButtonSize) +(x * C.Bag.ButtonSpace)
					yoff = off + 10 +(y * C.Bag.ButtonSize) +((y - 1) * C.Bag.ButtonSpace)
					yoff = yoff * -1

					b.frame:ClearAllPoints()
					b.frame:SetPoint("TOPLEFT", f, "TOPLEFT", xoff, yoff)
					b.frame:SetSize(C.Bag.ButtonSize, C.Bag.ButtonSize)
					
					b.frame:StyleButton(true)
					b.frame.lock = false
					b.frame:SetAlpha(1)

					local normalTex = _G[b.frame:GetName() .. "NormalTexture"]
					normalTex:SetSize(C.Bag.ButtonSize / 37 * 64, C.Bag.ButtonSize / 37 * 64)
					b.normalTex = normalTex

					b.frame:SetBackdrop{bgFile = C.Media.Blank, insets = {left = 1, right = 1, top = 1, bottom = 1}}
					b.frame:SetBackdropColor(unpack(C.Media.Backdrop_Color))

					if bagType == ST_QUIVER then
						normalTex:SetVertexColor(0.8, 0.8, 0.2)
						b.frame.lock = true
					elseif bagType == ST_SOULBAG then
						normalTex:SetVertexColor(0.8, 0.2, 0.2)
						b.frame.lock = true
					elseif bagType == ST_NORMAL then
						normalTex:SetVertexColor(unpack(C.Media.Border_Color))
					elseif bagType == ST_SPECIAL then
						if specialType == 0x0008 then -- Leatherworking
							normalTex:SetVertexColor(0.8, 0.7, 0.3)
							b.frame.lock = true
						elseif specialType == 0x0010 then -- Inscription
							normalTex:SetVertexColor(0.3, 0.3, 0.8)
						elseif specialType == 0x0020 then -- Herbs
							normalTex:SetVertexColor(0.3, 0.7, 0.3)
						elseif specialType == 0x0040 then -- Enchanting
							normalTex:SetVertexColor(0.6, 0, 0.6)
						elseif specialType == 0x0080 then -- Engineering
							normalTex:SetVertexColor(0.9, 0.4, 0.1)
						elseif specialType == 0x0200 then -- Gems
							normalTex:SetVertexColor(0, 0.7, 0.8)
						elseif specialType == 0x0400 then -- Mining
							normalTex:SetVertexColor(0.4, 0.3, 0.1)
						end
						b.frame.lock = true
					end

					local iconTex = _G[b.frame:GetName() .. "IconTexture"]

					iconTex:Show()
					b.iconTex = iconTex

					if b.Glow then
						b.Glow:SetSize(C.Bag.ButtonSize / 37 * 64, C.Bag.ButtonSize / 37 * 64)
					end

					idx = idx + 1
				end
			end
		end
	end
end

local function Stuffing_Sort(args)
	if not args then
		args = ""
	end

	Stuffing.itmax = 0
	Stuffing:SetBagsForSorting(args)
	Stuffing:SortBags()
end

function Stuffing:SetBagsForSorting(c)
	Stuffing_Open()

	self.sortBags = {}

	local cmd = ((c == nil or c == "") and {"d"} or {strsplit("/", c)})

	for _, s in ipairs(cmd) do
		if s == "c" then
			self.sortBags = {}
		elseif s == "d" then
			if not self.bankFrame or not self.bankFrame:IsShown() then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		elseif s == "p" then
			if not self.bankFrame or not self.bankFrame:IsShown() then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		else
			if tonumber(s) == nil then
				V.Print(string.format(L["Error: don't know what \"%s\" means."], s))
			end

			table.insert(self.sortBags, tonumber(s))
		end
	end
end

function Stuffing:ADDON_LOADED(addon)
	if addon ~= "Vermilion" then return nil end

	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("GUILDBANKFRAME_OPENED")
	self:RegisterEvent("GUILDBANKFRAME_CLOSED")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	self:RegisterEvent("BAG_CLOSED")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")

	self:InitBags()

	tinsert(UISpecialFrames, "StuffingFrameBags")

	-- hook functions
	ToggleBackpack = Stuffing_Toggle
	ToggleBag = Stuffing_Toggle
	ToggleAllBags = Stuffing_Toggle
	OpenAllBags = Stuffing_Open
	OpenBackpack = Stuffing_Open
	CloseAllBags = Stuffing_Close
	CloseBackpack = Stuffing_Close

	--BankFrame:SetScale(0.00001)
	--BankFrame:SetAlpha(0)
	--BankFrame:SetPoint("TOPLEFT")
	--BankFrame:SetScale(0.00001)
	--BankFrame:SetAlpha(0)
	--BankFrame:SetPoint("TOPLEFT")
	if BankFrame then
	BankFrame:UnregisterAllEvents()
	BankFrame:Hide()

	BankFrame:SetScript("OnShow", function(self)
		self:Hide()
	end)
end

	for i = 1, NUM_CONTAINER_FRAMES do
		_G['ContainerFrame'..i]:Kill()
	end
end

function Stuffing:PLAYER_ENTERING_WORLD()
	Stuffing:UnregisterEvent("PLAYER_ENTERING_WORLD")
	ToggleBackpack()
	ToggleBackpack()
end

function Stuffing:PLAYERBANKSLOTS_CHANGED(id)
	if id > 28 then
		for _, v in ipairs(self.bagframe_buttons) do
			if v.frame and v.frame.GetInventorySlot then

				BankFrameItemButton_Update(v.frame)
				BankFrameItemButton_UpdateLocked(v.frame)

				if not v.frame.tooltipText then
					v.frame.tooltipText = ""
				end
			end
		end
	end

	if self.bankFrame and self.bankFrame:IsShown() then
		self:BagSlotUpdate(-1)
	end
end

function Stuffing:BAG_UPDATE(id)
	self:BagSlotUpdate(id)
end

function Stuffing:ITEM_LOCK_CHANGED(bag, slot)
	if slot == nil then return end
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			self:SlotUpdate(v)
			break
		end
	end
end

function Stuffing:BANKFRAME_OPENED()

	if not self.bankFrame then
		self:InitBank()
	end

	self:Layout(true)

	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end

	for _, v in ipairs(self.buttons) do
		self:SlotUpdate(v)
	end

local updater = CreateFrame("Frame")

local elapsed = 0

updater:SetScript("OnUpdate", function(self, e)

	elapsed = elapsed + e

	if elapsed > 0.2 then

		for _, v in ipairs(Stuffing.buttons) do
			Stuffing:SlotUpdate(v)
		end

		self:SetScript("OnUpdate", nil)
	end
end)

	self.bankFrame:Show()

	Stuffing_Open()
end

function Stuffing:BANKFRAME_CLOSED()
	if not self.bankFrame then
		return
	end

	self.bankFrame:Hide()
end

function Stuffing:GUILDBANKFRAME_OPENED()
	Stuffing_Open()
end

function Stuffing:GUILDBANKFRAME_CLOSED()
	Stuffing_Close()
end

function Stuffing:BAG_CLOSED(id)
	local b = self.bags[id]
	if b then
		table.remove(self.bags, id)
		b:Hide()
		table.insert(trashBag, #trashBag + 1, b)
	end

	while true do
		local changed = false

		for i, v in ipairs(self.buttons) do
			if v.bag == id then
				v.frame:Hide()
				v.frame.lock = false

				table.insert(trashButton, #trashButton + 1, v.frame)
				table.remove(self.buttons, i)

				v = nil
				changed = true
			end
		end

		if not changed then
			break
		end
	end
end

function Stuffing:BAG_UPDATE_COOLDOWN()
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end
end

function Stuffing:SortOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	if not self.itmax then
		self.itmax = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0
	self.itmax = self.itmax + 1

	local changed, blocked = false, false

	if self.sortList == nil or next(self.sortList, nil) == nil then
		-- Wait for all item locks to be released
		local locks = false

		for i, v in pairs(self.buttons) do
			local _, _, l = GetContainerItemInfo(v.bag, v.slot)
			if l then
				locks = true
			else
				v.block = false
			end
		end

		if locks then
			-- Something still locked
			return
		else
			-- All unlocked. get a new table
			self:SetScript("OnUpdate", nil)
			self:SortBags()

			if self.sortList == nil then
				return
			end
		end
	end

	-- Go through the list and move stuff if we can
	for i, v in ipairs(self.sortList) do
		repeat
			if v.ignore then
				blocked = true
				break
			end

			if v.srcSlot.block then
				changed = true
				break
			end

			if v.dstSlot.block then
				changed = true
				break
			end

			local _, _, l1 = GetContainerItemInfo(v.dstSlot.bag, v.dstSlot.slot)
			local _, _, l2 = GetContainerItemInfo(v.srcSlot.bag, v.srcSlot.slot)

			if l1 then
				v.dstSlot.block = true
			end

			if l2 then
				v.srcSlot.block = true
			end

			if l1 or l2 then
				break
			end

			if v.sbag ~= v.dbag or v.sslot ~= v.dslot then
				if v.srcSlot.name ~= v.dstSlot.name then
					v.srcSlot.block = true
					v.dstSlot.block = true
					PickupContainerItem(v.sbag, v.sslot)
					PickupContainerItem(v.dbag, v.dslot)
					changed = true
					break
				end
			end
		until true
	end

	self.sortList = nil

	if (not changed and not blocked) or self.itmax > 250 then
		self:SetScript("OnUpdate", nil)
		self.sortList = nil
	end
end

local function InBags(x)
	if not Stuffing.bags[x] then
		return false
	end

	for _, v in ipairs(Stuffing.sortBags) do
		if x == v then
			return true
		end
	end
	return false
end

function Stuffing:SortBags()
	local free
	local total = 0
	local bagtypeforfree

	if StuffingFrameBank and StuffingFrameBank:IsShown() then
		for i = 5, 11 do
			free, bagtypeforfree = GetContainerNumFreeSlots(i)
			if bagtypeforfree == 0 then
				total = free + total
			end
		end
		total = GetContainerNumFreeSlots(-1) + total
	else
		for i = 0, 4 do
			free, bagtypeforfree = GetContainerNumFreeSlots(i)
			if bagtypeforfree == 0 then
				total = free + total
			end
		end
	end

	if total == 0 then
		--print("|cffff0000"..ERROR_CAPS.." - "..ERR_INV_FULL.."|r")
		return
	end

	local bs = self.sortBags
	if #bs < 1 then
		return
	end

	local st = {}
	local bank = false

	Stuffing_Open()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			self:SlotUpdate(v)

			if v.name then
				local _, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
				local n, _, q, iL, rL, c1, c2, _, Sl = GetItemInfo(clink)
				if n == GetItemInfo(6948) then c1 = "1" end	-- Hearthstone
				table.insert(st, {srcSlot = v, sslot = v.slot, sbag = v.bag, sort = q..c1..c2..rL..n..iL..Sl..(#self.buttons - i)})
			end
		end
	end
	-- Sort them
	table.sort(st, function(a, b)
		return a.sort > b.sort
	end)

	-- For each button we want to sort, get a destination button
	local st_idx = #bs
	local dbag = bs[st_idx]
	local dslot = GetContainerNumSlots(dbag)

	for i, v in ipairs(st) do
		v.dbag = dbag
		v.dslot = dslot
		v.dstSlot = self:SlotNew(dbag, dslot)

		dslot = dslot - 1

		if dslot == 0 then
			while true do
				st_idx = st_idx - 1

				if st_idx < 0 then
					break
				end

				dbag = bs[st_idx]

				if Stuffing:BagType(dbag) == ST_NORMAL or Stuffing:BagType(dbag) == ST_SPECIAL or dbag < 1 then
					break
				end
			end

			dslot = GetContainerNumSlots(dbag)
		end
	end

	-- Throw various stuff out of the search list
	local changed = true
	while changed do
		changed = false
		-- XXX why doesn't this remove all x->x moves in one pass?

		for i, v in ipairs(st) do
			-- Source is same as destination
			if (v.sslot == v.dslot) and (v.sbag == v.dbag) then
				table.remove(st, i)
				changed = true
			end
		end
	end

	-- Kick off moving of stuff, if needed
	if st == nil or next(st, nil) == nil then
		self:SetScript("OnUpdate", nil)
	else
		self.sortList = st
		self:SetScript("OnUpdate", Stuffing.SortOnUpdate)
	end
end

function Stuffing:RestackOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then return end

	self.elapsed = 0
	self:Restack()
end

function Stuffing:Restack()
	local st = {}

	Stuffing_Open()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			local _, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
			if clink then
				local n, _, _, _, _, _, _, s = GetItemInfo(clink)

				if n and cnt ~= s then
					if not st[n] then
						st[n] = {{item = v, size = cnt, max = s}}
					else
						table.insert(st[n], {item = v, size = cnt, max = s})
					end
				end
			end
		end
	end

	local did_restack = false

	for i, v in pairs(st) do
		if #v > 1 then
			for j = 2, #v, 2 do
				local a, b = v[j - 1], v[j]
				local _, _, l1 = GetContainerItemInfo(a.item.bag, a.item.slot)
				local _, _, l2 = GetContainerItemInfo(b.item.bag, b.item.slot)

				if l1 or l2 then
					did_restack = true
				else
					PickupContainerItem(a.item.bag, a.item.slot)
					PickupContainerItem(b.item.bag, b.item.slot)
					did_restack = true
				end
			end
		end
	end

	if did_restack then
		self:SetScript("OnUpdate", Stuffing.RestackOnUpdate)
	else
		self:SetScript("OnUpdate", nil)
	end
end

function Stuffing:PLAYERBANKBAGSLOTS_CHANGED()
for i = 1, NUM_BANKBAGSLOTS do

	local button = self.bankframe_buttons[i]

	if button then

		local icon = _G[button:GetName() .. "IconTexture"]

		local texture = GetInventoryItemTexture(
			"player",
			ContainerIDToInventoryID(i + NUM_BAG_SLOTS)
		)

		if icon then

			icon:SetTexture(
				texture or "Interface\\Icons\\INV_Misc_QuestionMark"
			)

			icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			icon:SetDrawLayer("ARTWORK")
			icon:SetAlpha(1)

			icon:Show()
		end

		button:SetAlpha(1)
		button:Show()
	end
end
	if not StuffingPurchaseButtonBank then return end
	local _, full = GetNumBankSlots()
	if full then
		StuffingPurchaseButtonBank:Hide()
	else
		StuffingPurchaseButtonBank:Show()
	end
end

function Stuffing.Menu(self, level)
	if not level then
		return
	end

	local info = self.info

	wipe(info)

	if level ~= 1 then
		return
	end

	wipe(info)
	info.text = L_BAG_SORT_MENU
	info.notCheckable = 1
	info.func = function()
		if InCombatLockdown() or UnitIsDeadOrGhost("player") then
			V.Print("|cffffe02e"..L_ERR_NOT_IN_COMBAT.."|r") return
		end
		Stuffing_Sort("d")
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = L_BAG_STACK_MENU
	info.notCheckable = 1
	info.func = function()
		if InCombatLockdown() or UnitIsDeadOrGhost("player") then
			V.Print("|cffffe02e"..L_ERR_NOT_IN_COMBAT.."|r") return
		end
		Stuffing:SetBagsForSorting("d")
		Stuffing:Restack()
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = L_BAG_SHOW_BAGS
	info.checked = function()
		return bag_bars == 1
	end

	info.func = function()
		if bag_bars == 1 then
			bag_bars = 0
		else
			bag_bars = 1
		end
		Stuffing:Layout()
		if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
			Stuffing:Layout(true)
		end

	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = KEYRING
	info.notCheckable = 1
	info.func = function()
		if InCombatLockdown() or UnitIsDeadOrGhost("player") then
			V.Print("|cffffe02e"..L_ERR_NOT_IN_COMBAT.."|r") return
		end
		ToggleKeyRing()
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.disabled = nil
	info.notCheckable = 1
	info.text = CLOSE
	info.func = self.HideMenu
	info.tooltipTitle = CLOSE
	UIDropDownMenu_AddButton(info, level)
end



-- =========================================================
-- Bank Snapshot Backport for Stuffing Bags (WoTLK 3.3.5)
-- =========================================================

local SnapshotFrame

-- =========================================================
-- Capture Bank Items
-- =========================================================

local function Stuffing_CaptureBankSnapshot()

	if not StuffingBankSnapshotDB then
		StuffingBankSnapshotDB = {}
	end

	wipe(StuffingBankSnapshotDB)

	local index = 1
	StuffingBankSnapshotDB.totalSlots = 0

for _, bag in ipairs(BAGS_BANK) do

	local numSlots = GetContainerNumSlots(bag)

	if numSlots and numSlots > 0 then
		StuffingBankSnapshotDB.totalSlots =
		StuffingBankSnapshotDB.totalSlots + numSlots
		for slot = 1, numSlots do

			local texture, count, locked = GetContainerItemInfo(bag, slot)
			local link = GetContainerItemLink(bag, slot)

			StuffingBankSnapshotDB[index] = {
				texture = texture,
				count = count or 0,
				link = link,
				empty = (not texture),
			}

			index = index + 1
		end
	end
end

--print("Saved snapshot:", index - 1)
end

-- =========================================================
-- Snapshot Frame
-- =========================================================

local function Stuffing_CreateSnapshotFrame()

	SnapshotFrame = CreateFrame(
		"Frame",
		"StuffingSnapshotFrame",
		UIParent
	)

	SnapshotFrame:SetScript("OnHide", function()

	if Stuffing and Stuffing.frame then
		Stuffing.frame:Show()
	end

	if Stuffing and Stuffing.buttons then
		for _, b in pairs(Stuffing.buttons) do
			if b and b.frame then
				b.frame:Show()
			end
		end
	end

end)
	SnapshotFrame:SetFrameStrata("HIGH")
	SnapshotFrame:SetFrameLevel(50)

	SnapshotFrame:SetClampedToScreen(true)

	SnapshotFrame:SetPoint(
		"CENTER",
		UIParent,
		"CENTER",
		0,
		0
	)

	SnapshotFrame.buttons = {}

	-- Background
	SnapshotFrame.bg = CreateFrame(
		"Frame",
		nil,
		SnapshotFrame
	)

	SnapshotFrame.bg:SetPoint("TOPLEFT", -6, 6)
	SnapshotFrame.bg:SetPoint("BOTTOMRIGHT", 6, -6)

	SnapshotFrame.bg:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false,
		tileSize = 0,
		edgeSize = 12,
		insets = {
			left = 3,
			right = 3,
			top = 3,
			bottom = 3
		}
	})

	SnapshotFrame.bg:SetBackdropColor(unpack(C.Media.Backdrop_Color))

	SnapshotFrame.bg:SetBackdropBorderColor(unpack(C.Media.Border_Color))

	-- Title
	SnapshotFrame.title = SnapshotFrame:CreateFontString(
		nil,
		"OVERLAY",
		"GameFontNormal"
	)

	SnapshotFrame.title:SetPoint(
		"TOP",
		0,
		-10
	)

	SnapshotFrame.title:SetText(
		"Bank Snapshot"
	)

	-- Close button
	SnapshotFrame.close = CreateFrame(
		"Button",
		nil,
		SnapshotFrame,
		"UIPanelCloseButton"
	)

	SnapshotFrame.close:SetPoint(
		"TOPRIGHT",
		2,
		2
	)

	SnapshotFrame:Hide()
end

-- =========================================================
-- Show Snapshot
-- =========================================================

local function Stuffing_ShowSnapshot()
	
	if not SnapshotFrame then
		Stuffing_CreateSnapshotFrame()
	end

	if not StuffingBankSnapshotDB then
		StuffingBankSnapshotDB = {}
	end

	local db = StuffingBankSnapshotDB

	local hasData = false

	for _, v in pairs(db) do
		if v then
			hasData = true
			break
		end
	end

	if not hasData then
		--print("No snapshot data")
		return
	end

	-- ESC close
	tinsert(UISpecialFrames, "StuffingSnapshotFrame")

	-- Frame settings
	SnapshotFrame:SetToplevel(true)
	SnapshotFrame:EnableMouse(true)
	SnapshotFrame:SetMovable(true)
	SnapshotFrame:RegisterForDrag("LeftButton")

	SnapshotFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	SnapshotFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	-- Hide old buttons
	for _, b in pairs(SnapshotFrame.buttons) do
		if b.icon then
			b.icon:SetTexture(nil)
			b.icon:Hide()
		end

		if b.count then
			b.count:SetText("")
		end
		
		b.link = nil
		b:Hide()
	end

	local size = 34
	local spacing = 4
	local cols = 17

local totalSlots =
	StuffingBankSnapshotDB.totalSlots or 168

local rows = math.ceil(totalSlots / cols)

if rows < 1 then
	rows = 1
end
	local width = (cols * (size + spacing)) + 30
	local height = (rows * (size + spacing)) + 30

	SnapshotFrame:SetSize(width, height)

local i = 1

local totalSlots =
	StuffingBankSnapshotDB.totalSlots or 168

for i = 1, totalSlots do

	local item = db[i]

	local b = SnapshotFrame.buttons[i]

	if not b then

		b = CreateFrame(
			"CheckButton",
			"StuffingSnapshotItem"..i,
			SnapshotFrame,
			"ItemButtonTemplate"
		)
		
			b:EnableMouse(true)

			b:SetScript("OnEnter", function(self)

			if self.link then

				GameTooltip:SetOwner(
					self,
					"ANCHOR_RIGHT"
				)

				GameTooltip:SetHyperlink(
					self.link
				)

				GameTooltip:Show()
			end
		end)

		b:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		b:SetSize(size, size)

		b.count = b:CreateFontString(nil, "OVERLAY")
		b.count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
		b.count:SetPoint("BOTTOMRIGHT", 1, 0)

		b.iLevel = b:CreateFontString(nil, "OVERLAY")
		b.iLevel:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
		b.iLevel:SetPoint("BOTTOMRIGHT", 0, 2)
		b.iLevel:SetJustifyH("LEFT")
		b.iLevel:SetDrawLayer("OVERLAY", 7)

		SnapshotFrame.buttons[i] = b
		end

	local row = floor((i - 1) / cols)
	local col = (i - 1) % cols

	b:ClearAllPoints()
	b:SetPoint("TOPLEFT", SnapshotFrame, "TOPLEFT", 10 + (col * (size + spacing)), -26 - (row * (size + spacing)))
	local icon = _G[b:GetName() .. "IconTexture"]

	local normalTexture = b:GetNormalTexture()

if normalTexture then
	normalTexture:SetTexture("Interface\\Buttons\\UI-Quickslot2")
	normalTexture:ClearAllPoints()
	normalTexture:SetPoint("TOPLEFT", b, "TOPLEFT", -12, 12)
	normalTexture:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 12, -12)
	normalTexture:SetTexCoord(0, 1, 0, 1)
	normalTexture:SetVertexColor(unpack(C.Media.Border_Color))
	normalTexture:SetDrawLayer("BACKGROUND")
	normalTexture:SetAlpha(1)
	normalTexture:SetDrawLayer("ARTWORK")
	normalTexture:Show()
end

if item and item.texture then

	local itemName, _, quality, itemLevel,
	_, _, _, equipSlot =
	GetItemInfo(item.link)

	if not itemLevel then

		local itemID =
			string.match(item.link or "", "item:(%d+)")

		if itemID then

			GameTooltip:SetHyperlink(
				"item:" .. itemID
			)

			_, _, quality, itemLevel =
				GetItemInfo(item.link)
		end
	end

	icon:SetTexture(item.texture)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:ClearAllPoints()
	icon:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2)
	icon:Show()

	b.count:SetText(
		item.count and item.count > 1
		and item.count
		or ""
	)

	b.link = item.link

	local _, _, _, _, _, itemType, itemSubType =
	GetItemInfo(item.link)

	local isEquip =
	itemType == "Armor"
	or itemType == "Weapon"

	if isEquip
	and itemLevel
	and itemLevel > 0 then

		local r, g, bq =
			GetItemQualityColor(quality or 1)

		b.iLevel:SetText(itemLevel)
		b.iLevel:SetTextColor(r, g, bq)
		b.iLevel:SetDrawLayer("OVERLAY", 7)
		b.iLevel:Show()

	else

		b.iLevel:SetText("")
	end

else

	icon:SetTexture(nil)
	icon:Hide()

	b.count:SetText("")
	b.link = nil

	if b.iLevel then
		b.iLevel:SetText("")
	end
end

b:Show()
end
	--print("Snapshot shown:", total)

	SnapshotFrame:Show()
end

-- =========================================================
-- Snapshot Listener
-- =========================================================

local SnapshotListener = CreateFrame("Frame")

SnapshotListener:RegisterEvent("BANKFRAME_OPENED")
SnapshotListener:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
SnapshotListener:RegisterEvent("BANKFRAME_CLOSED")

local bankReady = false
local captureQueued = false

local function After(delay, func)

	local frame = CreateFrame("Frame")

	local elapsed = 0

	frame:SetScript("OnUpdate", function(self, e)

		elapsed = elapsed + e

		if elapsed >= delay then

			func()

			self:SetScript("OnUpdate", nil)
		end
	end)
end

SnapshotListener:SetScript("OnEvent", function(self, event)

	if event == "BANKFRAME_OPENED" then

		--print("BANK OPENED")

		bankReady = true

		if not captureQueued then

			captureQueued = true

			After(0.1, function()

				if bankReady then
					Stuffing_CaptureBankSnapshot()
				end

				captureQueued = false

			end)
		end

	elseif event == "PLAYERBANKSLOTS_CHANGED" then

		if bankReady and not captureQueued then

			captureQueued = true

			After(0.1, function()

				if bankReady then
					Stuffing_CaptureBankSnapshot()
				end

				captureQueued = false

			end)
		end

	elseif event == "BANKFRAME_CLOSED" then

		bankReady = false

	end
end)

-- =========================================================
-- Snapshot Button
-- =========================================================

local SnapshotButton = CreateFrame(
	"Button",
	"StuffingSnapshotButton",
	UIParent
)
SnapshotButton:SetSize(C.Bag.ButtonSize, C.Bag.ButtonSize)
SnapshotButton:SetFrameStrata("HIGH")
SnapshotButton:SetFrameLevel(20)
SnapshotButton:EnableMouse(true)
SnapshotButton:RegisterForClicks("AnyUp")
SnapshotButton.tex = SnapshotButton:CreateTexture(nil, "ARTWORK")
SnapshotButton.tex:SetAllPoints()
SnapshotButton.tex:SetTexture("Interface\\ICONS\\INV_Misc_Bag_10")
SnapshotButton:SetBackdrop(V.Backdrop)
SnapshotButton:SetBackdropColor(unpack(C.Media.Backdrop_Color))
SnapshotButton:SetBackdropBorderColor(unpack(C.Media.Border_Color))

SnapshotButton:SetNormalTexture("")
SnapshotButton:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
SnapshotButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
SnapshotButton:GetHighlightTexture():SetBlendMode("ADD")
SnapshotButton:SetAlpha(1)

SnapshotButton.tex:ClearAllPoints()
SnapshotButton.tex:SetPoint("TOPLEFT", 2, -2)
SnapshotButton.tex:SetPoint("BOTTOMRIGHT", -2, 2)
SnapshotButton.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
SnapshotButton.tex:SetDrawLayer("OVERLAY")

SnapshotButton:SetScript("OnClick", function()
	Stuffing_ShowSnapshot()
end)

SnapshotButton:SetScript("OnEnter", function(self)

	GameTooltip:SetOwner(
		self,
		"ANCHOR_RIGHT"
	)

	GameTooltip:AddLine(
		"Bank Snapshot",
		1,
		0.82,
		0
	)

	GameTooltip:AddLine(
		"Left Click: Show Snapshot",
		1,
		1,
		1
	)

	GameTooltip:AddLine(" ")

	GameTooltip:AddLine(
		"Saved Slots: "
		.. (StuffingBankSnapshotDB.totalSlots or 0),
		0,
		1,
		0
	)

	GameTooltip:Show()
end)

SnapshotButton:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)



-- =========================================================
-- Position Button
-- =========================================================

local PositionFrame = CreateFrame("Frame")

PositionFrame:RegisterEvent(
	"PLAYER_ENTERING_WORLD"
)
PositionFrame:SetScript("OnEvent", function()

	After(0.1, function()

		if
			Stuffing
			and Stuffing.frame
			and Stuffing.frame.bags_frame
		then

			SnapshotButton:SetParent(
				Stuffing.frame.bags_frame
			)

			SnapshotButton:ClearAllPoints()

			SnapshotButton:SetPoint("TOP", StuffingFrameBags, "BOTTOMLEFT",	17, 0)

			SnapshotButton:Show()

		end

	end)

end)


