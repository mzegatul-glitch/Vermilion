local V, C, L, _ = select(2, ...):unpack()
if C.ActionBar.Enable ~= true or V.Class ~= "SHAMAN" then return end

-- We just use default totem bar for shaman
-- We parent it to our shapeshift bar.

if V.Class == "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(ShiftHolder)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("Center", ShiftHolder, 0, 0)
 
		hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
 
		MultiCastActionBarFrame.SetParent = V.Noop
		MultiCastActionBarFrame.SetPoint = V.Noop
		MultiCastRecallSpellButton.SetPoint = V.Noop
	end
end