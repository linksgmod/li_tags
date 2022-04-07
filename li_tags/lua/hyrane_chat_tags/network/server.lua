util.AddNetworkString("Hyrane.ChatTags.Purchase")
util.AddNetworkString("Hyrane.ChatTags.Equip")
util.AddNetworkString("Hyrane.ChatTags.Equip.Custom")
util.AddNetworkString("Hyrane.ChatTags.Unequip")
util.AddNetworkString("Hyrane.ChatTags.Unequip.Custom")
util.AddNetworkString("Hyrane.ChatTags.PurchaseCustomTag")
util.AddNetworkString("Hyrane.ChatTags.Sync")
util.AddNetworkString("Hyrane.ChatTags.AutomaticMessage")

net.Receive("Hyrane.ChatTags.Purchase", function(len, ply)
	local tbl = Hyrane.ChatTags.Config.Tags
	local id = net.ReadString()
	tbl = tbl[id]
	if (!tbl) then return end
	local customCheck = tbl.customCheck or function() return true end
	local check = customCheck(ply)
	if (!check) then return end
	if (!ply:canAfford(tbl.price)) then return end
	if (tbl.usergroups and !tbl.usergroups[ply:GetUserGroup()]) then return end

	ply:addMoney(-tbl.price)

	local class = ply:ChatTags()
	class:AddTag(id)
end)

net.Receive("Hyrane.ChatTags.Equip", function(len, ply)
	local tbl = Hyrane.ChatTags.Config.Tags
	local id = net.ReadString()
	tbl = tbl[id]
	if (!tbl) then return end

	local class = ply:ChatTags()
	class:SetEquipped(id)
	class:SetColor(nil)
	class:SetCustomTag(nil)
	ply:SetNW2String("ChatTags.Tag", id)
	ply:SetNW2Vector("ChatTags.Color", tbl.col)

	Hyrane.ChatTags.Database:RemoveCustom(ply:SteamID64())
end)

net.Receive("Hyrane.ChatTags.Equip.Custom", function(len, ply)
	local str = net.ReadString()
	local col = net.ReadColor()
	if (#str > Hyrane.ChatTags.Config.MaxChars) then return end
	local class = ply:ChatTags()
	if (Hyrane.ChatTags.Config.BlacklistedWords[str:lower()]) then
		class:SetEquipped(nil)
		class:SetColor(nil)
		class:SetCustomTag(nil)
		
		ply:SetNW2String("ChatTags.Tag", nil)
		ply:SetNW2Vector("ChatTags.Color", nil)

		return 
	end

	class:SetEquipped(nil)
	class:SetColor(col)
	class:SetCustomTag(str)
	
	ply:SetNW2String("ChatTags.Tag", str)
	ply:SetNW2Vector("ChatTags.Color", Vector(col.r, col.g, col.b))
end)

net.Receive("Hyrane.ChatTags.Unequip", function(len, ply)
	local class = ply:ChatTags()
	class:SetEquipped(nil)
	class:SetColor(nil)
	class:SetCustomTag(nil)
	ply:SetNW2String("ChatTags.Tag", nil)
	ply:SetNW2Vector("ChatTags.Color", nil)

	Hyrane.ChatTags.Database:RemoveCustom(ply:SteamID64())
end)

net.Receive("Hyrane.ChatTags.Unequip.Custom", function(len, ply)
	local class = ply:ChatTags()
	Hyrane.ChatTags.Database:RemoveCustom(ply:SteamID64())
	class:SetColor(nil)
	class:SetCustomTag(nil)

	if (class:GetEquipped()) then return end

	ply:SetNW2String("ChatTags.Tag", nil)
	ply:SetNW2Vector("ChatTags.Color", nil)
end)

net.Receive("Hyrane.ChatTags.PurchaseCustomTag", function(len, ply)
    local price = Hyrane.ChatTags.Config.CustomTagPrice
    if (!ply:canAfford(price)) then return end

    ply:addMoney(-price)

    local class = ply:ChatTags()
    class:SetOwnsCustomTag(true)
end) 
-- Hiding it from scripthook kiddies
hook.Add("Initialize", "Hyrane.ChatTags", function()
	local i = 1
	timer.Create("Hyrane.ChatTags.AutomaticMessages", Hyrane.ChatTags.Config.AutoChatInterval, 0, function()
		net.Start("Hyrane.ChatTags.AutomaticMessage")
			net.WriteUInt(i, 16)
		net.Broadcast()

		i = i >= #Hyrane.ChatTags.Config.AutoMessages and 1 or i + 1
	end)
end)

hook.Add("PlayerInitialSpawn", "Hyrane.ChatTags", function(ply)
	timer.Simple(3, function()
		local cT = ply:ChatTags()
		cT:Load()
	end)
end)