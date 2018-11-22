AddCSLuaFile( "von.lua" )
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("capaldiInt-Locations-GUI")
util.AddNetworkString("capaldiInt-Locations-Send")

function ENT:Initialize()
	self:SetModel( "models/doctorwho1200/capaldi/coordinate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetColor(Color(255,255,255,255))
	self.phys = self:GetPhysicsObject()
	self:SetNWEntity("capaldi",self.capaldi)
	self.usecur=0
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end		-- Who the frig is pressing this shit!?
	if IsValid(self.capaldi) and ((self.capaldi.isomorphic and not (activator==self.owner)) or not self.capaldi.power) then
		return
	end
	
	local interior=self.interior
	local capaldi=self.capaldi
	if IsValid(interior) and IsValid(self.capaldi) and IsValid(self) then
		interior.usecur=CurTime()+1
		if CurTime()>self.usecur then
			self.usecur=CurTime()+1
			if tobool(GetConVarNumber("capaldi_advanced"))==true then
				interior:UpdateAdv(activator,false)
			end
			net.Start("capaldiInt-Locations-GUI")
				net.WriteEntity(self.interior)
				net.WriteEntity(self.capaldi)
				net.WriteEntity(self)
			net.Send(activator)
		end
	end
	if IsValid(self.capaldi) then
		net.Start("capaldiInt-ControlSound")
			net.WriteEntity(self.capaldi)
			net.WriteEntity(self)
			net.WriteString("doctorwho1200/capaldi/coordinate.wav")
		net.Broadcast()
	end
	
	self:NextThink( CurTime() )
	return true
end

net.Receive("capaldiInt-Locations-Send", function(l,ply)
	local interior=net.ReadEntity()
	local capaldi=net.ReadEntity()
	local coordinate=net.ReadEntity()
	if IsValid(interior) and IsValid(capaldi) and IsValid(coordinate) then
		local pos=Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local ang=Angle(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		if tobool(GetConVarNumber("capaldi_advanced"))==true then
			if interior.flightmode==0 and interior.step==0 then
				local success=interior:StartAdv(2,ply,pos,ang)
				if success then
					ply:ChatPrint("Programmable flightmode activated.")
				end
			else
				interior:UpdateAdv(ply,false)
			end
		else
			if not capaldi.invortex then
				coordinate.pos=pos
				coordinate.ang=ang
				ply:ChatPrint("TARDIS destination set.")
			end
		end
		
		if capaldi.invortex then
			capaldi:SetDestination(pos,ang)
			ply:ChatPrint("TARDIS destination set.")
		end
	end
end)