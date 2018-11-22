AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("capaldiInt-Gramophone-GUI")
util.AddNetworkString("capaldiInt-Gramophone-Bounce")
util.AddNetworkString("capaldiInt-Gramophone-Send")

function ENT:Initialize()
	self:SetModel( "models/doctorwho1200/capaldi/audiosystem.mdl" )
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
	if IsValid(self) and IsValid(interior) and IsValid(capaldi) then
		interior.usecur=CurTime()+1
		if CurTime()>self.usecur then
			self.usecur=CurTime()+1
			net.Start("capaldiInt-Gramophone-GUI")
				net.WriteEntity(self)
				net.WriteEntity(capaldi)
				net.WriteEntity(interior)
			net.Send(activator)
		end
	end
	
	self:NextThink( CurTime() )
	return true
end

net.Receive("capaldiInt-Gramophone-Bounce", function(l,ply)
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
		net.Start("capaldiInt-Gramophone-Send")
			net.WriteEntity(gramophone)
			net.WriteEntity(capaldi)
			net.WriteEntity(interior)
			net.WriteBit(play)
			if play then
				net.WriteFloat(choice)
			end
			if custom then
				net.WriteBit(true)
				net.WriteString(customstr)
			else
				net.WriteBit(false)
			end
		net.Send(capaldi.occupants)
	end
end)