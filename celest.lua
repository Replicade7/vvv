local Leaf = {}
local HttpService = game:GetService("HttpService")

Leaf.Elements = {}
Leaf.Config = {
    Name = "default",
    Selected = "default",
    AutoSave = false
}

Leaf.Parser = {
    Colorpicker = {
        Save = function(obj)
            return {
                __type = obj.__type,
                value = obj.Value:ToHex(),
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
                element:Select(data.value, true)
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
    Slider = {
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

function Leaf:SaveConfig(name)
    if not pcall(makefolder, "Leaf") then
        makefolder("Leaf")
    end

    local dataToSave = {}
    for elementName, element in pairs(Leaf.Elements) do
        if Leaf.Parser[element.__type] then
            dataToSave[elementName] = Leaf.Parser[element.__type].Save(element)
        end
    end
    local json = HttpService:JSONEncode(dataToSave)
    writefile("Leaf/" .. name .. ".json", json)
end

function Leaf:LoadConfig(name)
    local path = "Leaf/" .. name .. ".json"
    if not isfile(path) then
        return
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)

    if not success or not data then
        return
    end

    for elementName, elementData in pairs(data) do
        local element = Leaf.Elements[elementName]
        if element and Leaf.Parser[elementData.__type] then
            Leaf.Parser[elementData.__type].Load(element, elementData)
        end
    end
end

function Leaf:GetAllConfigs()
    if not isfolder("Leaf") then return {} end
    local files = listfiles("Leaf")
    local configs = {}
    for _, file in ipairs(files) do
        local configName = file:match("([^/\\]+)%.json$")
        if configName then
            table.insert(configs, configName)
        end
    end
    return configs
end


function Leaf:CreateWindow(config)
    local window = {}
    Leaf.MenuColorValue = Instance.new("Color3Value")
    Leaf.MenuColorValue.Value = Color3.fromRGB(config.Color[1], config.Color[2], config.Color[3])
    Leaf.colorElements = {}
    Leaf.toggles = {}
    
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
            local toggleObject = { __type = "Toggle" }

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
            
            toggleObject.Value = props.Default or false
            local tweenService = game:GetService("TweenService")
            
            local function updateToggleVisuals()
                local pos = toggleObject.Value and UDim2.new(0.6, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
                local indColor = toggleObject.Value and Leaf.MenuColorValue.Value or Color3.fromRGB(30, 30, 30)
                local circColor = toggleObject.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                
                tweenService:Create(Circle, TweenInfo.new(0.2), {Position = pos}):Play()
                tweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = indColor}):Play()
                tweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = circColor}):Play()
            end
            
            function toggleObject:Set(state)
                toggleObject.Value = state
                updateToggleVisuals()
                if props.Callback then pcall(props.Callback, state) end
                if Leaf.Config.AutoSave then Leaf:SaveConfig(Leaf.Config.Selected) end
            end

            updateToggleVisuals()

            TextButton.MouseButton1Click:Connect(function()
                toggleObject:Set(not toggleObject.Value)
            end)
            
            Leaf.Elements[props.Title] = toggleObject
            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        function tab:Slider(props)
            local sliderObject = { __type = "Slider" }
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
            UICornerFill.Parent = UICornerFill
            
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
            
            function sliderObject:Set(value)
                value = math.clamp(value, min, max)
                value = math.floor(value / increment + 0.5) * increment
                sliderObject.Value = value
                
                local percent = (sliderObject.Value - min) / (max - min)
                Progress.Size = UDim2.new(percent, 0, 1, 0)
                Snumber.Text = tostring(sliderObject.Value)
                
                if props.Callback then pcall(props.Callback, sliderObject.Value) end
                if Leaf.Config.AutoSave then Leaf:SaveConfig(Leaf.Config.Selected) end
            end
            
            local function updateValueFromPosition(input)
                local fillAbsolute = Fill.AbsolutePosition
                local fillSize = Fill.AbsoluteSize
                local relativeX = math.clamp(input.Position.X - fillAbsolute.X, 0, fillSize.X)
                local percent = relativeX / fillSize.X
                local value = min + (max - min) * percent
                sliderObject:Set(value)
            end
            
            Fill.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateValueFromPosition(input)
                end
            end)
            
            Fill.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateValueFromPosition(input)
                end
            end)
            
            sliderObject:Set(default)
            Leaf.Elements[props.Title] = sliderObject
            self.nextPosition = self.nextPosition + 50
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
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
            local dropdownObject = { __type = "Dropdown" }
            
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
            DropdownList.Size = UDim2.new(0, 280, 0, 150)
            DropdownList.Visible = false
            DropdownList.ZIndex = 2
            
            UICornerList.CornerRadius = UDim.new(0, 4)
            UICornerList.Parent = DropdownList
            
            ScrollingFrameList.Parent = DropdownList
            ScrollingFrameList.BackgroundTransparency = 1
            ScrollingFrameList.Size = UDim2.new(1, 0, 1, 0)
            ScrollingFrameList.BorderSizePixel = 0
            ScrollingFrameList.ScrollBarThickness = 3
            
            UIListLayout.Parent = ScrollingFrameList
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            
            dropdownObject.Value = props.CurrentOption

            function dropdownObject:Select(option, fromConfig)
                dropdownObject.Value = option
                Info.Text = option
                if props.Callback and not fromConfig then pcall(props.Callback, option) end
                if Leaf.Config.AutoSave and not fromConfig then Leaf:SaveConfig(Leaf.Config.Selected) end
            end

            function dropdownObject:UpdateOptions(options)
                ScrollingFrameList.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
                for _, child in pairs(ScrollingFrameList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for _, option in pairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = ScrollingFrameList
                    OptionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    OptionButton.Size = UDim2.new(1, -10, 0, 20)
                    OptionButton.Position = UDim2.new(0.5, -((OptionButton.AbsoluteSize.X)/2),0,0)
                    OptionButton.Font = Enum.Font.GothamBold
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        dropdownObject:Select(option)
                        DropdownList.Visible = false
                    end)
                end
            end
            
            dropdownObject:UpdateOptions(props.Options)
            
            TextButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
                local pos = DropdownFrame.AbsolutePosition
                DropdownList.Position = UDim2.fromOffset(pos.X, pos.Y + DropdownFrame.AbsoluteSize.Y + 5)
            end)
            
            table.insert(allDropdowns, DropdownList)
            Leaf.Elements[props.Name] = dropdownObject

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
            return dropdownObject
        end

        function tab:Input(props)
            local inputObject = { __type = "Input" }

            local InputFrame = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local InputBox = Instance.new("TextBox")
            local UICornerBox = Instance.new("UICorner")
            
            InputFrame.Parent = self.ScrollingFrame
            InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            InputFrame.Size = UDim2.new(0, 280, 0, 40)
            InputFrame.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
            
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = InputFrame
            
            NameLabel.Parent = InputFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.4, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            InputBox.Parent = InputFrame
            InputBox.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {element = InputBox, property = "BackgroundColor3"})
            InputBox.Position = UDim2.new(0.5, 0, 0.2, 0)
            InputBox.Size = UDim2.new(0.45, 0, 0.6, 0)
            InputBox.Font = Enum.Font.GothamBold
            InputBox.Text = props.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 14
            InputBox.ClearTextOnFocus = false
            
            UICornerBox.CornerRadius = UDim.new(0, 4)
            UICornerBox.Parent = InputBox
            
            inputObject.Value = InputBox.Text
            
            function inputObject:Set(text)
                InputBox.Text = text
                inputObject.Value = text
                if props.Callback then pcall(props.Callback, text) end
            end

            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    inputObject:Set(InputBox.Text)
                    if Leaf.Config.AutoSave then Leaf:SaveConfig(Leaf.Config.Selected) end
                end
            end)
            
            Leaf.Elements[props.Title] = inputObject
            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end
        
        tab.nextPosition = tab.nextPosition + 5
        tab.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition)
        
        table.insert(allTabs, tab)
        if props.Opened then
            setActiveTab(tab)
        end
        
        TabButton.MouseButton1Click:Connect(function()
            setActiveTab(tab)
        end)
        
        return tab
    end
    
    local dragging = false
    local startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position - OuterFrame.Position.X.Offset
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newPos = input.Position - startPos
            OuterFrame.Position = UDim2.new(0, newPos.X, 0.5, 0)
        end
    end)
    
    Bmenu.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    if config.ConfigSystem and config.ConfigSystem.Enabled then
        Leaf.Config.AutoSave = config.ConfigSystem.AutoSave

        local ConfigTab = window:CreateTab({
            Image = "rbxassetid://6031104650",
            Opened = false
        })
        
        local configDropdown
        
        ConfigTab:Section({Title = "Configuration"})
        
        configDropdown = ConfigTab:CreateDropdown({
            Name = "Configs",
            Options = Leaf:GetAllConfigs(),
            CurrentOption = config.ConfigSystem.DefaultConfig or "default",
            Callback = function(option)
                Leaf.Config.Selected = option
                Leaf.Config.Name = option
                if Leaf.Elements["Name"] then Leaf.Elements["Name"]:Set(option) end
            end
        })
        
        ConfigTab:Input({
            Title = "Name",
            Default = config.ConfigSystem.DefaultConfig or "default",
            Callback = function(text)
                Leaf.Config.Name = text
            end
        })

        ConfigTab:DeButton({
            Title = "Save Config",
            Callback = function()
                Leaf:SaveConfig(Leaf.Config.Name)
                local allConfigs = Leaf:GetAllConfigs()
                configDropdown:UpdateOptions(allConfigs)
                configDropdown:Select(Leaf.Config.Name)
            end
        })

        ConfigTab:DeButton({
            Title = "Load Config",
            Callback = function()
                Leaf:LoadConfig(Leaf.Config.Selected)
            end
        })

        if config.ConfigSystem.DefaultConfig and config.ConfigSystem.DefaultConfig ~= "" then
            Leaf:LoadConfig(config.ConfigSystem.DefaultConfig)
        end
    end
    
    return window
end

return Leaf
