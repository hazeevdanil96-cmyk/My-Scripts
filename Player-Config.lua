-- LocalScript, поместите в StarterGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerConfigGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главный контейнер (теперь на нём DragDetector)
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 260, 0, 130)
container.Position = UDim2.new(0, 10, 0, 10)
container.BackgroundTransparency = 1
container.Parent = screenGui

-- ===== ПЕРЕМЕЩЕНИЕ ПАНЕЛИ (DragDetector на всём контейнере) =====
local dragDetector = Instance.new("DragDetector")
dragDetector.Parent = container
dragDetector.DragStyle = Enum.DragDetectorDragStyle.Translate
dragDetector.Enabled = true

-- Отладка: сообщение в консоль, когда начинаем тащить
dragDetector.DragStart:Connect(function(gestureData)
	print("Перетаскивание началось!")
end)

local dragStartPos = nil

dragDetector.DragStart:Connect(function(gestureData)
	dragStartPos = container.AbsolutePosition
end)

dragDetector.DragContinue:Connect(function(gestureData)
	if not dragStartPos then return end
	local delta = gestureData.Delta -- смещение с прошлого кадра
	local newPos = dragStartPos + delta

	local screenSize = screenGui.AbsoluteSize
	local containerSize = container.AbsoluteSize
	newPos = Vector2.new(
		math.clamp(newPos.X, 0, screenSize.X - containerSize.X),
		math.clamp(newPos.Y, 0, screenSize.Y - containerSize.Y)
	)

	container.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
	dragStartPos = newPos
end)

dragDetector.DragEnd:Connect(function(gestureData)
	dragStartPos = nil
end)

-- ===== ВЕРХНЯЯ ПАНЕЛЬ =====
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
topBar.BorderSizePixel = 0
topBar.Parent = container

-- Текст "Player Config" (не перехватывает ввод)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.7, -5, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Player Config"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Active = false           -- чтобы не мешал перетаскиванию
titleLabel.Parent = topBar

-- Кнопка свёртки/развёртки (остаётся независимой)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.3, -5, 1, 0)
toggleButton.Position = UDim2.new(0.7, 5, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "_"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Parent = topBar

-- ===== ПАНЕЛЬ НАСТРОЕК =====
local configPanel = Instance.new("Frame")
configPanel.Size = UDim2.new(1, 0, 0, 100)
configPanel.Position = UDim2.new(0, 0, 0, 30)
configPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
configPanel.BorderSizePixel = 0
configPanel.Visible = true
configPanel.Parent = container

-- Строка Speed
local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, 0, 0, 40)
speedRow.BackgroundTransparency = 1
speedRow.Parent = configPanel

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Right
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16
speedLabel.Active = false
speedLabel.Parent = speedRow

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -70, 1, 0)
speedBox.Position = UDim2.new(0, 65, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedBox.BorderSizePixel = 0
speedBox.Text = "16"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 16
speedBox.PlaceholderText = "16"
speedBox.Parent = speedRow

-- Строка Jump
local jumpRow = Instance.new("Frame")
jumpRow.Size = UDim2.new(1, 0, 0, 40)
jumpRow.Position = UDim2.new(0, 0, 0, 40)
jumpRow.BackgroundTransparency = 1
jumpRow.Parent = configPanel

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 60, 1, 0)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump:"
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.TextXAlignment = Enum.TextXAlignment.Right
jumpLabel.Font = Enum.Font.SourceSans
jumpLabel.TextSize = 16
jumpLabel.Active = false
jumpLabel.Parent = jumpRow

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(1, -70, 1, 0)
jumpBox.Position = UDim2.new(0, 65, 0, 0)
jumpBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpBox.BorderSizePixel = 0
jumpBox.Text = "50"
jumpBox.TextColor3 = Color3.new(1, 1, 1)
jumpBox.Font = Enum.Font.SourceSans
jumpBox.TextSize = 16
jumpBox.PlaceholderText = "50"
jumpBox.Parent = jumpRow

-- ===== ЛОГИКА СКОРОСТИ И ПРЫЖКА =====
local currentSpeed = 16
local currentJump = 50
local configVisible = true

local function applySpeedToCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.WalkSpeed = currentSpeed
	end
end

local function applyJumpToCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.JumpPower = currentJump
	end
end

if player.Character then
	applySpeedToCharacter(player.Character)
	applyJumpToCharacter(player.Character)
end

player.CharacterAdded:Connect(function(character)
	applySpeedToCharacter(character)
	applyJumpToCharacter(character)
end)

speedBox.FocusLost:Connect(function(enterPressed)
	local value = tonumber(speedBox.Text)
	if value then
		currentSpeed = value
		speedBox.Text = tostring(value)
		if player.Character then
			applySpeedToCharacter(player.Character)
		end
	else
		speedBox.Text = tostring(currentSpeed)
	end
end)

jumpBox.FocusLost:Connect(function(enterPressed)
	local value = tonumber(jumpBox.Text)
	if value then
		currentJump = value
		jumpBox.Text = tostring(value)
		if player.Character then
			applyJumpToCharacter(player.Character)
		end
	else
		jumpBox.Text = tostring(currentJump)
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	configVisible = not configVisible
	configPanel.Visible = configVisible
	toggleButton.Text = configVisible and "_" or "□"
end)
