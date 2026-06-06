local V, C, L, _ = select(2, ...):unpack()
if C.Minimap.Enable ~= true or C.Minimap.CollectButtons ~= true then return end

local unpack = unpack
local ipairs = ipairs
local ceil = math.ceil
local CreateFrame, UIParent = CreateFrame, UIParent

-- Collect minimap buttons in one line
local BlackList = {
	["Minimap"] = true,
	["MiniMapPing"] = true,
	["MinimapToggleButton"] = true,
	["MinimapZoneTextButton"] = true,
	["MiniMapRecordingButton"] = true,
	["MiniMapTracking"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapLFGFrame"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MiniMapMailFrame"] = true,
	["BattlefieldMinimap"] = true,
	["MinimapBackdrop"] = true,
	["GameTimeFrame"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
	["HelpOpenTicketButton"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["QueueStatusMinimapButton"] = true,
	["ButtonCollectFrame"] = true,
	["HandyNotesPin"] = true,
}

local buttons = {}
local button = CreateFrame("Frame", "ButtonCollectFrame", UIParent)
local line = ceil(C.Minimap.Size / 26)

local function PositionAndStyle()
	button:SetSize(26, 26)
	button:SetPoint(unpack(C.Position.MinimapButtons))
	for i = 1, #buttons do
		buttons[i]:ClearAllPoints()
		if i == 1 then
			buttons[i]:SetPoint("BOTTOM", button, "BOTTOM", 27, -190)
		elseif i == line then
			buttons[i]:SetPoint("BOTTOMRIGHT", buttons[1], "BOTTOMLEFT", 24, -32)
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT", 7, 0)
		end

	end
end

local collect = CreateFrame("Frame")
collect:RegisterEvent("PLAYER_ENTERING_WORLD")
collect:SetScript("OnEvent", function(self)
	for i, child in ipairs({Minimap:GetChildren()}) do
		if not BlackList[child:GetName()] then
			if child:GetObjectType() == "Button" and child:GetNumRegions() >= 3 and child:IsShown() then
				child:SetParent(button)
				tinsert(buttons, child)
			end
		end
	end
	if #buttons == 0 then
		button:Hide()
	end
	PositionAndStyle()
end)