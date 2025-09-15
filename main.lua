local UI = {}
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Colors = {
	TabIdle = Color3.fromRGB(25, 25, 25),
	TabActive = Color3.fromRGB(33, 33, 33),
	TabIndicator = Color3.fromRGB(56, 102, 255),
	Button = Color3.fromRGB(34, 34, 34),
	ButtonHover = Color3.fromRGB(40,40,40),
}

local function Tween(obj, props, duration)
	TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(topbar, mainWindow)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)

		TweenService:Create(
			mainWindow,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = newPos }
		):Play()
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainWindow.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

local function BuildBase()
	local Gui = {}

	Gui.ScreenGui = Instance.new("ScreenGui")
	Gui.ScreenGui.Name = "ScreenGui"
	Gui.ScreenGui.IgnoreGuiInset = true
	Gui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Gui.ScreenGui.Enabled = false
	Gui.ScreenGui.Parent = PlayerGui

	Gui.MainWindow = Instance.new("Frame")
	Gui.MainWindow.Name = "MainWindow"
	Gui.MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
	Gui.MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Gui.MainWindow.Size = UDim2.new(0, 600, 0, 600)
	Gui.MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Gui.MainWindow.BorderSizePixel = 0
	Gui.MainWindow.ClipsDescendants = true
	Gui.MainWindow.Parent = Gui.ScreenGui

	Instance.new("UICorner", Gui.MainWindow).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", Gui.MainWindow)
	stroke.Color = Color3.fromRGB(120, 120, 120)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	Gui.Topbar1 = Instance.new("Frame", Gui.MainWindow)
	Gui.Topbar1.Name = "Topbar1"
	Gui.Topbar1.Position = UDim2.new(0, 0, 0.0295, 0)
	Gui.Topbar1.Size = UDim2.new(0, 600, 0, 19)
	Gui.Topbar1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Gui.Topbar1.BorderSizePixel = 0

	Gui.Topbar2 = Instance.new("Frame", Gui.MainWindow)
	Gui.Topbar2.Name = "Topbar2"
	Gui.Topbar2.Size = UDim2.new(0, 600, 0, 19)
	Gui.Topbar2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Gui.Topbar2.BorderSizePixel = 0
	Instance.new("UICorner", Gui.Topbar2)

	Gui.Tabholders = Instance.new("ScrollingFrame", Gui.MainWindow)
	Gui.Tabholders.Name = "Tabholders"
	Gui.Tabholders.Position = UDim2.new(0.018, 0, 0.08, 0)
	Gui.Tabholders.Size = UDim2.new(0, 165, 0, 541)
	Gui.Tabholders.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Gui.Tabholders.BorderSizePixel = 0
	Instance.new("UICorner", Gui.Tabholders).CornerRadius = UDim.new(0, 10)

	Gui.Tabholders.CanvasSize = UDim2.new(0, 0, 0, 0) 
	Gui.Tabholders.ScrollBarThickness = 0
	Gui.Tabholders.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	Gui.Tabholders.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	Gui.Tabholders.AutomaticCanvasSize = Enum.AutomaticSize.Y 
	Gui.Tabholders.ClipsDescendants = true

	Gui.TabIndicator = Instance.new("Frame")
	Gui.TabIndicator.Name = "TabIndicator"
	Gui.TabIndicator.Size = UDim2.new(0, 4, 0, 36)
	Gui.TabIndicator.Position = UDim2.new(0, 0, 0, 0)
	Gui.TabIndicator.BackgroundColor3 = Colors.TabIndicator
	Gui.TabIndicator.BorderSizePixel = 0
	Gui.TabIndicator.Visible = false
	Gui.TabIndicator.Parent = Gui.Tabholders

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "TextLabel"
	TextLabel.Position = UDim2.new(0.0183333, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 135, 0, 36)
	TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.BorderColor3 = Color3.new(0, 0, 0)
	TextLabel.Text = "Mira"
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextSize = 16
	TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Gui.MainWindow
	TextLabel.ZIndex = 100

	local CloseButton = Instance.new("ImageButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Position = UDim2.new(0.942, 0, 0, 7)
	CloseButton.Size = UDim2.new(0, 23, 0, 23)
	CloseButton.BackgroundColor3 = Color3.new(1, 1, 1)
	CloseButton.BackgroundTransparency = 1
	CloseButton.BorderSizePixel = 0
	CloseButton.BorderColor3 = Color3.new(0, 0, 0)
	CloseButton.Image = "rbxassetid://110459327655965"
	CloseButton.Parent = Gui.MainWindow
	CloseButton.ZIndex = 100

	CloseButton.MouseButton1Click:Connect(function()
		Gui.ScreenGui:Destroy()
	end)

	MakeDraggable(Gui.Topbar1, Gui.MainWindow)
	MakeDraggable(Gui.Topbar2, Gui.MainWindow)

	return Gui
end

function UI:Init()
	self.Gui = BuildBase()

	local guiVisible = false

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.LeftControl then
			guiVisible = not guiVisible
			self.Gui.ScreenGui.Enabled = guiVisible
		end
	end)

	self.CurrentTab = nil
	self.TabCount = 0
	return self.Gui
end


function UI:CreateTab(name)
	self.TabCount += 1

	local tab = Instance.new("TextButton")
	tab.Name = name .. "_Tab"
	tab.Size = UDim2.new(0, 142, 0, 36)
	tab.Position = UDim2.new(0.5, -71, 0, 10 + (self.TabCount - 1) * (36 + 5))
	tab.BackgroundColor3 = Colors.TabIdle
	tab.BorderSizePixel = 0
	tab.Text = name
	tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.TextSize = 14
	tab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	tab.Parent = self.Gui.Tabholders
	tab.AutoButtonColor = false
	Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)

	local contentHolder = Instance.new("ScrollingFrame", self.Gui.MainWindow)
	contentHolder.Name = name .. "_ContentHolder"
	contentHolder.Position = UDim2.new(0.308333, 0, 0.08, 0)
	contentHolder.Size = UDim2.new(0, 405, 0, 541)
	contentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	contentHolder.BorderSizePixel = 0
	contentHolder.Visible = false
	contentHolder.ClipsDescendants = true

	contentHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentHolder.ScrollBarThickness = 0
	contentHolder.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

	Instance.new("UICorner", contentHolder).CornerRadius = UDim.new(0, 10)

	local ContentHolderUIStroke = Instance.new("UIStroke")
	ContentHolderUIStroke.Color = Color3.fromRGB(50, 50, 50)
	ContentHolderUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	ContentHolderUIStroke.Thickness = 1
	ContentHolderUIStroke.Parent = contentHolder

	local layout = Instance.new("UIListLayout")
	layout.Parent = contentHolder
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 5)

	local padding = Instance.new("UIPadding")
	padding.Parent = contentHolder
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)

	local function ActivateTab()
		for _, child in pairs(self.Gui.MainWindow:GetChildren()) do
			if child.Name:match("_ContentHolder$") then
				child.Visible = false
			end
		end
		for _, sibling in pairs(self.Gui.Tabholders:GetChildren()) do
			if sibling:IsA("TextButton") then
				Tween(sibling, {BackgroundColor3 = Colors.TabIdle}, 0.2)
			end
		end

		self.CurrentTab = contentHolder
		contentHolder.Visible = true
		Tween(tab, {BackgroundColor3 = Colors.TabActive}, 0.2)

		local indicator = self.Gui.TabIndicator
		indicator.Visible = true
		Tween(indicator, {
			Position = UDim2.new(0, 0, 0, tab.Position.Y.Offset),
			Size = UDim2.new(0, 4, 0, tab.Size.Y.Offset)
		}, 0.25)
	end

	tab.MouseButton1Click:Connect(ActivateTab)

	if self.TabCount == 1 then
		ActivateTab()
	end

	return contentHolder
end

function UI:CreateButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Colors.Button
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	btn.Parent = parent
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
	btn.MouseEnter:Connect(function()
		Tween(btn, {BackgroundColor3 = Colors.ButtonHover}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, {BackgroundColor3 = Colors.Button}, 0.15)
	end)

	return btn
end

function UI:CreateToggle(parent, text, callback)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, 0, 0, 40)
	toggle.BackgroundColor3 = Colors.Button
	toggle.BorderSizePixel = 0
	toggle.Text = ""
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.TextSize = 14
	toggle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	toggle.Parent = parent
	toggle.AutoButtonColor = false
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0) 
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggle

	local knobHolder = Instance.new("Frame")
	knobHolder.Size = UDim2.new(0, 44, 0, 22)
	knobHolder.Position = UDim2.new(1, -10, 0.5, 0)
	knobHolder.AnchorPoint = Vector2.new(1, 0.5)
	knobHolder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	knobHolder.BorderSizePixel = 0
	knobHolder.Parent = toggle
	Instance.new("UICorner", knobHolder).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke", knobHolder)
	stroke.Color = Color3.fromRGB(57, 57, 57)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(0.1, 0, 0.5, 0)
	knob.AnchorPoint = Vector2.new(0.1, 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
	knob.BorderSizePixel = 0
	knob.Parent = knobHolder
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = false
	local connection

	local function updateVisual()
		if state then
			knobHolder.BackgroundColor3 = Color3.fromRGB(56, 102, 255)
			stroke.Color = Color3.fromRGB(56, 102, 255) -- active color
			knob:TweenPosition(UDim2.new(0.6, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		else
			knobHolder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			stroke.Color = Color3.fromRGB(57, 57, 57) -- inactive color
			knob:TweenPosition(UDim2.new(0.1, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		end
	end


	toggle.MouseButton1Click:Connect(function()
		state = not state
		updateVisual()

		if state then
			connection = RunService.Heartbeat:Connect(function()
				if callback then callback(state) end
			end)
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end)

	toggle.MouseEnter:Connect(function()
		Tween(toggle, {BackgroundColor3 = Colors.ButtonHover}, 0.15)
	end)
	toggle.MouseLeave:Connect(function()
		Tween(toggle, {BackgroundColor3 = Colors.Button}, 0.15)
	end)

	return toggle
end


return UI
