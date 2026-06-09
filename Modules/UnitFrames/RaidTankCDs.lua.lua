local V, C, L, _ = select(2, ...):unpack()

local TankCDs = {
	["Pain Suppression"] = true,
	["Guardian Spirit"] = true,
	["Hand of Sacrifice"] = true,
	["Divine Shield"] = true,
	["Divine Protection"] = true,
	["Survival Instincts"] = true,
	["Barkskin"] = true,
}

function UpdateRaidTankCD(frame)

	if not frame or not frame.unit then
		return
	end

	frame.TankCDIcon:Hide()
if not UnitExists(frame.unit) then
	return
end

if not UnitIsConnected(frame.unit) then
	return
end

if UnitIsDeadOrGhost(frame.unit) then
	return
end
	for i = 1, 40 do

		local name, _, icon =
			UnitBuff(frame.unit, i)

		if not name then
			break
		end
	
		if TankCDs[name] then

			frame.TankCDIcon:SetTexture(icon)
			frame.TankCDIcon:Show()

			return

		end
	end
end