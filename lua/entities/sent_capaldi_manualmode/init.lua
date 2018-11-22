AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/doctorwho1200/capaldi/telepathic.mdl" )
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
	if IsValid(self.capaldi) and self.capaldi.isomorphic and not (activator==self.owner) then
		return
	end
	
	local interior=self.interior
	if IsValid(interior) then
		interior.usecur=CurTime()+1
		if CurTime()>self.usecur then
			self.usecur=CurTime()+1
			if tobool(GetConVarNumber("capaldi_advanced"))==true then
				if interior.flightmode==0 and interior.step==0 then
					local success=interior:StartAdv(1,activator)
					if success then
						activator:ChatPrint("Manual flightmode activated.")
					end
				else
					interior:UpdateAdv(activator,false)
				end
			end
		end
	end
	if IsValid(self.capaldi) then
		net.Start("capaldiInt-ControlSound")
			net.WriteEntity(self.capaldi)
			net.WriteEntity(self)
			net.WriteString("doctorwho1200/capaldi/manualmode.wav")
		net.Broadcast()
	end
	
	self:NextThink( CurTime() )
	return true
end