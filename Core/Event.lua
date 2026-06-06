-- ============================================================
-- FrostUI / Vermilion
-- Core/Events.lua
-- Central Event Manager
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

local EventFrame = CreateFrame("Frame")

----------------------------------------------------------
-- Register Events
----------------------------------------------------------

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

----------------------------------------------------------
-- ADDON_LOADED
----------------------------------------------------------

local function OnAddonLoaded(addon)

    if addon ~= "Vermilion" then
        return
    end

    -- Initialize SavedVariables
    VermilionDB = VermilionDB or {}
    VermilionDB.Profiles = VermilionDB.Profiles or {}
    VermilionDB.ActiveProfiles = VermilionDB.ActiveProfiles or {}
    VermilionDB.CharacterData = VermilionDB.CharacterData or {}

    if V.Print then
        V.Print("Database initialized.")
    end
end

----------------------------------------------------------
-- PLAYER_LOGIN
----------------------------------------------------------

local function OnPlayerLogin()

    -- Load active profile
    if V.GetActiveProfile and V.LoadProfile then

        local profile = V.GetActiveProfile()

        if profile then
            V.LoadProfile(profile)

            if V.Print then
                V.Print("Loaded profile: "..profile)
            end
        end
    end

    ------------------------------------------------------
    -- Future
    ------------------------------------------------------

    -- Install Wizard
    -- if V.RunInstaller then
    --     V.RunInstaller()
    -- end

    -- Version Check
    -- if V.CheckVersion then
    --     V.CheckVersion()
    -- end

    -- Movers Restore
    -- if V.RestoreMovers then
    --     V.RestoreMovers()
    -- end

    -- Refresh UI
    -- if V.RefreshGUI then
    --     V.RefreshGUI()
    -- end
end

----------------------------------------------------------
-- PLAYER_ENTERING_WORLD
----------------------------------------------------------

local function OnEnteringWorld()

    -- Future use

    -- Force refresh
    -- if V.RefreshModules then
    --     V.RefreshModules()
    -- end

end

----------------------------------------------------------
-- Event Dispatcher
----------------------------------------------------------

EventFrame:SetScript("OnEvent", function(self, event, ...)

    if event == "ADDON_LOADED" then

        OnAddonLoaded(...)

    elseif event == "PLAYER_LOGIN" then

        OnPlayerLogin()

    elseif event == "PLAYER_ENTERING_WORLD" then

        OnEnteringWorld()

    end

end)

----------------------------------------------------------
-- API
----------------------------------------------------------

V.Events = EventFrame