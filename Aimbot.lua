--[[
    SISTEMA DE TESTE PARA ANTI-CHEAT
    Controles:
    - Pressione "V" para alternar entre os modos.
    - Pressione "B" para ativar/desativar o aimbot.
    - O script vai mirar no jogador mais próximo dentro do FOV configurado.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIGURAÇÕES DO TESTE =====
local CONFIG = {
    FOV = 90,              -- Ângulo de visão para detectar alvos (graus)
    MAX_DISTANCE = 350,    -- Distância máxima para mirar
    TARGET_OFFSET = Vector3.new(0, 1.5, 0), -- Mira na cabeça (ajuste)
    SMOOTHNESS = 0.15,     -- 0 = instantâneo (snap), 0.15 = suave
    AIM_KEY = Enum.KeyCode.B, -- Liga/Desliga
    MODE_KEY = Enum.KeyCode.V -- Alterna entre Snap e Smooth
}

local aiming = false
local smoothMode = false

-- ===== FUNÇÃO PARA ENCONTRAR O MELHOR ALVO =====
local function getBestTarget()
    local character = LocalPlayer.Character
    if not character then return nil end

    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not root or not head then return nil end

    local origin = root.Position
    local cameraDirection = Camera.CFrame.LookVector
    
    local bestTarget = nil
    local bestScore = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local targetChar = player.Character
        if targetChar then
            local targetHead = targetChar:FindFirstChild("Head")
            local humanoid = targetChar:FindFirstChild("Humanoid")
            
            if targetHead and humanoid and humanoid.Health > 0 then
                local targetPos = targetHead.Position
                local dist = (origin - targetPos).Magnitude
                
                -- Verifica distância
                if dist > CONFIG.MAX_DISTANCE then continue end
                
                -- Verifica se está dentro do FOV (ângulo entre a câmera e o alvo)
                local directionToTarget = (targetPos - Camera.CFrame.Position).Unit
                local angle = math.deg(math.acos(cameraDirection:Dot(directionToTarget)))
                
                if angle <= CONFIG.FOV then
                    -- Prioriza o mais próximo do centro da tela (menor ângulo)
                    if angle < bestScore then
                        bestScore = angle
                        bestTarget = targetHead
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- ===== FUNÇÃO DE MIRA (com suavização) =====
local function aimAt(targetPart)
    if not targetPart then return end
    
    local targetPos = targetPart.Position + CONFIG.TARGET_OFFSET
    local currentPos = Camera.CFrame.Position
    
    if smoothMode then
        -- MODO SUAVE: Move gradualmente (simula aimbot humano)
        local targetCFrame = CFrame.lookAt(currentPos, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, CONFIG.SMOOTHNESS)
    else
        -- MODO SNAP: Teleporta instantaneamente (simula aimbot agressivo)
        Camera.CFrame = CFrame.lookAt(currentPos, targetPos)
    end
end

-- ===== CONTROLES DE TECLADO =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.AIM_KEY then
        aiming = not aiming
        print(aiming and "🔴 Aimbot ATIVADO" or "🟢 Aimbot DESATIVADO")
    end
    
    if input.KeyCode == CONFIG.MODE_KEY then
        smoothMode = not smoothMode
        print(smoothMode and "🐢 Modo SMOOTH (lento)" or "⚡ Modo SNAP (instantâneo)")
    end
end)

-- ===== LOOP PRINCIPAL =====
RunService.RenderStepped:Connect(function()
    if not aiming then return end
    
    local target = getBestTarget()
    if target then
        aimAt(target)
    end
end)

-- ===== FEEDBACK VISUAL (Raios na tela) =====
-- Opcional: Desenha um círculo no centro da tela para testar o FOV
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 10, 0, 10)
frame.Position = UDim2.new(0.5, -5, 0.5, -5)
frame.BackgroundColor3 = Color3.new(1, 0, 0)
frame.BackgroundTransparency = 0.7
frame.BorderSizePixel = 0
frame.Parent = ScreenGui

-- Mostra o status na tela
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextStrokeTransparency = 0
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "Aimbot: OFF"
statusLabel.Parent = ScreenGui

-- Atualiza o label
game:GetService("RunService").Heartbeat:Connect(function()
    statusLabel.Text = aiming and (smoothMode and "🔴 Aimbot: SMOOTH" or "🔴 Aimbot: SNAP") or "🟢 Aimbot: OFF"
end)
