-- ============================================================
-- Vermilion
-- Style/EditBox.lua
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local CreateFrame = CreateFrame

function V.StyleEditBox(editbox, width, height)
	if not editbox or editbox.VermilionStyled then return end

	if width and height then
		editbox:SetSize(width, height)
	end

	editbox:SetAutoFocus(false)
	editbox:SetMultiLine(false)
	editbox:SetFont(V.GetStyleFont(), 12, V.GetStyleFontFlag())
	editbox:SetTextInsets(4, 4, 0, 0)

	V.SetBackdrop(editbox)

	editbox:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(V.GetClassColor())
	end)

	editbox:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(V.GetBorderColor())
	end)

	editbox.VermilionStyled = true
end

function V.CreateEditBox(parent, width, height)
	local edit = CreateFrame("EditBox", nil, parent)
	edit:SetSize(width or 120, height or 22)

	V.StyleEditBox(edit)

	return edit
end
