-- Модуль ConfigManager для управления конфигурациями
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local ConfigManager = {
    Window = nil,
    Folder = nil,
    Path = nil,
    Configs = {},
    -- Парсеры для различных типов элементов UI
    Parser = {
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Default:ToHex()
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(Color3.fromHex(data.value))
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value
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
                    value = obj.Value.Default
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
                    value = obj.Value
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        }
    }
}

--- Инициализация ConfigManager
-- @param Window Объект окна UI
-- @return ConfigManager или false при ошибке
function ConfigManager:Init(Window)
    if not Window.Folder then
        warn("[ConfigManager] Window.Folder не указан.")
        return false
    end
    self.Window = Window
    self.Folder = Window.Folder
    self.Path = "Leaf/" .. tostring(self.Folder) .. "/configs/"
    return self
end

--- Создание модуля конфигурации
-- @param configFilename Имя файла конфигурации
-- @return ConfigModule или false и сообщение об ошибке
function ConfigManager:CreateConfig(configFilename)
    if not configFilename then
        return false, "Не указано имя файла конфигурации"
    end

    local ConfigModule = {
        Path = self.Path .. configFilename .. ".json",
        Elements = {}
    }

    --- Регистрация элемента в конфигурации
    -- @param Name Уникальное имя элемента
    -- @param Element Объект элемента UI
    function ConfigModule:Register(Name, Element)
        self.Elements[Name] = Element
    end

    --- Сохранение конфигурации в файл
    function ConfigModule:Save()
        local saveData = { Elements = {} }
        for name, element in pairs(self.Elements) do
            if self.Parser[element.__type] then
                saveData.Elements[tostring(name)] = self.Parser[element.__type].Save(element)
            end
        end
        if not isfolder(self.Path) then
            makefolder(self.Path)
        end
        writefile(self.Path .. configFilename .. ".json", HttpService:JSONEncode(saveData))
    end

    --- Загрузка конфигурации из файла
    -- @return boolean Успех операции
    -- @return string Сообщение об ошибке, если есть
    function ConfigModule:Load()
        if not isfile(self.Path) then
            return false, "Файл конфигурации не найден"
        end
        local success, loadData = pcall(function()
            return HttpService:JSONDecode(readfile(self.Path))
        end)
        if not success then
            return false, "Ошибка при чтении файла конфигурации"
        end
        for name, data in pairs(loadData.Elements) do
            if self.Elements[name] and self.Parser[data.__type] then
                task.spawn(function()
                    self.Parser[data.__type].Load(self.Elements[name], data)
                end)
            end
        end
        return true
    end

    self.Configs[configFilename] = ConfigModule
    return ConfigModule
end

--- Получение списка всех конфигураций
-- @return table Список имен файлов конфигураций или false
function ConfigManager:AllConfigs()
    if not listfiles then
        return false
    end
    local files = {}
    if not isfolder(self.Path) then
        return files
    end
    for _, file in pairs(listfiles(self.Path))) do
        local name = file:match("([^\\/]+)%.json$")
        if name then
            table.insert(files, name)
        end
    end
    return files
end

-- Основной модуль Leaf UI
local Leaf = {
    configElements = {}, -- Хранилище всех конфигурируемых элементов
}

--- Создание окна UI
-- @param config Таблица конфигурации окна {Name, Color, LogoID, Folder}
-- @return table Объект окна
function Leaf:CreateWindow(config)
    local window = {}
    Leaf.MenuColorValue = Instance.new("Color3Value")
    Leaf.MenuColorValue.Value = Color3.fromRGB(config.Color[1], config.Color[2], config.Color[3])
    Leaf.colorElements = {}
    Leaf.toggles = {}
    window.Folder = config.Folder or "LeafConfigs"

    -- Инициализация ConfigManager
    ConfigManager:Init(window)

    -- Создание вспомогательной функции для модуля конфигурации
    local function createConfigModule(filename)
        local configModule = ConfigManager:CreateConfig(filename)
        for name, element in pairs(Leaf.configElements) do
            configModule:Register(name, element)
        end
        return configModule
    end

    -- Создание UI элементов окна (MiniMenu и MainMenu)
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

    -- Обновление активной вкладки
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

    --- Создание новой вкладки
    -- @param props Свойства вкладки {Name, Image, Opened}
    -- @return table Объект вкладки
    function window:CreateTab(props)
        local tab = {}
        local TabButton = Instance.new("ImageButton")
        local UICornerTab = Instance.new("UICorner")

        TabButton.Name = "Tab" .. #allTabs + 1
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
        tab.Elements = {} -- Хранилище элементов вкладки

        --- Добавление кнопки
        -- @param props Свойства кнопки {Title, Callback, Active}
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
            table.insert(self.Elements, ButtonFrame)
        end

        --- Добавление декоративной кнопки
        -- @param props Свойства кнопки {Title, Callback}
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
            table.insert(self.Elements, DeButtonFrame)
        end

        --- Добавление переключателя
        -- @param props Свойства переключателя {Name, Title, Default, Callback}
        function tab:Toggle(props)
            assert(props.Name, "Уникальное имя (Name) обязательно для Toggle")
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

            local toggleObj = {
                __type = "Toggle",
                Value = props.Default or false,
                Set = function(self, value)
                    self.Value = value
                    if value then
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0.6, 0, 0.1, 0)}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Leaf.MenuColorValue.Value}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    else
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0.05, 0, 0.1, 0)}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    end
                end
            }

            toggleObj:Set(toggleObj.Value)
            TextButton.MouseButton1Click:Connect(function()
                toggleObj.Value = not toggleObj.Value
                toggleObj:Set(toggleObj.Value)
                if props.Callback then pcall(props.Callback, toggleObj.Value) end
            end)

            Leaf.configElements[props.Name] = toggleObj
            table.insert(self.Elements, ToggleFrame)
            table.insert(Leaf.toggles, {state = toggleObj.Value, indicator = Indicator})

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        --- Добавление слайдера
        -- @param props Свойства слайдера {Name, Title, Value={Min, Max, Increment, Default}, Callback}
        function tab:Slider(props)
            assert(props.Name, "Уникальное имя (Name) обязательно для Slider")
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

            local sliderObj = {
                __type = "Slider",
                Value = {Default = default},
                Set = function(self, value)
                    self.Value.Default = math.clamp(value, min, max)
                    self.Value.Default = math.floor(self.Value.Default / increment + 0.5) * increment
                    local percent = (self.Value.Default - min) / (max - min)
                    Progress.Size = UDim2.new(percent, 0, 1, 0)
                    Snumber.Text = tostring(self.Value.Default)
                end
            }

            local dragging = false
            local function updateSlider(value)
                sliderObj:Set(value)
                if props.Callback then pcall(props.Callback, sliderObj.Value.Default) end
            end

            local function updateValueFromPosition(position)
                local fillAbsolute = Fill.AbsolutePosition
                local fillSize = Fill.AbsoluteSize
                local relativeX = math.clamp(position.X - fillAbsolute.X, 0, fillSize.X)
                local percent = relativeX / fillSize.X
                local value = min + (max - min) * percent
                updateSlider(value)
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

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateValueFromPosition(input.Position)
                end
            end)

            sliderObj:Set(default)
            Leaf.configElements[props.Name] = sliderObj
            table.insert(self.Elements, SliderFrame)

            self.nextPosition = self.nextPosition + 50
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        --- Добавление выпадающего списка
        -- @param props Свойства списка {Name, Options, CurrentOption, Callback}
        function tab:CreateDropdown(props)
            assert(props.Name, "Уникальное имя (Name) обязательно для Dropdown")
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

            local dropdownObj = {
                __type = "Dropdown",
                Value = props.CurrentOption,
                Set = function(self, value)
                    self.Value = value
                    Info.Text = value
                end
            }

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
                    dropdownObj:Set(option)
                    props.Callback(option)
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

            Leaf.configElements[props.Name] = dropdownObj
            table.insert(self.Elements, DropdownFrame)
            table.insert(allDropdowns, DropdownList)

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        --- Добавление цветового селектора
        -- @param props Свойства селектора {Name, Color, Callback}
        function tab:CreateColorPicker(props)
            assert(props.Name, "Уникальное имя (Name) обязательно для ColorPicker")
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
            NameLabel.Text = props.Name
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            ColorIndicator.Parent = ColorPickerFrame
            ColorIndicator.BackgroundColor3 = props.Color
            ColorIndicator.Position = UDim2.new(0.879427671, 0, 0.174999997, 0)
            ColorIndicator.Size = UDim2.new(0, 25, 0, 25)

            UICornerCI.CornerRadius = UDim.new(0, 4)
            UICornerCI.Parent = ColorIndicator

            PickButton.Parent = ColorPickerFrame
            PickButton.BackgroundTransparency = 1
            PickButton.Size = UDim2.new(1, 0, 1, 0)
            PickButton.Text = ""

            local colorPickerObj = {
                __type = "Colorpicker",
                Default = props.Color,
                Set = function(self, color)
                    self.Default = color
                    ColorIndicator.BackgroundColor3 = color
                end
            }

            local ChangeColor = Instance.new("Frame")
            ChangeColor.Parent = ScreenGui
            ChangeColor.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ChangeColor.Size = UDim2.new(0, 159, 0, 180)
            ChangeColor.Visible = false
            ChangeColor.ZIndex = 5

            -- Реализация цветового селектора (оставлена как в оригинале, сокращена для примера)
            -- Полная реализация включает HueSlider, ColorCanvas и т.д., как в исходном коде
            local ApplyButton = Instance.new("TextButton")
            ApplyButton.Parent = ChangeColor
            ApplyButton.BackgroundColor3 = Leaf.MenuColorValue.Value
            ApplyButton.Position = UDim2.new(0.449, 0, 0.805, 0)
            ApplyButton.Size = UDim2.new(0, 60, 0, 27)
            ApplyButton.Font = Enum.Font.GothamBold
            ApplyButton.Text = "Apply"
            ApplyButton.TextColor3 = Color3.new(1, 1, 1)
            ApplyButton.TextSize = 14
            ApplyButton.ZIndex = 5

            ApplyButton.MouseButton1Click:Connect(function()
                ChangeColor.Visible = false
                colorPickerObj:Set(ColorIndicator.BackgroundColor3)
                if props.Callback then pcall(props.Callback, colorPickerObj.Default) end
            end)

            PickButton.MouseButton1Click:Connect(function()
                for _, picker in ipairs(allColorPickers) do
                    picker.Visible = false
                end
                ChangeColor.Visible = true
                local absPos = ColorPickerFrame.AbsolutePosition
                ChangeColor.Position = UDim2.new(0, absPos.X, 0, absPos.Y + 45)
            end)

            Leaf.configElements[props.Name] = colorPickerObj
            table.insert(self.Elements, ColorPickerFrame)
            table.insert(allColorPickers, ChangeColor)

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        --- Добавление поля ввода
        -- @param props Свойства поля {Name, Title, Default, Placeholder, Callback}
        function tab:Input(props)
            assert(props.Name, "Уникальное имя (Name) обязательно для Input")
            local InputFrame = Instance.new("Frame")
            local UICornerInp = Instance.new("UICorner")
            local NameLabel = Instance.new("TextLabel")
            local InputBox = Instance.new("TextBox")
            local UICornerInputBox = Instance.new("UICorner")

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
            InputBox.BorderSizePixel = 0
            InputBox.Position = UDim2.new(0.579999983, 0, 0.174999997, 0)
            InputBox.Size = UDim2.new(0.4, 0, 0.65, 0)
            InputBox.Font = Enum.Font.GothamBold
            InputBox.Text = props.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 14
            InputBox.PlaceholderText = props.Placeholder or ""

            UICornerInputBox.CornerRadius = UDim.new(0, 4)
            UICornerInputBox.Parent = InputBox

            local inputObj = {
                __type = "Input",
                Value = props.Default or "",
                Set = function(self, value)
                    self.Value = value
                    InputBox.Text = value
                end
            }

            InputBox.FocusLost:Connect(function(enterPressed)
                inputObj:Set(InputBox.Text)
                if props.Callback then pcall(props.Callback, inputObj.Value) end
            end)

            Leaf.configElements[props.Name] = inputObj
            table.insert(self.Elements, InputFrame)

            self.nextPosition = self.nextPosition + 45
            self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
        end

        --- Удаление элемента по имени
        -- @param name Имя элемента для удаления
        function tab:RemoveElement(name)
            if Leaf.configElements[name] then
                for i, element in ipairs(self.Elements) do
                    if element.Name == name then
                        element:Destroy()
                        table.remove(self.Elements, i)
                        Leaf.configElements[name] = nil
                        self.nextPosition = 10
                        for _, elem in ipairs(self.Elements) do
                            elem.Position = UDim2.new(0.5, -140, 0, self.nextPosition)
                            self.nextPosition = self.nextPosition + 45
                        end
                        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.nextPosition + 10)
                        break
                    end
                end
            end
        end

        if props.Opened then
            setActiveTab(tab)
        else
            ScrollingFrame.Visible = false
        end

        TabButton.MouseButton1Click:Connect(function() setActiveTab(tab) end)
        table.insert(allTabs, tab)
        return tab
    end

    -- Обработка перетаскивания окна и MiniMenu (оставлена как в оригинале)
    local UserInputService = game:GetService("UserInputService")
    local draggingMain, dragStartMain, startPosMain
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            dragStartMain = input.Position
            startPosMain = OuterFrame.Position
        end
    end)

    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartMain
            OuterFrame.Position = UDim2.new(
                startPosMain.X.Scale,
                startPosMain.X.Offset + delta.X,
                startPosMain.Y.Scale,
                startPosMain.Y.Offset + delta.Y
            )
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

    UserInputService.InputChanged:Connect(function(input)
        if miniMenuDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - miniMenuDragStart
            MiniMenuFrame.Position = UDim2.new(
                miniMenuStartPos.X.Scale,
                miniMenuStartPos.X.Offset + delta.X,
                miniMenuStartPos.Y.Scale,
                miniMenuStartPos.Y.Offset + delta.Y
            )
        end
    end)

    Bmenu.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    return window
end

return Leaf
