ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "2015 TARDIS"
ENT.Author			= "Dr. Matt"
ENT.Contact			= "mattjeanes23@gmail.com"
ENT.Instructions	= "Use with the sonic or press E to pilot."
ENT.Purpose			= "Time and Relative Dimensions in Space"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category		= "Doctor Who"

CreateConVar("capaldi_takedamage", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_flightphase", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_doubletrace", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_physdamage", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_nocollideteleport", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_advanced", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_teleportlock", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("capaldi_spawnoffset", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})

hook.Add("PhysgunDrop", "capaldi-PhysgunDrop", function(ply,ent)
	if ent.physlocked then
		ent:GetPhysicsObject():EnableMotion(false)
	end
end)

hook.Add("OnPhysgunReload", "capaldi-OnPhysgunReload", function(_,ply)
	local ent=ply:GetEyeTraceNoCursor().Entity
	if ent and IsValid(ent) and ent.physlocked then
		return false
	end
end)