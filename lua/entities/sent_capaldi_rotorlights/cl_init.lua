include('shared.lua')

function ENT:Draw()
	if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode and not LocalPlayer().capaldi_render then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self.rotorlights={}
	self.rotorlights.pos=0
	self.rotorlights.mode=1
	self.PosePosition = 0.5
end

function ENT:Think()
	local capaldi=self:GetNWEntity("capaldi",NULL)
	if IsValid(capaldi) and LocalPlayer().capaldi_viewmode and LocalPlayer().capaldi==capaldi then
	  if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode then
		  local TargetPos = 0.0;
		  if ( self:GetOn() ) then TargetPos = 1.0; end
		  self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1.5 )
		  self:SetPoseParameter( "rotorlights", self.PosePosition )
		  self:InvalidateBoneCache()
		
	  end
			if capaldi.health and capaldi.health > 0 and not capaldi.repairing and capaldi.power then
	                          self:SetColor(Color(255,255,255))
                        else
                                  self:SetColor(Color(100,100,100))
			end
        end
end