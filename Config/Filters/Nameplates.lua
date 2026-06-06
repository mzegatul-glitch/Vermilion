local V, C, L, _ = select(2, ...):unpack()
if C.Nameplate.Enable ~= true then return end

local GetSpellInfo = GetSpellInfo
----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at http://wotlk.openwow.com search for a spell.
--	Example: Necrotic Plague> http://wotlk.openwow.com/spell=73787
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id)
	if(not name) then
		print(" SpellID is not valid: "..id..". Please check for an updated version, if none exists report this to Vermilion.")
		return "Impale"
	else
		return name
	end
end

V.DebuffWhiteList = {
	-- Death Knight
	[SpellName(49203)]	=	true,	--	Hungering Cold
	[SpellName(47476)]	=	true,	--	Strangulate
	[SpellName(55095)]	=	true,	--	Frost Fever
	[SpellName(55078)]	=	true,	--	Blood Plague
	
	-- Druid
	[SpellName(33786)]	=	true,	--	Cyclone
	[SpellName(2637)]	=	true,	--	Hibernate
	[SpellName(339)]	=	true,	--	Entangling Roots
	[SpellName(8921)]	=	true,	--	Moonfire
	[SpellName(5570)]	=	true,	--	Insect Swarm
	[SpellName(58180)]	=	true,	--	Infected Wounds
	[SpellName(33878)]	=	true,	--	Mangle (Bear)
	[SpellName(33745)]	=	true,	--	Lacerate
	[SpellName(1822)]	=	true,	--	Rake
	[SpellName(1079)]	=	true,	--	Rip
	-- Hunter
	[SpellName(3355)]	=	true,	--	Freezing Trap
	[SpellName(1513)]	=	true,	--	Scare Beast
	[SpellName(19503)]	=	true,	--	Scatter Shot
	[SpellName(34490)]	=	true,	--	Silencing Shot
	-- Mage
	[SpellName(31661)]	=	true,	--	Dragon's Breath
	[SpellName(61305)]	=	true,	--	Polymorph
	[SpellName(18469)]	=	true,	--	Silenced
	[SpellName(122)]	=	true,	--	Frost Nova
	[SpellName(55080)]	=	true,	--	Shattered Barrier
	[SpellName(55360)]	=	true,	--	Living Bomb
	
	-- Paladin
	[SpellName(20066)]	=	true,	--	Repentance
	[SpellName(10326)]	=	true, 	--	Turn Evil
	[SpellName(853)]	=	true,	--	Hammer of Justice
	[SpellName(20186)]	=	true,	--	Judgement of Wisdom
	[SpellName(20185)]	=	true, 	--	Judgement of Light
	[SpellName(20184)]	=	true,	--	Judgement of Justice
	-- Priest
	[SpellName(605)]	=	true,	--	Mind Control
	[SpellName(64044)]	=	true,	--	Psychic Horror
	[SpellName(8122)]	=	true,	--	Psychic Scream
	[SpellName(9484)]	=	true,	--	Shackle Undead
	[SpellName(15487)]	=	true,	--	Silence
	[SpellName(34914)]	=	true,	--	Vampiric Touch
	[SpellName(2944)]	=	true,	--	Devouring Plague
	[SpellName(589)]	=	true,	--	Shadow Word: Pain
	-- Rogue
	[SpellName(2094)]	=	true,	--	Blind
	[SpellName(1776)]	=	true,	--	Gouge
	[SpellName(6770)]	=	true,	--	Sap
	[SpellName(18425)]	=	true,	--	Kick - Silenced
	-- Shaman
	[SpellName(51514)]	=	true,	--	Hex
	[SpellName(3600)]	=	true,	--	Earthbind Totem
	[SpellName(8056)]	=	true,	--	Frost Shock
	[SpellName(8050)]	=	true,	--	Flame Shock
	[SpellName(49231)]	=	true,	--	Earth Shock
	[SpellName(63685)]	=	true,	--	Freeze
	[SpellName(39796)]	=	true,	--	Stoneclaw Stun
	-- Warlock
	[SpellName(710)]	=	true,	--	Banish
	[SpellName(6789)]	=	true,	--	Death Coil
	[SpellName(5782)]	=	true,	--	Fear
	[SpellName(5484)]	=	true,	--	Howl of Terror
	[SpellName(6358)] 	=	true,	--	Seduction
	[SpellName(30283)]	=	true,	--	Shadowfury
	[SpellName(603)]	=	true,	--	Curse of Doom
	[SpellName(980)]	=	true,	--	Curse of Agony
	[SpellName(172)]	=	true,	--	Corruption
	[SpellName(17800)]	=	true,	--	Shadow Mastery
	[SpellName(48181)]	=	true,	--	Haunt
	[SpellName(30108)]	=	true,	--	Unstable Affliction
	[SpellName(348)]	=	true,	--	Immolate
	-- Warrior
	[SpellName(20511)]	=	true,	--	Intimidating Shout
	[SpellName(12323)]	=	true,	--	Piercing Howl
	[SpellName(1715)]	=	true,	--	Hamstring
	[SpellName(47465)]	=	true,	--	Rend
	[SpellName(47437)]	=	true,	--	Demoralizing Shout
	-- Racial
	[SpellName(25046)]	=	true,	--	Arcane Torrent
	[SpellName(20549)]	=	true,	--	War Stomp
}

V.PlateBlacklist = {
	["Dragonmaw War Banner"] = true,
	["Healing Tide Totem"] = true,

	--Gundrak
	["Fanged Pit Viper"] = true,
	["Crafty Snake"] = true,

	--Shaman Totems
	["Disease Cleansing Totem"] = true,
	["Earth Elemental Totem"] = true,
	["Earthbind Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Nova Totem I"] = true,
	["Fire Nova Totem II"] = true,
	["Fire Nova Totem III"] = true,
	["Fire Nova Totem IV"] = true,
	["Fire Nova Totem V"] = true,
	["Fire Nova Totem VI"] = true,
	["Fire Nova Totem VII"] = true,
	["Fire Resistance Totem I"] = true,
	["Fire Resistance Totem II"] = true,
	["Fire Resistance Totem III"] = true,
	["Fire Resistance Totem IV"] = true,
	["Fire Resistance Totem "] = true,
	["Flametongue Totem I"] = true,
	["Flametongue Totem II"] = true,
	["Flametongue Totem III"] = true,
	["Flametongue Totem IV"] = true,
	["Flametongue Totem V"] = true,
	["Frost Resistance Totem I"] = true,
	["Frost Resistance Totem II"] = true,
	["Frost Resistance Totem III"] = true,
	["Frost Resistance Totem IV"] = true,
	["Grace of Air Totem I"] = true,
	["Tranquil Air Totem"] = true,
	["Grace of Air Totem II"] = true,
	["Grace of Air Totem III"] = true,
	["Grounding Totem"] = true,
	["Healing Stream Totem"] = true,
	["Healing Stream Totem II"] = true,
	["Healing Stream Totem III"] = true,
	["Healing Stream Totem IV"] = true,
	["Healing Stream Totem V "] = true,
	["Healing Stream Totem VI"] = true,
	["Magma Totem"] = true,
	["Magma Totem II"] = true,
	["Magma Totem III"] = true,
	["Magma Totem IV"] = true,
	["Magma Totem V"] = true,
	["Mana Spring Totem"] = true,
	["Mana Spring Totem II"] = true,
	["Mana Spring Totem III"] = true,
	["Mana Spring Totem IV"] = true,
	["Mana Spring Totem V"] = true,
	["Mana Tide Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Nature Resistance Totem II"] = true,
	["Nature Resistance Totem III"] = true,
	["Nature Resistance Totem IV"] = true,
	["Nature Resistance Totem V"] = true,
	["Nature Resistance Totem V"] = true,
	["Poison Cleansing Totem"] = true,
	["Searing Totem"] = true,
	["Searing Totem II"] = true,
	["Searing Totem III"] = true,
	["Searing Totem IV"] = true,
	["Searing Totem V"] = true,
	["Searing Totem VI"] = true,
	["Searing Totem VII"] = true,
	["Sentry Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneclaw Totem II"] = true,
	["Stoneclaw Totem III"] = true,
	["Stoneclaw Totem IV"] = true,
	["Stoneclaw Totem V"] = true,
	["Stoneclaw Totem VI"] = true,
	["Stoneclaw Totem VII"] = true,
	["Stoneskin Totem"] = true,
	["Stoneskin Totem II"] = true,
	["Stoneskin Totem III"] = true,
	["Stoneskin Totem IV"] = true,
	["Stoneskin Totem V"] = true,
	["Stoneskin Totem VI"] = true,
	["Stoneskin Totem VII"] = true,
	["Stoneskin Totem VIII"] = true,
	["Strength of Earth Totem"] = true,
	["Strength of Earth Totem II"] = true,
	["Strength of Earth Totem III"] = true,
	["Strength of Earth Totem IV"] = true,
	["Strength of Earth Totem V"] = true,
	["Strength of Earth Totem VI"] = true,
	["Totem of Wrath"] = true,
	["Totem of Wrath II"] = true,
	["Totem of Wrath III"] = true,
	["Totem of Wrath IV"] = true,
	["Windfury Totem"] = true,
	["Windfury Totem II"] = true,
	["Windfury Totem III"] = true,
	["Windfury Totem IV"] = true,
	["Windfury Totem V"] = true,
	["Windwall Totem"] = true,
	["Windwall Totem II"] = true,
	["Windwall Totem III"] = true,
	["Windwall Totem IV"] = true,
	["Wrath of Air Totem"] = true,

	--The gayest ability in the game
	["Army of the Dead Ghoul"] = true,

	--Hunter Trap
	["Venomous Snake"] = true,
	["Viper"] = true,
}