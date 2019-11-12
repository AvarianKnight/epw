EPW = EPW or {}
EPW.cfg = EPW.cfg or {}
EPW.f = EPW.f or {}

function disallowEntityPurchase(ply, entTable)
	if EPW.cfg.disabledEntities[entTable.ent] then
		return false, false, "Sorry this entity is currently disabled."
	end
end
hook.Add("canBuyCustomEntity", "EPW.ent.disallowEntityPurchase", disallowEntityPurchase)

function setOwner(ply, entityTable, ent, price)
	if EPW.cfg.dontSetEntOwner[ent:GetClass()] then return end
	ent:CPPISetOwner(ply)
	ent.customEntity = true
end
hook.Add("playerBoughtCustomEntity", "EPW.ent.setOwner", setOwner)

function allowPhysgunPickup(ply, ent)
	ply.EPWNotify = ply.EPWNotify or 0
	if EPW.cfg.physgunPickupBlacklist[ent:GetClass()] or ent.PhysgunDisable then
		if ply.EPWNotify < CurTime() then
			DarkRP.notify(ply, NOTIFY_ERROR, 3, "You can't physgun the entity '" .. ent:GetClass() .. "' try to use the gravity gun!")
			ply.EPWNotify = CurTime() + EPW.cfg.notifyCooldown
		end
		return false
	end
end
hook.Add("PhysgunPickup", "EPW.ent.allowPhysgunPickup", allowPhysgunPickup)

function allowGravityGunPickup(ply, ent)
	if ent.customEntity then return true end
end
hook.Add("GravGunPickupAllowed", "EPW.ent.allowGravityGunPickup", allowGravityGunPickup)

function disallowFreeze(weapon, physobj, ent, ply)
	ent.EPWEPhysgunDisabled = ent.EPWEPhysgunDisabled or ent.PhysgunDisable or true
	if ent.customEntity and EPW.cfg.physgunFreezeWhitelist[ent:GetClass()] or not ent.EPWEPhysgunDisabled then
		ent:GetPhysicsObject():EnableMotion(false)
		return true
	elseif ent.customEntity then
		return false
	end
end
hook.Add("OnPhysgunFreeze", "EPW.ent.disallowFreeze", disallowFreeze)

function disallowCustomEntSpawn(ply, enttable)
	if ply.jail then return false, false, "You cannot buy entities while jailed!" end
end
hook.Add("canBuyCustomEntity", "EPW.jail.disallowCustomEntSpawn", disallowCustomEntSpawn)

function disallowPropSpawn(ply)
	if ply.jail then
		ply.EPWNotify = ply.EPWNotify or 0
		if ply.EPWNotify < CurTime() then
			DarkRP.notify(ply, NOTIFY_ERROR, 3, "You cannot spawn props while jailed!")
			ply.EPWNotify = CurTime() + EPW.cfg.notifyCooldown
		end
		return false
	end
end
hook.Add("PlayerSpawnProp", "EPW.jail.disallowPropSpawn", disallowPropSpawn)