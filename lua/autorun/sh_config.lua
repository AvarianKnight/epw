EPW = EPW or {}

EPW.cfg = EPW.cfg or {}

EPW.cfg.physgunFreezeWhitelist = {
	-- use ingame whitlisting
} -- anything in here overrides

EPW.cfg.physgunPickupBlacklist = {}

EPW.cfg.dontSetEntOwner = {}

EPW.cfg.disabledEntities = {}

EPW.cfg.notifyCooldown = 10

if not file.Exists("EPW/settings.txt", "DATA") then
	file.CreateDir( "EPW" ) 
	local settings = util.TableToJSON(EPW.cfg)
	file.Write("EPW/settings.txt", settings)
else
	local settingsInJson = file.Read("EPW/settings.txt", "DATA")
	local jsonToTable = util.JSONToTable(settingsInJson)

	table.Merge(EPW.cfg, jsonToTable)
end
