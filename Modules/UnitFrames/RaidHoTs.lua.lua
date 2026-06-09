local V, C, L, _ = select(2, ...):unpack()
local HoTs = {
	["Renew"] = true,
	["Power Word: Shield"] = true,
	["Prayer of Mending"] = true,
	["Rejuvenation"] = true,
	["Wild Growth"] = true,
	["Riptide"] = true,
	["Earth Shield"] = true,
}

function UpdateRaidHoTs(frame)

	if not frame or not frame.unit then
		return
	end

	frame.HotIcon:Hide()
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

		if HoTs[name] then

			frame.HotIcon:SetTexture(icon)
			frame.HotIcon:Show()

			return

		end
	end
end