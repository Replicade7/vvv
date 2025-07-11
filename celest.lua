local Leaf = {}

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ConfigManager = {
	Window = nil,
	Folder = nil,
	Path = nil,
	Configs = {},
	Parser = {
		Colorpicker = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value:ToHex(),
				}
			end,
			Load = function(element, data)
				if element and element.Set then
					element:Set(Color3.fromHex(data.value))
				end
			end
		},
		Dropdown = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value,
				}
			end,
			Load = function(element, data)
				if element and element.Select then
					element:Select(data.value)
				end
			end
		},
		Input = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value,
				}
			end,
			Load = function(element, data)
				if element and element.Set then
					element:Set(data.value)
				end
			end
		},
		Keybind = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value.Name,
				}
			end,
			Load = function(element, data)
				if element and element.Set then
					element:Set(data.value)
				end
			end
		},
		Slider = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value.Default,
				}
			end,
			Load = function(element, data)
				if element and element.Set then
					element:Set(data.value)
				end
			end
		},
		Toggle = {
			Save = function(obj)
				return {
					__type = obj.__type,
					value = obj.Value,
				}
			end,
			Load = function(element, data)
				if element and element.Set then
					element:Set(data.value)
				end
			end
		},
	}
}

function ConfigManager:Init(Window)
	if not Window.Folder then
		warn("[Leaf] Window.Folder is not specified for ConfigSystem.")
		return false
	end
	ConfigManager.Window = Window
	ConfigManager.Folder = Window.Folder
	ConfigManager.Path = "Leaf/" .. tostring(ConfigManager.Folder) .. "/"
	if not isfolder("Leaf") then makefolder("Leaf") end
	if not isfolder("Leaf/" .. tostring(ConfigManager.Folder)) then makefolder("Leaf/" .. tostring(ConfigManager.Folder)) end
	return ConfigManager
end

function ConfigManager:CreateConfig(configFilename)
	local ConfigModule = {
		Path = ConfigManager.Path .. configFilename .. ".json",
		Elements = {}
	}
	if not configFilename then return false, "No config file is selected" end
	function ConfigModule:Register(Name, Element)
		ConfigModule.Elements[Name] = Element
	end
	function ConfigModule:Save()
		local saveData = { Elements = {} }
		for name, i in next, ConfigModule.Elements do
			if ConfigManager.Parser[i.__type] then
				saveData.Elements[tostring(name)] = ConfigManager.Parser[i.__type].Save(i)
			end
		end
		writefile(ConfigModule.Path, HttpService:JSONEncode(saveData))
	end
	function ConfigModule:Load()
		if not isfile(ConfigModule.Path) then return false, "Invalid file" end
		local loadData = HttpService:JSONDecode(readfile(ConfigModule.Path))
		for name, data in next, loadData.Elements do
			if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
				task.spawn(function()
					ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
				end)
			end
		end
	end
	ConfigManager.Configs[configFilename] = ConfigModule
	return ConfigModule
end

function ConfigManager:AllConfigs()
	if listfiles then
		local files = {}
		for _, file in next, listfiles(ConfigManager.Path) do
			local name = file:match("([^/\\]+)%.json$")
			if name then table.insert(files, name) end
		end
		return files
	end
	return {}
end

function Leaf:CreateWindow(config)
	local window = {
		Folder = config.Name,
		RegisteredElements = {},
        AllElements = {}
	}
	Leaf.MenuColorValue = Instance.new("Color3Value")
	Leaf.MenuColorValue.Value = Color3.fromRGB(config.Color[1], config.Color[2], config.Color[3])
	Leaf.colorElements = {}
	Leaf.toggles = {}
	Leaf.Config = nil
    Leaf.ThemeManager = {
        Themes = {
            Default = {
                Main = Color3.fromRGB(30, 30, 30),
                Accent = config.Color,
                Secondary = Color3.fromRGB(50, 50, 50),
                Text = Color3.fromRGB(255, 255, 255)
            }
        },
        CurrentTheme = "Default"
    }

	Leaf.MenuColorValue.Changed:Connect(function()
		for _, item in ipairs(Leaf.colorElements) do
			if item.element and item.element.Parent then
				item.element[item.property] = Leaf.MenuColorValue.Value
			end
		end
		for _, toggleData in ipairs(Leaf.toggles) do
			if toggleData.state and toggleData.indicator and toggleData.indicator.Parent then
				toggleData.indicator.BackgroundColor3 = Leaf.MenuColorValue.Value
			end
		end
		if window.activeTab and window.activeTab.TabButton and window.activeTab.TabButton.Parent then
			window.activeTab.TabButton.ImageColor3 = Leaf.MenuColorValue.Value
		end
	end)

	local MiniMenu = Instance.new("ScreenGui")
	local MiniMenuFrame = Instance.new("Frame")
	local UICornerMini = Instance.new("UICorner")
	local ImageMiniMenu = Instance.new("ImageLabel")
	local Bmenu = Instance.new("TextButton")
	
	MiniMenu.Name = "MiniMenu"
	MiniMenu.Parent = game:GetService("CoreGui")
	MiniMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	MiniMenuFrame.Name = "MiniMenu"
	MiniMenuFrame.Parent = MiniMenu
	MiniMenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MiniMenuFrame.BorderSizePixel = 0
	MiniMenuFrame.Position = UDim2.new(0.442, 0, 0.065, 0)
	MiniMenuFrame.Size = UDim2.new(0, 50, 0, 50)
	
	UICornerMini.CornerRadius = UDim.new(0, 4)
	UICornerMini.Parent = MiniMenuFrame
	
	ImageMiniMenu.Name = "ImageMiniMenu"
	ImageMiniMenu.Parent = MiniMenuFrame
	ImageMiniMenu.BackgroundTransparency = 1
	ImageMiniMenu.Position = UDim2.new(0.14, 0, 0.14, 0)
	ImageMiniMenu.Size = UDim2.new(0, 35, 0, 35)
	ImageMiniMenu.Image = "rbxassetid://"..config.LogoID
	ImageMiniMenu.ImageColor3 = Leaf.MenuColorValue.Value
	table.insert(Leaf.colorElements, {element = ImageMiniMenu, property = "ImageColor3"})
	
	Bmenu.Name = "Bmenu"
	Bmenu.Parent = MiniMenuFrame
	Bmenu.BackgroundTransparency = 1
	Bmenu.Size = UDim2.new(0, 50, 0, 50)
	Bmenu.Font = Enum.Font.SourceSans
	Bmenu.Text = ""
	Bmenu.TextTransparency = 1

	local ScreenGui = Instance.new("ScreenGui")
	local OuterFrame = Instance.new("Frame")
	local UIStroke1 = Instance.new("UIStroke")
	local InnerFrame = Instance.new("Frame")
	local UIStroke2 = Instance.new("UIStroke")
	local Mainframe = Instance.new("Frame")
	local UICornerMain = Instance.new("UICorner")
	local UIStroke3 = Instance.new("UIStroke")
	local TopBar = Instance.new("Frame")
	local UIStroke4 = Instance.new("UIStroke")
	local TextLabel = Instance.new("TextLabel")
	local Line = Instance.new("Frame")
	
	ScreenGui.Name = "MainMenu"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Enabled = false
	
	OuterFrame.Name = "OuterFrame"
	OuterFrame.Parent = ScreenGui
	OuterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	OuterFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	OuterFrame.BorderSizePixel = 0
	OuterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	OuterFrame.Size = UDim2.new(0, 336, 0, 273)
	
	UIStroke1.Parent = OuterFrame
	UIStroke1.Color = Color3.fromRGB(80, 80, 80)
	UIStroke1.Thickness = 2
	
	InnerFrame.Name = "InnerFrame"
	InnerFrame.Parent = OuterFrame
	InnerFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	InnerFrame.BorderSizePixel = 0
	InnerFrame.Position = UDim2.new(0.024, 0, 0.0315, 0)
	InnerFrame.Size = UDim2.new(0, 320, 0, 255)
	
	UIStroke2.Parent = InnerFrame
	UIStroke2.Color = Color3.fromRGB(80, 80, 80)
	UIStroke2.Thickness = 2
	
	Mainframe.Name = "MainFrame"
	Mainframe.Parent = InnerFrame
	Mainframe.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Mainframe.BorderSizePixel = 0
	Mainframe.Position = UDim2.new(0.015, 0, 0.191, 0)
	Mainframe.Size = UDim2.new(0, 310, 0, 200)
	
	UIStroke3.Parent = Mainframe
	UIStroke3.Color = Color3.fromRGB(80, 80, 80)
	UIStroke3.Thickness = 2
	
	TopBar.Name = "TopBar"
	TopBar.Parent = Mainframe
	TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TopBar.Position = UDim2.new(0, 0, -0.19, 0)
	TopBar.Size = UDim2.new(0, 310, 0, 30)
	
	UIStroke4.Parent = TopBar
	UIStroke4.Color = Color3.fromRGB(80, 80, 80)
	UIStroke4.Thickness = 2
	
	TextLabel.Parent = TopBar
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0.05, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 200, 0, 30)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = config.Name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 15
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	Line.Name = "Line"
	Line.Parent = TopBar
	Line.BackgroundColor3 = Leaf.MenuColorValue.Value
	Line.Position = UDim2.new(0, 0, -0.238999993, 0)
	Line.Size = UDim2.new(1, 0, 0, 3)
	table.insert(Leaf.colorElements, {element = Line, property = "BackgroundColor3"})

	window.allTabs = {}
	window.activeTab = nil
	window.allDropdowns = {}
	window.allColorPickers = {}
	
	local function setActiveTab(tab)
		if window.activeTab then
			window.activeTab.ScrollingFrame.Visible = false
			window.activeTab.TabButton.ImageColor3 = Color3.fromRGB(130, 130, 130)
		end
		window.activeTab = tab
		window.activeTab.ScrollingFrame.Visible = true
		window.activeTab.TabButton.ImageColor3 = Leaf.MenuColorValue.Value
		
		for _, dropdown in ipairs(window.allDropdowns) do
			dropdown.Visible = false
		end
		for _, picker in ipairs(window.allColorPickers) do
			picker.Visible = false
		end
	end
	
	function window:CreateTab(props)
		local tab = {}
		local TabButton = Instance.new("ImageButton")
		local UICornerTab = Instance.new("UICorner")
		
		TabButton.Name = "Tab"..#window.allTabs+1
		TabButton.Parent = TopBar
		TabButton.BackgroundTransparency = 1
		TabButton.Position = UDim2.new(0.743 + (#window.allTabs * 0.081) - (#window.allTabs > 2 and 0.081 * 3 or 0) , 0, #window.allTabs > 2 and 0.073 + 1.2 or 0.073, 0)
		TabButton.Size = UDim2.new(0, 25, 0, 25)
		TabButton.Image = props.Image
		TabButton.ImageColor3 = props.Opened and Leaf.MenuColorValue.Value or Color3.fromRGB(130, 130, 130)
		
		UICornerTab.CornerRadius = UDim.new(0, 4)
		UICornerTab.Parent = TabButton
		
		local ScrollingFrame = Instance.new("ScrollingFrame")
		ScrollingFrame.Parent = Mainframe
		ScrollingFrame.Active = true
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.Size = UDim2.new(0, 309, 0, 200)
		ScrollingFrame.Visible = props.Opened
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 3
		
		tab.TabButton = TabButton
		tab.ScrollingFrame = ScrollingFrame
		tab.nextPosition = 10
        table.insert(window.AllElements, {Type = "Tab", Instance = tab})
		
		function tab:Button(props)
			local ButtonFrame = Instance.new("Frame")
			local UICornerBtn = Instance.new("UICorner")
			local Indicator = Instance.new("Frame")
			local UICornerInd = Instance.new("UICorner")
			local NameButton = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			
			ButtonFrame.Parent = self.ScrollingFrame
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ButtonFrame.Size = UDim2.new(0, 280, 0, 40)
			ButtonFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerBtn.CornerRadius = UDim.new(0, 4)
			UICornerBtn.Parent = ButtonFrame
			
			Indicator.Parent = ButtonFrame
			Indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Indicator.Position = UDim2.new(0.952, 0, 0.2, 0)
			Indicator.Size = UDim2.new(0, 5, 0, 23)
			
			UICornerInd.CornerRadius = UDim.new(0, 4)
			UICornerInd.Parent = Indicator
			
			NameButton.Parent = ButtonFrame
			NameButton.BackgroundTransparency = 1
			NameButton.Position = UDim2.new(0.04, 0, 0, 0)
			NameButton.Size = UDim2.new(0.8, 0, 1, 0)
			NameButton.Font = Enum.Font.GothamBold
			NameButton.Text = props.Title
			NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameButton.TextSize = 16
			NameButton.TextXAlignment = Enum.TextXAlignment.Left
			
			TextButton.Parent = ButtonFrame
			TextButton.BackgroundTransparency = 1
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Text = ""
			
			local clickCount = 0
			
			TextButton.MouseButton1Click:Connect(function()
				clickCount = clickCount + 1
				local currentClick = clickCount
				
				Indicator.BackgroundColor3 = Leaf.MenuColorValue.Value
				
				if props.Callback then pcall(props.Callback) end
				
				local startTime = os.clock()
				while os.clock() - startTime < (props.Active or 0.5) do
					RunService.Heartbeat:Wait()
				end
				
				if clickCount == currentClick then
					Indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				end
			end)
			
			self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            table.insert(window.AllElements, {Type = "Button", Instance = ButtonFrame, Title = NameButton, Elements = {Indicator}})
		end

		function tab:DeButton(props)
			local DeButtonFrame = Instance.new("Frame")
			local UICornerDeBtn = Instance.new("UICorner")
			local NameButton = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			
			DeButtonFrame.Parent = self.ScrollingFrame
			DeButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
			table.insert(Leaf.colorElements, {element = DeButtonFrame, property = "BackgroundColor3"})
			DeButtonFrame.Size = UDim2.new(0, 280, 0, 40)
			DeButtonFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerDeBtn.CornerRadius = UDim.new(0, 4)
			UICornerDeBtn.Parent = DeButtonFrame
			
			NameButton.Parent = DeButtonFrame
			NameButton.BackgroundTransparency = 1
			NameButton.Size = UDim2.new(1, 0, 1, 0)
			NameButton.Font = Enum.Font.GothamBold
			NameButton.Text = props.Title
			NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameButton.TextSize = 25
			
			TextButton.Parent = DeButtonFrame
			TextButton.BackgroundTransparency = 1
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Text = ""
			
			TextButton.MouseButton1Click:Connect(function()
				if props.Callback then pcall(props.Callback) end
			end)
			
			self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            table.insert(window.AllElements, {Type = "DeButton", Instance = DeButtonFrame, Title = NameButton})
		end

		function tab:Toggle(props)
			local toggleObject = { __type = "Toggle", Value = props.Default or false }
			local ToggleFrame = Instance.new("Frame")
			local UICornerTog = Instance.new("UICorner")
			local Indicator = Instance.new("Frame")
			local UICornerInd = Instance.new("UICorner")
			local Circle = Instance.new("Frame")
			local UICornerCir = Instance.new("UICorner")
			local NameButton = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			
			ToggleFrame.Parent = self.ScrollingFrame
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ToggleFrame.Size = UDim2.new(0, 280, 0, 40)
			ToggleFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerTog.CornerRadius = UDim.new(0, 4)
			UICornerTog.Parent = ToggleFrame
			
			Indicator.Parent = ToggleFrame
			Indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Indicator.Position = UDim2.new(0.802, 0, 0.25, 0)
			Indicator.Size = UDim2.new(0, 45, 0, 20)
			
			UICornerInd.CornerRadius = UDim.new(0, 4)
			UICornerInd.Parent = Indicator
			
			Circle.Parent = Indicator
			Circle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Circle.Size = UDim2.new(0, 15, 0, 15)
			Circle.Position = UDim2.new(0.05, 0, 0.1, 0)
			
			UICornerCir.CornerRadius = UDim.new(1, 0)
			UICornerCir.Parent = Circle
			
			NameButton.Parent = ToggleFrame
			NameButton.BackgroundTransparency = 1
			NameButton.Position = UDim2.new(0.04, 0, 0, 0)
			NameButton.Size = UDim2.new(0.6, 0, 1, 0)
			NameButton.Font = Enum.Font.GothamBold
			NameButton.Text = props.Title
			NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameButton.TextSize = 16
			NameButton.TextXAlignment = Enum.TextXAlignment.Left
			
			TextButton.Parent = ToggleFrame
			TextButton.BackgroundTransparency = 1
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Text = ""
			
			local toggleData = { state = toggleObject.Value, indicator = Indicator }
			table.insert(Leaf.toggles, toggleData)
			
			local function updateToggleVisuals()
				local targetPos = toggleObject.Value and UDim2.new(0.6, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
				local targetIndColor = toggleObject.Value and Leaf.MenuColorValue.Value or Color3.fromRGB(30, 30, 30)
				local targetCircColor = toggleObject.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
				TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetCircColor}):Play()
				TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetIndColor}):Play()
			end

			function toggleObject:Set(value)
				toggleObject.Value = value
				toggleData.state = value
				updateToggleVisuals()
				if props.Callback then pcall(props.Callback, toggleObject.Value) end
				if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
			end

			updateToggleVisuals()
			
			TextButton.MouseButton1Click:Connect(function()
				toggleObject:Set(not toggleObject.Value)
			end)
			
			self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
			if Leaf.Config then Leaf.Config:Register(props.Title, toggleObject) end
            table.insert(window.AllElements, {Type = "Toggle", Instance = ToggleFrame, Title = NameButton, Elements = {Indicator, Circle}})
		end

		function tab:Slider(props)
			local sliderObject = { __type = "Slider", Value = { Default = props.Value.Default } }
			local min, max, increment, default = props.Value.Min, props.Value.Max, props.Value.Increment, props.Value.Default
			
			local SliderFrame = Instance.new("Frame")
			local UICornerSld = Instance.new("UICorner")
			local SliderName = Instance.new("TextLabel")
			local Fill = Instance.new("Frame")
			local UICornerFill = Instance.new("UICorner")
			local Progress = Instance.new("Frame")
			local UICornerProg = Instance.new("UICorner")
			local Snumber = Instance.new("TextLabel")
			
			SliderFrame.Parent = self.ScrollingFrame
			SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SliderFrame.Size = UDim2.new(0, 280, 0, 45)
			SliderFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerSld.CornerRadius = UDim.new(0, 4)
			UICornerSld.Parent = SliderFrame
			
			SliderName.Parent = SliderFrame
			SliderName.BackgroundTransparency = 1
			SliderName.Position = UDim2.new(0.04, 0, 0, 0)
			SliderName.Size = UDim2.new(0.5, 0, 0.5, 0)
			SliderName.Font = Enum.Font.GothamBold
			SliderName.Text = props.Title
			SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderName.TextSize = 16
			SliderName.TextXAlignment = Enum.TextXAlignment.Left
			
			Fill.Parent = SliderFrame
			Fill.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
			Fill.Position = UDim2.new(0.035, 0, 0.6, 0)
			Fill.Size = UDim2.new(0, 261, 0, 10)
			
			UICornerFill.CornerRadius = UDim.new(0, 4)
			UICornerFill.Parent = Fill
			
			Progress.Parent = Fill
			Progress.BackgroundColor3 = Leaf.MenuColorValue.Value
			table.insert(Leaf.colorElements, {element = Progress, property = "BackgroundColor3"})
			Progress.Size = UDim2.new(0, 0, 1, 0)
			
			UICornerProg.CornerRadius = UDim.new(0, 4)
			UICornerProg.Parent = Progress
			
			Snumber.Parent = SliderFrame
			Snumber.BackgroundTransparency = 1
			Snumber.Position = UDim2.new(1, -60, 0, 0)
			Snumber.Size = UDim2.new(0, 50, 0.5, 0)
			Snumber.Font = Enum.Font.GothamBold
			Snumber.Text = tostring(default)
			Snumber.TextColor3 = Color3.fromRGB(255, 255, 255)
			Snumber.TextSize = 16
			Snumber.TextXAlignment = Enum.TextXAlignment.Right
			Snumber.TextYAlignment = Enum.TextYAlignment.Center
			
			local dragging = false
			
			local function updateSliderVisuals(value)
				local percent = (value - min) / (max - min)
				Progress.Size = UDim2.new(percent, 0, 1, 0)
				Snumber.Text = tostring(value)
			end

			function sliderObject:Set(value)
				value = math.clamp(value, min, max)
				value = math.floor(value / increment + 0.5) * increment
				sliderObject.Value.Default = value
				updateSliderVisuals(value)
				if props.Callback then pcall(props.Callback, value) end
				if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
			end

			local function updateValueFromPosition(position)
				local fillAbsolute = Fill.AbsolutePosition
				local fillSize = Fill.AbsoluteSize
				local relativeX = math.clamp(position.X - fillAbsolute.X, 0, fillSize.X)
				local percent = relativeX / fillSize.X
				local value = min + (max - min) * percent
				sliderObject:Set(value)
			end

			Fill.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateValueFromPosition(input.Position)
				end
			end)
			
			Fill.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateValueFromPosition(input.Position)
				end
			end)
			
			sliderObject:Set(default)
			self.nextPosition = self.nextPosition + 50
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
			if Leaf.Config then Leaf.Config:Register(props.Title, sliderObject) end
            table.insert(window.AllElements, {Type = "Slider", Instance = SliderFrame, Title = SliderName, Value = Snumber, Elements = {Fill, Progress}})
		end
		
		function tab:Section(props)
			local SectionFrame = Instance.new("Frame")
			local UICornerSec = Instance.new("UICorner")
			local SectionTitle = Instance.new("TextLabel")
			local Underline = Instance.new("Frame")
			
			SectionFrame.Parent = self.ScrollingFrame
			SectionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			SectionFrame.Size = UDim2.new(0, 280, 0, 25)
			SectionFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerSec.CornerRadius = UDim.new(0, 4)
			UICornerSec.Parent = SectionFrame
			
			SectionTitle.Parent = SectionFrame
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Size = UDim2.new(1, 0, 1, 0)
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = props.Title
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextSize = 16
			
			Underline.Parent = SectionFrame
			Underline.BackgroundColor3 = Leaf.MenuColorValue.Value
			table.insert(Leaf.colorElements, {element = Underline, property = "BackgroundColor3"})
			Underline.Position = UDim2.new(0, 0, 1, -2)
			Underline.Size = UDim2.new(1, 0, 0, 2)
			
			self.nextPosition = self.nextPosition + 30
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            table.insert(window.AllElements, {Type = "Section", Instance = SectionFrame, Title = SectionTitle, Elements = {Underline}})
		end
		
		function tab:CreateDropdown(props)
			local dropdownObject = { __type = "Dropdown", Value = props.CurrentOption }
			local DropdownFrame = Instance.new("Frame")
			local UICornerDrop = Instance.new("UICorner")
			local Dropdownname = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			local Info = Instance.new("TextButton")
			local UICornerInfo = Instance.new("UICorner")
			local DropdownList = Instance.new("Frame")
			local UICornerList = Instance.new("UICorner")
			local ScrollingFrameList = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			
			DropdownFrame.Parent = self.ScrollingFrame
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			DropdownFrame.Size = UDim2.new(0, 280, 0, 40)
			DropdownFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
			
			UICornerDrop.CornerRadius = UDim.new(0, 4)
			UICornerDrop.Parent = DropdownFrame
			
			Dropdownname.Parent = DropdownFrame
			Dropdownname.BackgroundTransparency = 1
			Dropdownname.Position = UDim2.new(0.04, 0, 0, 0)
			Dropdownname.Size = UDim2.new(0.5, 0, 1, 0)
			Dropdownname.Font = Enum.Font.GothamBold
			Dropdownname.Text = props.Name
			Dropdownname.TextColor3 = Color3.fromRGB(255, 255, 255)
			Dropdownname.TextSize = 16
			Dropdownname.TextXAlignment = Enum.TextXAlignment.Left
			
			TextButton.Parent = DropdownFrame
			TextButton.BackgroundTransparency = 1
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Text = ""
			
			Info.Parent = DropdownFrame
			Info.BackgroundColor3 = Leaf.MenuColorValue.Value
			table.insert(Leaf.colorElements, {element = Info, property = "BackgroundColor3"})
			Info.Position = UDim2.new(0.72, 0, 0.2, 0)
			Info.Size = UDim2.new(0.25, 0, 0.6, 0)
			Info.Font = Enum.Font.GothamBold
			Info.Text = props.CurrentOption
			Info.TextColor3 = Color3.fromRGB(255, 255, 255)
			Info.TextSize = 14
			
			UICornerInfo.CornerRadius = UDim.new(0, 4)
			UICornerInfo.Parent = Info
			
			DropdownList.Parent = OuterFrame
			DropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			DropdownList.Size = UDim2.new(0, 280, 0, 150)
			local framePos = DropdownFrame.AbsolutePosition
			DropdownList.Position = UDim2.fromOffset(framePos.X, framePos.Y + DropdownFrame.AbsoluteSize.Y)
			DropdownList.Visible = false
			DropdownList.ZIndex = 2
			table.insert(window.allDropdowns, DropdownList)

			UICornerList.CornerRadius = UDim.new(0, 4)
			UICornerList.Parent = DropdownList
			
			ScrollingFrameList.Parent = DropdownList
			ScrollingFrameList.BackgroundTransparency = 1
			ScrollingFrameList.Size = UDim2.new(1, 0, 1, 0)
			ScrollingFrameList.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrameList.ScrollBarThickness = 3
			
			UIListLayout.Parent = ScrollingFrameList
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			local function updateListPosition()
				local absPos = DropdownFrame.AbsolutePosition
				local absSize = DropdownFrame.AbsoluteSize
				DropdownList.Position = UDim2.fromOffset(absPos.X - OuterFrame.AbsolutePosition.X, absPos.Y - OuterFrame.AbsolutePosition.Y + absSize.Y)
			end

			function dropdownObject:Select(option)
				dropdownObject.Value = option
				Info.Text = option
				if props.Callback then pcall(props.Callback, option) end
				if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
			end

			function dropdownObject:UpdateOptions(options)
                if not ScrollingFrameList.Parent then return end
				for _,v in ipairs(ScrollingFrameList:GetChildren()) do
					if v:IsA("TextButton") then v:Destroy() end
				end
				local canvasHeight = 0
				for _, option in ipairs(options) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = ScrollingFrameList
					OptionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
					OptionButton.Size = UDim2.new(1, -10, 0, 30)
                    OptionButton.Position = UDim2.new(0.5, -OptionButton.AbsoluteSize.X/2, 0, 0)
					OptionButton.Font = Enum.Font.GothamBold
					OptionButton.Text = option
					OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.TextSize = 14
					OptionButton.MouseButton1Click:Connect(function()
						dropdownObject:Select(option)
						DropdownList.Visible = false
					end)
					canvasHeight = canvasHeight + 35
				end
				ScrollingFrameList.CanvasSize = UDim2.new(0, 0, 0, canvasHeight - 5)
			end
			
			dropdownObject:UpdateOptions(props.Options)
			
			TextButton.MouseButton1Click:Connect(function()
				updateListPosition()
				DropdownList.Visible = not DropdownList.Visible
			end)
			
			self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
			if Leaf.Config then Leaf.Config:Register(props.Name, dropdownObject) end
            table.insert(window.AllElements, {Type = "Dropdown", Instance = DropdownFrame, Title = Dropdownname, Value = Info})
			return dropdownObject
		end

		function tab:Input(props)
			local inputObject = { __type = "Input", Value = props.Default or "" }
			local InputFrame = Instance.new("Frame")
			local UICornerInp = Instance.new("UICorner")
			local InputName = Instance.new("TextLabel")
			local TextBox = Instance.new("TextBox")
			local UICornerBox = Instance.new("UICorner")

			InputFrame.Parent = self.ScrollingFrame
			InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			InputFrame.Size = UDim2.new(0, 280, 0, 40)
			InputFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)

			UICornerInp.CornerRadius = UDim.new(0, 4)
			UICornerInp.Parent = InputFrame

			InputName.Parent = InputFrame
			InputName.BackgroundTransparency = 1
			InputName.Position = UDim2.new(0.04, 0, 0, 0)
			InputName.Size = UDim2.new(0.3, 0, 1, 0)
			InputName.Font = Enum.Font.GothamBold
			InputName.Text = props.Title
			InputName.TextColor3 = Color3.fromRGB(255, 255, 255)
			InputName.TextSize = 16
			InputName.TextXAlignment = Enum.TextXAlignment.Left

			TextBox.Parent = InputFrame
			TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			TextBox.Position = UDim2.new(0.35, 0, 0.15, 0)
			TextBox.Size = UDim2.new(0.6, 0, 0.7, 0)
			TextBox.Font = Enum.Font.Gotham
			TextBox.Text = inputObject.Value
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 14
			TextBox.ClearTextOnFocus = false

			UICornerBox.CornerRadius = UDim.new(0, 4)
			UICornerBox.Parent = TextBox

			function inputObject:Set(text)
				inputObject.Value = text
				TextBox.Text = text
				if props.Callback then pcall(props.Callback, text) end
				if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
			end

			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					inputObject:Set(TextBox.Text)
				end
			end)
			TextBox:GetPropertyChangedSignal("Text"):Connect(function()
				inputObject.Value = TextBox.Text
				 if props.Callback then pcall(props.Callback, TextBox.Text) end
			end)

			self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
			if Leaf.Config then Leaf.Config:Register(props.Title, inputObject) end
            table.insert(window.AllElements, {Type = "Input", Instance = InputFrame, Title = InputName, Value = TextBox, Elements = {TextBox}})
			return inputObject
		end

        function tab:Keybind(props)
            local keybindObject = { __type = "Keybind", Value = props.Default or "None" }
            local KeybindFrame = Instance.new("Frame")
            local UICornerKey = Instance.new("UICorner")
            local KeybindName = Instance.new("TextLabel")
            local KeyButton = Instance.new("TextButton")
            local UICornerBtn = Instance.new("UICorner")

            KeybindFrame.Parent = self.ScrollingFrame
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            KeybindFrame.Size = UDim2.new(0, 280, 0, 40)
            KeybindFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)

            UICornerKey.CornerRadius = UDim.new(0, 4)
            UICornerKey.Parent = KeybindFrame

            KeybindName.Parent = KeybindFrame
            KeybindName.BackgroundTransparency = 1
            KeybindName.Position = UDim2.new(0.04, 0, 0, 0)
            KeybindName.Size = UDim2.new(0.5, 0, 1, 0)
            KeybindName.Font = Enum.Font.GothamBold
            KeybindName.Text = props.Title
            KeybindName.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindName.TextSize = 16
            KeybindName.TextXAlignment = Enum.TextXAlignment.Left

            KeyButton.Parent = KeybindFrame
            KeyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            KeyButton.Position = UDim2.new(0.7, 0, 0.15, 0)
            KeyButton.Size = UDim2.new(0.25, 0, 0.7, 0)
            KeyButton.Font = Enum.Font.GothamBold
            KeyButton.Text = keybindObject.Value.Name
            KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeyButton.TextSize = 14

            UICornerBtn.CornerRadius = UDim.new(0, 4)
            UICornerBtn.Parent = KeyButton

            local isBinding = false

            function keybindObject:Set(key)
                keybindObject.Value = key
                KeyButton.Text = key.Name
                if props.Callback then pcall(props.Callback, key) end
                if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
            end

            KeyButton.MouseButton1Click:Connect(function()
                isBinding = true
                KeyButton.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                    if not gameProcessedEvent and isBinding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            keybindObject:Set(input.KeyCode)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            keybindObject:Set(Enum.KeyCode.MouseButton1)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            keybindObject:Set(Enum.KeyCode.MouseButton2)
                        end
                        isBinding = false
                        connection:Disconnect()
                    end
                end)
            end)

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            if Leaf.Config then Leaf.Config:Register(props.Title, keybindObject) end
            table.insert(window.AllElements, {Type = "Keybind", Instance = KeybindFrame, Title = KeybindName, Value = KeyButton})
            return keybindObject
        end

        function tab:ColorPicker(props)
            local colorObject = { __type = "Colorpicker", Value = props.Default or Color3.new(1,1,1) }
            local ColorPickerFrame = Instance.new("Frame")
            local UICornerFrame = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local ColorButton = Instance.new("TextButton")
            local UICornerButton = Instance.new("UICorner")
            local ColorPreview = Instance.new("Frame")
            local UICornerPreview = Instance.new("UICorner")

            ColorPickerFrame.Parent = self.ScrollingFrame
            ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ColorPickerFrame.Size = UDim2.new(0, 280, 0, 40)
            ColorPickerFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
            
            UICornerFrame.CornerRadius = UDim.new(0, 4)
            UICornerFrame.Parent = ColorPickerFrame

            NameLabel.Parent = ColorPickerFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            ColorButton.Parent = ColorPickerFrame
            ColorButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ColorButton.Position = UDim2.new(0.8, 0, 0.15, 0)
            ColorButton.Size = UDim2.new(0.15, 0, 0.7, 0)
            ColorButton.Text = ""

            UICornerButton.CornerRadius = UDim.new(0, 4)
            UICornerButton.Parent = ColorButton

            ColorPreview.Parent = ColorButton
            ColorPreview.BackgroundColor3 = colorObject.Value
            ColorPreview.Position = UDim2.new(0.5, -12.5, 0.5, -12.5)
            ColorPreview.Size = UDim2.new(0, 25, 0, 25)
            ColorPreview.ZIndex = ColorButton.ZIndex + 1

            UICornerPreview.CornerRadius = UDim.new(0, 4)
            UICornerPreview.Parent = ColorPreview

            local PickerPopup = Instance.new("Frame")
            local UICornerPopup = Instance.new("UICorner")
            local SaturationValue = Instance.new("ImageLabel")
            local UICornerSV = Instance.new("UICorner")
            local Hue = Instance.new("ImageLabel")
            local UICornerHue = Instance.new("UICorner")
            local SaturationValueCursor = Instance.new("Frame")
            local HueCursor = Instance.new("Frame")
            
            local currentHue, currentSat, currentVal = Color3.toHSV(colorObject.Value)
            
            function colorObject:Set(color)
                colorObject.Value = color
                ColorPreview.BackgroundColor3 = color
                if props.Callback then pcall(props.Callback, color) end
                if Leaf.Config and config.ConfigSystem.AutoSave then Leaf.Config:Save() end
            end

            PickerPopup.Name = "PickerPopup"
            PickerPopup.Parent = OuterFrame
            PickerPopup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PickerPopup.BorderSizePixel = 0
            PickerPopup.Size = UDim2.new(0, 150, 0, 170)
            PickerPopup.Visible = false
            PickerPopup.ZIndex = 10
            table.insert(window.allColorPickers, PickerPopup)

            UICornerPopup.CornerRadius = UDim.new(0, 4)
            UICornerPopup.Parent = PickerPopup
            
            SaturationValue.Parent = PickerPopup
            SaturationValue.Position = UDim2.new(0.05, 0, 0.05, 0)
            SaturationValue.Size = UDim2.new(0, 130, 0, 130)
            SaturationValue.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
            SaturationValue.Image = "rbxassetid://4155525547"

            UICornerSV.CornerRadius = UDim.new(0, 4)
            UICornerSV.Parent = SaturationValue
            
            Hue.Parent = PickerPopup
            Hue.Position = UDim2.new(0.05, 0, 0.85, 0)
            Hue.Size = UDim2.new(0, 130, 0, 20)
            Hue.Image = "rbxassetid://4155525482"
            
            UICornerHue.CornerRadius = UDim.new(0, 4)
            UICornerHue.Parent = Hue
            
            SaturationValueCursor.Parent = SaturationValue
            SaturationValueCursor.BackgroundColor3 = Color3.new(1,1,1)
            SaturationValueCursor.Size = UDim2.new(0, 8, 0, 8)
            SaturationValueCursor.BorderSizePixel = 2
            SaturationValueCursor.BorderColor3 = Color3.new(0,0,0)
            local cursorCorner = Instance.new("UICorner")
            cursorCorner.CornerRadius = UDim.new(1,0)
            cursorCorner.Parent = SaturationValueCursor

            HueCursor.Parent = Hue
            HueCursor.BackgroundColor3 = Color3.new(1,1,1)
            HueCursor.Size = UDim2.new(0, 4, 0, 20)

            local function UpdateCursors()
                SaturationValueCursor.Position = UDim2.new(currentSat, -4, 1-currentVal, -4)
                HueCursor.Position = UDim2.new(currentHue, -2, 0, 0)
            end

            local function UpdateColor()
                local newColor = Color3.fromHSV(currentHue, currentSat, currentVal)
                colorObject:Set(newColor)
                SaturationValue.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
            end

            local function HandleSVInput(inputPos)
                local relativePos = inputPos - SaturationValue.AbsolutePosition
                currentSat = math.clamp(relativePos.X / SaturationValue.AbsoluteSize.X, 0, 1)
                currentVal = math.clamp(1 - (relativePos.Y / SaturationValue.AbsoluteSize.Y), 0, 1)
                UpdateCursors()
                UpdateColor()
            end
            
            local function HandleHueInput(inputPos)
                local relativePos = inputPos - Hue.AbsolutePosition
                currentHue = math.clamp(relativePos.X / Hue.AbsoluteSize.X, 0, 1)
                UpdateCursors()
                UpdateColor()
            end

            local svDragging, hueDragging = false, false
            SaturationValue.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true; HandleSVInput(input.Position) end end)
            SaturationValue.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end end)
            Hue.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true; HandleHueInput(input.Position) end end)
            Hue.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end end)

            UserInputService.InputChanged:Connect(function(input)
                if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then HandleSVInput(input.Position) end
                if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then HandleHueInput(input.Position) end
            end)

            ColorButton.MouseButton1Click:Connect(function()
                local absPos = ColorPickerFrame.AbsolutePosition
                local absSize = ColorPickerFrame.AbsoluteSize
                PickerPopup.Position = UDim2.fromOffset(absPos.X - OuterFrame.AbsolutePosition.X, absPos.Y - OuterFrame.AbsolutePosition.Y + absSize.Y)
                PickerPopup.Visible = not PickerPopup.Visible
                UpdateCursors()
            end)

            UpdateCursors()
            UpdateColor()
            
            self.nextPosition = self.nextPosition + 45
			self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            if Leaf.Config then Leaf.Config:Register(props.Title, colorObject) end
            table.insert(window.AllElements, {Type = "ColorPicker", Instance = ColorPickerFrame, Title = NameLabel, Value = ColorPreview})
        end

		table.insert(window.allTabs, tab)
		if props.Opened then setActiveTab(tab) end
		
		TabButton.MouseButton1Click:Connect(function()
			setActiveTab(tab)
		end)
		
		return tab
	end
	
	if config.ConfigSystem and config.ConfigSystem.Enabled then
		ConfigManager:Init(window)
		Leaf.Config = ConfigManager:CreateConfig(config.ConfigSystem.DefaultConfig or "default")

		local configTab = window:CreateTab({
			Image = "rbxassetid://6031104650",
			Opened = false
		})

		local currentConfigName = config.ConfigSystem.DefaultConfig or "default"
		local selectedConfigToLoad = currentConfigName

		local allConfigs = ConfigManager:AllConfigs()
		if #allConfigs == 0 then table.insert(allConfigs, currentConfigName) end
		
		configTab:Section({Title = "Config System"})

		local dropdown = configTab:CreateDropdown({
			Name = "Configs",
			Options = allConfigs,
			CurrentOption = currentConfigName,
			Callback = function(option)
				selectedConfigToLoad = option
			end
		})

		local nameInput = configTab:Input({
			Title = "Name",
			Default = currentConfigName,
			Callback = function(text)
				currentConfigName = text
			end
		})

		configTab:DeButton({
			Title = "Load",
			Callback = function()
				Leaf.Config = ConfigManager:CreateConfig(selectedConfigToLoad)
				Leaf.Config.Elements = window.RegisteredElements
				Leaf.Config:Load()
			end
		})

		configTab:DeButton({
			Title = "Save",
			Callback = function()
				local configToSave = ConfigManager:CreateConfig(currentConfigName)
				configToSave.Elements = window.RegisteredElements
				configToSave:Save()
				task.wait(0.1)
				dropdown:UpdateOptions(ConfigManager:AllConfigs())
			end
		})
		
		local originalRegister = Leaf.Config.Register
		Leaf.Config.Register = function(cfg, name, element)
			originalRegister(cfg, name, element)
			window.RegisteredElements[name] = element
		end
		if config.ConfigSystem.AutoSave == false then
			task.spawn(function()
				task.wait(0.5)
				Leaf.Config:Load()
			end)
		end
	end
    
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Parent = MiniMenu
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -210, 0, 10)
    NotificationHolder.Size = UDim2.new(0, 200, 1, -20)
    local NotifListLayout = Instance.new("UIListLayout")
    NotifListLayout.Parent = NotificationHolder
    NotifListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifListLayout.Padding = UDim.new(0, 5)

    function Leaf:CreateNotification(notifConfig)
        local notifFrame = Instance.new("Frame")
        notifFrame.Parent = NotificationHolder
        notifFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        notifFrame.Size = UDim2.new(1, 0, 0, 60)
        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notifFrame
        local notifStroke = Instance.new("UIStroke")
        notifStroke.Color = Leaf.MenuColorValue.Value
        notifStroke.Parent = notifFrame

        local notifTitle = Instance.new("TextLabel")
        notifTitle.Parent = notifFrame
        notifTitle.BackgroundTransparency = 1
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.Text = notifConfig.Title or "Notification"
        notifTitle.TextColor3 = Leaf.MenuColorValue.Value
        notifTitle.TextSize = 16
        notifTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
        notifTitle.Size = UDim2.new(0.9, 0, 0.3, 0)
        notifTitle.TextXAlignment = Enum.TextXAlignment.Left

        local notifText = Instance.new("TextLabel")
        notifText.Parent = notifFrame
        notifText.BackgroundTransparency = 1
        notifText.Font = Enum.Font.Gotham
        notifText.Text = notifConfig.Text or ""
        notifText.TextColor3 = Color3.fromRGB(255,255,255)
        notifText.TextSize = 14
        notifText.TextWrapped = true
        notifText.Position = UDim2.new(0.05, 0, 0.4, 0)
        notifText.Size = UDim2.new(0.9, 0, 0.5, 0)
        notifText.TextXAlignment = Enum.TextXAlignment.Left
        notifText.TextYAlignment = Enum.TextYAlignment.Top

        notifFrame.Size = UDim2.new(1, 0, 0, 0)
        TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        
        task.delay(notifConfig.Time or 5, function()
            if notifFrame and notifFrame.Parent then
                TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                task.wait(0.3)
                notifFrame:Destroy()
            end
        end)
    end

	local Draggable = false
	local DragStart = nil
	local StartPosition = nil
	
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Draggable = true
			DragStart = input.Position
			StartPosition = OuterFrame.Position
		end
	end)
	
	TopBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Draggable = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if Draggable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local newPosition = input.Position
			local delta = newPosition - DragStart
			OuterFrame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
		end
	end)
	
	Bmenu.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = not ScreenGui.Enabled
	end)
	
	return window, Leaf
end

return Leaf
