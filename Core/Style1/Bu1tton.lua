-- ============================================================
-- Vermilion
-- Style/Button.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame
local ipairs = ipairs

local function StripButtonTextures(button)
	if not button then return end

	if button.SetNormalTexture then button:SetNormalTexture("") end
	if button.SetPushedTexture then button:SetPushedTexture("") end
	if button.SetHighlightTexture then button:SetHighlightTexture("") end
	if button.SetDisabledTexture then button:SetDisabledTexture("") end

	local regions = { button:GetRegions() }
	for _, region in ipairs(regions) do
		if region and region.GetObjectType and region:GetObjectType() == "Texture" then
			local name = region:GetName()
			if name and (
				name:find("Left") or name:find("Middle") or name:find("Right") or
				name:find("Normal") or name:find("Pushed") or name:find("Highlight")
			) then
				region:SetTexture(nil)
				region:Hide()
			end
		end
	end
end

function V.StyleButton(button, width, height)
	if not button or button.VermilionStyled then return end

	if width and height then
		button:SetSize(width, height)
	end

	StripButtonTextures(button)
	V.SetBackdrop(button)

	local hl = button:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints(button)
	hl:SetTexture(V.GetStyleTexture())
	hl:SetBlendMode("ADD")
	hl:SetAlpha(0.18)

	button:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(V.GetClassColor())
	end)

	button:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(V.GetBorderColor())
	end)

	button.VermilionStyled = true
end

function V.StyleConfigButton(button, width, height)
	if not button then return end

	V.StyleButton(button, width, height)

	if button.Text then
		V.SetFont(button.Text, 12)
	end
end

function V.CreateButton(parent, text, width, height, fontSize)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(width or 100, height or 22)

	button.Text = V.CreateFontString(button, fontSize or 12, text or "")
	button.Text:SetPoint("CENTER")
	button:SetFontString(button.Text)

	V.StyleButton(button)

	return button
end

function V.CreateCloseButton(parent, width, height, fontSize)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(width or 24, height or 24)

	button.Text = V.CreateFontString(button, fontSize or 18, "×", "OUTLINE")
	button.Text:SetPoint("CENTER", 0, 1)

	V.StyleButton(button)

	return button
end
