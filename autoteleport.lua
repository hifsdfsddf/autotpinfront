-- Script for Auto-Teleport and One Health
-- Target Player: Beastmodejr412
-- Teleports to them and keeps you very close.
-- Sets your health to 1.

local targetPlayerName = "Beastmodejr412"
local distanceFromPlayer = 1 -- How close to be in front of the target

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local targetPlayer = nil

-- Function to find the target player
local function findTargetPlayer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name == targetPlayerName and player ~= localPlayer then
            return player
        end
    end
    return nil
end

-- Function to calculate the position in front of the target
local function getPositionInFront(targetHumanoidRootPart)
    local targetCFrame = targetHumanoidRootPart.CFrame
    local directionVector = targetCFrame.LookVector
    local position = targetCFrame.Position + (directionVector * distanceFromPlayer)
    return position
end

-- Function to set the player's health
local function setPlayerHealth(player, healthValue)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.Health = healthValue
    end
end

-- Main loop for teleportation and health management
RunService.Heartbeat:Connect(function()
    -- Ensure health stays at 1
    setPlayerHealth(localPlayer, 1)

    targetPlayer = findTargetPlayer()

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHumanoidRootPart = targetPlayer.Character.HumanoidRootPart

        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local playerHumanoidRootPart = localPlayer.Character.HumanoidRootPart
            local newPosition = getPositionInFront(targetHumanoidRootPart)

            -- Teleport the player
            playerHumanoidRootPart.CFrame = CFrame.new(newPosition) * CFrame.Angles(0, math.rad(180), 0) -- Face away from target
        end
    end
end)

-- Set health to 1 when the character is added
localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 1
    end
end)

-- Initial health set
setPlayerHealth(localPlayer, 1)
