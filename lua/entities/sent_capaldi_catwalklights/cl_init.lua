include('shared.lua')

function ENT:Draw()
	if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode and not LocalPlayer().capaldi_render then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self.catwalklights={}
	self.catwalklights.pos=0
	self.catwalklights.mode=1
	self.PosePosition = 0.5
end

function ENT:Think()
	local capaldi=self:GetNWEntity("capaldi",NULL)
	if IsValid(capaldi) and LocalPlayer().capaldi_viewmode and LocalPlayer().capaldi==capaldi then
	  if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode then
		  local TargetPos = 0.0;
		  if ( self:GetOn() ) then TargetPos = 1.0; end
		  self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1.5 )
		  self:SetPoseParameter( "catwalklights", self.PosePosition )
		  self:InvalidateBoneCache()
		
	  end
			if capaldi.health and capaldi.health > 0 and not capaldi.repairing and capaldi.power then
	                          self:SetColor(Color(255,255,255))
			             if capaldi.health < 21 then
	                                       self:SetColor(Color(255,0,0))
			             end
                        else
                                  self:SetColor(Color(100,100,100))
			end
                        mat=Material("models/doctorwho1200/capaldi/catwalklights")

			if not capaldi.moving and not capaldi.flightmode then
			          self:SetMaterial("models/doctorwho1200/capaldi/catwalklightsstatic")
                        else
                                  self:SetMaterial("models/doctorwho1200/capaldi/catwalklights")
			end
        end
end