local V, C, L, _ = select(2, ...):unpack()

local _G = _G
local unpack = unpack
local CreateFrame = CreateFrame
local UIParent = UIParent
local GetRuneCooldown = GetRuneCooldown
local GetTime = GetTime
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitHasVehicleUI = UnitHasVehicleUI

if V.Class == "DEATHKNIGHT" then
	local size = 36.2
	local spacing = 6
	local order = {1, 2, 5, 6, 3, 4} -- visual order
	for i = 1, 6 do
		local rune = _G["RuneButtonIndividual"..order[i]]
		-- hide orb textures
		if rune.rune then rune.rune:SetAlpha(0)	end
		if rune.normalTexture then
			rune.normalTexture:SetAlpha(0)
		end
		if not rune.text then
		rune.text = rune:CreateFontString(nil, "OVERLAY")
		rune.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
		rune.text:SetPoint("CENTER", rune, "CENTER", 0, 0)
		end

		if rune.highlightTexture then
			rune.highlightTexture:SetAlpha(0)
		end

		-- hide all default textures
		for _, region in pairs({rune:GetRegions()}) do
			if region and region.SetTexture then
				region:SetTexture(nil)
			end
		end

		-- hide child frames/glow
		for _, child in pairs({rune:GetChildren()}) do
			child:SetAlpha(0)
			child:Hide()
		end

		if rune.Circle then
			rune.Circle:SetAlpha(0)
		end

		if rune.glow then
			rune.glow:SetAlpha(0)
		end

		rune:ClearAllPoints()
		rune:SetWidth(size)
		rune:SetHeight(18)

		if i == 1 then
			rune:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 944, 306)
		else
			local prev = _G["RuneButtonIndividual"..order[i - 1]]
			rune:SetPoint("LEFT", prev, "RIGHT", spacing, 0)
		end

		-- border
		if not rune.border then
			rune.border = CreateFrame("Frame", nil, rune)
			rune.border:SetPoint("TOPLEFT", -3, 3)
			rune.border:SetPoint("BOTTOMRIGHT", 3, -3)

			rune.border:SetBackdrop({
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				edgeSize = 12,
			})

			rune.border:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
		end
		-- background
		if not rune.bg then
			rune.bg = rune:CreateTexture(nil, "BACKGROUND")
			rune.bg:SetAllPoints(rune)
			rune.bg:SetTexture("Interface\\Buttons\\WHITE8X8")
			rune.bg:SetVertexColor(0, 0, 0, 0.6)
		end
		-- fill
		if not rune.bar then
			rune.bar = rune:CreateTexture(nil, "ARTWORK")
			rune.bar:SetTexture("Interface\\Buttons\\WHITE8X8")
			rune.bar:SetPoint("LEFT", rune, "LEFT", 0, 0)
			rune.bar:SetHeight(18)
			rune.bar:SetWidth(size)
		end
		end

		RuneUpdate = CreateFrame("Frame")

		RuneUpdate:RegisterEvent("RUNE_POWER_UPDATE")
		RuneUpdate:RegisterEvent("RUNE_TYPE_UPDATE")
		RuneUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
		RuneUpdate:SetScript("OnEvent", function()
		for i = 1, 6 do
		local rune = _G["RuneButtonIndividual"..order[i]]

		local runeType = GetRuneType(order[i])
		local start, duration, runeReady = GetRuneCooldown(order[i])

		if rune and rune.bar then
			if runeReady then

				-- Blood
				if runeType == 1 then
					rune.bar:SetVertexColor(0.8, 0, 0, 1)

				-- Unholy
				elseif runeType == 2 then
					rune.bar:SetVertexColor(0, 0.8, 0, 1)

				-- Frost
				elseif runeType == 3 then
					rune.bar:SetVertexColor(0, 0.8, 1, 1)

				-- Death
				elseif runeType == 4 then
					rune.bar:SetVertexColor(0.7, 0, 1, 1)
				end

				rune.bar:SetWidth(size)
				rune.text:SetText("")
			else
				if not runeReady then
		local remaining = duration - (GetTime() - start)

				if remaining < 0 then
					remaining = 0
				end

		local progress = 1 - (remaining / duration)

				if progress < 0 then
					progress = 0
				elseif progress > 1 then
					progress = 1
				end

					-- Blood
				if runeType == 1 then
					rune.bar:SetVertexColor(0.8, 0, 0, 1)

					-- Unholy
				elseif runeType == 2 then
					rune.bar:SetVertexColor(0, 0.8, 0, 1)

					-- Frost
				elseif runeType == 3 then
					rune.bar:SetVertexColor(0, 0.8, 1, 1)

					-- Death
				elseif runeType == 4 then
					rune.bar:SetVertexColor(0.7, 0, 1, 1)
				end

					rune.bar:SetWidth(size * progress)
					rune.text:SetFormattedText("%.0f", remaining)

				else
					rune.bar:SetWidth(size)
					rune.text:SetText("")
				end
			end
		end
	end
end)
			RuneUpdate:SetScript("OnUpdate", function(self, elapsed)
				self.timer = (self.timer or 0) + elapsed

			if self.timer < 0.1 then
			return
			end

			self.timer = 0

			for i = 1, 6 do
				local rune = _G["RuneButtonIndividual"..order[i]]

				local start, duration, runeReady = GetRuneCooldown(order[i])
		
				if rune and rune.text then
			if not runeReady then
				local remaining = duration - (GetTime() - start)

				if remaining > 0 then
					rune.text:SetFormattedText("%.f", remaining)

					local alpha = remaining / duration

					if alpha < 0.25 then
						alpha = 0.25
					end

				local progress = 1 - (remaining / duration)

					if progress < 0 then
						progress = 0
					elseif progress > 1 then
						progress = 1
					end

				rune.bar:SetWidth(size * progress)

				else
					rune.text:SetText("")
					rune.bar:SetWidth(size)
				end
			else
				rune.text:SetText("")
				rune.bar:SetWidth(size)
			end
		end
	end
end)

RuneFrame:Show()
end
for i = 1, 4 do
	local totem = _G["TotemFrameTotem"..i]
	-- Totem frame бүрэн нуух
	if totem then
		totem:Hide()
		totem.Show = function() end
		totem:SetAlpha(0)
	end
	-- Icon нуух
	local icon = _G["TotemFrameTotem"..i.."IconTexture"]
	if icon then
		icon:Hide()
		icon.Show = function() end
	end
	-- Duration text нуух
	local duration = _G["TotemFrameTotem"..i.."Duration"]
	if duration then
		duration:Hide()
		duration.Show = function() end
	end
	-- Background нуух
	local bg = _G["TotemFrameTotem"..i.."Background"]
	if bg then
		bg:Hide()
		bg.Show = function() end
	end
end
-- TotemFrame өөрийг нь бас нуух
if TotemFrame then
	TotemFrame:Hide()
	TotemFrame.Show = function() end
end
			-- ComboFrame
if V.Class == "ROGUE" or V.Class == "DRUID" then
	local size = 44.8
	local spacing = 6

	ComboFrame:SetScale(1)
	ComboFrame:ClearAllPoints()
	ComboFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 274, 45)

	for i = 1, 5 do
		local point = _G["ComboPoint"..i]

		-- hide blizzard textures
		for _, region in pairs({point:GetRegions()}) do
			if region and region.SetTexture then
				region:SetTexture(nil)
			end
		end

		point:ClearAllPoints()
		point:SetWidth(size)
		point:SetHeight(18)

		if i == 1 then
			point:SetPoint("LEFT", ComboFrame, "LEFT", 0, 0)
		else
			point:SetPoint("LEFT", _G["ComboPoint"..(i - 1)], "RIGHT", spacing, 0)
		end

		-- black border
		if not point.border then
			point.border = CreateFrame("Frame", nil, point)
			point.border:SetPoint("TOPLEFT", -3, 3)
			point.border:SetPoint("BOTTOMRIGHT", 3, -3)

			point.border:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 12,
		})

			point.border:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
		end

		-- gold fill
		if not point.bar then
			point.bar = point:CreateTexture(nil, "ARTWORK")
			point.bar:SetAllPoints(point)
			point.bar:SetTexture("Interface\\Buttons\\WHITE8X8")
			point.bar:SetVertexColor(1, 0.76, 0, 1)
		end

		point:Show()
	end

	hooksecurefunc("ComboFrame_Update", function()
	local comboPoints = GetComboPoints("player", "target")

	for i = 1, 5 do
		local point = _G["ComboPoint"..i]

		if i <= comboPoints then
			-- 5 combo = red
			if comboPoints == 5 then
				point.bar:SetVertexColor(1, 0, 0, 1)
			else
				-- 1-4 combo = gold
				point.bar:SetVertexColor(1, 0.76, 0, 1)
			end
		else
			-- inactive
			point.bar:SetVertexColor(0, 0, 0, 0.7)
		end
	end
end)

	ComboFrame:Show()
end