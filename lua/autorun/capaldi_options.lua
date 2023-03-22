local checkbox_options={
	{"Flight sounds", "capaldi_flightsound"},
	{"Teleport sounds", "capaldi_matsound"},
	{"Door sounds", "capaldi_doorsound"},
	{"Lock sounds", "capaldi_locksound"},
	{"Phase sounds", "capaldi_phasesound"},
	{"Repair sounds", "capaldiint_repairsound"},
	{"Power sounds", "capaldiint_powersound"},
	{"Cloisterbell sound", "capaldiint_cloisterbell"},
	{"Interior Crack sound", "capaldiint_crack"},
	{"Interior Creaks sound", "capaldiint_creaks"},
	{"Flightmode music", "capaldiint_musicext"},
	{"Interior idle sounds", "capaldiint_idlesound"},
	{"Interior control sounds", "capaldiint_controlsound"},
	{"Interior music", "capaldiint_music"},
	{"Interior scanner", "capaldiint_scanner"},
	{"Interior dynamic light", "capaldiint_dynamiclight"},
	{"Exterior dynamic light", "capaldi_dynamiclight"},
}

for k,v in pairs(checkbox_options) do
	CreateClientConVar(v[2], "1", true)
end

local special_checkbox_options={
}

for k,v in pairs(special_checkbox_options) do
	CreateClientConVar(v[2], v[3], true, v[4])
end

CreateClientConVar("capaldiint_musicvol", "1", true)
CreateClientConVar("capaldi_flightvol", "1", true)

CreateClientConVar("capaldiint_mainlight_r", "0", true, true)
CreateClientConVar("capaldiint_mainlight_g", "0", true, true)
CreateClientConVar("capaldiint_mainlight_b", "0", true, true)

CreateClientConVar("capaldiint_seclight_r", "255", true, true)
CreateClientConVar("capaldiint_seclight_g", "85", true, true)
CreateClientConVar("capaldiint_seclight_b", "0", true, true)

CreateClientConVar("capaldiint_warnlight_r", "200", true, true)
CreateClientConVar("capaldiint_warnlight_g", "0", true, true)
CreateClientConVar("capaldiint_warnlight_b", "0", true, true)

CreateClientConVar("capaldi_extcol_r", "255", true, true)
CreateClientConVar("capaldi_extcol_g", "228", true, true)
CreateClientConVar("capaldi_extcol_b", "91", true, true)

hook.Add("PopulateToolMenu", "capaldi-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "capaldi_Options", "2015 TARDIS", "", "", function(panel)
		panel:ClearControls()
		//Do menu things here

		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Double spawn trace (Admin Only)" )
		checkBox:SetToolTip( "This should fix some maps where the interior/skycamera doesn't spawn properly" )
		checkBox:SetValue( GetConVarNumber( "capaldi_doubletrace" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
				net.Start("capaldi-DoubleTrace") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Take damage (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "capaldi_takedamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-TakeDamage") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end			
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Allow phasing in flightmode (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "capaldi_flightphase" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-FlightPhase") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Physical Damage (Admin Only)" )
		checkBox:SetToolTip( "This enables/disables physical damage from hitting stuff at high speeds." )
		checkBox:SetValue( GetConVarNumber( "capaldi_physdamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
		checkBox.OnChange = function(self,val) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-PhysDamage") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "No-collide during teleport (Admin Only)" )
		checkBox:SetToolTip( "This enables no-collide on the TARDIS when it is teleporting and disables it after again." )
		checkBox:SetValue( GetConVarNumber( "capaldi_nocollideteleport" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
		checkBox.OnChange = function(self,val) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-NoCollideTeleport") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Advanced Mode (Admin Only)" )
		checkBox:SetToolTip( "This sets interior navigation to advanced, turn off for easy." )
		checkBox:SetValue( GetConVarNumber( "capaldi_advanced" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
		checkBox.OnChange = function(self,val) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-AdvancedMode") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Lock doors during teleport (Admin Only)" )
		checkBox:SetToolTip( "This stops players from entering/leaving while it is teleporting." )
		checkBox:SetValue( GetConVarNumber( "capaldi_teleportlock" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin())) -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
		checkBox.OnChange = function(self,val) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.Start("capaldi-TeleportLock") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					net.WriteFloat(val==true and 1 or 0) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
				net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		/* -- i feel people arnt going to know what this does and end up breaking everything, the above checkbox should help in most cases.
		local slider = vgui.Create( "DNumSlider" )
			slider:SetText( "Spawn Offset (Admin Only)" )
			slider:SetToolTip("Try the above checkbox first, this is a last resort for advanced users only.")
			slider:SetValue(0)
			slider:SetDecimals(0)
			slider:SetMin(-10000)
			slider:SetMax(5000)
			slider.val=0
			slider.OnValueChanged = function(self,val)
				if not (slider.val==val) then
					slider.val=val
					if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
						net.Start("capaldi-SpawnOffset") -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
							net.WriteFloat(val) -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
						net.SendToServer() -- <- Stop doing this. You can simply override IsAdmin() as return true on the client.
					else
						chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
						chat.PlaySound()
					end
				end
			end
			panel:AddItem(slider)
			
		local button = vgui.Create( "DButton" )
		button:SetText( "Reset Spawn Offset" )
		button.DoClick = function(self)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then -- If this is removed clientsidedly you can EXPLOIT and SPAM this using net.SendToServer. How dumb can some people be as to not add a secondary net var with the player themselves and CHECK ADMIN STATUS ON SERVER INSTEAD OF CLIENT. REALLY. I COULD RANT ON FOR 100000 YEARS WITH THIS. STOP checking ADMIN STATUS. ON. CLIENT. xD
				if slider then
					slider:SetValue(0)
				end
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to use this button.")
				chat.PlaySound()
			end
		end
		panel:AddItem(button)
		*/
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Colors:")
		panel:AddItem(DLabel)
		
		local CategoryList = vgui.Create( "DPanelList" )
		//CategoryList:SetAutoSize( true )
		CategoryList:SetTall( 260 )
		CategoryList:SetSpacing( 10 )
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Exterior Lamp:")
		CategoryList:AddItem(DLabel)
		
		local Mixer = vgui.Create( "DColorMixer" )
		Mixer:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer:SetColor( Color(GetConVarNumber("capaldi_extcol_r"), GetConVarNumber("capaldi_extcol_g"), GetConVarNumber("capaldi_extcol_b")) )	--Set the default color
		Mixer.ValueChanged = function(self,col)
			RunConsoleCommand("capaldi_extcol_r", col.r)
			RunConsoleCommand("capaldi_extcol_g", col.g)
			RunConsoleCommand("capaldi_extcol_b", col.b)
		end
		CategoryList:AddItem(Mixer)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Main:")
		CategoryList:AddItem(DLabel)
		
		local Mixer1 = vgui.Create( "DColorMixer" )
		Mixer1:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer1:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer1:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer1:SetColor( Color(GetConVarNumber("capaldiint_mainlight_r"), GetConVarNumber("capaldiint_mainlight_g"), GetConVarNumber("capaldiint_mainlight_b")) )	--Set the default color
		Mixer1.ValueChanged = function(self,col)
			RunConsoleCommand("capaldiint_mainlight_r", col.r)
			RunConsoleCommand("capaldiint_mainlight_g", col.g)
			RunConsoleCommand("capaldiint_mainlight_b", col.b)
		end
		CategoryList:AddItem(Mixer1)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Secondary:")
		CategoryList:AddItem(DLabel)
		
		local Mixer2 = vgui.Create( "DColorMixer" )
		Mixer2:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer2:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer2:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer2:SetColor( Color(GetConVarNumber("capaldiint_seclight_r"), GetConVarNumber("capaldiint_seclight_g"), GetConVarNumber("capaldiint_seclight_b")) )	--Set the default color
		Mixer2.ValueChanged = function(self,col)
			RunConsoleCommand("capaldiint_seclight_r", col.r)
			RunConsoleCommand("capaldiint_seclight_g", col.g)
			RunConsoleCommand("capaldiint_seclight_b", col.b)
		end
		CategoryList:AddItem(Mixer2)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Warning:")
		CategoryList:AddItem(DLabel)
		
		local Mixer3 = vgui.Create( "DColorMixer" )
		Mixer3:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer3:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer3:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer3:SetColor( Color(GetConVarNumber("capaldiint_warnlight_r"), GetConVarNumber("capaldiint_warnlight_g"), GetConVarNumber("capaldiint_warnlight_b")) )	--Set the default color
		Mixer3.ValueChanged = function(self,col)
			RunConsoleCommand("capaldiint_warnlight_r", col.r)
			RunConsoleCommand("capaldiint_warnlight_g", col.g)
			RunConsoleCommand("capaldiint_warnlight_b", col.b)
		end
		CategoryList:AddItem(Mixer3)
		
		panel:AddItem(CategoryList)
		
		local button = vgui.Create("DButton")
		button:SetText("Reset Colors")
		button.DoClick = function(self)
			Mixer:SetColor(Color(255,228,91))
			Mixer1:SetColor(Color(0,0,0))
			Mixer2:SetColor(Color(255,85,0))
			Mixer3:SetColor(Color(200,0,0))
		end
		panel:AddItem(button)
		
		panel:AddControl("Slider", {
			Label="Music Volume",
			Type="float",
			Min=0.1,
			Max=1,
			Command="capaldiint_musicvol",
		})
		
		panel:AddControl("Slider", {
			Label="Exterior Flight Volume",
			Type="float",
			Min=0.1,
			Max=1,
			Command="capaldi_flightvol",
		})
		
		
		
		local checkboxes={}
		for k,v in pairs(special_checkbox_options) do
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
		
		for k,v in pairs(checkbox_options) do
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
	end)
end)
