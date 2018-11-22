include('shared.lua')

function ENT:Draw()
	if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode and not LocalPlayer().capaldi_render then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self.PosePosition = 0.5
end

function ENT:Think()
	if LocalPlayer().capaldi==self:GetNWEntity("capaldi", NULL) and LocalPlayer().capaldi_viewmode then
		local TargetPos = 0.0;
		if ( self:GetDir() ) then TargetPos = 1.0; end
		self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 0.7 )
		self:SetPoseParameter( "switch", self.PosePosition )
		self:InvalidateBoneCache()
	end
end