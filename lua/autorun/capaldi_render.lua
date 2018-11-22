if SERVER then
	hook.Add( "SetupPlayerVisibility", "capaldi-Render", function(ply,viewent)
		if IsValid(ply.capaldi) then
			AddOriginToPVS(ply.capaldi:GetPos())
		end
	end)
elseif CLIENT then
	local rt,mat
	local size=1024
	local CamData = {}
	CamData.x = 0
	CamData.y = 0
	CamData.fov = 90
	CamData.drawviewmodel = false
	CamData.w = size
	CamData.h = size
	
	hook.Add("InitPostEntity", "capaldi-Render", function()
		rt=GetRenderTarget("capaldi_rt",size,size,false)
		mat=Material("models/doctorwho1200/capaldi/Scanner")
		mat:SetTexture("$basetexture",rt)
	end)
	
	hook.Add("RenderScene", "capaldi-Render", function()
		if tobool(GetConVarNumber("capaldiint_scanner"))==false then return end
		local capaldi=LocalPlayer().capaldi
		if IsValid(capaldi) and LocalPlayer().capaldi_viewmode then
			CamData.origin = capaldi:LocalToWorld(Vector(24, 0, 80))
			CamData.angles = capaldi:GetAngles()
			LocalPlayer().capaldi_render=true
			local old = render.GetRenderTarget()
			render.SetRenderTarget( rt )
			render.Clear(0,0,0,255)
			cam.Start2D()
				render.RenderView(CamData)
			cam.End2D()
			render.CopyRenderTargetToTexture(rt)
			render.SetRenderTarget(old)
			LocalPlayer().capaldi_render=false
		end
	end)
	
	hook.Add( "PreDrawHalos", "capaldi-Render", function() // not ideal, but the new scanner sorta forced me to do this
		if tobool(GetConVarNumber("capaldiint_halos"))==false then return end
		local capaldi=LocalPlayer().capaldi
		if IsValid(capaldi) and not LocalPlayer().capaldi_render then
			local Interior=capaldi:GetNWEntity("Interior",NULL)
			if IsValid(Interior) and Interior.parts then
				for k,v in pairs(Interior.parts) do
					if v.shouldglow then
						halo.Add( {v}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
					end
				end
			end
		end
	end )
end