local V, C, L, _ = select(2, ...):unpack()
if C.Skins.Skada ~= true then
	return
end

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local pairs = pairs
local ipairs = ipairs
local unpack = unpack

-- Skada skin
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self)
	if not IsAddOnLoaded("Skada") then
		return
	end

	if not Skada or not Skada.displays then
		return
	end

	local barmod = Skada.displays["bar"]

	if not barmod then
		return
	end

	-- Strip useless options safely
	local function StripOptions(options)
		if not options then
			return
		end

		if options.baroptions and options.baroptions.args then
			options.baroptions.args.barspacing = nil
			options.baroptions.args.barfont = nil
			options.baroptions.args.reversegrowth = nil
		end

		if options.titleoptions and options.titleoptions.args then
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
			options.titleoptions.args.font = nil
		end

		options.windowoptions = nil
	end

	-- Config hooks
	if barmod.AddDisplayOptions and not barmod.AddDisplayOptions_ then
		barmod.AddDisplayOptions_ = barmod.AddDisplayOptions

		barmod.AddDisplayOptions = function(self, win, options)
			self:AddDisplayOptions_(win, options)
			StripOptions(options)
		end
	end

	-- Existing options
	if Skada.options
		and Skada.options.args
		and Skada.options.args.windows
		and Skada.options.args.windows.args then

		for _, options in pairs(Skada.options.args.windows.args) do
			if options.type == "group" and options.args then
				StripOptions(options.args)
			end
		end
	end

	-- Apply settings
	if barmod.ApplySettings and not barmod.ApplySettings_ then
		barmod.ApplySettings_ = barmod.ApplySettings

		barmod.ApplySettings = function(self, win)
			barmod.ApplySettings_(self, win)

			if not win or not win.bargroup then
				return
			end

			local skada = win.bargroup

			-- Texture
			if skada.SetTexture then
				skada:SetTexture(C.Media.Texture)
			end

			-- Spacing
			if skada.SetSpacing then
				skada:SetSpacing(4)
			end

			-- Remove default backdrop
			if skada.SetBackdrop then
				skada:SetBackdrop(nil)
			end

			skada:SetFrameLevel(5)

			-- Title
			if win.db and win.db.enabletitle and skada.button then
				local titlefont = CreateFont("VermilionSkadaTitle"..(win.db.name or ""))

				titlefont:SetFont(
					C.Media.Font,
					C.Media.Font_Size - 1,
					C.Media.Font_Style
				)

				titlefont:SetShadowOffset(0, 0)

				skada.button:SetNormalFontObject(titlefont)
				skada.button:SetHeight(20)
				
				if not skada.button.backdrop then
					skada.button:CreateBackdrop()

					skada.button.backdrop:SetPoint(
						"TOPLEFT",
						skada.button,
						"TOPLEFT",
						0,
						2
					)

					skada.button.backdrop:SetPoint(
						"BOTTOMRIGHT",
						skada.button,
						"BOTTOMRIGHT",
						4,
						0
					)
				end

				if not skada.button.bg then
					skada.button.bg = skada.button:CreateTexture(nil, "BACKGROUND")

					skada.button.bg:SetTexture(C.Media.Blank)
					skada.button.bg:SetVertexColor(unpack(C.Media.Backdrop_Color))

					skada.button.bg:SetPoint("TOPLEFT", skada.button, 2000, 0)
					skada.button.bg:SetPoint("BOTTOMRIGHT", skada.button, 0, 0)
				end
			end
		end
	end

	-- Update bars
	hooksecurefunc(Skada, "UpdateDisplay", function(self)
		for _, win in ipairs(self:GetWindows()) do
			if win.bargroup then
				for _, v in pairs(win.bargroup:GetBars()) do
					if not v.BarStyled then
						-- Main backdrop
						if not v.backdrop then
							v:CreateBackdrop()
						end

						v:SetHeight(24)

						-- Label
						if v.label then
							v.label:ClearAllPoints()
							v.label.ClearAllPoints = V.Noop

							v.label:SetPoint("LEFT", v, "LEFT", 8, -4)
							v.label.SetPoint = V.Noop

							v.label:SetFont(
								C.Media.Font,
								C.Media.Font_Size,
								C.Media.Font_Style
							)

							v.label.SetFont = V.Noop
							v.label:SetShadowOffset(0, 0)
							v.label.SetShadowOffset = V.Noop
						end

						-- Timer
						if v.timerLabel then
							v.timerLabel:ClearAllPoints()
							v.timerLabel.ClearAllPoints = V.Noop

							v.timerLabel:SetPoint("RIGHT", v, "RIGHT", 0, -4)
							v.timerLabel.SetPoint = V.Noop

							v.timerLabel:SetFont(
								C.Media.Font,
								C.Media.Font_Size,
								C.Media.Font_Style
							)

							v.timerLabel.SetFont = V.Noop
							v.timerLabel:SetShadowOffset(0, 0)
							v.timerLabel.SetShadowOffset = V.Noop
						end

						v.BarStyled = true
					end

					-- Icon Border ONLY
if v.icon and v.icon:IsShown() then
		v.icon:ClearAllPoints()
		v.icon:SetPoint("LEFT", v.backdrop, "LEFT", -24, 0)

	

	local size = v:GetHeight() - 2
	v.icon:SetSize(size, size)
	if not v.iconBorder then
	
		v.iconBorder = CreateFrame("Frame", nil, v)

		v.iconBorder:SetFrameStrata(v:GetFrameStrata())
		v.iconBorder:SetFrameLevel(v:GetFrameLevel() + 1)

		if v.iconBorder.CreateBorder then
			v.iconBorder:CreateBorder()
		else
			V.CreateBorder(v.iconBorder)
		end
	end

	v.iconBorder:ClearAllPoints()
	v.iconBorder:SetPoint("TOPLEFT", v.icon, -1, 1)
	v.iconBorder:SetPoint("BOTTOMRIGHT", v.icon, 1, -1)
end

					-- Backdrop spacing
if v.backdrop then
	v.backdrop:ClearAllPoints()
	
	if v.icon and v.icon:IsShown() then
		-- DBM style icon gap
		v.backdrop:SetPoint("TOPLEFT", 4, -2)
		v.backdrop:SetPoint("BOTTOMRIGHT", 4, -6.7)
	else
		v.backdrop:SetPoint("TOPLEFT", -4, 4)
		v.backdrop:SetPoint("BOTTOMRIGHT", 4, -4)
	end
end
				end
			end
		end
	end)

	-- Update existing windows
	if Skada.GetWindows then
		for _, window in ipairs(Skada:GetWindows()) do
			if window.UpdateDisplay then
				window:UpdateDisplay()
			end
		end
	end
end)