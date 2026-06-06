local V, C, L, _ = select(2, ...):unpack()

-- Media Options
C["Media"] = {
	["Backdrop_Color"] = {5/255, 5/255, 5/255, 0.8},
	["Blank"] = [[Interface\AddOns\Vermilion\Media\Textures\Blank]],
	["Blank_Font"] = [[Interface\AddOns\Vermilion\Media\Fonts\Invisible.ttf]],
	["Blizz"] = [[Interface\AddOns\Vermilion\Media\Border\Border_Default.tga]],
	["Border_Color"] = {150/255, 150/255, 150/255, 1},
	["Border_Glow"] = [[Interface\AddOns\Vermilion\Media\Border\Border_Glow.tga]],
	["Combat_Font"] = [[Interface\AddOns\Vermilion\Media\Fonts\Damage.ttf]],
	["Combat_Font_Size"] = 16,
	["Combat_Font_Size_Style"] = "OUTLINE" or "THINOUTLINE",
	["Font"] = [[Interface\AddOns\Vermilion\Media\Fonts\Normal.ttf]],
	["Font_Size"] = 12,
	["Font_Style"] = "OUTLINE" or "THINOUTLINE",
	["Glow"] = [[Interface\AddOns\Vermilion\Media\Textures\GlowTex.tga]],
	["Overlay_Color"] = {0/255, 0/255, 0/255, 0.8},
	["Proc_Sound"] = [[Interface\AddOns\Vermilion\Media\Sounds\Proc.ogg]],
	["Texture"] = [[Interface\AddOns\Vermilion\Media\Textures\UI-StatusBar]],
	["Warning_Sound"] = [[Interface\AddOns\Vermilion\Media\Sounds\Warning.ogg]],
	["Whisp_Sound"] = [[Interface\AddOns\Vermilion\Media\Sounds\Whisper.ogg]],
}
-- ActionBar Options
C["ActionBar"] = {
	["BottomBars"] = 3,
	["ButtonSize"] = 28,
	["ButtonSpace"] = 4,
	["Enable"] = true,
	["EquipBorder"] = true,
	["Hotkey"] = true,
	["Macro"] = false,
	["OutOfMana"] = {128/255, 128/255, 255/255},
	["OutOfRange"] = {204/255, 26/255, 26/255},
	["PetBarHide"] = false,
	["PetBarHorizontal"] = false,
	["RightBars"] = 2,
	["Selfcast"] = true,
	["ShowGrid"] = false,
	["SplitBars"] = true,
	["StanceBarHide"] = false,
	["StanceBarHorizontal"] = true,
	["ToggleMode"] = true,
}
-- Announcements Options
C["Announcements"] = {
	["Bad_Gear"] = true,
	["Feasts"] = true,
	["Interrupt"] = true,
	["Portals"] = true,
	["PullCountdown"] = true,
	["SaySapped"] = true,
	["Spells"] = true,
	["SpellsFromAll"] = true,
	["Toys"] = true,
}
-- Automation Options
C["Automation"] = {
	["AutoCollapse"] = true,
	["AutoInvite"] = true,
	["DeclineDuel"] = false,
	["LoggingCombat"] = false,
	["Resurrection"] = false,
	["ScreenShot"] = true,
	["SellGreyRepair"] = true,
	["TabBinder"] = true,
}
-- Bag Options
C["Bag"] = {
	["BagColumns"] = 12,
	["BankColumns"] = 17,
	["ButtonSize"] = 34,
	["ButtonSpace"] = 4,
	["Enable"] = true,
	["HideSoulBag"] = false,
}
-- Blizzard Options
C["Blizzard"] = {
	["Capturebar"] = true,
	["ClassColor"] = true,
	["DarkTextures"] = true,
	["DarkTexturesColor"] = {70/255, 70/255, 70/255},
	["Durability"] = true,
	["MoveAchievements"] = true,
	["Reputations"] = true,
}
-- Buffs & Debuffs Options
C["Aura"] = {
	["Enable"] = true,
	["BuffSize"] = 32,
	["CastBy"] = true,
	["ClassColorBorder"] = false,
}
-- Chat Options
C["Chat"] = {
	["CombatLog"] = true,
	["DamageMeterSpam"] = false,
	["Enable"] = true,
	["Filter"] = true,
	["Height"] = 200,
	["Outline"] = false,
	["Spam"] = false,
	["FadeTime"] = 120,
	["Sticky"] = true,
	["TabsMouseover"] = false,
	["TabsOutline"] = true,
	["WhispSound"] = true,
	["Width"] = 350,
}
-- Cooldown Options
C["Cooldown"] = {
	["Enable"] = true,
	["FontSize"] = 16,
	["Threshold"] = 3,
}
-- Error Options
C["Error"] = {
	["Black"] = false,
	["White"] = false,
	["Combat"] = true,
}
-- Filger Options
C["Filger"] = {
	["BuffsSize"] = 27,
	["CooldownSize"] = 23,
	["Enable"] = true,
	["MaxTestIcon"] = 8,
	["PvPSize"] = 50,
	["ShowTooltip"] = true,
	["TestMode"] = false,
}
-- General Options
C["General"] = {
	["AutoScale"] = false,
	["BubbleFontSize"] = 12,
	["BubbleBackdrop"] = true,
	["ReplaceBlizzardFonts"] = true,
	["TranslateMessage"] = true,
	["UIScale"] = 0.64,
	["MultisampleCheck"] = false,
	["WelcomeMessage"] = true,
}
-- Loot Options
C["Loot"] = {
	["ConfirmDisenchant"] = false,
	["AutoGreed"] = false,
	["LootFilter"] = true,
	["IconSize"] = 30,
	["Enable"] = true,
	["GroupLoot"] = true,
	["Width"] = 222,
}
-- Minimap Options
C["Minimap"] = {
	["CollectButtons"] = true,
	["Enable"] = true,
	["Ping"] = true,
	["Size"] = 150,
}
-- Miscellaneous Options
C["Misc"] = {
	["AFKCamera"] = true,
	["AlreadyKnown"] = true,
	["Armory"] = true,
	["BGSpam"] = true,
	["DurabilityWarninig"] = true,
	["EnhancedMail"] = true,
	["HatTrick"] = false,
	["InviteKeyword"] = "inv",
	["ItemLevel"] = false,
	["SpeedyLoad"] = true,
}
-- Nameplate Options
C["Nameplate"] = {
	["AdditionalHeight"] = 0,
	["AdditionalWidth"] = 0,

	["AuraSize"] = 20,

	["BadColor"] = {199/255, 64/255, 64/255},

	["ClassIcons"] = false,
	["Combat"] = false,
	["Enable"] = true,
	["EnhanceThreat"] = true,

	["GoodColor"] = {74/255, 173/255, 74/255},

	["HealthValue"] = true,

	-- ENEMY
	["EnemyWidth"] = 150,
	["EnemyHeight"] = 14,

	-- FRIENDLY
	["FriendlyWidth"] = 110,
	["FriendlyHeight"] = 10,

	["NameAbbreviate"] = true,

	["NearColor"] = {217/255, 196/255, 92/255},

	["CastBarName"] = true,
	["Auras"] = true,
}
-- PowerBar Options
C["PowerBar"] = {
	["Enable"] = false,
	["FontOutline"] = false,
	["Height"] = 4,
	["DKRuneBar"] = false,
	["Combo"] = true,
	["Mana"] = true,
	["Rage"] = true,
	["Rune"] = true,
	["RuneCooldown"] = true,
	["ValueAbbreviate"] = true,
	["Width"] = 200,
}
-- PulseCD Options
C["PulseCD"] = {
	["Enable"] = false,
	["Size"] = 75,
	["Sound"] = false,
	["AnimationScale"] = 1.5,
	["HoldTime"] = 0,
	["Threshold"] = 3,
}
-- Skins Options
C["Skins"] = {
	["Spy"] = false,
	["ChatBubble"] = true,
	["CLCRet"] = false,
	["DBM"] = false,
	["MinimapButtons"] = true,
	["Recount"] = false,
	["Skada"] = false,
	["WeakAuras"] = false,
	["WorldMap"] = false,
}
-- Tooltip Options
C["Tooltip"] = {
	["Achievements"] = true,
	["ArenaExperience"] = true,
	["Cursor"] = false,
	["Enable"] = true,
	["HealthValue"] = true,
	["HideCombat"] = false,
	["HideButtons"] = false,
	["InstanceLock"] = true,
	["ItemCount"] = true,
	["ItemIcon"] = true,
	["QualityBorder"] = true,
	["RaidIcon"] = true,
	["Rank"] = true,
	["SpellID"] = true,
	["Talents"] = true,
	["Target"] = true,
	["Title"] = true,
	["WhoTargetting"] = true,
}
-- Unitframe Options
C["Unitframe"] = {
	["ComboFrame"] = true,
	["SmoothBars"] = true,
	["AuraOffsetY"] = 3,
	["BetterPowerColors"] = true,
	["CastBarScale"] = 1,
	["ClassHealth"] = true,
	["ClassIcon"] = false,
	["CombatFeedback"] = true,
	["Enable"] = true,
	["EnhancedFrames"] = true,
	["GroupNumber"] = true,
	["PvPIcon"] = true,
	["LargeAuraSize"] = 26,
	["Outline"] = false,
	["PercentHealth"] = false,
	["Scale"] = 1.2,
	["SmallAuraSize"] = 22,
}

C["Misc"].ProcGlow = true

C["Raid"] = {
	["Enable"] = true,
	["Width"] = 82,
	["Height"] = 36,
	["HealthHeight"] = 24,
	["PowerHeight"] = 6,
	["HorizontalSpacing"] = 6,
	["VerticalSpacing"] = 6,
	["Scale"] = 1,
	["Backdrop"] = true,
	["BackdropAlpha"] = 0.8,
	["BorderClassColor"] = false,
	["HealthClassColor"] = true,
}