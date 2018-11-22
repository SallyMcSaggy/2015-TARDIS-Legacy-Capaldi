ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "TARDIS Interior"
ENT.Author			= "Dr. Matt"
ENT.Contact			= "mattjeanes23@gmail.com"
ENT.Instructions	= "Don't spawn this!"
ENT.Purpose			= "Time and Relative Dimension in Space's Interior"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Category		= "Doctor Who"
ENT.capaldi_part		= true

hook.Add("PhysgunPickup", "capaldiInt-PhysgunPickup", function(_,e)
	if e.capaldi_part then
		return false
	end
end)

hook.Add("OnPhysgunReload", "capaldiInt-OnPhysgunReload", function(_,p)
	local e = p:GetEyeTraceNoCursor().Entity
	if e.capaldi_part then
		return false
	end
end)

local modes={
	"remover"
}
hook.Add("CanTool", "capaldiInt-CanTool", function(ply,tr,mode)
	local e=tr.Entity
	if table.HasValue(modes,mode) and IsValid(e) and e.capaldi_part then
		return false
	end
end)

hook.Add("CanProperty", "capaldiInt-CanProperty", function(ply,property,e)
	if e.capaldi_part then
		return false
	end
end)

hook.Add("InitPostEntity", "capaldiInt-InitPostEntity", function()
	if pewpew and pewpew.NeverEverList then // nice and easy, blocks pewpew from damaging the interior.
		table.insert(pewpew.NeverEverList, "sent_capaldi_interior")
		hook.Add("PewPew_ShouldDamage","capaldiInt-BlockDamage",function(pewpew,e,dmg,dmgdlr)
			if e.capaldi_part then
				return false
			end
		end)
	end
	if ACF and ACF_Check then // this one is a bit hacky, but ACFs internal code is shockingly bad.
		local original=ACF_Check
		function ACF_Check(e)
			if IsValid(e) then
				local class=e:GetClass()
				if class=="sent_capaldi_interior" or e.capaldi_part then
					if not e.ACF then ACF_Activate(e) end
					return false
				end
			end
			return original(e)
		end
	end
	if XCF and XCF_Check then // this one is also a bit hacky, but XCFs internal code is shockingly bad.
		local original=XCF_Check
		function XCF_Check(e,i)
			if IsValid(e) then
				local class=e:GetClass()
				if class=="sent_capaldi_interior" or e.capaldi_part then
					if not e.ACF then ACF_Activate(e) end
					return false
				end
			end
			return original(e,i)
		end
	end
end)