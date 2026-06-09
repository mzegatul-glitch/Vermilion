local V, C, L, P = select(2,...):unpack()

-- ============================================================
-- ADDON_LOADED (Event.lua-аас)
-- ============================================================
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

-- ============================================================
-- PLAYER_LOGIN (Event.lua-аас)
-- ============================================================
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
end

-- ============================================================
-- PLAYER_ENTERING_WORLD (Event.lua-аас)
-- ============================================================
local function OnEnteringWorld()
    -- Future use
end

-- ============================================================
-- CreateDefaults
-- ============================================================
local function CreateDefaults()
    V.Defaults = {}

    for group, options in pairs(C) do
        if (not V.Defaults[group]) then
            V.Defaults[group] = {}
        end

        for option, value in pairs(options) do
            V.Defaults[group][option] = value

            if (type(C[group][option]) == "table") then
                if C[group][option].Options then
                    V.Defaults[group][option] = value.Value
                else
                    V.Defaults[group][option] = value
                end
            else
                V.Defaults[group][option] = value
            end
        end
    end
end

-- ============================================================
-- LoadCustomSettings (KkthnxUI-гийн дэвшилтэт хувилбар)
-- ============================================================
local function LoadCustomSettings()
    if not VermilionDB or not VermilionDB.Settings then
        return
    end
    
    local Settings = VermilionDB.Settings[V.Realm]
    if not Settings then
        return
    end
    
    Settings = Settings[V.Name]
    if not Settings then
        return
    end

    for group, options in pairs(Settings) do
        if C[group] then
            local Count = 0

            for option, value in pairs(options) do
                if C[group][option] ~= nil then
                    if C[group][option] == value then
                        Settings[group][option] = nil
                    else
                        Count = Count + 1

                        if type(C[group][option]) == "table" then
                            if C[group][option].Options then
                                C[group][option].Value = value
                            else
                                C[group][option] = value
                            end
                        else
                            C[group][option] = value
                        end
                    end
                end
            end

            if Count == 0 then
                Settings[group] = nil
            end
        else
            Settings[group] = nil
        end
    end
    
    if V.Print then
        V.Print("Custom settings loaded.")
    end
end

-- ============================================================
-- MergeDatabase
-- ============================================================
local function MergeDatabase()
    if VermilionData then
        VermilionDB["Variables"] = VermilionData
        VermilionData = nil
    end

    if VermilionSettingsPerCharacter then
        VermilionDB["Settings"] = VermilionSettingsPerCharacter
        VermilionSettingsPerCharacter = nil
    end

    if VermilionUIGold then
        VermilionDB["Gold"] = VermilionUIGold
        VermilionUIGold = nil
    end

    if VermilionUIChatHistory then
        VermilionDB["ChatHistory"] = VermilionUIChatHistory
        VermilionUIChatHistory = nil
    end
end

-- ============================================================
-- VerifyDatabase
-- ============================================================
local function VerifyDatabase()
    if not VermilionDB then
        VermilionDB = {}
    end

    -- VARIABLES
    if not VermilionDB.Variables then
        VermilionDB.Variables = {}
    end

    if not VermilionDB.Variables[V.Realm] then
        VermilionDB.Variables[V.Realm] = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name] then
        VermilionDB.Variables[V.Realm][V.Name] = {}
    end
    
    -- Transfer favourite items
    if VermilionDB and VermilionDB.Variables and VermilionDB.Variables[V.Realm][V.Name].FavouriteItems and next(VermilionDB.Variables[V.Realm][V.Name].FavouriteItems) then
        for itemID in pairs(VermilionDB.Variables[V.Realm][V.Name].FavouriteItems) do
            if not VermilionDB.Variables[V.Realm][V.Name].CustomItems then
                VermilionDB.Variables[V.Realm][V.Name].CustomItems = {}
            end
            VermilionDB.Variables[V.Realm][V.Name].CustomItems[itemID] = 1
        end
        VermilionDB.Variables[V.Realm][V.Name].FavouriteItems = nil
    end

    if not VermilionDB.Variables[V.Realm][V.Name].CustomItems then
        VermilionDB.Variables[V.Realm][V.Name].CustomItems = {}
    end 
    
    if not VermilionDB.Variables[V.Realm][V.Name].CustomNames then
        VermilionDB.Variables[V.Realm][V.Name].CustomNames = {}
    end
    
    if VermilionDB.Variables[V.Realm][V.Name].AutoQuest == nil then
        VermilionDB.Variables[V.Realm][V.Name].AutoQuest = false
    end
    
    if not VermilionDB.CustomJunkList then
        VermilionDB.CustomJunkList = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].BindType then
        VermilionDB.Variables[V.Realm][V.Name].BindType = 1
    end

    if not VermilionDB.Variables[V.Realm][V.Name].ChangeLog then
        VermilionDB.Variables[V.Realm][V.Name].ChangeLog = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].CustomJunkList then
        VermilionDB.Variables[V.Realm][V.Name].CustomJunkList = {}
    end

    if VermilionDB.Variables[V.Realm][V.Name].DetectVersion == nil then
        VermilionDB.Variables[V.Realm][V.Name].DetectVersion = V.Version
    end

    if not VermilionDB.Variables[V.Realm][V.Name].FavouriteItems then
        VermilionDB.Variables[V.Realm][V.Name].FavouriteItems = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].Mover then
        VermilionDB.Variables[V.Realm][V.Name].Mover = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].AuraWatchMover then
        VermilionDB.Variables[V.Realm][V.Name].AuraWatchMover = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].Tracking then
        VermilionDB.Variables[V.Realm][V.Name].Tracking = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].Tracking.PvP then
        VermilionDB.Variables[V.Realm][V.Name].Tracking.PvP = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].Tracking.PvE then
        VermilionDB.Variables[V.Realm][V.Name].Tracking.PvE = {}
    end

    if VermilionDB.Variables[V.Realm][V.Name].RevealWorldMap == nil then
        VermilionDB.Variables[V.Realm][V.Name].RevealWorldMap = false
    end

    if not VermilionDB.Variables[V.Realm][V.Name].SplitCount then
        VermilionDB.Variables[V.Realm][V.Name].SplitCount = 1
    end

    if not VermilionDB.Variables[V.Realm][V.Name].ContactList then
        VermilionDB.Variables[V.Realm][V.Name].ContactList = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].TempAnchor then
        VermilionDB.Variables[V.Realm][V.Name].TempAnchor = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].InternalCD then
        VermilionDB.Variables[V.Realm][V.Name].InternalCD = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].AuraWatchList then
        VermilionDB.Variables[V.Realm][V.Name].AuraWatchList = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].CCWhiteList then
        VermilionDB.Variables[V.Realm][V.Name].CCWhiteList = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].AuraWatchList.Switcher then
        VermilionDB.Variables[V.Realm][V.Name].AuraWatchList.Switcher = {}
    end

    if not VermilionDB.Variables[V.Realm][V.Name].AuraWatchList.IgnoreSpells then
        VermilionDB.Variables[V.Realm][V.Name].AuraWatchList.IgnoreSpells = {}
    end

    -- Settings
    if (not VermilionDB.Settings) then
        VermilionDB.Settings = {}
    end

    if not VermilionDB.Settings[V.Realm] then
        VermilionDB.Settings[V.Realm] = {}
    end

    if not VermilionDB.Settings[V.Realm][V.Name] then
        VermilionDB.Settings[V.Realm][V.Name] = {}
    end

    -- Chat History
    if not VermilionDB.ChatHistory then
        VermilionDB.ChatHistory = {}
    end

    -- Gold
    if not VermilionDB.Gold then
        VermilionDB.Gold = {}
    end

    if VermilionDB.ShowSlots == nil then
        VermilionDB.ShowSlots = false
    end

    if not VermilionDB.ChangeLog then
        VermilionDB.ChangeLog = {}
    end
end

-- ============================================================
-- LoadProfiles (KkthnxUI-гийн хувилбар)
-- ============================================================
local function LoadProfiles()
    if not C.General or not C.General.Profiles then
        return
    end

    local Profiles = C.General.Profiles

    if not Profiles.Options then
        Profiles.Options = {}
    end

    local Menu = Profiles.Options
    local GUISettings = VermilionDB.Settings

    if not GUISettings then
        return
    end

    wipe(Menu)
    
    local MyProfileName = V.Realm .. "-" .. V.Name

    for Index, Table in pairs(GUISettings) do
        for Nickname, Settings in pairs(Table) do
            local ProfileName = Index .. "-" .. Nickname
            
            if MyProfileName ~= ProfileName then
                Menu[ProfileName] = ProfileName
            end
        end
    end
    
    Profiles.Value = ""
end

V.LoadProfiles = LoadProfiles

-- ============================================================
-- Event Frames
-- ============================================================

-- ADDON_LOADED
local addonLoader = CreateFrame("Frame")
addonLoader:RegisterEvent("ADDON_LOADED")
addonLoader:SetScript("OnEvent", function(self, _, addon)
    if addon ~= "Vermilion" then
        return
    end

    -- Event.lua-аас
    OnAddonLoaded(addon)
    
    VerifyDatabase()
    MergeDatabase()
    CreateDefaults()
    LoadCustomSettings()
    LoadProfiles()

    if V.GUI and V.GUI.Toggle and not V.GUI:IsShown() then 
        V.GUI:Toggle() 
    end
    V.Profiles:Enable()
    self:UnregisterAllEvents()
end)

-- PLAYER_LOGIN
local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function(self, event)
    OnPlayerLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
end)

-- PLAYER_ENTERING_WORLD
local worldFrame = CreateFrame("Frame")
worldFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
worldFrame:SetScript("OnEvent", function(self, event)
    OnEnteringWorld()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)
