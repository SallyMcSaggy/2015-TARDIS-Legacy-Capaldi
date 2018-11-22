AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/doctorwho1200/capaldi/sticks.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetUseType( ONOFF_USE )
	self:SetColor(Color(255,255,255,255))
	self.phys = self:GetPhysicsObject()
	self:SetNWEntity("capaldi",self.capaldi)
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:SetLabel( text )

	text = string.gsub( text, "\\", "" )
	text = string.sub( text, 0, 20 )
	
	if ( text != "" ) then
	
		text = "\""..text.."\""
	
	end
	
	self:SetOverlayText( text )
	
end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end		-- Who the frig is pressing this shit!?
	if IsValid(self.capaldi) and self.capaldi.isomorphic and not (activator==self.owner) then
		return
	end
	
	if ( self:GetIsToggle() ) then

		if ( type == USE_ON ) then
			self:Toggle( !self:GetOn(), activator )
		end
		return;

	end

	if ( IsValid( self.LastUser ) ) then return end		-- Someone is already using this sticks

	--
	-- Switch off
	--
	if ( self:GetOn() ) then 
	
		self:Toggle( false, activator )
		
	return end

	--
	-- Switch on
	--
	self:Toggle( true, activator )
	self:NextThink( CurTime() )
	self.LastUser = activator
	
end

function ENT:Think()
	if ( self:GetOn() && !self:GetIsToggle() ) then 
	
		if ( !IsValid( self.LastUser ) || !self.LastUser:KeyDown( IN_USE ) ) then
			
			self:Toggle( false, self.LastUser )
			self.LastUser = nil
			
		end	

		self:NextThink( CurTime() )
		return true
	
	end
end

--
-- Makes the sticks trigger the keys
--
function ENT:Toggle( bEnable, ply )
	if ( bEnable ) then
		self:SetOn( true )
	else
		self:SetOn( false )
	end
	
	local interior=self.interior
	if IsValid(interior) then
		interior.usecur=CurTime()+1
	end
	if tobool(GetConVarNumber("capaldi_advanced"))==true and IsValid(interior) then
		if (interior.flightmode==1 or interior.flightmode==2 or interior.flightmode==3) and interior.step==2 then
			interior:UpdateAdv(ply, true)
		else
			interior:UpdateAdv(ply, false)
		end
	end
	
	if IsValid(self.capaldi) then
		net.Start("capaldiInt-ControlSound")
			net.WriteEntity(self.capaldi)
			net.WriteEntity(self)
			net.WriteString("doctorwho1200/capaldi/sticks.wav")
		net.Broadcast()
	end
end