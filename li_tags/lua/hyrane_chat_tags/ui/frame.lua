local PANEL = {}

Hyrane.ChatTags:CreateFont("XeninUI.TextEntry.Small", 14)
Hyrane.ChatTags:CreateFont("XeninUI.TextEntry.Big", 32)

function PANEL:Init()
	self.Slider = self:Add("XeninUI.Slider")
	self.Slider.OnValueChanged = function(pnl, frac)
		self.TextEntry:SetText(math.Round(frac * 255))
		self:OnValueChanged()
	end

	self.TextEntry = self:Add("XeninUI.TextEntry")
	self.TextEntry:SetText("255")
	self.TextEntry:SetFont("XeninUI.TextEntry.Small")
	self.TextEntry.textentry:DockMargin(2, 2, 2, 2)
	self.TextEntry:SetBackgroundColor(Color(51, 51, 51))
	self.TextEntry.textentry:SetUpdateOnType(true)
	self.TextEntry.textentry:SetNumeric(true)
	self.TextEntry.textentry.OnValueChange = function(pnl, text)
		text = tonumber(text)
		if (!text or !isnumber(text)) then return end
		text = math.min(255, text)

		pnl:SetText(text)
		pnl:SetCaretPos(#tostring(text))

		self.Slider.fraction = text / 255
		self.Slider:InvalidateLayout()

		self:OnValueChanged()
	end
end

function PANEL:OnValueChanged() end

function PANEL:GetValueChanged()
	return tonumber(self.TextEntry:GetText())
end

function PANEL:PerformLayout(w, h)
	self.Slider:SetSize(w * 0.8 - 8, h)
	self.TextEntry:SetPos(self.Slider:GetWide() + 12, 0)
	self.TextEntry:SetSize(w * 0.2 - 4, h)
end

vgui.Register("Hyrane.ChatTags.Color", PANEL)

local PANEL = {}

Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.Title", 20)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TitleVIP", 24)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TitleExclusive", 28)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.Name", 22)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.Price", 16)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.Button", 18)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.Equipped", 52)

Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.SectionTitle", 26)

PANEL.Colors = {
	[1] = Color(192, 57, 43),
	[2] = Color(52, 152, 219),
	[3] = Color(46, 204, 113)
}

function PANEL:Close()
	self:Network()

	self:AlphaTo(0, 0.2, 0, function()
		self:Remove()
	end)

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:Network()
	local str = self.VIP.TextEntry:GetText()
	if (str == "") then net.Start("Hyrane.ChatTags.Unequip.Custom") net.SendToServer() return end
	if (self.class:GetEquipped()) then return end
	local col = self.Color

	net.Start("Hyrane.ChatTags.Equip.Custom")
		net.WriteString(str)
		net.WriteColor(col)
	net.SendToServer()
end

function PANEL:Init()
	Hyrane.ChatTags.UI = self

	self.closeBtn.DoClick = function(pnl)
		surface.PlaySound("hyrane/button_click.wav")

		self:Close()
	end

	self.class = LocalPlayer():ChatTags()

	self.Top = self:Add("Panel")
	self.Top:Dock(TOP)
	self.Top:DockMargin(8, 8, 8, 8)

	self.Equipped = self.Top:Add("Panel")
	self.Equipped:Dock(LEFT)
	self.Equipped.Text = "None"
	self.Equipped.Paint = function(pnl, w, h)
		draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)
		draw.SimpleText("Equipped tag", "Hyrane.ChatTags.Title", 8, 8, Color(212, 212, 212), TEXT_ALIGN_LEFT)

		local equipped = self.class:GetEquipped()
		equipped = self.class:GetCustomTag() or equipped and Hyrane.ChatTags.Config.Tags[equipped]
		local text = self.class:GetCustomTag() or self.class:GetEquipped()
		if (equipped and text != "" and #text > 0) then
			local col = self.class:GetColor() or equipped.col

			draw.SimpleText(text, "Hyrane.ChatTags.Equipped", 8, h - 4, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			pnl.Text = text
		else
			draw.SimpleText("None", "Hyrane.ChatTags.Equipped", 8, h - 4, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			pnl.Text = "None"
		end
	end

	self.VIP = self.Top:Add("DPanel")
	self.VIP:Dock(FILL)
	self.VIP:DockMargin(8, 0, 0, 0)
	self.VIP.Paint = function(pnl, w, h)
		draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)
		draw.SimpleText("Custom tag", "Hyrane.ChatTags.Title", 8, 8, Color(212, 212, 212), TEXT_ALIGN_LEFT)
	end

	self:ColorChanged(self.class:GetColor() or 
		self.class:GetEquipped() and Hyrane.ChatTags.Config.Tags[self.class:GetEquipped()].col or 
		color_white)

	self.VIP.TextEntry = self.VIP:Add("Hyrane.ChatTags.TextEntry")
	self.VIP.TextEntry:SetPlaceholder("Tag")
	self.VIP.TextEntry:SetText(self.class:GetCustomTag() or "")
	self.VIP.TextEntry:SetTextColor(self.Color)
	self.VIP.TextEntry.textentry:SetUpdateOnType(true)
	self.VIP.TextEntry.textentry.OnValueChange = function(pnl, text)
		if (Hyrane.ChatTags.Config.BlacklistedWords[text:lower()]) then
			pnl:SetText("")

			chat.AddText(color_white, "[",
				XeninUI.Theme.Primary, "CHAT TAGS",
				color_white, "] That word have been blacklisted!"
			)

			hook.Run("Hyrane.ChatTags.TagChanged", "")
			self.class:SetCustomTag(nil)
			
			return
		end

		self.class:SetCustomTag(text)
		self.class:SetEquipped(nil)
		local col = {}
		for i, v in pairs(self.VIP.Mixer:GetChildren()) do
			col[i] = v:GetValueChanged()
		end
		self:ColorChanged(Color(unpack(col)))
		hook.Run("Hyrane.ChatTags.TagChanged", "")

		XeninUI:Debounce("ChatTags", 0.5, function()
			if (!IsValid(self)) then return end

			self:Network()
		end)
	end
	self.VIP.TextEntry.textentry.AllowInput = function(pnl, char)
		return #pnl:GetText() >= Hyrane.ChatTags.Config.MaxChars
	end
	self.VIP.TextEntry.textentry.OnFocusChanged = function(pnl, gained)
		if (gained and pnl:GetText() != "" and #pnl:GetText() > 0) then
			pnl:OnValueChange(pnl:GetText())
		end
	end

	self.VIP.Mixer = self.VIP:Add("Panel")
	self.VIP.Mixer:Dock(RIGHT)
	self.VIP.Mixer:DockMargin(0, 8, 8, 8)
	self.VIP.Mixer.Alpha = 0
	for i = 1, 3 do	
		local color = self.VIP.Mixer:Add("Hyrane.ChatTags.Color")
		color.Slider:SetColor(self.Colors[i])
		color.Slider.fraction = i == 1 and self.Color.r or i == 2 and self.Color.g or i == 3 and self.Color.b
		color.Slider.fraction = color.Slider.fraction / 255
		color.TextEntry:SetText(color.Slider.fraction * 255)
		color.OnValueChanged = function(pnl)
			local col = {}
			for i, v in pairs(self.VIP.Mixer:GetChildren()) do
				col[i] = v:GetValueChanged()
			end

			col = Color(unpack(col))

			self:ColorChanged(col)

			XeninUI:Debounce("ChatTags", 0.5, function()
				if (!IsValid(self)) then return end
				
				self:Network()
			end)
		end
	end

	if !self.class:GetOwnsCustomTag() then
		self.VIP.Overlay = self.VIP:Add("Panel")
		self.VIP.Overlay.Paint = function(pnl, w, h)
			XeninUI:DrawBlur(pnl, 4)
		end

		self.VIP.Overlay.Button = self.VIP.Overlay:Add("DButton")
		self.VIP.Overlay.Button:SetText("PURCHASE - " .. DarkRP.formatMoney(Hyrane.ChatTags.Config.CustomTagPrice))
		self.VIP.Overlay.Button:SetFont("Hyrane.ChatTags.TitleExclusive")
		self.VIP.Overlay.Button.TextColor = color_white
		self.VIP.Overlay.Button.BackgroundColor = XeninUI.Theme.Primary
		self.VIP.Overlay.Button.Paint = function(pnl, w, h)
			pnl:SetTextColor(pnl.TextColor)

			XeninUI:DrawRoundedBox(6, 0, 0, w, h, pnl.BackgroundColor)
		end
		self.VIP.Overlay.Button.DoClick = function(pnl)
			surface.PlaySound("hyrane/button_click.wav")

			local price = Hyrane.ChatTags.Config.CustomTagPrice
			if (!LocalPlayer():canAfford(price)) then
				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] You can't afford that! You need ", XeninUI.Theme.Green, DarkRP.formatMoney(price))

				return
			end

			self.class:SetOwnsCustomTag(true)

			net.Start("Hyrane.ChatTags.PurchaseCustomTag")
			net.SendToServer()
			
			self.VIP.Overlay:SetAlpha(255)
			self.VIP.Overlay:AlphaTo(0, 0.5, nil, function()
				self.VIP.Overlay:Remove()
			end)
		end

		self.VIP.Overlay.PerformLayout = function(pnl, w, h)
			pnl.Button:SizeToContentsX(8)
			pnl.Button:SizeToContentsY(4)
			pnl.Button:SetPos(0, 37)

			pnl.Button:CenterHorizontal()
		end
	end

	self.Main = self:Add("Panel")
	self.Main:Dock(FILL)
	self.Main:DockMargin(8, 0, 8, 8)

	self.Main.Shop = self.Main:Add("Panel")
	self.Main.Shop.Tabs = {}
	self.Main.Shop.rawSelected = 0
	self.Main.Shop.Select = function(pnl, id)
		local btn = pnl.Tabs[pnl.rawSelected]
		if (IsValid(btn)) then
			btn:LerpColor("TextColor", Color(180, 180, 180))
		end

		if (!pnl.selected) then
			pnl.selected = id

			pnl:InvalidateLayout()
		else
			pnl:Lerp("selected", id, 0.4)
		end

		pnl.rawSelected = id
		btn = pnl.Tabs[id]
		if (IsValid(btn)) then
			btn:LerpColor("TextColor", color_white)
		end
	end
	self.Main.Shop.AddTab = function(pnl, name, tab)
		local button = pnl:Add("DButton")
		button:SetText("")
		button.Name = name
		button.Font = "Hyrane.ChatTags.SectionTitle"
		button.TextColor = #pnl.Tabs == 0 and color_white or Color(180, 180, 180)
		button.BackgroundColor = XeninUI.Theme.Background
		button.Paint = function(pnl, w, h)
			draw.RoundedBox(6, 0, 0, w, h, pnl.BackgroundColor)

			draw.SimpleText(pnl.Name, pnl.Font, w / 2, h / 2, pnl.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		button.OnCursorEntered = function(pnl)
			pnl:LerpColor("BackgroundColor", XeninUI.Theme.Navbar)
		end
		button.OnCursorExited = function(pnl)
			pnl:LerpColor("BackgroundColor", XeninUI.Theme.Background)
		end
		button.DoClick = function(pnl)
			surface.PlaySound("hyrane/button_click.wav")

			self.Main.Shop:Select(pnl.id)
		end
		XeninUI:AddRippleClickEffect(button, ColorAlpha(XeninUI.Theme.Primary, 125), 0.4, 18)

		local id = table.insert(pnl.Tabs, button)
		pnl.Tabs[id].id = id

		local panel = pnl:Add(tab or "Panel")
		button.panel = panel
	end
	self.Main.Shop:Select(1)
	self.Main.Shop.PerformLayout = function(pnl, w, h)
		local x = 0
		for i, v in pairs(pnl.Tabs) do
			surface.SetFont(v.Font)
			local tw, th = surface.GetTextSize(v.Name)

			v:SetPos(x, 0)
			v:SetSize(tw + 16, th + 8)

			x = x + v:GetWide() + 4

			-- Handle positioning of the tabs
			local _x = (i - pnl.selected) * w
			v.panel:SetSize(w, h - v:GetTall() - 8)
			v.panel:SetPos(_x, v:GetTall() + 8)
		end
	end

	self.Main.Shop:AddTab("UNOWNED TAGS", "Hyrane.ChatTags.Tab")
	self.Main.Shop:AddTab("OWNED TAGS", "Hyrane.ChatTags.Tab.Owned")
end

function PANEL:Think()
	local pnl = self.Main.Shop
	if (pnl.rawSelected != pnl.selected) then
		pnl:InvalidateLayout()
	end

	if (!IsValid(self.VIP.TextEntry)) then return end

	self.VIP.Mixer:SetAlpha(self.VIP.Mixer.Alpha)

	local textLen = #self.VIP.TextEntry:GetText()
	local isVisible = self.VIP.Mixer.Alpha > 0.02
	if (!isVisible and textLen > 0 and !self.fading) then
		self.fading = true

		self.VIP.Mixer:Lerp("Alpha", 255, 0.15, function()
			self.fading = nil
		end)
	elseif (isVisible and textLen <= 0 and !self.fading) then
		self.fading = true

		self.VIP.Mixer:Lerp("Alpha", 0, 0.15, function()
			self.fading = nil
		end)
	end 
end

function PANEL:ColorChanged(col)
	self.class:SetColor(col)
	self.Color = col

	if (IsValid(self.VIP.TextEntry)) then
		self.class:SetCustomTag(self.VIP.TextEntry:GetText())

		self.VIP.TextEntry:SetTextColor(col)
	end
end

function PANEL:PerformLayout(w, h)
	self.BaseClass.PerformLayout(self, w, h)

	self.Top:SetTall(84)

	surface.SetFont("Hyrane.ChatTags.Equipped")
	local tw = surface.GetTextSize(self.Equipped.Text)
	self.Equipped:SetWide(math.max(200, tw + 16))

	self.VIP.TextEntry:SetPos(8, 34)
	self.VIP.TextEntry:SetSize(125, self.VIP:GetTall() - self.VIP.TextEntry.y - 8)

	self.VIP.Mixer:SetWide(180)

	local _h = self.VIP.Mixer:GetTall() - 8
	_h = _h / #self.VIP.Mixer:GetChildren()
	
	local y = 0
	for i, v in pairs(self.VIP.Mixer:GetChildren()) do
		v:SetSize(self.VIP.Mixer:GetWide(), _h)
		v:SetPos(0, y)

		y = y + v:GetTall() + 4
	end

	if (IsValid(self.VIP.Overlay)) then
		self.VIP.Overlay:SetSize(self.VIP:GetSize())
	end

	self.Main.Shop:SetSize(self.Main:GetSize())
end

vgui.Register("Hyrane.ChatTags.Frame", PANEL, "XeninUI.Frame")

Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TabMessage", 40)

local PANEL = {}

function PANEL:Init()
	self.Scroll = self:Add("XeninUI.Scrollpanel.Wyvern")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(0, 0, 0, 0)
	self.Scroll.VBar:SetVisibleFullHeight(false)

	self:Populate()
end

function PANEL:Paint(w, h)
	if (#self.Layout:GetChildren() == 0) then
		draw.SimpleText("You own all chat tags", "Hyrane.ChatTags.TabMessage", w / 2, 24, Color(235, 235, 235), TEXT_ALIGN_CENTER)
	end
end

function PANEL:Populate()
	if (IsValid(self.Layout)) then
		self.Layout:Remove()
	end
	
	self.Layout = self.Scroll:Add("DIconLayout")
	self.Layout:SetSpaceX(8)
	self.Layout:SetSpaceY(5)
  self.Layout.PerformLayout = function(pnl, w, h)
    local children = pnl:GetChildren()
    local count = 4
    local width = w / math.min(count, #children)

    local x = 0
    local y = 0

    local spacingX = pnl:GetSpaceX()
    local spacingY = pnl:GetSpaceY()
    local border = pnl:GetBorder()
    local innerWidth = w - border * 2 - spacingX * (count - 1)

    for i, child in ipairs(children) do
      if (!IsValid(child)) then continue end
    
      child:SetPos(border + x * innerWidth / count + spacingX * x, border + y * child:GetTall() + spacingY * y)
      child:SetSize(innerWidth / count, 48)

      x = x + 1
      if (x >= count) then
        x = 0
        y = y + 1
      end
    end
  end


	local class = LocalPlayer():ChatTags()
	for i, v in SortedPairs(Hyrane.ChatTags.Config.Tags) do
		if (class:GetTag(i)) then continue end

		local panel = self.Layout:Add("DPanel")
		panel.Paint = function(pnl, w, h)
			draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)

			draw.SimpleText(i, "Hyrane.ChatTags.Name", 10, h / 2 + 4, v.col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(DarkRP.formatMoney(v.price), "Hyrane.ChatTags.Price", 10, h / 2 + 2, Color(180, 180, 180), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		
		panel.Buy = panel:Add("DButton")
		panel.Buy:SetText("BUY")
		panel.Buy:SetFont("Hyrane.ChatTags.Button")
		panel.Buy.TextColor = Color(180, 180, 180)
		panel.Buy.BackgroundColor = Color(51, 51, 51)
		panel.Buy.Paint = function(pnl, w, h)
			pnl:SetTextColor(pnl.TextColor)

			draw.RoundedBox(6, 0, 0, w, h, pnl.BackgroundColor)
		end
		panel.Buy.OnCursorEntered = function(pnl)
			pnl:LerpColor("BackgroundColor", Color(65, 65, 65))
		end
		panel.Buy.OnCursorExited = function(pnl)
			pnl:LerpColor("BackgroundColor", Color(51, 51, 51))
		end
		panel.Buy.DoClick = function(pnl)
			surface.PlaySound("hyrane/button_click.wav")

			local price = v.price
			local ply = LocalPlayer()
			local canAfford = ply:canAfford(price)

			if (!canAfford) then
				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] You can't afford that! You need ", XeninUI.Theme.Green, DarkRP.formatMoney(v.price))

				return
			end

			local customCheck = v.customCheck or function() return true end
			local check, failMsg = customCheck(ply)
			if (!check) then 
				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] " .. failMsg)
				
				return
			end
			if (v.usergroups and !v.usergroups[ply:GetUserGroup()]) then
				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] You don't meet the rank requirement!")

				return
			end

			net.Start("Hyrane.ChatTags.Purchase")
				net.WriteString(i)
			net.SendToServer()

			class:AddTag(i)

			hook.Run("Hyrane.ChatTags.Purchased")

			--self:Populate()
			chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] Purchased ", v.col, i)

			panel:Remove()

			self:InvalidateLayout()
		end
		XeninUI:AddRippleClickEffect(panel.Buy, ColorAlpha(XeninUI.Theme.Primary, 150), 0.3)

		panel.PerformLayout = function(pnl, w, h)
			pnl.Buy:SizeToContentsX(24)
			pnl.Buy:SizeToContentsY(16)

			pnl.Buy:AlignRight(6)
			pnl.Buy:CenterVertical()
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.Layout:SetSize(self.Scroll:GetWide() - 20, self.Scroll:GetTall())
end

vgui.Register("Hyrane.ChatTags.Tab", PANEL)

local PANEL = {}

function PANEL:Init()
	self.Scroll = self:Add("XeninUI.Scrollpanel.Wyvern")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(0, 0, 0, 0)
	self.Scroll.VBar:SetVisibleFullHeight(false)

	hook.Add("Hyrane.ChatTags.Purchased", self, function(self)
		self:Populate()
	end)

	self:Populate()
end

function PANEL:Paint(w, h)
	if (#self.Layout:GetChildren() == 0) then
		draw.SimpleText("You own no chat tags", "Hyrane.ChatTags.TabMessage", w / 2, 24, Color(235, 235, 235), TEXT_ALIGN_CENTER)
	end
end

function PANEL:Populate()
	if (IsValid(self.Layout)) then
		self.Layout:Remove()
	end
	
	self.Layout = self.Scroll:Add("DIconLayout")
	self.Layout:SetSpaceX(8)
	self.Layout:SetSpaceY(5)
  self.Layout.PerformLayout = function(pnl, w, h)
    local children = pnl:GetChildren()
    local count = 4
    local width = w / math.min(count, #children)

    local x = 0
    local y = 0

    local spacingX = pnl:GetSpaceX()
    local spacingY = pnl:GetSpaceY()
    local border = pnl:GetBorder()
    local innerWidth = w - border * 2 - spacingX * (count - 1)

    for i, child in ipairs(children) do
      if (!IsValid(child)) then continue end
    
      child:SetPos(border + x * innerWidth / count + spacingX * x, border + y * child:GetTall() + spacingY * y)
      child:SetSize(innerWidth / count, 48)

      x = x + 1
      if (x >= count) then
        x = 0
        y = y + 1
      end
    end
  end

	local class = LocalPlayer():ChatTags()
	for i, v in SortedPairs(Hyrane.ChatTags.Config.Tags) do
		if (!class:GetTag(i)) then continue end

		local panel = self.Layout:Add("DPanel")
		panel.Paint = function(pnl, w, h)
			draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)

			draw.SimpleText(i, "Hyrane.ChatTags.Name", 10, h / 2 + 4, v.col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(DarkRP.formatMoney(v.price), "Hyrane.ChatTags.Price", 10, h / 2 + 2, Color(180, 180, 180), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		
		panel.Buy = panel:Add("DButton")
		panel.Buy:SetText(i == class:GetEquipped() and "UNEQUIP" or "EQUIP")
		panel.Buy:SetFont("Hyrane.ChatTags.Button")
		panel.Buy.TextColor = i == class:GetEquipped() and XeninUI.Theme.Green or Color(180, 180, 180)
		panel.Buy.BackgroundColor = Color(51, 51, 51)
		panel.Buy.Paint = function(pnl, w, h)
			pnl:SetTextColor(pnl.TextColor)

			draw.RoundedBox(6, 0, 0, w, h, pnl.BackgroundColor)
		end
		panel.Buy.OnCursorEntered = function(pnl)
			pnl:LerpColor("BackgroundColor", Color(65, 65, 65))
		end
		panel.Buy.OnCursorExited = function(pnl)
			pnl:LerpColor("BackgroundColor", Color(51, 51, 51))
		end
		panel.Buy.DoClick = function(pnl)
			surface.PlaySound("hyrane/button_click.wav")

			if (pnl:GetText() == "UNEQUIP") then
				class:SetEquipped(nil)
				class:SetColor(nil)
				class:SetCustomTag(nil)

				net.Start("Hyrane.ChatTags.Unequip")
				net.SendToServer()

				hook.Run("Hyrane.ChatTags.TagChanged")

				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] Unequipped ", v.col, i)
			else
				class:SetCustomTag(nil)
				class:SetColor(nil)
				class:SetEquipped(i)

				net.Start("Hyrane.ChatTags.Equip")
					net.WriteString(i)
				net.SendToServer()

				hook.Run("Hyrane.ChatTags.TagChanged", i)

				chat.AddText(color_white, "[", XeninUI.Theme.Primary, "CHAT TAGS", color_white, "] Equipped ", v.col, i)
			end
		end
		XeninUI:AddRippleClickEffect(panel.Buy, ColorAlpha(XeninUI.Theme.Primary, 150), 0.3)

		hook.Add("Hyrane.ChatTags.TagChanged", panel.Buy, function(pnl, id)
			if (i != id and pnl:GetText() == "UNEQUIP") then
				pnl:SetText("EQUIP")
				pnl:LerpColor("TextColor", Color(180, 180, 180))
				panel:InvalidateLayout()
			elseif (i == id) then
				pnl:SetText("UNEQUIP")
				pnl:LerpColor("TextColor", XeninUI.Theme.Green)
				panel:InvalidateLayout()
			end

			timer.Simple(0, function()
				Hyrane.ChatTags.UI:InvalidateLayout()
			end)
		end)

		panel.PerformLayout = function(pnl, w, h)
			pnl.Buy:SizeToContentsX(24)
			pnl.Buy:SizeToContentsY(16)

			pnl.Buy:AlignRight(6)
			pnl.Buy:CenterVertical()
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.Layout:SetSize(self.Scroll:GetWide() - 20, self.Scroll:GetTall())
end

vgui.Register("Hyrane.ChatTags.Tab.Owned", PANEL)

function Hyrane.ChatTags:OpenMenu()
	local w = math.min(ScrW(), 960)
	local h = math.min(ScrH(), 720)

	local frame = vgui.Create("Hyrane.ChatTags.Frame")
	frame:SetSize(0, 0)
	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.2)
	frame:LerpMove(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2, 0.2)
	frame:LerpSize(w, h, 0.2)
	frame:MakePopup()
	frame:SetTitle("Chat Tags")
end

concommand.Add("hyranechattags", Hyrane.ChatTags.OpenMenu)

Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TextEntry", 18)
Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TextEntryName", 15)

for i = 12, 20 do
  Hyrane.ChatTags:CreateFont("Hyrane.ChatTags.TextEntrySize" .. i, i)
end

local PANEL = {}

AccessorFunc(PANEL, "m_backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "m_rounded", "Rounded")
AccessorFunc(PANEL, "m_placeholder", "Placeholder")
AccessorFunc(PANEL, "m_textColor", "TextColor")
AccessorFunc(PANEL, "m_placeholderColor", "PlaceholderColor")
AccessorFunc(PANEL, "m_iconColor", "IconColor")

function PANEL:Init()
	self:SetBackgroundColor(XeninUI.Theme.Navbar)
	self:SetRounded(6)
	self:SetPlaceholder("")
	self:SetTextColor(Color(205, 205, 205))
	self:SetPlaceholderColor(Color(120, 120, 120))
	self:SetIconColor(self:GetTextColor())

	self.textentry = vgui.Create("DTextEntry", self)
	self.textentry:Dock(FILL)
	self.textentry:SetFont("XeninUI.TextEntry.Big")
	self.textentry:SetDrawLanguageID(false)
	self.textentry.Paint = function(pnl, w, h)
		local col = self:GetTextColor()
		
		pnl:DrawTextEntryText(col, XeninUI.Theme.Primary, color_white)

		if ((pnl:GetText() == "" or #pnl:GetText() == 0)and !pnl:HasFocus()) then
			draw.SimpleText(self:GetPlaceholder() or "", pnl:GetFont(), 0, pnl:IsMultiline() and 8 or h / 2, self:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:SetFont(str)
	self.textentry:SetFont(str)
end

function PANEL:GetText()
	return self.textentry:GetText()
end

function PANEL:SetText(str)
	self.textentry:SetText(str)
end

function PANEL:SetMultiLine(state)
	self:SetMultiline(state)
	self.textentry:SetMultiline(state)
end

function PANEL:SetIcon(icon)
	if (!IsValid(self.icon)) then
		self.icon = vgui.Create("DPanel", self)
		self.icon:Dock(RIGHT)
		self.icon:DockMargin(10, 10, 10, 10)
		self.icon.Paint = function(pnl, w, h)
			surface.SetDrawColor(self:GetIconColor())
			surface.SetMaterial(pnl.mat)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end

	self.icon.mat = icon
end

function PANEL:PerformLayout(w, h)
	if (IsValid(self.icon)) then
		self.icon:SetWide(self.icon:GetTall())
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self:GetTextColor())
	surface.DrawRect(0, h - 2, w, 2)
end

vgui.Register("Hyrane.ChatTags.TextEntry", PANEL)