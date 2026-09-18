-- Сервисы
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Создание UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PotatoModGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Переменные для базовых размеров (чтобы масштабирование работало стабильно)
local currentScale = 1.0

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
SettingsButton.Position = UDim2.new(0, 15, 0, 50) -- Отступ под первой кнопкой
SettingsButton.Size = UDim2.new(0, 35, 0, 35)
SettingsButton.Font = Enum.Font.SourceSansBold
SettingsButton.Text = "⚙️"
SettingsButton.TextSize = 18

local SetCorner = Instance.new("UICorner")
SetCorner.CornerRadius = UDim.new(0, 6)
SetCorner.Parent = SettingsButton

-- Панель настроек
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ScreenGui
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsFrame.Position = UDim2.new(0, 55, 0, 50)
SettingsFrame.Size = UDim2.new(0, 220, 0, 160)
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
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Настройки Potato Mod"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScaleLabel = Instance.new("TextLabel")
ScaleLabel.Parent = SettingsFrame
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Position = UDim2.new(0, 10, 0, 40)
ScaleLabel.Size = UDim2.new(1, -20, 0, 25)
ScaleLabel.Font = Enum.Font.SourceSans
ScaleLabel.Text = "Размер и отступы меню:"
ScaleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ScaleLabel.TextSize = 13
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Функция обновления размеров, отступов и скругления краев
local function UpdateScale(newScale)
    currentScale = math.clamp(newScale, 0.7, 1.5) -- Ограничение от чрезмерного уменьшения/увеличения
    
    -- Меняем размеры кнопок и скругления углов (края)
    ToggleButton.Size = UDim2.new(0, math.floor(95 * currentScale), 0, math.floor(30 * currentScale))
    ToggleButton.TextSize = math.floor(14 * currentScale)
    UICorner.CornerRadius = UDim.new(0, math.floor(6 * currentScale))
    
    SettingsButton.Size = UDim2.new(0, math.floor(35 * currentScale), 0, math.floor(35 * currentScale))
    SettingsButton.TextSize = math.floor(18 * currentScale)
    SetCorner.CornerRadius = UDim.new(0, math.floor(6 * currentScale))
    
    -- Автоматически настраиваем отступы между кнопками, чтобы они не слипались
    local spacing = math.floor(10 * currentScale)
    SettingsButton.Position = UDim2.new(0, 15, 0, 15 + ToggleButton.Size.Y.Offset + spacing)
end

local function CreateMiniButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = SettingsFrame
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Size = UDim2.new(0, 95, 0, 30)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateMiniButton("Уменьшить", 70, function()
    UpdateScale(currentScale - 0.15)
end)

CreateMiniButton("Увеличить", 110, function()
    UpdateScale(currentScale + 0.15)
end)

-- Переключение видимости настроек
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
