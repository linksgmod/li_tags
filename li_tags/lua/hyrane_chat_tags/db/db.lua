local DB = {}

function DB:GetConnection()
	return MySQLite
end

function DB:Replace(str, tbl)
	for i, v in pairs(tbl) do
		str = str:Replace(":" .. i, v)
	end

	return str
end

function DB:Setup()
	local conn = self:GetConnection()

	/*
	conn.query("DROP TABLE IF EXISTS hyrane_chat_tags_purchased")
	conn.query("DROP TABLE IF EXISTS hyrane_chat_tags_equipped")
	conn.query("DROP TABLE IF EXISTS hyrane_chat_tags_custom")
	conn.query("DROP TABLE IF EXISTS hyrane_chat_tags_custom_owns")
	*/

	conn.query([[
		CREATE TABLE IF NOT EXISTS hyrane_chat_tags_purchased (
			sid64 CHAR(22),
			id VARCHAR(64),
			PRIMARY KEY (sid64, id)
		)
	]])

	conn.query([[
		CREATE TABLE IF NOT EXISTS hyrane_chat_tags_equipped (
			sid64 CHAR(22),
			id VARCHAR(64),
			PRIMARY KEY (sid64)
		)
	]])

	conn.query([[
		CREATE TABLE IF NOT EXISTS hyrane_chat_tags_custom (
			sid64 CHAR(22),
			tag VARCHAR(64) NOT NULL,
			color VARCHAR(64) NOT NULL,
			PRIMARY KEY (sid64)
		)
	]])

	conn.query([[
		CREATE TABLE IF NOT EXISTS hyrane_chat_tags_custom_owns (
			sid64 CHAR(22),
			PRIMARY KEY (sid64)
		)
	]])
end

hook.Add("DarkRPDatabaseInitialized", "Hyrane.ChatTags", function()
	DB:Setup()
end)

function DB:AddTag(sid64, tag)
	local conn = self:GetConnection()
	local sql = [[
		INSERT IGNORE INTO hyrane_chat_tags_purchased (sid64, id)
		VALUES (':sid64', ':id')
	]]
	sql = self:Replace(sql, {
		sid64 = sid64,
		id = tag
	})

	conn.query(sql)
end

function DB:GetTags(sid64, callback)
	local conn = self:GetConnection()
	local sql = [[
		SELECT id FROM hyrane_chat_tags_purchased
		WHERE sid64 = ':sid64'
	]]
	sql = sql:Replace(":sid64", sid64)
	
	conn.query(sql, function(result)
		callback(result and result or {})
	end)
end

function DB:Equip(sid64, id)
	local conn = self:GetConnection()
	if (color) then
		color = color.r .. "," .. color.g .. "," .. color.b
	end
	local sql = [[
		INSERT INTO hyrane_chat_tags_equipped (sid64, id)
		VALUES (':sid64', ':id')
		ON DUPLICATE KEY 
			UPDATE
				id = ':id'
	]]
	sql = self:Replace(sql, {
		sid64 = sid64,
		id = id
	})

	conn.query(sql)
end

function DB:Unequip(sid64)
	local conn = self:GetConnection()
	local sql = [[
		DELETE FROM hyrane_chat_tags_equipped
		WHERE sid64 = ':sid64'
	]]
	sql = sql:Replace(":sid64", sid64)

	conn.query(sql)
end

function DB:GetEquipped(sid64, callback)
	local conn = self:GetConnection()
	local sql = [[
		SELECT id FROM hyrane_chat_tags_equipped
		WHERE sid64 = ':sid64'
	]]
	sql = sql:Replace(":sid64", sid64)

	conn.query(sql, function(result)
		callback(result and result[1] and result[1].id)
	end)
end

function DB:SetOwnsCustom(sid64)
	local conn = self:GetConnection()
	local sql = [[
		INSERT IGNORE INTO hyrane_chat_tags_custom_owns (sid64)
		VALUES (':sid64')
	]]
	sql = sql:Replace(":sid64", sid64)

	conn.query(sql)
end

function DB:SetCustom(sid64, tag, col)
	local conn = self:GetConnection()
	tag = conn.SQLStr(tag)
	col = col.r .. "," .. col.g .. "," .. col.b
	local sql = [[
		INSERT INTO hyrane_chat_tags_custom (sid64, tag, color)
		VALUES (':sid64', :tag, ':color')
		ON DUPLICATE KEY 
			UPDATE
				tag = :tag,
				color = ':color'
	]]
	sql = self:Replace(sql, {
		sid64 = sid64,
		tag = tag,
		color = col
	})

	conn.query(sql)
end

function DB:RemoveCustom(sid64)
	local conn = self:GetConnection()
	local sql = [[
		DELETE FROM hyrane_chat_tags_custom 
		WHERE sid64 = ':sid64'
	]]
	sql = self:Replace(sql, {
		sid64 = sid64
	})

	conn.query(sql)
end

function DB:GetCustom(sid64, callback)
	local conn = self:GetConnection()
	local sql = [[
		SELECT tag, color FROM hyrane_chat_tags_custom
		WHERE sid64 = ':sid64'
	]]
	sql = sql:Replace(":sid64", sid64)

	conn.query(sql, function(result)
		callback(result and result[1] or {})
	end)
end

function DB:GetOwnsCustom(sid64, callback)
	local conn = self:GetConnection()
	local sql = [[
		SELECT sid64 FROM hyrane_chat_tags_custom_owns
		WHERE sid64 = ':sid64'
	]]
	sql = sql:Replace(":sid64", sid64)

	conn.query(sql, function(result)
		callback(result and result[1])
	end)
end

Hyrane.ChatTags.Database = DB