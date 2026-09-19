-- Сервисы
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Создание UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PotatoModGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local currentScale = 1.0
local currentLang = "EN" -- Язык по умолчанию — английский
local limitRemoved = false -- Статус снятия лимитов

-- Кнопка статуса "pmod: off"
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "PModToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.Size = UDim2.new(0, 95, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "pmod: off"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.TextSize = 14

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton

-- Кнопка шестеренки (Настройки)
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = ScreenGui
SettingsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsButton.Position = UDim2.new(0, 15, 0, 55)
SettingsButton.Size = UDim2.new(0, 35, 0, 35)
SettingsButton.Font = Enum.Font.SourceSansBold
SettingsButton.Text = "⚙️"
SettingsButton.TextSize = 18

local SetCorner = Instance.new("UICorner")
SetCorner.CornerRadius = UDim.new(0, 6)
SetCorner.Parent = SettingsButton

-- Панель настроек (увеличена под новые элементы)
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ScreenGui
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsFrame.Position = UDim2.new(0, 55, 0, 55)
SettingsFrame.Size = UDim2.new(0, 230, 0, 245)
SettingsFrame.Visible = false
SettingsFrame.Active = true
SettingsFrame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = SettingsFrame

-- Заголовок панели настроек
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = SettingsFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.Size = UDim2.new(1, -20, 0, 25)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Potato Mod Settings"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Выбор языка в настройках
local LangLabel = Instance.new("TextLabel")
LangLabel.Parent = SettingsFrame
LangLabel.BackgroundTransparency = 1
LangLabel.Position = UDim2.new(0, 10, 0, 30)
LangLabel.Size = UDim2.new(1, -20, 0, 20)
LangLabel.Font = Enum.Font.SourceSans
LangLabel.Text = "Language: EN"
LangLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LangLabel.TextSize = 12
LangLabel.TextXAlignment = Enum.TextXAlignment.Left

local LangButton = Instance.new("TextButton")
LangButton.Parent = SettingsFrame
LangButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LangButton.Position = UDim2.new(0, 10, 0, 52)
LangButton.Size = UDim2.new(0, 210, 0, 25)
LangButton.Font = Enum.Font.SourceSansBold
LangButton.Text = "Switch Language: English"
LangButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LangButton.TextSize = 12

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 4)
LangCorner.Parent = LangButton

-- Текст описания для масштаба
local ScaleDescLabel = Instance.new("TextLabel")
ScaleDescLabel.Parent = SettingsFrame
ScaleDescLabel.BackgroundTransparency = 1
ScaleDescLabel.Position = UDim2.new(0, 10, 0, 85)
ScaleDescLabel.Size = UDim2.new(1, -20, 0, 20)
ScaleDescLabel.Font = Enum.Font.SourceSans
ScaleDescLabel.Text = "UI Scale:"
ScaleDescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ScaleDescLabel.TextSize = 12
ScaleDescLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка уменьшения (-)
local MinusButton = Instance.new("TextButton")
MinusButton.Parent = SettingsFrame
MinusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusButton.Position = UDim2.new(0, 10, 0, 110)
MinusButton.Size = UDim2.new(0, 50, 0, 30)
MinusButton.Font = Enum.Font.SourceSansBold
MinusButton.Text = "-"
MinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusButton.TextSize = 16

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 4)
MinusCorner.Parent = MinusButton

-- Отображение текущего размера
local ScaleValueLabel = Instance.new("TextLabel")
ScaleValueLabel.Parent = SettingsFrame
ScaleValueLabel.BackgroundTransparency = 1
ScaleValueLabel.Position = UDim2.new(0, 65, 0, 110)
ScaleValueLabel.Size = UDim2.new(0, 100, 0, 30)
ScaleValueLabel.Font = Enum.Font.SourceSansBold
ScaleValueLabel.Text = "1.0x"
ScaleValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ScaleValueLabel.TextSize = 14
ScaleValueLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Кнопка увеличения (+)
local PlusButton = Instance.new("TextButton")
PlusButton.Parent = SettingsFrame
PlusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusButton.Position = UDim2.new(0, 170, 0, 110)
PlusButton.Size = UDim2.new(0, 50, 0, 30)
PlusButton.Font = Enum.Font.SourceSansBold
PlusButton.Text = "+"
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.TextSize = 16

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 4)
PlusCorner.Parent = PlusButton

-- Чекбокс для снятия лимитов размера
local LimitButton = Instance.new("TextButton")
LimitButton.Parent = SettingsFrame
LimitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LimitButton.Position = UDim2.new(0, 10, 0, 150)
LimitButton.Size = UDim2.new(0, 210, 0, 25)
LimitButton.Font = Enum.Font.SourceSansBold
LimitButton.Text = "Remove Scale Limit: [ ]"
LimitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LimitButton.TextSize = 12

local LimitCorner = Instance.new("UICorner")
LimitCorner.CornerRadius = UDim.new(0, 4)
LimitCorner.Parent = LimitButton

-- Переключатель FPS (Show FPS)
local FpsButton = Instance.new("TextButton")
FpsButton.Parent = SettingsFrame
FpsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FpsButton.Position = UDim2.new(0, 10, 0, 185)
FpsButton.Size = UDim2.new(0, 210, 0, 25)
FpsButton.Font = Enum.Font.SourceSansBold
FpsButton.Text = "Show FPS: Off"
FpsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsButton.TextSize = 12

local FpsCorner = Instance.new("UICorner")
FpsCorner.CornerRadius = UDim.new(0, 4)
FpsCorner.Parent = FpsButton

-- Лейбл для вывода FPS на экран
local FpsDisplay = Instance.new("TextLabel")
FpsDisplay.Parent = ScreenGui
FpsDisplay.BackgroundTransparency = 1
FpsDisplay.Position = UDim2.new(0, 120, 0, 15)
FpsDisplay.Size = UDim2.new(0, 100, 0, 30)
FpsDisplay.Font = Enum.Font.SourceSansBold
FpsDisplay.Text = ""
FpsDisplay.TextColor3 = Color3.fromRGB(100, 255, 100)
FpsDisplay.TextSize = 16
FpsDisplay.TextXAlignment = Enum.TextXAlignment.Left
FpsDisplay.Visible = false

-- Логика обновления масштаба с учетом лимитов
local function UpdateScale(newScale)
    local minLimit = limitRemoved and 0.25 or 0.7
    local maxLimit = limitRemoved and 3.0 or 1.5
    
    currentScale = math.clamp(newScale, minLimit, maxLimit)
    
    ToggleButton.Size = UDim2.new(0, math.floor(95 * currentScale), 0, math.floor(30 * currentScale))
    ToggleButton.TextSize = math.floor(14 * currentScale)
    UICorner.CornerRadius = UDim.new(0, math.floor(6 * currentScale))
    
    SettingsButton.Size = UDim2.new(0, math.floor(35 * currentScale), 0, math.floor(35 * currentScale))
    SettingsButton.TextSize = math.floor(18 * currentScale)
    SetCorner.CornerRadius = UDim.new(0, math.floor(6 * currentScale))
    
    local spacing = math.floor(10 * currentScale)
    SettingsButton.Position = UDim2.new(0, 15, 0, 15 + ToggleButton.Size.Y.Offset + spacing)
    
    ScaleValueLabel.Text = string.format("%.2fx", currentScale)
end

MinusButton.MouseButton1Click:Connect(function()
    UpdateScale(currentScale - 0.1)
end)

PlusButton.MouseButton1Click:Connect(function()
    UpdateScale(currentScale + 0.1)
end)

-- Переключение чекбокса лимитов
LimitButton.MouseButton1Click:Connect(function()
    limitRemoved = not limitRemoved
    if currentLang == "EN" then
        LimitButton.Text = "Remove Scale Limit: " .. (limitRemoved and "[X]" or "[ ]")
    else
        LimitButton.Text = "Снять лимит размера: " .. (limitRemoved and "[X]" or "[ ]")
    end
    UpdateScale(currentScale) -- пересчет с новыми границами
end)

-- Логика FPS счетчика
local fpsEnabled = false
FpsButton.MouseButton1Click:Connect(function()
    fpsEnabled = not fpsEnabled
    FpsDisplay.Visible = fpsEnabled
    if currentLang == "EN" then
        FpsButton.Text = "Show FPS: " .. (fpsEnabled and "On" or "Off")
    else
        FpsButton.Text = "Показать FPS: " .. (fpsEnabled and "Вкл" or "Выкл")
    end
end)

local lastUpdate = 0
local frameCount = 0
RunService.RenderStepped:Connect(function(dt)
    if fpsEnabled then
        frameCount = frameCount + 1
        lastUpdate = lastUpdate + dt
        if lastUpdate >= 0.5 then
            local fps = math.floor(frameCount / lastUpdate)
            FpsDisplay.Text = "FPS: " .. fps
            frameCount = 0
            lastUpdate = 0
        end
    end
end)

-- Переключение языков
LangButton.MouseButton1Click:Connect(function()
    if currentLang == "EN" then
        currentLang = "RU"
        LangLabel.Text = "Язык: RU"
        LangButton.Text = "Сменить язык: Русский"
        TitleLabel.Text = "Настройки Potato Mod"
        ScaleDescLabel.Text = "Масштаб:"
        LimitButton.Text = "Снять лимит размера: " .. (limitRemoved and "[X]" or "[ ]")
        FpsButton.Text = "Показать FPS: " .. (fpsEnabled and "Вкл" or "Выкл")
    else
        currentLang = "EN"
        LangLabel.Text = "Language: EN"
        LangButton.Text = "Switch Language: English"
        TitleLabel.Text = "Potato Mod Settings"
        ScaleDescLabel.Text = "UI Scale:"
        LimitButton.Text = "Remove Scale Limit: " .. (limitRemoved and "[X]" or "[ ]")
        FpsButton.Text = "Show FPS: " .. (fpsEnabled and "On" or "Off")
    end
end)

-- Открытие/закрытие настроек
SettingsButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
end)

-- Логика Potato Mod
local potatoEnabled = false
local originalMaterials = {}
local originalTransparencies = {}

local function TogglePotatoMode(state)
    potatoEnabled = state
    
    if potatoEnabled then
        ToggleButton.Text = "pmod: on"
        ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        Lighting.GlobalShadows = false
        
        originalMaterials = {}
        originalTransparencies = {}
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                originalMaterials[obj] = obj.Material
                obj.Material = Enum.Material.Plastic
                obj.CastShadow = false
            elseif obj:IsA("Texture") or obj:IsA("Decal") then
                originalTransparencies[obj] = obj.Transparency
                obj.Transparency = 0.8
            end
        end
    else
        ToggleButton.Text = "pmod: off"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        Lighting.GlobalShadows = true
        
        for obj, mat in pairs(originalMaterials) do
            if obj and obj.Parent then
                obj.Material = mat
                obj.CastShadow = true
            end
        end
        
        for obj, trans in pairs(originalTransparencies) do
            if obj and obj.Parent then
                obj.Transparency = trans
            end
        end
        
        originalMaterials = {}
        originalTransparencies = {}
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    TogglePotatoMode(not potatoEnabled)
end)
