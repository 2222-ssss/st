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

MTab:AddButton({
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
                game:GetService("Workspace")[v.Name].ArmAngleChange:FireServer(CFrame.new(-999, -999, -999))
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


MTab:AddTextbox({
	Name = "Target",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players:Chat('/kill '..Value)
	end	  
})

MTab:AddButton({
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

MiscTab:AddLabel("LagServer (Picking)")
MiscTab:AddToggle({
    Name = "LagServer",
    Default = false,
    Callback = function(Value)
        if Value then
            local A_1 = Workspace.Map.Map.Pickable.VendingMachine.Model
            if not A_1 then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        A_1 = v.Character.HumanoidRootPart
                        break
                    end
                end
                if not A_1 then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Part") then
                            A_1 = obj
                            break
                        end
                    end
                end
            end
            local A_2 = Vector3.new(-1, -1, -1)
            local Event = plr.Picking
            Event:FireServer(A_1, A_2)
            wait(0.1)
            plr.Character.PuttingDown:FireServer()
        end
    end
})

local mouse = plr:GetMouse()
local lagServerToggle = false

local function lagServer()
    while lagServerToggle do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("Picked") and not plr.Character.Picked.Value then
                plr.Character.Picking:FireServer(mouse.Target, mouse.Hit.p)
            else
                plr.Character.PuttingDown:FireServer()
            end
        end)
        wait()
    end
end

MiscTab:AddToggle({
    Name = "LagServer (Picks Everywhere)",
    Default = false,
    Callback = function(Value)
        lagServerToggle = Value
        if lagServerToggle then
            spawn(lagServer)
        end
    end
})

MiscTab:AddLabel("Arm Controls")
local Slider1 = MiscTab:AddSlider({
    Name = "Arm Height",
    Min = 0,
    Max = 5000,
    Default = 0,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = .5,
    ValueName = " ",
    Callback = function(s)
        plr.Character.ArmAngleChange:FireServer(CFrame.new(1, s, 0))
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
        plr.Character.ArmAngleChange:FireServer(CFrame.new(1, s, -s))
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
        plr.Character.ArmAngleChange:FireServer(CFrame.new(1, 0.56, -s))
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
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ArmAngleChange") then
                player.Character.ArmAngleChange:FireServer(CFrame.new(1, 0.56, 0, 0, 0.01, 0.1, 0, 0, 0, 0, 0, 1))
            end
        end
    end
})


MiscTab:AddLabel("Players")

MiscTab:AddToggle({
    Name = "Arm Fly (Others)",
    Default = false,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.ArmAngleChange:FireServer(CFrame.new(1, .56, 0, 0, 0, 0, 3.5, 1, -18, 0, 0, 1))

        local speed = 5
        local height = 5
        local radius = 5
        local angle = 0
        
        while Value do
            local arm = game.Players.LocalPlayer.Character:FindFirstChild("Right Arm")
            if arm then
                angle = angle + speed * 0.1
                local x = radius * math.cos(math.rad(angle))
                local y = height * math.sin(math.rad(angle))
                local z = radius * math.sin(math.rad(angle))
                arm.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
            end
            wait(0.03)
        end
    end    
})

MiscTab:AddToggle({
    Name = "Arm Fly (Myself)",
    Default = false,
    Callback = function(Value)
        local speed = 5
        local height = 5
        local radius = 5
        local angle = 0
        
        while Value do
            local arm = game.Players.LocalPlayer.Character:FindFirstChild("Right Arm")
            if arm then
                angle = angle + speed * 0.1
                local x = radius * math.cos(math.rad(angle))
                local y = height * math.sin(math.rad(angle))
                local z = radius * math.sin(math.rad(angle))
                arm.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
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
