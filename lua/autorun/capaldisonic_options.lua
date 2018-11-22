//Sonic Screwdriver Spawnmenu Options

local checkbox_options={
	{"Sound", "capaldisonic_sound"},
	{"Particle light", "capaldisonic_light"},
	{"Dynamic light", "capaldisonic_dynamiclight"},
}

for k,v in pairs(checkbox_options) do
	CreateClientConVar(v[2], "1", true)
end

CreateClientConVar("capaldisonic_light_r", "0", true)
CreateClientConVar("capaldisonic_light_g", "100", true)
CreateClientConVar("capaldisonic_light_b", "250", true)

hook.Add("PopulateToolMenu", "capaldisonic-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "capaldisonic_Options", "2015 Sonic Screwdriver", "", "", function(panel)
		panel:ClearControls()
		
		local Mixer1 = vgui.Create( "DColorMixer" )
		Mixer1:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer1:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer1:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer1:SetColor( Color(GetConVarNumber("capaldisonic_light_r"), GetConVarNumber("capaldisonic_light_g"), GetConVarNumber("capaldisonic_light_b")) )	--Set the default color
		Mixer1.ValueChanged = function(self,col)
			RunConsoleCommand("capaldisonic_light_r", col.r)
			RunConsoleCommand("capaldisonic_light_g", col.g)
			RunConsoleCommand("capaldisonic_light_b", col.b)
		end
		panel:AddItem(Mixer1)
		
		local checkboxes={}
		for k,v in pairs(checkbox_options) do
			CreateClientConVar(v[2], "1", true)
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
	end)
end)