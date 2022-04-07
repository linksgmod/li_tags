net.Receive("Hyrane.ChatTags.Sync", function(len)
	local ply = LocalPlayer()
	local cT = ply:ChatTags()
	local tbl = net.ReadTable()

	cT:SetOwnsCustomTag(tbl.ownsCustom)
	cT.tags = tbl.tags
	if (tbl.custom.tag and tbl.custom.col) then
		cT:SetColor(tbl.custom.col)
		cT:SetCustomTag(tbl.custom.tag)
	end
	if (tbl.equipped) then
		cT:SetEquipped(tbl.equipped)
	end
end)

net.Receive("Hyrane.ChatTags.AutomaticMessage", function(len)
	local id = net.ReadUInt(16)
	local tbl = Hyrane.ChatTags.Config.AutoMessages[id]

	chat.AddText(Color(46, 204, 113, 255), "[NOTIFICATION] ",
		unpack(tbl)
	)
end)