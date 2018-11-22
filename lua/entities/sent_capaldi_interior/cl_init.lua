include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
	if LocalPlayer().capaldi_viewmode and self:GetNWEntity("capaldi",NULL)==LocalPlayer().capaldi and not LocalPlayer().capaldi_render then
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
	end
end

function ENT:OnRemove()
	if self.cloisterbell then
		self.cloisterbell:Stop()
		self.cloisterbell=nil
	end
	if self.creaks then
		self.creaks:Stop()
		self.creaks=nil
	end
	if self.idlesound then
		self.idlesound:Stop()
		self.idlesound=nil
	end
	if self.crack then
		self.crack:Stop()
		self.creaks=nil
	end
end

function ENT:Initialize()
	self.timerotor={}
	self.timerotor.pos=0
	self.timerotor.mode=1
	self.parts={}
end

net.Receive("capaldiInt-SetParts", function()
	local t={}
	local interior=net.ReadEntity()
	local count=net.ReadFloat()
	for i=1,count do
		local ent=net.ReadEntity()
		ent.capaldi_part=true
		if IsValid(interior) then
			table.insert(interior.parts,ent)
		end
	end
end)

net.Receive("capaldiInt-UpdateAdv", function()
	local success=tobool(net.ReadBit())
	if success then
	else
		surface.PlaySound("doctorwho1200/capaldi/cloister.wav")
	end
end)

net.Receive("capaldiInt-SetAdv", function()
	local interior=net.ReadEntity()
	local ply=net.ReadEntity()
	local mode=net.ReadFloat()
	if IsValid(interior) and IsValid(ply) and mode then
		if ply==LocalPlayer() then
		end
		interior.flightmode=mode
	end
end)

net.Receive("capaldiInt-ControlSound", function()
	local capaldi=net.ReadEntity()
	local control=net.ReadEntity()
	local snd=net.ReadString()
	if IsValid(capaldi) and IsValid(control) and snd and tobool(GetConVarNumber("capaldiint_controlsound"))==true and LocalPlayer().capaldi==capaldi and LocalPlayer().capaldi_viewmode then
		sound.Play(snd,control:GetPos())
	end
end)

function ENT:Think()
	local capaldi=self:GetNWEntity("capaldi",NULL)
	if IsValid(capaldi) and LocalPlayer().capaldi_viewmode and LocalPlayer().capaldi==capaldi then
		if tobool(GetConVarNumber("capaldiint_cloisterbell"))==true and not IsValid(LocalPlayer().capaldi_skycamera) then
			if capaldi.health and capaldi.health < 26 then
				if self.cloisterbell and !self.cloisterbell:IsPlaying() then
					self.cloisterbell:Play()
				elseif not self.cloisterbell then
					self.cloisterbell = CreateSound(self, "doctorwho1200/capaldi/cloisterbell_loop.wav")
					self.cloisterbell:Play()
				end
			else
				if self.cloisterbell and self.cloisterbell:IsPlaying() then
					self.cloisterbell:Stop()
					self.cloisterbell=nil
				end
			end
		else
			if self.cloisterbell and self.cloisterbell:IsPlaying() then
				self.cloisterbell:Stop()
				self.cloisterbell=nil
			end
		end

		if tobool(GetConVarNumber("capaldiint_creaks"))==true and not IsValid(LocalPlayer().capaldi_skycamera) then
			if not capaldi.power or capaldi.repairing then
				if self.creaks and !self.creaks:IsPlaying() then
					self.creaks:Play()
				elseif not self.creaks then
					self.creaks = CreateSound(self, "doctorwho1200/capaldi/creaks_loop.wav")
					self.creaks:Play()
				        self.creaks:ChangeVolume(0.4,0)
				end
			else
				if self.creaks and self.creaks:IsPlaying() then
					self.creaks:Stop()
					self.creaks=nil
				end
			end
		else
			if self.cloisterbell and self.cloisterbell:IsPlaying() then
				self.cloisterbell:Stop()
				self.cloisterbell=nil
			end
		end
		
		if tobool(GetConVarNumber("capaldiint_crack"))==true and not IsValid(LocalPlayer().capaldi_skycamera) then
			if capaldi.health and capaldi.health < 11 then
				if self.crack and !self.crack:IsPlaying() then
					self.crack:Play()
				elseif not self.crack then
					self.crack = CreateSound(self, "doctorwho1200/capaldi/crack.wav")
					self.crack:Play()
				        self.crack:ChangeVolume(1,0)
				end
			else
				if self.crack and self.crack:IsPlaying() then
					self.crack:Stop()
					self.crack=nil
				end
			end
		else
			if self.crack and self.crack:IsPlaying() then
				self.crack:Stop()
				self.crack=nil
			end
		end	
		
		if tobool(GetConVarNumber("capaldiint_idlesound"))==true and capaldi.health and capaldi.health >= 1 and not IsValid(LocalPlayer().capaldi_skycamera) and not capaldi.repairing and capaldi.power then
			if self.idlesound and !self.idlesound:IsPlaying() then
				self.idlesound:Play()
			elseif not self.idlesound then
				self.idlesound = CreateSound(self, "doctorwho1200/capaldi/interior_idle_loop.wav")
				self.idlesound:Play()
				self.idlesound:ChangeVolume(0.7,0)
			end
		else
			if self.idlesound and self.idlesound:IsPlaying() then
				self.idlesound:Stop()
				self.idlesound=nil
			end
		end
		
		if not IsValid(LocalPlayer().capaldi_skycamera) and tobool(GetConVarNumber("capaldiint_dynamiclight"))==true then
			if capaldi.health and capaldi.health > 0 and not capaldi.repairing and capaldi.power then
				local dlight = DynamicLight( self:EntIndex() )
				if ( dlight ) then
					local size=1024
					local v=self:GetNWVector("mainlight",Vector(0,0,0))
					dlight.Pos = self:LocalToWorld(Vector(0,0,300))
					dlight.r = v.x
					dlight.g = v.y
					dlight.b = v.z
					dlight.Brightness = 3
					dlight.Decay = size * 5
					dlight.Size = size
					dlight.DieTime = CurTime() + 1
				end
			end
			
			if capaldi.health and capaldi.health > 0 and not capaldi.repairing and capaldi.power then	
			   local dlight2 = DynamicLight( self:EntIndex()+10000 )
			   if ( dlight2 ) then
				   local size=1024
				   local v=self:GetNWVector("seclight",Vector(0,0,0))
					if capaldi.health < 21 then
						v=self:GetNWVector("warnlight",Vector(0,0,0))
					end
				   dlight2.Pos = self:LocalToWorld(Vector(0,0,-50))
				   dlight2.r = v.x
				   dlight2.g = v.y
				   dlight2.b = v.z
				   dlight2.Brightness = 4
				   dlight2.Decay = size * 5
				   dlight2.Size = size
				   dlight2.DieTime = CurTime() + 1
			   end
                        end
			
			if (capaldi.moving or capaldi.flightmode) then
				if self.timerotor.pos==1 then
					self.timerotor.pos=0
				end
				
				self.timerotor.pos=math.Approach( self.timerotor.pos, self.timerotor.mode, FrameTime()*0.07 )
				self:SetPoseParameter( "glass", self.timerotor.pos )
			end
              end
		
	else
		if self.cloisterbell then
			self.cloisterbell:Stop()
			self.cloisterbell=nil
		end
		if self.cloisterbell then
			self.cloisterbell:Stop()
			self.cloisterbell=nil
		end
		if self.idlesound then
			self.idlesound:Stop()
			self.idlesound=nil
		end
	end
end