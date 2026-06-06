-- ============================================================
-- Vermilion UI
-- Core/Events.lua
-- Central Event Dispatcher
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

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

    if not V.EventHandlers[event] then

        V.EventHandlers[event] = {}

        V.EventFrame:RegisterEvent(event)

    end

    table.insert(V.EventHandlers[event], func)

end

----------------------------------------------------------
-- Unregister API
----------------------------------------------------------

function V.UnregisterEvent(event)

    if V.EventHandlers[event] then

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

        local ok, err = pcall(handlers[i], ...)

        if not ok then

            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffff3333[Vermilion]|r "..tostring(err)
            )

        end

    end

end)