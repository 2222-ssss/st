local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/KaanOnly/tes/refs/heads/main/test'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Window = OrionLib:MakeWindow({
    Name = "Kavz Gui | " .. gameName,
    HidePremium = false, 
    SaveConfig = true, 
    IntroText = "Launching..", 
    ConfigFolder = "OrionTest"
})

local M = Window:MakeTab({ 
    Name = "Main", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false 
})

M:AddLabel("Antifling V1")

M:AddToggle({ 
    Name = "Antifling V1", 
    Default = false,
    Callback = function(Value)
        if Value then
            local plr = game.Players.LocalPlayer
            workspace.DescendantAdded:Connect(function(child)
                pcall(function()
                    if child.Name == 'Stabler' then
                        if child:WaitForChild('ConnectedWeld', 10).Part1:IsDescendantOf(plr.Character) then
                            child:Destroy()
                        end
                    end
                end)
            end)
        end
    end    
})

M:AddLabel("Antifling V2")

M:AddToggle({ 
    Name = "Antifling V2", 
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character

        local function resetArm()
            while wait() do
                if Value and character and player.Character == character then
                    local normalState = CFrame.new(0.999999583, 0.650959253, -0.732736051, 2.26716637e-6, 0.999949515, -0.0103517084, 0.181042269, 0.0102514042, 0.983678758)
                    game.ReplicatedStorage.ArmAngleChange:FireServer(normalState)
                end
            end
        end

        if Value then
            resetArm()
        end
    end    
})

M:AddLabel("Loopkill V1&V2")

local loopkillEnabled = false

M:AddToggle({ 
    Name = "Loopkill V1&V2", 
    Default = false,
    Callback = function(Value)
        loopkillEnabled = Value
        if loopkillEnabled then
            local prefix = '/'
            repeat wait() until game.Loaded
            local plrs = game:GetService'Players'
            local plr = plrs.LocalPlayer
            local loopall = false
            local whitelist = {}
            local loopKill = {}

            local function findplr(Target)
                for _,v in pairs(game:GetService'Players':GetPlayers()) do 
                    if v.Name:lower():sub(1,#Target) == Target:lower() or v.DisplayName:lower():sub(1,#Target) == Target:lower() then
                        return v
                    end
                end
            end

            plr.Chatted:connect(function(msg)
                msg = msg:lower():split(' ')
                if msg[1] == '/e' then
                    for i,v in next,msg do
                        msg[i] = msg[i+1]
                    end
                end
                if msg[1] == prefix..'lka' or (msg[1] == prefix..'loop' and msg[2] == 'all') then
                    loopall = true
                elseif msg[1] == prefix..'kill' and findplr(msg[2]) and not table.find(loopKill,findplr(msg[2]).Name) then
                    table.insert(loopKill,findplr(msg[2]).Name)
                elseif msg[1] == prefix..'resurrect' then
                    table.clear(loopKill)
                    loopall = false
                end
            end)

            spawn(function()
                while loopkillEnabled do
                    wait(0.1)
                    if loopall then
                        for _,v in next,plrs:GetPlayers() do
                            if v~=plr and not table.find(whitelist,v.Name) then
                                pcall(function()
                                    plr.Character.Picking:FireServer(v.Character.HumanoidRootPart, Vector3.new(math.huge,-math.huge,math.huge))
                                    wait(0.05)
                                    plr.Character.PuttingDown:FireServer()
                                end)
                            end
                        end
                    end
                    if #loopKill > 0 then
                        for _,v in next,plrs:GetPlayers() do
                            if table.find(loopKill,v.Name) then
                                game:GetService("Workspace")[v.Name].ArmAngleChange:FireServer(CFrame.new(-999, -999, -999))
                                pcall(function()
                                    plr.Character.Picking:FireServer(v.Character.HumanoidRootPart, Vector3.new(math.huge,-math.huge,math.huge))
                                    wait(0.1)
                                    plr.Character.PuttingDown:FireServer()
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end    
})

M:AddTextbox({
    Name = "Target",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players:Chat('/kill '..Value)
    end    
})

M:AddButton({
    Name = "Loop All",
    Callback = function()
        game.Players:Chat("/lka")
    end    
})

M:AddLabel("Wl & Bl")
M:AddTextbox({
    Name = "Whitelist",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players:Chat('/wl '..Value)
    end    
})

M:AddTextbox({
    Name = "Blacklist",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players:Chat('/bl '..Value)
    end    
})

local T = Window:MakeTab({ 
    Name = "Tools", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false 
})

T:AddLabel("Tools & Others")
T:AddButton({
    Name = "TpTool (OP)",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Equip to Click TP"
        tool.Activated:connect(function()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            pos = CFrame.new(pos.X, pos.Y, pos.Z)
            local character = game.Players.LocalPlayer.Character
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CFrame = pos
                end
            end
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end    
})

T:AddLabel("AutoPick (AP)")
T:AddButton({
    Name = "AutoPick (AP)",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "AutoPick (AP)"
        tool.Activated:connect(function()
            local plrs = game:GetService'Players'
            local plr = plrs.LocalPlayer
            local mouse = plr:GetMouse()
            pcall(function()
                if not plr.Character.Picked.Value then
                    plr.Character.Picking:FireServer(mouse.Target, mouse.Hit.p)
                else
                    plr.Character.PuttingDown:FireServer()
                end
            end)
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end    
})


T:AddLabel("Loopkills V1&V2")

T:AddButton({
    Name = "Loopkill V1",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Loopkill V1"

        tool.Activated:Connect(function()
            local plrs = game:GetService('Players')
            local plr = plrs.LocalPlayer
            local mouse = plr:GetMouse()

            pcall(function()
                if not plr.Character.Picked.Value then
                    plr.Character.Picking:FireServer(mouse.Target, Vector3.new(math.huge, -math.huge, math.huge) * 100)
                else
                    plr.Character.PuttingDown:FireServer()
                end
            end)
        end)

        tool.Parent = game.Players.LocalPlayer.Backpack
    end    
})

T:AddButton({
    Name = "Loopkill V2",
    Callback = function()
        mouse = game.Players.LocalPlayer:GetMouse()
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Loopkill V2" 
        tool.Activated:connect(function()
            local plrs = game:GetService'Players'
            local plr = plrs.LocalPlayer
            local mouse = plr:GetMouse()
            if mouse.Target:FindFirstAncestorOfClass('Model') and mouse.Target:FindFirstAncestorOfClass('Model'):FindFirstChild('ArmAngleChange') then
                mouse.Target:FindFirstAncestorOfClass('Model').ArmAngleChange:FireServer(CFrame.new(999,-999,999))
            end 
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end    
})

T:AddLabel("AnvilAim")
T:AddButton({
	Name = "Enable",
	Callback = function()
      		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Tool = localPlayer.Backpack:FindFirstChild("Anvil")
local beam = Instance.new("Beam")
beam.Segments = 1
beam.Width0 = 0.2
beam.Width1 = 0.2
beam.Texture = "rbxassetid://8187483094"
beam.TextureMode = "Stretch"
beam.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0), -- (time, value)
    NumberSequenceKeypoint.new(.5, 0),
    NumberSequenceKeypoint.new(1, 0)
}
beam.Brightness = 2
beam.TextureLength = 5
beam.LightEmission = 0
beam.LightInfluence = 0
beam.FaceCamera = true
 
local attachment0 = Instance.new("Attachment")
local attachment1 = Instance.new("Attachment")
beam.Attachment0 = attachment0
beam.Attachment1 = attachment1
 
beam.Parent = workspace.Terrain
attachment0.Parent = workspace.Terrain
attachment1.Parent = workspace.Terrain
 
local mouse = localPlayer:GetMouse()
 
RunService.RenderStepped:Connect(function()
 
	local character = localPlayer.Character
	if not character then

		beam.Enabled = false
		return
	end
 

	local head = character:FindFirstChild("RightHand")
	if not head then
		
		beam.Enabled = false
		return
	end
 



	local origin = head.Position
	local finish = mouse.Hit.p
 

	attachment0.Position = origin
	attachment1.Position = finish

end)

beam.Enabled = false

Tool.Equipped:Connect(function()
         beam.Enabled = true
end)

Tool.Unequipped:Connect(function()
         beam.Enabled = false
end)
  	end    
})

T:AddLabel("EZ tool")
T:AddButton({
    Name = "Spam Ez Tool",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = Instance.new("Tool")

        tool.RequiresHandle = false
        tool.Name = "Spam Ez"

        tool.Activated:Connect(function()
            local chatEvent = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent then
                chatEvent.SayMessageRequest:FireServer("EZ", "All")
            end
        end)

        tool.Parent = player.Backpack
    end    
})


local MiscTab = Window:MakeTab({
    Name = "Misc", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

MiscTab:AddLabel("AutoFarms")
local autoFarmEnabled = false
MiscTab:AddToggle({
	Name = "Autofarm (One Time)",
	Default = false,
    Callback = function(Value)
        autoFarmEnabled = Value
        if autoFarmEnabled then
           
            local plr = game.Players.LocalPlayer
            local mouse = plr:GetMouse()
            local rs = game:GetService('RunService')
            local vim = game:GetService('VirtualInputManager')

            pcall(function()
                local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
                b.Parent = plr.PlayerGui.DeathMenu
                b.Size = UDim2.new(0.1, 0, 0.05, 0)
                b.Position = UDim2.new(0.1, 0, 0, 0)
                b.TextScaled = true
            end)

            plr.CharacterAdded:Connect(function()
                repeat rs.RenderStepped:wait() until plr:FindFirstChild('PlayerGui') and plr.PlayerGui:FindFirstChild('DeathMenu') and plr.PlayerGui.DeathMenu:FindFirstChild('Frame') and plr.PlayerGui.DeathMenu.Frame:FindFirstChild('Button') and plr.PlayerGui.DeathMenu.Frame.Button:FindFirstChild('TextButton')
                local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
                b.Parent = plr.PlayerGui.DeathMenu
                b.Size = UDim2.new(0.1, 0, 0.05, 0)
                b.Position = UDim2.new(0.1, 0, 0, 0)
                b.TextScaled = true
            end)

            plr.CharacterAdded:Connect(function()
                local c = 0
                repeat 
                    rs.RenderStepped:wait()
                    c = c + 1
                until plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('RightHand') and plr:FindFirstChild('Backpack') and plr.Backpack:FindFirstChild('Punch') and plr:FindFirstChild('PlayerGui') and plr.PlayerGui:FindFirstChild('DeathMenu') and plr.PlayerGui.DeathMenu:FindFirstChild('TextButton') or c >= 200
                local obj = plr.PlayerGui.DeathMenu.TextButton
                if c >= 200 then
                    vim:SendMouseButtonEvent(obj.AbsolutePosition.X + 50, obj.AbsolutePosition.Y + 50, 0, true, game, 0)
                    vim:SendMouseButtonEvent(obj.AbsolutePosition.X + 50, obj.AbsolutePosition.Y + 50, 0, false, game, 0)
                else
                    pcall(function()
                        plr.Backpack.Punch.Parent = plr.Character
                        plr.Character.Punch:Activate()
                        firetouchinterest(plr.Character.RightHand, plr.Character.HumanoidRootPart, 0)
                        firetouchinterest(plr.Character.RightHand, plr.Character.HumanoidRootPart, 1)
                        wait()
                        vim:SendMouseButtonEvent(obj.AbsolutePosition.X + 50, obj.AbsolutePosition.Y + 50, 0, true, game, 0)
                        vim:SendMouseButtonEvent(obj.AbsolutePosition.X + 50, obj.AbsolutePosition.Y + 50, 0, false, game, 0)
                    end)
                end
            end)
        else
 
        end
	end    
})

MiscTab:AddButton({
	Name = "Autofarm (Farms Auto use inf yield)",
	Callback = function()
      		local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local rs = game:GetService'RunService'
local vim = game:GetService'VirtualInputManager'

pcall(function()
    local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
    b.Parent = plr.PlayerGui.DeathMenu
    b.Size = UDim2.new(0.1,0,0.05,0)
    b.Position = UDim2.new(0.1,0,0,0)
    b.TextScaled = true
end)

plr.CharacterAdded:Connect(function()
    repeat rs.RenderStepped:wait() until plr:FindFirstChild'PlayerGui' and plr.PlayerGui:FindFirstChild'DeathMenu' and plr.PlayerGui.DeathMenu:FindFirstChild'Frame' and plr.PlayerGui.DeathMenu.Frame:FindFirstChild'Button' and plr.PlayerGui.DeathMenu.Frame.Button:FindFirstChild'TextButton'
    local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
    b.Parent = plr.PlayerGui.DeathMenu
    b.Size = UDim2.new(0.1,0,0.05,0)
    b.Position = UDim2.new(0.1,0,0,0)
    b.TextScaled = true
end)

plr.CharacterAdded:Connect(function()
    local c = 0
    repeat 
        rs.RenderStepped:wait()
        c=c+1
    until plr.Character and plr.Character:FindFirstChild'HumanoidRootPart' and plr.Character:FindFirstChild'RightHand' and plr:FindFirstChild'Backpack' and plr.Backpack:FindFirstChild'Punch' and plr:FindFirstChild'PlayerGui' and plr.PlayerGui:FindFirstChild'DeathMenu' and plr.PlayerGui.DeathMenu:FindFirstChild'TextButton' or c>=200
    local obj = plr.PlayerGui.DeathMenu.TextButton
    if c>=200 then
        vim:SendMouseButtonEvent(obj.AbsolutePosition.X+50,obj.AbsolutePosition.Y+50,0,true,game,0)
        vim:SendMouseButtonEvent(obj.AbsolutePosition.X+50,obj.AbsolutePosition.Y+50,0,false,game,0)
    else
        pcall(function()
            plr.Backpack.Punch.Parent = plr.Character
            plr.Character.Punch:Activate()
            firetouchinterest(plr.Character.RightHand,plr.Character.HumanoidRootPart,0)
            firetouchinterest(plr.Character.RightHand,plr.Character.HumanoidRootPart,1)
            wait()
            vim:SendMouseButtonEvent(obj.AbsolutePosition.X+50,obj.AbsolutePosition.Y+50,0,true,game,0)
            vim:SendMouseButtonEvent(obj.AbsolutePosition.X+50,obj.AbsolutePosition.Y+50,0,false,game,0)
        end)
    end
end)
  	end    
})

MiscTab:AddLabel("Hitbox G Enables T Disables")
MiscTab:AddToggle({
    Name = "Hitbox",
    Default = false,
    Callback = function(state)
        _G.HitboxEnabled = state
    end
})

MiscTab:AddTextbox({
    Name = "Hitbox Size",
    Default = "12",
    TextDisappear = false,
    Callback = function(value)
        _G.HeadSize = tonumber(value) or 12
    end
})

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == "g" and _G.HitboxEnabled then
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Bright red")
                    v.Character.HumanoidRootPart.Material = "Neon"
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end)

mouse.KeyDown:Connect(function(key)
    if key == "t" and _G.HitboxEnabled then
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                    v.Character.HumanoidRootPart.Material = "Plastic"
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end)

MiscTab:AddLabel("AntiAnvil")

local isEnabled1 = false
local connection1

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer

MiscTab:AddToggle({
    Name = "AntiAnvil",
    Default = false,
    Callback = function(Value)
        isEnabled1 = Value
        if isEnabled1 then
            connection1 = RunService.Heartbeat:Connect(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= plr then
                        pcall(function()
                            if v.Character and v.Character:FindFirstChild("Anvil") then
                                v.Character.Anvil.send:FireServer(CFrame.new(math.huge, -math.huge, math.huge))
                            end
                        end)
                    end
                end
            end)
        else
            if connection1 then
                connection1:Disconnect()
                connection1 = nil
            end
        end
    end
})

MiscTab:AddLabel("Locations")

MiscTab:AddDropdown({ 
    Name = "Teleport",
    Default = "Spawn",
    Options = {"Spawn", "Safezone 1", "Safezone 2", "Safezone 3", "Safezone 4", "Safezone 5"},
    Callback = function(Value)
        local plr = game.Players.LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if Value == "Spawn" then
                for _, v in ipairs(workspace.Map:GetDescendants()) do
                    if v:IsA("SpawnLocation") then
                        plr.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                        break
                    end
                end
            else
                local safezones = {
                    {pos = Vector3.new(2000, workspace.FallenPartsDestroyHeight + 2, 2000), size = Vector3.new(500, 3, 500)},
                    {pos = Vector3.new(-1500, workspace.FallenPartsDestroyHeight + 2, 2500), size = Vector3.new(600, 3, 600)},
                    {pos = Vector3.new(3000, workspace.FallenPartsDestroyHeight + 2, -1000), size = Vector3.new(400, 3, 400)},
                    {pos = Vector3.new(0, workspace.FallenPartsDestroyHeight + 2, 5000), size = Vector3.new(700, 3, 700)},
                    {pos = Vector3.new(-2500, workspace.FallenPartsDestroyHeight + 2, -2500), size = Vector3.new(550, 3, 550)}
                }

                local zoneNumber = tonumber(string.match(Value, "%d+"))
                if zoneNumber and safezones[zoneNumber] then
                    local zoneData = safezones[zoneNumber]
                    local zoneName = "SafeZone" .. zoneNumber

                    if not workspace:FindFirstChild(zoneName) then
                        local sp = Instance.new("Part", workspace)
                        sp.Name = zoneName
                        sp.Size = zoneData.size
                        sp.CFrame = CFrame.new(zoneData.pos)
                        sp.Anchored = true
                    end

                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(zoneData.pos + Vector3.new(0, 8, 0))
                end
            end
        end
    end    
})

MiscTab:AddLabel("Teleport Players")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

local function GetPlayerOptions()
    local options = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(options, player.DisplayName)
        end
    end
    return options
end

local function FindPlayerByDisplayName(displayName)
    for _, player in pairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            return player
        end
    end
    return nil
end

local Dropdown = MiscTab:AddDropdown({ 
    Name = "Bring Players", 
    Default = "Select Player",
    Options = GetPlayerOptions(), 
    Callback = function(Value)
        local targetPlayer = FindPlayerByDisplayName(Value)
        if targetPlayer and targetPlayer.Character then
            local TargetCharacter = targetPlayer.Character
            local ArmAngleChange = LocalPlayer.Character:FindFirstChild("ArmAngleChange")
            
            if ArmAngleChange then
                task.spawn(function()
                    local distanceThreshold = 3
                    while TargetCharacter and (LocalPlayer.Character.PrimaryPart.Position - TargetCharacter.PrimaryPart.Position).Magnitude > distanceThreshold do
                        local targetTorso = TargetCharacter:FindFirstChild("Torso") or TargetCharacter:FindFirstChild("HumanoidRootPart")
                        if targetTorso then
                            ArmAngleChange:FireServer(targetTorso.CFrame)
                        end
                        task.wait(0.1)
                    end
                    
                    if LocalPlayer.Character.Picked.Value == false then
                        LocalPlayer.Character.Picking:FireServer(TargetCharacter, TargetCharacter.PrimaryPart.Position)
                    else
                        LocalPlayer.Character.PuttingDown:FireServer()
                    end
                    
                    for i = 1, 10 do
                        ArmAngleChange:FireServer(CFrame.new(LocalPlayer.Character.PrimaryPart.Position) * CFrame.Angles(0, 0, -math.rad(i * 10)))
                        task.wait(0.1)
                    end
                end)
            end
        end
    end    
})

MiscTab:AddButton({
    Name = "Refresh Players",
    Callback = function()
        Dropdown:SetOptions(GetPlayerOptions())
    end
})

MiscTab:AddLabel("Antis")
local antiRagdollEnabled = false
local antiRagdollThread

MiscTab:AddToggle({
    Name = "AntiRagdoll", 
    Default = false,
    Callback = function(Value)
        if Value then
            if not antiRagdollEnabled then
                antiRagdollEnabled = true
                antiRagdollThread = spawn(function()
                    while antiRagdollEnabled do
                        wait()

                        pcall(function()
                            local plr = game.Players.LocalPlayer
                            if plr and plr.Character then
                                if plr.Character:FindFirstChild("Ragdoll") and plr.Character.Ragdoll.Value then
                                    plr.Character.GetUpEvent:FireServer()
                                end
                            end
                        end)

                        pcall(function()
                            local plr = game.Players.LocalPlayer
                            if plr.Character then
                                for _, accessory in next, plr.Character:GetChildren() do
                                    pcall(function()
                                        if accessory:IsA("Accessory") and accessory.Name ~= "FakeAccessory" and accessory:FindFirstChild("Handle") then
                                            local weld = accessory.Handle:FindFirstChildOfClass("Weld")
                                            if weld then
                                                local clone = accessory:Clone()
                                                accessory:Destroy()
                                                clone.Name = "FakeAccessory"
                                                clone.Parent = plr.Character
                                            end
                                        end
                                    end)

                                    pcall(function()
                                        if accessory.Name == "VelocityDamage" or accessory.Name == "GetPicked" then
                                            accessory:Destroy()
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end)
            end
        else
            antiRagdollEnabled = false
            if antiRagdollThread then
                antiRagdollThread = nil
            end
        end
    end    
})

MiscTab:AddToggle({ 
    Name = "AntiSpinner", 
    Default = false,
    Callback = function(Value)
        if Value then
            repeat wait() until plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head")
            for _, v in next, plr.Character:GetChildren() do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = prop1000
                end
            end
        else
            for _, v in next, plr.Character:GetChildren() do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = nil
                end
            end
        end
    end    
})

local AutoRespawnEnabled = false
local plr = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")

local function respawn()
    pcall(function()
        local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
        b.Position = UDim2.new(0,0,0,0)
        b.Size = UDim2.new(1,0,1,0)
        b.Text = ''
        b.BackgroundTransparency = 1
        b.ZIndex = (2^31-1)
        local s = Instance.new('ScreenGui', game:GetService('CoreGui'))
        b.Parent = s
        vim:SendMouseButtonEvent(b.AbsolutePosition.X + b.AbsoluteSize.X / 2, b.AbsolutePosition.Y + b.AbsoluteSize.Y / 2, 0, true, game, 0)
        vim:SendMouseButtonEvent(b.AbsolutePosition.X + b.AbsoluteSize.X / 2, b.AbsolutePosition.Y + b.AbsoluteSize.Y / 2, 0, false, game, 0)
        spawn(function()
            wait()
            s:Destroy()
        end)
    end)
end

MiscTab:AddToggle({
    Name = "AutoRespawn",
    Default = false,
    Callback = function(Value)
        AutoRespawnEnabled = Value
    end
})

plr.CharacterAdded:Connect(function(character)
    if AutoRespawnEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            respawn()
        end)
    end
end)

local player = game.Players.LocalPlayer
local userToggle = false

function ToggleAntiVoid(Value)
    userToggle = Value
end

game:GetService("RunService").Heartbeat:Connect(function()
    if userToggle then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            if humanoidRootPart.Position.Y < -100 then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, -5, 0)
            end
        end
    end
end)

MiscTab:AddToggle({
    Name = "AntiVoid", 
    Default = false,
    Callback = function(Value)
        ToggleAntiVoid(Value)
    end    
})


MiscTab:AddLabel("Arm Controls")

local function applyArmMovement(player, x, y, z)
    if player.Character and player.Character:FindFirstChild("ArmAngleChange") then
        player.Character.ArmAngleChange:FireServer(CFrame.new(x, y, z))
    end
end

local function updateAllPlayers(x, y, z)
    for _, player in ipairs(game.Players:GetPlayers()) do
        applyArmMovement(player, x, y, z)
    end
end

local Slider1 = MiscTab:AddSlider({
    Name = "Arm Height",
    Min = 0,
    Max = 5000,
    Default = 0,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = .5,
    ValueName = " ",
    Callback = function(s)
        updateAllPlayers(1, s, 0)
    end
})

local Slider2 = MiscTab:AddSlider({
    Name = "Arm Catapult",
    Min = 0,
    Max = 5000,
    Default = 0,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = .5,
    ValueName = " ",
    Callback = function(s)
        updateAllPlayers(1, s, -s)
    end
})

local meow = MiscTab:AddSlider({
    Name = "Arm Forward",
    Min = 0,
    Max = 5000,
    Default = 0,
    Color = Color3.fromRGB(255, 105, 180),
    Increment = .5,
    ValueName = " ",
    Callback = function(s)
        updateAllPlayers(1, 0.56, -s)
    end
})

MiscTab:AddBind({
    Name = "Arm Reset",
    Default = Enum.KeyCode.RightBracket,
    Hold = false,
    Callback = function()
        Slider1:Set(0)
        Slider2:Set(0)
        meow:Set(0)
        wait(0.1)
        updateAllPlayers(1, 0.56, 0)
    end
})

MiscTab:AddLabel("Players")

local armFlyOthers = false
MiscTab:AddToggle({
    Name = "Arm Fly (Others)",
    Default = false,
    Callback = function(Value)
        armFlyOthers = Value
        while armFlyOthers do
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local arm = player.Character and player.Character:FindFirstChild("Right Arm")
                    if arm then
                        local speed = 5
                        local height = 5
                        local radius = 5
                        local angle = tick() * speed
                        local x = radius * math.cos(angle)
                        local y = height * math.sin(angle)
                        local z = radius * math.sin(angle)
                        arm.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
                    end
                end
            end
            wait(0.03)
        end
    end    
})

MiscTab:AddSlider({
    Name = "Orbit Speed",
    Min = 0,
    Max = 1000,
    Default = 5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
    end    
})

MiscTab:AddSlider({
    Name = "Orbit Height",
    Min = 0,
    Max = 1000,
    Default = 5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Height",
    Callback = function(Value)
    end    
})

MiscTab:AddSlider({
    Name = "Orbit Radius",
    Min = 0,
    Max = 1000,
    Default = 5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Radius",
    Callback = function(Value)
    end    
})

local GlobalTab = Window:MakeTab({
    Name = "Global", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

GlobalTab:AddLabel("LegFlings / Big Jacket")
GlobalTab:AddToggle({
    Name = "LegsFling", 
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                for _, v in next, plr.Character:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
                        v.Massless = true
                    end
                end
                pcall(function()
                    plr.Character.BodyFollowMouse.Disabled = true
                end)
                plr.Character.HeadWaist:FireServer(CFrame.new(0, 9e37, -9e37), CFrame.new(0, -9e37, 9e37))
            end)
        else
            pcall(function()
                for _, v in next, plr.Character:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
                        v.Massless = false
                    end
                end
                pcall(function()
                    plr.Character.BodyFollowMouse.Disabled = false
                end)
            end)
        end
    end
})
GlobalTab:AddLabel("Change AntiAnvil")

GlobalTab:AddDropdown({
    Name = "AntiAnvil Options",
    Default = "AntiAnvilV2",
    Options = {"AntiAnvilV2", "AntiAnvil (Fix)", "AntiAnvil (Test)", "AntiAnvil (TpVoid)", "AntiAnvil (Destroys)"},
    Callback = function(Value)
        if Value == "AntiAnvilV2" then
            antiAnvil("v2")
        elseif Value == "AntiAnvil (Fix)" then
            antiAnvil("fix")
        elseif Value == "AntiAnvil (Test)" then
            antiAnvil("method1")
        elseif Value == "AntiAnvil (TpVoid)" then
            antiAnvil("method2")
        elseif Value == "AntiAnvil (Destroys)" then
            antiAnvil("method3")
        end
    end
})

GlobalTab:AddToggle({
    Name = "Enable AntiAnvil",
    Default = false,
    Callback = function(state)
        if state then
            antiAnvil("enable")
        else
            antiAnvil("disable")
        end
    end
})

function antiAnvil(method)
    local plrs = game:GetService("Players")

    for _,v in next,plrs:GetPlayers() do
        pcall(function()
            if v.Character and v.Character:FindFirstChild("Anvil") then
                if method == "v2" then
                    v.Character.Anvil.send:FireServer(CFrame.new(math.huge, math.huge, math.huge))
                elseif method == "fix" then
                    v.Character.Anvil:Destroy()
                elseif method == "method1" then
                    v.Character.Anvil.CFrame = CFrame.new(0, 5000, 0)
                elseif method == "method2" then
                    v.Character.Anvil.CFrame = CFrame.new(math.huge, 0, math.huge)
                elseif method == "method3" then
                    v.Character.Anvil.Anchored = true
                    v.Character.Anvil.CFrame = CFrame.new(0, 1000, 0)
                end
            end
        end)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    local plrs = game:GetService("Players")
    for _,v in next,plrs:GetPlayers() do
        pcall(function()
            if v.Character and v.Character:FindFirstChild("Anvil") then
                antiAnvil("enable")
            end
        end)
    end
end)

GlobalTab:AddToggle({
    Name = "BigJacket", 
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                local char = plr.Character
                for _, v in next, char:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
                        v.Massless = true
                    end
                end
                pcall(function()
                    char.BodyFollowMouse.Disabled = true
                end)
            end)
        else
            pcall(function()
                local char = plr.Character
                for _, v in next, char:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
                        v.Massless = false
                    end
                end
                pcall(function()
                    char.BodyFollowMouse.Disabled = false
                end)
            end)
        end
    end
})

local OptionsTab = Window:MakeTab({
    Name = "Options", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

local OptionsV2 = Window:MakeTab({
    Name = "OptionsV2", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

local Keybinds = Window:MakeTab({
    Name = "Keybinds", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

local Other = Window:MakeTab({
    Name = "Other", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

local Settings = Window:MakeTab({
    Name = "Settings", 
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})
