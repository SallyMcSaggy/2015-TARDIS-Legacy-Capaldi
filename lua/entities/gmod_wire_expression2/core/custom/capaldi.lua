/******************************************************************************\
	capaldi custom E2 functions by Dr. Matt
\******************************************************************************/

E2Lib.RegisterExtension("capaldi", true)

local function CheckPP(ply, ent) // Prop Protection
	return hook.Call("PhysgunPickup", GAMEMODE, ply, ent)
end

local function capaldi_Get(ent)
	if ent and IsValid(ent) then
		if ent:GetClass()=="sent_capaldi_interior" and IsValid(ent.capaldi) then
			return ent.capaldi
		elseif ent:GetClass()=="sent_capaldi" then
			return ent
		elseif ent:IsPlayer() then
			if IsValid(ent.capaldi) then
				return ent.capaldi
			else
				return NULL
			end
		else
			return NULL
		end
	end
	return NULL
end

local function capaldi_Teleport(data,ent,pos,ang)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local pos=Vector(pos[1], pos[2], pos[3])
		if ang then ang=Angle(ang[1], ang[2], ang[3]) end
		local success=ent:Go(pos,ang)
		if success then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

local function capaldi_Phase(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:TogglePhase()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Flightmode(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:ToggleFlight()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Lock(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:ToggleLocked()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Physlock(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:TogglePhysLock()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Power(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:TogglePower()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Isomorph(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") or not IsValid(data.player) then return 0 end
		local success=ent:IsomorphicToggle(data.player)
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Longflight(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:ToggleLongFlight()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Materialise(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:LongReappear()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Selfrepair(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:ToggleRepair()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Track(data,ent,trackent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:SetTrackingEnt(trackent)
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Spinmode(data,ent,spinmode)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		ent:SetSpinMode(spinmode)
		return ent.spinmode
	end
	return 0
end

local function capaldi_SetDestination(data,ent,pos,ang)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local pos=Vector(pos[1], pos[2], pos[3])
		if ang then ang=Angle(ang[1], ang[2], ang[3]) end
		if ent.invortex then
			ent:SetDestination(pos,ang)
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

local function capaldi_FastReturn(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:FastReturn()
		if success then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

local function capaldi_HADS(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:ToggleHADS()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_FastDemat(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		local success=ent:DematFast()
		if success then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

// get details

local function capaldi_Moving(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.moving then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Visible(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.visible then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Flying(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.flightmode then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Locked(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.locked then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Physlocked(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.physlocked then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Powered(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.power then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Isomorphic(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.isomorphic then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Longflighted(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.longflight then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Selfrepairing(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.repairing then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_LastPos(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.lastpos then
			return ent.lastpos
		else
			return Vector()
		end
	end
	return Vector()
end

local function capaldi_LastAng(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.lastang then
			return {ent.lastang.p, ent.lastang.y, ent.lastang.r}
		else
			return {0,0,0}
		end
	end
	return {0,0,0}
end

local function capaldi_Health(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.health then
			return math.floor(ent.health)
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Tracking(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if IsValid(ent.trackingent) then
			return ent.trackingent
		else
			return NULL
		end
	end
	return NULL
end

local function capaldi_InVortex(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.invortex then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_IsHADS(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return 0 end
		if ent.hads then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function capaldi_Pilot(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_capaldi") then return NULL end
		if not ent.pilot then return NULL end
		return ent.pilot
	end
	return NULL
end

--------------------------------------------------------------------------------

//set details
e2function entity entity:capaldiGet()
	return capaldi_Get(this)
end

e2function number entity:capaldiDemat(vector pos)
	return capaldi_Teleport(self, this, pos)
end

e2function number entity:capaldiDemat(vector pos, angle rot)
	return capaldi_Teleport(self, this, pos, rot)
end

e2function number entity:capaldiPhase()
	return capaldi_Phase(self, this)
end

e2function number entity:capaldiFlightmode()
	return capaldi_Flightmode(self, this)
end

e2function number entity:capaldiLock()
	return capaldi_Lock(self, this)
end

e2function number entity:capaldiPhyslock()
	return capaldi_Physlock(self, this)
end

e2function number entity:capaldiPower()
	return capaldi_Power(self, this)
end

e2function number entity:capaldiIsomorph()
	return capaldi_Isomorph(self,this)
end

e2function number entity:capaldiLongflight()
	return capaldi_Longflight(self, this)
end

e2function number entity:capaldiMaterialise()
	return capaldi_Materialise(self, this)
end

e2function number entity:capaldiSelfrepair()
	return capaldi_Selfrepair(self, this)
end

e2function number entity:capaldiTrack(entity ent)
	return capaldi_Track(self, this, ent)
end

e2function number entity:capaldiSpinmode(number spinmode)
	return capaldi_Spinmode(self, this, spinmode)
end

e2function number entity:capaldiSetDestination(vector pos)
	return capaldi_SetDestination(self, this, pos)
end

e2function number entity:capaldiSetDestination(vector pos, angle rot)
	return capaldi_SetDestination(self, this, pos, rot)
end

e2function number entity:capaldiFastReturn()
	return capaldi_FastReturn(self, this)
end

e2function number entity:capaldiHADS()
	return capaldi_HADS(self, this)
end

e2function number entity:capaldiFastDemat()
	return capaldi_FastDemat(self, this)
end

// get details
e2function number entity:capaldiMoving()
	return capaldi_Moving(this)
end

e2function number entity:capaldiVisible()
	return capaldi_Visible(this)
end

e2function number entity:capaldiFlying()
	return capaldi_Flying(this)
end

e2function number entity:capaldiHealth()
	return capaldi_Health(this)
end

e2function number entity:capaldiLocked()
	return capaldi_Locked(this)
end

e2function number entity:capaldiPhyslocked()
	return capaldi_Physlocked(this)
end

e2function number entity:capaldiPowered()
	return capaldi_Powered(this)
end

e2function number entity:capaldiIsomorphic()
	return capaldi_Isomorphic(this)
end

e2function number entity:capaldiLongflighted()
	return capaldi_Longflighted(this)
end

e2function number entity:capaldiSelfrepairing()
	return capaldi_Selfrepairing(this)
end

e2function vector entity:capaldiLastPos()
	return capaldi_LastPos(this)
end

e2function angle entity:capaldiLastAng()
	return capaldi_LastAng(this)
end

e2function entity entity:capaldiTracking()
	return capaldi_Tracking(this)
end

e2function number entity:capaldiInVortex()
	return capaldi_InVortex(this)
end

e2function number entity:capaldiIsHADS()
	return capaldi_IsHADS(this)
end

e2function entity entity:capaldiPilot()
	return capaldi_Pilot(this)
end