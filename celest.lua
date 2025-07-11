local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ConfigManager = {}

ConfigManager.Parser = {
    Colorpicker = {
        Save = function(obj)
            return {
                __type = obj.__type,
                value = obj.Default:ToHex(),
                transparency = obj.Transparency or nil,
            }
        end,
        Load = function(element, data)
            if element then
                element:Update(Color3.fromHex(data.value), data.transparency or nil)
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
            if element then
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
            if element then
                element:Set(data.value)
            end
        end
    },
    Keybind = {
        Save = function(obj)
            return {
                __type = obj.__type,
                value = obj.Value,
            }
        end,
        Load = function(element, data)
            if element then
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
            if element then
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
            if element then
                element:Set(data.value)
            end
        end
    },
}

function ConfigManager:Init(Window)
    if not Window.Folder then
        warn("[ WindUI.ConfigManager ] Window.Folder is not specified.")
        return false
    end
    ConfigManager.Window = Window
    ConfigManager.Folder = Window.Folder
    ConfigManager.Path = "WindUI/" .. tostring(ConfigManager.Folder) .. "/config/"
    return ConfigManager
end

function ConfigManager:CreateConfig(configFilename)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {}
    }
    if not configFilename then
        return false, "No config file is selected"
    end

    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
    end
    
    function ConfigModule:Save()
        local saveData = {
            Elements = {}
        }
        for name,i in next, ConfigModule.Elements do
            if ConfigManager.Parser[i.__type] then
                saveData.Elements[tostring(name)] = ConfigManager.Parser[i.__type].Save(i)
            end
        end
        print(HttpService:JSONEncode(saveData))
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
            local name = file:match("([^\\/]+)%.json$")
            if name then
                table.insert(files, name)
            end
        end
        return files
    end
    return false
end

local Leaf = loadstring(game:HttpGet("https://raw.githubusercontent.com/Replicade7/vvv/refs/heads/main/celest.lua"))()

function Leaf:CreateWindow(config)
    local window = {}
    Leaf.MenuColorValue = Instance.new("Color3Value")
    Leaf.MenuColorValue.Value = Color3.fromRGB(config.Color[1], config.Color[2], config.Color[3])
    Leaf.colorElements = {}
    Leaf.toggles = {}
    
    local configSystemEnabled = config.ConfigSystem and config.ConfigSystem.Enabled or false
    local defaultConfigName = config.ConfigSystem and config.ConfigSystem.DefaultConfig or "default"
    local autoSaveEnabled = config.ConfigSystem and config.ConfigSystem.AutoSave or false

    local myConfigManager = ConfigManager:Init(window)
    local currentConfig = myConfigManager:CreateConfig(defaultConfigName)
    local configFileNameInput = defaultConfigName
    
    Leaf.MenuColorValue.Changed:Connect(function()
        for _, item in ipairs(Leaf.colorElements) do
            item.element[item.property] = Leaf.MenuColorValue.Value
        end
        for _, toggleData in ipairs(Leaf.toggles) do
            if toggleData.state then
                toggleData.indicator.BackgroundColor3 = Leaf.MenuColorValue.Value
            end
        end
        if activeTab then
            activeTab.TabButton.ImageColor3 = Leaf.MenuColorValue.Value
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

    local allTabs = {}
    local activeTab
    local allDropdowns = {}
    local allColorPickers = {}
    
    local function setActiveTab(tab)
        if activeTab then
            activeTab.ScrollingFrame.Visible = false
            activeTab.TabButton.ImageColor3 = Color3.fromRGB(130, 130, 130)
        end
        activeTab = tab
        activeTab.ScrollingFrame.Visible = true
        activeTab.TabButton.ImageColor3 = Leaf.MenuColorValue.Value
        
        for _, dropdown in ipairs(allDropdowns) do
            dropdown.Visible = false
        end
        for _, picker in ipairs(allColorPickers) do
            picker.Visible = false
        end
    end
    
    function window:CreateTab(props)
        local tab = {}
        local TabButton = Instance.new("ImageButton")
        local UICornerTab = Instance.new("UICorner")
        
        TabButton.Name = "Tab"..#allTabs+1
        TabButton.Parent = TopBar
        TabButton.BackgroundTransparency = 1
        TabButton.Position = UDim2.new(0.743 + (#allTabs * 0.081), 0, 0.073, 0)
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
        
        TabButton.MouseButton1Click:Connect(function()
            setActiveTab(tab)
        end)
        
        if props.Opened then
            setActiveTab(tab)
        end
        
        table.insert(allTabs, tab)
        
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
            local runService = game:GetService("RunService")
            
            TextButton.MouseButton1Click:Connect(function()
                clickCount = clickCount + 1
                local currentClick = clickCount
                
                Indicator.BackgroundColor3 = Leaf.MenuColorValue.Value
                
                if props.Callback then pcall(props.Callback) end
                
                local startTime = os.clock()
                while os.clock() - startTime < (props.Active or 0.5) do
                    runService.Heartbeat:Wait()
                end
                
                if clickCount == currentClick then
                    Indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                end
            end)
            
            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
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
        end

        function tab:Toggle(props)
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
            
            local state = props.Default or false
            local toggleData = {
                state = state,
                indicator = Indicator
            }
            table.insert(Leaf.toggles, toggleData)
            
            local function updateToggle()
                if state then
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0.6, 0, 0.1, 0)}):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Leaf.MenuColorValue.Value}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0.05, 0, 0.1, 0)}):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end
            end
            
            updateToggle()
            
            TextButton.MouseButton1Click:Connect(function()
                state = not state
                toggleData.state = state
                updateToggle()
                if props.Callback then pcall(props.Callback, state) end
                if autoSaveEnabled then currentConfig:Save() end
            end)
            
            if configSystemEnabled then
                local element = {__type = "Toggle", Value = state, Set = function(value) state = value toggleData.state = value updateToggle() end}
                currentConfig:Register(props.Name, element)
            end

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return {
                Value = state,
                __type = "Toggle",
                Set = function(value)
                    state = value
                    toggleData.state = value
                    updateToggle()
                end
            }
        end

        function tab:Slider(props)
            local min = props.Value.Min
            local max = props.Value.Max
            local increment = props.Value.Increment
            local default = props.Value.Default
            
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
            
            local currentValue = default
            local dragging = false
            
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                value = math.floor(value / increment + 0.5) * increment
                currentValue = value
                
                local percent = (currentValue - min) / (max - min)
                Progress.Size = UDim2.new(percent, 0, 1, 0)
                Snumber.Text = tostring(currentValue)
                
                if props.Callback then pcall(props.Callback, currentValue) end
                if autoSaveEnabled then currentConfig:Save() end
            end
            
            local function updateValueFromPosition(position)
                local fillAbsolute = Fill.AbsolutePosition
                local fillSize = Fill.AbsoluteSize
                local relativeX = math.clamp(position.X - fillAbsolute.X, 0, fillSize.X)
                local percent = relativeX / fillSize.X
                local value = min + (max - min) * percent
                updateSlider(value)
            end
            
            local function handleInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateValueFromPosition(input.Position)
                end
            end
            
            local function endInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end
            
            Fill.InputBegan:Connect(handleInput)
            Fill.InputEnded:Connect(endInput)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateValueFromPosition(input.Position)
                end
            end)
            
            updateSlider(default)
            
            if configSystemEnabled then
                local element = {__type = "Slider", Value = {Default = currentValue}, Set = updateSlider}
                currentConfig:Register(props.Title, element)
            end

            self.nextPosition = self.nextPosition + 50 
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return {
                Value = {Default = currentValue},
                __type = "Slider",
                Set = updateSlider
            }
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
        end
        
        function tab:CreateDropdown(props)
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
            Info.Position = UDim2.new(0.72023803, 0, 0.200000003, 0)
            Info.Size = UDim2.new(0.25, 0, 0.6, 0)
            Info.Font = Enum.Font.GothamBold
            Info.Text = props.CurrentOption
            Info.TextColor3 = Color3.fromRGB(255, 255, 255)
            Info.TextSize = 14

            UICornerInfo.CornerRadius = UDim.new(0, 4)
            UICornerInfo.Parent = Info

            DropdownList.Parent = OuterFrame
            DropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            DropdownList.Size = UDim2.new(0.85, 0, 0, 150)
            DropdownList.Visible = false
            DropdownList.ZIndex = 2

            UICornerList.CornerRadius = UDim.new(0, 4)
            UICornerList.Parent = DropdownList

            ScrollingFrameList.Parent = DropdownList
            ScrollingFrameList.Active = true
            ScrollingFrameList.BackgroundTransparency = 1
            ScrollingFrameList.Size = UDim2.new(1, 0, 1, 0)
            ScrollingFrameList.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollingFrameList.ScrollBarThickness = 3
            ScrollingFrameList.ZIndex = 2

            UIListLayout.Parent = ScrollingFrameList
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            local function createOption(option)
                local OptionFrame = Instance.new("Frame")
                local UICornerOpt = Instance.new("UICorner")
                local OptionText = Instance.new("TextLabel")
                local OptionButton = Instance.new("TextButton")

                OptionFrame.Parent = ScrollingFrameList
                OptionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                OptionFrame.Size = UDim2.new(1, 0, 0, 25)
                OptionFrame.ZIndex = 2

                UICornerOpt.CornerRadius = UDim.new(0, 4)
                UICornerOpt.Parent = OptionFrame

                OptionText.Parent = OptionFrame
                OptionText.BackgroundTransparency = 1
                OptionText.Size = UDim2.new(1, 0, 1, 0)
                OptionText.Font = Enum.Font.GothamBold
                OptionText.Text = option
                OptionText.TextColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {element = OptionText, property = "TextColor3"})
                OptionText.TextSize = 14
                OptionText.ZIndex = 2

                OptionButton.Parent = OptionFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.Text = ""
                OptionButton.ZIndex = 2

                OptionButton.MouseButton1Click:Connect(function()
                    Info.Text = option
                    if props.Callback then pcall(props.Callback, option) end
                    if autoSaveEnabled then currentConfig:Save() end
                    DropdownList.Visible = false
                end)
            end

            for _, option in ipairs(props.Options) do
                createOption(option)
            end
            ScrollingFrameList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
            
            local isOpen = false
            TextButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    for _, dropdown in ipairs(allDropdowns) do
                        dropdown.Visible = false
                    end
                    local buttonAbsolutePos = DropdownFrame.AbsolutePosition
                    local menuAbsolutePos = OuterFrame.AbsolutePosition
                    local relativeX = buttonAbsolutePos.X - menuAbsolutePos.X
                    local relativeY = buttonAbsolutePos.Y - menuAbsolutePos.Y + DropdownFrame.AbsoluteSize.Y
                    DropdownList.Position = UDim2.new(0, relativeX, 0, relativeY)
                end
                DropdownList.Visible = isOpen
            end)
            table.insert(allDropdowns, DropdownList)

            if configSystemEnabled then
                local element = {__type = "Dropdown", Value = props.CurrentOption, Select = function(value) Info.Text = value if props.Callback then pcall(props.Callback, value) end end}
                currentConfig:Register(props.Name, element)
            end
            
            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return {
                Value = props.CurrentOption,
                __type = "Dropdown",
                Select = function(value)
                    Info.Text = value
                    if props.Callback then pcall(props.Callback, value) end
                end
            }
        end

        function tab:CreateColorPicker(props)
            local Name = props.Name
            local Color = props.Color
            local Callback = props.Callback

            local ColorPickerFrame = Instance.new("Frame")
            local UICornerCP = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local ColorIndicator = Instance.new("Frame")
            local UICornerCI = Instance.new("UICorner")
            local PickButton = Instance.new("TextButton")

            ColorPickerFrame.Parent = self.ScrollingFrame
            ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ColorPickerFrame.Size = UDim2.new(0, 280, 0, 40)
            ColorPickerFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)

            UICornerCP.CornerRadius = UDim.new(0, 4)
            UICornerCP.Parent = ColorPickerFrame

            NameLabel.Parent = ColorPickerFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = Name
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            ColorIndicator.Parent = ColorPickerFrame
            ColorIndicator.BackgroundColor3 = Color
            ColorIndicator.Position = UDim2.new(0.879427671, 0, 0.174999997, 0)
            ColorIndicator.Size = UDim2.new(0, 25, 0, 25)

            UICornerCI.CornerRadius = UDim.new(0, 4)
            UICornerCI.Parent = ColorIndicator

            PickButton.Parent = ColorPickerFrame
            PickButton.BackgroundTransparency = 1
            PickButton.Size = UDim2.new(1, 0, 1, 0)
            PickButton.Text = ""

            local ChangeColor = Instance.new("Frame")
            ChangeColor.Parent = ScreenGui
            ChangeColor.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ChangeColor.Size = UDim2.new(0, 159, 0, 180)
            ChangeColor.Visible = false
            ChangeColor.ZIndex = 5

            local TopBarCP = Instance.new("Frame")
            TopBarCP.Name = "TopBarColorPicker"
            TopBarCP.Parent = ChangeColor
            TopBarCP.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TopBarCP.Size = UDim2.new(1, 0, 0, 30)
            TopBarCP.Position = UDim2.new(0,0,0,0)

            local UICornerTopBarCP = Instance.new("UICorner")
            UICornerTopBarCP.CornerRadius = UDim.new(0,4)
            UICornerTopBarCP.Parent = TopBarCP

            local TopBarTitle = Instance.new("TextLabel")
            TopBarTitle.Parent = TopBarCP
            TopBarTitle.BackgroundTransparency = 1
            TopBarTitle.Size = UDim2.new(1,0,1,0)
            TopBarTitle.Font = Enum.Font.GothamBold
            TopBarTitle.Text = "Color Picker"
            TopBarTitle.TextColor3 = Color3.new(1,1,1)
            TopBarTitle.TextSize = 14

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Parent = ChangeColor
            UIStroke.Thickness = 2
            UIStroke.Color = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {element = UIStroke, property = "Color"})

            local ColorCanvas = Instance.new("Frame")
            ColorCanvas.Parent = ChangeColor
            ColorCanvas.BackgroundTransparency = 1
            ColorCanvas.BorderSizePixel = 0
            ColorCanvas.Position = UDim2.new(0.041, 0, 0.222, 0)
            ColorCanvas.Size = UDim2.new(0, 125, 0, 100)

            local HueSlider = Instance.new("Frame")
            HueSlider.Parent = ChangeColor
            HueSlider.BorderSizePixel = 0
            HueSlider.Position = UDim2.new(0.9, 0, 0.222, 0)
            HueSlider.Size = UDim2.new(0, 6, 0, 135)

            local HueSelector = Instance.new("Frame")
            HueSelector.Parent = HueSlider
            HueSelector.AnchorPoint = Vector2.new(0.5, 0.5)
            HueSelector.BorderSizePixel = 0
            HueSelector.Size = UDim2.new(0, 15, 0, 15)
            HueSelector.BackgroundColor3 = Color3.new(1, 1, 1)
            HueSelector.ZIndex = 10

            local UICornerHue = Instance.new("UICorner")
            UICornerHue.CornerRadius = UDim.new(1, 0)
            UICornerHue.Parent = HueSelector

            local UIStrokeHue = Instance.new("UIStroke")
            UIStrokeHue.Parent = HueSelector
            UIStrokeHue.Thickness = 1
            UIStrokeHue.Color = Color3.new(1, 1, 1)

            local ColorSelector = Instance.new("Frame")
            ColorSelector.Parent = ColorCanvas
            ColorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorSelector.BorderSizePixel = 0
            ColorSelector.Size = UDim2.new(0, 15, 0, 15)
            ColorSelector.BackgroundTransparency = 1
            ColorSelector.ZIndex = 10

            local UICornerSel = Instance.new("UICorner")
            UICornerSel.CornerRadius = UDim.new(1, 0)
            UICornerSel.Parent = ColorSelector

            local UIStrokeSel = Instance.new("UIStroke")
            UIStrokeSel.Parent = ColorSelector
            UIStrokeSel.Thickness = 2
            UIStrokeSel.Color = Color3.new(1, 1, 1)

            local ApplyButton = Instance.new("TextButton")
            ApplyButton.Parent = ChangeColor
            ApplyButton.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {element = ApplyButton, property = "BackgroundColor3"})
            ApplyButton.Size = UDim2.new(0, 140, 0, 20)
            ApplyButton.Position = UDim2.new(0.5, -70, 0.9, 0)
            ApplyButton.Text = "Apply"
            ApplyButton.Font = Enum.Font.GothamBold
            ApplyButton.TextColor3 = Color3.new(1,1,1)
            ApplyButton.TextSize = 14
            local UICornerApply = Instance.new("UICorner")
            UICornerApply.CornerRadius = UDim.new(0,4)
            UICornerApply.Parent = ApplyButton

            local H, S, V = Color:ToHSV()
            local currentTransparency = props.Transparency or 0

            local function updateColorCanvas()
                for x = 0, ColorCanvas.AbsoluteSize.X do
                    for y = 0, ColorCanvas.AbsoluteSize.Y do
                        local saturation = x / ColorCanvas.AbsoluteSize.X
                        local value = 1 - (y / ColorCanvas.AbsoluteSize.Y)
                        local pixelColor = Color3.fromHSV(H, saturation, value)
                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(0, 1, 0, 1)
                        frame.Position = UDim2.new(0, x, 0, y)
                        frame.BackgroundColor3 = pixelColor
                        frame.Parent = ColorCanvas
                    end
                end
            end

            local function updateHueSlider()
                for y = 0, HueSlider.AbsoluteSize.Y do
                    local hue = 1 - (y / HueSlider.AbsoluteSize.Y)
                    local pixelColor = Color3.fromHSV(hue, 1, 1)
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(0, 6, 0, 1)
                    frame.Position = UDim2.new(0, 0, 0, y)
                    frame.BackgroundColor3 = pixelColor
                    frame.Parent = HueSlider
                end
            end

            local function updateSelectors()
                local x = S * ColorCanvas.AbsoluteSize.X
                local y = (1 - V) * ColorCanvas.AbsoluteSize.Y
                ColorSelector.Position = UDim2.new(0, x, 0, y)

                local hueY = (1 - H) * HueSlider.AbsoluteSize.Y
                HueSelector.Position = UDim2.new(0.5, 0, 0, hueY)
            end

            local function pickColor(input)
                local pos = ColorCanvas.AbsolutePosition
                local size = ColorCanvas.AbsoluteSize
                local relativeX = math.clamp(input.Position.X - pos.X, 0, size.X)
                local relativeY = math.clamp(input.Position.Y - pos.Y, 0, size.Y)

                S = relativeX / size.X
                V = 1 - (relativeY / size.Y)

                updateColorCanvas()
                updateSelectors()
                ColorIndicator.BackgroundColor3 = Color3.fromHSV(H, S, V)
            end

            local function pickHue(input)
                local pos = HueSlider.AbsolutePosition
                local size = HueSlider.AbsoluteSize
                local relativeY = math.clamp(input.Position.Y - pos.Y, 0, size.Y)

                H = 1 - (relativeY / size.Y)

                updateColorCanvas()
                updateSelectors()
                ColorIndicator.BackgroundColor3 = Color3.fromHSV(H, S, V)
            end

            local draggingColor = false
            local draggingHue = false

            ColorCanvas.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingColor = true
                    pickColor(input)
                end
            end)
            ColorCanvas.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingColor = false
                end
            end)

            HueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    pickHue(input)
                end
            end)
            HueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingColor and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    pickColor(input)
                elseif draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    pickHue(input)
                end
            end)
            
            local function updateColor(newColor, newTransparency)
                ColorIndicator.BackgroundColor3 = newColor
                ColorIndicator.BackgroundTransparency = newTransparency or 0
                H, S, V = newColor:ToHSV()
                currentTransparency = newTransparency or 0
                updateColorCanvas()
                updateSelectors()
                if Callback then pcall(Callback, newColor, newTransparency) end
                if autoSaveEnabled then currentConfig:Save() end
            end

            PickButton.MouseButton1Click:Connect(function()
                for _, picker in ipairs(allColorPickers) do
                    picker.Visible = false
                end
                local buttonAbsolutePos = ColorPickerFrame.AbsolutePosition
                local menuAbsolutePos = OuterFrame.AbsolutePosition
                local relativeX = buttonAbsolutePos.X - menuAbsolutePos.X
                local relativeY = buttonAbsolutePos.Y - menuAbsolutePos.Y + ColorPickerFrame.AbsoluteSize.Y
                ChangeColor.Position = UDim2.new(0, relativeX, 0, relativeY)
                ChangeColor.Visible = not ChangeColor.Visible
                if ChangeColor.Visible then
                    updateColorCanvas()
                    updateHueSlider()
                    updateSelectors()
                end
            end)

            ApplyButton.MouseButton1Click:Connect(function()
                updateColor(Color3.fromHSV(H, S, V), currentTransparency)
                ChangeColor.Visible = false
            end)

            table.insert(allColorPickers, ChangeColor)

            if configSystemEnabled then
                local element = {__type = "Colorpicker", Default = Color, Transparency = currentTransparency, Update = updateColor}
                currentConfig:Register(Name, element)
            end

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return {
                Default = Color,
                Transparency = currentTransparency,
                __type = "Colorpicker",
                Update = updateColor
            }
        end

        function tab:Input(props)
            local InputFrame = Instance.new("Frame")
            local UICornerInp = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local InputBox = Instance.new("TextBox")
            local UICornerBox = Instance.new("UICorner")
            
            InputFrame.Parent = self.ScrollingFrame
            InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            InputFrame.Size = UDim2.new(0, 280, 0, 40)
            InputFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
            
            UICornerInp.CornerRadius = UDim.new(0, 4)
            UICornerInp.Parent = InputFrame
            
            NameLabel.Parent = InputFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            InputBox.Parent = InputFrame
            InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InputBox.Size = UDim2.new(0, 100, 0, 25)
            InputBox.Position = UDim2.new(0.6, 0, 0.2, 0)
            InputBox.Font = Enum.Font.GothamBold
            InputBox.Text = props.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 14
            InputBox.TextXAlignment = Enum.TextXAlignment.Center
            
            UICornerBox.CornerRadius = UDim.new(0, 4)
            UICornerBox.Parent = InputBox

            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    if props.Callback then pcall(props.Callback, InputBox.Text) end
                    if autoSaveEnabled then currentConfig:Save() end
                end
            end)

            if configSystemEnabled then
                local element = {__type = "Input", Value = InputBox.Text, Set = function(value) InputBox.Text = value if props.Callback then pcall(props.Callback, value) end end}
                currentConfig:Register(props.Title, element)
            end
            
            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return {
                Value = InputBox.Text,
                __type = "Input",
                Set = function(value)
                    InputBox.Text = value
                    if props.Callback then pcall(props.Callback, value) end
                end
            }
        end
    end

    local mainTab = window:CreateTab({
        Image = "rbxassetid://6031104650",
        Opened = true
    })

    mainTab:Section({Title = "Basic Options"})
    
    mainTab:Toggle({
        Name = "ExampleToggle1",
        Title = "Enable Feature A",
        Default = false,
        Callback = function(state)
            print("Feature A is now: " .. tostring(state))
        end
    })

    mainTab:Slider({
        Name = "ExampleSlider1",
        Title = "Adjust Value A",
        Value = {
            Min = 0,
            Max = 100,
            Increment = 5,
            Default = 50
        },
        Callback = function(value)
            print("Value A is now: " .. tostring(value))
        end
    })

    mainTab:CreateColorPicker({
        Name = "ExampleColor1",
        Color = Color3.fromRGB(255, 0, 0),
        Callback = function(color, transparency)
            print("Color A changed to: " .. tostring(color) .. " with transparency: " .. tostring(transparency))
        end
    })

    mainTab:Input({
        Name = "ExampleInput1",
        Title = "User Name",
        Default = "Guest",
        Callback = function(text)
            print("User Name set to: " .. text)
        end
    })

    local miscTab = window:CreateTab({
        Image = "rbxassetid://6031104650",
        Opened = false
    })

    miscTab:Section({Title = "Config System"})

    local configsDropdown
    configsDropdown = miscTab:CreateDropdown({
        Name = "Configs",
        Options = myConfigManager:AllConfigs() or {"default"},
        CurrentOption = defaultConfigName,
        Callback = function(option)
            currentConfig = myConfigManager:CreateConfig(option)
            configFileNameInput = option
            print("Selected Config:", option)
        end
    })
    
    miscTab:DeButton({
        Title = "Load Config",
        Callback = function()
            currentConfig:Load()
            print("Config loaded!")
        end
    })

    local nameInput
    nameInput = miscTab:Input({
        Title = "Config Name",
        Default = configFileNameInput,
        Callback = function(text)
            configFileNameInput = text
            print("Config Name set to:", text)
        end
    })

    miscTab:DeButton({
        Title = "Save Config",
        Callback = function()
            currentConfig = myConfigManager:CreateConfig(configFileNameInput)
            currentConfig:Save()
            local allConfigs = myConfigManager:AllConfigs()
            configsDropdown:Select(configFileNameInput)
            configsDropdown.Options = allConfigs
            print("Config saved as:", configFileNameInput)
        end
    })

    miscTab:Button({
        Title = "Refresh Configs",
        Callback = function()
            local allConfigs = myConfigManager:AllConfigs()
            configsDropdown.Options = allConfigs
            configsDropdown:Select(configFileNameInput)
            print("Configs refreshed.")
        end
    })
    
    local MiniMenuDragging, MiniMenuDragStart, MiniMenuStartPos
    Bmenu.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MiniMenuDragging = true
            MiniMenuDragStart = input.Position
            MiniMenuStartPos = MiniMenuFrame.Position
        end
    end)
    
    Bmenu.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MiniMenuDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if MiniMenuDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - MiniMenuDragStart
            MiniMenuFrame.Position = UDim2.new(
                MiniMenuStartPos.X.Scale,
                MiniMenuStartPos.X.Offset + delta.X,
                MiniMenuStartPos.Y.Scale,
                MiniMenuStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local dragging, dragStart, startPosMain
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosMain = OuterFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            OuterFrame.Position = UDim2.new(
                startPosMain.X.Scale,
                startPosMain.X.Offset + delta.X,
                startPosMain.Y.Scale,
                startPosMain.Y.Offset + delta.Y
            )
        end
    end)
    
    Bmenu.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    return window
end
