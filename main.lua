local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Blue Hub",
    Icon = 0,
    LoadingTitle = "Exploit Hub",
    LoadingSubtitle = "by Blue",
    Theme = "Default",
    ToggleUIKeybind = "K",
})

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function teleportTo(cf, name)
    local char = getChar()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cf
        if name then
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Pindah ke " .. name,
                Duration = 4,
                Image = 4483362458,
            })
        end
    end
end

-- Lokasi Checkpoints
local checkpoints = {
    {Name = "Basecamp", CF = CFrame.new(243.000, 15.867, -992.000)},
    {Name = "Lokasi 1", CF = CFrame.new(510.809, 162.498, -532.073)},
    {Name = "Lokasi 2", CF = CFrame.new(386.136, 311.550, -183.671)},
    {Name = "Lokasi 3", CF = CFrame.new(101.852, 414.151, 616.154)},
    {Name = "Lokasi 4", CF = CFrame.new(9.975, 603.053, 998.138)},
    {Name = "Lokasi 5", CF = CFrame.new(872.620, 866.762, 581.769)},
    {Name = "Lokasi 6", CF = CFrame.new(1616.274, 1083.046, 158.392)},
    {Name = "Lokasi 7", CF = CFrame.new(2969.925, 1529.404, 708.316)},
    {Name = "Lokasi 8", CF = CFrame.new(1945.811, 1745.390, 1226.817)},
    {Name = "Puncak",   CF = CFrame.new(1804.686, 1983.861, 2169.327)},
}

-- ========= Teleport Tab =========
local TeleportTab = Window:CreateTab("💠Mount.Ckptw", 4483362458)

-- Manual teleport buttons
for _, e in ipairs(checkpoints) do
    TeleportTab:CreateButton({
        Name = e.Name,
        Callback = function()
            teleportTo(e.CF, e.Name)
        end
    })
end

-- Auto Summit System
local autoSystem = false
local function runSystem()
    while autoSystem do
        teleportTo(checkpoints[1].CF, checkpoints[1].Name) -- Basecamp
        task.wait(15)
        for i = 2, #checkpoints do
            if not autoSystem then break end
            teleportTo(checkpoints[i].CF, checkpoints[i].Name)
            if checkpoints[i].Name == "Puncak" then
                Rayfield:Notify({
                    Title = "Puncak",
                    Content = "Tunggu 3 detik, lalu respawn otomatis",
                    Duration = 3,
                    Image = 4483362458,
                })
                task.wait(3)
                local char = player.Character
                if char then pcall(function() char:BreakJoints() end) end
                player.CharacterAdded:Wait()
                task.wait(2)
                teleportTo(checkpoints[1].CF, checkpoints[1].Name)
                break
            else
                task.wait(15)
            end
        end
    end
end

TeleportTab:CreateToggle({
    Name = "♾ Auto Summit (15s delay, respawn di Puncak)",
    CurrentValue = false,
    Flag = "AutoSummit",
    Callback = function(Value)
        autoSystem = Value
        if autoSystem then
            task.spawn(runSystem)
        end
    end,
})

-- ========= Movement Tab =========
local MovementTab = Window:CreateTab("🏃‍♂Movement", 4483362458)

-- Speed Hack
MovementTab:CreateInput({
    Name = "Speed Hack",
    CurrentValue = "",
    PlaceholderText = "16 default",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local char = player.Character or player.CharacterAdded:Wait()
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = tonumber(Text) or 16
        end
    end,
})

-- Jump Hack
MovementTab:CreateSlider({
    Name = "Jump Hack",
    Range = {50, 200},
    Increment = 1,
    Suffix = "Jump Power",
    CurrentValue = 50,
    Callback = function(Value)
        local char = player.Character or player.CharacterAdded:Wait()
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

-- Noclip
local noclip = false
MovementTab:CreateToggle({
    Name = "Noclip (tembus tembok)",
    CurrentValue = false,
    Callback = function(Value)
        noclip = Value
    end,
})
runService.Stepped:Connect(function()
    if noclip then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly
local flying = false
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Value then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = char.HumanoidRootPart
            runService.RenderStepped:Connect(function()
                if flying and hum and hum.Parent then
                    local moveDir = hum.MoveDirection
                    bv.Velocity = moveDir * 50
                end
            end)
        else
            if char.HumanoidRootPart:FindFirstChild("FlyVelocity") then
                char.HumanoidRootPart.FlyVelocity:Destroy()
            end
        end
    end,
})

-- Gravity
MovementTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 300},
    Increment = 10,
    Suffix = "Gravity",
    CurrentValue = workspace.Gravity,
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

-- Infinite Jump
local infJump = false
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        infJump = Value
    end,
})
uis.JumpRequest:Connect(function()
    if infJump then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)