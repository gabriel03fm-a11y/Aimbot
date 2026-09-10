-- Interface circular de depuração
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevAimDebugUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Painel principal
local panel = Instance.new("Frame")
panel.Name = "DebugPanel"
panel.Size = UDim2.fromOffset(220, 130)
panel.Position = UDim2.fromOffset(25, 100)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel = 0
panel.Visible = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "DEBUG AIM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = panel

-- Botão ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, -20, 0, 32)
espButton.Position = UDim2.fromOffset(10, 45)
espButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 14
espButton.Font = Enum.Font.Gotham
espButton.Parent = panel

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

-- Botão assistência de mira
local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(1, -20, 0, 32)
aimButton.Position = UDim2.fromOffset(10, 84)
aimButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextSize = 14
aimButton.Font = Enum.Font.Gotham
aimButton.Parent = panel

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 8)
aimCorner.Parent = aimButton

-- Botão circular para abrir/fechar
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleInterface"
toggleButton.Size = UDim2.fromOffset(54, 54)
toggleButton.Position = UDim2.fromOffset(25, 245)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 140, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "≡"
toggleButton.TextSize = 28
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local function updateButtons()
	espButton.Text = "ESP: " .. (espEnabled and "ATIVADO" or "DESATIVADO")
	aimButton.Text = "MIRA: " .. (aimEnabled and "ATIVADA" or "DESATIVADA")

	espButton.BackgroundColor3 = espEnabled
		and Color3.fromRGB(35, 125, 75)
		or Color3.fromRGB(90, 45, 45)

	aimButton.BackgroundColor3 = aimEnabled
		and Color3.fromRGB(35, 125, 75)
		or Color3.fromRGB(90, 45, 45)
end

toggleButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible

	if panel.Visible then
		toggleButton.Text = "×"
	else
		toggleButton.Text = "≡"
	end
end)

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	updateButtons()
end)

aimButton.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	updateButtons()
end)

updateButtons()
