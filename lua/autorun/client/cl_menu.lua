properties.Add( "EPWoptions", {
	MenuLabel = "EPW Options", -- Name to display on the context menu
	Order = 500, -- The order to display this property relative to other properties
	MenuIcon = "icon16/fire.png", -- The icon to display next to the property

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
		if not ply:IsSuperAdmin() then return false end
		if not IsValid(ent) then return false end
		if not ent:GetClass() then return false end
		if ent:EntIndex() < 0 then return false end

		return true
	end,
	MenuOpen = function( self, option, ent, tr )
		local submenu = option:AddSubMenu()
		local function addoption( str, data )
			local menu = submenu:AddOption( str, data.callback )

			if data.icon then
				menu:SetImage( data.icon )
			end

			return menu
		end

		addoption( "Add this entity class to the Physgun Freeze Whitelist", {
			icon = "icon16/tick.png",
			callback = function() self:EPWcmd( ent, 1 ) end,
		})

		addoption( "Remove this entity class from the Physgun Freeze Whitelist", {
			icon = "icon16/cross.png",
			callback = function() self:EPWcmd( ent, 2 ) end,
		})

		submenu:AddSpacer()

		addoption( "Add this entity class to the Physgun Pickup Blacklist", {
			icon = "icon16/cross.png",
			callback = function() self:EPWcmd( ent, 3 ) end,
		})

		addoption( "Remove this entity class from the Physgun Pickup Blacklist", {
			icon = "icon16/tick.png",
			callback = function() self:EPWcmd( ent, 4 ) end,
		})

		submenu:AddSpacer()

		addoption( "Add this entity class to the 'Dont set entity owner' table", {
			icon = "icon16/cross.png",
			callback = function() self:EPWcmd( ent, 5 ) end,
		})

		addoption( "Remove this entity class to the 'Dont set entity owner' table", {
			icon = "icon16/tick.png",
			callback = function() self:EPWcmd( ent, 6 ) end,
		})

		submenu:AddSpacer()

		addoption( "Disallow this entity from being purchased", {
			icon = "icon16/cross.png",
			callback = function() self:EPWcmd( ent, 7 ) end,
		})

		addoption( "Allow this entity to be purchased", {
			icon = "icon16/tick.png",
			callback = function() self:EPWcmd( ent, 8 ) end,
		})

	end,
	Action = function( self, ent ) end,
	EPWcmd = function( self, ent, cmd )
		if IsValid( ent ) then
			net.Start( "EPW.n.contextMenu" )
				net.WriteUInt( cmd, 4 )
				net.WriteEntity( ent )
			net.SendToServer()
		end
	end,
})