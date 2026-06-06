-- ============================================================
-- Vermilion UI
-- Profile.lua
-- Profile API
-- ============================================================

local V, C, L, _ = select(2, ...):unpack()

----------------------------------------------------------
-- Helpers
----------------------------------------------------------

function V.GetCharKey()
    return V.Realm .. "-" .. V.Name
end

----------------------------------------------------------
-- Active Profile
----------------------------------------------------------

function V.GetActiveProfile()

    local charKey = V.GetCharKey()

    if not V.DB.ActiveProfiles[charKey] then

        local profileName = V.Name

        if not V.DB.Profiles[profileName] then
            V.CreateProfile(profileName)
        end

        V.DB.ActiveProfiles[charKey] = profileName
    end

    return V.DB.ActiveProfiles[charKey]
end

----------------------------------------------------------
-- Profile Database
----------------------------------------------------------

function V.GetProfileDB()

    local profile = V.GetActiveProfile()

    V.DB.Profiles[profile] = V.DB.Profiles[profile] or {}

    return V.DB.Profiles[profile]

end

----------------------------------------------------------
-- Create
----------------------------------------------------------

function V.CreateProfile(profileName)

    if V.DB.Profiles[profileName] then
        return false
    end

    V.DB.Profiles[profileName] = CopyTable(C, true)

    return true

end

----------------------------------------------------------
-- Delete
----------------------------------------------------------

function V.DeleteProfile(profileName)

    if profileName == "Default" then
        return false
    end

    V.DB.Profiles[profileName] = nil

    return true

end

----------------------------------------------------------
-- Rename
----------------------------------------------------------

function V.RenameProfile(oldName, newName)

    if not V.DB.Profiles[oldName] then
        return false
    end

    if V.DB.Profiles[newName] then
        return false
    end

    V.DB.Profiles[newName] = V.DB.Profiles[oldName]
    V.DB.Profiles[oldName] = nil

    for charKey, profile in pairs(V.DB.ActiveProfiles) do

        if profile == oldName then
            V.DB.ActiveProfiles[charKey] = newName
        end

    end

    return true

end

----------------------------------------------------------
-- Set Active
----------------------------------------------------------

function V.SetProfile(profileName)

    if not V.DB.Profiles[profileName] then
        return false
    end

    V.DB.ActiveProfiles[V.GetCharKey()] = profileName

    V.LoadProfile(profileName)

    return true

end

----------------------------------------------------------
-- Save
----------------------------------------------------------

function V.SaveProfile(profileName)

    profileName = profileName or V.GetActiveProfile()

    local profile = {}

    for group, data in pairs(C) do

        if PROFILE_SAVE_GROUPS[group] then

            profile[group] = CopyTable(data, true)

        end

    end

    V.DB.Profiles[profileName] = profile

    return true

end

----------------------------------------------------------
-- Load
----------------------------------------------------------

function V.LoadProfile(profileName)

    profileName = profileName or V.GetActiveProfile()

    local profile = V.DB.Profiles[profileName]

    if not profile then
        return false
    end

    for group, data in pairs(profile) do

        C[group] = C[group] or {}

        for option, value in pairs(data) do

            C[group][option] = CopyTable(value, true)

        end

    end

    return true

end

local function OnAddonLoaded(addon)

    if addon ~= "VermilionUI" then
        return
    end

    V.GetActiveProfile()
    V.LoadProfile()

end

V.RegisterEvent("ADDON_LOADED", OnAddonLoaded)