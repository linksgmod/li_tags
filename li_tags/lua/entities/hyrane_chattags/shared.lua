ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Chat Tags NPC"
ENT.Author = "Links#0001"
ENT.Category = "Azure | NPCs"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end