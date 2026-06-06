local V, C, _ = select(2, ...):unpack()
if (select(4, GetAddOnInfo("MikScrollingBattleText"))) or (select(4, GetAddOnInfo("Parrot"))) or (select(4, GetAddOnInfo("xCT"))) or (select(4, GetAddOnInfo("sct"))) then return end

SystemFont_Shadow_Huge3:SetFont(C.Media.Combat_Font, C.Media.Combat_Font_Size, C.Media.Combat_Font_Style)
SystemFont_Shadow_Huge3:SetShadowColor(0, 0, 0, 0.6)

COMBAT_TEXT_HEIGHT = C.Media.Combat_Font_Size
COMBAT_TEXT_CRIT_MAXHEIGHT = 30
COMBAT_TEXT_CRIT_MINHEIGHT = 30
COMBAT_TEXT_SCROLLSPEED = 3.6
COMBAT_TEXT_FADEOUT_TIME = 2.6

hooksecurefunc("CombatText_UpdateDisplayedMessages", function()
  if COMBAT_TEXT_FLOAT_MODE == "1" then
	COMBAT_TEXT_LOCATIONS.startX = 0
    COMBAT_TEXT_LOCATIONS.startY = 450 * COMBAT_TEXT_Y_SCALE
    COMBAT_TEXT_LOCATIONS.endY = 400 * COMBAT_TEXT_Y_SCALE
	COMBAT_TEXT_LOCATIONS.endX = 0
  end
end)