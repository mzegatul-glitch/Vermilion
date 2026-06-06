-- ============================================================
-- Vermilion UI
-- Core/Events.lua
-- Central Event Dispatcher
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

----------------------------------------------------------
-- Local Cache
----------------------------------------------------------

local CreateFrame = CreateFrame
local pcall = pcall
local tostring = tostring
local tinsert = table.insert
local tremove = table.remove

----------------------------------------------------------
-- Event Frame
----------------------------------------------------------

V.EventFrame = CreateFrame("Frame")

----------------------------------------------------------
-- Registered Callbacks
----------------------------------------------------------

V.EventHandlers = {}

----------------------------------------------------------
-- Register API
----------------------------------------------------------

function V.RegisterEvent(event, func)

	if not event or not func then
		return
	end

	local handlers = V.EventHandlers[event]

	if not handlers then
		handlers = {}
		V.EventHandlers[event] = handlers
		V.EventFrame:RegisterEvent(event)
	end

	for i = 1, #handlers do
		if handlers[i] == func then
			return
		end
	end

	tinsert(handlers, func)
end

----------------------------------------------------------
-- Unregister API
----------------------------------------------------------

function V.UnregisterEvent(event, func)

	local handlers = V.EventHandlers[event]
	if not handlers then
		return
	end

	if not func then
		V.EventHandlers[event] = nil
		V.EventFrame:UnregisterEvent(event)
		return
	end

	for i = #handlers, 1, -1 do
		if handlers[i] == func then
			tremove(handlers, i)
		end
	end

	if #handlers == 0 then
		V.EventHandlers[event] = nil
		V.EventFrame:UnregisterEvent(event)
	end
end

----------------------------------------------------------
-- Dispatcher
----------------------------------------------------------

V.EventFrame:SetScript("OnEvent", function(self, event, ...)

	local handlers = V.EventHandlers[event]

	if not handlers then
		return
	end

	for i = 1, #handlers do

		local handler = handlers[i]

		if handler then
			local ok, err = pcall(handler, ...)

			if not ok then
				if V.Print then
					V.Print("|cffff3333Error:|r " .. tostring(err))
				else
					DEFAULT_CHAT_FRAME:AddMessage("|cffff3333[Vermilion]|r " .. tostring(err))
				end
			end
		end

	end

end)

----------------------------------------------------------
-- API
----------------------------------------------------------

V.Events = {}

V.Events.Frame = V.EventFrame
V.Events.Register = V.RegisterEvent
V.Events.Unregister = V.UnregisterEvent
V.Events.Handlers = V.EventHandlers
