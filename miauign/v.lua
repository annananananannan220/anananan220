-- START SCRIPT

repeat
    task.wait()
until game:IsLoaded()

if not getgenv().ScriptLoaded then
    getgenv().ScriptLoaded = true
    print("Script Loaded")
    
    -- Init --
    pcall(setsimulationradius, 1000)
    local DiscordPing = "<@{DISCORD}>"
    local SetBoss = "{SETBOSS}"
    print(SetBoss)
    
    local StartTime = tick()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local RS, TS, TP, Debris, HTTP = game:GetService("ReplicatedStorage"), game:GetService("TweenService"),
        game:GetService("TeleportService"), game:GetService("Debris"), game:GetService("HttpService")
    local ServerRemotes = RS:WaitForChild("Remotes"):WaitForChild("Server")
    local ClientRemotes = RS:WaitForChild("Remotes"):WaitForChild("Client")

    -- Webhook
    pcall(function()
        if getgenv().Webhook then
            writefile("JJI_Webhook.txt", getgenv().Webhook)
        end
        if readfile("JJI_Webhook.txt") then
            getgenv().Webhook = readfile("JJI_Webhook.txt")
        end
        if getgenv().Webhook:find("https://discord.com/api/webhooks") then
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end)

    -- Constants
    local Domainable = {"Ocean Curse", "Soul Curse", "Heian Imaginary Demon"}
    local LuckTable = {
        Cats = {
            [1] = "Polished Beckoning Cat",
            [2] = "Wooden Beckoning Cat",
            [3] = "Withered Beckoning Cat"
        },
        OneTime = {
            [1] = "Fortune Gourd",
            [2] = "Snake Charm",
            [3] = "Luck Vial",
            [4] = "Dumplings"
        }
    }

    local BossDrops = {
        ["Finger Bearer"] = "Cursed Fragment",
        ["Ocean Curse"] = "Cursed Tentacle",
        ["Volcano Curse"] = "Volcanic Ash",
        ["Soul Curse"] = "Transfigured Human",
        ["Sorcerer Killer"] = "Heavenly Chains",
        ["Heian Imaginary Demon"] = "Demon Blob",
    }

    local BossMaterials = {"Cursed Fragment", "Cursed Tentacle", "Volcanic Ash", "Transfigured Human", "Heavenly Chains", "Demon Blob"}

    -- Black screen check & Fail safe --
    if {CURSEMARKET_INDEX} ~= -1 then
        pcall(function()
            for i = 1, {CURSEMARKET_COUNT}, 1 do
                ServerRemotes:WaitForChild("Data"):WaitForChild("MarketExchange"):InvokeServer(RS:WaitForChild("CurseMarket"):FindFirstChild("{CURSEMARKET_INDEX}"))
                print("Exchange:", i)
                task.wait(1)
            end
        end)
    end

    task.spawn(function()
        task.wait(120)
        while task.wait(10) do
            TP:Teleport(119359147980471)
        end
    end)

    if game.PlaceId == 10450270085 then
        task.spawn(function()
            while task.wait(10) do
                TP:Teleport(119359147980471)
            end
        end)
    elseif game.PlaceId == 119359147980471 then
        local SelectedBoss = "Heian Imaginary Demon"
        pcall(function()
            if readfile("JJI_LastBoss.txt") then
                SelectedBoss = readfile("JJI_LastBoss.txt")
            end
        end)
        task.wait(3)
        while task.wait(1) do
            ServerRemotes:WaitForChild("Raids"):WaitForChild("QuickStart"):InvokeServer("Boss", SelectedBoss, 4, "Nightmare")
        end
    end

    repeat
        task.wait()
    until LocalPlayer.Character

    local Character = LocalPlayer.Character
    local Root = Character:WaitForChild("HumanoidRootPart")
    Root.ChildAdded:Connect(function(C)
        if table.find({"BodyVelocity", "BodyPosition", "BodyGyro", "BodyForce"}, C.ClassName) and
            not table.find({"BGyro", "BVelocity", "BPosition"}, C.Name) then
            Debris:AddItem(C, 0)
        end
    end)

    local Objects = workspace:WaitForChild("Objects")
    local Mobs = Objects:WaitForChild("Mobs")
    local Spawns = Objects:WaitForChild("Spawns")
    local Drops = Objects:WaitForChild("Drops")
    local Effects = Objects:WaitForChild("Effects")
    local Destructibles = Objects:WaitForChild("Destructibles")

    local LootUI = LocalPlayer.PlayerGui:WaitForChild("Loot")
    local Flip = LootUI:WaitForChild("Frame"):WaitForChild("Flip")
    local Replay = LocalPlayer.PlayerGui:WaitForChild("ReadyScreen"):WaitForChild("Frame"):WaitForChild("Replay")

    local Combat = ServerRemotes:WaitForChild("Combat")
    
    -- Destroy fx --
    Effects.ChildAdded:Connect(function(Child)
        if not table.find({"DomainSphere", "DomainInitiate"}, Child.Name) then
            Debris:AddItem(Child, 0)
        end
    end)

    game:GetService("Lighting").ChildAdded:Connect(function(Child)
        Debris:AddItem(Child, 0)
    end)

    Destructibles.ChildAdded:Connect(function(Child)
        Debris:AddItem(Child, 0)
    end)

    -- Uh, ignore this spaghetti way of determining screen center --
    local MouseTarget = Instance.new("Frame", LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui"))
    MouseTarget.Size = UDim2.new(0, 0, 0, 0)
    MouseTarget.Position = UDim2.new(0.5, 0, 0.5, 0)
    MouseTarget.AnchorPoint = Vector2.new(0.5, 0.5)
    local X, Y = MouseTarget.AbsolutePosition.X, MouseTarget.AbsolutePosition.Y

    -- Funcs --
    local function Godmode(State)
        Combat:WaitForChild("ToggleMenu"):FireServer(State)
        if State then
            Character:WaitForChild("ForceField").Visible = false -- Just for show, if anyone were to record a video
        end
    end

    local SkillDB = {}
    local function Skill(Name, Raw)
        if Raw then
            Combat:WaitForChild("Skill"):FireServer(Name)
        else
            if not table.find(SkillDB, Name) then
                task.spawn(function()
                    table.insert(SkillDB, Name)
                    print(RS.Skills:FindFirstChild(Name).Cooldown.Value)
                    task.wait(RS.Skills:FindFirstChild(Name).Cooldown.Value)
                    table.remove(SkillDB, table.find(SkillDB, Name))
                end)
                print("Used Skill:", Name)
                repeat task.wait() until not Character.Torso:FindFirstChild("RagdollAttachment")
                Combat:WaitForChild("Skill"):FireServer(Name)
            end
        end
    end

    local function DetermineLuckBoosts()
        local Boosts = {}
        local Inventory = LocalPlayer.ReplicatedData.inventory
        if LocalPlayer.ReplicatedData.luckBoost.duration.Value == 0 then
            for i, v in LuckTable.Cats do
                if Inventory:FindFirstChild(v) then
                    if Inventory[v].Value > 5 then
                        table.insert(Boosts, v)
                        break
                    end
                end
            end
        end
        for i, v in LuckTable.OneTime do
            if Inventory:FindFirstChild(v) then
                if Inventory[v].Value > 5 then
                    table.insert(Boosts, v)
                end
            end
        end
        return Boosts
    end

    local function OpenChest()
        for i, v in ipairs(Drops:GetChildren()) do
            if v:FindFirstChild("Collect") then
                fireproximityprompt(v.Collect)
            end
        end
    end

    local function InCutscene()
        return workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
    end

    local function Hit()
        if not (Character.Torso:FindFirstChild("RagdollAttachment") or InCutscene()) then
            Combat.ApplyBlackFlashToNextHitbox:FireServer(1)
            task.wait(0.1)
            Combat:WaitForChild("M2"):FireServer(2)
        else
            print("Paused")
        end
    end

    local function Click(Button)
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.Size = UDim2.new(50, 0, 50, 0)
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.ZIndex = 20
        Button.ImageTransparency = 1
        for i, v in ipairs(Button:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(X, Y, 0, true, game, 0)
        task.wait()
        VIM:SendMouseButtonEvent(X, Y, 0, false, game, 0)
        task.wait()
    end

    local BP, BV, BG = function(I, P, Prop, Deriv)
        local BP = I:FindFirstChild("BPosition")
        if not BP then
            BP = Instance.new("BodyPosition")
            BP.Position = P
            BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BP.P = 3000
            BP.D = 500
            BP.Name = "BPosition"
            if Prop and Deriv then
                BP.P = Prop
                BP.D = Deriv
            end
            BP.Parent = I
        else
            BP.Position = P
        end
    end, function(I, V, Prop, Deriv)
        local BV = I:FindFirstChild("BVelocity")
        if not BV then
            BV = Instance.new("BodyVelocity")
            BV.Velocity = V
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BV.Name = "BVelocity"
            BV.Parent = I
        else
            BV.Velocity = V
        end
    end, function(I, C, Prop, Deriv)
        local BG = I:FindFirstChild("BGyro")
        if not BG then
            BG = Instance.new("BodyGyro")
            BG.CFrame = C
            BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BG.Name = "BGyro"
            BG.P = 3000
            BG.D = 100
            BG.Parent = I
        else
            BG.CFrame = C
        end
    end

    local function Target(Character)
        local Name = Character.Name
        local S, E = pcall(function()
            ClientRemotes:WaitForChild("GetClosestTarget").OnClientInvoke = function()
                if Mobs:FindFirstChild(Name) then
                    return Character.Humanoid
                else
                    return nil
                end
            end
            ClientRemotes:WaitForChild("GetMouse").OnClientInvoke = function()
                return {
                    Hit = Character.PrimaryPart.CFrame,
                    Target = nil, 
                    UnitRay = CFrame.new(Root.Position, Character.PrimaryPart.Position).LookVector
                }
            end
        end)
    end

    local function AnalyseInventory()
        local MaterialAmount, Sorted = {}, {}
        local AllFull = true
        local Inventory = LocalPlayer.ReplicatedData.inventory
        table.foreach(BossMaterials, function(_, v) MaterialAmount[v] = 0 end)
        table.foreach(Inventory:GetChildren(), function(_, v) if table.find(BossMaterials, v.Name) then MaterialAmount[v.Name] = v.Value end end)
        table.foreach(MaterialAmount, function(i, v) 
            if v ~= 999 then AllFull = false end 
            table.insert(Sorted, {i, v})
        end)
        if AllFull then return "Cursed Fragment" end
        table.sort(Sorted, function(a, b) return a[2] > b[2] end)
        return Sorted[#Sorted][1]
    end

    -- Farm start --
    local ScriptLoading = tostring(math.floor((tick() - StartTime) * 10) / 10)
    local LuckBoosts = DetermineLuckBoosts()
    Skill("Demon Vessel: Switch")
    local InitialTween = TS:Create(Root, TweenInfo.new(1), {
        CFrame = Spawns.BossSpawn.CFrame
    })
    InitialTween:Play()
    InitialTween.Completed:Wait()
    BV(Character.Torso, Vector3.new(0, 0, 0))

    repeat
        task.wait()
    until Mobs:FindFirstChildWhichIsA("Model")
    local Boss = Mobs:FindFirstChildWhichIsA("Model").Name

    -- Use buffs & save last boss --
    local Overwritten = false
    task.spawn(function()
        for i, v in pairs({"Damage Vial", "Damage Gourd", "Rage Gourd"}) do
            ServerRemotes:WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(v)
            task.wait()
        end
        for i, v in pairs(LuckBoosts) do
            ServerRemotes:WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(v)
            print("Used Luck Boost", v)
            task.wait()
        end
        local S, E = pcall(function()
            writefile("JJI_LastBoss.txt", Boss)
            Overwritten = true
        end)
        if not S then
            print("Last boss config saving failed:", E)
        end
    end)

    -- Update curse market data and inventory
    task.spawn(function()
        local S, E = pcall(function()
            local Inventory, SpecialGrades, Message, Empty = LocalPlayer.ReplicatedData.inventory, {}, "", true
            local Legendary = {"Demon Finger", "Demon Blob", "Cursed Tentacle", "Cursed Fragment", "Volcanic Ash", "Transfigured Human", "Heavenly Chains"}
            for _, v in Inventory:GetChildren() do
                local Item = v.Name
                if Item:find("|") and not Item:find("Title") then
                    Item = Item:match("^(.-)|")
                    if SpecialGrades[Item] then
                        SpecialGrades[Item] = SpecialGrades[Item] + 1
                    else
                        SpecialGrades[Item] = 1
                    end
                    Empty = false
                elseif table.find(Legendary, Item) then
                    SpecialGrades[Item] = v.Value
                    Empty = false
                end
            end
            if Empty then SpecialGrades = {Drops = 0} end
            local Data = game:GetService("HttpService"):JSONEncode({
                Key = "{KEY}",
                Username = LocalPlayer.Name,
                Inventory = SpecialGrades
            })
        end)

        if SetBoss ~= "X" then
            pcall(function()
                repeat task.wait() until Overwritten
                task.wait(0.5)
                writefile("JJI_LastBoss.txt", SetBoss)
            end)
            if Boss ~= SetBoss then
                while task.wait(10) do
                    TP:Teleport(10450270085)
                end
            end
        end

        local S, E = pcall(function()
            local Data = game:GetService("HttpService"):JSONEncode({
                Key = "{KEY}",
                Username = LocalPlayer.Name,
                ["Boss"] = Boss
            })
            print(Data)
        end)
        
    end)

    -- Value spoofing --
    ClientRemotes:WaitForChild("GetFocus").OnClientInvoke = function() return 3 end
    ClientRemotes:WaitForChild("GetDomainMeter").OnClientInvoke = function() return 100 end
    ClientRemotes:WaitForChild("GetBlackFlashCombo").OnClientInvoke = function() return 3 end
    Target(Mobs[Boss]) -- Aimbot
    
    -- Prevent boss from using domain -- 
    if table.find(Domainable, Boss) then
        repeat
            Skill("Incomplete Domain", true)
            task.wait(0.5)
        until Effects:FindFirstChild("DomainInitiate")
        repeat task.wait() until Effects:FindFirstChild("DomainSphere")
        task.wait(0.3)
    end
    
    -- Remove boss random flinging -- 
    Mobs[Boss]:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(k)
        if k.Name ~= "BPosition" then
            Debris:AddItem(k, 0)
        end
    end)

    -- Equip curse tool/fists --
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if not table.find({"Innates", "Skills", "Reverse Curse Technique"}, v.Name) then
            v.Parent = Character
        end
    end
    if not Character:FindFirstChildWhichIsA("Tool") then
        LocalPlayer.Backpack.Skills.Parent = Character
    end

    -- Opening moves --
    task.wait(0.5)
    Skill("Infinity: Mugen")
    task.wait()
    Skill("Death Sentence")

    -- Killing -- 
    local I = Mobs[Boss]
    task.spawn(function()
        while Mobs:FindFirstChild(Boss) do
            local CF = I.PrimaryPart.CFrame
            Root.CFrame = CF - CF.LookVector * 2 + CF.UpVector * 2
            task.wait()
        end
    end)

    -- Hit & Godmode loop -- 
    task.spawn(function()
        while Mobs:FindFirstChild(Boss) do
            if not Character:FindFirstChild("ForceField") then
                Godmode(true)
            end
            BV(I.PrimaryPart, Vector3.new(0, 0, 0))
            Hit(I.Humanoid)
            task.wait(0.2)
            Combat:WaitForChild("Vent"):FireServer()
        end
    end)
    
    task.spawn(function()
        repeat task.wait() until Replay.Visible
        print("Fail Safe Firing")
        task.wait(10)
        for i = 1, 10, 1 do
            Click(Replay)
            task.wait(1)
        end
    end)
    
    repeat
        task.wait()
    until Drops:FindFirstChild("Chest") -- Could have used WaitForChild here, but I felt it feels cursed not assigning WaitForChild to a variable, then I don't want an unused variable...
    print("Chests spawned")

    -- Overwrite chest collection function --
    local Items, HasGoodDrops, ChestsCollected = {}, false, 0
    local ChestsCollected = 0
    local S, E = pcall(function()
        ClientRemotes.CollectChest.OnClientInvoke = function(Chest, Loots)
            if Chest then
                ChestsCollected = ChestsCollected + 1
                for _, Item in pairs(Loots) do
                    if table.find({"Special Grade", "Unique"}, Item[1]) then
                        HasGoodDrops = true
                        Item[2] = "**" .. Item[2] .. "**"
                    end
                    table.insert(Items, Item[2])
                end
            end
            return {}
        end
    end)

    task.spawn(function()
        while Drops:FindFirstChild("Chest") or LootUI.Enabled do
            pcall(function()
                for i, v in pairs(Drops:GetChildren()) do
                    v.PrimaryPart.CFrame = Root.CFrame
                end
            end)
            if not LootUI.Enabled then
                OpenChest()
            else
                repeat
                    Click(Flip)
                until not LootUI.Enabled
            end
            task.wait()
        end
    end)
    
    repeat
        task.wait()
    until not (Drops:FindFirstChild("Chest") or LootUI.Enabled)

    -- Send webhook message --
    local S, E = pcall(function()
        if getgenv().Webhook then
		
            local Executor = (identifyexecutor() or "None Found")
			
            local Content = ""
			
            if HasGoodDrops and DiscordPing ~= "None Found" then
                Content = Content .. DiscordPing
            end
			
            Content = Content .. "\n-# [Debug] " .. "Executor used: " .. Executor .. " | Loading Time: " ..
                            tostring(getgenv().ScriptLoading) .. "Chest: " .. tostring(getgenv().ChestsCollected)
            print("Sending webhook")
            task.wait()
            local embed = {
                ["title"] = getgenv().Boss .. "Grind Timer: [" .. tostring(math.floor((tick() - getgenv().StartTime) * 10) / 10) .. " seconds]",
                ["description"] = "**Collected Items**" .. table.concat(getgenv().Items, " | "),
                ["color"] = tonumber(0xffffff),
            }
            request({
                Url = getgenv().Webhook,
                Headers = {
                    ['Content-Type'] = 'application/json'
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    ['embeds'] = {embed},
                    ['content'] = Content,
                    ['avatar_url'] = "https://cdn.discordapp.com/attachments/1089257712900120576/1105570269055160422/archivector200300015.png"
                }),
                Method = "POST"
            })
            task.wait()
            --{CUSTOMHOOK}--
            print("Webhook sent!")
        end  
    end)
    pcall(function()
        local Response = ServerRemotes:WaitForChild("Dialogue"):WaitForChild("GetResponse"):InvokeServer("Clan Head Jujutsu High", "Start")
        if not string.find(Response, "Don't waste") then
            ServerRemotes:WaitForChild("Dialogue"):WaitForChild("GetResponse"):InvokeServer("Clan Head Jujutsu High", "Promote")
        end
    end)

    if (true and {OVERNIGHT}) then
        local CurrentMaterials = LocalPlayer.ReplicatedData.inventory:FindFirstChild(BossDrops[Boss])
        if CurrentMaterials then
            if CurrentMaterials.Value == 999 then
                local MaterialToFarm = AnalyseInventory()
                for i, v in BossDrops do
                    if v == MaterialToFarm then
                        local S, E = pcall(function()
                            writefile("JJI_LastBoss.txt", i)
                            print(i)
                            while task.wait(10) do
                                TP:Teleport(10450270085)
                            end
                        end)
                        if not S then print(E) end
                    end
                end
            end
        end
    end

    -- Click replay --
    task.wait()
    if Toggle == "ON" then
        for i = 1, 10, 1 do
            Click(Replay)
            task.wait(1)
        end
    end
end
