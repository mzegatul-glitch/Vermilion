local V, C, L, _ = select(2, ...):unpack()

local tonumber = tonumber
local lower, match = string.lower, string.match
local print = print
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local CreateFrame = CreateFrame

--	Check outdated UI version
local Check = function(self, event, prefix, message, channel, sender)
	local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if event == "CHAT_MSG_ADDON" then
		if prefix ~= "VermilionVersion" or sender == V.Name then return end
		if tonumber(message) ~= nil and tonumber(message) > tonumber(V.Version) then
			print("|cffff0000"..L_MISC_UI_OUTDATED.."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		if numRaid > 0 then
			SendAddonMessage("VermilionVersion", tonumber(V.Version), "RAID")
		elseif numParty > 0 then
			SendAddonMessage("VermilionVersion", tonumber(V.Version), "PARTY")
		elseif IsInGuild() then
			SendAddonMessage("VermilionVersion", tonumber(V.Version), "GUILD")
		end
	end
	-- Remind people to delete old Vermilion_Filger
	if event == "PLAYER_ENTERING_WORLD" and (select(4, GetAddOnInfo("Vermilion_Filger"))) then
		V.Print("|cffff3300".."Please, delete Vermilion_Filger, it is now built-in.".."|r")
		DisableAddOn("Vermilion_Filger") -- Just incase they ignore the message.
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", Check)

-- Whisper UI version
local Whisper = CreateFrame("Frame")
Whisper:RegisterEvent("CHAT_MSG_WHISPER")
Whisper:SetScript("OnEvent", function(self, event, text, name, ...)
	if text:lower():match("ui_version") then
		if event == "CHAT_MSG_WHISPER" then
			V.Delay(2, SendChatMessage, "Vermilion "..V.Version, "WHISPER", nil, name)
		end
	end
end)