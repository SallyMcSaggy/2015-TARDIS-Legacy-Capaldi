include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw() 
	if not self.phasing and self.visible and not self.invortex then
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
	elseif self.phasing then
		if self.percent then
			if not self.phasemode and self.highPer <= 0 then
				self.phasing=false
			elseif self.phasemode and self.percent >= 1 then
				self.phasing=false
			end
		end
		
		self.percent = (self.phaselifetime - CurTime())
		self.highPer = self.percent + 0.5
		if self.phasemode then
			self.percent = (1-self.percent)-0.5
			self.highPer = self.percent+0.5
		end
		self.percent = math.Clamp( self.percent, 0, 1 )
		self.highPer = math.Clamp( self.highPer, 0, 1 )

		--Drawing original model
		local normal = self:GetUp()
		local origin = self:GetPos() + self:GetUp() * (self.maxs.z - ( self.height * self.highPer ))
		local distance = normal:Dot( origin )
		
		render.EnableClipping( true )
		render.PushCustomClipPlane( normal, distance )
			self:DrawModel()
		render.PopCustomClipPlane()
		
		local restoreT = self:GetMaterial()
		
		--Drawing phase texture
		render.MaterialOverride( self.wiremat )

		normal = self:GetUp()
		distance = normal:Dot( origin )
		render.PushCustomClipPlane( normal, distance )
		
		local normal2 = self:GetUp() * -1
		local origin2 = self:GetPos() + self:GetUp() * (self.maxs.z - ( self.height * self.percent ))
		local distance2 = normal2:Dot( origin2 )
		render.PushCustomClipPlane( normal2, distance2 )
			self:DrawModel()
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()
		
		render.MaterialOverride( restoreT )
		render.EnableClipping( false )
	end
end

function ENT:Phase(mode)
	self.phasing=true
	self.phaseactive=true
	self.phaselifetime=CurTime()+1
	self.phasemode=mode
end

function ENT:Initialize()
	self.health=100
	self.phasemode=false
	self.visible=true
	self.flightmode=false
	self.visible=true
	self.power=true
	self.z=0
	self.phasedraw=0
	self.mins = self:OBBMins()
	self.maxs = self:OBBMaxs()
	self.wiremat = Material( "models/doctorwho1200/capaldi/phase" )
	self.height = self.maxs.z - self.mins.z
end

function ENT:OnRemove()
	if self.flightloop then
		self.flightloop:Stop()
		self.flightloop=nil
	end
	if self.flightloop2 then
		self.flightloop2:Stop()
		self.flightloop2=nil
	end
end

function ENT:Think()
	if tobool(GetConVarNumber("capaldi_flightsound"))==true then
		if not self.flightloop then
			self.flightloop=CreateSound(self, "doctorwho1200/capaldi/flight_loop.wav")
			self.flightloop:SetSoundLevel(90)
			self.flightloop:Stop()
		end
		if self.flightmode and self.visible and not self.moving then
			if !self.flightloop:IsPlaying() then
				self.flightloop:Play()
			end
			local e = LocalPlayer():GetViewEntity()
			if !IsValid(e) then e = LocalPlayer() end
			local capaldi=LocalPlayer().capaldi
			if not (capaldi and IsValid(capaldi) and capaldi==self and e==LocalPlayer()) then
				local pos = e:GetPos()
				local spos = self:GetPos()
				local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200
				if self.exploded then
					local r=math.random(90,130)
					self.flightloop:ChangePitch(math.Clamp(r+doppler,80,120),0.1)
				else
					self.flightloop:ChangePitch(math.Clamp((self:GetVelocity():Length()/250)+95+doppler,80,120),0.1)
				end
				self.flightloop:ChangeVolume(GetConVarNumber("capaldi_flightvol"),0)
			else
				if self.exploded then
					local r=math.random(90,130)
					self.flightloop:ChangePitch(r,0.1)
				else
					local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
					self.flightloop:ChangePitch(95+p,0.1)
				end
				self.flightloop:ChangeVolume(0.75*GetConVarNumber("capaldi_flightvol"),0)
			end
		else
			if self.flightloop:IsPlaying() then
				self.flightloop:Stop()
			end
		end
		
		local interior=self:GetNWEntity("interior",NULL)
		if not self.flightloop2 and interior and IsValid(interior) then
			self.flightloop2=CreateSound(interior, "doctorwho1200/capaldi/flight_loop_int.wav")
			self.flightloop2:Stop()
		end
		if self.flightloop2 and (self.flightmode or self.invortex) and LocalPlayer().capaldi_viewmode and not IsValid(LocalPlayer().capaldi_skycamera) and interior and IsValid(interior) and ((self.invortex and self.moving) or not self.moving) then
			if !self.flightloop2:IsPlaying() then
				self.flightloop2:Play()
				self.flightloop2:ChangeVolume(0.4,0)
			end
			if self.exploded then
				local r=math.random(90,130)
				self.flightloop2:ChangePitch(r,0.1)
				self.flightloop2:ChangeVolume(3)
			else
				local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
				self.flightloop2:ChangeVolume(3)
			end
		elseif self.flightloop2 then
			if self.flightloop2:IsPlaying() then
				self.flightloop2:Stop()
			end
		end
	else
		if self.flightloop then
			self.flightloop:Stop()
			self.flightloop=nil
		end
		if self.flightloop2 then
			self.flightloop2:Stop()
			self.flightloop2=nil
		end
	end
	
	if self.light_on and tobool(GetConVarNumber("capaldi_dynamiclight"))==true then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local size=400
			local v=self:GetNWVector("extcol",Vector(255,255,255))
			local c=Color(v.x,v.y,v.z)
			dlight.Pos = self:GetPos() + self:GetUp() * 123
			dlight.r = c.r
			dlight.g = c.g
			dlight.b = c.b
			dlight.Brightness = 1
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1
		end
	end
	if self.health and self.health > 20 and self.visible and self.power and not self.moving and tobool(GetConVarNumber("capaldi_dynamiclight"))==true then
		local dlight2 = DynamicLight( self:EntIndex() )
		if ( dlight2 ) then
			local size=400
			local v=self:GetNWVector("extcol",Vector(255,255,255))
			local c=Color(v.x,v.y,v.z)
			dlight2.Pos = self:GetPos() + self:GetUp() * 123
			dlight2.r = c.r
			dlight2.g = c.g
			dlight2.b = c.b
			dlight2.Brightness = 1
			dlight2.Decay = size * 5
			dlight2.Size = size
			dlight2.DieTime = CurTime() + 1
		end
	end
end

net.Receive("capaldi-UpdateVis", function()
	local ent=net.ReadEntity()
	ent.visible=tobool(net.ReadBit())
end)

net.Receive("capaldi-Phase", function()
	local capaldi=net.ReadEntity()
	local interior=net.ReadEntity()
	if IsValid(capaldi) then
		capaldi.visible=tobool(net.ReadBit())
		capaldi:Phase(capaldi.visible)
		if not capaldi.visible and tobool(GetConVarNumber("capaldi_phasesound"))==true then
			capaldi:EmitSound("doctorwho1200/capaldi/phase_enable.wav", 100, 100)
			if IsValid(interior) then
				interior:EmitSound("doctorwho1200/capaldi/phase_enable.wav", 100, 100)
			end
		end
	end
end)

net.Receive("capaldi-Explode", function()
	local ent=net.ReadEntity()
	ent.exploded=true
end)

net.Receive("capaldi-UnExplode", function()
	local ent=net.ReadEntity()
	ent.exploded=false
end)

net.Receive("capaldi-Flightmode", function()
	local ent=net.ReadEntity()
	ent.flightmode=tobool(net.ReadBit())
end)

net.Receive("capaldi-SetInterior", function()
	local ent=net.ReadEntity()
	ent.interior=net.ReadEntity()
end)

local tpsounds={}
tpsounds[0]={ // normal
	"doctorwho1200/capaldi/demat.wav",
	"doctorwho1200/capaldi/mat.wav",
	"doctorwho1200/capaldi/full.wav"
}
tpsounds[1]={ // fast demat
	"doctorwho1200/capaldi/fast_demat.wav",
	"doctorwho1200/capaldi/mat.wav",
	"doctorwho1200/capaldi/full.wav"
}
tpsounds[2]={ // fast return
	"doctorwho1200/capaldi/fastreturn_demat_int.wav",
	"doctorwho1200/capaldi/fastreturn_mat_int.wav",
	"doctorwho1200/capaldi/fastreturn_full_int.wav"
}
net.Receive("capaldi-Go", function()
	local capaldi=net.ReadEntity()
	if IsValid(capaldi) then
		capaldi.moving=true
	end
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	local long=tobool(net.ReadBit())
	local snd=net.ReadFloat()
	local snds=tpsounds[snd]
	if tobool(GetConVarNumber("capaldi_matsound"))==true then
		if IsValid(capaldi) and LocalPlayer().capaldi==capaldi then
			if capaldi.visible then
				if long then
					capaldi:EmitSound(snds[1], 100, pitch)
				else
					capaldi:EmitSound(snds[3], 100, pitch)
				end
			end
			if interior and IsValid(interior) and LocalPlayer().capaldi_viewmode and not IsValid(LocalPlayer().capaldi_skycamera) then
				if long then
				sound.Play("doctorwho1200/capaldi/demat_int.wav", interior:LocalToWorld(Vector(0,0,90)))
				else
				sound.Play("doctorwho1200/capaldi/full_int.wav", interior:LocalToWorld(Vector(0,0,90)))
				end
			end
		elseif IsValid(capaldi) and capaldi.visible then
			local pos=net.ReadVector()
			local pos2=net.ReadVector()
			if pos then
				sound.Play(snds[1], pos, 75, pitch)
			end
			if pos2 and not long then
				sound.Play("doctorwho1200/capaldi/mat.wav", pos2, 75, pitch)
			end
		end
	end
end)

net.Receive("capaldi-Stop", function()
	capaldi=net.ReadEntity()
	if IsValid(capaldi) then
		capaldi.moving=nil
	end
end)

net.Receive("capaldi-Reappear", function()
	local capaldi=net.ReadEntity()
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	local snd=net.ReadFloat()
	local snds=tpsounds[snd]
	if tobool(GetConVarNumber("capaldi_matsound"))==true then
		if IsValid(capaldi) and LocalPlayer().capaldi==capaldi then
			if capaldi.visible then
				capaldi:EmitSound("doctorwho1200/capaldi/mat.wav", 100, pitch)
			end
			if interior and IsValid(interior) and LocalPlayer().capaldi_viewmode and not IsValid(LocalPlayer().capaldi_skycamera) then
				sound.Play("doctorwho1200/capaldi/mat_int.wav", interior:LocalToWorld(Vector(0,0,90)))
			end
		elseif IsValid(capaldi) and capaldi.visible then
			sound.Play("doctorwho1200/capaldi/mat.wav", net.ReadVector(), 75, pitch)
		end
	end
end)

net.Receive("Player-Setcapaldi", function()
	local ply=net.ReadEntity()
	ply.capaldi=net.ReadEntity()
end)

net.Receive("capaldi-SetHealth", function()
	local capaldi=net.ReadEntity()
	capaldi.health=net.ReadFloat()
end)

net.Receive("capaldi-SetLocked", function()
	local capaldi=net.ReadEntity()
	local interior=net.ReadEntity()
	local locked=tobool(net.ReadBit())
	local makesound=tobool(net.ReadBit())
	if IsValid(capaldi) then
		capaldi.locked=locked
		if tobool(GetConVarNumber("capaldi_locksound"))==true and makesound then
			sound.Play("doctorwho1200/capaldi/lock.wav", capaldi:GetPos())
		end
	end
	if IsValid(interior) then
		if tobool(GetConVarNumber("capaldi_locksound"))==true and not IsValid(LocalPlayer().capaldi_skycamera) and makesound then
			sound.Play("doctorwho1200/capaldi/lock.wav", interior:LocalToWorld(Vector(-270,0,89)))
		end
	end
end)

net.Receive("capaldi-SetViewmode", function()
	LocalPlayer().capaldi_viewmode=tobool(net.ReadBit())
	LocalPlayer().ShouldDisableLegs=(not LocalPlayer().capaldi_viewmode)
	
	if LocalPlayer().capaldi_viewmode and GetConVarNumber("r_rootlod")>0 then
		Derma_Query("The TARDIS Interior requires model detail on high, set now?", "TARDIS Interior", "Yes", function() RunConsoleCommand("r_rootlod", 0) end, "No", function() end)
	end
		
end)

hook.Add( "ShouldDrawLocalPlayer", "capaldi-ShouldDrawLocalPlayer", function(ply)
	if IsValid(ply.capaldi) and not ply.capaldi_viewmode then
		return false
	end
end)

net.Receive("capaldi-PlayerEnter", function()
	if tobool(GetConVarNumber("capaldi_doorsound"))==true then
		local ent1=net.ReadEntity()
		local ent2=net.ReadEntity()
		if IsValid(ent1) and ent1.visible then
			sound.Play("doctorwho1200/capaldi/door.wav", ent1:GetPos())
		end
		if IsValid(ent2) and not IsValid(LocalPlayer().capaldi_skycamera) then
			sound.Play("doctorwho1200/capaldi/door.wav", ent2:LocalToWorld(Vector(-270,0,89)))
		end
	end
end)

net.Receive("capaldi-PlayerExit", function()
	if tobool(GetConVarNumber("capaldi_doorsound"))==true then
		local ent1=net.ReadEntity()
		local ent2=net.ReadEntity()
		if IsValid(ent1) and ent1.visible then
			sound.Play("doctorwho1200/capaldi/door.wav", ent1:GetPos())
		end
		if IsValid(ent2) and not IsValid(LocalPlayer().capaldi_skycamera) then
			sound.Play("doctorwho1200/capaldi/door.wav", ent2:LocalToWorld(Vector(-270,0,89)))
		end
	end
end)

net.Receive("capaldi-SetRepairing", function()
	local capaldi=net.ReadEntity()
	local repairing=tobool(net.ReadBit())
	local interior=net.ReadEntity()
	if IsValid(capaldi) then
		capaldi.repairing=repairing
	end
	if IsValid(interior) and LocalPlayer().capaldi==capaldi and LocalPlayer().capaldi_viewmode and tobool(GetConVarNumber("capaldiint_powersound"))==true then
		if repairing then
			sound.Play("doctorwho1200/capaldi/powerdown.wav", interior:GetPos())
		else
			sound.Play("doctorwho1200/capaldi/powerup.wav", interior:GetPos())
		end
	end
end)

net.Receive("capaldi-BeginRepair", function()
	local capaldi=net.ReadEntity()
	if IsValid(capaldi) then
		/*
		local mat=Material("models/doctorwho1200/capaldi/2014")
		if not mat:IsError() then
			mat:SetTexture("$basetexture", "models/props_combine/metal_combinebridge001")
		end
		*/
	end
end)

net.Receive("capaldi-FinishRepair", function()
	local capaldi=net.ReadEntity()
	if IsValid(capaldi) then
		if tobool(GetConVarNumber("capaldiint_repairsound"))==true and capaldi.visible then
			sound.Play("doctorwho1200/capaldi/repairfinish.wav", capaldi:GetPos())
		end
		/*
		local mat=Material("models/doctorwho1200/capaldi/2010")
		if not mat:IsError() then
			mat:SetTexture("$basetexture", "models/doctorwho1200/capaldi/2014")
		end
		*/
	end
end)

net.Receive("capaldi-SetLight", function()
	local capaldi=net.ReadEntity()
	local on=tobool(net.ReadBit())
	if IsValid(capaldi) then
		capaldi.light_on=on
	end
end)

net.Receive("capaldi-SetPower", function()
	local capaldi=net.ReadEntity()
	local on=tobool(net.ReadBit())
	local interior=net.ReadEntity()
	if IsValid(capaldi) then
		capaldi.power=on
	end
	if IsValid(interior) and LocalPlayer().capaldi==capaldi and LocalPlayer().capaldi_viewmode and tobool(GetConVarNumber("capaldiint_powersound"))==true then
		if on then
			sound.Play("doctorwho1200/capaldi/powerup.wav", interior:GetPos())
		else
			sound.Play("doctorwho1200/capaldi/powerdown.wav", interior:GetPos())
		end
	end
end)

net.Receive("capaldi-SetVortex", function()
	local capaldi=net.ReadEntity()
	local on=tobool(net.ReadBit())
	if IsValid(capaldi) then
		capaldi.invortex=on
	end
end)

surface.CreateFont( "HUDNumber", {font="Trebuchet MS", size=40, weight=900} )

hook.Add("HUDPaint", "capaldi-DrawHUD", function()
	local p = LocalPlayer()
	local capaldi = p.capaldi
	if capaldi and IsValid(capaldi) and capaldi.health and (tobool(GetConVarNumber("capaldi_takedamage"))==true or capaldi.exploded) then
		local health = math.floor(capaldi.health)
		local n=0
		if health <= 99 then
			n=20
		end
		if health <= 9 then
			n=40
		end
		local col=Color(255,255,255)
		if health <= 20 then
			col=Color(255,0,0)
		end
		draw.RoundedBox( 0, 5, ScrH()-55, 250-n, 50, Color(0, 0, 0, 180) )
		draw.DrawText("Integrity: "..health.."%","HUDNumber", 13, ScrH()-52, col)
	end
end)

hook.Add("CalcView", "capaldi_CLView", function( ply, origin, angles, fov )
	local capaldi=LocalPlayer().capaldi
	local viewent = LocalPlayer():GetViewEntity()
	if !IsValid(viewent) then viewent = LocalPlayer() end
	local dist= -300
	
	if capaldi and IsValid(capaldi) and viewent==LocalPlayer() and not LocalPlayer().capaldi_viewmode then
		local pos=capaldi:GetPos()+(capaldi:GetUp()*50)
		local tracedata={}
		tracedata.start=pos
		tracedata.endpos=pos+ply:GetAimVector():GetNormal()*dist
		tracedata.mask=MASK_NPCWORLDSTATIC
		local trace=util.TraceLine(tracedata)
		local view = {}
		view.origin = trace.HitPos
		view.angles = angles
		return view
	end
end)

hook.Add( "HUDShouldDraw", "capaldi-HideHUD", function(name)
	local viewmode=LocalPlayer().capaldi_viewmode
	if ((name == "CHudHealth") or (name == "CHudBattery")) and viewmode then
		return false
	end
end)