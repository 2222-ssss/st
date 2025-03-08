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


T:AddLabel("Loopkills V1&V2&v3")

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

T:AddButton({
	Name = "Loopkill V3",
	Callback = function()
        local plrs = game:GetService("Players")
        local plr = plrs.LocalPlayer
        local mouse = plr:GetMouse()
        
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "LoopKill V3"
        tool.Parent = plr.Backpack
        
        tool.Activated:Connect(function()
            pcall(function()
                local targetModel = mouse.Target and mouse.Target:FindFirstAncestorOfClass("Model")
                
                if targetModel then
                    if not plr.Character.Picked.Value then
                        plr.Character.Picking:FireServer(mouse.Target, Vector3.new(math.huge, -math.huge, math.huge))
                    else
                        plr.Character.PuttingDown:FireServer()
                    end
        
                    if targetModel:FindFirstChild("ArmAngleChange") then
                        targetModel.ArmAngleChange:FireServer(CFrame.new(-999, -999, -999))
                    end
                end
            end)
        end)
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
    NumberSequenceKeypoint.new(0, 0), -- change it if u need more lines
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

MiscTab:AddLabel("Other Guis")

MiscTab:AddButton({
	Name = "Button!",
	Callback = function()
      		print("button pressed")
  	end    
})
MiscTab:AddLabel("To Turn Flux gui type Launch Test Gui")
MiscTab:AddLabel("To Turn Arm Gui type Launch Arm Gui")
MiscTab:AddButton({
	Name = "Updated Flux Gui (NEWEST)",
	Callback = function()
      		-- my guiV2 --
--30Thirty30$--
local player = game.Players.LocalPlayer

local function onChat(message)
    if message == "Launch Test Gui" then
        -- my guiV2 --
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/KaanOnly/tes/refs/heads/main/test'))()
local window = OrionLib:MakeWindow({Name = "Flux Gui", IntroText = "Loading..", IntroIcon = "rbxassetid://10907975245", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab1 = window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


Tab1:AddLabel("Loopkill/Loopkill V2/AntiRag/AntiFling")

Tab1:AddButton({
	Name = "Activate",
	Callback = function()
      		local prefix = '/'

repeat wait() until game.Loaded
local plrs = game:GetService'Players'
local plr = plrs.LocalPlayer
local loopall = false
local whitelist = {}
local loopKill = {}
local function findplr(Target)
    if game:GetService'Players':FindFirstChild(Target) then
        return game:GetService'Players':FindFirstChild(Target)
    else
        if Target ~= nil and Target ~= "" and Target ~= " " and Target then
            local name = Target
            local found = false
            for _,v in pairs(game:GetService'Players':GetPlayers()) do 
                if not found and (v.Name:lower():sub(1,#name) == name:lower() or v.DisplayName:lower():sub(1,#name) == name:lower()) then
                    name = v
                    found = true
                end
            end
            if name ~= nil and name ~= Target then
                return name
            end
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
    elseif msg[1] == prefix..'wl' and findplr(msg[2]) and not table.find(whitelist,findplr(msg[2]).Name) then
        table.insert(whitelist,findplr(msg[2]).Name)
    elseif msg[1] == prefix..'bl' and findplr(msg[2]) and table.find(whitelist,findplr(msg[2]).Name) then
        table.remove(whitelist,findplr(msg[2]).Name)
    elseif msg[1] == prefix..'resurrect' then
        table.clear(loopKill)
        loopall = false
        pcall(function()
            plr.Character.PuttingDown:FireServer()
        end)
    end
end)
spawn(function()
    while true do wait()
        pcall(function()
            if plr.Character.Ragdoll.Value then
                plr.Character.GetUpEvent:FireServer()
            end
        end)
        pcall(function()
            for _,_2 in next,plr.Character:GetChildren() do
                pcall(function()
                    if _2:IsA'Accessory' and _2.Name ~= 'FakeAccessory' and _2:FindFirstChild'Handle' and _2.Handle:FindFirstChildOfClass'Weld' then
                        local clone = _2:Clone()
                        _2:Destroy()
                        clone.Name = 'FakeAccessory'
                        clone.Parent = plr.Character
                    end
                end)
                pcall(function()
                    if _2.Name == 'VelocityDamage' or _2.Name == 'GetPicked' then
                        _2:Destroy()
                    end
                end)
            end
        end) 
    end
end)
while true do wait(0.1)
    if loopall then
        for _,v in next,plrs:GetPlayers() do
            if v~=plr and not table.find(whitelist,v.Name) then
                pcall(function()
                    plr.Character.Picking:FireServer(v.Character.HumanoidRootPart,Vector3.new(math.huge,-math.huge,math.huge))
                    wait(0.05)
                    plr.Character.PuttingDown:FireServer()
                end)
            end
        end
    end
    if loopKill ~= {} then
        for _,v in next,plrs:GetPlayers() do
            if table.find(loopKill,v.Name) then
                game:GetService("Workspace")[v.Name].ArmAngleChange:FireServer(CFrame.new(-math.huge, math.huge, -3, 0, .01, .1, 0, 0, 0, 0, 0, 1))
                pcall(function()
                    local accs = v.Character:FindFirstChildOfClass'Accessory'
                    if accs then
                        if accs:FindFirstChild'Handle' then
                            plr.Character.Picking:FireServer(accs.Handle,Vector3.new(math.huge,-math.huge,math.huge))
                        elseif accs:IsA'BasePart' then
                            plr.Character.Picking:FireServer(accs,Vector3.new(math.huge,-math.huge,math.huge))
                        end
                    else
                        plr.Character.Picking:FireServer(v.Character.HumanoidRootPart,Vector3.new(math.huge,-math.huge,math.huge))
                        wait(0.1)
                        plr.Character.PuttingDown:FireServer()
                    end
                end)
            end
        end
    end
end
end    
})


Tab1:AddTextbox({
	Name = "Target Name",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players:Chat('/kill '..Value)
	end	  
})

Tab1:AddButton({
	Name = "Loop All",
	Callback = function()
      	game.Players:Chat("/lka")
  	end    
})





local player = game.Players.LocalPlayer

local hiddenloop = false
Tab1:AddToggle({
	Name = "Hidden Loop",
	Default = false,
	Callback = function(Value)
		hiddenloop = Value
	end    
})
spawn(function()
    while true do
        pcall(function()
            player.Character.ArmAngle.Disabled = hiddenloop
            wait(0.3)
        end)
    end
end)


Tab1:AddLabel("Whitelist/Blacklist")
Tab1:AddTextbox({
	Name = "Whitelist",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players:Chat('/wl '..Value)
	end	  
})


Tab1:AddTextbox({
	Name = "Blacklist",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players:Chat('/bl '..Value)
	end	  
})



Tab1:AddLabel("Grab Anywhere")


Tab1:AddButton({
	Name = "Activate",
	Callback = function()
local plrs = game:GetService'Players'
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == 'q' then
        pcall(function()
            if not plr.Character.Picked.Value then
                plr.Character.Picking:FireServer(mouse.Target,mouse.Hit.p)
            else
                plr.Character.PuttingDown:FireServer()
            end
        end)
    end
end)
mouse.KeyUp:Connect(function(key)
    if key == 'q' then
        pcall(function()
            plr.Character.PuttingDown:FireServer()
        end)
    end
end)
end
})


Tab1:AddLabel("Easy Grab")

Tab1:AddButton({
	Name = "Activate",
	Callback = function()
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local DistanceGui = Instance.new("ScreenGui")
local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Size = UDim2.new(0, 250, 0, 60)
DistanceLabel.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
DistanceLabel.TextColor3 = Color3.fromRGB(32, 194, 14)
DistanceLabel.FontSize = Enum.FontSize.Size18
DistanceLabel.Position = UDim2.new(0.5, -100, 0, 10)
DistanceLabel.Text = "Distance: \nHeight difference: "
DistanceLabel.TextWrapped = true
DistanceLabel.Parent = DistanceGui
DistanceGui.Parent = game:GetService("CoreGui")

local function OnClick()
   if not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
      return
   end

   local ClickedPart = Mouse.Target
   if ClickedPart and ClickedPart:IsA("BasePart") and Players:GetPlayerFromCharacter(ClickedPart.Parent) then
       local ClickedPosition = ClickedPart.Position
       local MyPosition = Player.Character.HumanoidRootPart.Position
       local ArmPosition = Player.Character.RightUpperArm.Position

       -- Calculate distance
       local Distance = (ClickedPosition - MyPosition).Magnitude

       -- Calculate height difference
       local HeightDifference = ClickedPosition.Y - MyPosition.Y
       local HeightSign = HeightDifference >= 0 and "+" or "-"

       -- Update the GUI with the new values
       DistanceLabel.Text = string.format("Distance: %d\nHeight difference: %s%d units", math.floor(Distance), HeightSign, math.abs(math.floor(HeightDifference)))

       -- Face the clicked player
       local Confused = game.Players.LocalPlayer.Character
       Confused.RightHand.Massless = true
       Confused.RightUpperArm.Massless = true
       Confused.RightLowerArm.Massless = true
       local LookVector = (ClickedPart.Position - MyPosition).Unit
       Player.Character.HumanoidRootPart.CFrame = CFrame.new(MyPosition, MyPosition + LookVector)
       game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(-.7,HeightDifference,-Distance))
       wait(.2)
       Player.Character.Picking:FireServer(ClickedPart,ClickedPart.Position)
   end
end

Mouse.Button1Down:Connect(OnClick)
end
})








Tab1:AddLabel("Punch Anywhere")

Tab1:AddButton({
	Name = "Activate",
	Callback = function()
      	local plr = game:GetService'Players'.LocalPlayer
local mouse = plr:GetMouse()

while true do
    wait(.05)
	pcall(function()
        local part = mouse.Target:FindFirstAncestorOfClass'Model'.HumanoidRootPart
        firetouchinterest(plr.Character.RightHand,part,0)
        firetouchinterest(plr.Character.RightHand,part,1)
    end)
    wait()
end
end    
})

Tab1:AddLabel("Anti Hit")
Tab1:AddButton({
	Name = "Activate",
	Callback = function()
      		Target = "THEVICTIM"

game.Players.LocalPlayer.Character.Humanoid.Name = 1
local l = game.Players.LocalPlayer.Character["1"]:Clone()
l.Parent = game.Players.LocalPlayer.Character
l.Name = "Humanoid"
wait()
game.Players.LocalPlayer.Character["1"]:Destroy()
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
game.Players.LocalPlayer.Character.Animate.Disabled = true
wait()
game.Players.LocalPlayer.Character.Animate.Disabled = false
game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
for i,v in pairs(game:GetService'Players'.LocalPlayer.Backpack:GetChildren())do
game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
end
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[Target].Character.HumanoidRootPart.CFrame
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[Target].Character.HumanoidRootPart.CFrame
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10000000,0))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130,3.5,30)
wait()
local prt=Instance.new("Model", workspace);
Instance.new("Part", prt).Name="Torso";
Instance.new("Part", prt).Name="Head";
Instance.new("Humanoid", prt).Name="Humanoid";
game.Players.LocalPlayer.Character=prt
  	end    
})
Tab1:AddLabel("Anvil Aim")

Tab1:AddButton({
	Name = "Activate",
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


--tab 2

local Tab2 = window:MakeTab({
	Name = "Random",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})



Tab2:AddLabel("Infinite Yield")

Tab2:AddButton({
	Name = "Activate",
	Callback = function()
      		loadstring(game:HttpGet('https://pastebin.com/raw/gvDkEHHg'))()
  	end    
})

Tab2:AddLabel("Run left Ctrl")

Tab2:AddButton({
	Name = "Activate",
	Callback = function()
      		--factors
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local hum = game.Players.LocalPlayer.Character.Humanoid
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local toggled = false


--run on key press
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        hum.WalkSpeed = 22
        hum.JumpPower = 70
    toggled = true
    end
end)

--stop run upon key release
uis.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        hum.WalkSpeed = 16.33
        hum.JumpPower = 50
        toggled = false
    end
end)

--look vector 'tpwalk'
RunService.RenderStepped:Connect(function()
    if toggled == true then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * .15
    end
end)
  	end    
})




Tab2:AddLabel("E To Zoom")
Tab2:AddButton({
	Name = "Activate",
	Callback = function()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
--zoom on key press
uis.InputBegan:connect(function(input, istyping) 
    if input.KeyCode == Enum.KeyCode.E and not istyping then
        workspace.Camera.FieldOfView = 30
            for _, object in ipairs(player.Character:GetDescendants()) do
        -- Parts have a superclass called BasePart, use this instead of
        -- checking over several classes.
        if object:IsA("BasePart") or object:IsA("Decal") then
            object.LocalTransparencyModifier = .85
        end
    end
    end
end)

--stop zoom upon key release
uis.InputEnded:connect(function(input, istyping) 
    if input.KeyCode == Enum.KeyCode.E and not istyping then
        workspace.Camera.FieldOfView = 90
            for _, object in ipairs(player.Character:GetDescendants()) do
        -- Parts have a superclass called BasePart, use this instead of
        -- checking over several classes.
        if object:IsA("BasePart") or object:IsA("Decal") then
            object.LocalTransparencyModifier = 0
        end
    end
    end
end)
	end    
})




Tab2:AddLabel("Rejoin")

Tab2:AddButton({
	Name = "Activate",
	Callback = function()
      		loadstring(game:HttpGet("https://pastebin.com/raw/1gtVMUz3"))()
  	end    
})
Tab2:AddLabel("Aesthetics")



Tab2:AddButton({
	Name = "Disable Body Follows Mouse",
	Callback = function()
      		local player = game.Players.LocalPlayer
pcall(function()
while true do
player.Character.BodyFollowMouse.Disabled = true
wait(1.5)
end
end)
  	end    
})


Tab2:AddButton({
	Name = "BigHead Reposition",
	Callback = function()
game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, 0.8, .05, 1, 0, 0, .0, 0, 0, -0, 0, 0),CFrame.new(0, .095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
  	end    
})

Tab2:AddButton({
	Name = "Dog Reposition",
	Callback = function()
game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(-6.79650398e-08, 0.86, -.1, 0.99993664, 8.12966027e-06, 0.0112577537, 0.000602641259, 0.998527229, -0.0542489029, -0.0112416157, 0.0542522483, 0),CFrame.new(-0.116010524, .92, -.1, 10.999984026, 0, 0.00565499254, 0.000201625779, 10.999344885, -0.0361913592, -0.00565139763, 0.036191918, 10.999328911))
game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1.08069849, 0.17757228, 0.106126301, 1, 0, 0, 0, 1, 0, 0, 0, 1))
  	end    
})


Tab2:AddButton({
	Name = "Flux Trail",
	Callback = function()
      		local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character
local head = character:FindFirstChild("HumanoidRootPart")



local attachment0 = Instance.new("Attachment")
attachment0.Name = "Attachment0"
attachment0.Parent = head
attachment0.Position = Vector3.new(-1.5, -2.9, 1)


local attachment1 = Instance.new("Attachment")
attachment1.Name = "Attachment1"
attachment1.Parent = head
attachment1.Position = Vector3.new(1.5, -2.9, 1)



local trail = Instance.new("Trail")
trail.Parent = head
trail.Attachment0 = attachment0
trail.Attachment1 = attachment1
trail.Texture = "rbxassetid://10907975245"
trail.TextureMode = "Wrap"
trail.MaxLength = 10
trail.Lifetime = 3
trail.LightEmission = 0
trail.LightInfluence = 0
trail.Transparency = NumberSequence.new(0, 0)
trail.TextureLength = 2.43
trail.FaceCamera = false
  	end    
})



--TAB 3


local Tab3 = window:MakeTab({
	Name = "Key Binds",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab3:AddBind({
	Name = "Stop Loopkill",
	Default = Enum.KeyCode.BackSlash,
	Hold = false,
	Callback = function()
		game.Players:Chat("/resurrect")
	end    
})




Tab3:AddBind({
	Name = "Arm Stance",
	Default = Enum.KeyCode.LeftBracket,
	Hold = false,
	Callback = function()
		game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1, .56, 0, 0, 0, 0, 3.5, 1, -18, 0, 0, 1))
	end    
})


Tab3:AddBind({
	Name = "Loop Bind",
	Default = Enum.KeyCode.T,
	Hold = false,
	Callback = function()
		local plrs = game:GetService'Players'
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()


pcall(function()
    if not plr.Character.Picked.Value then
        plr.Character.Picking:FireServer(mouse.Target,Vector3.new(math.huge,-math.huge,math.huge))
    else
        plr.Character.PuttingDown:FireServer()
    end
end)
	end    
})


local Slider1 = Tab3:AddSlider({
	Name = "Arm Height",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1,s,0))
	end    
})


local Slider2 = Tab3:AddSlider({
	Name = "Arm Catapult",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1,s,-s))
	end    
})


local meow = Tab3:AddSlider({
	Name = "Arm Forward",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1,.56,-s))
	end    
})

local meows = Tab3:AddSlider({
	Name = "Head Turn",
	Min = -18,
	Max = 18,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .25,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, 0.800000012, 0.0500000007, 1, 0, -s, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
	end    
})

local wow = Tab3:AddSlider({
	Name = "Head Lean",
	Min = -1,
	Max = 1,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .1,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, .9, 0.0500000007, 1, s, 0, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
	end    
})

local MyValue = 0
local Increasing = true
local LoopRunning = false
Tab3:AddToggle({
    Name = "Creepy Head Lean",
    Default = false,
    Callback = function(Value)
        LoopRunning = Value
    end    
})
spawn(function()
    while true do
       wait(0.07)
       if LoopRunning then
           if Increasing then
              MyValue = MyValue + 0.1
              if MyValue >= 1 then
                 Increasing = false
              end
           else
              MyValue = MyValue - 0.1
              if MyValue <= -1 then
                 Increasing = true
              end
           end
            game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, .9, 0.0500000007, 1, MyValue, 0, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
        end
    end
end)







local wows = Tab3:AddSlider({
	Name = "Body Turn",
	Min = -10,
	Max = 10,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .2,
	ValueName = " ",
	Callback = function(s)
		game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, 0.800000012, 0.0500000007, 1, 0, 0, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, -s, 0, 0, 0, 0, 0, 1))
	end    
})

Tab3:AddBind({
	Name = "Body Reset",
	Default = Enum.KeyCode.RightBracket,
	Hold = false,
	Callback = function()
		Slider1:Set(0)
		Slider2:Set(0)
		meow:Set(0)
		meows:Set(0)
		wow:Set(0)
		wows:Set(0)
		Slider7:Set(0)
		wait(.1)
		game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1, .56, 0, 0, .01, .1, 0, 0, 0, 0, 0, 1))
		game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, 0.800000012, 0.0500000007, 1, 0, 0, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
    end    
})





local Tab4 = window:MakeTab({
	Name = "Credits/Info",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


Tab4:AddParagraph("Loopkilling","To begin a loopkill first activate the LoopKill/AntiRag/AntiFling. Then fully or partially type the players display name or username in the target name textbox below. To end the loopkill simply press the Stop Loop keybind which will be set by you in the keybinds section. To kill a player once simply hover your mouse over them and press the loop bind button of your choice set by you in the keybinds section.")


Tab4:AddLabel("Made By:Flux#6394")

game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1, .56, 0, 0, .01, .1, 0, 0, 0, 0, 0, 1))
game.Players.LocalPlayer.Character.HeadWaist:FireServer(CFrame.new(0, 0.800000012, 0.0500000007, 1, 0, 0, 0, 0, 0, 0, 0, 0),CFrame.new(0, 0.0949999988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
    elseif message == "Launch Arm Gui" then
        --arm gui--
local player = game.Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/KaanOnly/tes/refs/heads/main/test'))()
local window = OrionLib:MakeWindow({Name = "Flux Arm Gui", IntroText = "Loading..", IntroIcon = "rbxassetid://10907975245", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local Tab1 = window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Slider1 = Tab1:AddSlider({
	Name = "Arm Height",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
	for _,player in ipairs(game.Players:GetPlayers()) do
    player.Character.ArmAngleChange:FireServer(CFrame.new(1,s,0))
	end
	end
})
local Slider2 = Tab1:AddSlider({
	Name = "Arm Catapult",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
	for _,player in ipairs(game.Players:GetPlayers()) do
    player.Character.ArmAngleChange:FireServer(CFrame.new(1,s,-s))
	end
	end
})
local meow = Tab1:AddSlider({
	Name = "Arm Forward",
	Min = 0,
	Max = 200,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = .5,
	ValueName = " ",
	Callback = function(s)
	for _,player in ipairs(game.Players:GetPlayers()) do
    player.Character.ArmAngleChange:FireServer(CFrame.new(1,.56,-s))
	end
	end
})
Tab1:AddBind({
	Name = "Slider Reset",
	Default = Enum.KeyCode.RightBracket,
	Hold = false,
	Callback = function()
		Slider1:Set(0)
		Slider2:Set(0)
		meow:Set(0)
		wait(.1)
	    for _,player in ipairs(game.Players:GetPlayers()) do
        player.Character.ArmAngleChange:FireServer(CFrame.new(1, .56, 0, 0, .01, .1, 0, 0, 0, 0, 0, 1))
	end
end
})


    elseif message == "Launch Test Yield" then
        loadstring(game:HttpGet('https://pastebin.com/raw/gvDkEHHg'))()
    elseif message == "Rejoin" then
        loadstring(game:HttpGet("https://pastebin.com/raw/1gtVMUz3"))()
    end
end
workspace.Camera.FieldOfView = 90

player.Chatted:Connect(onChat)
  	end    
})
MiscTab:AddButton({
	Name = "Animation Gui (AG)",
	Callback = function()
        local AnimationChanger = Instance.new("ScreenGui")
        local Main = Instance.new("Frame")
        local TopBar = Instance.new("Frame")
        local Close = Instance.new("TextButton")
        local TextLabel = Instance.new("TextLabel")
        local TextLabel_2 = Instance.new("TextLabel")
        local NormalTab = Instance.new("Frame")
        local A_Astronaut = Instance.new("TextButton")
        local A_Bubbly = Instance.new("TextButton")
        local A_Cartoony = Instance.new("TextButton")
        local A_Elder = Instance.new("TextButton")
        local A_Knight = Instance.new("TextButton")
        local A_Levitation = Instance.new("TextButton")
        local A_Mage = Instance.new("TextButton")
        local A_Ninja = Instance.new("TextButton")
        local A_Pirate = Instance.new("TextButton")
        local A_Robot = Instance.new("TextButton")
        local A_Stylish = Instance.new("TextButton")
        local A_SuperHero = Instance.new("TextButton")
        local A_Toy = Instance.new("TextButton")
        local A_Vampire = Instance.new("TextButton")
        local A_Werewolf = Instance.new("TextButton")
        local A_Zombie = Instance.new("TextButton")
        local Category = Instance.new("TextLabel")
        local SpecialTab = Instance.new("Frame")
        local A_Patrol = Instance.new("TextButton")
        local A_Confident = Instance.new("TextButton")
        local A_Popstar = Instance.new("TextButton")
        local A_Cowboy = Instance.new("TextButton")
        local A_Ghost = Instance.new("TextButton")
        local A_Sneaky = Instance.new("TextButton")
        local A_Princess = Instance.new("TextButton")
        local Category_2 = Instance.new("TextLabel")
        local OtherTab = Instance.new("Frame")
        local Category_3 = Instance.new("TextLabel")
        local A_None = Instance.new("TextButton")
        local A_Anthro = Instance.new("TextButton")
        local Animate = game.Players.LocalPlayer.Character.Animate
         
        AnimationChanger.Name = "AnimationChanger"
        AnimationChanger.Parent = game:WaitForChild("CoreGui")
        AnimationChanger.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
         
        Main.Name = "Main"
        Main.Parent = AnimationChanger
        Main.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0.421999991, 0, -1, 0)
        Main.Size = UDim2.new(0, 300, 0, 250)
        Main.Active = true
        Main.Draggable = true
         
        TopBar.Name = "TopBar"
        TopBar.Parent = Main
        TopBar.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        TopBar.BorderSizePixel = 0
        TopBar.Size = UDim2.new(0, 300, 0, 30)
         
        Close.Name = "Close"
        Close.Parent = TopBar
        Close.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        Close.BorderSizePixel = 0
        Close.Position = UDim2.new(0.899999976, 0, 0, 0)
        Close.Size = UDim2.new(0, 30, 0, 30)
        Close.Font = Enum.Font.SciFi
        Close.Text = "x"
        Close.TextColor3 = Color3.new(1, 0, 0.0156863)
        Close.TextSize = 20
        Close.MouseButton1Click:Connect(function()
            wait(0.3)
            Main:TweenPosition(UDim2.new(0.421999991, 0, -1.28400004, 0))
            wait(3)
            AnimationChanger:Destroy()
        end)
         
        TextLabel.Parent = TopBar
        TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0, 0, 0.600000024, 0)
        TextLabel.Size = UDim2.new(0, 270, 0, 10)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = "Made by voxrqz"
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.TextSize = 15
         
        TextLabel_2.Parent = TopBar
        TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
        TextLabel_2.BackgroundTransparency = 1
        TextLabel_2.BorderSizePixel = 0
        TextLabel_2.Position = UDim2.new(0, 0, -0.0266667679, 0)
        TextLabel_2.Size = UDim2.new(0, 270, 0, 20)
        TextLabel_2.Font = Enum.Font.SourceSans
        TextLabel_2.Text = "Animation Changer"
        TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
        TextLabel_2.TextSize = 20
         
        NormalTab.Name = "NormalTab"
        NormalTab.Parent = Main
        NormalTab.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
        NormalTab.BackgroundTransparency = 1
        NormalTab.BorderSizePixel = 0
        NormalTab.Position = UDim2.new(0.5, 0, 0.119999997, 0)
        NormalTab.Size = UDim2.new(0, 150, 0, 500)
         
        A_Astronaut.Name = "A_Astronaut"
        A_Astronaut.Parent = NormalTab
        A_Astronaut.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Astronaut.BorderSizePixel = 0
        A_Astronaut.Position = UDim2.new(0, 0, 0.815764725, 0)
        A_Astronaut.Size = UDim2.new(0, 150, 0, 30)
        A_Astronaut.Font = Enum.Font.SciFi
        A_Astronaut.Text = "Astronaut"
        A_Astronaut.TextColor3 = Color3.new(1, 1, 1)
        A_Astronaut.TextSize = 20
        A_Astronaut.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=891621366"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=891633237"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=891667138"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=891636393"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=891627522"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=891609353"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=891617961"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Bubbly.Name = "A_Bubbly"
        A_Bubbly.Parent = NormalTab
        A_Bubbly.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Bubbly.BorderSizePixel = 0
        A_Bubbly.Position = UDim2.new(0, 0, 0.349019617, 0)
        A_Bubbly.Size = UDim2.new(0, 150, 0, 30)
        A_Bubbly.Font = Enum.Font.SciFi
        A_Bubbly.Text = "Bubbly"
        A_Bubbly.TextColor3 = Color3.new(1, 1, 1)
        A_Bubbly.TextSize = 20
        A_Bubbly.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=910004836"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=910009958"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=910034870"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=910025107"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=910016857"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=910001910"
        Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=910030921"
        Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=910028158"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Cartoony.Name = "A_Cartoony"
        A_Cartoony.Parent = NormalTab
        A_Cartoony.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Cartoony.BorderSizePixel = 0
        A_Cartoony.Position = UDim2.new(0, 0, 0.407272667, 0)
        A_Cartoony.Size = UDim2.new(0, 150, 0, 30)
        A_Cartoony.Font = Enum.Font.SciFi
        A_Cartoony.Text = "Cartoony"
        A_Cartoony.TextColor3 = Color3.new(1, 1, 1)
        A_Cartoony.TextSize = 20
        A_Cartoony.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Elder.Name = "A_Elder"
        A_Elder.Parent = NormalTab
        A_Elder.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Elder.BorderSizePixel = 0
        A_Elder.Position = UDim2.new(6.51925802e-09, 0, 0.636310041, 0)
        A_Elder.Size = UDim2.new(0, 150, 0, 30)
        A_Elder.Font = Enum.Font.SciFi
        A_Elder.Text = "Elder"
        A_Elder.TextColor3 = Color3.new(1, 1, 1)
        A_Elder.TextSize = 20
        A_Elder.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Knight.Name = "A_Knight"
        A_Knight.Parent = NormalTab
        A_Knight.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Knight.BorderSizePixel = 0
        A_Knight.Position = UDim2.new(0, 0, 0.52352941, 0)
        A_Knight.Size = UDim2.new(0, 150, 0, 30)
        A_Knight.Font = Enum.Font.SciFi
        A_Knight.Text = "Knight"
        A_Knight.TextColor3 = Color3.new(1, 1, 1)
        A_Knight.TextSize = 20
        A_Knight.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Levitation.Name = "A_Levitation"
        A_Levitation.Parent = NormalTab
        A_Levitation.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Levitation.BorderSizePixel = 0
        A_Levitation.Position = UDim2.new(0, 0, 0.115472436, 0)
        A_Levitation.Size = UDim2.new(0, 150, 0, 30)
        A_Levitation.Font = Enum.Font.SciFi
        A_Levitation.Text = "Levitation"
        A_Levitation.TextColor3 = Color3.new(1, 1, 1)
        A_Levitation.TextSize = 20
        A_Levitation.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Mage.Name = "A_Mage"
        A_Mage.Parent = NormalTab
        A_Mage.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Mage.BorderSizePixel = 0
        A_Mage.Position = UDim2.new(0, 0, 0.696203232, 0)
        A_Mage.Size = UDim2.new(0, 150, 0, 30)
        A_Mage.Font = Enum.Font.SciFi
        A_Mage.Text = "Mage"
        A_Mage.TextColor3 = Color3.new(1, 1, 1)
        A_Mage.TextSize = 20
        A_Mage.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Ninja.Name = "A_Ninja"
        A_Ninja.Parent = NormalTab
        A_Ninja.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Ninja.BorderSizePixel = 0
        A_Ninja.Position = UDim2.new(0, 0, 0.0597896464, 0)
        A_Ninja.Size = UDim2.new(0, 150, 0, 30)
        A_Ninja.Font = Enum.Font.SciFi
        A_Ninja.Text = "Ninja"
        A_Ninja.TextColor3 = Color3.new(1, 1, 1)
        A_Ninja.TextSize = 20
        A_Ninja.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Pirate.Name = "A_Pirate"
        A_Pirate.Parent = NormalTab
        A_Pirate.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Pirate.BorderSizePixel = 0
        A_Pirate.Position = UDim2.new(-0.000333309174, 0, 0.874588311, 0)
        A_Pirate.Size = UDim2.new(0, 150, 0, 30)
        A_Pirate.Font = Enum.Font.SciFi
        A_Pirate.Text = "Pirate"
        A_Pirate.TextColor3 = Color3.new(1, 1, 1)
        A_Pirate.TextSize = 20
        A_Pirate.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Robot.Name = "A_Robot"
        A_Robot.Parent = NormalTab
        A_Robot.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Robot.BorderSizePixel = 0
        A_Robot.Position = UDim2.new(0, 0, 0.291479498, 0)
        A_Robot.Size = UDim2.new(0, 150, 0, 30)
        A_Robot.Font = Enum.Font.SciFi
        A_Robot.Text = "Robot"
        A_Robot.TextColor3 = Color3.new(1, 1, 1)
        A_Robot.TextSize = 20
        A_Robot.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616088211"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616089559"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616095330"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616091570"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616090535"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616086039"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616087089"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Stylish.Name = "A_Stylish"
        A_Stylish.Parent = NormalTab
        A_Stylish.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Stylish.BorderSizePixel = 0
        A_Stylish.Position = UDim2.new(0, 0, 0.232816339, 0)
        A_Stylish.Size = UDim2.new(0, 150, 0, 30)
        A_Stylish.Font = Enum.Font.SciFi
        A_Stylish.Text = "Stylish"
        A_Stylish.TextColor3 = Color3.new(1, 1, 1)
        A_Stylish.TextSize = 20
        A_Stylish.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616136790"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616138447"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616146177"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616140816"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616139451"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616133594"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616134815"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_SuperHero.Name = "A_SuperHero"
        A_SuperHero.Parent = NormalTab
        A_SuperHero.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_SuperHero.BorderSizePixel = 0
        A_SuperHero.Position = UDim2.new(0, 0, 0.464919746, 0)
        A_SuperHero.Size = UDim2.new(0, 150, 0, 30)
        A_SuperHero.Font = Enum.Font.SciFi
        A_SuperHero.Text = "SuperHero"
        A_SuperHero.TextColor3 = Color3.new(1, 1, 1)
        A_SuperHero.TextSize = 20
        A_SuperHero.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Toy.Name = "A_Toy"
        A_Toy.Parent = NormalTab
        A_Toy.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Toy.BorderSizePixel = 0
        A_Toy.Position = UDim2.new(6.51925802e-09, 0, 0.756028414, 0)
        A_Toy.Size = UDim2.new(0, 150, 0, 30)
        A_Toy.Font = Enum.Font.SciFi
        A_Toy.Text = "Toy"
        A_Toy.TextColor3 = Color3.new(1, 1, 1)
        A_Toy.TextSize = 20
        A_Toy.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Vampire.Name = "A_Vampire"
        A_Vampire.Parent = NormalTab
        A_Vampire.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Vampire.BorderSizePixel = 0
        A_Vampire.Position = UDim2.new(0, 0, 0.934021354, 0)
        A_Vampire.Size = UDim2.new(0, 150, 0, 30)
        A_Vampire.Font = Enum.Font.SciFi
        A_Vampire.Text = "Vampire"
        A_Vampire.TextColor3 = Color3.new(1, 1, 1)
        A_Vampire.TextSize = 20
        A_Vampire.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Werewolf.Name = "A_Werewolf"
        A_Werewolf.Parent = NormalTab
        A_Werewolf.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Werewolf.BorderSizePixel = 0
        A_Werewolf.Position = UDim2.new(-0.000333368778, 0, 0.174509808, 0)
        A_Werewolf.Size = UDim2.new(0, 150, 0, 30)
        A_Werewolf.Font = Enum.Font.SciFi
        A_Werewolf.Text = "Werewolf"
        A_Werewolf.TextColor3 = Color3.new(1, 1, 1)
        A_Werewolf.TextSize = 20
        A_Werewolf.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083178339"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083216690"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083189019"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Zombie.Name = "A_Zombie"
        A_Zombie.Parent = NormalTab
        A_Zombie.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Zombie.BorderSizePixel = 0
        A_Zombie.Position = UDim2.new(-1.1920929e-07, 0, 0.582352936, 0)
        A_Zombie.Size = UDim2.new(0, 150, 0, 30)
        A_Zombie.Font = Enum.Font.SciFi
        A_Zombie.Text = "Zombie"
        A_Zombie.TextColor3 = Color3.new(1, 1, 1)
        A_Zombie.TextSize = 20
        A_Zombie.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        Category.Name = "Category"
        Category.Parent = NormalTab
        Category.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Category.BorderSizePixel = 0
        Category.Size = UDim2.new(0, 150, 0, 30)
        Category.Text = "Normal"
        Category.TextColor3 = Color3.new(0, 0.835294, 1)
        Category.TextSize = 14
         
        SpecialTab.Name = "SpecialTab"
        SpecialTab.Parent = Main
        SpecialTab.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
        SpecialTab.BackgroundTransparency = 1
        SpecialTab.BorderSizePixel = 0
        SpecialTab.Position = UDim2.new(0, 0, 0.119999997, 0)
        SpecialTab.Size = UDim2.new(0, 150, 0, 230)
         
        A_Patrol.Name = "A_Patrol"
        A_Patrol.Parent = SpecialTab
        A_Patrol.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Patrol.BorderSizePixel = 0
        A_Patrol.Position = UDim2.new(0, 0, 0.259960413, 0)
        A_Patrol.Size = UDim2.new(0, 150, 0, 30)
        A_Patrol.Font = Enum.Font.SciFi
        A_Patrol.Text = "Patrol"
        A_Patrol.TextColor3 = Color3.new(1, 1, 1)
        A_Patrol.TextSize = 20
        A_Patrol.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1149612882"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1150842221"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1151231493"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1150967949"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1148811837"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1148811837"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1148863382"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Confident.Name = "A_Confident"
        A_Confident.Parent = SpecialTab
        A_Confident.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Confident.BorderSizePixel = 0
        A_Confident.Position = UDim2.new(0, 0, 0.389248967, 0)
        A_Confident.Size = UDim2.new(0, 150, 0, 30)
        A_Confident.Font = Enum.Font.SciFi
        A_Confident.Text = "Confident"
        A_Confident.TextColor3 = Color3.new(1, 1, 1)
        A_Confident.TextSize = 20
        A_Confident.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1069977950"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1069987858"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1070017263"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1070001516"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1069984524"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1069946257"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1069973677"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Popstar.Name = "A_Popstar"
        A_Popstar.Parent = SpecialTab
        A_Popstar.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Popstar.BorderSizePixel = 0
        A_Popstar.Position = UDim2.new(0, 0, 0.130671918, 0)
        A_Popstar.Size = UDim2.new(0, 150, 0, 30)
        A_Popstar.Font = Enum.Font.SciFi
        A_Popstar.Text = "Popstar"
        A_Popstar.TextColor3 = Color3.new(1, 1, 1)
        A_Popstar.TextSize = 20
        A_Popstar.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1212900985"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1150842221"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980338"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980348"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1212954642"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1213044953"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1212900995"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Cowboy.Name = "A_Cowboy"
        A_Cowboy.Parent = SpecialTab
        A_Cowboy.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Cowboy.BorderSizePixel = 0
        A_Cowboy.Position = UDim2.new(0, 0, 0.772964239, 0)
        A_Cowboy.Size = UDim2.new(0, 150, 0, 30)
        A_Cowboy.Font = Enum.Font.SciFi
        A_Cowboy.Text = "Cowboy"
        A_Cowboy.TextColor3 = Color3.new(1, 1, 1)
        A_Cowboy.TextSize = 20
        A_Cowboy.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1014390418"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1014398616"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1014421541"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1014401683"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1014394726"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1014380606"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1014384571"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Ghost.Name = "A_Ghost"
        A_Ghost.Parent = SpecialTab
        A_Ghost.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Ghost.BorderSizePixel = 0
        A_Ghost.Position = UDim2.new(0, 0, 0.900632322, 0)
        A_Ghost.Size = UDim2.new(0, 150, 0, 30)
        A_Ghost.Font = Enum.Font.SciFi
        A_Ghost.Text = "Ghost"
        A_Ghost.TextColor3 = Color3.new(1, 1, 1)
        A_Ghost.TextSize = 20
        A_Ghost.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
        Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=616012453"
        Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=616011509"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Sneaky.Name = "A_Sneaky"
        A_Sneaky.Parent = SpecialTab
        A_Sneaky.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Sneaky.BorderSizePixel = 0
        A_Sneaky.Position = UDim2.new(0, 0, 0.517628431, 0)
        A_Sneaky.Size = UDim2.new(0, 150, 0, 30)
        A_Sneaky.Font = Enum.Font.SciFi
        A_Sneaky.Text = "Sneaky"
        A_Sneaky.TextColor3 = Color3.new(1, 1, 1)
        A_Sneaky.TextSize = 20
        A_Sneaky.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1132473842"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1132477671"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1132510133"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1132494274"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1132489853"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1132461372"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1132469004"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Princess.Name = "A_Princess"
        A_Princess.Parent = SpecialTab
        A_Princess.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Princess.BorderSizePixel = 0
        A_Princess.Position = UDim2.new(0, 0, 0.645296335, 0)
        A_Princess.Size = UDim2.new(0, 150, 0, 30)
        A_Princess.Font = Enum.Font.SciFi
        A_Princess.Text = "Princess"
        A_Princess.TextColor3 = Color3.new(1, 1, 1)
        A_Princess.TextSize = 20
        A_Princess.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=941003647"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=941013098"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=941028902"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=941015281"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=941008832"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=940996062"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=941000007"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        Category_2.Name = "Category"
        Category_2.Parent = SpecialTab
        Category_2.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Category_2.BorderSizePixel = 0
        Category_2.Size = UDim2.new(0, 150, 0, 30)
        Category_2.Text = "Special"
        Category_2.TextColor3 = Color3.new(0, 0.835294, 1)
        Category_2.TextSize = 14
         
        OtherTab.Name = "OtherTab"
        OtherTab.Parent = Main
        OtherTab.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
        OtherTab.BackgroundTransparency = 1
        OtherTab.BorderSizePixel = 0
        OtherTab.Position = UDim2.new(0, 0, 1.06800008, 0)
        OtherTab.Size = UDim2.new(0, 150, 0, 220)
         
        Category_3.Name = "Category"
        Category_3.Parent = OtherTab
        Category_3.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Category_3.BorderSizePixel = 0
        Category_3.Size = UDim2.new(0, 150, 0, 30)
        Category_3.Text = "Other"
        Category_3.TextColor3 = Color3.new(0, 0.835294, 1)
        Category_3.TextSize = 14
         
        A_None.Name = "A_None"
        A_None.Parent = OtherTab
        A_None.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_None.BorderSizePixel = 0
        A_None.Position = UDim2.new(0, 0, 0.134545445, 0)
        A_None.Size = UDim2.new(0, 150, 0, 30)
        A_None.Font = Enum.Font.SciFi
        A_None.Text = "None"
        A_None.TextColor3 = Color3.new(1, 1, 1)
        A_None.TextSize = 20
        A_None.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=0"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        A_Anthro.Name = "A_Anthro"
        A_Anthro.Parent = OtherTab
        A_Anthro.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
        A_Anthro.BorderSizePixel = 0
        A_Anthro.Position = UDim2.new(0, 0, 0.269090891, 0)
        A_Anthro.Size = UDim2.new(0, 150, 0, 30)
        A_Anthro.Font = Enum.Font.SciFi
        A_Anthro.Text = "Anthro (Default)"
        A_Anthro.TextColor3 = Color3.new(1, 1, 1)
        A_Anthro.TextSize = 20
        A_Anthro.MouseButton1Click:Connect(function()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=2510196951"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=2510197257"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=2510202577"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=2510198475"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=2510197830"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=2510192778"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=2510195892"
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
         
        wait(1)
        Main:TweenPosition(UDim2.new(0.421999991, 0, 0.28400004, 0))
  	end    
})
MiscTab:AddButton({
	Name = "Infinite Yield (IY)",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
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

GlobalTab:AddLabel("AutoSound (VERY LOUD)")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local autoSoundEnabled = false
local connection  

GlobalTab:AddToggle({ 
    Name = "AutoSound", 
    Default = false,
    Callback = function(Value)
        autoSoundEnabled = Value  

        if autoSoundEnabled then
            connection = RunService.Heartbeat:Connect(function()
                local Event = player.Character and player.Character:FindFirstChild("Damage")
                if Event then
                    Event:FireServer()
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end    
})

GlobalTab:AddLabel("Customize")

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


OrionLib:Init()
