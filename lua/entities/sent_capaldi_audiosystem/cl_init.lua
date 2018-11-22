include('shared.lua')

function ENT:Draw()
	if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode and not LocalPlayer().capaldi_render then
		self:DrawModel()
	end
end

function ENT:StopTheme()
	if self.sound then
		self.sound:Stop()
		self.sound=nil
	end
end

function ENT:OnRemove()
	self:StopTheme()
end

local sounds={
	{"Main Theme (1963-1966)", "1963"},
	{"Main Theme (1966-1980)", "1966"},
	{"Main Theme (1980-1986)", "1980"},
	{"Main Theme (1986-1987)", "1986"},
	{"Main Theme (1987)", "1987"},
	{"Main Theme (1996)", "1996"},
	{"Main Theme (2005-2008)", "2005"},
	{"Main Theme (2008-2009)", "2008"},
	{"Main Theme (2010-2012)", "2010"},
	{"Main Theme (2013)", "2013"},
	{"Main Theme (2014-present)", "2014"},
        {"Doctor Who Theme Techno Remix", "techno"},
        {"Floorten - Mobius", "mobius"},
        {"Doctor Who Theme with Another Twist", "twist"},
        {"Pyrodrifter - Exterminate", "pyroext"},
	{"The Doctor's Theme", "TheDoctorsTheme"},
	{"Slitheen", "Slitheen"},
	{"Father's Day", "fathersday"},
	{"Rose In Peril", "RoseInPeril"},
	{"I'm Coming To Get You", "imcomingtogetyou"},
	{"Hologram", "Hologram"},
	{"Clockwork TARDIS", "Clockworktardis"},
	{"Rose's Theme", "RosesTheme"},
	{"The Face Of Boe", "TheFaceOfBoe"},
	{"The Lone Dalek", "TheLoneDalek"},
	{"New Adventures", "NewAdventures"},
	{"The Daleks", "TheDaleks"},
	{"The Cybermen", "TheCybermen"},
	{"Doomsday", "doomsday"},
	{"All The Strange, Strange Creatures", "AllTheStrangeStrangeCreatures"},
	{"Martha's Theme", "marthastheme"},
	{"Boe", "Boe"},
	{"The Futurekind", "TheFuturekind"},
	{"YANA", "YANA"},
	{"This Is Gallifrey, Our Childhood, Our Home", "ThisIsGallifreyOurChildhoodOurHome"},
	{"Donna's Theme", "donnastheme"},
	{"The Source", "TheSource"},
	{"The Doctor's Theme Series 4", "TheDoctorsThemeSeries4"},
	{"The Greatest Story Never Told", "TheGreatestStoryNeverTold"},
	{"Davros", "davros"},
	{"The Clouds Pass", "TheCloudsPass"},
	{"Yamit Mamo - My Angel put the Devil in Me", "yamitmamo"},
	{"Vale Decem", "ValeDecem"},
	{"The New Doctor", "TheNewDoctor"},
	{"Down to Earth", "downtoearth"},
	{"Can I Come With You?", "CanIComeWithYou"},
	{"The Sun's Gone Wibbly", "TheSunsGoneWibbly"},
	{"I Am the Doctor", "iamthedoctor"},
	{"The Mad Man With a Box", "TheMadManWithaBox"},
	{"Amy In the TARDIS", "AmyInthetardis"},
	{"Amy's Theme", "AmysTheme"},
	{"A Lonely Decision", "Alonelydecision"},
	{"The Vampires Of Venice", "TheVampiresOfVenice"},
	{"The Dream", "TheDream"},
	{"Paint", "Paint"},
	{"Hidden Treasures", "HiddenTreasures"},
	{"A Troubled Man", "atroubledman"},
	{"With Love, Vincent", "WithLoveVincent"},
	{"Adrift In the TARDIS", "AdriftInthetardis"},
	{"Doctor Gastronomy", "doctorgastronomy"},
	{"A Useful Striker", "AUsefulStriker"},
	{"Beneath Stonehenge", "BeneathStonehenge"},
	{"Who Else Is Coming", "WhoElseIsComing"},
	{"The Pandorica", "ThePandorica"},
	{"Words Win Wars", "WordsWinWars"},
	{"The Life And Death Of Amy Pond", "TheLifeAndDeathOfAmyPond"},
	{"The Perfect Prison", "ThePerfectPrison"},
	{"The Sad Man With a Box", "TheSadManWithaBox"},
	{"I Remember You", "irememberyou"},
	{"Come Along Pond", "comealongpond"},
	{"Geoff", "geoff"},
	{"He Comes Every Christmas", "ComesEveryChristmas"},
	{"Abigail's Song", "Abigailsong"},
	{"I Am The Doctor In Utah", "iamthedoctorinutah"},
	{"The Impossible Astronaut", "TheImpossibleAstronaut"},
	{"Brigadier Lethbridge - Stewart", "BrigadierLethbridgeStewart"},
	{"The Wedding Of River Song", "TheWeddingOfRiverSong"},
	{"The Majestic Tale (Of A Madman In A Box)", "TheMajesticTale"},
	{"My Husband's Home", "HusbandsHome"},
	{"Together Or Not At All", "TogetherOrNotAtAll"},
	{"Goodbye Pond", "goodbyepond"},
	{"Clara In the TARDIS", "ClaraInthetardis"},
	{"One Word", "OneWord"},
	{"Psychotic Potato Dwarf", "PsychoticPotatoDwarf"},
	{"Monking About", "MonkingAbout"},
	{"Clara?", "Clara"},
	{"Bah Bah Biker", "BahBahBiker"},
	{"Up The Shard", "UpTheShard"},
	{"The Leaf", "TheLeaf"},
	{"Something Awesome", "SomethingAwesome"},
	{"Merry Gejelh", "MerryGejelh"},
	{"Infinite Potential", "infinitepotential"},
	{"Cold War", "ColdWar"},
	{"Thomas Thomas", "ThomasThomas"},
	{"To Save The Doctor", "ToSaveTheDoctor"},
	{"Trenzalore", "Trenzalore"},
	{"500 Miles", "CastandCrew"},
	{"Gravity Falls Extended Theme", "gf"},
	{"Scorpions - Holiday", "holiday"},
	{"Scorpions - When the Smoke Is Going Down", "WhentheSmokeIsGoingDown"},
	{"Rain OST - Premonitions", "Premonitions"},
	{"W.I.T.C.H. UK Opening Theme", "witch"},
	{"W.I.T.C.H. Russian Opening Theme", "witchrus"},
	{"W.I.T.C.H. Closing Theme", "witchclosing"},
	{"W.I.T.C.H. Series 2 UK Opening Theme", "witch2"},
	{"W.I.T.C.H. Series 2 Russian Opening Theme", "witchrus2"},
	{"W.I.T.C.H. Series 2 Closing Theme", "witchclosing2"},
	{"Kuplinov Song", "kuplinovnihua"},
	{"Chameleon Circuit - The Doctor Is Dying", "doctordying"},
	{"Chameleon Circuit - Big Bang Two", "bbtwo"},
	{"Chameleon Circuit - Exterminate, Regenerate", "exterminateregenerate"},
	{"Chameleon Circuit - Type 40", "type40"},
	{"Costello - Profite", "profite"},
	{"Disiz la Peste & Jalane - Lettre Ouverte", "LettreOuverte"},
	{"Freeman_Karim le Roi - Le dernier coup", "Lederniercoup"},
	{"One shot - A la conquete", "Alaconquete"},
	{"One Shot - Trop De Polemiques", "TropDePolemiques"},
	{"Otis McDonald - Behind Closed Doors", "behindcloseddoors"},
	{"Otis McDonald - Hangs Ups (Want You)", "hangsups"},
	{"SANIC - HEGERHOG", "sanichegerhog"},
	{"Ira - Prigai Vniz", "prvniz"},
}

net.Receive("capaldiInt-Gramophone-Send", function(l,ply)
	local gramophone=net.ReadEntity()
	local capaldi=net.ReadEntity()
	local interior=net.ReadEntity()
	local play=tobool(net.ReadBit())
	local choice=net.ReadFloat()
	local custom=tobool(net.ReadBit())
	local customstr
	if custom then
		customstr=net.ReadString()
	end
	if IsValid(gramophone) and IsValid(capaldi) and IsValid(interior) then
		gramophone:StopTheme()
		if play and tobool(GetConVarNumber("capaldiint_music"))==true then
			local addr
			if custom and not (customstr=="") then
				addr=customstr
			elseif choice and sounds[choice] then
				addr="https://subversion.assembla.com/svn/doctorwho1200fastdl/Music/Gramophone/"..sounds[choice][2]..".mp3"
			else
				return
			end
			sound.PlayURL(addr, "", function(station)
				if station then
					station:SetPos(gramophone:GetPos())
					station:SetVolume(1)
					station:Play()
					gramophone.sound=station
				else
					LocalPlayer():ChatPrint("ERROR: Failed to load theme (check console for BASS error!)")
				end
			end)
		end
	end
end)

net.Receive("capaldiInt-Gramophone-GUI", function()	
	local gramophone=net.ReadEntity()
	local capaldi=net.ReadEntity()
	local interior=net.ReadEntity()
	local choice=0
	
	local function SendSelection(play,customstr)
		if IsValid(gramophone) and IsValid(capaldi) and IsValid(interior) then
			net.Start("capaldiInt-Gramophone-Bounce")
				net.WriteEntity(gramophone)
				net.WriteEntity(capaldi)
				net.WriteEntity(interior)
				net.WriteBit(play)
				net.WriteFloat(choice)
				if customstr then
					net.WriteBit(true)
					net.WriteString(customstr)
				else
					net.WriteBit(false)
				end
			net.SendToServer()
			return true
		else
			return false
		end
	end
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 200, 155+221 )
	window:Center()
	window:SetTitle( "Gramophone" )
	window:MakePopup()
	
	local label = vgui.Create( "DLabel", window )
	label:SetPos(10,30) // Position
	label:SetColor(Color(255,255,255,255)) // Color
	label:SetFont("Trebuchet24")
	label:SetText("Select theme tune") // Text
	label:SizeToContents() // make the control the same size as the text.
	
	local listview = vgui.Create( "DListView", window )
	listview:SetPos(10,60)
	listview:SetSize(180,16+221)
	listview:SetMultiSelect( false )
	listview:AddColumn( "Themes" )
	listview.OnClickLine = function(self,line)
		local name=line:GetValue(1)
		self:ClearSelection()
		self:SelectItem(line)
		for k,v in pairs(sounds) do
			if v[1]==name then
				choice=k
			end
		end
	end
	
	for k,v in pairs(sounds) do
		listview:AddLine( v[1] )
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 180, 30 )
	button:SetPos( 10, window:GetTall()-74 )
	button:SetText( "Enter Custom Theme" )
	button.DoClick = function( button )
		Derma_StringRequest(
			"Enter Custom Theme",
			"Input a web link of a sound (MP3, MP2, MP1, OGG, WAV, AIFF)",
			"",
			function(text) SendSelection(true,text) end,
			function(text) end
		)
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 87.5, 30 )
	button:SetPos( 10, window:GetTall()-38 )
	button:SetText( "Play" )
	button.DoClick = function( button )
		local success=SendSelection(true)
		if success then
			window:Close()
		end
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 87.5, 30 )
	button:SetPos( 102.5, window:GetTall()-38 )
	button:SetText( "Stop" )
	button.DoClick = function( button )
		local success=SendSelection(false)
		if success then
			window:Close()
		end
	end
end)

function ENT:Think()
	if self.sound then
		if tobool(GetConVarNumber("capaldiint_music"))==true then
			local capaldi=self:GetNWEntity("capaldi",NULL)
			if IsValid(capaldi) then
				local interior=capaldi:GetNWEntity("interior",NULL)
				if LocalPlayer().capaldi==capaldi and IsValid(interior) then
					if LocalPlayer().capaldi_viewmode and not (LocalPlayer().capaldi_skycamera and IsValid(LocalPlayer().capaldi_skycamera)) then
						local distance=LocalPlayer():GetPos():Distance(interior:GetPos())
						local volume=math.Clamp(((distance*-1)/2200+1.1)*GetConVarNumber("capaldiint_musicvol"),0,1)
						self.sound:SetVolume(volume)
					elseif (not LocalPlayer().capaldi_viewmode or (LocalPlayer().capaldi_skycamera and IsValid(LocalPlayer().capaldi_skycamera))) and tobool(GetConVarNumber("capaldiint_musicext"))==true then
						local volume=math.Clamp(GetConVarNumber("capaldiint_musicvol"),0,1)
						self.sound:SetVolume(volume)
					else
						self.sound:SetVolume(0)
					end
				else
					self:StopTheme()
				end
			end
		else
			self:StopTheme()
		end
	end
end