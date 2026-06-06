local V, C, L, _ = select(2, ...):unpack()

-- Per Class Config (overwrites general)
-- Class Type need to be UPPERCASE -- DRUID, MAGE ect ect...
if V.Class == "DRUID" then
end

if V.Role == "Tank" then
end

-- Per Character Name Config (overwrite general and class)
-- Name need to be case sensitive
if V.Name == "CharacterName" then
end

-- Per Max Character Level Config (overwrite general, class and name)
if V.Level ~= MAX_PLAYER_LEVEL then
end

-- Magicnachos Personal Config
if (V.Name == "Magicnachos" or V.Name == "Bootyshorts") and (V.Realm == "Icecrown") then

end

-- Vermilion Personal Config
if (V.Name == "Vermilion" or V.Name == "Rollndots" or V.Name == "Safeword" or V.Name == "Broflex" or V.Name == "Broflexin") and (V.Realm == "Icecrown") then

end