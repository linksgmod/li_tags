local CLASS = {}
CLASS.__index = CLASS
CLASS.tags = {}

AccessorFunc(CLASS, "m_player", "Player")
AccessorFunc(CLASS, "m_customTag", "CustomTag")
AccessorFunc(CLASS, "m_color", "Color")
AccessorFunc(CLASS, "m_equipped", "Equipped")
AccessorFunc(CLASS, "m_ownsCustomTag", "OwnsCustomTag")

function CLASS:Sid64()
	return self:GetPlayer():SteamID64()
end

function CLASS:AddTag(tag, ignoreDb)
	self.tags[tag] = true

	if (SERVER and !ignoreDb) then
		Hyrane.ChatTags.Database:AddTag(self:Sid64(), tag)
	end
end

function CLASS:GetTag(tag)
	return self.tags[tag]
end

function CLASS:SetColor(col)
	self.m_color = col
end

function CLASS:SetCustomTag(tag)
	self.m_customTag = tag

	if (SERVER and tag and self:GetColor()) then
		Hyrane.ChatTags.Database:SetCustom(self:Sid64(), tag, self:GetColor())
		Hyrane.ChatTags.Database:Unequip(self:Sid64())
	end
end

function CLASS:SetEquipped(equipped)
	self.m_equipped = equipped

	if (SERVER and equipped) then
		Hyrane.ChatTags.Database:Equip(self:Sid64(), equipped)
	elseif (SERVER and !equipped) then
		Hyrane.ChatTags.Database:Unequip(self:Sid64())
	end
end

function CLASS:SetOwnsCustomTag(bool)
	self.m_ownsCustomTag = bool

	if (SERVER and bool) then
		Hyrane.ChatTags.Database:SetOwnsCustom(self:Sid64())
	end
end

function CLASS:Load()
	local ply = self:GetPlayer()
	local db = Hyrane.ChatTags.Database
	local sid64 = self:Sid64()

	db:GetTags(sid64, function(tags)
		for i, v in pairs(tags) do
			self.tags[v.id] = true
		end

		db:GetOwnsCustom(sid64, function(owns)
			self:SetOwnsCustomTag(owns and true or false)

			db:GetCustom(sid64, function(tag)
				if (tag.tag and tag.color) then
					local col = Color(0, 0, 0)
					local split = string.Explode(",", tag.color)
					col.r = split[1]
					col.g = split[2]
					col.b = split[3]
					self:SetColor(col)
					self:SetCustomTag(tag.tag)

					ply:SetNW2String("ChatTags.Tag", self:GetCustomTag())
					ply:SetNW2Vector("ChatTags.Color", Vector(col.r, col.g, col.b))
				end

				db:GetEquipped(sid64, function(equipped)
					if (equipped) then
						self:SetEquipped(equipped)
						local tbl = Hyrane.ChatTags.Config.Tags[equipped]
						if (tbl) then
							ply:SetNW2String("ChatTags.Tag", equipped)
							ply:SetNW2Vector("ChatTags.Color", tbl.col)
						end
					end

					local tbl = {}
					tbl.tags = self.tags
					tbl.ownsCustom = self:GetOwnsCustomTag()
					tbl.custom = {
						tag = self:GetCustomTag(),
						col = self:GetColor()
					}
					tbl.equipped = equipped

					net.Start("Hyrane.ChatTags.Sync")
						net.WriteTable(tbl)
					net.Send(ply)
				end)
			end)
		end)
	end)
end

local PLY = FindMetaTable("Player")

function PLY:ChatTags()
	if (!self.chattags) then
		self.chattags = table.Copy(CLASS)
		self.chattags:SetPlayer(self)
	end

	return self.chattags
end

if (CLIENT) then
	-- This is so fkn gay idk man
	local cfg = Hyrane.ChatTags.Config
	hook.Add("OnPlayerChat", "Hyrane.ChatTags.Replacement", function(ply, _text, teamOnly, alive, prefixText, color1, color2)		
		if ply:IsPlayer() then
			local tbl = {}
			local prefix = string.lower(prefixText)
			if (prefix:sub(2, 7) == "advert") then
				table.insert(tbl, color_white)
				table.insert(tbl, "[")
				table.insert(tbl, Hyrane.ChatTags.Config.ChatColors.Advert)
				table.insert(tbl, "Advert")
				table.insert(tbl, color_white)
				table.insert(tbl, "] ")
			elseif (prefix:sub(2, 3) == "pm") then
				table.insert(tbl, color_white)
				table.insert(tbl, "[")
				table.insert(tbl, Hyrane.ChatTags.Config.ChatColors.PM)
				table.insert(tbl, "PM")
				table.insert(tbl, color_white)
				table.insert(tbl, "] ")
			elseif (prefix:sub(2, 4) == "ooc") then
				table.insert(tbl, color_white)
				table.insert(tbl, "[")
				table.insert(tbl, Hyrane.ChatTags.Config.ChatColors.OOC)
				table.insert(tbl, "OOC")
				table.insert(tbl, color_white)
				table.insert(tbl, "] ")
			end
			if (!ply:Alive()) then
				table.insert(tbl, color_white)
				table.insert(tbl, "[")
				table.insert(tbl, Hyrane.ChatTags.Config.ChatColors.Dead)
				table.insert(tbl, "DEAD")
				table.insert(tbl, color_white)
				table.insert(tbl, "] ")
			end

			local rank = ply:GetUserGroup()
			local chatRank = cfg.ChatRanks[rank]
			if (chatRank) then
				table.insert(tbl, chatRank.borderCol or color_white)
				table.insert(tbl, "[")
				table.insert(tbl, chatRank.col)
				table.insert(tbl, chatRank.name)
				table.insert(tbl, chatRank.borderCol or color_white)
				table.insert(tbl, "] ")
			end

			local text = ply:GetNW2String("ChatTags.Tag")
			local col = ply:GetNW2Vector("ChatTags.Color")
			if (text and text != "" and col) then
				col = cfg.Tags[text] and cfg.Tags[text].col or Color(col.x, col.y, col.z)

				table.insert(tbl, color_white)
				table.insert(tbl, "[")
				table.insert(tbl, col)
				table.insert(tbl, text)
				table.insert(tbl, color_white)
				table.insert(tbl, "] ")
			end
			
			table.insert(tbl, team.GetColor(ply:Team()))
			table.insert(tbl, ply:Nick() .. ": ")
			table.insert(tbl, color_white)
			table.insert(tbl, _text)

			chat.AddText(unpack(tbl))

			return true
		end
	end)
end