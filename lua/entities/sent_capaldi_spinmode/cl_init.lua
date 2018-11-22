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
	local capaldi=self:GetNWEntity("capaldi", NULL)
	if IsValid(capaldi) and LocalPlayer().capaldi==capaldi and LocalPlayer().capaldi_viewmode then
		local mode=self:GetMode()
		if (capaldi.flightmode or capaldi.moving) and not (mode==0) then
			local TargetPos
			if ( mode==-1 ) then
				TargetPos = 1.0
				if self.PosePosition==1 then
					self.PosePosition=0
				end
			elseif ( mode==1 ) then
				TargetPos = 0.0
				if self.PosePosition==0 then
					self.PosePosition=1
				end
			end
			self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1 )
			self:SetPoseParameter( "switch", self.PosePosition )
			self:InvalidateBoneCache()
		end
		
	end
end