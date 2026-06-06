----------------------------------------------------------
-- Root Database
----------------------------------------------------------

VermilionDB = VermilionDB or {}

----------------------------------------------------------
-- Tables
----------------------------------------------------------

VermilionDB.Profiles       = VermilionDB.Profiles or {}
VermilionDB.ActiveProfiles = VermilionDB.ActiveProfiles or {}
VermilionDB.CharacterData  = VermilionDB.CharacterData or {}
VermilionDB.Movers         = VermilionDB.Movers or {}
VermilionDB.GUI            = VermilionDB.GUI or {}
VermilionDB.Installer      = VermilionDB.Installer or {}

----------------------------------------------------------
-- Metadata
----------------------------------------------------------

VermilionDB.Version = VermilionDB.Version or 1

----------------------------------------------------------
-- API
----------------------------------------------------------

V.DB = VermilionDB

V.DB.Character = V.DB.CharacterData