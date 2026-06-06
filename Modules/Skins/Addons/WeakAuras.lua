local V, C, L, _ = select(2, ...):unpack()
if C.Skins.WeakAuras ~= true then
	return
end

local pairs = pairs
local select = select
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- WeakAuras skin
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event)
	if not IsAddOnLoaded("WeakAuras") then
		return
	end

	if not WeakAuras then
		return
	end

	-- Different WeakAuras versions use different tables
	local regions = WeakAuras.regions or WeakAuras.regionsTable or WeakAuras.regionTypes

	if not regions or type(regions) ~= "table" then
		return
	end

	local function Skin_WeakAuras(region)
		if not region then
			return
		end

		-- Border
		if not region.border then
			V.CreateBorder(region, 10, 2.5)
		end

		-- Icon
		if region.icon then
			region.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			region.icon.SetTexCoord = V.Noop
		end

		-- Statusbar
		if region.bar then
			if region.bar.fg then
				region.bar.fg:SetTexture(C.Media.Texture)
			end

			if region.bar.bg then
				region.bar.bg:SetTexture(C.Media.Texture)
			end
		end

		-- Stacks
		if region.stacks and region.stacks.GetFont then
			local _, size = region.stacks:GetFont()

			region.stacks:SetFont(
				C.Media.Font,
				size or C.Media.Font_Size,
				C.Media.Font_Style
			)
		end

		-- Timer
		if region.timer and region.timer.GetFont then
			local _, size = region.timer:GetFont()

			region.timer:SetFont(
				C.Media.Font,
				size or C.Media.Font_Size,
				C.Media.Font_Style
			)
		end

		-- Text
		if region.text and region.text.GetFont then
			local _, size = region.text:GetFont()

			region.text:SetFont(
				C.Media.Font,
				size or C.Media.Font_Size,
				C.Media.Font_Style
			)
		end
	end

	-- Modern / Legacy WeakAuras support
	for id, data in pairs(regions) do
		if data then
			local regionType = data.regionType
			local region = data.region or data

			-- Some WA versions store type differently
			if not regionType and region.regionType then
				regionType = region.regionType
			end

			if regionType == "icon" or regionType == "aurabar" then
				Skin_WeakAuras(region)
			end
		end
	end
end)