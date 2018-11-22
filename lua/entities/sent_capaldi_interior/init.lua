AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("capaldi-SetViewmode")
util.AddNetworkString("capaldiInt-SetParts")
util.AddNetworkString("capaldiInt-UpdateAdv")
util.AddNetworkString("capaldiInt-SetAdv")
util.AddNetworkString("capaldiInt-ControlSound")

function ENT:Initialize()
	self:SetModel( "models/doctorwho1200/capaldi/interior.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:DrawShadow(false)
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
	
	self:SetNWEntity("capaldi",self.capaldi)
	
	self.viewcur=0
	self.throttlecur=0
	self.usecur=0
	self.flightmode=0 //0 is none, 1 is skycamera selection, 2 is idk yet or whatever and so on
	self.step=0
	
	
	if WireLib then
		Wire_CreateInputs(self, { "Demat", "Phase", "Flightmode", "X", "Y", "Z", "XYZ [VECTOR]", "Rot" })
		Wire_CreateOutputs(self, { "Health" })
	end
	
	self:SpawnParts()
	
	if IsValid(self.owner) then
		local rails=tobool(self.owner:GetInfoNum("capaldiint_rails",1))
		if rails then
			self.rails=self:MakePart("sent_capaldi_rails", Vector(0,0,0), Angle(0,0,0),true)
		end
		self:SetNWVector("mainlight",Vector(self.owner:GetInfoNum("capaldiint_mainlight_r",255),self.owner:GetInfoNum("capaldiint_mainlight_g",50),self.owner:GetInfoNum("capaldiint_mainlight_b",0)))
		self:SetNWVector("seclight",Vector(self.owner:GetInfoNum("capaldiint_seclight_r",0),self.owner:GetInfoNum("capaldiint_seclight_g",255),self.owner:GetInfoNum("capaldiint_seclight_b",0)))
		self:SetNWVector("warnlight",Vector(self.owner:GetInfoNum("capaldiint_warnlight_r",200),self.owner:GetInfoNum("capaldiint_warnlight_g",0),self.owner:GetInfoNum("capaldiint_warnlight_b",0)))
	end
end

function ENT:SpawnParts()
	if self.parts then
		for k,v in pairs(self.parts) do
			if IsValid(v) then
				v:Remove()
				v=nil
			end
		end
	end
	
	self.parts={}
	
	//chairs
	local vname="Seat_Airboat"
	local chair=list.Get("Vehicles")[vname]
	self.chair1=self:MakeVehicle(self:LocalToWorld(Vector(-130,-75,100)), Angle(0,-65,0), chair.Model, chair.Class, vname, chair)
	self.chair2=self:MakeVehicle(self:LocalToWorld(Vector(10,-150,100)), Angle(0,0,0), chair.Model, chair.Class, vname, chair)
	self.chair3=self:MakeVehicle(self:LocalToWorld(Vector(150,30,100)), Angle(0,100,0), chair.Model, chair.Class, vname, chair)
	self.chair4=self:MakeVehicle(self:LocalToWorld(Vector(40,150,100)), Angle(0,170,0), chair.Model, chair.Class, vname, chair)
	
	//parts	
	self.skycamera=self:MakePart("sent_capaldi_skycamera", Vector(0,0,-350), Angle(90,0,0),false)
	self.throttle=self:MakePart("sent_capaldi_throttle", Vector(0,0,0), Angle(0,0,0),true)
	self.spinmode=self:MakePart("sent_capaldi_spinmode", Vector(0,0,0), Angle(0,0,0),true)
	self.screen=self:MakePart("sent_capaldi_screen", Vector(0,0,0), Angle(0,0,0),true)
	self.flightlever=self:MakePart("sent_capaldi_flightlever", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.vortex=self:MakePart("sent_capaldi_vortex", Vector(0,0,0), Angle(0,0,0),true)
	self.manualmode=self:MakePart("sent_capaldi_manualmode", Vector(0,0,0), Angle(0,0,0),true)
	self.helmicregulator=self:MakePart("sent_capaldi_helmicregulator", Vector(0,0,0), Angle(0,0,0),true)
	self.fastreturn=self:MakePart("sent_capaldi_fastreturn", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.handbrake=self:MakePart("sent_capaldi_handbrake", Vector(0,0,0), Angle(0,0,0),true)
	self.longflighttoggle=self:MakePart("sent_capaldi_longflighttoggle", Vector(0,0, 0), Angle(0,0,0),true)
	self.coordinate=self:MakePart("sent_capaldi_coordinate", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.physbrake=self:MakePart("sent_capaldi_physbrake", Vector(0,25,0), Angle(0,0,0),true)
	self.repairlever=self:MakePart("sent_capaldi_repairlever", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.hads=self:MakePart("sent_capaldi_hads", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.powerlever=self:MakePart("sent_capaldi_powerlever", Vector(0,0, 0), Angle(0, 0, 0),true)
	self.isomorphic=self:MakePart("sent_capaldi_isomorphic", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.phaselever=self:MakePart("sent_capaldi_phaselever", Vector(0, 0, 0), Angle(0, 0,0),true)
	self.lock=self:MakePart("sent_capaldi_lock", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.button2=self:MakePart("sent_capaldi_button2", Vector(0, 9, 0), Angle(0, 0, 0),true)
	self.buttons=self:MakePart("sent_capaldi_buttons", Vector(0, 0, 0), Angle(0, 0, 0),true)
	self.audiosystem=self:MakePart("sent_capaldi_audiosystem", Vector(0,0,0), Angle(0,0,0),true)
	self.doorint=self:MakePart("sent_capaldi_doorint", Vector(0,0,0), Angle(0,0,0),true)
	self.console=self:MakePart("sent_capaldi_console", Vector(0,0,0), Angle(0,0,0),true)
	self.floor=self:MakePart("sent_capaldi_floor", Vector(0,0,0), Angle(0,0,0),true)
	self.portals=self:MakePart("sent_capaldi_portals", Vector(0,0,0), Angle(0,0,0),true)
	self.roundels=self:MakePart("sent_capaldi_roundels", Vector(0,0,0), Angle(0,0,0),true)
	self.trim=self:MakePart("sent_capaldi_trim", Vector(0,0,0), Angle(0,0,0),true)
	self.phone=self:MakePart("sent_capaldi_phone", Vector(0,0,0), Angle(0,0,0),true)
	self.switch=self:MakePart("sent_capaldi_switch", Vector(0,0,0.6), Angle(0,0,0),true)
	self.sticks=self:MakePart("sent_capaldi_sticks", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator2=self:MakePart("sent_capaldi_rotator2", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator3=self:MakePart("sent_capaldi_rotator3", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator4=self:MakePart("sent_capaldi_rotator4", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator5=self:MakePart("sent_capaldi_rotator5", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator6=self:MakePart("sent_capaldi_rotator6", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator7=self:MakePart("sent_capaldi_rotator7", Vector(0,0,0), Angle(0,0,0),true)
	self.rotator8=self:MakePart("sent_capaldi_rotator8", Vector(0,0,0.5), Angle(0,0,0),true)
	self.rotator8=self:MakePart("sent_capaldi_rotator8", Vector(0,0,0.5), Angle(0,199,0),true)
	self.lever=self:MakePart("sent_capaldi_lever", Vector(0,0,0), Angle(0,0,0),true)
	self.lever2=self:MakePart("sent_capaldi_lever2", Vector(0,0,0), Angle(0,199,0),true)
	self.regulator=self:MakePart("sent_capaldi_regulator", Vector(0,0,0), Angle(0,0,0),true)
	self.levers=self:MakePart("sent_capaldi_levers", Vector(0,0,0.2), Angle(0,0,0),true)
	self.levers2=self:MakePart("sent_capaldi_levers2", Vector(0,0,0.2), Angle(0,0,0),true)
	self.sliders=self:MakePart("sent_capaldi_sliders", Vector(0,0,0), Angle(0,0,0),true)
	self.switches=self:MakePart("sent_capaldi_switches", Vector(0,0,0), Angle(0,0,0),true)
	self.switches2=self:MakePart("sent_capaldi_switches2", Vector(0,0,0), Angle(0,0,0),true)
	self.catwalklights=self:MakePart("sent_capaldi_catwalklights", Vector(0,0,0), Angle(0,90,0),true)
	self.books=self:MakePart("sent_capaldi_books", Vector(0,0,0), Angle(0,0,0),true)
	self.rotorlights=self:MakePart("sent_capaldi_rotorlights", Vector(0,0,0), Angle(0,0,0),true)
	self.lights=self:MakePart("sent_capaldi_lights", Vector(0,0,0), Angle(0,90,0),true)
	
	timer.Simple(2,function() // delay exists so the entity can register on the client, allows for a ping of just under 2000 (should be fine lol)
		if IsValid(self) and self.parts then
			net.Start("capaldiInt-SetParts")
				net.WriteEntity(self)
				net.WriteFloat(#self.parts)
				for k,v in pairs(self.parts) do
					net.WriteEntity(v)
				end
			net.Broadcast()
		end
	end)
end

function ENT:StartAdv(mode,ply,pos,ang)
	if self.flightmode==0 and self.step==0 and IsValid(self.capaldi) and self.capaldi.power and not self.capaldi.moving then
		self.flightmode=mode
		self.step=1
		if pos and ang then
			self.advpos=pos
			self.advang=ang
		end
		net.Start("capaldiInt-SetAdv")
			net.WriteEntity(self)
			net.WriteEntity(ply)
			net.WriteFloat(mode)
		net.Send(ply)
		return true
	else
		return false
	end
end

function ENT:UpdateAdv(ply,success)
	if not (self.flightmode==0) and tobool(GetConVarNumber("capaldi_advanced"))==true and IsValid(self.capaldi) and self.capaldi.power then
		if success then
			self.step=self.step+1
			if self.flightmode==1 and self.step==11 then
				local skycamera=self.skycamera
				if IsValid(self.capaldi) and not self.capaldi.moving and IsValid(skycamera) and skycamera.hitpos and skycamera.hitang then
					self.capaldi:Go(skycamera.hitpos, skycamera.hitang)
					skycamera.hitpos=nil
					skycamera.hitang=nil
				else
					ply:ChatPrint("Error, already teleporting or no coordinates set.")
				end
				self.flightmode=0
				self.step=0
			elseif self.flightmode==2 and self.step==11 then
				if IsValid(self.capaldi) and not self.capaldi.moving and self.advpos and self.advpos then
					self.capaldi:Go(self.advpos, self.advang)
				else
					ply:ChatPrint("Error, already teleporting or no coordinates set.")
				end
				self.advpos=nil
				self.advang=nil
				self.flightmode=0
				self.step=0
			elseif self.flightmode==3 and self.step==11 then
				local success=self.capaldi:DematFast()
				if not success then
					ply:ChatPrint("Error, may be already teleporting.")
				end
				self.flightmode=0
				self.step=0
			end
		else
			//ply:ChatPrint("Failed.")
			self.flightmode=0
			self.step=0
			self.advpos=nil
			self.advang=nil
		end
		net.Start("capaldiInt-UpdateAdv")
			net.WriteBit(success)
		net.Send(ply)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:MakePart(class,vec,ang,weld)
	local ent=ents.Create(class)
	ent.capaldi=self.capaldi
	ent.interior=self
	ent.owner=self.owner
	ent:SetPos(self:LocalToWorld(vec))
	ent:SetAngles(ang)
	//ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:Spawn()
	ent:Activate()
	if weld then
		constraint.Weld(self,ent,0,0)
	end
	if IsValid(self.owner) then
		if SPropProtection then
			SPropProtection.PlayerMakePropOwner(self.owner, ent)
		else
			gamemode.Call("CPPIAssignOwnership", self.owner, ent)
		end
	end
	table.insert(self.parts,ent)
	return ent
end

function ENT:MakeVehicle( Pos, Ang, Model, Class, VName, VTable ) // for the chairs
	local ent = ents.Create( Class )
	if (!ent) then return NULL end
	
	ent:SetModel( Model )
	
	-- Fill in the keyvalues if we have them
	if ( VTable && VTable.KeyValues ) then
		for k, v in pairs( VTable.KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end
		
	ent:SetAngles( Ang )
	ent:SetPos( Pos )
		
	ent:Spawn()
	ent:Activate()
	
	ent.VehicleName 	= VName
	ent.VehicleTable 	= VTable
	
	-- We need to override the class in the case of the Jeep, because it 
	-- actually uses a different class than is reported by GetClass
	ent.ClassOverride 	= Class
	
	ent.capaldi_part=true
	ent:GetPhysicsObject():EnableMotion(false)
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetColor(Color(255,255,255,0))
	constraint.Weld(self,ent,0,0)
	if IsValid(self.owner) then
		if SPropProtection then
			SPropProtection.PlayerMakePropOwner(self.owner, ent)
		else
			gamemode.Call("CPPIAssignOwnership", self.owner, ent)
		end
	end
	
	table.insert(self.parts,ent)

	return ent
end

if WireLib then
	function ENT:TriggerInput(k,v)
		if self.capaldi and IsValid(self.capaldi) then
			self.capaldi:TriggerInput(k,v)
		end
	end
end

function ENT:SetHP(hp)
	if WireLib then
		Wire_TriggerOutput(self, "Health", math.floor(hp))
	end
end

function ENT:Explode()
	self.exploded=true
	
	self.fire = ents.Create("env_fire_trail")
	self.fire:SetPos(self:LocalToWorld(Vector(0,0,0)))
	self.fire:Spawn()
	self.fire:SetParent(self)
	
	local explode = ents.Create("env_explosion")
	explode:SetPos(self:LocalToWorld(Vector(0,0,50)))
	explode:Spawn()
	explode:Fire("Explode",0)
	explode:EmitSound("doctorwho1200/capaldi/explosion.wav", 100, 100 ) //Adds sound to the explosion
	
	self:SetColor(Color(255,233,200))
end

function ENT:UnExplode()
	self.exploded=false
	
	if self.fire and IsValid(self.fire) then
		self.fire:Remove()
		self.fire=nil
	end
	
	self:SetColor(Color(255,255,255))
end

function ENT:OnRemove()
	if self.fire then
		self.fire:Remove()
		self.fire=nil
	end
	for k,v in pairs(self.parts) do
		if IsValid(v) then
			v:Remove()
			v=nil
		end
	end
end

function ENT:PlayerLookingAt(ply,vec,fov,Width)	
	local Disp = vec - self:WorldToLocal(ply:GetPos()+Vector(0,0,100))
	local Dist = Disp:Length()
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + Width * Width ) ) + fov * ( math.pi / 50 ) ) )
	Disp:Normalize()
	
	if Disp:Dot( ply:EyeAngles():Forward() ) > MaxCos then
		return true
	end
	
    return false
end

function ENT:Use( ply )
	if CurTime()>self.usecur and self.capaldi and IsValid(self.capaldi) and ply.capaldi and IsValid(ply.capaldi) and ply.capaldi==self.capaldi and ply.capaldi_viewmode and not ply.capaldi_skycamera then

		//this must go last, or bad things may happen
		if CurTime()>self.capaldi.viewmodecur then
			local pos=Vector(0,0,100)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 110 and self:PlayerLookingAt(ply, Vector(0,0,100), 25, 25) then
				self.capaldi:ToggleViewmode(ply)
				self.usecur=CurTime()+1
				self.capaldi.viewmodecur=CurTime()+1
				return
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self.capaldi and IsValid(self.capaldi) then
		self.capaldi:OnTakeDamage(dmginfo)
	end
end

function ENT:Think()
	if self.capaldi and IsValid(self.capaldi) then
		if self.capaldi.occupants then
			for k,v in pairs(self.capaldi.occupants) do
				if self:GetPos():Distance(v:GetPos()) > 700 and v.capaldi_viewmode and not v.capaldi_skycamera then
					self.capaldi:PlayerExit(v,true)
				end
			end
		end
	end
end