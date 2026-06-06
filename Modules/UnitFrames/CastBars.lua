local V, C, L, _ = select(2, ...):unpack()
if C.Unitframe.Enable ~= true or IsAddOnLoaded("Quartz") then return end

local unpack = unpack
local format = string.format
local max = math.max
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIPARENT_MANAGED_FRAME_POSITIONS = UIPARENT_MANAGED_FRAME_POSITIONS
local CastBars = CreateFrame("Frame", nil, UIParent)
-- Anchors
local PlayerCastbarAnchor = CreateFrame("Frame", "PlayerCastbarAnchor", UIParent)
if not InCombatLockdown() then
	PlayerCastbarAnchor:SetSize(CastingBarFrame:GetWidth() * C.Unitframe.CastBarScale, CastingBarFrame:GetHeight() * 2)
	PlayerCastbarAnchor:SetPoint(unpack(C.Position.UnitFrames.PlayerCastBar))
end
local TargetCastbarAnchor = CreateFrame("Frame", "TargetCastbarAnchor", UIParent)
if not InCombatLockdown() then
	TargetCastbarAnchor:SetSize(TargetFrameSpellBar:GetWidth() * C.Unitframe.CastBarScale, TargetFrameSpellBar:GetHeight() * 2)
	TargetCastbarAnchor:SetPoint(unpack(C.Position.UnitFrames.TargetCastBar))
end
CastBars:RegisterEvent("ADDON_LOADED")
CastBars:SetScript("OnEvent", function(self, event, addon)
	if (addon ~= "Vermilion") then return end
	if not InCombatLockdown() then
		UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
		-- Move Cast Bar
--------------------------------------------------
-- PLAYER CASTBAR
--------------------------------------------------

CastingBarFrame:ClearAllPoints()
CastingBarFrame:SetScale(C.Unitframe.CastBarScale)
CastingBarFrame:SetHeight(20)
CastingBarFrame:SetWidth(196)
CastingBarFrame:SetPoint("CENTER", PlayerCastbarAnchor, "CENTER", 0, -3)
CastingBarFrame.SetPoint = V.Noop

-- Kill Blizzard Art
CastingBarFrameBorder:Hide()
CastingBarFrameBorder.Show = V.Noop

CastingBarFrameFlash:Hide()
CastingBarFrameFlash.Show = V.Noop

CastingBarFrameBorderShield:Hide()
CastingBarFrameBorderShield.Show = V.Noop

CastingBarFrameBorder:SetAlpha(0)
CastingBarFrameFlash:SetAlpha(0)
CastingBarFrameBorderShield:SetAlpha(0)

CastingBarFrameText:ClearAllPoints()
CastingBarFrameText:SetPoint("RIGHT", 0, 0)

-- Icon
CastingBarFrameIcon:Show()
CastingBarFrameIcon:SetSize(20,20)
CastingBarFrameIcon:ClearAllPoints()
CastingBarFrameIcon:SetPoint("LEFT", CastingBarFrame, "RIGHT", 7, 0)

		
		-- Target Castbar
		TargetFrameSpellBar:ClearAllPoints()
		TargetFrameSpellBar:SetPoint("CENTER", TargetCastbarAnchor, "CENTER", 0, 0)
		TargetFrameSpellBar:SetScale(C.Unitframe.CastBarScale)
		TargetFrameSpellBar:SetHeight(20)
		TargetFrameSpellBar:SetWidth(148) 
		TargetFrameSpellBarText:ClearAllPoints()
		TargetFrameSpellBarText:SetPoint("CENTER", 0, 0.8)
		TargetFrameSpellBarFlash:Hide()
		TargetFrameSpellBarFlash.Show = V.Noop
local border = select(2, TargetFrameSpellBar:GetRegions())

if border then
	border:SetTexture(nil)
	border:Hide()
end
		TargetFrameSpellBar.ShieldIcon = TargetFrameSpellBar:CreateTexture(nil, "OVERLAY")
		TargetFrameSpellBar.ShieldIcon:SetSize(14, 14)
		TargetFrameSpellBar.ShieldIcon:SetPoint("LEFT", TargetFrameSpellBar, "RIGHT", 4, 0)
		TargetFrameSpellBar.ShieldIcon:SetTexture("Interface\\Icons\\Spell_Holy_AuraOfLight")
		TargetFrameSpellBar.ShieldIcon:Hide()
		-- Focus --
		FocusFrameSpellBar:SetHeight(15)
		FocusFrameSpellBarText:ClearAllPoints()
		FocusFrameSpellBarText:SetPoint("CENTER", 0, 0.8)
		FocusFrameSpellBarFlash:Hide()
		FocusFrameSpellBarFlash.Show = V.Noop
local border = select(2, FocusFrameSpellBar:GetRegions())

if border then
	border:SetTexture(nil)
	border:Hide()
end
		TargetFrameSpellBar.SetPoint = V.Noop
		FocusFrameSpellBar.ShieldIcon = FocusFrameSpellBar:CreateTexture(nil, "OVERLAY")
		FocusFrameSpellBar.ShieldIcon:SetSize(14, 14)
		FocusFrameSpellBar.ShieldIcon:SetPoint("LEFT", FocusFrameSpellBar, "RIGHT", 4, 0)
		FocusFrameSpellBar.ShieldIcon:SetTexture("Interface\\Icons\\Spell_Holy_AuraOfLight")
		FocusFrameSpellBar.ShieldIcon:Hide()


--------------------------------------------------
-- BORDERS
--------------------------------------------------

V.CreateBorder(CastingBarFrame, 2, 12)
V.CreateBorder(TargetFrameSpellBar, 2, 12)
V.CreateBorder(FocusFrameSpellBar, 2, 12)
V.CreateBorder(CastingBarFrameIcon)
if CastingBarFrame.Border then
	CastingBarFrame.Border:SetFrameStrata("HIGH")
end
--CastingBarFrame.Border:Hide()
--TargetFrameSpellBar.Border:Hide()
--FocusFrameSpellBar.Border:Hide()

		CastingBarFrame:HookScript("OnShow", function(self)
			if self.Border then self.Border:Show() end
		end)

		CastingBarFrame:HookScript("OnHide", function(self)
			if self.Border then self.Border:Hide() end
		end)

		TargetFrameSpellBar:HookScript("OnShow", function(self)
			if self.Border then self.Border:Show() end
		end)

		TargetFrameSpellBar:HookScript("OnHide", function(self)
			if self.Border then self.Border:Hide() end
		end)

		FocusFrameSpellBar:HookScript("OnShow", function(self)
			if self.Border then self.Border:Show() end
		end)

		FocusFrameSpellBar:HookScript("OnHide", function(self)
			if self.Border then self.Border:Hide() end
		end)
		-- Castbar Timer
		CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
		if C.Unitframe.Outline then
			CastingBarFrame.timer:SetFont(C.Media.Font, C.Media.Font_Size + 2, C.Media.Font_Style)
			CastingBarFrame.timer:SetShadowOffset(0, -0)
		else
			CastingBarFrame.timer:SetFont(C.Media.Font, C.Media.Font_Size + 2)
			CastingBarFrame.timer:SetShadowOffset(V.Mult, -V.Mult)
		end
		CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "LEFT", -4, 0.8)
		CastingBarFrame.updateDelay = 0.1

		TargetFrameSpellBar.timer = TargetFrameSpellBar:CreateFontString(nil)
		if C.Unitframe.Outline then
			TargetFrameSpellBar.timer:SetFont(C.Media.Font, C.Media.Font_Size, C.Media.Font_Style)
			TargetFrameSpellBar.timer:SetShadowOffset(0, -0)
		else
			TargetFrameSpellBar.timer:SetFont(C.Media.Font, C.Media.Font_Size)
			TargetFrameSpellBar.timer:SetShadowOffset(V.Mult, -V.Mult)
		end
		TargetFrameSpellBar.timer:SetPoint("LEFT", TargetFrameSpellBar, "RIGHT", 3, 1)
		TargetFrameSpellBar.updateDelay = 0.1

		self:UnregisterEvent("ADDON_LOADED")
	end
end)
-- Displays the Casting Bar timer
local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
	if(not self.timer) then
		return
	end
	if(self.updateDelay) and (self.updateDelay < elapsed) then
		if(self.casting) then
			self.timer:SetText(format("%2.1f", max(self.maxValue - self.value, 0), self.maxValue))
		elseif(self.channeling) then
			self.timer:SetText(format("%.1f", max(self.value, 0)))
		else
			self.timer:SetText("")
		end
		self.updateDelay = 0.1
	else
		self.updateDelay = self.updateDelay - elapsed
	end
	end

local function UpdateCastbarBorder(bar)

	if not bar or not bar.Border then
		return
	end

	if bar.notInterruptible then

		bar.Border:SetBackdropBorderColor(1, 0, 0)

		if bar.ShieldIcon then
			bar.ShieldIcon:Show()
		end

	else

		local r, g, b = unpack(C.Blizzard.DarkTexturesColor)

		bar.Border:SetBackdropBorderColor(r, g, b)

		if bar.ShieldIcon then
			bar.ShieldIcon:Hide()
		end

	end

end

hooksecurefunc("CastingBarFrame_OnUpdate", function()

	UpdateCastbarBorder(CastingBarFrame)
	UpdateCastbarBorder(TargetFrameSpellBar)
	UpdateCastbarBorder(FocusFrameSpellBar)

end)