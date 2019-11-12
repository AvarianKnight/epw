util.AddNetworkString("EPW.n.contextMenu")
EPW.f = EPW.f or {}

-- shamelessly ripped from APG
function saveSettings( json )
	if not file.Exists("EPWcem", "DATA") then file.CreateDir( "EPWcem" ) end
	file.Write("EPWcem/settings.txt", json)
end

function EPW.f.contextMenu(len, ply)
	if not ply:IsSuperAdmin() then return false end
	local funcNumber = net.ReadUInt(4)
	local ent = net.ReadEntity()
	if not IsValid(ent) then
		DarkRP.notify(ply, NOTIFY_ERROR, 5, "That is not a valid entity!")
		return
	end
	local contextFunctions = {
		[1] = function(ply, ent)
			EPW.cfg.physgunFreezeWhitelist[ent:GetClass()] = true
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity added to whitelist.")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[2] = function(ply, ent)
			if not EPW.cfg.physgunFreezeWhitelist[ent:GetClass()] then
				DarkRP.notify(ply, NOTIFY_ERROR, 5, "This entity is not in the whitelist!")
				return
			end
			EPW.cfg.physgunFreezeWhitelist[ent:GetClass()] = nil
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity removed from the whitelist.")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[3] = function(ply, ent)
			EPW.cfg.physgunPickupBlacklist[ent:GetClass()] = true
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity added to physgun blacklist.")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[4] = function(ply, ent)
			if not EPW.cfg.physgunPickupBlacklist[ent:GetClass()] then
				DarkRP.notify(ply, NOTIFY_ERROR, 5, "This entity is not in the blacklist!")
				return
			end
			EPW.cfg.physgunPickupBlacklist[ent:GetClass()] = nil
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity removed from physgun blacklist.")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[5] = function(ply, ent)
			EPW.cfg.dontSetEntOwner[ent:GetClass()] = true
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity added to the 'Dont set Entity owner' table")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[6] = function(ply, ent)
			if not EPW.cfg.dontSetEntOwner[ent:GetClass()] then
				DarkRP.notify(ply, NOTIFY_ERROR, 5, "This entity is not in this table!")
				return
			end
			EPW.cfg.physgunPickupBlacklist[ent:GetClass()] = nil
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity removed from the 'Dont set Entity owner' table")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[7] = function(ply, ent)
			EPW.cfg.disabledEntities[ent:GetClass()] = true
			DarkRP.notify(ply, NOTIFY_ERROR, 5, "Entity added to disabled entites blacklist. (ARE YOU SURE?)")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
		[8] = function(ply, ent)
			if not EPW.cfg.disabledEntities[ent:GetClass()] then
				DarkRP.notify(ply, NOTIFY_ERROR, 5, "This entity is not in the disabled entites blacklist!")
				return
			end
			EPW.cfg.disabledEntities[ent:GetClass()] = nil
			DarkRP.notify(ply, NOTIFY_HINT, 5, "Entity removed from the disabled entites blacklist.")
			local updatedSettings = util.TableToJSON(EPW.cfg)
			saveSettings(updatedSettings)
		end,
	}
	
	contextFunctions[funcNumber](ply, ent)
end
net.Receive("EPW.n.contextMenu", EPW.f.contextMenu)
