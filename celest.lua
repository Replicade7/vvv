local Leaf = {}
function Leaf:CreateWindow(config)
    local window = {}
    window.elements = {}
    Leaf.CurrentWindow = window
    Leaf.MenuColorValue = Instance.new("Color3Value")
    Leaf.MenuColorValue.Value = Color3.fromRGB(config.Color[1], config.Color[2], config.Color[3])
    Leaf.colorElements = {}
    Leaf.toggles = {}
    Leaf.MenuColorValue.Changed:Connect(function()
        for _, item in ipairs(Leaf.colorElements) do
            item.element[item.property] = Leaf.MenuColorValue.Value
        end
        for _, toggleData in ipairs(Leaf.toggles) do
            toggleData.update()
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
    ImageMiniMenu.Image = "rbxassetid://" .. config.LogoID
    ImageMiniMenu.ImageColor3 = Leaf.MenuColorValue.Value
    table.insert(Leaf.colorElements, {
        element = ImageMiniMenu,
        property = "ImageColor3"
    })

    Bmenu.Name = "Bmenu"
    Bmenu.Parent = MiniMenuFrame
    Bmenu.BackgroundTransparency = 1
    Bmenu.Size = UDim2.new(1, 0, 1, 0)
    Bmenu.Text = ""

    local ScreenGui = Instance.new("ScreenGui")
    local OuterFrame = Instance.new("Frame")
    local UIStroke1 = Instance.new("UIStroke")
    local InnerFrame = Instance.new("Frame")
    local UIStroke2 = Instance.new("UIStroke")
    local Mainframe = Instance.new("Frame")
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
    Mainframe.Size = UDim2.new(1, -20, 0, 195)
    Mainframe.Position = UDim2.new(0, 10, 0, 45)

    UIStroke3.Parent = Mainframe
    UIStroke3.Color = Color3.fromRGB(80, 80, 80)
    UIStroke3.Thickness = 2

    TopBar.Name = "TopBar"
    TopBar.Parent = Mainframe
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.Position = UDim2.new(0, 0, 0, 0)

    UIStroke4.Parent = TopBar
    UIStroke4.Color = Color3.fromRGB(80, 80, 80)
    UIStroke4.Thickness = 2

    TextLabel.Parent = TopBar
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.072, 0, 0, 0)
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
    table.insert(Leaf.colorElements, {
        element = Line,
        property = "BackgroundColor3"
    })

    local SubTabFrame = Instance.new("Frame")
    local UIStrokeSubTab = Instance.new("UIStroke")

    SubTabFrame.Name = "SubTabFrame"
    SubTabFrame.Parent = InnerFrame
    SubTabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SubTabFrame.Size = UDim2.new(1, -20, 0, 35)
    SubTabFrame.Position = UDim2.new(0, 10, 0, 45 + 195 + 5)
    SubTabFrame.Visible = false

    UIStrokeSubTab.Parent = SubTabFrame
    UIStrokeSubTab.Color = Color3.fromRGB(80, 80, 80)
    UIStrokeSubTab.Thickness = 2

    local allTabs = {}
    local activeTab
    local allDropdowns = {}
    local allColorPickers = {}

    local function updateTabPositions()
        local n = #allTabs
        if n == 0 then
            return
        end
        local buttonWidth = 25
        local gap = 1
        local rightPadding = 5
        local totalWidth = buttonWidth * n + gap * (n - 1)
        local startX = 310 - rightPadding - totalWidth
        for i, tab in ipairs(allTabs) do
            tab.TabButton.Position = UDim2.new(0, startX + (i - 1) * (buttonWidth + gap), 0.073, 0)
        end
    end

    local function setActiveTab(tab)
        if activeTab then
            activeTab.ScrollingFrame.Visible = false
            activeTab.TabButton.ImageColor3 = Color3.fromRGB(130, 130, 130)
            if activeTab.subTabs and #activeTab.subTabs > 0 then
                SubTabFrame.Visible = false
            end
        end
        activeTab = tab
        activeTab.ScrollingFrame.Visible = true
        activeTab.TabButton.ImageColor3 = Leaf.MenuColorValue.Value
        if activeTab.subTabs and #activeTab.subTabs > 0 then
            SubTabFrame.Visible = true
            for _, stab in ipairs(activeTab.subTabs) do
                stab.button.Visible = true
            end
        else
            SubTabFrame.Visible = false
        end
    end

    function window:CreateTab(configTab)
        local tab = {}
        tab.elements = {}
        tab.subTabs = {}
        tab.activeSubTab = nil

        local TabButton = Instance.new("ImageButton")
        local UIStroke5 = Instance.new("UIStroke")

        TabButton.Parent = InnerFrame
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, 25, 0, 25)
        TabButton.Image = configTab.Image
        TabButton.ImageColor3 = Color3.fromRGB(130, 130, 130)

        UIStroke5.Parent = TabButton
        UIStroke5.Thickness = 2
        UIStroke5.Color = Color3.fromRGB(80, 80, 80)

        local ScrollingFrame = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")

        ScrollingFrame.Parent = Mainframe
        ScrollingFrame.Active = true
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
        ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
        ScrollingFrame.ScrollBarThickness = 3
        ScrollingFrame.ScrollBarImageColor3 = Leaf.MenuColorValue.Value
        table.insert(Leaf.colorElements, {
            element = ScrollingFrame,
            property = "ScrollBarImageColor3"
        })
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 10)
        ScrollingFrame.Visible = false

        UIListLayout.Parent = ScrollingFrame
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)

        tab.ScrollingFrame = ScrollingFrame
        tab.TabButton = TabButton
        tab.nextPosition = 10

        function tab:CreateSubTab(configSubTab)
            local subTab = {}
            local button = Instance.new("TextButton")
            local UIStrokeSubBtn = Instance.new("UIStroke")

            button.Name = configSubTab.Name
            button.Parent = SubTabFrame
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0, 60, 1, -10)
            button.Position = UDim2.new(0, 0, 0, 5)
            button.Font = Enum.Font.GothamBold
            button.Text = configSubTab.Name
            button.TextColor3 = Color3.fromRGB(130, 130, 130)
            button.TextSize = 13
            button.Visible = false

            UIStrokeSubBtn.Parent = button
            UIStrokeSubBtn.Thickness = 1
            UIStrokeSubBtn.Color = Color3.fromRGB(80, 80, 80)

            local subScrollingFrame = Instance.new("ScrollingFrame")
            local subUIListLayout = Instance.new("UIListLayout")

            subScrollingFrame.Parent = Mainframe
            subScrollingFrame.Active = true
            subScrollingFrame.BackgroundTransparency = 1
            subScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
            subScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
            subScrollingFrame.ScrollBarThickness = 3
            subScrollingFrame.ScrollBarImageColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = subScrollingFrame,
                property = "ScrollBarImageColor3"
            })
            subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 10)
            subScrollingFrame.Visible = false

            subUIListLayout.Parent = subScrollingFrame
            subUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subUIListLayout.Padding = UDim.new(0, 10)

            subTab.button = button
            subTab.ScrollingFrame = subScrollingFrame
            subTab.nextPosition = 10

            local function setActiveSubTab(stab)
                if tab.activeSubTab then
                    tab.activeSubTab.button.TextSize = 13
                    tab.activeSubTab.button.TextColor3 = Color3.fromRGB(130, 130, 130)
                end
                tab.activeSubTab = stab
                tab.activeSubTab.button.TextSize = 14
                tab.activeSubTab.button.TextColor3 = Leaf.MenuColorValue.Value
            end

            button.MouseButton1Click:Connect(function()
                if tab.activeSubTab then
                    tab.activeSubTab.ScrollingFrame.Visible = false
                end
                setActiveSubTab(subTab)
                subScrollingFrame.Visible = true
            end)

            if configSubTab.Opened then
                if activeTab == tab then
                    setActiveSubTab(subTab)
                    subScrollingFrame.Visible = true
                    SubTabFrame.Visible = true
                end
            end

            table.insert(tab.subTabs, subTab)

            local function updateSubTabButtonPositions()
                local numSubTabs = #tab.subTabs
                if numSubTabs == 0 then return end

                local buttonWidth = 60
                local gap = 5
                local totalWidth = buttonWidth * numSubTabs + gap * (numSubTabs - 1)
                local startX = (SubTabFrame.AbsoluteSize.X - totalWidth) / 2

                for i, sTab in ipairs(tab.subTabs) do
                    sTab.button.Position = UDim2.new(0, startX + (i - 1) * (buttonWidth + gap), 0, 5)
                    sTab.button.Size = UDim2.new(0, buttonWidth, 1, -10)
                end
            end

            tab.updateSubTabButtonPositions = updateSubTabButtonPositions

            function subTab:Toggle(props)
                local ToggleFrame = Instance.new("Frame")
                local UICornerTog = Instance.new("UICorner")
                local NameLabel = Instance.new("TextLabel")
                local ToggleButton = Instance.new("Frame")
                local UICornerToggleBtn = Instance.new("UICorner")
                local UIStrokeToggle = Instance.new("UIStroke")
                local ToggleIndicator = Instance.new("Frame")
                local UICornerInd = Instance.new("UICorner")
                local TextButton = Instance.new("TextButton")

                ToggleFrame.Parent = subScrollingFrame
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ToggleFrame.Size = UDim2.new(0, 280, 0, 40)
                ToggleFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerTog.CornerRadius = UDim.new(0, 4)
                UICornerTog.Parent = ToggleFrame

                NameLabel.Parent = ToggleFrame
                NameLabel.BackgroundTransparency = 1
                NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
                NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.Text = props.Title
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.TextSize = 16
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left

                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                ToggleButton.Position = UDim2.new(0.871, 0, 0.175, 0)
                ToggleButton.Size = UDim2.new(0, 26, 0, 26)

                UICornerToggleBtn.CornerRadius = UDim.new(0, 4)
                UICornerToggleBtn.Parent = ToggleButton

                UIStrokeToggle.Parent = ToggleButton
                UIStrokeToggle.Thickness = 1
                UIStrokeToggle.Color = Color3.fromRGB(80, 80, 80)

                ToggleIndicator.Parent = ToggleButton
                ToggleIndicator.BackgroundColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = ToggleIndicator,
                    property = "BackgroundColor3"
                })
                ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
                ToggleIndicator.Size = UDim2.new(1, -4, 1, -4)
                ToggleIndicator.Visible = props.State

                UICornerInd.CornerRadius = UDim.new(0, 2)
                UICornerInd.Parent = ToggleIndicator

                TextButton.Parent = ToggleFrame
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.Text = ""

                local key = props.Title
                local toggled = props.State
                subTab.elements[key] = {
                    GetValue = function()
                        return toggled
                    end,
                    SetValue = function(value)
                        toggled = value
                        ToggleIndicator.Visible = value
                        if props.Callback then
                            pcall(props.Callback, value)
                        end
                    end
                }

                TextButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    ToggleIndicator.Visible = toggled
                    if props.Callback then
                        pcall(props.Callback, toggled)
                    end
                end)

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:Button(props)
                local ButtonFrame = Instance.new("Frame")
                local UICornerBtn = Instance.new("UICorner")
                local NameButton = Instance.new("TextLabel")
                local TextButton = Instance.new("TextButton")

                ButtonFrame.Parent = subScrollingFrame
                ButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = ButtonFrame,
                    property = "BackgroundColor3"
                })
                ButtonFrame.Size = UDim2.new(0, 280, 0, 40)
                ButtonFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerBtn.CornerRadius = UDim.new(0, 4)
                UICornerBtn.Parent = ButtonFrame

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
                    ButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    runService.Heartbeat:Wait()
                    if currentClick == clickCount and props.Callback then
                        pcall(props.Callback)
                    end
                    ButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
                end)

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:Slider(props)
                local min = props.Min
                local max = props.Max
                local increment = props.Increment
                local default = props.Default

                local SliderFrame = Instance.new("Frame")
                local UICornerSl = Instance.new("UICorner")
                local NameLabel = Instance.new("TextLabel")
                local SliderLine = Instance.new("Frame")
                local UICornerLine = Instance.new("UICorner")
                local Progress = Instance.new("Frame")
                local UICornerProg = Instance.new("UICorner")
                local SliderButton = Instance.new("TextButton")
                local Snumber = Instance.new("TextLabel")

                SliderFrame.Parent = subScrollingFrame
                SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SliderFrame.Size = UDim2.new(0, 280, 0, 50)
                SliderFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerSl.CornerRadius = UDim.new(0, 4)
                UICornerSl.Parent = SliderFrame

                NameLabel.Parent = SliderFrame
                NameLabel.BackgroundTransparency = 1
                NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
                NameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.Text = props.Title
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.TextSize = 16
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left

                SliderLine.Parent = SliderFrame
                SliderLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SliderLine.Position = UDim2.new(0.04, 0, 0.6, 0)
                SliderLine.Size = UDim2.new(0, 200, 0, 10)

                UICornerLine.CornerRadius = UDim.new(0, 4)
                UICornerLine.Parent = SliderLine

                Progress.Name = "Progress"
                Progress.Parent = SliderLine
                Progress.BackgroundColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = Progress,
                    property = "BackgroundColor3"
                })
                Progress.Size = UDim2.new(0, 0, 1, 0)
                Progress.Position = UDim2.new(0, 0, 0, 0)

                UICornerProg.CornerRadius = UDim.new(0, 4)
                UICornerProg.Parent = Progress

                SliderButton.Name = "SliderButton"
                SliderButton.Parent = SliderLine
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""

                Snumber.Name = "Snumber"
                Snumber.Parent = SliderFrame
                Snumber.BackgroundTransparency = 1
                Snumber.Position = UDim2.new(0.768, 0, 0.5, 0)
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
                    if props.Callback then
                        pcall(props.Callback, currentValue)
                    end
                end

                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    updateSlider(default)
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                        local relativeX = mouseLocation.X - SliderLine.AbsolutePosition.X
                        local percent = math.clamp(relativeX / SliderLine.AbsoluteSize.X, 0, 1)
                        local value = min + (max - min) * percent
                        updateSlider(value)
                    end
                end)

                local key = props.Title
                subTab.elements[key] = {
                    GetValue = function()
                        return currentValue
                    end,
                    SetValue = function(value)
                        updateSlider(value)
                    end
                }

                updateSlider(default)

                subTab.nextPosition = subTab.nextPosition + 55
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:Dropdown(props)
                local DropdownFrame = Instance.new("Frame")
                local UICornerDrop = Instance.new("UICorner")
                local NameLabel = Instance.new("TextLabel")
                local DropdownButton = Instance.new("Frame")
                local UICornerDropBtn = Instance.new("UICorner")
                local UIStrokeDrop = Instance.new("UIStroke")
                local Indicator = Instance.new("TextLabel")
                local TextButton = Instance.new("TextButton")
                local DropdownList = Instance.new("ScrollingFrame")
                local UIListLayout_2 = Instance.new("UIListLayout")

                DropdownFrame.Parent = subScrollingFrame
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                DropdownFrame.Size = UDim2.new(0, 280, 0, 40)
                DropdownFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerDrop.CornerRadius = UDim.new(0, 4)
                UICornerDrop.Parent = DropdownFrame

                NameLabel.Parent = DropdownFrame
                NameLabel.BackgroundTransparency = 1
                NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
                NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.Text = props.Title
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.TextSize = 16
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left

                DropdownButton.Parent = DropdownFrame
                DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                DropdownButton.Position = UDim2.new(0.871, 0, 0.175, 0)
                DropdownButton.Size = UDim2.new(0, 26, 0, 26)

                UICornerDropBtn.CornerRadius = UDim.new(0, 4)
                UICornerDropBtn.Parent = DropdownButton

                UIStrokeDrop.Parent = DropdownButton
                UIStrokeDrop.Thickness = 1
                UIStrokeDrop.Color = Color3.fromRGB(80, 80, 80)

                Indicator.Parent = DropdownButton
                Indicator.BackgroundTransparency = 1
                Indicator.Position = UDim2.new(0, 0, 0, 0)
                Indicator.Size = UDim2.new(1, 0, 1, 0)
                Indicator.Font = Enum.Font.GothamBold
                Indicator.Text = "+"
                Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
                Indicator.TextSize = 18

                TextButton.Parent = DropdownFrame
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.Text = ""

                DropdownList.Parent = subScrollingFrame
                DropdownList.Active = true
                DropdownList.BackgroundTransparency = 1
                DropdownList.Size = UDim2.new(0, 280, 0, 0)
                DropdownList.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition + 45)
                DropdownList.ScrollBarThickness = 3
                DropdownList.ScrollBarImageColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = DropdownList,
                    property = "ScrollBarImageColor3"
                })
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.Visible = false

                UIListLayout_2.Parent = DropdownList
                UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_2.Padding = UDim.new(0, 5)

                local isOpen = false
                local selectedOption = props.Options[1]
                local listHeight = 0

                local function toggleDropdown()
                    isOpen = not isOpen
                    Indicator.Text = isOpen and "-" or "+"
                    DropdownList.Visible = isOpen
                    if isOpen then
                        listHeight = 0
                        for i, option in ipairs(props.Options) do
                            listHeight = listHeight + 30 + 5
                        end
                        DropdownList.Size = UDim2.new(0, 280, 0, math.min(listHeight, 150))
                        DropdownList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
                    else
                        DropdownList.Size = UDim2.new(0, 280, 0, 0)
                    end
                    subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 55 + (isOpen and math.min(listHeight, 150) or 0))
                end

                TextButton.MouseButton1Click:Connect(toggleDropdown)

                for i, option in ipairs(props.Options) do
                    local OptionButton = Instance.new("TextButton")
                    local UICornerOpt = Instance.new("UICorner")

                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14

                    UICornerOpt.CornerRadius = UDim.new(0, 4)
                    UICornerOpt.Parent = OptionButton

                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        NameLabel.Text = props.Title .. ": " .. option
                        toggleDropdown()
                        if props.Callback then
                            pcall(props.Callback, option)
                        end
                    end)
                end

                local key = props.Title
                subTab.elements[key] = {
                    GetValue = function()
                        return selectedOption
                    end,
                    SetValue = function(option)
                        if table.find(props.Options, option) then
                            selectedOption = option
                            NameLabel.Text = props.Title .. ": " .. option
                            if props.Callback then
                                pcall(props.Callback, option)
                            end
                        end
                    end
                }

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:ColorPicker(props)
                local ColorPickerFrame = Instance.new("Frame")
                local UICornerCP = Instance.new("UICorner")
                local NameLabel = Instance.new("TextLabel")
                local ColorButton = Instance.new("Frame")
                local UICornerClrBtn = Instance.new("UICorner")
                local UIStrokeClr = Instance.new("UIStroke")
                local TextButton = Instance.new("TextButton")

                ColorPickerFrame.Parent = subScrollingFrame
                ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ColorPickerFrame.Size = UDim2.new(0, 280, 0, 40)
                ColorPickerFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerCP.CornerRadius = UDim.new(0, 4)
                UICornerCP.Parent = ColorPickerFrame

                NameLabel.Parent = ColorPickerFrame
                NameLabel.BackgroundTransparency = 1
                NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
                NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.Text = props.Title
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.TextSize = 16
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left

                ColorButton.Parent = ColorPickerFrame
                ColorButton.BackgroundColor3 = props.Default
                ColorButton.Position = UDim2.new(0.871, 0, 0.175, 0)
                ColorButton.Size = UDim2.new(0, 26, 0, 26)

                UICornerClrBtn.CornerRadius = UDim.new(0, 4)
                UICornerClrBtn.Parent = ColorButton

                UIStrokeClr.Parent = ColorButton
                UIStrokeClr.Thickness = 1
                UIStrokeClr.Color = Color3.fromRGB(80, 80, 80)

                TextButton.Parent = ColorPickerFrame
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.Text = ""

                local ChangeColor = Instance.new("Frame")
                local UICornerChClr = Instance.new("UICorner")
                local UIStrokeChClr = Instance.new("UIStroke")
                local ColorSelector = Instance.new("ImageButton")
                local UICornerClrSl = Instance.new("UICorner")
                local ColorIndicator = Instance.new("Frame")
                local UICornerInd = Instance.new("UICorner")
                local UIStrokeInd = Instance.new("UIStroke")
                local HueSlider = Instance.new("ImageButton")
                local UICornerHue = Instance.new("UICorner")
                local HueIndicator = Instance.new("Frame")
                local UICornerHueInd = Instance.new("UICorner")
                local UIStrokeHueInd = Instance.new("UIStroke")
                local ApplyButton = Instance.new("TextButton")
                local CancelButton = Instance.new("TextButton")

                ChangeColor.Name = "ChangeColor"
                ChangeColor.Parent = InnerFrame
                ChangeColor.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                ChangeColor.Position = UDim2.new(0.5, -150, 0.5, -100)
                ChangeColor.Size = UDim2.new(0, 300, 0, 200)
                ChangeColor.Visible = false
                ChangeColor.ZIndex = 2

                UICornerChClr.CornerRadius = UDim.new(0, 4)
                UICornerChClr.Parent = ChangeColor

                UIStrokeChClr.Parent = ChangeColor
                UIStrokeChClr.Thickness = 2
                UIStrokeChClr.Color = Color3.fromRGB(80, 80, 80)

                ColorSelector.Name = "ColorSelector"
                ColorSelector.Parent = ChangeColor
                ColorSelector.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                ColorSelector.Position = UDim2.new(0.05, 0, 0.1, 0)
                ColorSelector.Size = UDim2.new(0, 180, 0, 120)
                ColorSelector.ZIndex = 2

                UICornerClrSl.CornerRadius = UDim.new(0, 4)
                UICornerClrSl.Parent = ColorSelector

                ColorIndicator.Name = "ColorIndicator"
                ColorIndicator.Parent = ColorSelector
                ColorIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ColorIndicator.Position = UDim2.new(0, 0, 0, 0)
                ColorIndicator.Size = UDim2.new(0, 5, 0, 5)
                ColorIndicator.ZIndex = 2

                UICornerInd.CornerRadius = UDim.new(0, 1)
                UICornerInd.Parent = ColorIndicator

                UIStrokeInd.Parent = ColorIndicator
                UIStrokeInd.Thickness = 1
                UIStrokeInd.Color = Color3.fromRGB(0, 0, 0)

                HueSlider.Name = "HueSlider"
                HueSlider.Parent = ChangeColor
                HueSlider.BackgroundTransparency = 1
                HueSlider.Position = UDim2.new(0.7, 0, 0.1, 0)
                HueSlider.Size = UDim2.new(0, 15, 0, 120)
                HueSlider.ZIndex = 2

                UICornerHue.CornerRadius = UDim.new(0, 4)
                UICornerHue.Parent = HueSlider

                HueIndicator.Name = "HueIndicator"
                HueIndicator.Parent = HueSlider
                HueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueIndicator.Position = UDim2.new(-0.5, 0, 0, 0)
                HueIndicator.Size = UDim2.new(2, 0, 0, 2)
                HueIndicator.ZIndex = 2

                UICornerHueInd.CornerRadius = UDim.new(0, 1)
                UICornerHueInd.Parent = HueIndicator

                UIStrokeHueInd.Parent = HueIndicator
                UIStrokeHueInd.Thickness = 1
                UIStrokeHueInd.Color = Color3.fromRGB(0, 0, 0)

                ApplyButton.Parent = ChangeColor
                ApplyButton.BackgroundColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = ApplyButton,
                    property = "BackgroundColor3"
                })
                ApplyButton.Position = UDim2.new(0.449, 0, 0.805, 0)
                ApplyButton.Size = UDim2.new(0, 60, 0, 27)
                ApplyButton.Font = Enum.Font.GothamBold
                ApplyButton.Text = "Apply"
                ApplyButton.TextColor3 = Color3.new(1, 1, 1)
                ApplyButton.TextSize = 14
                ApplyButton.ZIndex = 2

                CancelButton.Parent = ChangeColor
                CancelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                CancelButton.Position = UDim2.new(0.449, 0, 0.805, 0)
                CancelButton.Size = UDim2.new(0, 60, 0, 27)
                CancelButton.Font = Enum.Font.GothamBold
                CancelButton.Text = "Cancel"
                CancelButton.TextColor3 = Color3.new(1, 1, 1)
                CancelButton.TextSize = 14
                CancelButton.Position = UDim2.new(0.2, 0, 0.805, 0)
                CancelButton.ZIndex = 2

                local originalColor = props.Default
                local color = props.Default

                local function updateColor()
                    local hue = 1 - (HueIndicator.Position.Y.Offset / HueSlider.AbsoluteSize.Y)
                    local saturation = ColorIndicator.Position.X.Offset / ColorSelector.AbsoluteSize.X
                    local value = 1 - ColorIndicator.Position.Y.Offset / ColorSelector.AbsoluteSize.Y
                    color = Color3.fromHSV(hue, saturation, value)
                    ColorButton.BackgroundColor3 = color
                end

                local function setDefaultColor(c)
                    local h, s, v = c:ToHSV()
                    HueIndicator.Position = UDim2.new(-0.5, 0, 1 - h, 0)
                    ColorSelector.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    ColorIndicator.Position = UDim2.new(s, 0, 1 - v, 0)
                    color = c
                    ColorButton.BackgroundColor3 = color
                end

                local draggingHue = false
                local draggingColor = false

                HueSlider.MouseButton1Down:Connect(function()
                    draggingHue = true
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local relativeY = math.clamp(mousePos.Y - HueSlider.AbsolutePosition.Y, 0, HueSlider.AbsoluteSize.Y)
                    HueIndicator.Position = UDim2.new(-0.5, 0, relativeY / HueSlider.AbsoluteSize.Y, 0)
                    ColorSelector.BackgroundColor3 = Color3.fromHSV(1 - (relativeY / HueSlider.AbsoluteSize.Y), 1, 1)
                    updateColor()
                end)

                ColorSelector.MouseButton1Down:Connect(function()
                    draggingColor = true
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local relativeX = math.clamp(mousePos.X - ColorSelector.AbsolutePosition.X, 0, ColorSelector.AbsoluteSize.X)
                    local relativeY = math.clamp(mousePos.Y - ColorSelector.AbsolutePosition.Y, 0, ColorSelector.AbsoluteSize.Y)
                    ColorIndicator.Position = UDim2.new(relativeX / ColorSelector.AbsoluteSize.X, 0, relativeY / ColorSelector.AbsoluteSize.Y, 0)
                    updateColor()
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                        local relativeY = math.clamp(mousePos.Y - HueSlider.AbsolutePosition.Y, 0, HueSlider.AbsoluteSize.Y)
                        HueIndicator.Position = UDim2.new(-0.5, 0, relativeY / HueSlider.AbsoluteSize.Y, 0)
                        ColorSelector.BackgroundColor3 = Color3.fromHSV(1 - (relativeY / HueSlider.AbsoluteSize.Y), 1, 1)
                        updateColor()
                    elseif draggingColor and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                        local relativeX = math.clamp(mousePos.X - ColorSelector.AbsolutePosition.X, 0, ColorSelector.AbsoluteSize.X)
                        local relativeY = math.clamp(mousePos.Y - ColorSelector.AbsolutePosition.Y, 0, ColorSelector.AbsoluteSize.Y)
                        ColorIndicator.Position = UDim2.new(relativeX / ColorSelector.AbsoluteSize.X, 0, relativeY / ColorSelector.AbsoluteSize.Y, 0)
                        updateColor()
                    end
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingHue = false
                        draggingColor = false
                    end
                end)

                ApplyButton.MouseButton1Click:Connect(function()
                    ChangeColor.Visible = false
                    color = ColorIndicator.BackgroundColor3
                    if props.Callback then
                        pcall(props.Callback, color)
                    end
                end)

                CancelButton.MouseButton1Click:Connect(function()
                    ChangeColor.Visible = false
                    ColorIndicator.BackgroundColor3 = originalColor
                end)

                TextButton.MouseButton1Click:Connect(function()
                    originalColor = ColorButton.BackgroundColor3
                    setDefaultColor(originalColor)
                    ChangeColor.Visible = true
                end)

                local key = props.Title
                subTab.elements[key] = {
                    GetValue = function()
                        return color
                    end,
                    SetValue = function(value)
                        if typeof(value) == "Color3" then
                            color = value
                            ColorButton.BackgroundColor3 = value
                            if props.Callback then
                                pcall(props.Callback, value)
                            end
                        end
                    end
                }

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:Input(props)
                local InputFrame = Instance.new("Frame")
                local UICornerInp = Instance.new("UICorner")
                local NameLabel = Instance.new("TextLabel")
                local InputBox = Instance.new("TextBox")
                local UICornerInputBox = Instance.new("UICorner")

                InputFrame.Parent = subScrollingFrame
                InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                InputFrame.Size = UDim2.new(0, 280, 0, 40)
                InputFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

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
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(0.55, 0, 0.175, 0)
                InputBox.Size = UDim2.new(0, 110, 0, 26)
                InputBox.Font = Enum.Font.GothamBold
                InputBox.Text = props.Default or ""
                InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.TextSize = 14
                InputBox.TextXAlignment = Enum.TextXAlignment.Left

                UICornerInputBox.CornerRadius = UDim.new(0, 4)
                UICornerInputBox.Parent = InputBox

                InputBox.FocusLost:Connect(function(enterPressed)
                    if props.Callback then
                        pcall(props.Callback, InputBox.Text)
                    end
                end)

                local key = props.Title
                subTab.elements[key] = {
                    GetValue = function()
                        return InputBox.Text
                    end,
                    SetValue = function(value)
                        InputBox.Text = value
                        if props.Callback then
                            pcall(props.Callback, value)
                        end
                    end
                }

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            function subTab:DeButton(props)
                local DeButtonFrame = Instance.new("Frame")
                local UICornerDeBtn = Instance.new("UICorner")
                local NameButton = Instance.new("TextLabel")
                local TextButton = Instance.new("TextButton")

                DeButtonFrame.Parent = subScrollingFrame
                DeButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
                table.insert(Leaf.colorElements, {
                    element = DeButtonFrame,
                    property = "BackgroundColor3"
                })
                DeButtonFrame.Size = UDim2.new(0, 280, 0, 40)
                DeButtonFrame.Position = UDim2.new(0.5, -140, 0, subTab.nextPosition)

                UICornerDeBtn.CornerRadius = UDim.new(0, 4)
                UICornerDeBtn.Parent = DeButtonFrame

                NameButton.Parent = DeButtonFrame
                NameButton.BackgroundTransparency = 1
                NameButton.Position = UDim2.new(0.04, 0, 0, 0)
                NameButton.Size = UDim2.new(0.8, 0, 1, 0)
                NameButton.Font = Enum.Font.GothamBold
                NameButton.Text = props.Title
                NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameButton.TextSize = 16
                NameButton.TextXAlignment = Enum.TextXAlignment.Left

                TextButton.Parent = DeButtonFrame
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.Text = ""

                local clickCount = 0
                local runService = game:GetService("RunService")
                TextButton.MouseButton1Click:Connect(function()
                    clickCount = clickCount + 1
                    local currentClick = clickCount
                    DeButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    runService.Heartbeat:Wait()
                    if currentClick == clickCount and props.Callback then
                        pcall(props.Callback)
                    end
                    DeButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
                end)

                subTab.nextPosition = subTab.nextPosition + 45
                subScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, subTab.nextPosition + 10)
            end

            return subTab
        end

        function tab:Toggle(props)
            local ToggleFrame = Instance.new("Frame")
            local UICornerTog = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local ToggleButton = Instance.new("Frame")
            local UICornerToggleBtn = Instance.new("UICorner")
            local UIStrokeToggle = Instance.new("UIStroke")
            local ToggleIndicator = Instance.new("Frame")
            local UICornerInd = Instance.new("UICorner")
            local TextButton = Instance.new("TextButton")

            ToggleFrame.Parent = ScrollingFrame
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleFrame.Size = UDim2.new(0, 280, 0, 40)
            ToggleFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerTog.CornerRadius = UDim.new(0, 4)
            UICornerTog.Parent = ToggleFrame

            NameLabel.Parent = ToggleFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleButton.Position = UDim2.new(0.871, 0, 0.175, 0)
            ToggleButton.Size = UDim2.new(0, 26, 0, 26)

            UICornerToggleBtn.CornerRadius = UDim.new(0, 4)
            UICornerToggleBtn.Parent = ToggleButton

            UIStrokeToggle.Parent = ToggleButton
            UIStrokeToggle.Thickness = 1
            UIStrokeToggle.Color = Color3.fromRGB(80, 80, 80)

            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = ToggleIndicator,
                property = "BackgroundColor3"
            })
            ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
            ToggleIndicator.Size = UDim2.new(1, -4, 1, -4)
            ToggleIndicator.Visible = props.State

            UICornerInd.CornerRadius = UDim.new(0, 2)
            UICornerInd.Parent = ToggleIndicator

            TextButton.Parent = ToggleFrame
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Text = ""

            local key = props.Title
            local toggled = props.State
            tab.elements[key] = {
                GetValue = function()
                    return toggled
                end,
                SetValue = function(value)
                    toggled = value
                    ToggleIndicator.Visible = value
                    if props.Callback then
                        pcall(props.Callback, value)
                    end
                end
            }

            TextButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleIndicator.Visible = toggled
                if props.Callback then
                    pcall(props.Callback, toggled)
                end
            end)

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:Button(props)
            local ButtonFrame = Instance.new("Frame")
            local UICornerBtn = Instance.new("UICorner")
            local NameButton = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")

            ButtonFrame.Parent = ScrollingFrame
            ButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = ButtonFrame,
                property = "BackgroundColor3"
            })
            ButtonFrame.Size = UDim2.new(0, 280, 0, 40)
            ButtonFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerBtn.CornerRadius = UDim.new(0, 4)
            UICornerBtn.Parent = ButtonFrame

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
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                runService.Heartbeat:Wait()
                if currentClick == clickCount and props.Callback then
                    pcall(props.Callback)
                end
                ButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
            end)

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:Slider(props)
            local min = props.Min
            local max = props.Max
            local increment = props.Increment
            local default = props.Default

            local SliderFrame = Instance.new("Frame")
            local UICornerSl = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local SliderLine = Instance.new("Frame")
            local UICornerLine = Instance.new("UICorner")
            local Progress = Instance.new("Frame")
            local UICornerProg = Instance.new("UICorner")
            local SliderButton = Instance.new("TextButton")
            local Snumber = Instance.new("TextLabel")

            SliderFrame.Parent = ScrollingFrame
            SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderFrame.Size = UDim2.new(0, 280, 0, 50)
            SliderFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerSl.CornerRadius = UDim.new(0, 4)
            UICornerSl.Parent = SliderFrame

            NameLabel.Parent = SliderFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            SliderLine.Parent = SliderFrame
            SliderLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderLine.Position = UDim2.new(0.04, 0, 0.6, 0)
            SliderLine.Size = UDim2.new(0, 200, 0, 10)

            UICornerLine.CornerRadius = UDim.new(0, 4)
            UICornerLine.Parent = SliderLine

            Progress.Name = "Progress"
            Progress.Parent = SliderLine
            Progress.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = Progress,
                property = "BackgroundColor3"
            })
            Progress.Size = UDim2.new(0, 0, 1, 0)
            Progress.Position = UDim2.new(0, 0, 0, 0)

            UICornerProg.CornerRadius = UDim.new(0, 4)
            UICornerProg.Parent = Progress

            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderLine
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Text = ""

            Snumber.Name = "Snumber"
            Snumber.Parent = SliderFrame
            Snumber.BackgroundTransparency = 1
            Snumber.Position = UDim2.new(0.768, 0, 0.5, 0)
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
                if props.Callback then
                    pcall(props.Callback, currentValue)
                end
            end

            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
                updateSlider(default)
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                    local relativeX = mouseLocation.X - SliderLine.AbsolutePosition.X
                    local percent = math.clamp(relativeX / SliderLine.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percent
                    updateSlider(value)
                end
            end)

            local key = props.Title
            tab.elements[key] = {
                GetValue = function()
                    return currentValue
                end,
                SetValue = function(value)
                    updateSlider(value)
                end
            }

            updateSlider(default)

            tab.nextPosition = tab.nextPosition + 55
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:Dropdown(props)
            local DropdownFrame = Instance.new("Frame")
            local UICornerDrop = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local DropdownButton = Instance.new("Frame")
            local UICornerDropBtn = Instance.new("UICorner")
            local UIStrokeDrop = Instance.new("UIStroke")
            local Indicator = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")
            local DropdownList = Instance.new("ScrollingFrame")
            local UIListLayout_2 = Instance.new("UIListLayout")

            DropdownFrame.Parent = ScrollingFrame
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropdownFrame.Size = UDim2.new(0, 280, 0, 40)
            DropdownFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerDrop.CornerRadius = UDim.new(0, 4)
            UICornerDrop.Parent = DropdownFrame

            NameLabel.Parent = DropdownFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropdownButton.Position = UDim2.new(0.871, 0, 0.175, 0)
            DropdownButton.Size = UDim2.new(0, 26, 0, 26)

            UICornerDropBtn.CornerRadius = UDim.new(0, 4)
            UICornerDropBtn.Parent = DropdownButton

            UIStrokeDrop.Parent = DropdownButton
            UIStrokeDrop.Thickness = 1
            UIStrokeDrop.Color = Color3.fromRGB(80, 80, 80)

            Indicator.Parent = DropdownButton
            Indicator.BackgroundTransparency = 1
            Indicator.Position = UDim2.new(0, 0, 0, 0)
            Indicator.Size = UDim2.new(1, 0, 1, 0)
            Indicator.Font = Enum.Font.GothamBold
            Indicator.Text = "+"
            Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.TextSize = 18

            TextButton.Parent = DropdownFrame
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Text = ""

            DropdownList.Parent = ScrollingFrame
            DropdownList.Active = true
            DropdownList.BackgroundTransparency = 1
            DropdownList.Size = UDim2.new(0, 280, 0, 0)
            DropdownList.Position = UDim2.new(0.5, -140, 0, tab.nextPosition + 45)
            DropdownList.ScrollBarThickness = 3
            DropdownList.ScrollBarImageColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = DropdownList,
                property = "ScrollBarImageColor3"
            })
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.Visible = false

            UIListLayout_2.Parent = DropdownList
            UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_2.Padding = UDim.new(0, 5)

            local isOpen = false
            local selectedOption = props.Options[1]
            local listHeight = 0

            local function toggleDropdown()
                isOpen = not isOpen
                Indicator.Text = isOpen and "-" or "+"
                DropdownList.Visible = isOpen
                if isOpen then
                    listHeight = 0
                    for i, option in ipairs(props.Options) do
                        listHeight = listHeight + 30 + 5
                    end
                    DropdownList.Size = UDim2.new(0, 280, 0, math.min(listHeight, 150))
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
                else
                    DropdownList.Size = UDim2.new(0, 280, 0, 0)
                end
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 55 + (isOpen and math.min(listHeight, 150) or 0))
            end

            TextButton.MouseButton1Click:Connect(toggleDropdown)

            for i, option in ipairs(props.Options) do
                local OptionButton = Instance.new("TextButton")
                local UICornerOpt = Instance.new("UICorner")

                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 14

                UICornerOpt.CornerRadius = UDim.new(0, 4)
                UICornerOpt.Parent = OptionButton

                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    NameLabel.Text = props.Title .. ": " .. option
                    toggleDropdown()
                    if props.Callback then
                        pcall(props.Callback, option)
                    end
                end)
            end

            local key = props.Title
            tab.elements[key] = {
                GetValue = function()
                    return selectedOption
                end,
                SetValue = function(option)
                    if table.find(props.Options, option) then
                        selectedOption = option
                        NameLabel.Text = props.Title .. ": " .. option
                        if props.Callback then
                            pcall(props.Callback, option)
                        end
                    end
                end
            }

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:ColorPicker(props)
            local ColorPickerFrame = Instance.new("Frame")
            local UICornerCP = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local ColorButton = Instance.new("Frame")
            local UICornerClrBtn = Instance.new("UICorner")
            local UIStrokeClr = Instance.new("UIStroke")
            local TextButton = Instance.new("TextButton")

            ColorPickerFrame.Parent = ScrollingFrame
            ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ColorPickerFrame.Size = UDim2.new(0, 280, 0, 40)
            ColorPickerFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerCP.CornerRadius = UDim.new(0, 4)
            UICornerCP.Parent = ColorPickerFrame

            NameLabel.Parent = ColorPickerFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0.04, 0, 0, 0)
            NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = props.Title
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            ColorButton.Parent = ColorPickerFrame
            ColorButton.BackgroundColor3 = props.Default
            ColorButton.Position = UDim2.new(0.871, 0, 0.175, 0)
            ColorButton.Size = UDim2.new(0, 26, 0, 26)

            UICornerClrBtn.CornerRadius = UDim.new(0, 4)
            UICornerClrBtn.Parent = ColorButton

            UIStrokeClr.Parent = ColorButton
            UIStrokeClr.Thickness = 1
            UIStrokeClr.Color = Color3.fromRGB(80, 80, 80)

            TextButton.Parent = ColorPickerFrame
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Text = ""

            local ChangeColor = Instance.new("Frame")
            local UICornerChClr = Instance.new("UICorner")
            local UIStrokeChClr = Instance.new("UIStroke")
            local ColorSelector = Instance.new("ImageButton")
            local UICornerClrSl = Instance.new("UICorner")
            local ColorIndicator = Instance.new("Frame")
            local UICornerInd = Instance.new("UICorner")
            local UIStrokeInd = Instance.new("UIStroke")
            local HueSlider = Instance.new("ImageButton")
            local UICornerHue = Instance.new("UICorner")
            local HueIndicator = Instance.new("Frame")
            local UICornerHueInd = Instance.new("UICorner")
            local UIStrokeHueInd = Instance.new("UIStroke")
            local ApplyButton = Instance.new("TextButton")
            local CancelButton = Instance.new("TextButton")

            ChangeColor.Name = "ChangeColor"
            ChangeColor.Parent = InnerFrame
            ChangeColor.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ChangeColor.Position = UDim2.new(0.5, -150, 0.5, -100)
            ChangeColor.Size = UDim2.new(0, 300, 0, 200)
            ChangeColor.Visible = false
            ChangeColor.ZIndex = 2

            UICornerChClr.CornerRadius = UDim.new(0, 4)
            UICornerChClr.Parent = ChangeColor

            UIStrokeChClr.Parent = ChangeColor
            UIStrokeChClr.Thickness = 2
            UIStrokeChClr.Color = Color3.fromRGB(80, 80, 80)

            ColorSelector.Name = "ColorSelector"
            ColorSelector.Parent = ChangeColor
            ColorSelector.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            ColorSelector.Position = UDim2.new(0.05, 0, 0.1, 0)
            ColorSelector.Size = UDim2.new(0, 180, 0, 120)
            ColorSelector.ZIndex = 2

            UICornerClrSl.CornerRadius = UDim.new(0, 4)
            UICornerClrSl.Parent = ColorSelector

            ColorIndicator.Name = "ColorIndicator"
            ColorIndicator.Parent = ColorSelector
            ColorIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorIndicator.Position = UDim2.new(0, 0, 0, 0)
            ColorIndicator.Size = UDim2.new(0, 5, 0, 5)
            ColorIndicator.ZIndex = 2

            UICornerInd.CornerRadius = UDim.new(0, 1)
            UICornerInd.Parent = ColorIndicator

            UIStrokeInd.Parent = ColorIndicator
            UIStrokeInd.Thickness = 1
            UIStrokeInd.Color = Color3.fromRGB(0, 0, 0)

            HueSlider.Name = "HueSlider"
            HueSlider.Parent = ChangeColor
            HueSlider.BackgroundTransparency = 1
            HueSlider.Position = UDim2.new(0.7, 0, 0.1, 0)
            HueSlider.Size = UDim2.new(0, 15, 0, 120)
            HueSlider.ZIndex = 2

            UICornerHue.CornerRadius = UDim.new(0, 4)
            UICornerHue.Parent = HueSlider

            HueIndicator.Name = "HueIndicator"
            HueIndicator.Parent = HueSlider
            HueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueIndicator.Position = UDim2.new(-0.5, 0, 0, 0)
            HueIndicator.Size = UDim2.new(2, 0, 0, 2)
            HueIndicator.ZIndex = 2

            UICornerHueInd.CornerRadius = UDim.new(0, 1)
            UICornerHueInd.Parent = HueIndicator

            UIStrokeHueInd.Parent = HueIndicator
            UIStrokeHueInd.Thickness = 1
            UIStrokeHueInd.Color = Color3.fromRGB(0, 0, 0)

            ApplyButton.Parent = ChangeColor
            ApplyButton.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = ApplyButton,
                property = "BackgroundColor3"
            })
            ApplyButton.Position = UDim2.new(0.449, 0, 0.805, 0)
            ApplyButton.Size = UDim2.new(0, 60, 0, 27)
            ApplyButton.Font = Enum.Font.GothamBold
            ApplyButton.Text = "Apply"
            ApplyButton.TextColor3 = Color3.new(1, 1, 1)
            ApplyButton.TextSize = 14
            ApplyButton.ZIndex = 2

            CancelButton.Parent = ChangeColor
            CancelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            CancelButton.Position = UDim2.new(0.449, 0, 0.805, 0)
            CancelButton.Size = UDim2.new(0, 60, 0, 27)
            CancelButton.Font = Enum.Font.GothamBold
            CancelButton.Text = "Cancel"
            CancelButton.TextColor3 = Color3.new(1, 1, 1)
            CancelButton.TextSize = 14
            CancelButton.Position = UDim2.new(0.2, 0, 0.805, 0)
            CancelButton.ZIndex = 2

            local originalColor = props.Default
            local color = props.Default

            local function updateColor()
                local hue = 1 - (HueIndicator.Position.Y.Offset / HueSlider.AbsoluteSize.Y)
                local saturation = ColorIndicator.Position.X.Offset / ColorSelector.AbsoluteSize.X
                local value = 1 - ColorIndicator.Position.Y.Offset / ColorSelector.AbsoluteSize.Y
                color = Color3.fromHSV(hue, saturation, value)
                ColorButton.BackgroundColor3 = color
            end

            local function setDefaultColor(c)
                local h, s, v = c:ToHSV()
                HueIndicator.Position = UDim2.new(-0.5, 0, 1 - h, 0)
                ColorSelector.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                ColorIndicator.Position = UDim2.new(s, 0, 1 - v, 0)
                color = c
                ColorButton.BackgroundColor3 = color
            end

            local draggingHue = false
            local draggingColor = false

            HueSlider.MouseButton1Down:Connect(function()
                draggingHue = true
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativeY = math.clamp(mousePos.Y - HueSlider.AbsolutePosition.Y, 0, HueSlider.AbsoluteSize.Y)
                HueIndicator.Position = UDim2.new(-0.5, 0, relativeY / HueSlider.AbsoluteSize.Y, 0)
                ColorSelector.BackgroundColor3 = Color3.fromHSV(1 - (relativeY / HueSlider.AbsoluteSize.Y), 1, 1)
                updateColor()
            end)

            ColorSelector.MouseButton1Down:Connect(function()
                draggingColor = true
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativeX = math.clamp(mousePos.X - ColorSelector.AbsolutePosition.X, 0, ColorSelector.AbsoluteSize.X)
                local relativeY = math.clamp(mousePos.Y - ColorSelector.AbsolutePosition.Y, 0, ColorSelector.AbsoluteSize.Y)
                ColorIndicator.Position = UDim2.new(relativeX / ColorSelector.AbsoluteSize.X, 0, relativeY / ColorSelector.AbsoluteSize.Y, 0)
                updateColor()
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local relativeY = math.clamp(mousePos.Y - HueSlider.AbsolutePosition.Y, 0, HueSlider.AbsoluteSize.Y)
                    HueIndicator.Position = UDim2.new(-0.5, 0, relativeY / HueSlider.AbsoluteSize.Y, 0)
                    ColorSelector.BackgroundColor3 = Color3.fromHSV(1 - (relativeY / HueSlider.AbsoluteSize.Y), 1, 1)
                    updateColor()
                elseif draggingColor and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local relativeX = math.clamp(mousePos.X - ColorSelector.AbsolutePosition.X, 0, ColorSelector.AbsoluteSize.X)
                    local relativeY = math.clamp(mousePos.Y - ColorSelector.AbsolutePosition.Y, 0, ColorSelector.AbsoluteSize.Y)
                    ColorIndicator.Position = UDim2.new(relativeX / ColorSelector.AbsoluteSize.X, 0, relativeY / ColorSelector.AbsoluteSize.Y, 0)
                    updateColor()
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = false
                    draggingColor = false
                end
            end)

            ApplyButton.MouseButton1Click:Connect(function()
                ChangeColor.Visible = false
                color = ColorIndicator.BackgroundColor3
                if props.Callback then
                    pcall(props.Callback, color)
                end
            end)

            CancelButton.MouseButton1Click:Connect(function()
                ChangeColor.Visible = false
                ColorIndicator.BackgroundColor3 = originalColor
            end)

            TextButton.MouseButton1Click:Connect(function()
                originalColor = ColorButton.BackgroundColor3
                setDefaultColor(originalColor)
                ChangeColor.Visible = true
            end)

            local key = props.Title
            tab.elements[key] = {
                GetValue = function()
                    return color
                end,
                SetValue = function(value)
                    if typeof(value) == "Color3" then
                        color = value
                        ColorButton.BackgroundColor3 = value
                        if props.Callback then
                            pcall(props.Callback, value)
                        end
                    end
                end
            }

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:Input(props)
            local InputFrame = Instance.new("Frame")
            local UICornerInp = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local InputBox = Instance.new("TextBox")
            local UICornerInputBox = Instance.new("UICorner")

            InputFrame.Parent = ScrollingFrame
            InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            InputFrame.Size = UDim2.new(0, 280, 0, 40)
            InputFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

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
            InputBox.BorderSizePixel = 0
            InputBox.Position = UDim2.new(0.55, 0, 0.175, 0)
            InputBox.Size = UDim2.new(0, 110, 0, 26)
            InputBox.Font = Enum.Font.GothamBold
            InputBox.Text = props.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 14
            InputBox.TextXAlignment = Enum.TextXAlignment.Left

            UICornerInputBox.CornerRadius = UDim.new(0, 4)
            UICornerInputBox.Parent = InputBox

            InputBox.FocusLost:Connect(function(enterPressed)
                if props.Callback then
                    pcall(props.Callback, InputBox.Text)
                end
            end)

            local key = props.Title
            tab.elements[key] = {
                GetValue = function()
                    return InputBox.Text
                end,
                SetValue = function(value)
                    InputBox.Text = value
                    if props.Callback then
                        pcall(props.Callback, value)
                    end
                end
            }

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        function tab:DeButton(props)
            local DeButtonFrame = Instance.new("Frame")
            local UICornerDeBtn = Instance.new("UICorner")
            local NameButton = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")

            DeButtonFrame.Parent = ScrollingFrame
            DeButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
            table.insert(Leaf.colorElements, {
                element = DeButtonFrame,
                property = "BackgroundColor3"
            })
            DeButtonFrame.Size = UDim2.new(0, 280, 0, 40)
            DeButtonFrame.Position = UDim2.new(0.5, -140, 0, tab.nextPosition)

            UICornerDeBtn.CornerRadius = UDim.new(0, 4)
            UICornerDeBtn.Parent = DeButtonFrame

            NameButton.Parent = DeButtonFrame
            NameButton.BackgroundTransparency = 1
            NameButton.Position = UDim2.new(0.04, 0, 0, 0)
            NameButton.Size = UDim2.new(0.8, 0, 1, 0)
            NameButton.Font = Enum.Font.GothamBold
            NameButton.Text = props.Title
            NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameButton.TextSize = 16
            NameButton.TextXAlignment = Enum.TextXAlignment.Left

            TextButton.Parent = DeButtonFrame
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Text = ""

            local clickCount = 0
            local runService = game:GetService("RunService")
            TextButton.MouseButton1Click:Connect(function()
                clickCount = clickCount + 1
                local currentClick = clickCount
                DeButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                runService.Heartbeat:Wait()
                if currentClick == clickCount and props.Callback then
                    pcall(props.Callback)
                end
                DeButtonFrame.BackgroundColor3 = Leaf.MenuColorValue.Value
            end)

            tab.nextPosition = tab.nextPosition + 45
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tab.nextPosition + 10)
        end

        TabButton.MouseButton1Click:Connect(function()
            setActiveTab(tab)
        end)

        table.insert(allTabs, tab)

        if configTab.Opened then
            if activeTab == nil then
                setActiveTab(tab)
            end
        end

        updateTabPositions()

        return tab
    end

    local draggingMain = false
    local dragStartMain
    local startPosMain

    OuterFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            dragStartMain = input.Position
            startPosMain = OuterFrame.Position
        end
    end)

    OuterFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartMain
            OuterFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
        end
    end)

    local miniMenuDragging, miniMenuDragStart, miniMenuStartPos

    Bmenu.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniMenuDragging = true
            miniMenuDragStart = input.Position
            miniMenuStartPos = MiniMenuFrame.Position
        end
    end)

    Bmenu.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniMenuDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if miniMenuDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - miniMenuDragStart
            MiniMenuFrame.Position = UDim2.new(miniMenuStartPos.X.Scale, miniMenuStartPos.X.Offset + delta.X, miniMenuStartPos.Y.Scale, miniMenuStartPos.Y.Offset + delta.Y)
        end
    end)

    Bmenu.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    return window
end

return Leaf
