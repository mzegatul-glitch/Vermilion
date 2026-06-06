local V, C, L, _ = select(2, ...):unpack()
if C.Skins.DBM ~= true then return end

local _G = _G
local format = string.format
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local croprwicons = true
local rwiconsize = 12

local backdrop = {
	bgFile = C.Media.Texture,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

local function ApplyFont(fs, size, justify)
	if not fs then return end

	fs:SetFont(C.Media.Font or STANDARD_TEXT_FONT, size or 12, "OUTLINE")
	fs:SetShadowOffset(0, 0)

	if justify then
		fs:SetJustifyH(justify)
	end
end

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")

DBMSkin:SetScript("OnEvent", function(self)
	if not IsAddOnLoaded("DBM-Core") then
		return
	end

	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				bar.ApplyStyle = function()
					local frame = bar.frame
					if not frame then return end

					local tbar = _G[frame:GetName().."Bar"]
					local spark = _G[frame:GetName().."BarSpark"]
					local texture = _G[frame:GetName().."BarTexture"]
					local icon1 = _G[frame:GetName().."BarIcon1"]
					local icon2 = _G[frame:GetName().."BarIcon2"]
					local name = _G[frame:GetName().."BarName"]
					local timer = _G[frame:GetName().."BarTimer"]

					local options = bar.owner and (bar.owner.Options or bar.owner.options)

					-- ICON BACKDROPS
					if icon1 and not icon1.overlay then
						icon1.overlay = CreateFrame("Frame", nil, tbar)
						icon1.overlay:SetSize(23, 23)
						icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, -2)

						if icon1.overlay.CreateBackdrop then
							icon1.overlay:CreateBackdrop(2)
						end
					end

					if icon2 and not icon2.overlay then
						icon2.overlay = CreateFrame("Frame", nil, tbar)
						icon2.overlay:SetSize(23, 23)
						icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, -2)

						if icon2.overlay.CreateBackdrop then
							icon2.overlay:CreateBackdrop(2)
						end
					end

					-- BAR SIZE
					if options then
						local width = bar.enlarged and (options.HugeWidth or 183) or (options.Width or 183)

						frame:SetWidth(width)

						if tbar then
							tbar:SetWidth(width)
						end
					end

					frame:SetScale(1)

					-- FRAME STYLE
					if not frame.styled then
						frame:SetHeight(23)

						if frame.CreateBackdrop then
							frame:CreateBackdrop(2)
						end

						frame.styled = true
					end

					-- BAR STYLE
					if tbar then
						tbar:SetStatusBarTexture(C.Media.Texture)
						tbar:SetStatusBarColor(0.1, 0.1, 0.1)

						if tbar.SetBackdrop then
							tbar:SetBackdrop(backdrop)
							tbar:SetBackdropColor(0.1, 0.1, 0.1, 0.15)
						end

						if not tbar.styled then
							tbar:ClearAllPoints()
							tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

							tbar.styled = true
						end
					end

					-- SPARK REMOVE
					if spark and not spark.killed then
						spark:SetTexture(nil)
						spark:SetAlpha(0)
						spark.killed = true
					end

					-- TEXTURE
					if texture and not texture.styled then
						texture:SetTexture(C.Media.Texture)
						texture.styled = true
					end

					-- ICON 1
					if icon1 and not icon1.styled then
						icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)

						icon1:ClearAllPoints()
						icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
						icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)

						icon1.styled = true
					end

					-- ICON 2
					if icon2 and not icon2.styled then
						icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)

						icon2:ClearAllPoints()
						icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
						icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)

						icon2.styled = true
					end

					-- NAME
					if name and not name.styled then
						name:ClearAllPoints()
						name:SetPoint("LEFT", frame, "LEFT", 4, 0)
						name:SetWidth(180)

						ApplyFont(name, 12, "LEFT")

						name.styled = true
					end

					-- TIMER
					if timer and not timer.styled then
						timer:ClearAllPoints()
						timer:SetPoint("RIGHT", frame, "RIGHT", -5, 0)

						ApplyFont(timer, 12, "RIGHT")

						timer.styled = true
					end

					-- ICON VISIBILITY
					if icon1 and icon1.overlay then
						if options and options.IconLeft then
							icon1:Show()
							icon1.overlay:Show()
						else
							icon1:Hide()
							icon1.overlay:Hide()
						end
					end

					if icon2 and icon2.overlay then
						if options and options.IconRight then
							icon2:Show()
							icon2.overlay:Show()
						else
							icon2:Hide()
							icon2.overlay:Hide()
						end
					end

					frame:SetAlpha(1)

					if tbar then
						tbar:SetAlpha(1)
					end

					frame:Show()

					if bar.Update then
						bar:Update(0)
					end

					bar.injected = true
				end

				bar:ApplyStyle()
			end
		end
	end

	-- DBM TIMER BARS
	if DBT then
		hooksecurefunc(DBT, "CreateBar", SkinBars)
	end

	-- RAID WARNING ICON CROP
	if croprwicons then
		local replace = string.gsub
		local old = RaidNotice_AddMessage

		RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
			if type(textString) == "string" and textString:find(" |T") then
				textString = replace(
					textString,
					"(:12:12)",
					":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59"
				)
			end

			return old(noticeFrame, textString, colorInfo)
		end
	end
end)