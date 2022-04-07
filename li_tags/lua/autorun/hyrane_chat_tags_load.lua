Hyrane = Hyrane or {}
Hyrane.ChatTags = Hyrane.ChatTags or {}

function Hyrane.ChatTags:CreateFont(name, size, weight)
	surface.CreateFont(name, {
		font = "Montserrat",
		size = size,
		weight = weight or 500
	})
end

function Hyrane.ChatTags:IncludeClient(path)
	if (CLIENT) then
		include("hyrane_chat_tags/" .. path .. ".lua")
	end

	if (SERVER) then
		AddCSLuaFile("hyrane_chat_tags/" .. path .. ".lua")
	end
end

function Hyrane.ChatTags:IncludeServer(path)
	if (SERVER) then
		include("hyrane_chat_tags/" .. path .. ".lua")
	end
end

function Hyrane.ChatTags:IncludeShared(path)
	self:IncludeServer(path)
	self:IncludeClient(path)
end

Hyrane.ChatTags:IncludeShared("config/config")

Hyrane.ChatTags:IncludeServer("db/db")

Hyrane.ChatTags:IncludeClient("ui/frame")

Hyrane.ChatTags:IncludeShared("helper")

Hyrane.ChatTags:IncludeServer("network/server")
Hyrane.ChatTags:IncludeClient("network/client")