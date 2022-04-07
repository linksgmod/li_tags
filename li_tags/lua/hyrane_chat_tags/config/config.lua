local CONFIG = {}

CONFIG.Tags = {
	["Noble"] = {
		col = Color(181, 129, 72),
		price = 15000
	},
	["Sir"] = {
		col = Color(179, 175, 171),
		price = 25000
	},
	["Master"] = {
		col = Color(247, 228, 84),
		price = 50000
	},
	["Heroic"] = {
		col = Color(157, 235, 235),
		price = 75000
	},
	["TheBad"] = {
		col = Color(77, 74, 77),
		price = 75000
	},
	["Corona"] = {
		col = Color(30,230,30),
		price = 100000
	},
	["Hoe"] = {
		col = Color(252, 119, 3),
		price = 1000000
	},
	["1Bil"] = {
		col = Color(237, 109, 237),
		price = 1000000000
	},
	["Bronze"] = {
		col = Color(181, 129, 72),
		price = 15000
	},
	["Silver"] = {
		col = Color(179, 175, 171),
		price = 25000
	},
	["Gold"] = {
		col = Color(247, 228, 84),
		price = 50000
	},
	["Diamond"] = {
		col = Color(114, 236, 247),
		price = 75000
	},
	["Emerald"] = {
		col = Color(46, 204, 113),
		price = 200000
	},
	["Ruby"] = {
		col = Color(204, 46, 67),
		price = 400000
	},
	["100k"] = {
		col = Color(255, 36, 47),
		price = 100000
	},
	["250k"] = {
		col = Color(87, 230, 142),
		price = 250000
	},
	["500K"] = {
		col = Color(87, 230, 185),
		price = 500000
	},
	["1Mil"] = {
		col = Color(230, 170, 87),
		price = 1000000
	},
	["2Mil"] = {
		col = Color(232, 139, 220),
		price = 20000000
	},
	["5Mil"] = {
		col = Color(199, 82, 222),
		price = 50000000
	},
	["ICE"] = {
		col = Color(181, 244, 2552),
		price = 10000000
	},
	["Addicted"] = {
		col = Color(250, 120, 228),
		price = 10000000
	},
	["BROKE"] = {
		col = Color(255, 36, 47),
		price = 10000000
	},
	["0w0"] = {
		col = Color(197, 109, 252),
		price =  15000000
	},
	["420"] = {
		col = Color(81, 199, 52),
		price = 5000000
	},		
	["シ"] = {
		col = Color(111, 42, 201),
		price = 15000000
	},
	["666"] = {
		col = Color(255,0,0),
		price = 15000000
	},
  ["✪"] = {
    col = Color(255, 206, 71),
    price = 1500000
  },
	-- 	["Mystic"] = {
	-- 	col = Color(133, 81, 237),
	-- 	price = 10000000
	-- },
	-- 	["UseHexane"] = {
	-- 	col = Color(245, 56, 56),
	-- 	price = 10000000
	-- },
	-- 	["xD"] = {
	-- 	col = Color(247, 250, 80),
	-- 	price = 15000000
	-- },
	-- 	["Millionaire"] = {
	-- 	col = Color(54, 245, 63),
	-- 	price = 1000000
	-- },
	--     ["Hyranium"] = {
	-- 	col = Color(255, 88, 88),
	-- 	price = 20000000
	-- },
 --    ["Summer19"] = {
	-- 	col = Color(245, 221, 66),
	-- 	price = 0,
	-- 	Optional,
	-- 	usergroups = {
	-- 		["mystic"] = true
	-- 	}
	-- },
	-- ["Joeranium"] = {
	-- 	col = Color(255, 88, 88)
	-- },
}

CONFIG.CustomTagPrice = 10000000

CONFIG.BlacklistedWords = {
	["nigga"] = true,
	["n1gga"] = true,
	["nigg4"] = true,
	["n1gg4"] = true,
	["nogga"] = true,
	["n0gga"] = true,
	["nogg4"] = true,
	["n0gg4"] = true,
	["ddos"] = true,
	[" ddos"] = true,
	["ddos "] = true,
	["dd0s"] = true,
	[" dd0s"] = true,
	[" dd0s "] = true,
	["rapis"] = true,
	["rape"] = true,
	[" rape"] = true,
	["rape "] = true,
	["raper"] = true,
	["L33T"] = true,
	["nog"] = true,
	[" nog"] = true,
	["nog "] = true,
	[" n0g"] = true,
	["n0g "] = true,
	["ni33a"] = true,
	["pedo"] = true,
	[" pedo"] = true,
	["pedo "] = true,
	["ped0"] = true,
	["ped0 "] = true,
	[" ped0"] = true,
	["p3do"] = true,
	["p3do "] = true,
	[" p3do"] = true,
	["p3d0"] = true,
	["p3d0 "] = true,
	[" p3d0"] = true,
	["fuck"] = true,
	[" fuck"] = true,
	["fuck "] = true,
	["cunt"] = true,
	[" cunt"] = true,
	["cunt "] = true,
	["twat"] = true,
	[" twat"] = true,
	["twat "] = true,
	["nig"] = true,
	[" nig"] = true,
	["nig "] = true,
	["homo"] = true,
	["homo "] = true,
	[" homo"] = true,
	["gay"] = true,
	[" gay"] = true,
	["gay "] = true,
	["fag"] = true,
	["fag "] = true,
	[" fag"] = true,
	["coon"] = true,
	[" coon"] = true,
	["coon "] = true,
	["c0on"] = true,
	[" c0on"] = true,
	["c0on "] = true,
	["co0n"] = true,
	[" co0n"] = true,
	["co0n "] = true,
	["c00n"] = true,
	[" c00n"] = true,
	["c00n "] = true,
	["shit"] = true,
	[" shit"] = true,
	["shit "] = true,
	["sh1t"] = true,
	[" sh1t"] = true,
	["sh1t "] = true,
	["wank"] = true,
	[" wank"] = true,
	["wank "] = true,
	["w4nk"] = true,
	[" w4nk"] = true,
	["w4nk "] = true,
	["spazz"] = true,
	["sp4zz"] = true,
	["spaz"] = true,
	[" spaz"] = true,
	["spaz "] = true,
	["sp4z"] = true,
	[" sp4z"] = true,
	["sp4z "] = true,
	["nazi"] = true,
	[" nazi"] = true,
	["nazi "] = true,
	["naz1"] = true,
	[" naz1"] = true,
	["naz1 "] = true,
	["n4zi"] = true,
	[" n4zi"] = true,
	["n4zi "] = true,
	["n4z1"] = true,
	[" n4z1"] = true,
	["n4z1 "] = true,
	["godly"] = true,
	["g0dly"] = true,
	["elite"] = true,
	["3lite"] = true,
	["3l1te"] = true,
	["3l1t3"] = true,
	["el1t3"] = true,
	["el1te"] = true,
	["alien"] = true,
	["al1en"] = true,
	["ali3n"] = true,
	["al13n"] = true,
	[" 0w0"] = true,
	["0w0 "] = true,
	["0w0"] = true,
	[" 420"] = true,
	["420"] = true,
	["420 "] = true,
	["kappa"] = true,
	["k4ppa"] = true,
	["kapp4"] = true,
	["4app4"] = true,
	["nerd"] = true,
	[" nerd"] = true,
	["nerd "] = true,
	["n3rd"] = true,
	[" n3rd"] = true,
	["n3rd "] = true,
	["xD"] = true,
	[" xD"] = true,
	["xD "] = true,
	["卍"] = true,
	[" 卍"] = true,
	["卍 "] = true,
	["シ"] = true,
	["nigr"] = true,
	[" nigr"] = true,
	["nigr "] = true,
	["n1gr"] = true,
	[" n1gr"] = true,
	["n1gr "] = true,
	["negro"] = true,
	["n3gro"] = true,
	["negr0"] = true,
	["n3gr0"] = true,
	["jew"] = true,
	[" jew"] = true,
	["jew "] = true,
	["summit"] = true,
	["summ1t"] = true,
	["ICE"] = true,
	[" ICE"] = true,
	["ICE "] = true,
	["1CE"] = true,
	[" 1CE"] = true,
	["1CE "] = true,
	["IC3"] = true,
	[" IC3"] = true,
	["IC3 "] = true,
	["1C3"] = true,
	[" 1C3"] = true,
	["Paki"] = true,
	["paki"] = true,
	["1C3 "] = true,
	["100k"] = true,
	["1Bil"] = true,
	["1Mil"] = true,
	["250k"] = true,
	["2Mil"] = true,
	["420"] = true,
	["500K"] = true,
	["5Mil"] = true,
	["666"] = true,
	["Addicted"] = true,
	["BROKE"] = true,
	["Bronze"] = true,
	["Corona"] = true,
	["Diamond"] = true,
	["Emerald"] = true,
	["Gold"] = true,
	["Heroic"] = true,
	["Hoe"] = true,
	["ICE"] = true,
	["Master"] = true,
	["Noble"] = true,
	["Ruby"] = true,
	["Silver"] = true,
	["Sir"] = true,
	["TheBad"] = true,
  ["✪"] = true,
  [" ✪"] = true,
  ["✪ "] = true,
}

CONFIG.MaxChars = 5

-- Chat stuff
CONFIG.ChatColors = {
	Dead = Color(230, 58, 64),
	Advert = Color(201, 176, 15),
	PM = Color(0, 150, 150),
	OOC = Color(228, 104, 78),
}

CONFIG.ChatRanks = {
		["user"] = {
		name = "User",
		col = Color(191, 191, 191)
	},
		["mystic"] = {
		name = "Mystic",
		col = Color(185, 27, 255)
	},
		["hyper"] = {
		name = "Hyper",
		col = Color(255, 66, 66)
	},
		["juniormod"] = {
		name = "Junior Moderator",
		col = Color(143, 196, 248)
	},
		["junior_moderator"] = {
		name = "Junior Moderator",
		col = Color(66, 255, 160)
	},
		["moderator"] = {
		name = "Moderator",
		col = Color(66, 255, 160)
	},
		["senior_moderator"] = {
		name = "Senior Moderator",
		col = Color(66, 255, 160)
	},
		["junior_administrator"] = {
		name = "Junior Administrator",
		col = Color(66, 222, 255)
	},
		["administrator"] = {
		name = "Administrator",
		col = Color(66, 222, 255)
	},		
		["senior_administrator"] = {
		name = "Senior Administrator",
		col = Color(66, 222, 255)
	},
		["moderation_lead"] = {
		name = "Moderation Lead",
		col = Color(227, 66, 255)
	},
		["superadmin"] = {
		name = "Network Lead",
		col = Color(227, 66, 255)
	},
}

CONFIG.AutoChatInterval = 150 * 1 -- 2 min
CONFIG.AutoMessages = {
  { color_white, "Welcome to our community azureservers.co if you have any issues type ", Color(255, 163, 107), "!report." },
  { color_white, "Want to get involved? Join our discord here ", Color(213, 112, 255), "azureservers.co/discord." },
  { color_white, "Staff Applications are now open. To apply go to ", Color(105, 255, 88), "azureservers.co" },
  { color_white, "Read the rules and other important information by typing ", Color(255, 163, 107), "azureservers.co/community." },
 -- { color_white, "Make sure to enjoy our", Color(255, 88, 88)," Summer Sale!", color_white, " everything is currently ", Color(213, 112, 255), "50% Off ", color_white, "type ", Color(213, 112, 255), "!store." }
}

Hyrane.ChatTags.Config = CONFIG

--CONFIG.Tags = {
--	["test"] = {
	--	col = Color(142, 68, 173),
	--	price = 35000,
		-- Optional,
		--usergroups = {
		--	["vip++"] = true
		--}
	--},