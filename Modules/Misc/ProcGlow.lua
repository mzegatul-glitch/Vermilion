local V, C, L = select(2, ...):unpack()

_G.ProcGlow = _G.ProcGlow or {}
local ProcGlow = _G.ProcGlow

if C.Misc.ProcGlow ~= true then
	return
end

local GetSpellTexture = GetSpellTexture
local C_Timer = C_Timer

if not C_Timer then

	C_Timer = {}

	function C_Timer.After(seconds, func)

		local f = CreateFrame("Frame")

		local elapsed = 0

		f:SetScript("OnUpdate", function(self, e)

			elapsed = elapsed + e

			if elapsed >= seconds then

				self:SetScript("OnUpdate", nil)

				func()
			end
		end)
	end
end
local _, playerClass = UnitClass("player")
local strlower = string.lower
local strupper = string.upper

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local classColor = RAID_CLASS_COLORS[playerClass]

local function ProcGlow_ShowOverlayGlow(frame)

	local LCG = LibStub and LibStub("LibCustomGlow-1.0", true)

	if not LCG or not frame then
		return
	end

	if frame.__procGlow then
		return
	end

	frame.__procGlow = true

	LCG.ProcGlow_Start(frame, {
		duration = 1,
		color = {classColor.r, classColor.g, classColor.b, 1},
		startAnim = true,
		key = "default",
		xOffset = 0,
		yOffset = 0,
	})
end

local function ProcGlow_HideOverlayGlow(frame)

	local LCG = LibStub and LibStub("LibCustomGlow-1.0", true)

	if not LCG or not frame then
		return
	end

	frame.__procGlow = nil

	LCG.ProcGlow_Stop(frame, "default")
end

-- ============================================================
-- MODULE
-- ============================================================

-- ============================================================
-- 1. DB
-- ============================================================
local DB = {}

local function InitDB()
    if not ProcGlowDB then
        ProcGlowDB = {}
    end

    local var = ProcGlowDB

    if not var.ProcGlow then
        var.ProcGlow = {
            alpha            = 1.0,
            animate          = true,
            breatheSpeed     = 0.6,
            breatheDepth     = 0.4,
            sideOffset       = 0,
            topOffset        = 0,
            textureScale     = 1,
            disabledProcs    = {},
            disabledTextures = {},
            glowEnabled      = true,
            disabledGlows    = {},
            stanceOverrides  = {},
        }
    end

    DB = var.ProcGlow
end

-- ============================================================
-- 2. CLASS PROC TABLE
-- ============================================================
local ClassProcs = {

    PALADIN = {
        [53489] = {
            name         = "Art of War",
            spells       = {"Exorcism", "Flash of Light"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Art_of_War.blp",
            position     = "Left + Right (Flipped)",
            scale        = 0.6,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [59578] = {
            name         = "Art of War",
            spells       = {"Exorcism", "Flash of Light"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Art_of_War.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [53672] = {
            name         = "Infusion of Light",
            spells       = {"Flash of Light", "Holy Light"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Daybreak.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [54149] = {
            name         = "Infusion of Light",
            spells       = {"Flash of Light", "Holy Light"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Daybreak.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [53657] = {
            name         = "Judgements of the Pure",
            spells       = {"Judgement of Light", "Judgement of Wisdom", "Judgement of Justice"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
        },
        [24275] = {
            name         = "Hammer of Wrath",
            spells       = {"Hammer of Wrath"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
        },
        [70765] = {
            name         = "Divine Storm Reset",
            spells       = {"Divine Storm"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,   -- clears when Divine Storm is cast
            cdReset      = true,
            iconOverride = 53385,
        },
    },

    WARRIOR = {
        [52437] = {
            name         = "Sudden Death",
            spells       = {"Execute"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Sudden_Death.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [46916] = {
            name         = "Bloodsurge",
            spells       = {"Slam"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Blood_Surge.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [50227] = {
            name         = "Sword and Board",
            spells       = {"Shield Slam"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Sword_and_Board.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [56636] = {
            name         = "Taste for Blood",
            spells       = {"Overpower"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\bandits_guile.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [46924] = {
            name         = "Bladestorm",
            spells       = {},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\GenericArc_05.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1.25,
            r = 200, g = 200, b = 200,
            showTexture  = true,
            showGlow     = false,
        },
        [7384] = {
            name         = "Overpower",
            spells       = {"Overpower"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
            stanceRestrict = { [1]=true },
        },
        [5308] = {
            name         = "Execute",
            spells       = {"Execute"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
            stanceRestrict = { [1]=true, [3]=true },
        },
        [6572] = {
            name         = "Revenge",
            spells       = {"Revenge"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
            stanceRestrict = { [2]=true },
        },
        [34428] = {
            name         = "Victory Rush",
            spells       = {"Victory Rush"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
        },
    },

    MAGE = {
        [57761] = {
            name         = "Brain Freeze",
            spells       = {"Frostfire Bolt", "Fireball"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Brain_Freeze.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [44401] = {
            name         = "Missile Barrage",
            spells       = {"Arcane Missiles"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Arcane_Missiles.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [48108] = {
            name         = "Hot Streak",
            spells		 = {"Pyroblast"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Hot_Streak.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [74396] = {
            name         = "Fingers of Frost",
            spells       = {"Ice Lance", "Deep Freeze"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Frozen_Fingers.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
    },

    WARLOCK = {
        [126] = {
            name         = "Eye of Kilrogg",
            spells       = {},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\GenericTop_01.blp",
            position     = "Top",
            scale        = 1,
            r = 64, g = 255, b = 64,
            showTexture  = true,
            showGlow     = false,
        },
        [17941] = {
            name         = "Shadow Trance",
            spells       = {"Shadow Bolt"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Nightfall.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [47383] = {
            name         = "Molten Core",
            spells       = {"Incinerate", "Soul Fire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Molten_Core.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = false,
        },
        [71162] = {
            name         = "Molten Core",
            spells       = {"Incinerate", "Soul Fire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Molten_Core.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = false,
        },
        [71165] = {
            name         = "Molten Core",
            spells       = {"Incinerate", "Soul Fire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Molten_Core.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [63165] = {
            name         = "Decimation",
            spells       = {"Soul Fire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Impact.blp",
            position     = "Top",
            scale        = 0.8,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = false,
        },
        [63167] = {
            name         = "Decimation",
            spells       = {"Soul Fire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Impact.blp",
            position     = "Top",
            scale        = 0.8,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [34936] = {
            name         = "Backlash",
            spells       = {"Shadow Bolt", "Incinerate"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Backlash.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [47283] = {
            name         = "Empowered Imp",
            spells       = {"Shadow Bolt", "Incinerate"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Imp_Empowerment.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
    },

    DRUID = {
        [16870] = {
            name         = "Omen of Clarity",
            spells       = {"Regrowth", "Healing Touch", "Starfire", "Wrath"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Natures_Grace.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [48518] = {
            name         = "Eclipse (Lunar)",
            spells       = {"Starfire"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Eclipse_Moon.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 244, g = 244, b = 244,
            showTexture  = true,
            showGlow     = true,
        },
        [48517] = {
            name         = "Eclipse (Solar)",
            spells       = {"Wrath"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Eclipse_Sun.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 244, g = 244, b = 244,
            showTexture  = true,
            showGlow     = true,
        },
        [16886] = {
            name        = "Nature's Grace",
            spells      = {},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Serendipity.blp",
            position    = "Top",
            scale       = 0.7,
            r = 255, g = 255, b = 255,
            showTexture = true,
            showGlow    = false,
        },
    },

    PRIEST = {
        [63731] = {
            name         = "Serendipity (1-2 Stacks)",
            spells       = {},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Serendipity.blp",
            position     = "Top",
            scale        = 0.6,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = false,
        },
        [63735] = {
            name         = "Serendipity (1-2 Stacks)",
            spells       = {},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Serendipity.blp",
            position     = "Top",
            scale        = 0.8,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = false,
        },
        [63734] = {
            name         = "Serendipity (3 Stacks)",
            spells       = {"Greater Heal", "Prayer of Healing"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Serendipity.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [14751] = {
            name         = "Inner Focus",
            spells       = {"Greater Heal", "Flash Heal", "Prayer of Healing"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
        },
        [33151] = {
            name         = "Surge of Light",
            spells       = {"Smite", "Flash Heal"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Surge_of_Light.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [15473] = {
            name         = "Shadowform",
            spells       = {"Mind Blast"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
        },
    },

    HUNTER = {
        [53351] = {
            name         = "Kill Shot",
            spells       = {"Kill Shot"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
        },
        [19306] = {
            name         = "Counterattack",
            spells       = {"Counterattack"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
        },
        [53220] = {
            name         = "Improved Steady Shot",
            spells       = {"Aimed Shot", "Arcane Shot", "Chimera Shot"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Master_Marksman.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [56453] = {
            name         = "Lock and Load",
            spells       = {"Arcane Shot", "Explosive Shot"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Lock_and_Load.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
    },

    SHAMAN = {
        [53817] = {
            name        = "Maelstrom Weapon",
            spells      = {"Lightning Bolt", "Chain Lightning", "Lesser Healing Wave", "Healing Wave", "Chain Heal"},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Maelstrom_Weapon.blp",
            position    = "Top",
            scale       = 1,
            r = 255, g = 255, b = 255,
            showTexture = true,
            showGlow    = true,
        },
        [53390] = {
            name        = "Tidal Waves",
            spells      = {"Lesser Healing Wave", "Healing Wave"},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\High_Tide.blp",
            position    = "TOP",
            scale       = 1,
            r = 255, g = 255, b = 255,
            showTexture = true,
            showGlow    = true,
        },
        [43339] = {
            name        = "Shamanistic Focus",
            spells      = {"Earth Shock", "Flame Shock", "Frost Shock"},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\GenericArc_05.blp",
            position    = "Left + Right (Flipped)",
            scale       = 1.25,
            r = 255, g = 128, b = 0,
            showTexture = true,
            showGlow    = true,
        },
        [16246] = {
            name        = "Elemental Focus",
            spells      = {"Lightning Bolt", "Chain Lightning", "Lava Burst"},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\GenericArc_05.blp",
            position    = "Left + Right (Flipped)",
            scale       = 1.25,
            r = 255, g = 255, b = 255,
            showTexture = true,
            showGlow    = true,
        },
    },

    ROGUE = {
        [51713] = {
            name         = "Shadow Dance",
            spells       = {"Ambush", "Garrote", "Cheap Shot", "Premeditation"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Slice_and_Dice.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [14251] = {
            name        = "Riposte",
            spells      = {"Riposte"},
            texture     = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\bandits_guile.blp",
            position    = "Left + Right (Flipped)",
            scale       = 1.1,
            r = 255, g = 255, b = 255,
            showTexture = true,
            showGlow    = true,
            counter     = true,
        },
    },

    DEATHKNIGHT = {
        [56815] = {
            name         = "Rune Strike",
            spells       = {"Rune Strike"},
            texture      = nil,
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = false,
            showGlow     = true,
            counter      = true,
        },
        [59052] = {
            name         = "Rime",
            spells       = {"Howling Blast"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Rime.blp",
            position     = "Top",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [51124] = {
            name         = "Killing Machine",
            spells       = {"Obliterate", "Frost Strike", "Icy Touch"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Killing_Machine.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
        [49530] = {
            name         = "Sudden Doom",
            spells       = {"Death Coil"},
            texture      = "Interface\\AddOns\\Vermilion\\Media\\SpellActivationOverlays\\Sudden_Doom.blp",
            position     = "Left + Right (Flipped)",
            scale        = 1,
            r = 255, g = 255, b = 255,
            showTexture  = true,
            showGlow     = true,
        },
    },
}

local procTable   = ClassProcs[playerClass] or {}
local activeProcs = {}
local testMode    = false
local UpdateGlows  -- forward declare

local stanceNames      = { [1]="Battle", [2]="Defensive", [3]="Berserker" }
local stanceGatedProcs = {}
for pID, data in pairs(procTable) do
    if data.stanceRestrict then
        stanceGatedProcs[pID] = true
    end
end

-- ============================================================
-- STANCE HELPERS (unchanged logic, same as before)
-- ============================================================
local function IsProcAllowedInStance(pID)
    local data = procTable[pID]
    if not data then return false end
    local dbOverride = DB.stanceOverrides and DB.stanceOverrides[pID]
    if dbOverride ~= nil then
        local currentStance = GetShapeshiftForm()
        if currentStance == 0 then return true end
        return dbOverride[currentStance] == true
    end
    local restrict = data.stanceRestrict
    if not restrict then return true end
    local currentStance = GetShapeshiftForm()
    if currentStance == 0 then return true end
    return restrict[currentStance] == true
end

local function GetStanceOptionsForProc(pID)
    local data = procTable[pID]
    if not data or not data.stanceRestrict then return nil end
    local restrict = data.stanceRestrict
    local relevant = {}
    for sIdx in pairs(restrict) do table.insert(relevant, sIdx) end
    table.sort(relevant)
    local options = {}
    table.insert(options, { label = "All Stances", stances = false })
    for _, sIdx in ipairs(relevant) do
        table.insert(options, { label = stanceNames[sIdx] .. " only", stances = { [sIdx]=true } })
    end
    if #relevant > 1 then
        for i = 1, #relevant do
            for j = i + 1, #relevant do
                local s1, s2 = relevant[i], relevant[j]
                table.insert(options, { label = stanceNames[s1] .. " + " .. stanceNames[s2], stances = { [s1]=true, [s2]=true } })
            end
        end
    end
    return options
end

local function GetCurrentStanceLabel(pID)
    local data = procTable[pID]
    if not data then return "All Stances" end

    local dbOverride = DB.stanceOverrides and DB.stanceOverrides[pID]

    -- No override set — read the default from the proc table itself
    if dbOverride == nil then
        local restrict = data.stanceRestrict
        if not restrict then return "All Stances" end
        local active = {}
        for sIdx, v in pairs(restrict) do
            if v then table.insert(active, sIdx) end
        end
        table.sort(active)
        if #active == 0 then return "All Stances" end
        if #active == 1 then return stanceNames[active[1]] .. " only" end
        local parts = {}
        for _, sIdx in ipairs(active) do table.insert(parts, stanceNames[sIdx]) end
        return table.concat(parts, " + ")
    end

    if dbOverride[1] and dbOverride[2] and dbOverride[3] then return "All Stances" end
    local active = {}
    for sIdx, v in pairs(dbOverride) do
        if v then table.insert(active, sIdx) end
    end
    table.sort(active)
    if #active == 0 then return "All Stances" end
    if #active == 1 then return stanceNames[active[1]] .. " only" end
    local parts = {}
    for _, sIdx in ipairs(active) do table.insert(parts, stanceNames[sIdx]) end
    return table.concat(parts, " + ")
end

local stanceDDFrame   = nil
local stanceDDContext = { pID = nil, labelFS = nil }

local function EnsureStanceDDFrame()
    if stanceDDFrame then return stanceDDFrame end
    stanceDDFrame = CreateFrame("Frame", "ProcGlowStanceDDF", UIParent, "UIDropDownMenuTemplate")
    stanceDDFrame.displayMode = "MENU"
    stanceDDFrame.initialize  = function(self, level)
        if not level then return end
        local pID     = stanceDDContext.pID
        local labelFS = stanceDDContext.labelFS
        if not pID or not labelFS then return end
        local options = GetStanceOptionsForProc(pID)
        if not options then return end
        local info = {}
        for _, opt in ipairs(options) do
            info.text         = opt.label
            info.notCheckable = true
            info.func         = function()
                if not DB.stanceOverrides then DB.stanceOverrides = {} end
                if opt.stances then
                    DB.stanceOverrides[pID] = opt.stances
                else
                    DB.stanceOverrides[pID] = { [1]=true, [2]=true, [3]=true }
                end
                labelFS:SetText("|cffaaaaaa" .. GetCurrentStanceLabel(pID) .. "|r")
                if not IsProcAllowedInStance(pID) then
                    activeProcs[pID] = false
                    UpdateGlows()
                end
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, level)
            wipe(info)
        end
        info.text = CLOSE
        info.notCheckable = true
        info.func = function() CloseDropDownMenus() end
        UIDropDownMenu_AddButton(info, level)
    end
    return stanceDDFrame
end

local function OpenStanceDropDown(anchor, pID, labelFS)
    stanceDDContext.pID     = pID
    stanceDDContext.labelFS = labelFS
    ToggleDropDownMenu(1, nil, EnsureStanceDDFrame(), anchor, 0, 0)
end

-- ============================================================
-- 3. OVERLAY FRAMES
-- ============================================================
local sizeScale = 0.8
local longSide  = 256 * sizeScale
local shortSide = 128 * sizeScale

local complexLocationTable = {
    ["RIGHT (FLIPPED)"]        = { RIGHT  = { hFlip = true } },
    ["BOTTOM (FLIPPED)"]       = { BOTTOM = { vFlip = true } },
    ["LEFT + RIGHT (FLIPPED)"] = { LEFT = {}, RIGHT = { hFlip = true } },
    ["TOP + BOTTOM (FLIPPED)"] = { TOP  = {}, BOTTOM = { vFlip = true } },
}

local overlayParent = CreateFrame("Frame", nil, UIParent)
overlayParent:SetSize(longSide, longSide)
overlayParent:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
overlayParent:SetFrameStrata("HIGH")
overlayParent:Show()

local overlayChildren = {}

local function CreateChildOverlay()
    local f = CreateFrame("Frame", nil, overlayParent)
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints(f)
    f.tex = tex
    f.pulseTimer = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        if not DB.animate then
            self:SetAlpha(DB.alpha or 1)
            return
        end
        self.pulseTimer = self.pulseTimer + elapsed
        local base   = DB.alpha or 1
        local depth  = DB.breatheDepth or 0.4
        local speed  = DB.breatheSpeed or 0.6
        local bottom = base * (1 - depth)
        local mid    = (base + bottom) / 2
        local amp    = (base - bottom) / 2
        self:SetAlpha(mid + amp * math.sin(self.pulseTimer * math.pi / speed))
    end)
    f:SetScript("OnShow", function(self)
        self.pulseTimer = 0
        self:SetAlpha(DB.alpha or 1)
    end)
    f:SetScript("OnHide", function(self) self:SetAlpha(1) end)
    f:Hide()
    return f
end

local function GetOrCreateChild(posKey)
    if not overlayChildren[posKey] then
        overlayChildren[posKey] = CreateChildOverlay()
    end
    return overlayChildren[posKey]
end

local function GetOffsetForPos(pos)
    local p = strupper(pos)
    if p == "LEFT"   then return -(DB.sideOffset or 0), 0 end
    if p == "RIGHT"  then return  (DB.sideOffset or 0), 0 end
    if p == "TOP"    then return 0,  (DB.topOffset or 0) end
    if p == "BOTTOM" then return 0, -(DB.topOffset or 0) end
    return 0, 0
end

local function ShowChild(posKey, texturePath, scale, r, g, b, vFlip, hFlip)
    local child = GetOrCreateChild(posKey)
    child:ClearAllPoints()
    local texL, texR, texT, texB = 0, 1, 0, 1
    if vFlip then texT, texB = 1, 0 end
    if hFlip then texL, texR = 1, 0 end
    child.tex:SetTexCoord(texL, texR, texT, texB)
    local width, height
    local pos = strupper(posKey)
    local ox, oy = GetOffsetForPos(pos)
    if pos == "CENTER" then
        width, height = longSide, longSide
        child:SetPoint("CENTER", overlayParent, "CENTER", ox, oy)
    elseif pos == "LEFT" then
        width, height = shortSide, longSide
        child:SetPoint("RIGHT", overlayParent, "LEFT", ox, oy)
    elseif pos == "RIGHT" then
        width, height = shortSide, longSide
        child:SetPoint("LEFT", overlayParent, "RIGHT", ox, oy)
    elseif pos == "TOP" then
        width, height = longSide, shortSide
        child:SetPoint("BOTTOM", overlayParent, "TOP", ox, oy)
    elseif pos == "BOTTOM" then
        width, height = longSide, shortSide
        child:SetPoint("TOP", overlayParent, "BOTTOM", ox, oy)
    elseif pos == "TOPRIGHT" then
        width, height = shortSide, shortSide
        child:SetPoint("BOTTOMLEFT", overlayParent, "TOPRIGHT", ox, oy)
    elseif pos == "TOPLEFT" then
        width, height = shortSide, shortSide
        child:SetPoint("BOTTOMRIGHT", overlayParent, "TOPLEFT", ox, oy)
    elseif pos == "BOTTOMRIGHT" then
        width, height = shortSide, shortSide
        child:SetPoint("TOPLEFT", overlayParent, "BOTTOMRIGHT", ox, oy)
    elseif pos == "BOTTOMLEFT" then
        width, height = shortSide, shortSide
        child:SetPoint("TOPRIGHT", overlayParent, "BOTTOMLEFT", ox, oy)
    else
        return
    end
    child:SetSize(width * scale * (DB.textureScale or 1), height * scale * (DB.textureScale or 1))
    child.tex:SetTexture(texturePath)
    child.tex:SetVertexColor(r / 255, g / 255, b / 255)
    child:Show()
end

local function ShowOverlayForProc(procID)
    local data = procTable[procID]
    if not data then return end
    if DB.disabledProcs and DB.disabledProcs[procID] then return end
    if DB.disabledTextures and DB.disabledTextures[procID] then return end
    if (DB.alpha or 1) == 0 then return end
    if not data.showTexture then return end
    if not data.texture then return end
    local posUpper = strupper(data.position)
    if complexLocationTable[posUpper] then
        for location, info in pairs(complexLocationTable[posUpper]) do
            ShowChild(location, data.texture, data.scale, data.r, data.g, data.b, info.vFlip, info.hFlip)
        end
    else
        ShowChild(data.position, data.texture, data.scale, data.r, data.g, data.b, false, false)
    end
end

local function HideAllOverlays()
    for _, child in pairs(overlayChildren) do
        if child:IsShown() then child:Hide() end
    end
end

local function ShowTestOverlays()
    HideAllOverlays()
    for pID in pairs(procTable) do
        ShowOverlayForProc(pID)
    end
end

-- ============================================================
-- 4. BUTTON GLOW
-- ============================================================
local function GetGlowLib()
    return LibStub and LibStub("LibCustomGlow-1.0", true)
end


local function IsGlowAllowedForSpell(spellName)
    if not spellName then
        return false
    end

    if type(spellName) == "number" then
        spellName = GetSpellInfo(spellName)
    end

    if not spellName or type(spellName) ~= "string" then
        return false
    end

    if not DB.glowEnabled then
        return false
    end

    if DB.disabledGlows and DB.disabledGlows[strlower(spellName)] then
        return false
    end

    return true
end

-- ============================================================
-- 5. CORE UPDATE LOGIC
-- ============================================================
local currentlyShownProc = nil


UpdateGlows = function()
    local LCG = GetGlowLib()

    if testMode then
        ShowTestOverlays()

        if LCG then
            local bars = {
                "ActionButton",
                "MultiBarBottomLeftButton",
                "MultiBarBottomRightButton",
                "MultiBarRightButton",
                "MultiBarLeftButton",
            }

            for _, prefix in ipairs(bars) do
                for i = 1, 12 do
                    local f = _G[prefix .. i]

                    if f then
local action = ActionButton_CalculateAction and ActionButton_CalculateAction(f) or f.action

local spellName = nil

if action then
    local actionType, id, subType = GetActionInfo(action)

    -- =====================================================
    -- DIRECT SPELL
    -- =====================================================
    if actionType == "spell" and id then
        spellName = GetSpellInfo(id)

    -- =====================================================
    -- MACRO SPELL
    -- =====================================================
    elseif actionType == "macro" then
        local macroSpell = GetMacroSpell(id)

        if type(macroSpell) == "number" then
            spellName = GetSpellInfo(macroSpell)
        else
            spellName = macroSpell
        end
    end

    -- =====================================================
    -- PAGED ACTION FALLBACK (PALADIN / WARRIOR / DRUID)
    -- =====================================================
    if not spellName then
        local pagedAction = ActionButton_GetPagedID and ActionButton_GetPagedID(f)

        if pagedAction then
            local pType, pID = GetActionInfo(pagedAction)

            if pType == "spell" and pID then
                spellName = GetSpellInfo(pID)

            elseif pType == "macro" then
                local macroSpell = GetMacroSpell(pID)

                if type(macroSpell) == "number" then
                    spellName = GetSpellInfo(macroSpell)
                else
                    spellName = macroSpell
                end
            end
        end
    end

    -- =====================================================
    -- TEXTURE FALLBACK
    -- =====================================================
    if not spellName then
        local texture = GetActionTexture(action)

        if texture then
            for _, data in pairs(procTable) do
                for _, targetName in ipairs(data.spells) do
                    local compareSpell = targetName

                    if type(compareSpell) == "number" then
                        compareSpell = GetSpellInfo(compareSpell)
                    end

                    if compareSpell then
                        local compareTexture = GetSpellTexture(compareSpell)

                        if compareTexture == texture then
                            spellName = compareSpell
                            break
                        end
                    end
                end

                if spellName then
                    break
                end
            end
        end
    end
end

                        local shouldGlow = false

if spellName then
    local actionSpellID = nil
    local actionSpellName = nil

    if action then
        local actionType, actionID = GetActionInfo(action)

        -- ==========================================
        -- DIRECT SPELL
        -- ==========================================
        if actionType == "spell" then
            actionSpellID = actionID

        -- ==========================================
        -- MACRO SPELL
        -- ==========================================
        elseif actionType == "macro" then
            local macroSpell = GetMacroSpell(actionID)

            if type(macroSpell) == "number" then
                actionSpellID = macroSpell
            end
        end
    end

    -- ==========================================
    -- GET ACTION SPELL NAME
    -- ==========================================
    if actionSpellID then
        actionSpellName = GetSpellInfo(actionSpellID)
    end

    -- ==========================================
    -- PROC CHECK
    -- ==========================================
    for pID, data in pairs(procTable) do
        if data.showGlow
        and activeProcs[pID]
        and not (DB.disabledProcs and DB.disabledProcs[pID])
        and IsProcAllowedInStance(pID)
        and IsGlowAllowedForSpell(spellName)
        then

            for _, targetName in ipairs(data.spells) do
                local compareSpellName = nil

                -- ==========================================
                -- TARGET SPELL NAME
                -- ==========================================
                if type(targetName) == "number" then
                    compareSpellName = GetSpellInfo(targetName)
                else
                    compareSpellName = targetName
                end

                -- ==========================================
                -- EXACT SPELL MATCH
                -- ==========================================
                if compareSpellName and actionSpellName then
                    local s1 = strlower(compareSpellName)
                    local s2 = strlower(actionSpellName)

                    s1 = s1:gsub("%(.-%)", "")
                    s2 = s2:gsub("%(.-%)", "")

                    s1 = s1:gsub("%s+", "")
                    s2 = s2:gsub("%s+", "")

                    if s1 == s2 then
                        local start, duration, enable = GetActionCooldown(action)

                        local onCooldown = false

                        if enable == 1 and start and duration then
                            if duration > 1.5 then
                                onCooldown = true
                            end
                        end

                        -- ==========================================
                        -- GLOW
                        -- ==========================================
                        if not onCooldown then
                            shouldGlow = true
                            break
                        end
                    end
                end
            end

            if shouldGlow then
                break
            end
        end
    end
end

local glowFrame = f

if shouldGlow then
    if not f.__procglow then
        f.__procglow = true

        ProcGlow_ShowOverlayGlow(f)
    end
else
    if f.__procglow then
        f.__procglow = nil

        ProcGlow_HideOverlayGlow(f)
    end
end
                    end
                end
            end
        end

        return
    end

    local activeProcID = nil

    for pID in pairs(procTable) do
        if activeProcs[pID]
        and not (DB.disabledProcs and DB.disabledProcs[pID])
        and IsProcAllowedInStance(pID)
        then
            if not activeProcID then
                activeProcID = pID
            elseif not procTable[pID].counter and procTable[activeProcID].counter then
                activeProcID = pID
            end
        end
    end

    if activeProcID then
        if currentlyShownProc ~= activeProcID then
            HideAllOverlays()
            ShowOverlayForProc(activeProcID)
            currentlyShownProc = activeProcID
        end
    else
        if currentlyShownProc then
            HideAllOverlays()
            currentlyShownProc = nil
        end
    end

    if LCG then
        local bars = {
            "ActionButton",
            "MultiBarBottomLeftButton",
            "MultiBarBottomRightButton",
            "MultiBarRightButton",
            "MultiBarLeftButton",
        }

        for _, prefix in ipairs(bars) do
            for i = 1, 12 do
                local f = _G[prefix .. i]

                if f then
local action = ActionButton_CalculateAction and ActionButton_CalculateAction(f) or f.action
local spellName = nil

if action then
    local actionType, id = GetActionInfo(action)

    -- ==========================================
    -- DIRECT SPELL
    -- ==========================================
    if actionType == "spell" and id then
        spellName = GetSpellInfo(id)

    -- ==========================================
    -- MACRO
    -- ==========================================
    elseif actionType == "macro" then
        local macroSpell = GetMacroSpell(id)

        if type(macroSpell) == "number" then
            spellName = GetSpellInfo(macroSpell)
        else
            spellName = macroSpell
        end
    end

    -- ==========================================
    -- FALLBACK
    -- ==========================================
    if not spellName then
        local texture = GetActionTexture(action)

        if texture then
            for _, data in pairs(procTable) do
                for _, targetName in ipairs(data.spells) do
                    local compareSpell = targetName

                    if type(compareSpell) == "number" then
                        compareSpell = GetSpellInfo(compareSpell)
                    end

                    if compareSpell then
                        local compareTexture = GetSpellTexture(compareSpell)

                        if compareTexture == texture then
                            spellName = compareSpell
                            break
                        end
                    end
                end

                if spellName then
                    break
                end
            end
        end
    end
end

                    local shouldGlow = false

if spellName then
    for pID, data in pairs(procTable) do
        if data.showGlow
        and activeProcs[pID]
        and not (DB.disabledProcs and DB.disabledProcs[pID])
        and IsProcAllowedInStance(pID)
        and IsGlowAllowedForSpell(spellName)
        then

            for _, targetName in ipairs(data.spells) do
                local compareName = targetName

                if type(targetName) == "number" then
                    compareName = GetSpellInfo(targetName)
                end

                if compareName and spellName then
                    local s1 = strlower(tostring(spellName))
                    local s2 = strlower(tostring(compareName))

                    if s1 == s2
                    or s1:find(s2, 1, true)
                    or s2:find(s1, 1, true)
                    then
                        local start, duration, enable = GetActionCooldown(action)

                        local onCooldown = false

                        if enable == 1 and start and duration then
                            if duration > 1.5 then
                                onCooldown = true
                            end
                        end

                        if not onCooldown then
                            shouldGlow = true
                            break
                        end
                    end
                end
            end

            if shouldGlow then
                break
            end
        end
    end
end

local glowFrame = f

if shouldGlow then
    if not f.__procglow then
        f.__procglow = true

        ProcGlow_ShowOverlayGlow(f)
    end
else
    if f.__procglow then
        f.__procglow = nil

        ProcGlow_HideOverlayGlow(f)
    end
end
                end
            end
        end
    end
end

-- ============================================================
-- 6. CONFIG UI
-- ============================================================
local Texture = "Interface\\Buttons\\WHITE8x8"
local R, G, B = 0.2, 0.6, 1
local Font = STANDARD_TEXT_FONT

local PAD      = 10
local ROW_H    = 28
local HEADER_H = 28
local BTN_H    = 22

local configFrame  = nil
local sliderRefs   = {}
local checkboxRefs = {}
local stanceLabelRefs = {}

local function BG(parent, r, g, b, a)
    local t = parent:CreateTexture(nil, "BACKGROUND")
    t:SetDrawLayer("BORDER", 7)
    t:SetAllPoints()
    t:SetTexture(Texture)
    t:SetVertexColor(r, g, b, a)
    return t
end

local function MakeBtn(parent, w, h, label)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(w, h)

    local fs = btn:CreateFontString(nil, "OVERLAY")
    fs:SetFont(STANDARD_TEXT_FONT, 12, "")
    fs:SetPoint("CENTER")
    fs:SetText(label)

    btn.SetText = function(self, t)
        fs:SetText(t)
    end

    btn.GetText = function(self)
        return fs:GetText()
    end

    return btn
end

local SliderEditBoxWidth = 40
local SliderWidth        = 180
local LabelSpacing       = 8
local Spacing            = 6

local function KUI_CreateSlider(parent, label, minV, maxV, step, onChanged)
    local Anchor = CreateFrame("Frame", nil, parent)
    Anchor:SetSize(SliderEditBoxWidth + SliderWidth + LabelSpacing + 120, 20)

    local EditBox = CreateFrame("Frame", nil, Anchor)
    EditBox:SetPoint("LEFT", Anchor, 0, 0)
    EditBox:SetSize(SliderEditBoxWidth, 20)
    EditBox:CreateBorder()
    BG(EditBox, 0.05, 0.05, 0.05, 0.9)

    EditBox.Highlight = EditBox:CreateTexture(nil, "OVERLAY")
    EditBox.Highlight:SetAllPoints()
    EditBox.Highlight:SetTexture(Texture)
    EditBox.Highlight:SetVertexColor(123/255, 132/255, 137/255)
    EditBox.Highlight:SetAlpha(0)

    EditBox.Box = CreateFrame("EditBox", nil, EditBox)
    EditBox.Box:SetFont(STANDARD_TEXT_FONT, 12, "")
    EditBox.Box:SetPoint("TOPLEFT",     EditBox, 0, 0)
    EditBox.Box:SetPoint("BOTTOMRIGHT", EditBox, 0, 0)
    EditBox.Box:SetJustifyH("CENTER")
    EditBox.Box:SetMaxLetters(6)
    EditBox.Box:SetAutoFocus(false)
    EditBox.Box:EnableKeyboard(true)
    EditBox.Box:EnableMouse(true)
    EditBox.Box:EnableMouseWheel(true)

    local Slider = CreateFrame("Slider", nil, Anchor)
    Slider:SetPoint("LEFT", EditBox, "RIGHT", Spacing, 0)
    Slider:SetSize(SliderWidth, 20)
    Slider:SetThumbTexture(Texture)
    Slider:SetOrientation("HORIZONTAL")
    Slider:SetValueStep(step)
    Slider:CreateBorder()
    Slider:SetMinMaxValues(minV, maxV)
    Slider:EnableMouseWheel(true)

    Slider.Highlight = Slider:CreateTexture(nil, "OVERLAY")
    Slider.Highlight:SetAllPoints()
    Slider.Highlight:SetTexture(Texture)
    Slider.Highlight:SetVertexColor(123/255, 132/255, 137/255)
    Slider.Highlight:SetAlpha(0)

    local Thumb = Slider:GetThumbTexture()
    Thumb:SetSize(8, 20)
    Thumb:SetTexture(Texture)
    Thumb:SetVertexColor(R, G, B)

    Thumb.Border = CreateFrame("Frame", nil, Slider)
    Thumb.Border:SetPoint("TOPLEFT",     Thumb, 0, -1)
    Thumb.Border:SetPoint("BOTTOMRIGHT", Thumb, 0,  1)
    Thumb.Border:CreateBorder(nil, nil, nil, nil, nil, nil, nil, nil, nil,
        Texture, nil, nil, nil, R, G, B)

    Slider.Progress = Slider:CreateTexture(nil, "ARTWORK")
    Slider.Progress:SetPoint("TOPLEFT",     Slider, 1, -1)
    Slider.Progress:SetPoint("BOTTOMRIGHT", Thumb, "BOTTOMLEFT", 0, 0)
    Slider.Progress:SetTexture(Texture)
    Slider.Progress:SetVertexColor(R, G, B)

    Slider.Label = Slider:CreateFontString(nil, "OVERLAY")
    Slider.Label:SetPoint("LEFT", Slider, "RIGHT", LabelSpacing, 0)
    Slider.Label:SetWidth(120)
    Slider.Label:SetJustifyH("LEFT")
    Slider.Label:SetFont(STANDARD_TEXT_FONT, 12, "")
    Slider.Label:SetText(label)

    local function UpdateEditBox(val)
        if step < 1 then
            EditBox.Box:SetText(string.format("%.2f", val))
        else
            EditBox.Box:SetText(tostring(math.floor(val + 0.5)))
        end
    end

    Slider:SetScript("OnValueChanged", function(self, val)
        UpdateEditBox(val)
        self.Progress:SetPoint("BOTTOMRIGHT", Thumb, "BOTTOMLEFT", 0, 0)
        if onChanged then onChanged(self, val) end
    end)
    Slider:SetScript("OnMouseWheel", function(self, delta)
        self:SetValue(self:GetValue() + delta * step)
    end)
    EditBox.Box:SetScript("OnEnterPressed", function(self)
        local v = tonumber(self:GetText())
        if v then
            v = math.max(minV, math.min(maxV, v))
            Slider:SetValue(v)
        end
        self:ClearFocus()
    end)
    EditBox.Box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    EditBox.Box:SetScript("OnMouseWheel", function(self, delta)
        Slider:SetValue(Slider:GetValue() + delta * step)
    end)

    Anchor.Slider   = Slider
    Anchor.EditBox  = EditBox.Box
    Anchor.SetValue = function(_, v) Slider:SetValue(v) end
    Anchor.GetValue = function(_)    return Slider:GetValue() end
    return Anchor
end

local checkboxCount = 0
local function KUI_CreateCheckbox(parent, label, iconTex, onClick)
    checkboxCount = checkboxCount + 1

    local cb = CreateFrame(
        "CheckButton",
        "ProcGlowKCheck"..checkboxCount,
        parent,
        "UICheckButtonTemplate"
    )

    cb:SetSize(20, 20)

    local lbl = _G[cb:GetName().."Text"]
    lbl:SetFont(STANDARD_TEXT_FONT, 12, "")
    lbl:SetText(label)

    if iconTex then
        local icon = cb:CreateTexture(nil, "ARTWORK")
        icon:SetSize(16, 16)
        icon:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        icon:SetTexture(iconTex)

        lbl:ClearAllPoints()
        lbl:SetPoint("LEFT", icon, "RIGHT", 4, 0)
    else
        lbl:ClearAllPoints()
        lbl:SetPoint("LEFT", cb, "RIGHT", 8, 0)
    end

    if onClick then
        cb:SetScript("OnClick", onClick)
    end

    return cb
end

local function MakeSectionHeader(parent, text, yOff)
    local line = CreateFrame("Frame", nil, parent)
    line:SetHeight(HEADER_H)
    line:SetPoint("TOPLEFT",  parent, "TOPLEFT",  PAD, yOff)
    line:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -PAD, yOff)
    line:CreateBorder()
    BG(line, 0.15, 0.15, 0.15, 0.5)
    local fs = line:CreateFontString(nil, "OVERLAY")
    fs:SetFont(STANDARD_TEXT_FONT, 12, "")
    fs:SetPoint("LEFT", line, "LEFT", 8, 0)
    fs:SetText("|cffFFCC66" .. text .. "|r")
    return line
end

local function BuildSpellNameToIDMap()
    local map = {}

    for pID, data in pairs(procTable) do
        for _, spellName in ipairs(data.spells) do

            local realName = spellName

            if type(spellName) == "number" then
                realName = GetSpellInfo(spellName)
            end

            if realName then
                local key = realName:lower()

                if not map[key] then
                    local _, _, icon = GetSpellInfo(realName)

                    if icon then
                        map[key] = icon
                    end
                end
            end
        end

        local iconID = data.iconOverride or pID
        local procName, _, procIcon = GetSpellInfo(iconID)

        if procName and procIcon then
            map[procName:lower()] = procIcon
        end
    end

    return map
end

local function GetAllProcSpells()
    local seen, spells = {}, {}

    for _, data in pairs(procTable) do
        if data.showGlow then
            for _, spellName in ipairs(data.spells) do

                local realName = spellName

                if type(spellName) == "number" then
                    realName = GetSpellInfo(spellName)
                end

                if realName then
                    local key = realName:lower()

                    if not seen[key] then
                        seen[key] = true
                        spells[#spells + 1] = realName
                    end
                end
            end
        end
    end

    table.sort(spells)

    return spells
end

_G.ProcGlow = _G.ProcGlow or {}
_G.ProcGlow.SetupArrow = function() end

local function BuildConfigUI()
    if configFrame then configFrame:Show(); return end

    local f = CreateFrame("Frame", "ProcGlowConfig", UIParent)
	f:SetBackdrop({
	bgFile = "Interface\\Buttons\\WHITE8x8",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 0,
	edgeSize = 12,
	insets = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2
	}
})

f:SetBackdropColor(0.05, 0.05, 0.05, 0.95)

f:SetBackdropBorderColor(
	0.3,
	0.3,
	0.3,
	1
)
    f:SetSize(480, 620)
    f:SetFrameStrata("DIALOG")
    f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:Hide()
    f:CreateBorder()
    BG(f, 0.05, 0.05, 0.05, 0.95)
    table.insert(UISpecialFrames, "ProcGlowConfig")
    configFrame = f

    local header = CreateFrame("Frame", nil, f)
    header:SetHeight(HEADER_H)
    header:SetPoint("TOPLEFT",  f,  PAD, -PAD)
    header:SetPoint("TOPRIGHT", f, -PAD, -PAD)
    header:CreateBorder()
    BG(header, R * 0.35, G * 0.35, B * 0.35, 0.6)

    local titleFS = header:CreateFontString(nil, "OVERLAY")
    titleFS:SetFont(STANDARD_TEXT_FONT, 12, "")
    titleFS:SetPoint("CENTER", header)
    titleFS:SetText("|cffFFCC66ProcGlow Config|r")

    local closeBtn = CreateFrame("Button", nil, header)
    closeBtn:SetSize(22, 22)
    closeBtn:SetPoint("RIGHT", header, -2, 0)
    closeBtn.tex = closeBtn:CreateTexture(nil, "OVERLAY")
    closeBtn.tex:SetPoint("CENTER"); closeBtn.tex:SetSize(18, 18)
    closeBtn.tex:SetTexture("Interface\\AddOns\\Vermilion\\Media\\Textures\\CloseButton_32")
    closeBtn:SetScript("OnEnter", function(s) s.tex:SetVertexColor(1, 0.2, 0.2) end)
    closeBtn:SetScript("OnLeave", function(s) s.tex:SetVertexColor(1, 1,   1)   end)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local scrollFrame = CreateFrame("ScrollFrame", "ProcGlowConfigScroll", f, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT",     f,  PAD,  -(PAD + HEADER_H + PAD))
    scrollFrame:SetPoint("BOTTOMRIGHT", f, -32,   46)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(scrollFrame:GetWidth() - 4)
    content:SetHeight(1)
    scrollFrame:SetScrollChild(content)

    local sb = _G["ProcGlowConfigScrollScrollBar"]
    if sb and sb.SkinScrollBar then
    sb:SkinScrollBar()
    end

    local testBtn  = MakeBtn(f, 140, BTN_H, "Test Mode: OFF")
    testBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD, 14)

    local resetBtn = MakeBtn(f, 140, BTN_H, "Reset to Defaults")
    resetBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -PAD, 14)

    local yOff = -5
    local function NextY(delta) yOff = yOff - delta end
    local function Place(widget, xLeft, extraY)
        widget:SetParent(content)
        widget:ClearAllPoints()
        widget:SetPoint("TOPLEFT", content, "TOPLEFT", xLeft or PAD, yOff - (extraY or 0))
    end

    MakeSectionHeader(content, "Visual Settings", yOff)
    NextY(HEADER_H + 8)

    local alphaSlider = KUI_CreateSlider(content, "Overlay Alpha", 0, 1, 0.05, function(_, val)
        DB.alpha = val
        if testMode then ShowTestOverlays() end
    end)
    Place(alphaSlider, PAD); alphaSlider:SetValue(DB.alpha or 1)
    sliderRefs.alpha = alphaSlider
    NextY(28)

    local speedSlider = KUI_CreateSlider(content, "Breathe Speed (s)", 0.1, 2.0, 0.05, function(_, val)
        DB.breatheSpeed = val
    end)
    Place(speedSlider, PAD); speedSlider:SetValue(DB.breatheSpeed or 0.6)
    sliderRefs.breatheSpeed = speedSlider
    NextY(28)

    local depthSlider = KUI_CreateSlider(content, "Breathe Depth", 0, 1, 0.05, function(_, val)
        DB.breatheDepth = val
    end)
    Place(depthSlider, PAD); depthSlider:SetValue(DB.breatheDepth or 0.3)
    sliderRefs.breatheDepth = depthSlider
    NextY(28)

    local sideSlider = KUI_CreateSlider(content, "Side Texture Offset", -80, 80, 1, function(_, val)
        DB.sideOffset = val
        if testMode then ShowTestOverlays() end
        if currentlyShownProc then HideAllOverlays(); ShowOverlayForProc(currentlyShownProc) end
    end)
    Place(sideSlider, PAD); sideSlider:SetValue(DB.sideOffset or 0)
    sliderRefs.side = sideSlider
    NextY(28)

    local topSlider = KUI_CreateSlider(content, "Top Texture Offset", -80, 80, 1, function(_, val)
        DB.topOffset = val
        if testMode then ShowTestOverlays() end
        if currentlyShownProc then HideAllOverlays(); ShowOverlayForProc(currentlyShownProc) end
    end)
    Place(topSlider, PAD); topSlider:SetValue(DB.topOffset or 0)
    sliderRefs.top = topSlider
    NextY(28)

    local texScaleSlider = KUI_CreateSlider(content, "Texture Scale", 0.1, 2.0, 0.05, function(_, val)
        DB.textureScale = val
        if testMode then ShowTestOverlays() end
        if currentlyShownProc then HideAllOverlays(); ShowOverlayForProc(currentlyShownProc) end
    end)
    Place(texScaleSlider, PAD); texScaleSlider:SetValue(DB.textureScale or 1.0)
    sliderRefs.textureScale = texScaleSlider
    NextY(36)

    local animCheck = KUI_CreateCheckbox(content, "Enable breathing animation", nil, function(self)
        DB.animate = self:GetChecked() and true or false
    end)
    Place(animCheck, PAD); animCheck:SetChecked(DB.animate)
    checkboxRefs.animate = animCheck
    NextY(28)

    MakeSectionHeader(content, "Spell Alerts", yOff)
    NextY(HEADER_H + 8)

    local seenNames = {}
    for pID, data in pairs(procTable) do
        if data.showTexture and data.texture and not seenNames[data.name] then
            seenNames[data.name] = pID
        end
    end
    local uniqueProcs = {}
    for name, pID in pairs(seenNames) do
        uniqueProcs[#uniqueProcs + 1] = { name = name, pID = pID }
    end
    table.sort(uniqueProcs, function(a, b) return a.name < b.name end)

    for _, entry in ipairs(uniqueProcs) do
        local pID  = entry.pID
        local data = procTable[pID]
        local iconID = data.iconOverride or pID
        local _, _, procIcon = GetSpellInfo(iconID)

        -- master checkbox
        local cb = KUI_CreateCheckbox(content, data.name, procIcon, function(self)
            local isChecked = self:GetChecked()
            for id, d in pairs(procTable) do
                if d.name == data.name then
                    if isChecked then
                        DB.disabledProcs[id] = nil
                    else
                        DB.disabledProcs[id] = true
                        DB.disabledTextures[id] = nil
                    end
                end
            end
            local texCB = checkboxRefs["tex__" .. pID]
			if texCB.Enable then
			texCB:Enable()
			elseif texCB.Disable and not isChecked then
			texCB:Disable()
			end
            if testMode then
                HideAllOverlays()
                ShowTestOverlays()
            end
            UpdateGlows()
        end)
        Place(cb, PAD + 4)
        cb:SetChecked(not (DB.disabledProcs and DB.disabledProcs[pID]))
        checkboxRefs[pID] = cb

        -- texture checkbox
        local texCB = KUI_CreateCheckbox(content, "Show Texture", nil, function(self)
            local isChecked = self:GetChecked()
            for id, d in pairs(procTable) do
                if d.name == data.name then
                    if isChecked then
                        DB.disabledTextures[id] = nil
                    else
                        DB.disabledTextures[id] = true
                    end
                end
            end
            if testMode then
                HideAllOverlays()
                ShowTestOverlays()
            end
            UpdateGlows()
        end)
        texCB:SetSize(14, 14)
        texCB:SetParent(content)
        texCB:ClearAllPoints()
        texCB:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 14, 0)
        if isChecked then

		if texCB.Enable then
			texCB:Enable()
		end

		else

		if texCB.Disable then
			texCB:Disable()
		end
	end
        if not (DB.disabledProcs and DB.disabledProcs[pID]) then

	if texCB.Enable then
		texCB:Enable()
	end

else

	if texCB.Disable then
		texCB:Disable()
	end
end
        checkboxRefs["tex__" .. pID] = texCB

        NextY(ROW_H + ROW_H - 10)
    end
    NextY(6)

    MakeSectionHeader(content, "Glowing Buttons", yOff)
    NextY(HEADER_H + 8)

    local glowMasterCB = KUI_CreateCheckbox(content, "Enable Glowing Buttons", nil, function(self)
        DB.glowEnabled = self:GetChecked() and true or false
        for spellKey, cb in pairs(checkboxRefs) do
            if type(spellKey) == "string" and spellKey:sub(1,6) == "glow__" then
                cb:SetEnabled(DB.glowEnabled)
            end
        end
        UpdateGlows()
    end)
    Place(glowMasterCB, PAD)
    glowMasterCB:SetChecked(DB.glowEnabled)
    _G[glowMasterCB:GetName() .."Text"]:SetTextColor(1, 0.82, 0)
    checkboxRefs.glowMaster = glowMasterCB
    NextY(ROW_H)

    local spellNameToID      = BuildSpellNameToIDMap()
    local allSpells          = GetAllProcSpells()
    local spellToProcNames   = {}
    local spellToCounterOnly = {}
    local spellToGatedProcID = {}

for pID, data in pairs(procTable) do
    if data.showGlow then
        for _, spellName in ipairs(data.spells) do

            local realName = spellName

            if type(spellName) == "number" then
                realName = GetSpellInfo(spellName)
            end

            if realName and type(realName) == "string" then
                local key = realName:lower()

                if key then
                    if not spellToProcNames[key] then
                        spellToProcNames[key] = {}
                    end

                    local alreadyAdded = false

                    for _, existing in ipairs(spellToProcNames[key]) do
                        if existing == data.name then
                            alreadyAdded = true
                            break
                        end
                    end

                    if not alreadyAdded then
                        spellToProcNames[key][#spellToProcNames[key] + 1] = data.name
                    end

                    if not data.counter and not data.combatLog then
                        spellToCounterOnly[key] = false
                    elseif spellToCounterOnly[key] == nil then
                        spellToCounterOnly[key] = true
                    end

                    if stanceGatedProcs[pID] and not spellToGatedProcID[key] then
                        spellToGatedProcID[key] = pID
                    end
                end
            end
        end
    end
end

    local drawnStanceDD = {}
    for _, spellName in ipairs(allSpells) do
        local key        = "glow__" .. spellName:lower()
        local iconTex    = spellNameToID[spellName:lower()]
        local procNames  = spellToProcNames[spellName:lower()]
        local counterOnly = spellToCounterOnly[spellName:lower()]
        local label = spellName
        if not counterOnly and procNames and #procNames > 0 then
            table.sort(procNames)
            label = spellName .. "  |cff888888<- " .. table.concat(procNames, ", ") .. "|r"
        end
        local cb = KUI_CreateCheckbox(content, label, iconTex, function(self)
            if self:GetChecked() then
                DB.disabledGlows[spellName:lower()] = nil
            else
                DB.disabledGlows[spellName:lower()] = true
            end
            UpdateGlows()
        end)
        Place(cb, PAD + 14)
        cb:SetChecked(not (DB.disabledGlows and DB.disabledGlows[spellName:lower()]))
        if DB.glowEnabled then if cb.Enable then cb:Enable() end else if cb.Disable then cb:Disable() end
		end
        checkboxRefs[key] = cb
        NextY(ROW_H)

        local gatedProcID = spellToGatedProcID[spellName:lower()]
        if gatedProcID and not drawnStanceDD[gatedProcID] then
            drawnStanceDD[gatedProcID] = true
            local stanceLbl = content:CreateFontString(nil, "OVERLAY")
            stanceLbl:SetFont(STANDARD_TEXT_FONT, 12, "")
            stanceLbl:SetPoint("TOPLEFT", content, "TOPLEFT", PAD + 34, yOff)
            stanceLbl:SetText("|cff888888Stances:|r")
            local stanceValueFS = content:CreateFontString(nil, "OVERLAY")
            stanceValueFS:SetFont(STANDARD_TEXT_FONT, 12, "")
            stanceValueFS:SetPoint("LEFT", stanceLbl, "RIGHT", 6, 0)
            stanceValueFS:SetText("|cffaaaaaa" .. GetCurrentStanceLabel(gatedProcID) .. "|r")
            stanceLabelRefs[gatedProcID] = stanceValueFS
            local arrowTex = content:CreateTexture(nil, "OVERLAY")
            arrowTex:SetSize(12, 12)
            arrowTex:SetPoint("LEFT", stanceValueFS, "RIGHT", 4, 0)
			if ProcGlow.SetupArrow then
				ProcGlow.SetupArrow(arrowTex)
			else
				arrowTex:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
			end
            local ddBtn = CreateFrame("Button", nil, content)
            ddBtn:SetHeight(ROW_H - 4)
            ddBtn:SetPoint("LEFT",  stanceLbl,    "LEFT",  0, 0)
            ddBtn:SetPoint("RIGHT", stanceValueFS, "RIGHT", 20, 0)
            ddBtn:SetScript("OnEnter", function()
                stanceLbl:SetTextColor(1, 0.82, 0)
                stanceValueFS:SetTextColor(1, 0.82, 0)
                arrowTex:SetVertexColor(1, 0.82, 0)
            end)
            ddBtn:SetScript("OnLeave", function()
                stanceLbl:SetTextColor(0.53, 0.53, 0.53)
                stanceValueFS:SetTextColor(0.67, 0.67, 0.67)
                arrowTex:SetVertexColor(1, 1, 1)
            end)
            ddBtn:SetScript("OnClick", function(self)
                OpenStanceDropDown(self, gatedProcID, stanceValueFS)
            end)
            NextY(ROW_H)
        end
    end

    content:SetHeight(math.abs(yOff) + 20)

    testBtn:SetScript("OnClick", function(self)
        testMode = not testMode
        if testMode then
            self:SetText("Test Mode: |cff00ff00ON|r")
            UpdateGlows()
        else
            self:SetText("Test Mode: OFF")
            HideAllOverlays()
            currentlyShownProc = nil
            local LCG = GetGlowLib()
            if LCG then
                local fr = EnumerateFrames()
                while fr do
                    if fr:IsObjectType("CheckButton") and fr.action then
                        LCG.ProcGlow_Stop(fr)
                    end
                    fr = EnumerateFrames(fr)
                end
            end
            UpdateGlows()
        end
    end)

    resetBtn:SetScript("OnClick", function()
        HideAllOverlays()
        currentlyShownProc = nil
        DB.alpha             = 1.0
        DB.animate           = true
        DB.breatheSpeed      = 0.6
        DB.breatheDepth      = 0.4
        DB.sideOffset        = 0
        DB.topOffset         = 0
        DB.textureScale      = 1.0
        DB.disabledProcs     = {}
        DB.disabledTextures  = {}
        DB.glowEnabled       = true
        DB.disabledGlows     = {}
        DB.stanceOverrides   = {}
        for pID, labelFS in pairs(stanceLabelRefs) do
            labelFS:SetText("|cffaaaaaa" .. GetCurrentStanceLabel(pID) .. "|r")
        end
        sliderRefs.alpha:SetValue(DB.alpha)
        sliderRefs.breatheSpeed:SetValue(DB.breatheSpeed)
        sliderRefs.breatheDepth:SetValue(DB.breatheDepth)
        sliderRefs.side:SetValue(DB.sideOffset)
        sliderRefs.top:SetValue(DB.topOffset)
        sliderRefs.textureScale:SetValue(DB.textureScale)
        checkboxRefs.animate:SetChecked(DB.animate)
        if checkboxRefs.glowMaster then
            checkboxRefs.glowMaster:SetChecked(DB.glowEnabled)
        end
        for key, cb in pairs(checkboxRefs) do
            if type(key) == "number"
            or (type(key) == "string" and key:sub(1,6) == "glow__")
            or (type(key) == "string" and key:sub(1,5) == "tex__")
            then
                cb:SetChecked(true)
                cb:SetEnabled(true)
            end
        end
        if testMode then ShowTestOverlays() end
        UpdateGlows()
    end)

    f:Show()
end

-- ============================================================
-- 7. SLASH COMMAND
-- ============================================================
SLASH_PROCGLOW1 = "/procglow"
SlashCmdList["PROCGLOW"] = function()
    BuildConfigUI()
end

function ProcGlow:OpenConfig()
    BuildConfigUI()
end

-- ============================================================
-- 8. EVENT HANDLING — wired through K:RegisterEvent
-- ============================================================
local function OnUnitAura(event, unit)
    if unit ~= "player" then return end
    local changed = false
    for pID, data in pairs(procTable) do
        if not data.combatLog and not data.counter then
            local name = GetSpellInfo(pID)
            if name then
                local hasAura = UnitAura("player", name) ~= nil
                if activeProcs[pID] ~= hasAura then
                    activeProcs[pID] = hasAura
                    changed = true
                end
            end
        end
    end
    if changed then UpdateGlows() end
end

local divineStormExpireTime = 0
local gcdStart    = nil
local gcdDuration = nil

local function CheckGCD()
    local startTime, duration = GetSpellCooldown(61304)
    if duration and duration > 0 then
        gcdStart    = startTime
        gcdDuration = duration
    else
        gcdStart    = nil
        gcdDuration = nil
    end
end

local function OnDivineStormCooldown()
    if not procTable[70765] then return end
    CheckGCD()
    local start, duration = GetSpellCooldown("Divine Storm")
	start = start or 0
	duration = duration or 0
	local time = GetTime()
    local endTime = start + duration

    if duration > 0 then
        if gcdStart and start == gcdStart and duration == gcdDuration then
            -- only GCD showing, check if we had a longer CD stored
            if divineStormExpireTime and divineStormExpireTime > endTime and divineStormExpireTime ~= 0 then
                divineStormExpireTime = 0
                activeProcs[70765] = true
                UpdateGlows()
            end
            return
        end
        divineStormExpireTime = endTime
    else
        if divineStormExpireTime and divineStormExpireTime > time + 1 then
            activeProcs[70765] = true
            UpdateGlows()
        end
        divineStormExpireTime = 0
    end
end

local function OnCombatLogEvent(...)
    local timestamp, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...
    -- 1. Counter triggers (dodge / parry / block misses)
    local missType
    if subEvent == "SWING_MISSED" then
        missType = select(9, ...)
    elseif subEvent == "SPELL_MISSED" then
        missType = select(12, ...)
    end

    if missType then
        local changed = false

        if sourceGUID == UnitGUID("player") and missType == "DODGE" then
            if procTable[7384] and IsProcAllowedInStance(7384) then
                activeProcs[7384] = true; changed = true
            end
        end

        if destGUID == UnitGUID("player") then
            if subEvent == "SWING_MISSED" then
                if missType == "DODGE" or missType == "PARRY" or missType == "BLOCK" then
                    if procTable[6572] and IsProcAllowedInStance(6572) then
                        activeProcs[6572] = true; changed = true
                    end
                end
                if missType == "DODGE" or missType == "PARRY" then
                    if procTable[56815] then activeProcs[56815] = true; changed = true end
                    if procTable[14251] and missType == "PARRY" then activeProcs[14251] = true; changed = true end
                end
            elseif subEvent == "SPELL_MISSED" or subEvent == "RANGE_MISSED" then
                local rangeMissType = select(12, ...)
                if rangeMissType == "DODGE" or rangeMissType == "PARRY" or rangeMissType == "BLOCK" then
                    if procTable[6572] and IsProcAllowedInStance(6572) then
                        activeProcs[6572] = true; changed = true
                    end
                end
                if rangeMissType == "DODGE" or rangeMissType == "PARRY" then
                    if procTable[56815] then activeProcs[56815] = true; changed = true end
                end
                if rangeMissType == "PARRY" then
                    if procTable[14251] then activeProcs[14251] = true; changed = true end
                end
            end
        end

        if changed then UpdateGlows() end
    end

    -- 2. Clear counter proc on successful cast
    if subEvent == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
        local spellID  = select(9, ...)
        local castName = GetSpellInfo(spellID)
        if castName then
            local changed = false
            for pID, pData in pairs(procTable) do
                if pData.counter and activeProcs[pID] then
                    for _, targetName in ipairs(pData.spells) do
                        if castName:lower() == targetName:lower() then
                            activeProcs[pID] = false
                            changed = true
                            break
                        end
                    end
                end
            end
            if changed then UpdateGlows() end
        end
    end

    -- 3. Victory Rush: procs on kill
    if subEvent == "UNIT_DIED" and sourceGUID == UnitGUID("player") then
        if procTable[34428] then activeProcs[34428] = true; UpdateGlows() end
    end
end

local function OnUpdateShapeshiftForm()
    for pID, data in pairs(procTable) do
        if data.counter then
            local anyUsable = false
            for _, spellName in ipairs(data.spells) do
                if IsUsableSpell(spellName) then anyUsable = true; break end
            end
            if not anyUsable and activeProcs[pID] then
                activeProcs[pID] = false
            end
        end
    end
    C_Timer.After(0.05, UpdateGlows)
end

local function OnPlayerRegenEnabled()
    for pID in pairs(activeProcs) do activeProcs[pID] = false end
    UpdateGlows()
end

local function OnExecuteRangeCheck(event, unit)
    if event == "PLAYER_TARGET_CHANGED" then unit = "target" end
    if unit ~= "target" then return end

    local canAttack = UnitCanAttack("player", "target")
    local hp    = UnitHealth("target")
    local hpMax = UnitHealthMax("target")
    local pct   = hpMax > 0 and (hp / hpMax) or 1

    local function checkExecute(pID, threshold)
        if not procTable[pID] then return end
        local can = canAttack and pct < threshold and IsProcAllowedInStance(pID)
        if activeProcs[pID] ~= can then
            activeProcs[pID] = can
            UpdateGlows()
        end
    end

    checkExecute(5308,  0.20)   -- Warrior Execute
    checkExecute(53351, 0.20)   -- Hunter Kill Shot
    checkExecute(24275, 0.20)   -- Paladin Hammer of Wrath
end

local function OnSpellUpdateUsable()
    local changed = false
    for pID, data in pairs(procTable) do
        if data.counter and data.spells and #data.spells > 0 and not data.cdReset then  -- skip cdReset procs
            local usable = false
            for _, spellName in ipairs(data.spells) do
                local u, noMana = IsUsableSpell(spellName)
                if u or noMana then
                    usable = true
                    break
                end
            end
            local should = usable and IsProcAllowedInStance(pID)
            if activeProcs[pID] ~= should then
                activeProcs[pID] = should
                changed = true
            end
        end
    end
    if changed then UpdateGlows() end
end

local function OnStanceChanged()
    if playerClass ~= "WARRIOR" then
        return
    end

    C_Timer.After(0.1, function()
        local LCG = GetGlowLib()

        if LCG then
            for i = 1, 12 do
                local f = _G["ActionButton"..i]

                if f and f.__PGGlow then
                    f.__PGGlow = nil
                    ProcGlow_HideOverlayGlow(f)
                end
            end
        end

        OnSpellUpdateUsable()
        UpdateGlows()
    end)
end

-- ============================================================
-- OnEnable — module entry point called by Vermilion on PLAYER_LOGIN
-- ============================================================
local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:RegisterEvent("SPELLS_CHANGED")
EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventFrame:RegisterEvent("UNIT_HEALTH")

if playerClass == "WARRIOR" then
    EventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
end

if playerClass == "PALADIN" then
    EventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        InitDB()
        UpdateGlows()

    elseif event == "UNIT_AURA" then
        OnUnitAura(event, ...)

    elseif event == "ACTIONBAR_SLOT_CHANGED" then
        UpdateGlows()

    elseif event == "SPELLS_CHANGED" then
        UpdateGlows()

    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateGlows()
        OnExecuteRangeCheck()

    elseif event == "ACTIONBAR_UPDATE_USABLE" then
        OnSpellUpdateUsable()

    elseif event == "PLAYER_REGEN_ENABLED" then
        OnPlayerRegenEnabled()

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        OnCombatLogEvent()

    elseif event == "SPELL_UPDATE_COOLDOWN" then
        OnDivineStormCooldown()

    elseif event == "UNIT_HEALTH" then
        OnExecuteRangeCheck()

    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        OnStanceChanged()
    end
end)