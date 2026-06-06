local V, C, L, _ = select(2, ...):unpack()
if C.Unitframe.EnhancedFrames ~= true then return end

local _G = _G
-- MAIN FRAMES
local HEALTH_WIDTH  = C.Unitframe.HealthWidth or 122
local HEALTH_HEIGHT = C.Unitframe.HealthHeight or 32

local POWER_WIDTH   = C.Unitframe.PowerWidth or 122
local POWER_HEIGHT  = C.Unitframe.PowerHeight or 13

local PORTRAIT_SIZE = C.Unitframe.PortraitSize or 50

-- TARGETTOT
local TOT_WIDTH        = C.Unitframe.ToTWidth or 100
local TOT_HEIGHT       = C.Unitframe.ToTHeight or 24
local TOT_POWER_HEIGHT = C.Unitframe.ToTPowerHeight or 12

-- FOCUSTOT
local FOCUSTOT_WIDTH        = C.Unitframe.FocusToTWidth or 100
local FOCUSTOT_HEIGHT       = C.Unitframe.FocusToTHeight or 24
local FOCUSTOT_POWER_HEIGHT = C.Unitframe.FocusToTPowerHeight or 12

-- PET
local PET_WIDTH        = C.Unitframe.PetWidth or 100
local PET_HEIGHT       = C.Unitframe.PetHeight or 24
local PET_POWER_HEIGHT = C.Unitframe.PetPowerHeight or 12

-- BOSS
local BOSS_WIDTH        = C.Unitframe.BossWidth or 122
local BOSS_HEIGHT       = C.Unitframe.BossHeight or 32
local BOSS_POWER_HEIGHT = C.Unitframe.BossPowerHeight or 13

local BOSS_X            = C.Unitframe.BossX or 200
local BOSS_Y            = C.Unitframe.BossY or 200

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local GetCVar = GetCVar
local EnhancedFrames = CreateFrame("Frame")
local eventHandler = CreateFrame("Frame")
local _, class = UnitClass("player")
local lc, lcl = IsAddOnLoaded("LoseControl"), IsAddOnLoaded("LoseControlLite")
local function CreatePowerStyle(frame)
	if not frame or frame.PowerHolder then return end
	-- BACKDROP
	local holder = CreateFrame("Frame", nil, frame:GetParent())
	holder:SetFrameStrata(frame:GetFrameStrata())
	holder:SetFrameLevel(1)
	holder:SetPoint("TOPLEFT", frame)
	holder:SetPoint("BOTTOMRIGHT", frame)
	local bg = holder:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture("Interface\\Buttons\\WHITE8X8")
	bg:SetVertexColor(0, 0, 0, 0.6)
	holder.BG = bg
	-- BORDER
	if not frame.Border then
		frame:CreateBorder()
	end
	if frame.Border then
		frame.Border:SetFrameStrata("HIGH")
		frame.Border:SetFrameLevel(frame:GetFrameLevel() + 20)
	end
	frame.PowerHolder = holder
	return holder
end
local function CreateNoPowerBorder(bar)
	if not bar or bar.NoPowerBorder then return	end
	local border = CreateFrame("Frame", nil, bar:GetParent())
	border:SetPoint("TOPLEFT", bar)
	border:SetPoint("BOTTOMRIGHT", bar)
	border:CreateBorder()
	local bg = border:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture("Interface\\Buttons\\WHITE8X8")
	bg:SetVertexColor(0, 0, 0, 0)
	border:Hide()
	bar.NoPowerBorder = border
	return border
end
local function UpdateNoPowerBorder(bar)
	if not bar or not bar.NoPowerBorder then
		return
	end
	local minValue, maxValue = bar:GetMinMaxValues()
	if not bar:IsShown() or maxValue == 0 then
		bar.NoPowerBorder:Show()
	else
		bar.NoPowerBorder:Hide()
	end
end
local function CreatePortraitStyle(portrait)
	if not portrait or portrait.Styled then return end
	-- Backdrop
	local bg = portrait:GetParent():CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", portrait)
	bg:SetPoint("BOTTOMRIGHT", portrait)
	bg:SetTexture("Interface\\Buttons\\WHITE8X8")
	bg:SetVertexColor(0, 0, 0, 0.8)
	-- Border
	local border = CreateFrame("Frame", nil, portrait:GetParent())
	border:SetPoint("TOPLEFT", portrait)
	border:SetPoint("BOTTOMRIGHT", portrait)
	border:CreateBorder()
	border:SetFrameStrata("Medium")
	portrait.Backdrop = bg
	portrait.BorderHolder = border
	portrait.Styled = true
end
local function StylePortrait(portrait, healthbar, manabar, side)
	if not portrait then return end
	portrait:ClearAllPoints()
	if C.Unitframe.DetachedPortrait then
		portrait:SetSize(PORTRAIT_SIZE, PORTRAIT_SIZE)
		if side == "LEFT" then
			portrait:SetPoint("RIGHT", healthbar, "LEFT", -8, 0)
		else
			portrait:SetPoint("LEFT", healthbar, "RIGHT", 8, 0)
		end
	else
		if side == "LEFT" then
			portrait:SetPoint("TOPRIGHT", healthbar, "TOPLEFT", -6, 0)
			portrait:SetPoint("BOTTOMRIGHT", manabar, "BOTTOMLEFT", -6, 0)
			portrait:SetWidth(50)
		else
			portrait:SetPoint("TOPLEFT", healthbar, "TOPRIGHT", 6, 0)
			portrait:SetPoint("BOTTOMLEFT", manabar, "BOTTOMRIGHT", 6, 0)
			portrait:SetWidth(50)
		end
	end
	portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
end
local function StylePowerBar(bar, anchorFrame)
	if not bar then return end
	bar:ClearAllPoints()
	if C.Unitframe.DetachedPower then
		bar:SetSize(HEALTH_WIDTH, POWER_HEIGHT)
		bar:SetPoint("TOP", anchorFrame, "BOTTOM", 0, -6)
	else
		bar:SetSize(POWER_WIDTH, POWER_HEIGHT)
		bar:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -6)
	end
	if bar.PowerHolder then
		bar.PowerHolder:ClearAllPoints()
		bar.PowerHolder:SetPoint("TOPLEFT", bar, "TOPLEFT")
		bar.PowerHolder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
	end
end
local function ResizePortrait(portrait, healthbar, manabar)

	if not portrait or not healthbar or not manabar then
		return
	end
	local height = healthbar:GetHeight() + manabar:GetHeight() + 6
	portrait:SetSize(height, height)
end
function EnhancedFrames_PositionBossFrames()
	for i = 1, 4 do
		local boss = _G["Boss"..i.."TargetFrame"]
		if boss then
			boss:ClearAllPoints()
			if i == 1 then
				boss:SetPoint("TOP", BossFrameAnchor, "TOP", 0, 0)
			else
				boss:SetPoint("TOP", _G["Boss"..(i-1).."TargetFrame"], "BOTTOM", 0, -25)
			end
		end
	end
end
-- EVENT LISTENER TO MAKE SURE WE ENABLE THE ADDON AT THE RIGHT TIME
function EnhancedFrames:PLAYER_ENTERING_WORLD()
	EnableEnhancedFrames()
	--EnableEnhancedPartyFrames()
end
function EnableEnhancedFrames()
-- GENERIC STATUS TEXT
hooksecurefunc("TextStatusBar_UpdateTextString", EnhancedFrames_UpdateTextStringWithValues)
-- PLAYER
hooksecurefunc("PlayerFrame_ToPlayerArt", EnhancedFrames_PlayerFrame_ToPlayerArt)
hooksecurefunc("PlayerFrame_ToVehicleArt", EnhancedFrames_PlayerFrame_ToVehicleArt)
-- TARGET
hooksecurefunc("TargetFrame_CheckDead", EnhancedFrames_TargetFrame_Update)
hooksecurefunc("TargetFrame_Update", EnhancedFrames_TargetFrame_Update)
hooksecurefunc("TargetFrame_CheckFaction", EnhancedFrames_TargetFrame_CheckFaction)
hooksecurefunc("TargetFrame_CheckClassification", EnhancedFrames_Target_Classification)
hooksecurefunc("TargetofTarget_Update", EnhancedFrames_TargetFrame_Update)
-- BOSS
hooksecurefunc("BossTargetFrame_OnLoad", EnhancedFrames_BossTargetFrame_Style)
-- STYLE FRAMES
EnhancedFrames_Style_PlayerFrame()
EnhancedFrames_Style_PetFrame()
EnhancedFrames_Style_TargetFrame(TargetFrame)
EnhancedFrames_Style_TargetToTFrame()
EnhancedFrames_Style_FocusFrame(FocusFrame)
EnhancedFrames_Style_FocusToTFrame()


for i = 1, 4 do
	local boss = _G["Boss"..i.."TargetFrame"]
	if boss then
		EnhancedFrames_BossTargetFrame_Style(boss)
	end
end

EnhancedFrames_PositionBossFrames()
-- UPDATE TEXT
TextStatusBar_UpdateTextString(PlayerFrame.healthbar)
TextStatusBar_UpdateTextString(PlayerFrame.manabar)
		-- HEALTH BORDERS
	local HealthBars = {
		PlayerFrameHealthBar,
		TargetFrameHealthBar,
		FocusFrameHealthBar,
		TargetFrameToTHealthBar,
		FocusFrameToTHealthBar,
		PetFrameHealthBar,
	}
	for _, bar in pairs(HealthBars) do
	if bar and not bar.Border then
		bar:CreateBorder()
		end
	end
		-- POWER STYLE
	local PowerBars = {
		PlayerFrameManaBar,
		TargetFrameManaBar,
		FocusFrameManaBar,
		TargetFrameToTManaBar,
		FocusFrameToTManaBar,
		PetFrameManaBar,
	}
	for _, bar in pairs(PowerBars) do
	if bar then
		CreatePowerStyle(bar)
		end
	end
	-- NO POWER BORDERS
	for _, bar in pairs(PowerBars) do
	if bar then
		CreateNoPowerBorder(bar)
		end
	end
		-- PORTRAIT STYLE
	local Portraits = {
		PlayerPortrait,
		TargetFramePortrait,
		FocusFramePortrait,
		PetPortrait,
		TargetFrameToTPortrait,
		FocusFrameToTPortrait,
		Boss1TargetFramePortrait,
		Boss2TargetFramePortrait,
		Boss3TargetFramePortrait,
		Boss4TargetFramePortrait,
	}
	for _, portrait in pairs(Portraits) do
	if portrait then
		CreatePortraitStyle(portrait)
		end
	end
		-- PARTY
	for i = 1, 4 do
	local hp = _G["PartyMemberFrame"..i.."HealthBar"]
	local mp = _G["PartyMemberFrame"..i.."ManaBar"]
	if hp and not hp.Border then
			hp:CreateBorder()
	end
		if mp then
			CreatePowerStyle(mp)
	end
	local portrait = _G["PartyMemberFrame"..i.."Portrait"]
	if portrait then
			CreatePortraitStyle(portrait)
	end
	local pethp = _G["PartyMemberFrame"..i.."PetFrameHealthBar"]
	if pethp and not pethp.Border then
			pethp:CreateBorder()
		end
	end
		-- BOSS
	for i = 1, 4 do
	local hp = _G["Boss"..i.."TargetFrameHealthBar"]
	local mp = _G["Boss"..i.."TargetFrameManaBar"]
	local portrait = _G["Boss"..i.."TargetFramePortrait"]
	if hp and not hp.Border then
			hp:CreateBorder()
	end
	if mp then
			CreatePowerStyle(mp)
	end
	if portrait then
			CreatePortraitStyle(portrait)
		end
	end
end

 --PlayerFrame
function EnhancedFrames_Style_PlayerFrame()
if InCombatLockdown() then
	return
end
		PlayerName:SetPoint("CENTER", 50, 40)
		-- HEALTH
		PlayerFrameHealthBar.capNumericDisplay = true
		PlayerFrameHealthBar:SetSize(HEALTH_WIDTH, HEALTH_HEIGHT)
		PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -12)
		PlayerFrameHealthBarText:ClearAllPoints()
		PlayerFrameHealthBarText:SetPoint("CENTER", 50, 22)
		-- POWER
		StylePowerBar(PlayerFrameManaBar,PlayerFrameHealthBar)
		PlayerFrameManaBarText:ClearAllPoints()
		PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0.3)
		-- PORTRAIT
		StylePortrait(PlayerPortrait, PlayerFrameHealthBar, PlayerFrameManaBar, "LEFT")
		-- BACKGROUND
		PlayerFrameBackground:SetHeight(HEALTH_HEIGHT)
		PlayerFrameBackground:SetWidth(HEALTH_WIDTH)
		PlayerFrameBackground:SetPoint("TOPLEFT", 106, -12)
		-- ICONS
		PlayerAttackIcon:SetSize(34, 34)
		PlayerAttackIcon:ClearAllPoints()
		PlayerAttackIcon:SetPoint("CENTER", -10, 16)

		PlayerLeaderIcon:SetSize(20, 20)
		PlayerLeaderIcon:ClearAllPoints()
		PlayerLeaderIcon:SetPoint("TOPLEFT", 40, 0)

		PlayerLevelText:SetPoint("TOP", -40, -4)

		PlayerRestIcon:SetPoint("CENTER", -10, 16)
		PlayerGuideIcon:SetPoint("CENTER", -10, 16)
		PlayerPVPIcon:SetPoint("CENTER", -10, 16)
		PlayerRestGlow:SetPoint("CENTER", -10, 16)
		-- FERAL MANA BAR
		PlayerFrameAlternateManaBar:ClearAllPoints()
		PlayerFrameAlternateManaBar:SetPoint("BOTTOMLEFT", 127, 23.6)
		PlayerFrameAlternateManaBar:SetWidth(80)
		-- DISABLE BLIZZARD TEXTURES
		PlayerFrameTexture:Hide()
		PlayerFrameTexture.Show = V.Noop
		PlayerStatusTexture:Hide()
		PlayerStatusTexture.Show = V.Noop
		PlayerFrameFlash:Hide()
		PlayerFrameFlash.Show = V.Noop
	if PlayerFrameVehicleTexture then
			PlayerFrameVehicleTexture:Hide()
			PlayerFrameVehicleTexture.Show = V.Noop
		end
	end
function PlayerFrame_ToVehicleArt(self, vehicleType)
	PlayerFrame.state = "vehicle"
	UnitFrame_SetUnit(self, "vehicle", PlayerFrameHealthBar, PlayerFrameManaBar)
	UnitFrame_SetUnit(PetFrame, "player", PetFrameHealthBar, PetFrameManaBar)
	PetFrame_Update(PetFrame)
	PlayerFrame_Update()
	BuffFrame_Update()
	ComboFrame_Update(ComboFrame)
	-- HEALTH
	PlayerFrameHealthBar:SetSize(HEALTH_WIDTH, HEALTH_HEIGHT)
	PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -12)
	-- POWER
	StylePowerBar(PlayerFrameManaBar, PlayerFrameHealthBar)
	UpdateNoPowerBorder(PlayerFrameManaBar)
	PlayerFrameManaBar:Show()
	-- TEXT
	PlayerName:SetPoint("CENTER", 50, 40)
	PlayerLeaderIcon:SetPoint("TOPLEFT", 40, 0)
	PlayerMasterIcon:SetPoint("TOPLEFT", 86, 0)
	PlayerFrameGroupIndicator:SetPoint("BOTTOMLEFT", PlayerFrame, "TOPLEFT", 97, -13)
	PlayerLevelText:Hide()
	-- BACKGROUND
	PlayerFrameBackground:SetSize(HEALTH_WIDTH, HEALTH_HEIGHT)
	PlayerFrameBackground:SetPoint("TOPLEFT", 106, -12)
	-- DISABLE BLIZZARD VEHICLE ART
	if PlayerFrameVehicleTexture then
		PlayerFrameVehicleTexture:Hide()
		PlayerFrameVehicleTexture.Show = V.Noop
	end
	PlayerFrameFlash:Hide()
	PlayerFrameFlash.Show = V.Noop
	if PlayerStatusTexture then
		PlayerStatusTexture:Hide()
		PlayerStatusTexture.Show = V.Noop
	end
end
 --TargetFrame
function EnhancedFrames_Style_TargetFrame(self)
local classification = UnitClassification(self.unit)
if classification == "minus" then
	self.healthbar:SetHeight(12)
	self.healthbar:SetPoint("TOPLEFT", 7, -41)
	self.healthbar.TextString:SetPoint("CENTER", -50, 4)
	self.deadText:SetPoint("CENTER", -50, 4)
	if self.Background then
			self.Background:ClearAllPoints()
			self.Background:SetPoint("TOPLEFT", self.healthbar)
			self.Background:SetPoint("BOTTOMRIGHT", self.healthbar)
	end return
end
-- NAME
self.name:ClearAllPoints()
self.name:SetPoint("TOPLEFT", 16, -5)
-- HEALTH
self.healthbar:SetSize(HEALTH_WIDTH, HEALTH_HEIGHT)
self.healthbar:SetPoint("TOPLEFT", 5, -12)
self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
-- POWER
StylePowerBar(self.manabar, self.healthbar)
self.manabar.TextString:ClearAllPoints()
self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0.3)
-- DEAD TEXT
self.deadText:SetPoint("CENTER", -50, 12)
-- BACKGROUND
local background = _G[self:GetName().."Background"]
if background then
background:SetPoint("TOPLEFT", self.healthbar)
background:SetPoint("BOTTOMRIGHT", self.healthbar)
end
-- PORTRAIT
local portrait = self.portrait or _G[self:GetName().."Portrait"]

	TargetFrameTextureFrameLevelText:ClearAllPoints()
	TargetFrameTextureFrameLevelText:SetPoint("CENTER", 40, 40)
	
	TargetFrameTextureFrameHighLevelTexture:ClearAllPoints()
	TargetFrameTextureFrameHighLevelTexture:SetPoint("CENTER", TargetFrameTextureFrameLevelText, 0, 0)
	TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
	TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", 40, 40)
	TargetFrameTextureFrameRaidTargetIcon:SetSize(22, 22)

if portrait then
	StylePortrait(portrait, self.healthbar, self.manabar, "RIGHT")
end
-- TARGET ONLY
if self == TargetFrame then
	TargetFrameNumericalThreat:SetPoint("BOTTOM", 40, 16)
	TargetFrameNumericalThreatBG:SetAlpha(1)
	TargetFrameNumericalThreatBG:SetSize(36, 14)
	TargetFrameNumericalThreatBG:ClearAllPoints()
	TargetFrameNumericalThreatBG:SetPoint("TOP", 0, 10)
	TargetFrameNumericalThreatValue:SetPoint("TOP", 1, 10)
	if TargetFrameTextureFrameTexture then
		TargetFrameTextureFrameTexture:Hide()
	end
end
UpdateNoPowerBorder(self.manabar)
end
-- Focus Frame
function EnhancedFrames_Style_FocusFrame()
	-- FOCUS POWER
	StylePowerBar(FocusFrameManaBar, FocusFrameHealthBar)
	UpdateNoPowerBorder(FocusFrameManaBar)
	-- FOCUS PORTRAIT
	StylePortrait(FocusFramePortrait, FocusFrameHealthBar, FocusFrameManaBar, "RIGHT")
	-- FOCUS LEVEL
	FocusFrameTextureFrameLevelText:ClearAllPoints()
	FocusFrameTextureFrameLevelText:SetPoint("CENTER", 40, 40)
	-- FOCUS BACKGROUND
	FocusFrameBackground:SetSize(HEALTH_WIDTH, HEALTH_HEIGHT)
	FocusFrameBackground:ClearAllPoints()
	FocusFrameBackground:SetPoint("TOPLEFT", 5, -12)
	-- DISABLE BLIZZARD FOCUS ART
	if FocusFrameTextureFrameTexture then
		FocusFrameTextureFrameTexture:SetTexture(nil)
		FocusFrameTextureFrameTexture:Hide()
		FocusFrameTextureFrameTexture.Show = V.Noop
	end
end

-- Focus TOT
function EnhancedFrames_Style_FocusToTFrame()
	-- HEALTH
	FocusFrameToTHealthBar:SetSize(FOCUSTOT_WIDTH, FOCUSTOT_HEIGHT)
	FocusFrameToTHealthBar:ClearAllPoints()
	FocusFrameToTHealthBar:SetPoint("TOPLEFT", 50, -10)
	-- POWER
	FocusFrameToTManaBar:SetSize(FOCUSTOT_WIDTH, FOCUSTOT_POWER_HEIGHT)
	FocusFrameToTManaBar:ClearAllPoints()
	FocusFrameToTManaBar:SetPoint("TOPLEFT", 50, -(10 + FOCUSTOT_HEIGHT + 6))
	-- PORTRAIT
	local portraitSize = FOCUSTOT_HEIGHT + FOCUSTOT_POWER_HEIGHT + 6
	FocusFrameToTPortrait:ClearAllPoints()
	FocusFrameToTPortrait:SetPoint("TOPLEFT", 3, -10)
	FocusFrameToTPortrait:SetSize(portraitSize, portraitSize)
	-- BACKGROUND
	FocusFrameToTBackground:SetSize(FOCUSTOT_WIDTH, FOCUSTOT_HEIGHT)
	FocusFrameToTBackground:ClearAllPoints()
	FocusFrameToTBackground:SetPoint("TOPLEFT", 50, -10)
	-- NAME
	FocusFrameToTTextureFrameName:ClearAllPoints()
	FocusFrameToTTextureFrameName:SetPoint("CENTER", FocusFrameToTHealthBar, "TOP", 0, 2)

	-- POSITION
	FocusFrameToT:ClearAllPoints()
	FocusFrameToT:SetPoint("TOPRIGHT", FocusFrame, "BOTTOMRIGHT", -10, 44)
	-- DISABLE BLIZZARD ART
	if FocusFrameToTTextureFrameTexture then
		FocusFrameToTTextureFrameTexture:SetTexture(nil)
		FocusFrameToTTextureFrameTexture:Hide()
		FocusFrameToTTextureFrameTexture.Show = V.Noop
	end
	if FocusFrameToTTexture then
		FocusFrameToTTexture:SetTexture(nil)
		FocusFrameToTTexture:Hide()
		FocusFrameToTTexture.Show = V.Noop
	end
end

-- Target TOT
function EnhancedFrames_Style_TargetToTFrame()
	TargetFrameToT:ClearAllPoints()
	TargetFrameToT:SetPoint("CENTER", ToTFrameAnchor)
	-- HEALTH
	TargetFrameToTHealthBar:SetSize(TOT_WIDTH, TOT_HEIGHT)
	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOPLEFT", 50, -10)
	-- POWER
	TargetFrameToTManaBar:SetSize(TOT_WIDTH, TOT_POWER_HEIGHT)
	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("TOPLEFT", 50, -(10 + TOT_HEIGHT + 6))
	-- PORTRAIT
	local portraitSize = TOT_HEIGHT + TOT_POWER_HEIGHT + 6
	TargetFrameToTPortrait:ClearAllPoints()
	TargetFrameToTPortrait:SetPoint("TOPLEFT", 3, -10)
	TargetFrameToTPortrait:SetSize(portraitSize, portraitSize)
	-- BACKGROUND
	TargetFrameToTBackground:SetSize(TOT_WIDTH, TOT_HEIGHT)
	TargetFrameToTBackground:ClearAllPoints()
	TargetFrameToTBackground:SetPoint("TOPLEFT", 50, -10)
	-- NAME
	TargetFrameToTTextureFrameName:ClearAllPoints()
	TargetFrameToTTextureFrameName:SetPoint("CENTER", TargetFrameToTHealthBar, "TOP", 0, 0)
	TargetFrameToTTextureFrameName:SetDrawLayer("OVERLAY", 7)
	if TargetFrameToTTextureFrame then
	TargetFrameToTTextureFrame:SetFrameStrata("MEDIUM")
	end
	-- DEBUFFS
	TargetFrameToTDebuff1:ClearAllPoints()
	TargetFrameToTDebuff1:SetPoint("TOPLEFT", TargetFrameToTPortrait, "BOTTOMLEFT", 0, -4)
	TargetFrameToTDebuff3:ClearAllPoints()
	TargetFrameToTDebuff3:SetPoint("TOPRIGHT", TargetFrameToTDebuff2, 14, 0)
	-- DEAD TEXT
	TargetFrameToTTextureFrameDeadText:ClearAllPoints()
	TargetFrameToTTextureFrameDeadText:SetPoint("CENTER", 15, -3)
	
	-- DISABLE BLIZZARD ART
	if TargetFrameToTTextureFrameTexture then
		TargetFrameToTTextureFrameTexture:SetTexture(nil)
		TargetFrameToTTextureFrameTexture:Hide()
		TargetFrameToTTextureFrameTexture.Show = V.Noop
	end

	if TargetFrameToTTexture then
		TargetFrameToTTexture:SetTexture(nil)
		TargetFrameToTTexture:Hide()
		TargetFrameToTTexture.Show = V.Noop
	end
end
-- Petframe
function EnhancedFrames_Style_PetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameAnchor)
	-- PORTRAIT
	local portraitSize = PET_HEIGHT + PET_POWER_HEIGHT + 6
	PetPortrait:ClearAllPoints()
	PetPortrait:SetPoint("TOPLEFT", 3, -10)
	PetPortrait:SetSize(portraitSize, portraitSize)
	-- HEALTH
	PetFrameHealthBar:SetSize(PET_WIDTH, PET_HEIGHT)
	PetFrameHealthBar:ClearAllPoints()
	PetFrameHealthBar:SetPoint("TOPLEFT", 50, -10)
	-- POWER
	PetFrameManaBar:SetSize(PET_WIDTH, PET_POWER_HEIGHT)
	PetFrameManaBar:ClearAllPoints()
	PetFrameManaBar:SetPoint("TOPLEFT", 50, -(10 + PET_HEIGHT + 6))
	-- NAME
	PetName:ClearAllPoints()
	PetName:SetPoint("CENTER", PetFrameHealthBar, "TOP", 0, 0)
	-- HEALTH TEXT
	PetFrameHealthBarText:ClearAllPoints()
	PetFrameHealthBarText:SetPoint("CENTER", PetFrameHealthBar)
	-- POWER TEXT
	PetFrameManaBarText:ClearAllPoints()
	PetFrameManaBarText:SetPoint("CENTER", PetFrameManaBar)
	-- HAPPINESS
	PetFrameHappiness:SetScale(0.8)
	PetFrameHappiness:ClearAllPoints()
	PetFrameHappiness:SetPoint("BOTTOMLEFT", PetPortrait, "BOTTOMRIGHT", -4, 4)
	-- DEBUFFS
	PetFrameDebuff1:ClearAllPoints()
	PetFrameDebuff1:SetPoint("TOPLEFT", PetPortrait, "BOTTOMLEFT", 0, -4)
	-- DISABLE BLIZZARD
	PetHitIndicator:SetText("")
	PetHitIndicator.SetText = V.Noop

	if PetFrameFlash then PetFrameFlash:SetTexture(nil) end
if PetFrameTexture then
	PetFrameTexture:SetTexture(nil)
	PetFrameTexture:Hide()
	PetFrameTexture.Show = V.Noop
end

end

function EnhancedFrames_BossTargetFrame_Style(self)
	-- REFERENCES
	local portrait   = _G[self:GetName().."Portrait"]
	local background = _G[self:GetName().."Background"]
	local texture    = _G[self:GetName().."TextureFrameTexture"]
	local name       = _G[self:GetName().."TextureFrameName"]
	local raid       = _G[self:GetName().."TextureFrameRaidTargetIcon"]
	-- HEALTH
	self.healthbar:SetSize(BOSS_WIDTH, BOSS_HEIGHT)
	self.healthbar:ClearAllPoints()
	self.healthbar:SetPoint("TOPLEFT", 50, -10)
	-- POWER
	self.manabar:SetSize(BOSS_WIDTH, BOSS_POWER_HEIGHT)
	self.manabar:ClearAllPoints()
	self.manabar:SetPoint("TOPLEFT", 50, -(10 + BOSS_HEIGHT + 6))
	-- HEALTH TEXT
	if not self.healthbar.Value then
		self.healthbar.Value = self.healthbar:CreateFontString(nil, "OVERLAY")
		self.healthbar.Value:SetFont(C.Media.Font, 9, C.Media.Font_Style)
		self.healthbar.Value:SetPoint("CENTER")
		--self.healthbar.Value:SetText(AbbreviateLargeNumbers(UnitHealth(self.unit)))
	end
	-- POWER TEXT
	if not self.manabar.Value then
		self.manabar.Value = self.manabar:CreateFontString(nil, "OVERLAY")
		self.manabar.Value:SetFont(C.Media.Font, 8, C.Media.Font_Style)
		self.manabar.Value:SetPoint("CENTER")
		--self.manabar.Value:SetText(AbbreviateLargeNumbers(UnitMana(self.unit)))
	end
		-- PORTRAIT
		local portrait = _G[self:GetName().."Portrait"]
		if portrait then
			local portraitSize = BOSS_HEIGHT + BOSS_POWER_HEIGHT + 6
			portrait:SetTexCoord(.08, .92, .08, .92)
			portrait:ClearAllPoints()
			portrait:SetPoint("TOPLEFT", 3, -10)
			portrait:SetSize(portraitSize, portraitSize)
			SetPortraitTexture(portrait, self.unit)
			CreatePortraitStyle(portrait)
		end
	-- BACKGROUND
	if background then
		background:SetSize(BOSS_WIDTH, BOSS_HEIGHT)
		background:ClearAllPoints()
		background:SetPoint("TOPLEFT", 50, -10)
	end
	-- NAME
	if name then
		name:ClearAllPoints()
		name:SetPoint("CENTER", self.healthbar, "TOP", 0, 0)
	end
	-- RAID ICON
	if raid then
		raid:ClearAllPoints()
		raid:SetPoint("RIGHT", self.healthbar, "LEFT", -6, 0)
		raid:SetSize(20, 20)
	end
	-- POWER STYLE
	StylePowerBar(self.manabar, self.healthbar)
	UpdateNoPowerBorder(self.manabar)
	-- DISABLE BLIZZARD ART
	if texture then
		texture:SetTexture(nil)
		texture:Hide()
		texture.Show = V.Noop
	end
end


function EnhancedFrames_UpdateTextStringWithValues(textStatusBar)
	local textString = textStatusBar.TextString
	if(textString) then
		local value = textStatusBar:GetValue()
		local valueMin, valueMax = textStatusBar:GetMinMaxValues()
		if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (textStatusBar.pauseUpdates)) then
			textStatusBar:Show()
			if (value and valueMax > 0 and (GetCVarBool("statusTextPercentage") or textStatusBar.showPercentage) and not textStatusBar.showNumeric) then
				if (value == 0 and textStatusBar.zeroText) then
					textString:SetText(textStatusBar.zeroText)
					textStatusBar.isZero = 1
					textString:Show()
					return
				end
				value = tostring(ceil((value / valueMax) * 100)) .. "%"
				textString:SetText(V.ShortValue(textStatusBar:GetValue()).." - "..value.."")
			elseif (value == 0 and textStatusBar.zeroText) then
				textString:SetText(textStatusBar.zeroText)
				textStatusBar.isZero = 1
				textString:Show()
				return
			else
				textStatusBar.isZero = nil
				if (textStatusBar.capNumericDisplay) then
					value = V.ShortValue(value)
				end
				textString:SetText(value)
			end
			if ((textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) or textStatusBar.forceShow) then
				textString:Show()
			elseif (textStatusBar.lockShow > 0 and (not textStatusBar.forceHideText)) then
				textString:Show()
			else
				textString:Hide()
			end
		else
			textString:Hide()
			textString:SetText("")
			if (not textStatusBar.alwaysShow) then
				textStatusBar:Hide()
			else
				textStatusBar:SetValue(0)
			end
		end
	end
end
function EnhancedFrames_PlayerFrame_ToPlayerArt(self)

	if not InCombatLockdown() then
		EnhancedFrames_Style_PlayerFrame()
	end

	if PlayerFrameManaBar
	and PlayerFrameManaBar.VehicleBg then

		PlayerFrameManaBar.VehicleBg:Hide()

	end

end
function EnhancedFrames_PlayerFrame_ToVehicleArt(self)
	if not InCombatLockdown() then
		--PlayerFrameHealthBar:SetHeight(12)
		--PlayerFrameHealthBarText:SetPoint("CENTER", 52, 22)
	end
end
function EnhancedFrames_TargetFrame_Update(self)
	-- Set back color of health bar
	--if (not UnitPlayerControlled(self.unit) and UnitIsTapDenied(self.unit)) then
	if (not UnitPlayerControlled(self.unit)) then
		-- Gray if npc is tapped by other player
		self.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
	end
end	
function EnhancedFrames_Target_Classification(self, forceNormalTexture)
	local texture
	local classification = UnitClassification(self.unit)
	if (classification == "worldboss" or classification == "elite") then
		texture = "Interface\\Addons\\Vermilion\\Media\\Unitframes\\UI-TargetingFrame-Elite"
	elseif (classification == "rareelite") then
		texture = "Interface\\Addons\\Vermilion\\Media\\Unitframes\\UI-TargetingFrame-Rare-Elite"
	elseif (classification == "rare") then
		texture = "Interface\\Addons\\Vermilion\\Media\\Unitframes\\UI-TargetingFrame-Rare"
	end
	if (texture and not forceNormalTexture) then
		--self.borderTexture:SetTexture(texture)
	else
		if (not (classification == "minus")) then
			--self.borderTexture:SetTexture("Interface\\Addons\\Vermilion\\Media\\Unitframes\\UI-TargetingFrame")
		end
	end
	self.nameBackground:Hide()
end
function EnhancedFrames_TargetFrame_CheckFaction(self)
	local factionGroup = UnitFactionGroup(self.unit)
	if (UnitIsPVPFreeForAll(self.unit)) then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
		self.pvpIcon:Show()
	elseif (factionGroup and UnitIsPVP(self.unit) and UnitIsEnemy("player", self.unit)) then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
		self.pvpIcon:Show()
	elseif (factionGroup == "Alliance" or factionGroup == "Horde") then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)
		self.pvpIcon:Show()
	else
		self.pvpIcon:Hide()
	end
	EnhancedFrames_Style_TargetFrame(self)
end
PartyMemberFrame1:ClearAllPoints()
PartyMemberFrame1:SetPoint("TOPLEFT", 100, -180)
-- STYLE - PARTY MEMEBER FRAME STYLE CHANGES
		for i = 1, 4 do
	_G["PartyMemberFrame"..i]:SetScale("1.5")
	_G["PartyMemberFrame"..i.."Background"]:SetHeight(19.7)
	_G["PartyMemberFrame"..i.."Background"]:SetWidth(80)
	_G["PartyMemberFrame"..i.."Background"]:SetPoint("TOPLEFT", 45, -11.5)
	_G["PartyMemberFrame"..i.."Portrait"]:SetSize(34, 34)
	_G["PartyMemberFrame"..i.."Portrait"]:SetPoint("TOPLEFT", 6, -10)
	_G["PartyMemberFrame"..i.."Name"]:SetPoint("BOTTOMLEFT", 42, 40)
	_G["PartyMemberFrame"..i.."HealthBar"]:SetHeight(21)
	_G["PartyMemberFrame"..i.."HealthBar"]:SetWidth(80)
	_G["PartyMemberFrame"..i.."HealthBar"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."HealthBar"]:SetPoint("TOPLEFT", 43, -11)
	_G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("CENTER", 22, 6.5)
	_G["PartyMemberFrame"..i.."ManaBar"]:SetHeight(11)
	_G["PartyMemberFrame"..i.."ManaBar"]:SetWidth(81)
	_G["PartyMemberFrame"..i.."ManaBar"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."ManaBar"]:SetPoint("TOPLEFT", 43, -34)
	_G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("CENTER", 20, -12)
	_G["PartyMemberFrame"..i.."Debuff1"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."Debuff1"]:SetPoint("TOPLEFT", 125, -15)
	_G["PartyMemberFrame"..i.."Debuff3"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."Debuff3"]:SetPoint("TOPLEFT", 125, -30)
	_G["PartyMemberFrame"..i.."PetFrame"]:SetScale(1.0)
	_G["PartyMemberFrame"..i.."PetFramePortrait"]:SetSize(16, 16)
	_G["PartyMemberFrame"..i.."PetFramePortrait"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."PetFramePortrait"]:SetPoint("TOPLEFT", 3, -6)
	_G["PartyMemberFrame"..i.."PetFrameHealthBar"]:SetHeight(7)
	_G["PartyMemberFrame"..i.."PetFrameHealthBar"]:ClearAllPoints()
	_G["PartyMemberFrame"..i.."PetFrameHealthBar"]:SetPoint("TOPLEFT", 23, -11)
	
	_G["PartyMemberFrame"..i.."VehicleTexture"]:SetTexture("Interface\\Addons\\Vermilion\\Media\\Unitframes\\VehiclePartyFrame")
	
	_G["PartyMemberFrame"..i.."Texture"]:SetTexture("Interface\\Addons\\Vermilion\\Media\\Unitframes\\PartyFrame")
	_G["PartyMemberFrame"..i.."Texture"]:SetPoint("TOPLEFT", 0, -1)

	_G["PartyMemberFrame"..i.."Flash"]:SetTexture("Interface\\Addons\\Vermilion\\Media\\Unitframes\\PartyFrameFlash")
	_G["PartyMemberFrame"..i.."Flash"]:SetPoint("TOPLEFT", 0, 6)
	end
local function fixPartyPortrait()
	for i=1,4 do
		_G["PartyMemberFrame"..i.."Portrait"]:ClearAllPoints()
		_G["PartyMemberFrame"..i.."Portrait"]:SetPoint("TOPLEFT", 6, -10)
	end
end



-- CLASS COLORED NAMES ----------------------------
---------------------------------------------------
-- Player
local function playerNameColor()
	local playerColor = RAID_CLASS_COLORS[class]
	PlayerName:SetTextColor(playerColor.r, playerColor.g, playerColor.b)
end
-- Target
local function targetNameColor()
	local isPlayer = UnitIsPlayer("target")
	local _, targetClass = UnitClass("target")
	local targetClassColor = RAID_CLASS_COLORS[targetClass]
	if (isPlayer == 1) and not (targetClassColor == nil) then
		TargetFrameTextureFrameName:SetTextColor(targetClassColor.r, targetClassColor.g, targetClassColor.b) 
	elseif (UnitIsTapped("target")) and (not UnitIsTappedByPlayer("target")) then
		TargetFrameTextureFrameName:SetTextColor(0.7, 0.7, 0.7)
	else
		TargetFrameTextureFrameName:SetTextColor(1, 0.8, 0)
	end
end
-- Target of target
local function totNameColor(target, ...)
	local totIsPlayer = UnitIsPlayer("targettarget")
	local _, totClass = UnitClass("targettarget")
	local totClassColor = RAID_CLASS_COLORS[totClass]
	if (totIsPlayer == 1) and not (totClassColor == nil) then
		TargetFrameToTTextureFrameName:SetTextColor(totClassColor.r, totClassColor.g, totClassColor.b)
	else
		TargetFrameToTTextureFrameName:SetTextColor(1, 0.8, 0)
	end
end
-- Focus
local function focusNameColor()
	local focusIsPlayer = UnitIsPlayer("focus")
	local _, focusClass = UnitClass("focus")
	local focusClassColor = RAID_CLASS_COLORS[focusClass]
	if (focusIsPlayer == 1) and not (focusClassColor == nil) then
		FocusFrameTextureFrameName:SetTextColor(focusClassColor.r, focusClassColor.g, focusClassColor.b)
	else
		FocusFrameTextureFrameName:SetTextColor(1, 0.8, 0)
	end
end
-- Focus target of target
local function focusToTNameColor(focus, ...)
	local focusToTIsPlayer = UnitIsPlayer("focustarget")
	local _, focusToTClass = UnitClass("focustarget")
	local focusToTClassColor = RAID_CLASS_COLORS[focusToTClass]
	if (focusToTIsPlayer == 1) and not (focusToTClassColor == nil) then
		FocusFrameToTTextureFrameName:SetTextColor(focusToTClassColor.r, focusToTClassColor.g, focusToTClassColor.b)
	else
		FocusFrameToTTextureFrameName:SetTextColor(1, 0.8, 0)
	end
end
-- Party frames
local function partyNameColor()
	local _, party1Class = UnitClass("party1")
	local party1ClassColor = RAID_CLASS_COLORS[party1Class]
	if not (party1ClassColor == nil) then
		PartyMemberFrame1Name:SetTextColor(party1ClassColor.r, party1ClassColor.g, party1ClassColor.b)
	end
	local _, party2Class = UnitClass("party2")
	local party2ClassColor = RAID_CLASS_COLORS[party2Class]
	if not (party2ClassColor == nil) then
		PartyMemberFrame2Name:SetTextColor(party2ClassColor.r, party2ClassColor.g, party2ClassColor.b)
	end
	local _, party3Class = UnitClass("party3")
	local party3ClassColor = RAID_CLASS_COLORS[party3Class]
	if not (party3ClassColor == nil) then
		PartyMemberFrame3Name:SetTextColor(party3ClassColor.r, party3ClassColor.g, party3ClassColor.b)
	end
	local _, party4Class = UnitClass("party4")
	local party4ClassColor = RAID_CLASS_COLORS[party4Class]
	if not (party4ClassColor == nil) then
		PartyMemberFrame4Name:SetTextColor(party4ClassColor.r, party4ClassColor.g, party4ClassColor.b)
	end
end
-- EVENTS -----------------------------------------
---------------------------------------------------
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
eventHandler:RegisterEvent("PLAYER_FOCUS_CHANGED")
eventHandler:RegisterEvent("PARTY_MEMBERS_CHANGED")
eventHandler:RegisterEvent("UNIT_TARGET")
eventHandler:SetScript("OnEvent", function(self, event, arg1)
	if (event == "PLAYER_ENTERING_WORLD") then
		playerNameColor()
	end
	if (event == "PLAYER_TARGET_CHANGED") then
		targetNameColor()
		totNameColor()
	end
	if (event == "PLAYER_FOCUS_CHANGED") then
		focusNameColor()
		focusToTNameColor()
	end
	if (event == "PLAYER_REGEN_ENABLED") then
		eventHandler:UnregisterEvent("PLAYER_REGEN_ENABLED")
		fixPartyPortrait()
		PlayerFrame:SetAlpha(1)
	end
	if (event == "PARTY_MEMBERS_CHANGED") then
		partyNameColor()
	end
	if (event == "UNIT_TARGET") then
		totNameColor()
		focusToTNameColor()
	end
end)
-- Hooks to fix party frames
hooksecurefunc("PartyMemberFrame_ToPlayerArt", function()
	if not (UnitAffectingCombat("player")) then
		fixPartyPortrait()
	else
		eventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end)
-- LoseControl
if lc or lcl then
	LoseControlplayer:SetScale(0.76)
	LoseControltarget:SetScale(0.76)
	LoseControlfocus:SetScale(0.76)
	LoseControlarena1:SetScale(0.94)
	LoseControlarena2:SetScale(0.94)
	LoseControlarena3:SetScale(0.94)
	LoseControlarena4:SetScale(0.94)
	LoseControlarena5:SetScale(0.94)
end
-- BOOTSTRAP
function EnhancedFrames_StartUp(self)
	self:SetScript("OnEvent", function(self, event) self[event](self) end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end
EnhancedFrames_StartUp(EnhancedFrames)
local ToT = TargetFrameToT
if ToT then
	-- HP TEXT
-- TARGETTARGET HP TEXT
if not ToT.HealthText then
	ToT.HealthText = ToT.healthbar:CreateFontString(nil, "OVERLAY")
	--ToT.HealthText:SetFont(C.Media.Font, 8, "SHADOW")
	ToT.HealthText:SetFont(C.Media.Font, 8, C.Media.Font_Size)
	ToT.HealthText:SetShadowOffset(V.Mult, -V.Mult)
	ToT.HealthText:SetDrawLayer("OVERLAY", 7)
	ToT.HealthText:SetPoint("CENTER", ToT.healthbar, "CENTER", 0, 0)
	ToT.HealthText:SetParent(ToT.healthbar)
end
-- TARGETTARGET POWER TEXT
if not ToT.ManaText then
	ToT.ManaText = ToT.manabar:CreateFontString(nil, "OVERLAY")
	ToT.ManaText:SetFont(C.Media.Font, 8, C.Media.Font_Size)
	ToT.ManaText:SetShadowOffset(V.Mult, -V.Mult)
	ToT.ManaText:SetPoint("CENTER", ToT.manabar, "CENTER", 0, 0)
	ToT.ManaText:SetParent(ToT.manabar)
end
-- FORCE FRONT
ToT.healthbar:SetFrameLevel(ToT:GetFrameLevel() + 5)
ToT.manabar:SetFrameLevel(ToT:GetFrameLevel() + 5)
	local function UpdateToTText()
		if not UnitExists("targettarget") then
			ToT.HealthText:SetText("")
			ToT.ManaText:SetText("")
			return
		end
		-- HP
		local hp = UnitHealth("targettarget")
		local hpMax = UnitHealthMax("targettarget")
		if hpMax and hpMax > 0 then
			local hpPercent = floor((hp / hpMax) * 100)
			ToT.HealthText:SetText(V.ShortValue(hp) .. " - " .. hpPercent .. "%")
		end
		-- POWER
		local power = UnitPower("targettarget")
		local powerMax = UnitPowerMax("targettarget")

		if powerMax and powerMax > 0 then
			local powerPercent = floor((power / powerMax) * 100)
			ToT.ManaText:SetText(V.ShortValue(power) .. " - " .. powerPercent .. "%")
		else
			ToT.ManaText:SetText("")
		end
	end
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("UNIT_TARGET")
	f:RegisterEvent("UNIT_HEALTH")
	f:RegisterEvent("UNIT_MANA")
	f:RegisterEvent("UNIT_ENERGY")
	f:RegisterEvent("UNIT_RAGE")
	f:RegisterEvent("UNIT_FOCUS")
	f:SetScript("OnEvent", function(self, event, unit)
		if not unit or unit == "targettarget" then
			UpdateToTText()
		end
	end)
	UpdateToTText()
end

