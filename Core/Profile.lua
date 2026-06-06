-- Modules/Profiles/Profiles.lua
local V, C, L, _ = select(2, ...):unpack()

local ProfileSystem = {}
local PROFILE_VERSION = 1


-- ============================================================
-- ALLOWED GROUPS
-- ============================================================
local ALLOWED_GROUPS = {
    General = true,
    ActionBar = true,
    Announcements = true,
    Automation = true,
    Bag = true,
    Blizzard = true,
    Aura = true,
    Chat = true,
    Cooldown = true,
    Error = true,
    Filger = true,
    Loot = true,
    Minimap = true,
    Misc = true,
    Nameplate = true,
    PowerBar = true,
    PulseCD = true,
    Skins = true,
    Tooltip = true,
    Unitframe = true,
    Raid = true,
    Position = true,
}
-- ============================================================
-- DATABASE INITIALIZATION
-- ============================================================

VermilionDB = VermilionDB or {}
VermilionDB.Profiles = VermilionDB.Profiles or {}
VermilionDB.ActiveProfiles = VermilionDB.ActiveProfiles or {}
VermilionDB.CharacterData = VermilionDB.CharacterData or {}

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

function V.GetCharKey()
    return V.Realm .. "-" .. V.Name
end

function V.GetActiveProfile()
    local charKey = V.GetCharKey()

    if not VermilionDB.ActiveProfiles[charKey] then
        local profileName = V.Name

        if not VermilionDB.Profiles[profileName] then
            V.CreateProfile(profileName)
        end

        VermilionDB.ActiveProfiles[charKey] = profileName
    end

    return VermilionDB.ActiveProfiles[charKey]
end

function V.GetProfileDB()
    local profile = V.GetActiveProfile()
    if not VermilionDB.Profiles[profile] then
        VermilionDB.Profiles[profile] = {}
    end
    return VermilionDB.Profiles[profile]
end

-- ============================================================
-- DEEP COPY TABLE
-- ============================================================

local function CopyTable(source, deep)
    if type(source) ~= "table" then
        return source
    end
    
    local result = {}
    for k, v in pairs(source) do
        if deep and type(v) == "table" then
            result[k] = CopyTable(v, true)
        else
            result[k] = v
        end
    end
    return result
end

-- ============================================================
-- PROFILE OPERATIONS
-- ============================================================

function V.CreateProfile(profileName)
    if VermilionDB.Profiles[profileName] then
        V.Print("|cffff0000Profile already exists: " .. profileName .. "|r")
        return false
    end
    
    -- Create new profile with default settings
    VermilionDB.Profiles[profileName] = CopyTable(C, true)
    V.Print("|cff00ff00Profile created: " .. profileName .. "|r")
    return true
end

function V.DeleteProfile(profileName)
    if profileName == "Default" then
        V.Print("|cffff0000Cannot delete Default profile!|r")
        return false
    end
    
    if not VermilionDB.Profiles[profileName] then
        V.Print("|cffff0000Profile not found: " .. profileName .. "|r")
        return false
    end
    
    -- If it was active, switch to Default
    local charKey = V.GetCharKey()
    if VermilionDB.ActiveProfiles[charKey] == profileName then
        VermilionDB.ActiveProfiles[charKey] = "Default"
    end
    
    VermilionDB.Profiles[profileName] = nil
    V.Print("|cff00ff00Profile deleted: " .. profileName .. "|r")
    return true
end

function V.RenameProfile(oldName, newName)
    if not VermilionDB.Profiles[oldName] then
        V.Print("|cffff0000Profile not found: " .. oldName .. "|r")
        return false
    end
    
    if VermilionDB.Profiles[newName] then
        V.Print("|cffff0000Profile already exists: " .. newName .. "|r")
        return false
    end
    
    VermilionDB.Profiles[newName] = VermilionDB.Profiles[oldName]
    VermilionDB.Profiles[oldName] = nil
    
    -- Update active profile if needed
    local charKey = V.GetCharKey()
    if VermilionDB.ActiveProfiles[charKey] == oldName then
        VermilionDB.ActiveProfiles[charKey] = newName
    end
    
    V.Print("|cff00ff00Profile renamed: " .. oldName .. " -> " .. newName .. "|r")
    return true
end

function V.SetProfile(profileName)
    if not VermilionDB.Profiles[profileName] then
        V.Print("|cffff0000Profile not found: " .. profileName .. "|r")
        return false
    end
    
    local charKey = V.GetCharKey()
    VermilionDB.ActiveProfiles[charKey] = profileName
    
    -- Load profile into C
    V.LoadProfile(profileName)
    
    V.Print("|cff00ff00Profile loaded: " .. profileName .. "|r")
    return true
end

-- ============================================================
-- SAVE / LOAD PROFILE
-- ============================================================

function V.SaveProfile(profileName)
    profileName = profileName or V.GetActiveProfile()

    if not profileName then
        return false
    end

    local profile = {}

    for group, data in pairs(C) do
        if ALLOWED_GROUPS[group] and type(data) == "table" then
            profile[group] = CopyTable(data, true)
        end
    end

    VermilionDB.Profiles[profileName] = profile

    V.Print("|cff00ff00Profile saved: " .. profileName .. "|r")
    return true
end

function V.LoadProfile(profileName)
    profileName = profileName or V.GetActiveProfile()

    local profileData = VermilionDB.Profiles[profileName]
    if not profileData then
        return false
    end

    for group, settings in pairs(profileData) do
        if ALLOWED_GROUPS[group] and type(settings) == "table" then
            C[group] = C[group] or {}

            for option, value in pairs(settings) do
                if type(value) == "table" then
                    C[group][option] = CopyTable(value, true)
                else
                    C[group][option] = value
                end
            end
        end
    end

    V.Print("|cff00ff00Profile loaded: " .. profileName .. "|r")
    return true
end

-- ============================================================
-- IMPORT / EXPORT
-- ============================================================

local function SerializeValue(val)
    if type(val) == "string" then
        return "\"" .. val:gsub("\"", "\\\"") .. "\""
    elseif type(val) == "number" then
        return tostring(val)
    elseif type(val) == "boolean" then
        return val and "true" or "false"
    elseif type(val) == "table" then
        local str = "{"
        local first = true
        for k, v in pairs(val) do
            if not first then str = str .. "," end
            first = false
            str = str .. SerializeValue(k) .. "=" .. SerializeValue(v)
        end
        return str .. "}"
    end
    return "nil"
end

function V.ExportProfile(profileName)
    profileName = profileName or V.GetActiveProfile()
    
    if not VermilionDB.Profiles[profileName] then
        V.Print("|cffff0000Profile not found: " .. profileName .. "|r")
        return ""
    end
    
    local export = SerializeValue(VermilionDB.Profiles[profileName])
    return export
end

function V.ImportProfile(profileName, exportedData)
    if not exportedData or exportedData == "" then
        V.Print("|cffff0000Invalid export data!|r")
        return false
    end
    
    local success, result = pcall(function()
        return loadstring("return " .. exportedData)()
    end)
    
    if not success then
        V.Print("|cffff0000Failed to parse export data!|r")
        return false
    end
    
    VermilionDB.Profiles[profileName] = result
    V.Print("|cff00ff00Profile imported: " .. profileName .. "|r")
    return true
end

-- ============================================================
-- INITIALIZATION
-- ============================================================

local function InitializeProfiles()
    -- Create Default profile if it doesn't exist
    if not VermilionDB.Profiles["Default"] then
        VermilionDB.Profiles["Default"] = CopyTable(C, true)
    end
    
    -- Load active profile
    local activeProfile = V.GetActiveProfile()
    V.LoadProfile(activeProfile)
    
    print("|cff2eb6ffProfile System: Initialized|r")
end

-- Register initialization
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
    if addon == "Vermilion" then
        InitializeProfiles()
        self:UnregisterEvent(event)
    end
end)

V.ProfileSystem = ProfileSystem