local V, C, L, _ = select(2, ...):unpack()
if C.ActionBar.Enable ~= true then return end

local _G = _G
local CreateFrame = CreateFrame

--	Setup MultiBarLeft as bar #3 by Tukz
local bar = CreateFrame("Frame", "Bar3Holder", RightActionBarAnchor)
bar:SetAllPoints(RightActionBarAnchor)
MultiBarLeft:SetParent(bar)
MultiBarLeft:SetScale(1.1); 

for i = 1, 12 do
	local b = _G["MultiBarLeftButton"..i]
	local b2 = _G["MultiBarLeftButton"..i-1]
	b:ClearAllPoints()
	if i == 1 then
		if C.ActionBar.RightBars == 3 then
			b:SetPoint("TOP", RightActionBarAnchor, "TOP", 0, 0)
		else
			b:SetPoint("BOTTOMLEFT", RightActionBarAnchor, "BOTTOMLEFT", 0, 36)
		end
	else
		b:SetPoint("Left", b2, "Right", 5, 0)
	end
end

-- Hide bar
if C.ActionBar.RightBars < 2 then
	bar:Hide()
end