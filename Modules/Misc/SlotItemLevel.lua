local V, C, L, _ = select(2, ...):unpack()

V.Modules = V.Modules or {}

V.Modules["SlotItemLevel"] = {
    Enable = function()
        -- frame/text үүсгэх
    end,

    Disable = function()
        -- hide хийх
    end,

    Refresh = function()
        if C.Misc.ItemLevel then
            V.Modules["SlotItemLevel"].Enable()
        else
            V.Modules["SlotItemLevel"].Disable()
        end
    end,
}
-- ============================================================
-- Character & Inspect panel item level
-- ============================================================
local OnEvent = CreateFrame("Frame", nil, UIParent)
local OnLoad = CreateFrame("Frame", nil, UIParent)
print("ItemLevel =", VermilionDB.Settings[V.Realm][V.Name].Misc.ItemLevel)

local slots = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
    "WristSlot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot", "HandsSlot", "WaistSlot",
    "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
}

local function CreateButtonsText(frame)
    for _, slot in pairs(slots) do
        local button = _G[frame..slot]

        if button and not button.t then
            local font, _, flags = NumberFontNormal:GetFont()

            button.t = button:CreateFontString(nil, "OVERLAY")
            button.t:SetFont(font, 12, flags)
            if button:GetPoint() then
                button.t:ClearAllPoints()
            end

            if slot == "HeadSlot"
            or slot == "NeckSlot"
            or slot == "ShoulderSlot"
            or slot == "BackSlot"
            or slot == "ChestSlot"
            or slot == "ShirtSlot"
            or slot == "TabardSlot"
            or slot == "WristSlot"
            then
                -- RIGHT SIDE
                button.t:SetPoint("BOTTOM", button, "BOTTOM", 40, 3)
            else
                -- LEFT SIDE
                if slot == "MainHandSlot" or slot == "SecondaryHandSlot" or slot == "RangedSlot" then
                    button.t:SetPoint("TOP", button, "TOP", 0, 20)
                else
                    button.t:SetPoint("BOTTOM", button, "BOTTOM", -40, 3)
                end
            end
            button.t:SetJustifyH("CENTER")
            button.t:SetText("")
        end
    end
end

local function GetItemLevel(unit, slot)
    local id = GetInventorySlotInfo(slot)
    local itemLink = GetInventoryItemLink(unit, id)

    if not itemLink then
        return nil
    end

    local itemLevel = GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(itemLink)

    if not itemLevel then
        itemLevel = select(4, GetItemInfo(itemLink))
    end

    return itemLevel
end

local function UpdateButtonsText(frame)
    if frame == "Inspect" and (not InspectFrame or not InspectFrame:IsShown()) then
        return
    end

    local unit = (frame == "Inspect") and "target" or "player"

    for _, slot in pairs(slots) do
        local button = _G[frame..slot]

        if button and button.t then
            if slot == "ShirtSlot" or slot == "TabardSlot" then
                button.t:SetText("")
            else
                local ilevel = GetItemLevel(unit, slot)

                if ilevel then
                    local color

                    if ilevel >= 284 then
                        color = "|cFFFF8000"
                    elseif ilevel >= 264 then
                        color = "|cFFA335EE"
                    elseif ilevel >= 232 then
                        color = "|cFFA335EE"
                    elseif ilevel >= 200 then
                        color = "|cFF0070DD"
                    else
                        color = "|cFF1EFF00"
                    end

                    button.t:SetText(color .. ilevel)
                else
                    button.t:SetText("")
                end
            end
        end
    end
end

OnEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
OnEvent:RegisterEvent("PLAYER_LOGIN")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:RegisterEvent("PLAYER_TARGET_CHANGED")
OnEvent:RegisterEvent("INSPECT_READY")

OnEvent:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        CreateButtonsText("Character")
        UpdateButtonsText("Character")

    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        UpdateButtonsText("Character")
    elseif event == "PLAYER_ENTERING_WORLD" then
        CreateButtonsText("Character")
        UpdateButtonsText("Character")

    elseif event == "PLAYER_TARGET_CHANGED" then
        if InspectFrame and InspectFrame:IsShown() then
            NotifyInspect("target")
        end

    elseif event == "INSPECT_READY" then
        UpdateButtonsText("Inspect")
    end
end)

OnLoad:RegisterEvent("ADDON_LOADED")
OnLoad:SetScript("OnEvent", function(self, event, addon)
    if addon == "Blizzard_InspectUI" then
        CreateButtonsText("Inspect")

        InspectFrame:HookScript("OnShow", function()
            if UnitExists("target") then
                NotifyInspect("target")
            end
        end)

        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- ============================================================
-- Bag item level (Stuffing bag)
-- ============================================================
local function CreateItemLevel(button)
    if button.iLevel then return end

    local font, _, flags = NumberFontNormal:GetFont()

    button.iLevel = button:CreateFontString(nil, "OVERLAY")
    button.iLevel:SetFont(font, 11, flags)
    button.iLevel:SetPoint("BOTTOMRIGHT", button, -1, 2)
    button.iLevel:SetJustifyH("RIGHT")
    button.iLevel:SetDrawLayer("OVERLAY", 7)
end

local function UpdateItemLevel(button, bag, slot)
    if not button then return end

    local link = GetContainerItemLink(bag, slot)

    if not link then
        if button.iLevel then
            button.iLevel:SetText("")
        end
        return
    end

    local _, _, quality, itemLevel, reqLevel, class, subclass, maxStack, equipSlot = GetItemInfo(link)

    if equipSlot and equipSlot ~= "" and itemLevel and itemLevel > 1 then
        local color

        if itemLevel >= 284 then
            color = "|cFFFF8000"
        elseif itemLevel >= 264 then
            color = "|cFFA335EE"
        elseif itemLevel >= 232 then
            color = "|cFFA335EE"
        elseif itemLevel >= 200 then
            color = "|cFF0070DD"
        else
            color = "|cFF1EFF00"
        end

        if button.iLevel then
            button.iLevel:SetText(color .. itemLevel .. "|r")
        end
    else
        if button.iLevel then
            button.iLevel:SetText("")
        end
    end
end

local function UpdateStuffing()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local button = _G["StuffingBag"..bag.."_"..slot]

            if button then
                CreateItemLevel(button)
                UpdateItemLevel(button, bag, slot)
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", function()
    UpdateStuffing()
end)

-- First update after profile loaded
UpdateStuffing()
CreateButtonsText("Character")
UpdateButtonsText("Character")

print("SlotItemLevel: Enabled")
