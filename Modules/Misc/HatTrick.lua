local V, C, L, _ = select(2, ...):unpack()

local GameTooltip = GameTooltip
local CreateFrame = CreateFrame

local HelmCheck
local CloakCheck

local function UpdateHatTrick()
    if HelmCheck then
        if C.Misc.HatTrick then
            HelmCheck:Show()
            CloakCheck:Show()

            HelmCheck:SetChecked(ShowingHelm())
            CloakCheck:SetChecked(ShowingCloak())
        else
            HelmCheck:Hide()
            CloakCheck:Hide()
        end
    end
end

local function CreateHatTrick()

    if HelmCheck then
        UpdateHatTrick()
        return
    end

    ------------------------------------------------------------------
    -- Helm
    ------------------------------------------------------------------

    HelmCheck = CreateFrame("CheckButton", "HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
    HelmCheck:SetSize(16, 16)
    HelmCheck:SetPoint("CENTER", CharacterHeadSlot, "CENTER", 40, 6)

    HelmCheck:SetScript("OnClick", function()
        ShowHelm(not ShowingHelm())
        HelmCheck:SetChecked(ShowingHelm())
    end)

    HelmCheck:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(OPTION_TOOLTIP_SHOW_HELM)
    end)

    HelmCheck:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    HelmCheck:SetScript("OnEvent", function(self)
        self:SetChecked(ShowingHelm())
    end)

    HelmCheck:RegisterEvent("UNIT_MODEL_CHANGED")

    ------------------------------------------------------------------
    -- Cloak
    ------------------------------------------------------------------

    CloakCheck = CreateFrame("CheckButton", "CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
    CloakCheck:SetSize(16, 16)
    CloakCheck:SetPoint("CENTER", CharacterBackSlot, "CENTER", 40, 6)

    CloakCheck:SetScript("OnClick", function()
        ShowCloak(not ShowingCloak())
        CloakCheck:SetChecked(ShowingCloak())
    end)

    CloakCheck:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(OPTION_TOOLTIP_SHOW_CLOAK)
    end)

    CloakCheck:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    CloakCheck:SetScript("OnEvent", function(self)
        self:SetChecked(ShowingCloak())
    end)

    CloakCheck:RegisterEvent("UNIT_MODEL_CHANGED")

    ------------------------------------------------------------------

    UpdateHatTrick()
end

CreateHatTrick()