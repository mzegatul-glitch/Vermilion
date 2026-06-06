local V, C, L, _ = select(2, ...):unpack()
if C.Aura.Enable ~= true or C.Filger.Enable ~= true then return end

COOLDOWN_Anchor = CreateFrame("Frame", "COOLDOWN_Anchor", UIParent)
PVE_PVP_CC_Anchor = CreateFrame("Frame", "PVE_PVP_CC_Anchor", UIParent)
PVE_PVP_DEBUFF_Anchor = CreateFrame("Frame", "PVE_PVP_DEBUFF_Anchor", UIParent)
P_BUFF_ICON_Anchor = CreateFrame("Frame", "P_BUFF_ICON_Anchor", UIParent)
P_PROC_ICON_Anchor = CreateFrame("Frame", "P_PROC_ICON_Anchor", UIParent)
SPECIAL_P_BUFF_ICON_Anchor = CreateFrame("Frame", "SPECIAL_P_BUFF_ICON_Anchor", UIParent)
T_BUFF_Anchor = CreateFrame("Frame", "T_BUFF_Anchor", UIParent)
T_DEBUFF_ICON_Anchor = CreateFrame("Frame", "T_DEBUFF_ICON_Anchor", UIParent)
T_DE_BUFF_BAR_Anchor = CreateFrame("Frame", "T_DE_BUFF_BAR_Anchor", UIParent)

C["filger_spells"] = {
	["DRUID"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 33763,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Lifebloom
			{ spellID = 774,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Rejuvenation
			{ spellID = 8936,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Regrowth	
			{ spellID = 2893,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Abolish Poison	
			{ spellID = 52610,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Savage roar	
			{ spellID = 22812,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Barkskin	 
			{ spellID = 61336,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Survival Instincts	
			{ spellID = 48518,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Eclipse (Lunar)	
			{ spellID = 48517,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Eclipse (Solar)	
			{ spellID = 16870,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Clearcasting
			{ spellID = 5229,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Enrage
			{ spellID = 50213,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Tiger's Fury
			{ spellID = 22842,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Frenzied Regeneration
			{ spellID = 53312,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Nature's Grasp
			{ spellID = 33357,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Dash
			{ spellID = 53201,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Starfall
			{ spellID = 50334,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Berserk
			{ spellID = 48066,	unitID = "player",	caster = "all",		filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 69369,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Predatory Strikes
			{ spellID = 16886,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Nature's Grace
			{ spellID = 70721,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Omen of Doom
			{ spellID = 64823,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Elune's Wrath			T8	4 set Boomy
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 48463,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Moonfire
			{ spellID = 48468,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Insect Swarm	
			{ spellID = 770,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Faerie Fire
			{ spellID = 26989,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Entangling Roots
			{ spellID = 59886,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Rake	
			{ spellID = 49800,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Rip
			{ spellID = 48568,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Lacerate	
			{ spellID = 49804,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce Bleed	
			{ spellID = 48566,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Mangle (Cat)
			{ spellID = 48564,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Mangle (Bear)
			{ spellID = 48560,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Demoralizing Roar
			{ spellID = 5211,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Bash
			{ spellID = 6795,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Growl
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce

		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce
		},

		{
			Name = "T_DE/BUFF_BAR",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 186,
			Position = {"LEFT", T_DE_BUFF_BAR_Anchor},

			{ spellID = 33763,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Lifebloom
			{ spellID = 774,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Rejuvenation
			{ spellID = 8936,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Regrowth
			{ spellID = 48438,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Wild Growth
			{ spellID = 99,		size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Demoralizing Roar
			
		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 53308,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "all",	filter = "DEBUFF" },	--	Entangling Roots
			{ spellID = 33786,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "all",	filter = "DEBUFF" },	--	Cyclone
			{ spellID = 2637,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "all",	filter = "DEBUFF" },	--	Hibernate
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 48438,	size = 30,	filter = "CD" },	--	Wild Growth
			{ spellID = 18562,	size = 30,	filter = "CD" },	--	Swiftmend
			{ spellID = 22812,	size = 30,	filter = "CD" },	--	Barkskin
			{ spellID = 33878,	size = 30,	filter = "CD" },	--	Mangle(Bear)
			{ spellID = 53312,	size = 30,	filter = "CD" },	--	Nature's Grasp
			{ spellID = 53201,	size = 30,	filter = "CD" },	--	Starfall
			{ spellID = 61676,	size = 30,	filter = "CD" },	--	Growl
			{ spellID = 5229,	size = 30,	filter = "CD" },	--	Enrage
			{ spellID = 16857,	size = 30,	filter = "CD" },	--	Faerie Fire(Feral)
			{ spellID = 16979,	size = 30,	filter = "CD" },	--	Feral Charge - Bear	
			{ spellID = 49376,	size = 30,	filter = "CD" },	--	Feral Charge - Cat
			{ spellID = 8983,	size = 30,	filter = "CD" },	--	Bash
			{ spellID = 49802,	size = 30,	filter = "CD" },	--	Maim
			{ spellID = 48575,	size = 30,	filter = "CD" },	--	Cower
		},
	},
	["HUNTER"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 56453,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Lock and Load
			{ spellID = 6150,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Quick Shots
			{ spellID = 34837,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Master Tactician
			{ spellID = 53224,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Master Tactician
			{ spellID = 34503,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Expose Weakness
			{ spellID = 71007,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Stinger 4t10 proc
			{ spellID = 3045,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Rapid Fire
			{ spellID = 53434,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Call of the Wild
			{ spellID = 1539,	unitID = "pet",		caster = "player",	filter = "BUFF" },	--	Feed Pet Effect
			{ spellID = 3662,	unitID = "pet",		caster = "player",	filter = "BUFF" },	--	Mend Pet
			{ spellID = 5118,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Aspect of the Cheetah
			{ spellID = 13161,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Aspect of the Beast
			{ spellID = 13163,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Aspect of the Monkey
			{ spellID = 27045,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Aspect of the Wild
			{ spellID = 34074,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Aspect of the Viper
			{ spellID = 19574,	unitID = "pet",		caster = "player",	filter = "BUFF" },	--	Bestial Wrath
			{ spellID = 19577,	unitID = "pet",		caster = "player",	filter = "BUFF" },	--	Intimidation
			{ spellID = 24604,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Furious Howl
			{ spellID = 34471,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	The Beast Within
			{ spellID = 48066,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 19263,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Deterrence
			{ spellID = 5384,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Feign Death
			{ spellID = 53271,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Master's Call
			{ spellID = 64861,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Precision Shots			T8	4 set
			{ spellID = 71007,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Stinger					T10	4P Bonus
			{ spellID = 70728,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Exploit Weakness		T10	2P Bonus
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 1130,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Hunter's Mark
			{ spellID = 49001,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Serpent Sting
			{ spellID = 3043,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Scorpid Sting
			{ spellID = 63672,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Black Arrow
			{ spellID = 60053,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Explosive Shot
			{ spellID = 1513,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Scare Beast
			{ spellID = 5116,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Concussive Shot
			{ spellID = 27018,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Viper Sting
			{ spellID = 19386,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Wyvern Sting
			{ spellID = 14268,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Wing Clip
			{ spellID = 13810,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost trap
			{ spellID = 14309,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Freezing trap
			{ spellID = 27024,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Immolation Trap
			{ spellID = 27026,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Explosive trap
			{ spellID = 24394,	unitID = "target",	caster = "pet",		filter = "DEBUFF" },	--	Intimidation
			
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce

		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 49012,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Wyvern Sting
			{ spellID = 34490,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Silencing Shot
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 53301,	size = 30,	filter = "CD" },	--	Explosive Shot
			{ spellID = 19434,	size = 30,	filter = "CD" },	--	Aimed Shot
			{ spellID = 61006,	size = 30,	filter = "CD" },	--	Kill Shot
			{ spellID = 781,	size = 30,	filter = "CD" },	--	Disengage
			{ spellID = 34477,	size = 30,	filter = "CD" },	--	Misdirection
			{ spellID = 34026,	size = 30,	filter = "CD" },	--	Kill Command
			{ spellID = 28728,	size = 30,	filter = "CD" },	--	Feign Death
			{ spellID = 14311,	size = 30,	filter = "CD" },	--	Freezing Trap
			{ spellID = 49012,	size = 30,	filter = "CD" },	--	Wyvern Sting
			{ spellID = 14327,	size = 30,	filter = "CD" },	--	Scare Beast
			{ spellID = 53271,	size = 30,	filter = "CD" },	--	Master's Call
			{ spellID = 19263,	size = 30,	filter = "CD" },	--	Deterrence
			{ spellID = 5116,	size = 30,	filter = "CD" },	--	Concussive Shot
			{ spellID = 48999,	size = 30,	filter = "CD" },	--	Counterattack
			{ spellID = 53339,	size = 30,	filter = "CD" },	--	Mongoose Bite
			{ spellID = 19577,	size = 30,	filter = "CD" },	--	Intimidation
			{ spellID = 3045,	size = 30,	filter = "CD" },	--	Rapid Fir
			{ spellID = 20572,	size = 30,	filter = "CD" },	--	Blood Fury
			{ spellID = 23989,	size = 30,	filter = "CD" },	--	Readiness
		},
	},
	["MAGE"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},
			
			{ spellID = 44544,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Fingers of Frost
			{ spellID = 57761,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Fireball!
			{ spellID = 44448,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Hot Streak
			{ spellID = 54490,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Missile Barrage
			{ spellID = 12536,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Clearcasting
			{ spellID = 12358,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Impact
			{ spellID = 66,		unitID = "player",	caster = "player",	filter = "BUFF" },	--	Invisibility
			{ spellID = 27131,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Mana Shield
			{ spellID = 27128,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Fire Ward
			{ spellID = 32796,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Frost Ward
			{ spellID = 45438,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Ice barrier
			{ spellID = 11129,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Combustion
			{ spellID = 12042,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Arcane Power
			{ spellID = 12472,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Icy Veins
			{ spellID = 48066,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 130,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Slow fall
			{ spellID = 62215,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Mana Surges 			T7	2 set
			{ spellID = 64868,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Praxis					T8	2 set
			{ spellID = 70747,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Quad Core				T10	4P	Bonus
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},
			
			{ spellID = 11071,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Frostbite
			{ spellID = 28593,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Winter's Chill
			{ spellID = 116,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frostbolt
			{ spellID = 118,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Polymorph
			{ spellID = 122,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost Nova
			{ spellID = 12654,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Ignite
			{ spellID = 11366,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pyroblast
			{ spellID = 55360,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Living Bomb

			
			
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce

		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 118,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" }, --	Polymorph
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 1953,	size = 30,	filter = "CD" },	--	Blink
			{ spellID = 11831,	size = 30,	filter = "CD" },	--	Frost Nova
			{ spellID = 11426,	size = 30,	filter = "CD" },	--	Ice Barrier
			{ spellID = 2139,	size = 30,	filter = "CD" },	--	Counterspell
			{ spellID = 44572,	size = 30,	filter = "CD" },	--	Deep Freeze
			{ spellID = 6143,	size = 30,	filter = "CD" },	--	Frost Ward
			{ spellID = 12043,	size = 30,	filter = "CD" },	--	Presence of Mind
			{ spellID = 12042,	size = 30,	filter = "CD" },	--	Arcane Power
			{ spellID = 42945,	size = 30,	filter = "CD" },	--	Blast Wave
			{ spellID = 42950,	size = 30,	filter = "CD" },	--	Dragon's Breath
			{ spellID = 42931,	size = 30,	filter = "CD" },	--	Cone of Cold
			{ spellID = 7744,	size = 30,	filter = "CD" },	--	Will of the forsaken (undead)
			{ spellID = 11958,	size = 30,	filter = "CD" },	--	Cold Snap
			{ spellID = 45438,	size = 30,	filter = "CD" },	--	Ice Block
			{ spellID = 12051,	size = 30,	filter = "CD" },	--	Evocation
			{ spellID = 12472,	size = 30,	filter = "CD" },	--	Icy Veins
			{ spellID = 2136,	size = 30,	filter = "CD" },	--	Fire Blast
			{ spellID = 55342,	size = 30,	filter = "CD" },	--	Mirror Image
		},
	},
	["WARRIOR"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 52437,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Sudden Death
			{ spellID = 46916,	unitID = "player",	caster = "all",		filter = "BUFF" },	--	Slam!
			{ spellID = 871,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Shield wall
			{ spellID = 1719,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Recklessness
			{ spellID = 7384,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Overpower
			{ spellID = 12975,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Last Stand
			{ spellID = 12292,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Death Wish
			{ spellID = 20230,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Shield Reflection
			{ spellID = 18499,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Berserker Rage
			{ spellID = 12328,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Sweeping Strikes
			{ spellID = 46924,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Bladestorm
			{ spellID = 48066,	unitID = "player",	caster = "all",		filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 29131,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Blood Rage
			{ spellID = 2565,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Shield Block
			{ spellID = 23920,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Shield Reflection
			{ spellID = 55694,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Enraged Regeneration	
			{ spellID = 50227,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Sword and Board
			{ spellID = 64937,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Heightened Reflexes		T8	2 set
			{ spellID = 70855,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Blood Drinker			T10	2P	Bonus
			{ spellID = 61571,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Bleed Cost Reduction	T7	4P	Bonus
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 1715,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Hamstring
			{ spellID = 47465,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Rend
			{ spellID = 7386,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Sunder Armor
			{ spellID = 48669,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Expose Armor
			{ spellID = 6343, 	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Thunder Clap
			{ spellID = 48485,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Infected Wounds
			{ spellID = 1160,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Demoralizing Shout	
			{ spellID = 48560,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Demoralizing Roar
			{ spellID = 50511,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Curse of Weakness
			{ spellID = 676,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Disarm
			{ spellID = 64382,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Shattering Throw
			{ spellID = 355,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Taunt
			{ spellID = 5246,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Intimidating Shout
			{ spellID = 7922,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Charge Stun
			{ spellID = 12323,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Piercing Howl
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce

			
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 3411,	size = 30,	filter = "CD" },	--	Intervene
			{ spellID = 47488,	size = 30,	filter = "CD" },	--	Shield Slam
			{ spellID = 47502,	size = 30,	filter = "CD" },	--	Thunder Clap
			{ spellID = 6552,	size = 30,	filter = "CD" },	--	Pummel
			{ spellID = 72,		size = 30,	filter = "CD" },	--	Shield Bash
			{ spellID = 11578,	size = 30,	filter = "CD" },	--	Charge
			{ spellID = 20252,	size = 30,	filter = "CD" },	--	Intercept
			{ spellID = 23920,	size = 30,	filter = "CD" },	--	Spell Reflection
			{ spellID = 2565,	size = 30,	filter = "CD" },	--	Shield Block
		},
	},
	["SHAMAN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 51532,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Maelstorm Weapon
			{ spellID = 30823,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Shamanistic rage
			{ spellID = 49281,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Lightning Shield
			{ spellID = 57960,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Water Shield	
			{ spellID = 49284,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Earth Shield	 
			{ spellID = 12536,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Clearcasting
			{ spellID = 55166,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Tidal Waves
			{ spellID = 53390,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Tidal forge
			{ spellID = 64701,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Elemental Mastery
			{ spellID = 16188,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Natural Swiftness
			{ spellID = 48066,	unitID = "player",	caster = "all",		filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 16280,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Flurry
			{ spellID = 63283,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Totem of Wrath
			{ spellID = 17364,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Stormstrike
			{ spellID = 2645,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Ghost Wolf
			{ spellID = 70829,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Elemental Rage			T10	2P Bonus
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 17364,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Stormstrike
			{ spellID = 49233,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Flame Shock
			{ spellID = 49236,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost Shock
			{ spellID = 49231,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Earth Shock
			{ spellID = 58799,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frostbroond
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce

		},

		{
			Name = "T_DE/BUFF_BAR",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 186,
			Position = {"LEFT", T_DE_BUFF_BAR_Anchor},
		
			{ spellID = 49231,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Earth Shock
			{ spellID = 49236,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost Shock
			{ spellID = 49233,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Flame Shock
			{ spellID = 58799,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frostbroond
		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 51514,	size = 25,	barWidth =	191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Hex
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 49236,	size = 30,	filter = "CD" },	--	Earth Shock
			{ spellID = 61301,	size = 30,	filter = "CD" },	--	Riptide
			{ spellID = 59159,	size = 30,	filter = "CD" },	--	Thunderstorm
			{ spellID = 60043,	size = 30,	filter = "CD" },	--	Lava Burst
			{ spellID = 60103,	size = 30,	filter = "CD" },	--	Lava Lash
			{ spellID = 49271,	size = 30,	filter = "CD" },	--	Chain Lightning
			{ spellID = 57994,	size = 30,	filter = "CD" },	--	Wind Shear
		},
	},
	["PALADIN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 498,	unitID = "player",	filter = "BUFF" },	--	Divine Protection
			{ spellID = 642,	unitID = "player",	filter = "BUFF" },	--	Divine Shield
			{ spellID = 31884,	unitID = "player",	filter = "BUFF" },	--	Avenging Wrath
			{ spellID = 20216,	unitID = "player",	filter = "BUFF" },	--	Divine Favor
			{ spellID = 31842,	unitID = "player",	filter = "BUFF" },	--	Divine Illumination
			{ spellID = 48066,	unitID = "player",	filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 31850, 	unitID = "player",	filter = "BUFF" },	--	Ardent Defender
			{ spellID = 59578,	unitID = "player",	filter = "BUFF" },	--	The Art of War
			{ spellID = 48952,	unitID = "player",	filter = "BUFF" },	--	Holy Shield
			{ spellID = 54428,	unitID = "player",	filter = "BUFF" },	--	Divine Plea
			{ spellID = 54149,	unitID = "player",	filter = "BUFF" },	--	Infusion of Light
			{ spellID = 64883,	unitID = "player",	filter = "BUFF"	},	--	Aegis		T8	4 set
			{ spellID = 70757,	unitID = "player",	filter = "BUFF" },	--	Holiness	T10	4P Bonus (Holy)
			{ spellID = 70760,	unitID = "player",	filter = "BUFF" },	--	Deliverance	T10	4P Bonus (Prot)
		},
		
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 10308,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Hammer of Justice
			{ spellID = 48817,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Holy Wrath
			{ spellID = 20066,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Repentance
			{ spellID = 20185,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Judgement of Light
			{ spellID = 53408,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Judgement of Wisdom
			{ spellID = 20184,	unitID = "target",	Caster = "player",	filter = "DEBUFF"},	--	Judgement of Justice
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce


		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 4,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 20066,	size = 30,	filter = "CD" },	--	Repentance
			{ spellID = 62124,	size = 30,	filter = "CD" },	--	Hand of Reckoning
			{ spellID = 1044,	size = 30,	filter = "CD" },	--	Hand of Freedom
			{ spellID = 20271,	size = 30,	filter = "CD" },	--	Judgement of Light
			{ spellID = 31789,	size = 30,	filter = "CD" },	--	Righteous Defense
			{ spellID = 48801,	size = 30,	filter = "CD" },	--	Exorcism
			{ spellID = 10308,	size = 30,	filter = "CD" },	--	Hammer of Justice
			{ spellID = 48819,	size = 30,	filter = "CD" },	--	Consecration
			{ spellID = 48806,	size = 30,	filter = "CD" },	--	Hammer of Wrath
			{ spellID = 48825,	size = 30,	filter = "CD" },	--	Holy Shock
			{ spellID = 48952,	size = 30,	filter = "CD" },	--	Holy Shield
			{ spellID = 48827,	size = 30,	filter = "CD" },	--	Avenger's Shield
			{ spellID = 54428,	size = 30,	filter = "CD" },	--	Divine Plea
			{ spellID = 61411,	size = 30,	filter = "CD" },	--	Shield of Righteousness
			{ spellID = 48817,	size = 30,	filter = "CD" },	--	Holy Wrath
			{ spellID = 31821,	size = 30,	filter = "CD" },	--	Aura Mastery
			{ spellID = 35395,	size = 30,	filter = "CD" },	--	Crusader Strike
			{ spellID = 20216,	size = 30,	filter = "CD" },	--	Divine Favor
			{ spellID = 53385,	size = 30,	filter = "CD" },	--	Divine Storm
			{ spellID = 53595,	size = 30,	filter = "CD" },	--	Hammer of the Righteous
		},
	},
	["PRIEST"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},
			
			{ spellID = 48066,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 25222,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Renew
			{ spellID = 586,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Fade
			{ spellID = 6346,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Fear Ward
			{ spellID = 47585,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Dispersion
			{ spellID = 48168,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Inner Fire
			{ spellID = 33151,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Surge of Light
			{ spellID = 63725,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Holy Concentration
			{ spellID = 63734,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Serendipity
			{ spellID = 14751,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Inner Focus
			{ spellID = 27827,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Spirit of Redemption 
			{ spellID = 64911,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Disciplined Power		T8	4 set heal
			{ spellID = 64907,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Devious Mind			T8	4 set Damage
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce


		},	
		{
			Name = "T_DE/BUFF_BAR",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 186,
			Position = {"LEFT", T_DE_BUFF_BAR_Anchor},

			{ spellID = 139,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Renew
			{ spellID = 41637,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Prayer of Mending
			{ spellID = 47788,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Guardian spirit
			{ spellID = 33206,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Pain suspension
			{ spellID = 589,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Shadow Word: Pain
			{ spellID = 2944,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Devouring Plague
			{ spellID = 34914,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Vampiric Touch
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 25384,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Holy Fire
			{ spellID = 15487,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Silence
			{ spellID = 48125,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Shadow Word: Pain
			{ spellID = 48300,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Devouring Plague
			{ spellID = 10890,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Psychic Scream
			{ spellID = 34919,	unitID = "target",	Caster = "player",	filter = "DEBUFF" },	--	Vampire's Touch
			
		},
		
		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "RIGHT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"RIGHT", PVE_PVP_CC_Anchor},

			{ spellID = 10955, size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Shackle undead
			{ spellID = 10890, size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Fear
			{ spellID = 48065, size = 25,	barWidth = 191,	unitID = "player",	caster = "player",	filter = "BUFF" },		--	Power Word: Shield
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 53007,	size = 30,	filter = "CD" },	--	Penance
			{ spellID = 33206,	size = 30,	filter = "CD" },	--	Pain Suppression
			{ spellID = 10060,	size = 30,	filter = "CD" },	--	Power Infusion
			{ spellID = 10890,	size = 30,	filter = "CD" },	--	Psychic Scream
			{ spellID = 48089,	size = 30,	filter = "CD" },	--	Circle of Healing
			{ spellID = 47788,	size = 30,	filter = "CD" },	--	Guardian Spirit
			{ spellID = 48113,	size = 30,	filter = "CD" },	--	Prayer of Mending
			{ spellID = 15487,	size = 30,	filter = "CD" },	--	Silence
			{ spellID = 48066,	size = 30,	filter = "CD" },	--	Power Word: Shield
			{ spellID = 48135,	size = 30,	filter = "CD" },	--	Holy Fire
			{ spellID = 48158,	size = 30,	filter = "CD" },	--	Shadow Word: Death
			{ spellID = 26297,	size = 30,	filter = "CD" },	--	Berserking
			{ spellID = 64901,	size = 30,	filter = "CD" },	--	Hymn of Hope
			{ spellID = 64843,	size = 30,	filter = "CD" },	--	Divine Hymn
			{ spellID = 34433,	size = 30,	filter = "CD" },	--	Shadowfiend
			{ spellID = 47585,	size = 30,	filter = "CD" },	--	Dispersion
			{ spellID = 64044,	size = 30,	filter = "CD" },	--	Psychic Horror
		},
	},
	["WARLOCK"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 63321,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Life Tap
			{ spellID = 70840,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Devious Minds			T10	4P Bonus
			{ spellID = 60062,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Essence of Life
			{ spellID = 47383,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Molten Core
			{ spellID = 63158,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Decimation
			{ spellID = 54277,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Backdraft
			{ spellID = 34939,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Backlash
			{ spellID = 30302,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Nether Protection
			{ spellID = 18095,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Nightfall
			{ spellID = 28610,	unitID = "pet",		caster = "pet",		filter = "BUFF" },	--	Shadow Ward
			{ spellID = 47241,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Metamorphosis
			{ spellID = 50589,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Immolation Aura
			{ spellID = 5697,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Unending Breath
			{ spellID = 61595,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Demonic Soul			T7	2P BONUS
			{ spellID = 61082,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Spirits of the Damned	T7	4P BONUS
		},

		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 47865,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Curse of the Elements
			{ spellID = 11719,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Curse of Tongues
			{ spellID = 18223,	unitID = "target",	caster = "all", 	filter = "DEBUFF" },	--	Curse of Exhaustion
			{ spellID = 50511,	unitID = "target",	caster = "all", 	filter = "DEBUFF" },	--	Curse of Weakness
			{ spellID = 32385,	unitID = "target",	caster = "player",	filter = "BUFF" },		--	Shadow Embrace
			{ spellID = 710,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Banish
			{ spellID = 6215,	unitID = "target",	caster = "pet",		filter = "DEBUFF" },	--	Fear
			{ spellID = 6358,	unitID = "target",	caster = "pet",		filter = "DEBUFF" },	--	charm
			{ spellID = 27223,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Death Coil
			{ spellID = 17928,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Howl of Terror
			{ spellID = 17877,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Shadowburn
			{ spellID = 27215,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Immolate
			{ spellID = 30910,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Curse of Doom
			{ spellID = 27216,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Corruption
			{ spellID = 27218,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Agony
			{ spellID = 30108,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Unstable Afflictions
			{ spellID = 27243,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Seed of Corruption
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce


		},

		{
			Name = "T_DE/BUFF_BAR",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 186,
			Position = {"LEFT", T_DE_BUFF_BAR_Anchor},

			{ spellID = 172,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Corruption
			{ spellID = 348,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Immolate
			{ spellID = 980,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Agony
			{ spellID = 47867,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Doom
			{ spellID = 47843,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Unstable Affliction
			{ spellID = 59164,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Haunt
			{ spellID = 27243,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Seed of Corruption
			{ spellID = 702,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Weakness
			{ spellID = 1714,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Tongues
			{ spellID = 18223,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Curse of Exhaustion
			{ spellID = 6215,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Fear
			{ spellID = 5484,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Howl of Terror
			{ spellID = 6789,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Death Coil
			{ spellID = 710,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Banish
			{ spellID = 1098,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Enslave Demon
			{ spellID = 54785,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Demon Charge
		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 5782,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Fear
			{ spellID = 710,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Banish
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},
			
			{ spellID = 20577,	size = 30,	filter = "CD" },	--	Cannibalize
			{ spellID = 7744,	size = 30,	filter = "CD" },	--	Will of the Forsaken
			{ spellID = 17962,	size = 30,	filter = "CD" },	--	Conflagrate
			{ spellID = 59671,	size = 30,	filter = "CD" },	--	Challenging Howl
			{ spellID = 698,	size = 30,	filter = "CD" },	--	Ritual of Summoning
			{ spellID = 47891,	size = 30,	filter = "CD" },	--	Shadow Ward
			{ spellID = 1122,	size = 30,	filter = "CD" },	--	Inferno
			{ spellID = 47193,	size = 30,	filter = "CD" },	--	Demonic Empowerment
			{ spellID = 54785,	size = 30,	filter = "CD" },	--	Demon Charge
			{ spellID = 18540,	size = 30,	filter = "CD" },	--	Ritual of Doom
			{ spellID = 50581,	size = 30,	filter = "CD" },	--	Shadow Cleave
			{ spellID = 29858,	size = 30,	filter = "CD" },	--	Soulshatter
			{ spellID = 58887,	size = 30,	filter = "CD" },	--	Ritual of Souls
			{ spellID = 48020,	size = 30,	filter = "CD" },	--	Demonic Circle: Teleport
			{ spellID = 17928,	size = 30,	filter = "CD" },	--	Howl of Terror
			{ spellID = 47860,	size = 30,	filter = "CD" },	--	Death Coil
			{ spellID = 59164,	size = 30,	filter = "CD" },	--	Haunt	
			{ spellID = 47867,	size = 30,	filter = "CD" },	--	Curse of Doom
			{ spellID = 47827,	size = 30,	filter = "CD" },	--	Shadowburn
			{ spellID = 47847,	size = 30,	filter = "CD" },	--	Shadowfury
			{ spellID = 59172,	size = 30,	filter = "CD" },	--	Chaos Bolt
			{ spellID = 61290,	size = 30,	filter = "CD" },	--	Shadowflame
			{ spellID = 18708,	size = 30,	filter = "CD" },	--	Fel Domination
			{ spellID = 4511,	size = 30,	filter = "CD" },	--	Phase Shift (Imp)
			{ spellID = 47986,	size = 30,	filter = "CD" },	--	Sacrifice (Voidwalker)
			{ spellID = 47990,	size = 30,	filter = "CD" },	--	Suffering (Voidwalker)
			{ spellID = 19647,	size = 30,	filter = "CD" },	--	Spell Lock (Felhunter)
			{ spellID = 48011,	size = 30,	filter = "CD" },	--	Devour Magic (Felhunter)
			{ spellID = 47996,	size = 30,	filter = "CD" },	--	Intercept (Felguard)
		},
	},
	["ROGUE"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},
			
			{ spellID = 1784,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Stealth
			{ spellID = 31224,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Cloak of Shadows
			{ spellID = 2983,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Sprint
			{ spellID = 5277,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Evasion
			{ spellID = 58426,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Overkill
			{ spellID = 51713,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Shadowdance
			{ spellID = 31665,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Master of Subtlety
			{ spellID = 63848,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Hunger For Blood
			{ spellID = 5171,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Slice and Dice
			{ spellID = 26888,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Vanish
			{ spellID = 13750,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Adrenaline Rush
			{ spellID = 13877,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Blade Flurry
			{ spellID = 51690,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Killing Spree
			{ spellID = 14177,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Cold Blood
			{ spellID = 48066,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Power Word: Shield
			{ spellID = 48659,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Feint Mitigation
			{ spellID = 45182,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Cheating Death
			{ spellID = 14278,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Ghostly Strike
			{ spellID = 51627,	unitID = "player",	caster = "Player",	filter = "BUFF" },	--	Turn the Tables
		},
				
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 48672,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Rupture
			{ spellID = 48676,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Garrote
			{ spellID = 408,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Kidney shot
			{ spellID = 1776,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Gouge
			{ spellID = 1833,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Cheap shot 
			{ spellID = 2094,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Blind
			{ spellID = 6770,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Sap		
			{ spellID = 8647,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Expose Armor
			{ spellID = 7386,	unitID = "target",	caster = "all",		filter = "DEBUFF" },	--	Sunder Armor
			{ spellID = 51722,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Dismantle	
		},

		{
			Name = "PVE/PVP_CC",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 189,
			Position = {"LEFT", PVE_PVP_CC_Anchor},

			{ spellID = 2094,	size = 25,	barWidth = 191,	unitID = "focus",	caster = "player",	filter = "DEBUFF" },	--	Blind
		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 1766, size = 30, filter = "CD" },	--	Kick
			{ spellID = 1776, size = 30, filter = "CD" },	--	Gouge
			{ spellID = 8643, size = 30, filter = "CD" },	--	Kidney shot
			{ spellID = 1784, size = 30, filter = "CD" },	--	Stealth
			{ spellID = 1856, size = 30, filter = "CD" },	--	Vanish
		},
	},
	["DEATHKNIGHT"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_BUFF_ICON_Anchor},

			{ spellID = 67383,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Unholy Force
			{ spellID = 66817,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Desolation
			{ spellID = 65014,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Pyrite Infusion
			{ spellID = 49028,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Dancing Rune Weapon
			{ spellID = 51124,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Killing machine
			{ spellID = 59052,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Freezing fog
			{ spellID = 63560,	unitID = "pet",		caster = "player",	filter = "BUFF" },	--	Ghoul Frenzy
			{ spellID = 47568,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Empower Rune Weapon
			{ spellID = 55233,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Vampire Blood
			{ spellID = 48707,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Anti-Magic Shield
			{ spellID = 48792,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Icebound Fortitude
			{ spellID = 51271,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Unbreakable Armor
			{ spellID = 49796,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Deathchill
			{ spellID = 48743,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Death Pact
			{ spellID = 42650,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Army of the Death
			{ spellID = 49005,	unitID = "target",	caster = "player",	filter = "DEBUFF"},	--	Mark of Blood
			{ spellID = 61606,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Mark of Blood	
			{ spellID = 64858,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Blade Barrier
			{ spellID = 49222,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Bone Shield
			{ spellID = 49039,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	LichBorne
			{ spellID = 42650,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Army of the Dead
			{ spellID = 67115,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Unholy Might			T9	2P Bonus
			{ spellID = 70657,	unitID = "player",	caster = "player",	filter = "BUFF" },	--	Advantage				T10	4P Bonus
		},
				{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", T_DEBUFF_ICON_Anchor},

			{ spellID = 55078,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Blood Plague
			{ spellID = 55095,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost Fever
			{ spellID = 56222,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Dark Command
			{ spellID = 45524,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Chains of Ice
			{ spellID = 49194,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Unholy Blight
			{ spellID = 49206,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Summon Gargoyled
		},

		{
			Name = "T_DE/BUFF_BAR",
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = 25,
			BarWidth = 186,
			Position = {"LEFT", T_DE_BUFF_BAR_Anchor},

			{ spellID = 59879,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Blood Plague
			{ spellID = 59921,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Frost Fever
			{ spellID = 49194,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Unholy Blight
			{ spellID = 49206,	size = 25,	barWidth = 187,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Summon Gargoyle
		},

		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", P_PROC_ICON_Anchor},
			{ spellID = 27006,	unitID = "target",	caster = "player",	filter = "DEBUFF" },	--	Pounce


		},

		{
			Name = "COOLDOWN",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 6,
			Alpha = 1,
			IconSize = C.Filger.CooldownSize,
			Position = {"TOP", COOLDOWN_Anchor},

			{ spellID = 49206,	size = 30,	filter = "CD" },	--	Summon Gargoyle
			{ spellID = 47481,	size = 30,	filter = "CD" },	--	Gnaw
			{ spellID = 47476,	size = 30,	filter = "CD" },	--	Strangulate
			{ spellID = 47528,	size = 30,	filter = "CD" },	--	Mind Freeze
		},
	},
	["ALL"] = {
		{
			Name = "PVE/PVP_DEBUFF",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.PvPSize,
			Position = {"TOP", PVE_PVP_DEBUFF_Anchor},

			-- Death Knight
			{ spellID = 47481,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gnaw (Ghoul)
			{ spellID = 47476,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Strangulate
			{ spellID = 45524,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Chains of Ice
			{ spellID = 55741,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Desecration (no duration, lasts as long as you stand in it)
			{ spellID = 58617,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Glyph of Heart Strike
			{ spellID = 50436,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Icy Clutch (Chilblains)
			{ spellID = 51209,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Hungering Cold
			
			-- Druid
			{ spellID = 33786,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Cyclone
			{ spellID = 2637,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Hibernate
			{ spellID = 5211,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Bash
			{ spellID = 22570,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Maim
			{ spellID = 9005,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Pounce
			{ spellID = 339,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Entangling Roots
			{ spellID = 45334,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Feral Charge Effect
			{ spellID = 58179,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Infected Wounds

			-- Hunter
			{ spellID = 3355,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Freezing Trap Effect
			{ spellID = 60210,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Freezing Arrow Effect
			{ spellID = 1513,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Scare Beast
			{ spellID = 19503,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Scatter Shot
			{ spellID = 53359,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Chimera Shot - Scorpid
			{ spellID = 50541,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Snatch (Bird of Prey)
			{ spellID = 34490,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Silencing Shot
			{ spellID = 24394,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Intimidation
			{ spellID = 50519,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Sonic Blast (Bat)
			{ spellID = 50518,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Ravage (Ravager)
			{ spellID = 35101,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Concussive Barrage
			{ spellID = 5116,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Concussive Shot
			{ spellID = 13810,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Frost Trap Aura
			{ spellID = 61394,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Glyph of Freezing Trap
			{ spellID = 2974,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Wing Clip
			{ spellID = 19306,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Counterattack
			{ spellID = 19185,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Entrapment
			{ spellID = 50245,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Pin (Crab)
			{ spellID = 54706,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Venom Web Spray (Silithid)
			{ spellID = 4167,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Web (Spider)
			{ spellID = 51209,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Froststorm Breath (Chimera)
			{ spellID = 51209,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Tendon Rip (Hyena)

			-- Mage
			{ spellID = 31661,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Dragon's Breath
			{ spellID = 118,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Polymorph
			{ spellID = 18469,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Silenced - Improved Counterspell
			{ spellID = 44572,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Deep Freeze
			{ spellID = 33395,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Freeze (Water Elemental)
			{ spellID = 122,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Frost Nova
			{ spellID = 55080,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Shattered Barrier
			{ spellID = 6136,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Chilled
			{ spellID = 120,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Cone of Cold
			{ spellID = 31589,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Slow

			-- Paladin
			{ spellID = 20066,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Repentance
			{ spellID = 10326,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Turn Evil
			{ spellID = 63529,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Shield of the Templar
			{ spellID = 853,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Hammer of Justice
			{ spellID = 2812,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Holy Wrath
			{ spellID = 20170,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Stun (Seal of Justice proc)
			{ spellID = 31935,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Avenger's Shield
			
			-- Priest
			{ spellID = 64058,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Psychic Horror
			{ spellID = 605,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Mind Control
			{ spellID = 64044,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Psychic Horror
			{ spellID = 8122,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Psychic Scream
			{ spellID = 15487,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Silence
			{ spellID = 15407,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Mind Flay

			-- Rogue
			{ spellID = 51722,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Dismantle
			{ spellID = 2094,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Blind
			{ spellID = 1776,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gouge
			{ spellID = 6770,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Sap
			{ spellID = 1330,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Garrote - Silence
			{ spellID = 18425,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Silenced - Improved Kick
			{ spellID = 1833,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Cheap Shot
			{ spellID = 408,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Kidney Shot
			{ spellID = 31125,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Blade Twisting
			{ spellID = 3409,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Crippling Poison
			{ spellID = 26679,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Deadly Throw

			-- Shaman
			{ spellID = 51514,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Hex
			{ spellID = 64695,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Earthgrab
			{ spellID = 63685,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Freeze
			{ spellID = 39796,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Stoneclaw Stun
			{ spellID = 3600,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Earthbind
			{ spellID = 8056,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Frost Shock

			-- Warlock
			{ spellID = 710,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Banish
			{ spellID = 6789,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Death Coil
			{ spellID = 5782,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Fear
			{ spellID = 5484,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Howl of Terror
			{ spellID = 6358,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Seduction (Succubus)
			{ spellID = 24259,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Spell Lock (Felhunter)
			{ spellID = 30283,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Shadowfury
			{ spellID = 30153,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Intercept (Felguard)
			{ spellID = 18118,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Aftermath
			{ spellID = 18223,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Curse of Exhaustion

			-- Warrior
			{ spellID = 20511,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Intimidating Shout
			{ spellID = 676,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Disarm
			{ spellID = 18498,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Silenced (Gag Order)
			{ spellID = 7922,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Charge Stun
			{ spellID = 12809,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Concussion Blow
			{ spellID = 20253,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Intercept
			{ spellID = 12798,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Revenge Stun
			{ spellID = 46968,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Shockwave
			{ spellID = 58373,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Glyph of Hamstring
			{ spellID = 23694,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Improved Hamstring
			{ spellID = 1715,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Hamstring
			{ spellID = 12323,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Piercing Howl
			
			-- Racials
			{ spellID = 20549,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	War Stomp

			-- Raid Auras
				--TOC
			{ spellID = 66406,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Snobolled!
			{ spellID = 67477,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Impale
			{ spellID = 67618,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Paralytic Toxin
			{ spellID = 66869,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Burning Bite
			{ spellID = 68126,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Legion Flame
			{ spellID = 67049,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Incinerate Flesh
				--ICC
			{ spellID = 72865,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Death Plague
			{ spellID = 71204,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Touch of Insignificance (LDW)
			{ spellID = 71237,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Curse of Torpor(LDW)
			{ spellID = 72293,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Mark of the Fallen Champion (DBS)
			{ spellID = 72443,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Rolling Blood	(DBS)
			{ spellID = 72410,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Rune of Blood	(DBS)
			{ spellID = 69278,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gas Spore (Festergut)
			{ spellID = 72219,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gastric Bloat (Festergut)
			{ spellID = 72103,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Inoculated (Festergut)
			{ spellID = 71224,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Mutated Infection (Rotface)
			{ spellID = 72856,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Unbound Plague (Professor Putricide)
			{ spellID = 70353,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gas Variable (Professor Putricide)
			{ spellID = 72858,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Gaseous Bloat (Professor Putricide)
			{ spellID = 70352,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Ooze Variable (Professor Putricide)
			{ spellID = 72836,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Volatile Ooze Adhesive (Professor Putricide)
			{ spellID = 72458,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Malleable Goo (Professor Putricide)
			{ spellID = 69778,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Sticky Ozee (Professor Putricide)
			{ spellID = 72460,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Choking Gas (Professor Putricide)
			{ spellID = 70423,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Vampiric Curse (Bloodqueen Queen Prince)
			{ spellID = 70445,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Blood Mirror (Bloodqueen Queen Prince)
			{ spellID = 70432,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Blood Sap (Bloodqueen Queen Prince)
			{ spellID = 72999,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Shadow Prison (Bloodqueen Queen Prince)
			{ spellID = 70877,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Frenzied Bloodthirst (Bloodqueen Lana'thel)
			{ spellID = 71340,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Pact of the Darkfallen (Bloodqueen Lana'thel)
			{ spellID = 71861,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Swarming Shadows (Bloodqueen Lana'thel)
			{ spellID = 71473,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Essence of the Blood Queen (Bloodqueen Lana'thel)
			{ spellID = 71053,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Frost Bomb (Sindragosa)
			{ spellID = 69766,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Instability (Sindragosa)
			{ spellID = 69762,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Unchained Magic (Sindragosa)
			{ spellID = 70128,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Mystic Buffet (Sindragosa)
			{ spellID = 70106,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Chilled of the Bone (Sindragosa)
			{ spellID = 73912,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Necrotic Plague (Arthas - The Lich King)
			{ spellID = 73788,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Pain and Suffering (Arthas - The Lich King)
			{ spellID = 73797,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Soul Reaper (Arthas - The Lich King)
			{ spellID = 69242,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Soul Shirek (Arthas - The Lich King)
				--Ruby Sanctum
			{ spellID = 74562,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Fiery Combustion (Halion)
			{ spellID = 74792,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Soul Consumption (Halion)
			{ spellID = 74453,	size = 51,	unitID = "player",	caster = "all",	filter = "DEBUFF" },	--	Flame Beacon (General)
			--Player Important Aura
			{ spellID = 34074,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Aspect of the Viper
			{ spellID = 13159,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Aspect of the Pack
			{ spellID = 29166,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF"	},		--	Innervate
			{ spellID = 23920,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Spell Reflection
			{ spellID = 31821,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Aura Mastery
			{ spellID = 45438,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Ice Block
			{ spellID = 31224,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Cloak of Shadows
			{ spellID = 642,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Divine Shield
			{ spellID = 19263,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Deterrence
			{ spellID = 48707,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Anti-Magic Shell
			{ spellID = 49039,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Lichborne
			{ spellID = 1044,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Hand of Freedom
			{ spellID = 6940,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Hand of Sacrifice
			{ spellID = 8178,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Grounding Totem Effect
			{ spellID = 33206,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Pain Suppression
			{ spellID = 47788,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Guardian Spirit
			{ spellID = 1038,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Hand of Salvation
			{ spellID = 64205,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Divine Sacrifice
			{ spellID = 50461,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Anti-Magic Zone
			{ spellID = 26983,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Tranquility
			{ spellID = 64844,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Divine Hymn
			{ spellID = 64904,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Hymn of Hope
			{ spellID = 49016,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Hysteria
			{ spellID = 10060,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Power Infusion
			{ spellID = 32182,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Heroism
			{ spellID = 2825,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Bloodlust
			{ spellID = 57934,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Tricks of the Trade
			{ spellID = 41635,	size = 51,	unitID = "player",	caster = "all",	filter = "BUFF" },		--	Prayer of Mending

		},
		{
			Name = "T_BUFF",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.PvPSize,
			Position = {"TOP", T_BUFF_Anchor},

			--Target Important Aura
			{ spellID = 34074,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Aspect of the Viper
			{ spellID = 13159,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Aspect of the Pack
			{ spellID = 29166,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF"	},		--	Innervate
			{ spellID = 23920,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Spell Reflection
			{ spellID = 31821,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Aura Mastery
			{ spellID = 45438,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Ice Block
			{ spellID = 31224,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Cloak of Shadows
			{ spellID = 642,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Divine Shield
			{ spellID = 19263,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Deterrence
			{ spellID = 48707,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Anti-Magic Shell
			{ spellID = 49039,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Lichborne
			{ spellID = 1044,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Hand of Freedom
			{ spellID = 6940,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Hand of Sacrifice
			{ spellID = 8178,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Grounding Totem Effect
			{ spellID = 33206,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Pain Suppression
			{ spellID = 47788,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Guardian Spirit
			{ spellID = 1038,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Hand of Salvation
			{ spellID = 64205,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Divine Sacrifice
			{ spellID = 50461,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Anti-Magic Zone
			{ spellID = 26983,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Tranquility
			{ spellID = 64844,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Divine Hymn
			{ spellID = 64904,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Hymn of Hope
			{ spellID = 49016,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Hysteria
			{ spellID = 10060,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Power Infusion
			{ spellID = 32182,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Heroism
			{ spellID = 2825,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Bloodlust
			{ spellID = 57934,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Tricks of the Trade
			{ spellID = 41635,	size = 51,	unitID = "target",	caster = "all",	filter = "BUFF" },		--	Prayer of Mending

		},
		
		{
			Name = "SPECIAL_P_BUFF_ICON_Anchor",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = C.Filger.BuffsSize,
			Position = {"TOP", SPECIAL_P_BUFF_ICON_Anchor},
			
			-- AP Trinket --
			{ spellID = 71541,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Icy Rage
			{ spellID = 67703,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Paragon
			{ spellID = 75458,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Piercing Twilight
			{ spellID = 62115,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Strength of the Titans
			{ spellID = 59818,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Frenzyheart Fury
			{ spellID = 58904,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Tears of Anguish
			{ spellID = 57351,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Berserker!
			{ spellID = 57350,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Illusionary Barrier
			{ spellID = 60439,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Loatheb's Shadow
			{ spellID = 60305,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Heart of a Dragon
			{ spellID = 60301,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Meteorite Whetstone
			{ spellID = 60299,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Incisor Fragment
			{ spellID = 63251,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Glory of the Jouster
			{ spellID = 59658,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Argent Heroism
			{ spellID = 47806,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Towering Rage
			{ spellID = 50263,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Quickness of the Sailor
			{ spellID = 64524,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Platinum Disks of Battle
			{ spellID = 60313,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Fury of the Five Flights
			{ spellID = 60436,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Grim Toll
			{ spellID = 60319,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Mark of Norgannon
			{ spellID = 65014,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Pyrite Infusion
			{ spellID = 65024,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Implosion
			{ spellID = 65019,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Mjolnir Runestone
			{ spellID = 64790,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Blood of the Old God
			{ spellID = 64800,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Wrathstone
			{ spellID = 64772,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Comet's Trail
			{ spellID = 71403, 	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Fatal Flaws
			{ spellID = 67683,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Celerity
			{ spellID = 67695,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Rage
			{ spellID = 67738,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Rising Fury
			{ spellID = 60233,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Greatness
			{ spellID = 71396,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Rage of the Fallen
			{ spellID = 71486,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Power of the Taunka
			{ spellID = 71485,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Agility of the Vrykul
			{ spellID = 71492,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Speed of the Vrykul
			{ spellID = 71491,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Aim of the Iron Dwarves
			{ spellID = 71484,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Strength of the Taunka
			{ spellID = 71487,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Precision of the Iron Dwarves
			{ spellID = 60065,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Reflection of Torment
			{ spellID = 67746,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Risen Fury
			-- SP Trinkets
			{ spellID = 64714,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Flame of the Heavens
			{ spellID = 60063,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Now is the Time!
			{ spellID = 67669,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Elusive Power
			{ spellID = 62114,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Flow of Knowledge
			{ spellID = 60524,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Majestic Dragon Figurine
			{ spellID = 60527,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Essence Flow
			{ spellID = 60490,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Embrace of the Spider
			{ spellID = 49623,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Effervescence
			{ spellID = 60519,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Spark of Life
			{ spellID = 60473,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Forge Ember
			{ spellID = 60517,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Talisman of Troll Divinity
			{ spellID = 60521,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Winged Talisman
			{ spellID = 60480,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Mark of the War Prisoner
			{ spellID = 56184,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Twilight Serpent
			{ spellID = 56186,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Sapphire Owl
			{ spellID = 60471,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Tome of Arcane Phenomena
			{ spellID = 60510,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Soul Preserver
			{ spellID = 59657,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Argent Valor
			{ spellID = 54808,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Sonic Shield
			{ spellID = 47807,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Healing Focus
			{ spellID = 47816,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Spell Power
			{ spellID = 50261,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Nimble Fingers
			{ spellID = 64527,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Platinum Disks of Swiftness
			{ spellID = 64525,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Platinum Disks of Sorcery
			{ spellID = 60485,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Illustration of the Dragon Soul
			{ spellID = 60493,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Dying Curse
			{ spellID = 65005,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Alacrity of the Elements
			{ spellID = 65007,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Eye of the Broodmother
			{ spellID = 65008,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Energy Siphon
			{ spellID = 64999,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Meteoric Inspiration
			{ spellID = 65003,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Memories of Love
			{ spellID = 64742,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Pandora's Plea
			{ spellID = 64707,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Scale of Fates
			{ spellID = 64712,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Living Flame
			{ spellID = 64739,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Show of Faith
			{ spellID = 71568,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Urgency
			{ spellID = 71563,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Deadly Precision
			{ spellID = 67684,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Hospitality
			{ spellID = 67736,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Volatile Power
			{ spellID = 67726,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Escalating Power
			{ spellID = 67696,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Energized
			{ spellID = 71584,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Revitalized
			{ spellID = 71605,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Siphoned Power
			{ spellID = 71643,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Surging Power
			{ spellID = 75493,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Twilight Renewal
			{ spellID = 33953,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Essence of Life
			{ spellID = 67759,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Shard of Flame
			{ spellID = 71644,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Surge of Power
			{ spellID = 75473,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Twilight Flames
			-- Tank Trinket
			{ spellID = 68443,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Drunken Evasiveness
			{ spellID = 67631,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Aegis
			{ spellID = 60054,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Valor Medal of the First War
			{ spellID = 60180,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Resolute
			{ spellID = 60221,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Essence of Gossamer
			{ spellID = 60215,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Lavanthor's Talisman
			{ spellID = 56121,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Ruby Hare
			{ spellID = 59757,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Figurine - Monarch Crab
			{ spellID = 60214,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Seal of the Pantheon
			{ spellID = 54707,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Sonic Awareness DND
			{ spellID = 60258,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Rune of Repulsion
			{ spellID = 60286,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Defender's Code
			{ spellID = 65012,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Gamon's Heroic Spirit
			{ spellID = 65011,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Furnace Stone
			{ spellID = 64764,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	The General's Heart
			{ spellID = 64763,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Heart of Iron
			{ spellID = 71569,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Increased Fortitude
			{ spellID = 67694,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Defensive Tactics
			{ spellID = 67728,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Hardening Armor
			{ spellID = 71586,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Hardened Skin
			{ spellID = 71575,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Invigorened
			{ spellID = 71635,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Aegis of Dalaran
			{ spellID = 71633,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Thick Skin
			{ spellID = 75477,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Scaly Nimbleness
			{ spellID = 67727,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Hardened		
			-- Rings
			{ spellID = 35084,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Band of the Eternal Sage
			{ spellID = 35081,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Band of the Eternal Champion
			{ spellID = 35087,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Band of the Eternal Restorer
			{ spellID = 35078,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Band of the Eternal Defender
			{ spellID = 72412,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Frostforged Champion
			{ spellID = 72414,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Frostforged Defender
			{ spellID = 72416,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Frostforged Sage
			{ spellID = 72418,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Chilling Knowledge
			{ spellID = 60318,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Edward's Insight
				-- Proff Skill
			{ spellID = 54758,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Hyperspeed Acceleration
			{ spellID = 55775,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Swordguard Embroidery
			{ spellID = 55637,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Lightweave
			{ spellID = 55379,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Skyflare Swiftness
				-- Racial buff
			{ spellID = 20572,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Blood Fury
			{ spellID = 58984,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Shadowmeld
			{ spellID = 59547,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Gift of the Naaru
			{ spellID = 26297,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Berserking
			{ spellID = 65116,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Stoneform	
				-- Raid buff

				--Weapon enchant
			{ spellID = 59620,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Berserking
			{ spellID = 28093,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Mongoose
			{ spellID = 42976,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Executioner
			{ spellID = 59626,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Black Magic
			{ spellID = 64568,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Blood Reserve
			{ spellID = 64440,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Blade Warding
			{ spellID = 53365,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Unholy Strength
			{ spellID = 53386,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Cinderglacier
				--Potion 
			{ spellID = 53908,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Haste Potion
			{ spellID = 28508,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Destruction Potion
			{ spellID = 53762,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Indestructible
			{ spellID = 28507,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Haste Potion
			{ spellID = 53909,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Wild Magic
			{ spellID = 28714,	unitID = "player",	caster = "all",	filter = "BUFF" },	--	Flame Cap
			
			
		},

	},
}