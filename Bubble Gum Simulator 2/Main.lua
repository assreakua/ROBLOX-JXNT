if not LPH_OBFUSCATED then
    getgenv().Settings = {
        ["Egg Settings"] = {
            OpenEggs = true,
            Egg = "Best",
            --// Supports ANY egg ("Rainbow Egg", "Infinity Egg", ...). Keep "Best" for new accounts.
            
            ["Notifications"] = {
                Webhook = "",
                DiscordID = "318070660050059264",
                Difficulty = "100k", --// Minimum Difficulty for Webhook Notifications
            },

            ["Rifts"] = {
                FindRifts = true,
                SortByMultiplier = true, 
                --// true --> Sort by Multiplier out of ALL Targetted Rifts.
                --// false --> Sort by Multiplier out of BEST Targetted Rifts.
                
                Targets = {"Aura Egg", "Nightmare Egg"},
                --// Targets = {} will automatically find the Top 3 BEST Rifts to hatch.
            },
        },

        ["Debug"] = {
            DisableUI = true,
        },
    }
end
--[[
	Want to Enchant your Pets?
	Add these EXTRA Config options anywhere inside Settings.

    ["Enchant Settings"] = {
        EnchantPets = false,
        
        ["Require All Enchants"] = true,
        ["Enchants Needed"] = {
            ["Team Up"] = {Tier = 1, HigherTiers = true},
        },
    },
]]--
local Debug = Settings.Debug or {}
local StartTime = os.time()

if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local LocalPlayer = game.Players.LocalPlayer
if not LocalPlayer.Character then 
    LocalPlayer.CharacterAdded:Wait() 
end

local Character = LocalPlayer.Character
local Humanoid = Character.Humanoid
local HumanoidRootPart = Character.HumanoidRootPart

if game.PlaceId ~= 85896571713843 then
    return 
end

local Module = loadstring(game:HttpGet("https://system-exodus.com/scripts/BGSI/Module.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local PhysicsService = game:GetService("PhysicsService")

if Library.Intro.IsPlaying then
    repeat wait() until Library.LocalData:IsReady()
    Module.Fire("SetSetting", "Low Detail Mode", true)
    LocalPlayer.PlayerGui.ScreenGui.Enabled = true
    LocalPlayer.PlayerGui.Intro.Enabled = false
    pcall(function()
        StarterGui:SetCoreGuiEnabled("All", true)
    end)
    task.wait(1)
end

local Save = Library.LocalData.Get()

--[[
    Completed:
    - Auto Trade Pets
]]

--[[
    Needed Features:
    - Purchase Merchants
    - Craft Potions 
]]--

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

if LocalPlayer.PlayerScripts:FindFirstChild("AFK") then
    LocalPlayer.PlayerScripts.AFK.Enabled = false
end
if Save.Season.Level >= 15 and not Save.Season.IsInfinite then
    Module.Fire("BeginSeasonInfinite")
end

if not Debug.DisableUI then
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    UserSettings():GetService("UserGameSettings").GraphicsQualityLevel = 1
    UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    sethiddenproperty(Terrain, "Decoration", false)
    sethiddenproperty(Lighting, "Technology", 2)
    for _, v in Lighting:GetChildren() do
        v:Destroy()
    end
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 1
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.FogEnd = 0
    Lighting.FogStart = 0
    Lighting.Technology = Enum.Technology.Voxel
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end
    local function ClearItem(v)
        if v.Name == "SystemExodus" then
            return
        end
        if v:IsA("Model") and v.Parent == workspace and v.Name ~= LocalPlayer.Name then
            v:Destroy()
        elseif v:IsA("Workspace") then
            v.Terrain.WaterWaveSize = 0
            v.Terrain.WaterWaveSpeed = 0
            v.Terrain.Elasticity = 0
            v.Terrain.WaterReflectance = 0
            v.Terrain.WaterTransparency = 1
            sethiddenproperty(v, "StreamingTargetRadius", 64)
            sethiddenproperty(v, "StreamingPauseMode", 2)
            sethiddenproperty(v.Terrain, "Decoration", false)
        elseif v:IsA("Model") then
            sethiddenproperty(v, "LevelOfDetail", 1)
        elseif v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("ImageLabel") then
            v.Visible = false
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.Transparency = 1
        elseif v:IsA("MeshPart") then
            v.Transparency = 0
            v.CanCollide = false
        elseif v:IsA("Texture") or v:IsA("Decal") then
            v.Texture = ""
            v.Transparency = 1
        elseif v:IsA("SpecialMesh") then
            v.TextureId = ""
        elseif v:IsA("ShirtGraphic") then
            v.Graphic = 1
        elseif v:IsA("Lighting") then
            sethiddenproperty(v, "Technology", 2)
            v.GlobalShadows = false
            v.FogEnd = 0
            v.Brightness = 0
        elseif v:IsA("Shirt") or v:IsA("Pants") then
            v[v.ClassName .. "Template"] = ""
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
            v.Enabled = false
        elseif v:IsA("NetworkClient") then
            v:SetOutgoingKBPSLimit(100)
        elseif
            v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or
                v:IsA("DepthOfFieldEffect") or
                v:IsA("UIGradient") or
                v:IsA("UIStroke") or
                v:IsA("PointLight") or
                v:IsA("Fire") or
                v:IsA("SpotLight") or
                v:IsA("Smoke") or
                v:IsA("Sparkles") or
                v:IsA("Beam") or
                v:IsA("BillboardGui") or
                v:IsA("SurfaceGui") or
                v:IsA("ScreenGui")
        then
            v.Enabled = false
        elseif v:IsA("Highlight") then
            v.OutlineTransparency = 1
            v.FillTransparency = 1
        elseif v:IsA("Explosion") then
            v.BlastPressure = 0
            v.BlastRadius = 0
            v.Visible = false
            v.Position = Vector3.new(0, 0, 0)
        elseif v:IsA("Sound") then
            v.Playing = false
            v.Volume = 0
        elseif v:IsA("CharacterMesh") then
            v.BaseTextureId = ""
            v.MeshId = ""
            v.OverlayTextureId = ""
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        ClearItem(v)
    end
    for _, v in pairs(Players:GetChildren()) do
        if v ~= LocalPlayer then
            ClearItem(v)
        end
    end
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        ClearItem(v)
    end
    workspace.DescendantAdded:Connect(function(v)
        ClearItem(v)
    end)
    for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if v.Name ~= "System Exodus" and v.ClassName == "ScreenGui" then
            v.Enabled = false
        end
    end
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name ~= "DevConsoleMaster" and v:IsA("ScreenGui") then
            v.Enabled = false
        end
    end
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    GuiService.TouchControlsEnabled = false
    setfpscap(Debug and Debug.FPSLimit or 10)
end

pcall(function()
    local SystemExodus = Instance.new("ScreenGui")
    local WholeUI = Instance.new("Frame")
    local LastHatch = Instance.new("TextLabel")
    local Info = Instance.new("TextLabel")
    local Frame = Instance.new("Frame")
    local LastTask = Instance.new("TextLabel")
    local SessionTime = Instance.new("TextLabel")
    local Frame_2 = Instance.new("Frame")
    local Logo = Instance.new("Frame")
    local Exodus = Instance.new("TextLabel")
    local UIGradient = Instance.new("UIGradient")
    local System = Instance.new("TextLabel")
    local UIGradient_2 = Instance.new("UIGradient")
    local Discord = Instance.new("TextLabel")
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
    local ImageLogo = Instance.new("ImageLabel")
    local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
    local SessionHatch = Instance.new("TextLabel")
    
    SystemExodus.Name = "System Exodus"
    SystemExodus.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    SystemExodus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SystemExodus.DisplayOrder = 999
    SystemExodus.IgnoreGuiInset = true
    SystemExodus.Enabled = true
    
    WholeUI.Name = "Whole UI"
    WholeUI.Parent = SystemExodus
    WholeUI.AnchorPoint = Vector2.new(0.5, 0.5)
    WholeUI.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
    WholeUI.BorderColor3 = Color3.fromRGB(98, 70, 253)
    WholeUI.BorderSizePixel = 3
    WholeUI.Position = UDim2.new(0.5, 0, 0.5, 0)
    WholeUI.Size = UDim2.new(1, 0, 1, 0)
    
    LastHatch.Name = "LastHatch"
    LastHatch.Parent = WholeUI
    LastHatch.AnchorPoint = Vector2.new(0.5, 0.5)
    LastHatch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LastHatch.BackgroundTransparency = 1.000
    LastHatch.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LastHatch.BorderSizePixel = 0
    LastHatch.Position = UDim2.new(0.499295563, 0, 0.491042107, 0)
    LastHatch.Size = UDim2.new(0.783704877, 0, 0.118177816, 0)
    LastHatch.ZIndex = 2
    LastHatch.Font = Enum.Font.Cartoon
    LastHatch.Text = "Last Hatch: N/A"
    LastHatch.TextColor3 = Color3.fromRGB(222, 222, 222)
    LastHatch.TextScaled = true
    LastHatch.TextSize = 100.000
    LastHatch.TextWrapped = true
    
    Info.Name = "Info"
    Info.Parent = WholeUI
    Info.AnchorPoint = Vector2.new(0.5, 0.5)
    Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Info.BackgroundTransparency = 1.000
    Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Info.BorderSizePixel = 0
    Info.Position = UDim2.new(0.496443689, 0, 0.578424335, 0)
    Info.Size = UDim2.new(0.783493757, 0, 0.118177816, 0)
    Info.ZIndex = 2
    Info.Font = Enum.Font.Cartoon
    Info.Text = "Coins: Loading | Gems: Loading"
    Info.TextColor3 = Color3.fromRGB(222, 222, 222)
    Info.TextScaled = true
    Info.TextSize = 100.000
    Info.TextWrapped = true
    
    Frame.Parent = WholeUI
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(212, 190, 255)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.498789072, 0, 0.640537977, 0)
    Frame.Size = UDim2.new(0.786000013, 0, 0.00400000019, 0)
    
    LastTask.Name = "LastTask"
    LastTask.Parent = WholeUI
    LastTask.AnchorPoint = Vector2.new(0.5, 0.5)
    LastTask.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LastTask.BackgroundTransparency = 1.000
    LastTask.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LastTask.BorderSizePixel = 0
    LastTask.Position = UDim2.new(0.499973953, 0, 0.707352996, 0)
    LastTask.Size = UDim2.new(0.783707261, 0, 0.110473886, 0)
    LastTask.ZIndex = 2
    LastTask.Font = Enum.Font.Cartoon
    LastTask.Text = "Loading"
    LastTask.TextColor3 = Color3.fromRGB(222, 222, 222)
    LastTask.TextScaled = true
    LastTask.TextSize = 80.000
    LastTask.TextWrapped = true
    LastTask.TextYAlignment = Enum.TextYAlignment.Top
    
    SessionTime.Name = "SessionTime"
    SessionTime.Parent = WholeUI
    SessionTime.AnchorPoint = Vector2.new(0.5, 0.5)
    SessionTime.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SessionTime.BackgroundTransparency = 1.000
    SessionTime.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionTime.BorderSizePixel = 0
    SessionTime.Position = UDim2.new(0.5, 0, 0.270000011, 0)
    SessionTime.Size = UDim2.new(0.781448126, 0, 0.116130508, 0)
    SessionTime.ZIndex = 2
    SessionTime.Font = Enum.Font.Cartoon
    SessionTime.Text = "Session Time: Loading"
    SessionTime.TextColor3 = Color3.fromRGB(222, 222, 222)
    SessionTime.TextScaled = true
    SessionTime.TextSize = 100.000
    SessionTime.TextWrapped = true
    
    Frame_2.Parent = WholeUI
    Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame_2.BackgroundColor3 = Color3.fromRGB(212, 190, 255)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0.499001592, 0, 0.4219504, 0)
    Frame_2.Size = UDim2.new(0.786000013, 0, 0.00400000019, 0)
    
    Logo.Name = "Logo"
    Logo.Parent = WholeUI
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Logo.BorderSizePixel = 0
    Logo.Position = UDim2.new(0.499991536, 0, 0.0707971379, 0)
    Logo.Size = UDim2.new(0.17320314, 0, 0.0850019157, 0)
    
    Exodus.Name = "Exodus"
    Exodus.Parent = Logo
    Exodus.AnchorPoint = Vector2.new(0.5, 0.5)
    Exodus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Exodus.BackgroundTransparency = 1.000
    Exodus.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Exodus.BorderSizePixel = 0
    Exodus.Position = UDim2.new(1.04387271, 0, 0.281516135, 0)
    Exodus.Size = UDim2.new(1.04831469, 0, 2.27298212, 0)
    Exodus.ZIndex = 2
    Exodus.Font = Enum.Font.FredokaOne
    Exodus.Text = "Exodus"
    Exodus.TextColor3 = Color3.fromRGB(196, 74, 245)
    Exodus.TextScaled = true
    Exodus.TextSize = 100.000
    Exodus.TextWrapped = true
    
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(213, 97, 242)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(151, 15, 251))}
    UIGradient.Parent = Exodus
    
    System.Name = "System"
    System.Parent = Logo
    System.AnchorPoint = Vector2.new(0.5, 0.5)
    System.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    System.BackgroundTransparency = 1.000
    System.BorderColor3 = Color3.fromRGB(0, 0, 0)
    System.BorderSizePixel = 0
    System.Position = UDim2.new(-0.0355360918, 0, 0.281516135, 0)
    System.Size = UDim2.new(1.04387271, 0, 2.27298212, 0)
    System.ZIndex = 2
    System.Font = Enum.Font.FredokaOne
    System.Text = "System"
    System.TextColor3 = Color3.fromRGB(102, 184, 255)
    System.TextScaled = true
    System.TextSize = 100.000
    System.TextWrapped = true
    
    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(102, 254, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(101, 50, 255))}
    UIGradient_2.Parent = System
    
    Discord.Name = "Discord"
    Discord.Parent = Logo
    Discord.AnchorPoint = Vector2.new(0.5, 0.5)
    Discord.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Discord.BackgroundTransparency = 1.000
    Discord.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Discord.BorderSizePixel = 0
    Discord.Position = UDim2.new(0.510831296, 0, 0.834121943, 0)
    Discord.Size = UDim2.new(1.76415002, 0, 0.573458791, 0)
    Discord.ZIndex = 2
    Discord.Font = Enum.Font.FredokaOne
    Discord.Text = "discord.gg/Jk28atjPas"
    Discord.TextColor3 = Color3.fromRGB(248, 250, 255)
    Discord.TextScaled = true
    Discord.TextSize = 100.000
    Discord.TextWrapped = true
    
    UIAspectRatioConstraint.Parent = Discord
    UIAspectRatioConstraint.AspectRatio = 7.221
    
    UIAspectRatioConstraint_2.Parent = Logo
    UIAspectRatioConstraint_2.AspectRatio = 2.347
    
    ImageLogo.Name = "ImageLogo"
    ImageLogo.Parent = WholeUI
    ImageLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLogo.BackgroundTransparency = 1.000
    ImageLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLogo.BorderSizePixel = 0
    ImageLogo.Position = UDim2.new(0, 42, 0, 44)
    ImageLogo.Size = UDim2.new(0, 66, 0, 70)
    ImageLogo.Image = "http://www.roblox.com/asset/?id=138398943441432"
    
    UIAspectRatioConstraint_3.Parent = ImageLogo
    UIAspectRatioConstraint_3.AspectRatio = 0.988
    
    SessionHatch.Name = "SessionHatch"
    SessionHatch.Parent = WholeUI
    SessionHatch.AnchorPoint = Vector2.new(0.5, 0.5)
    SessionHatch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SessionHatch.BackgroundTransparency = 1.000
    SessionHatch.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionHatch.BorderSizePixel = 0
    SessionHatch.Position = UDim2.new(0.500426173, 0, 0.356230229, 0)
    SessionHatch.Size = UDim2.new(0.781448126, 0, 0.116130508, 0)
    SessionHatch.ZIndex = 2
    SessionHatch.Font = Enum.Font.Cartoon
    SessionHatch.Text = "Session Hatch: Loading (1/1)"
    SessionHatch.TextColor3 = Color3.fromRGB(222, 222, 222)
    SessionHatch.TextScaled = true
    SessionHatch.TextSize = 100.000
    SessionHatch.TextWrapped = true
end)
local UI = LocalPlayer.PlayerGui:WaitForChild("System Exodus")
UI = UI:WaitForChild("Whole UI")
if Debug.DisableUI then
    UI.Parent.Enabled = false
end
local function UIText(Type, Text)
    if Type.Text == Text then return end
    if Type == UI.LastTask then
        print("[System Exodus]:", Text)
    end
    Type.Text = Text
end

--// Initialize Gum Items by Storage
local Gum = {}
for ID, Data in pairs(Library.Gum) do
    if ID:find("Infinity") then continue end
    table.insert(Gum, {ID = ID, Storage = Data.Storage, Cost = Data.Cost, Area = Data.Area})
end
table.sort(Gum, function(a,b)
    return a.Storage > b.Storage
end)

--// Initialize Gum Flavors by Bubbles
local Flavors = {}
for ID, Data in pairs(Library.Flavors) do
    if ID:find("VIP") then continue end
    table.insert(Flavors, {ID = ID, Bubbles = Data.Bubbles, Cost = Data.Cost, Area = Data.Area})
end
table.sort(Flavors, function(a,b)
    return a.Bubbles > b.Bubbles
end)

--// Currency Order
local Currency = {}
for Name, Data in pairs(Library.Currency) do
    Currency[Name] = Data.LayoutOrder
end

--// Egg Order
local Eggs = {}
for Name, Data in pairs(Library.Eggs) do
    if not Data.Cost or Data.ProductId or Name:find("Season") then continue end
    Data.Name = Name
    --if not Data.World then Data.World = "The Overworld" end
    --if not Data.Island then Data.Island = "Spawn" end
    table.insert(Eggs, Data)
end
table.sort(Eggs, function(a, b)
    local Egg1 = Currency[a.Currency] or math.huge
    local Egg2 = Currency[b.Currency] or math.huge
    if Egg1 == Egg2 then
        return a.Cost.Amount > b.Cost.Amount
    else
        return Egg1 < Egg2
    end
end)
local EggNames = {}
for _, Data in pairs(Eggs) do
    table.insert(EggNames, Data.Name)
end
--[[if not table.find(EggNames, Settings["Egg Settings"].Egg) then
    for _, Data in ipairs(Eggs) do
        if Data.World and Data.Island then
            Settings["Egg Settings"].Egg = Data.Name
            break
        end
    end
end]]--

--// Egg ID vs Display Translation
local EggTranslation = {}
for ID, Data in pairs(Library.Rifts) do
    if Data.Egg then
        EggTranslation[Data.Egg] = ID
        EggTranslation[ID] = Data.Egg
    end
end

--// Initialize Equipped Pets
local EquippedPets = {}
local function GetEquippedPets()
    Module.Fire("EquipBestPets")
    EquippedPets = {}
    for _,UID in pairs(Save.Teams[Save.TeamEquipped or 1].Pets or {}) do
        table.insert(EquippedPets, UID)
    end
end

--// Initialize Masteries
local Masteries = {}
for Mastery in pairs(Library.Mastery.Upgrades) do
    if Mastery ~= "Shops" then
        Masteries[#Masteries + 1] = Mastery
    end
end
local function ClaimMasteries()
    for _,v in pairs(Masteries) do
        if Save.MasteryLevels and Save.MasteryLevels[v] then
            local TrueLevel = Save.MasteryLevels[v] + 1 -- #MasteryUtil:GetUpgrades(Save, v)
            for Index, Value in pairs(Library.Mastery.Upgrades[v].Levels) do
                if Index == TrueLevel and (not Value.Cost or Save[Value.Cost.Currency] >= Value.Cost.Amount) then
                    UIText(UI.LastTask, "Purchased Mastery: "..v.." "..TrueLevel)
                    Module.Fire("UpgradeMastery", v)
                    break
                end
            end
        else
            UIText(UI.LastTask, "Initialized Mastery: "..v)
            Module.Fire("UpgradeMastery", v)
        end
    end
end

--// Initialize Prizes
local Prizes = Library.Prizes
local Translation = {["Eggs"] = "Hatches", ["Bubbles"] = "Bubbles"}
local function ClaimPrizes()
    for i,v in pairs(Prizes) do
        local Type = Translation[v.Type]
        if Save.ClaimedPrizes[v.Key] then
            continue
        end
        if Save.Stats[Type] >= v.Requirement then
            UIText(UI.LastTask, "Claimed Prize: "..i.." ("..v.Key..")")
            Module.Fire("ClaimPrize", i)
        end
    end
end

--// Initialize Index Rewards
local function ClaimIndexRewards()
    for i,v in pairs(Library.Eggs) do
        if (i:find("Inferno") or i:find("Hell")) then
            continue
        end
        if not Save.EggPrizesClaimed["S"..i] and v.World then
            local Data = Library.IndexUtil:GetEggCompleted(Save, v.World, "Shiny", i)
            if (Data.Total - Data.Found) <= 0 then
                UIText(UI.LastTask, "Claimed Index Reward: "..i)
                Module.Fire("EggPrizeClaim", i, true)
            end
        end
        if not Save.EggPrizesClaimed[i] then
            local Data = Library.IndexUtil:GetEggCompleted(Save, v.World, "Normal", i)
            if (Data.Total - Data.Found) <= 0 then
                UIText(UI.LastTask, "Claimed Index Reward: "..i)
                Module.Fire("EggPrizeClaim", i, false)
            end
        end
    end
end

--// Initialize Season Rewards
local SeasonUtil = Library.SeasonUtil
local Season = SeasonUtil:GetCurrentSeason()
local function ClaimSeasonRewards()
    local CurrentLevel = Save.Season.Level
    local CurrentPoints = Save.Season.Points

    for Index = 1, #Season.Track do
        if Index <= CurrentLevel then continue end
        local Requirement = SeasonUtil:GetRequirement(Season, Index)
        if Requirement <= CurrentPoints and not Save.Season.IsInfinite then
            Module.Fire("ClaimSeason")
        end
    end

    if Save.Season.IsInfinite then
        local NextIndex = CurrentLevel + 1

        Save.Season.LastCostIndex = Save.Season.LastCostIndex or CurrentLevel
        Save.Season.LastCost = Save.Season.LastCost or 0

        local InfiniteSegment = SeasonUtil:GetInfiniteSegment({ Season = Save.Season }, Season, NextIndex)
        if InfiniteSegment and InfiniteSegment.Requirement > 0 and CurrentPoints >= InfiniteSegment.Requirement then
            Module.Fire("ClaimSeason")
        end
    end
end

--// Initialize Codes
local function ClaimCodes()
    for Code in pairs(Library.Codes or {}) do
        if table.find(Save.Redeemed, Code) then
            continue
        end
        UIText(UI.LastTask, "Redeemed Code: "..Code)
        Module.Invoke("RedeemCode", Code)
    end
end
ClaimCodes()

--// Initialize Open Items
workspace.Rendered.Gifts.ChildAdded:Connect(function(Gift)
    Module.Fire("ClaimGift", Gift.Name)
    Gift.Parent = nil
end)
local SeasonID = Library.SeasonUtil:GetCurrentSeason().ID
local function OpenItems()
    for Item, Amount in pairs(Save.Powerups) do
        if Amount <= 9 then continue end

        local ItemName = tostring(Item):gsub(" ", "")
        if Debug["DisableUse"..ItemName] then continue end

        if Item:match("Season %d Egg") then
            local Season = tonumber(Item:match("Season%s+(%d+)%s+Egg"))
            if Season == SeasonID then
                local Times = math.floor(Amount / 10)
                for i = 1, Times do
                    UIText(UI.LastTask, "Opened: "..Item.." x10")
                    Module.Fire("HatchPowerupEgg", Item, 10)
                end
            end
        end

        if Item:find("Mystery Box") then
            local Times = math.floor(Amount / 10)
            for i = 1, Times do
                UIText(UI.LastTask, "Opened: "..Item.." x10")
                Module.Fire("UseGift", Item, 10)
                task.wait(2)
            end
        end
    end
end

--// Initialize Opening Chests
workspace.Rendered.Generic.ChildAdded:Connect(function(Item)
    if Item:IsA("Part") and Item.Name:find("-") then
        Module.Fire("GrabVisualItem", {Item.Name})
        Item:Destroy()
    end
    if Item.Name == "Portal" then
        task.wait(0.1)
        if Item:FindFirstChild("Display") and Item.Display:FindFirstChild("TouchInterest") then
            Item.Display.TouchInterest:Destroy()
        end
    end
end)
local function ClaimChest()
    for Item, Cooldown in pairs(Save.Cooldowns) do
        if Item:find("Chest") and (os.time()-Cooldown) >= 0 then
            local Model = workspace.Rendered.Generic[Item]
            if Model and (Model.Outer.Position - HumanoidRootPart.Position).Magnitude >= 20 then
                Module.Teleport(Model.Outer.CFrame)
            end
            UIText(UI.LastTask, "Claimed Chest: "..Item)
            Module.Fire("ClaimChest", Item)
        end
    end
end

--// Initialize Purchasing Shop
local function PurchaseBaseShop()
    for _,v in pairs(Flavors) do
        if v.Cost and type(v.Cost) == "table" and v.Cost.Currency then
            if not Save.Flavors[v.ID] and v.Bubbles > Library.Flavors[Save.Bubble.Flavor].Bubbles and Save[v.Cost.Currency] >= v.Cost.Amount then
                UIText(UI.LastTask, "Purchased Item: "..v.ID)
                Module.Fire("GumShopPurchase", v.ID)
                break
            end
        end
    end
    
    for _,v in pairs(Gum) do
        if v.Cost and type(v.Cost) == "table" and v.Cost.Currency then
            if not Save.Gum[v.ID] and v.Storage > Library.StatsUtil:GetBubbleStorage(Save) and Save[v.Cost.Currency] >= v.Cost.Amount then
                UIText(UI.LastTask, "Purchased Item: "..v.ID)
                Module.Fire("GumShopPurchase", v.ID)
                break
            end
        end
    end
end
Library.LocalData:ConnectDataChanged("Stats", PurchaseBaseShop)

--// Initialize Rift Islands
local WorkspaceRifts = workspace.Rendered.Rifts
local Rifts = {}
local RiftSettings = Settings["Egg Settings"].Rifts
if RiftSettings and RiftSettings.FindRifts then
    for _, Rift in pairs(WorkspaceRifts:GetChildren()) do
        table.insert(Rifts, Rift.Name)
    end
    WorkspaceRifts.ChildAdded:Connect(function(Rift)
        table.insert(Rifts, Rift.Name)
    end)
    WorkspaceRifts.ChildRemoved:Connect(function(Rift)
        table.remove(Rifts, table.find(Rifts, Rift.Name))
    end)
end

LocalPlayer.PlayerGui.ScreenGui.ChildAdded:Connect(function(v)
    if v:IsA("Frame") then
        if v.Name == "Prompt" and v:FindFirstChild("ExternalClose") then
            v.ExternalClose:Invoke()
        end
    end
end)

if LocalPlayer.PlayerGui.ScreenGui.HUD.Left.Currency.Coins.Bundles.Benefits.Visible then
    Module.Fire("ClaimBenefits")
end

LocalPlayer.PlayerGui.ScreenGui.HUD.NotifyGame.Changed:Connect(function(v)
    LocalPlayer.PlayerGui.ScreenGui.HUD.NotifyGame.Visible = false
end)

LocalPlayer.PlayerGui.ScreenGui.Playtime.Changed:Connect(function(v)
    LocalPlayer.PlayerGui.ScreenGui.Playtime.Visible = false
end)

LocalPlayer.PlayerGui.ScreenGui.Playtime.Changed:Connect(function(v)
    LocalPlayer.PlayerGui.ScreenGui.Playtime.Visible = false
end)

LocalPlayer.PlayerGui.ScreenGui.AFKReveal.Changed:Connect(function(v)
    LocalPlayer.PlayerGui.ScreenGui.AFKReveal.Visible = false
end)

LocalPlayer.PlayerGui.ScreenGui.DailyRewards.Changed:Connect(function(v)
    Module.Fire("DailyRewardClaimStars")
    LocalPlayer.PlayerGui.ScreenGui.DailyRewards.Visible = false
end)

--// Pickup map coins without console errors.
local Coins;
task.spawn(function()
    --[[repeat task.wait()
        for _,v in pairs(workspace.Rendered:GetChildren()) do
            if v.Name == "Chunker" and v:FindFirstChildOfClass("Model") and v:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart") then
                Coins = v
                break
            end
        end
        task.wait(1)
    until Coins
    Coins.ChildAdded:Connect(function(v)
        Module.Fire("CollectPickup", v.Name)
    end)]]--
    Library.StatsUtil.GetPickupRange = function(...)
        return 9999
    end
end)

local function ClaimPlaytimeRewards()
    local Current = (os.time() - Save.PlaytimeRewards.Start)
    for i,v in pairs(Library.Playtime.Gifts) do
        if (Current > v.Time) and (not Save.PlaytimeRewards.Claimed[tostring(i)]) then
            UIText(UI.LastTask, "Claimed Playtime Reward: "..i)
            Module.Invoke("ClaimPlaytime", i)
        end
    end
end

local BestIsland;
local BestWorld;
local function UnlockIslands()
    for World, WorldData in pairs(Library.Worlds) do
        if Save.WorldsUnlocked[World] then
            for _, AreaData in pairs(WorldData.Islands) do
                local Height = workspace.Worlds[World].Islands[AreaData.Name].Island.UnlockHitbox.CFrame
                if not Save.AreasUnlocked[AreaData.Name] then
                    repeat task.wait()
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.CFrame.X + math.random(0,5), Height.Y + 5, HumanoidRootPart.CFrame.Z + math.random(0,5))
                    until Save.AreasUnlocked[AreaData.Name]
                end
                BestIsland = AreaData.Name
                BestWorld = World
            end
        end
    end
end
UnlockIslands()

local function EnchantEquippedPets()
    if not Settings["Enchant Settings"] or not Settings["Enchant Settings"].EnchantPets or Save.Gems <= 100000 or Save.Stats.Hatches <= 500 then 
        return "Enchanting is NOT enabled."
    end

    local EnchantsNeeded = 0
    for _,v in pairs(Settings["Enchant Settings"]["Enchants Needed"]) do
        EnchantsNeeded += 1
    end

    local EnchantingPets = {}
    for _,v in pairs(EquippedPets) do
        table.insert(EnchantingPets, v)
    end

    repeat task.wait()
        for _, Data in pairs(Save.Pets) do
            if table.find(EnchantingPets, Data.Id) then
                local EnchantsGotten = 0
                local EnchantSlot;
                if not Data.Enchants then continue end
                for Slot, Enchant in ipairs(Data.Enchants) do
                    local Name = Enchant.Id:gsub("-", " "):gsub("(%a)([%w_']*)", function(First, Rest)
                        return First:upper() .. Rest:lower()
                    end)
                    local SettingEnchant = Settings["Enchant Settings"]["Enchants Needed"][Name]
                    if SettingEnchant and (Enchant.Level == SettingEnchant.Tier or SettingEnchant.HigherTiers and Enchant.Level >= SettingEnchant.Tier) then
                        EnchantsGotten += 1
                        EnchantSlot = Slot
                    end

                    if (Settings["Enchant Settings"]["Require All Enchants"] and EnchantsGotten >= EnchantsNeeded) or (not Settings["Enchant Settings"]["Require All Enchants"] and EnchantsGotten >= 1) then
                        table.remove(EnchantingPets, table.find(EnchantingPets, Data.Id))
                        break
                    end
                end

                if table.find(EnchantingPets, Data.Id) then
                    if Save.Powerups["Reroll Orb"] and Save.Powerups["Reroll Orb"] >= 1 and Data.Enchants[1] and not Debug["DisableUseRerollOrb"] then
                        local Slot = (EnchantSlot == 1 and 2) or 1
                        Module.Fire("RerollEnchant", Data.Id, Slot)
                    else
                        Module.Invoke("RerollEnchants", Data.Id)
                    end
                end

            end
        end
    until #EnchantingPets == 0 or Save.Gems <= 100000

    return Save.Gems <= 100000 and "User ran out of Gems!" or "Successfully Enchanted Equipped Pets!"
end

local function CompleteMinigames()
    --// Wheel Spin
    if (Save.NextWheelSpin-os.time()) <= 0 then
        UIText(UI.LastTask, "Claimed Free Wheel Spin")
        Module.Fire("ClaimFreeWheelSpin")
    end

    if Save.Powerups["Spin Ticket"] and not Debug["DisableUseSpinTicket"] then
        for i = 1, Save.Powerups["Spin Ticket"] do
            UIText(UI.LastTask, "Spun Minigame Wheel")
            Module.Invoke("WheelSpin")
            Module.Fire("ClaimWheelSpinQueue")
        end
    end

    --// DoggyJump
    if (Save.DoggyJump.Claimed) ~= 3 then
        UIText(UI.LastTask, "Completed Doggy Jump Minigame")
        Module.Fire("DoggyJumpWin", 3)
    end
end

local CurrentTask = nil
local function SetTask(Task)
    CurrentTask = Task
end

local function CanAffordEgg(Egg)
    if Egg == "Infinity Egg" then
        Egg = Library.GetInfinityEgg(LocalPlayer)
    else
        Egg = Library.Eggs[Egg]
    end
    local CostPerEgg = Library.ItemUtil:GetAmount(Egg.Cost)
    local CurrencyOwned = Library.ItemUtil:GetOwnedAmount(Save, Egg.Cost)
    local CanAfford = math.floor(CurrencyOwned / CostPerEgg)
    return CanAfford
end

local CurrentEgg = nil
local CurrentSource = nil
local function TeleportToBestRift(Custom)
    if (Save.Stats.Hatches or 0) < 100 or not RiftSettings.FindRifts then
        return
    end

    local FinalRifts = {}
    local SelectedEggs = {}

    if #RiftSettings.Targets > 0 then
        SelectedEggs = Custom and Custom or RiftSettings.Targets
    else
        for _, EggData in ipairs(Eggs) do
            table.insert(SelectedEggs, EggData.Name)
            if #SelectedEggs >= 4 then break end
        end
    end

    local ActiveEggs = {}
    for _, Name in ipairs(SelectedEggs) do
        local RiftName = EggTranslation[Name] or Name
        if WorkspaceRifts:FindFirstChild(RiftName) then
            table.insert(ActiveEggs, Name)
        end
    end

    local RiftByEgg = {}
    for _, Rift in pairs(WorkspaceRifts:GetChildren()) do
        local Name = EggTranslation[Rift.Name] or Rift.Name
        if table.find(ActiveEggs, Name) then
            local Display = Rift:FindFirstChild("Display")
            local LuckLabel = Display and Display:FindFirstChild("SurfaceGui")
            and Display.SurfaceGui:FindFirstChild("Icon")
            and Display.SurfaceGui.Icon:FindFirstChild("Luck")
    
            if LuckLabel and LuckLabel:IsA("TextLabel") then
                local Luck = tonumber(LuckLabel.Text:match("%d+%.?%d*") or "0") or 0
    
                if not RiftByEgg[Name] or Luck > RiftByEgg[Name].Luck then
                    RiftByEgg[Name] = {
                        Name = Name,
                        Rift = Rift.Name,
                        CFrame = Rift.Output.CFrame * CFrame.new(0, 5, 0),
                        Luck = Luck
                    }
                end
            end
        end
    end
    
    FinalRifts = {}
    for _, data in pairs(RiftByEgg) do
        table.insert(FinalRifts, data)
    end

    if RiftSettings.SortByMultiplier then
        table.sort(FinalRifts, function(a, b)
            return a.Luck > b.Luck
        end)
    else
        table.sort(FinalRifts, function(a, b)
            return table.find(EggNames, a.Name) < table.find(EggNames, b.Name)
        end)
    end

    if #FinalRifts > 0 then
        local BestRift = FinalRifts[1]
        if CanAffordEgg(BestRift.Name) >= 10 then
            if BestRift.Name == "Aura Egg" or BestRift.Luck >= 25 then
                CanUsePotions = true
            end
            UIText(UI.LastTask, "Teleporting & Hatching Rift: "..BestRift.Name.." ("..BestRift.Luck.."x)")
            local position = BestRift.CFrame * CFrame.new(math.random(0, 3), 3, math.random(0, 3))
            local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

            Module.Teleport(position * randomRotation)
            CurrentEgg = BestRift.Name
            CurrentSource = "Rift"
        end
    else
        if CurrentSource ~= "Normal" then
            CurrentEgg = nil
            CurrentSource = nil
        end
    end
end

local HatchedEggs = {}
local function FindNormalEggs(Custom)
    local EggName = Settings["Egg Settings"].Egg
    if Settings["Egg Settings"].Egg == "Best" then
        if Custom then
            for i = #Eggs, 1, -1 do
                EggData = Eggs[i]
                if EggData.Name == Custom and CanAffordEgg(EggData.Name) >= 1 then
                    EggName = EggData.Name
                end 
            end
        else
            for _, EggData in ipairs(Eggs) do
                if CanAffordEgg(EggData.Name) >= 1 and EggData.Name ~= "Aura Egg" and (not Custom or Custom and (not HatchedEggs[EggData.Name] or HatchedEggs[EggData.Name] < 10)) then
                    EggName = EggData.Name
                    break
                end
            end
        end
    end
    
    if (not CurrentEgg or CurrentSource ~= "Rift") and Settings["Egg Settings"].OpenEggs then
        CurrentSource = "Normal"
        for _, Data in pairs(Eggs) do
            if Data.Name == EggName or EggName == "Infinity Egg" then
                local Generic = workspace.Rendered.Generic
                if not Data.World then continue end
                local WorkspaceWorld = workspace.Worlds:FindFirstChild(Data.World)
                if not Generic:FindFirstChild(Data.Name) then
                    if EggName ~= "Infinity Egg" and WorkspaceWorld and Data.Island and WorkspaceWorld.Islands:FindFirstChild(Data.Island) then
                        UIText(UI.LastTask, "Loading in Normal: "..EggName)
                        Module.Fire("Teleport", "Workspace.Worlds."..Data.World..".Islands."..Data.Island..".Island.Portal.Spawn")
                        --Module.Teleport(WorkspaceWorld.Islands[Data.Island].Island.UnlockHitbox.CFrame * CFrame.new(-10, 50, -10))
                    else
                        UIText(UI.LastTask, "Loading in Normal: "..EggName)
                        Module.Fire("Teleport", "Workspace.Worlds."..Data.World..".FastTravel.Spawn")
                    end
                end
                task.wait(1)
                local Chunker;
                for _,v in pairs(workspace.Rendered:GetChildren()) do
                    if v.Name == "Chunker" then
                        for a,b in pairs(v:GetChildren()) do
                            if b.Name == EggName then
                                CurrentEgg = EggName
                                UIText(UI.LastTask, "Teleporting & Hatching: "..CurrentEgg)
                                local position = b.Plate.CFrame * CFrame.new(math.random(0, 3), 3, math.random(0, 3))
                                local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
                                Module.Teleport(position * randomRotation)
                                task.wait(1)
                                break
                            end
                        end
                    end
                end
                break
            end
        end
    end
end

function Color3ToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return r * 65536 + g * 256 + b
end

local Rarities = Library.Constants.RarityOrder
local SaveRarities = {}

local Sorted = {}
for Rarity, Value in pairs(Rarities) do
    table.insert(Sorted, {Name = Rarity, Value = Value})
end
table.sort(Sorted, function(a, b)
    return a.Value > b.Value
end)
for i = 1, math.min(2, #Sorted) do
    SaveRarities[Sorted[i].Name] = true
end

local function GetBasePower(Pet)
    local BaseStats = table.clone(Library.Pets[Pet.Name].Stats)
    if not BaseStats then return 1 end

    local Multi = 1
    if Pet.Shiny then Multi += 0.5 end
    if Pet.Mythic then Multi += 0.75 end

    for Name, Value in pairs(BaseStats) do
        BaseStats[Name] = Value * Multi
    end

    local Power = BaseStats.Bubbles or 1
    for Name, Value in pairs(BaseStats) do
        if Name ~= "Bubbles" then
            Power *= Value
        end
    end

    return Power
end

local function PetFunction(Pet)
    local MaxPetEquip = Library.StatsUtil:GetMaxPetsEquipped(Save)
    local First = false
    for _, Data in pairs(Save.Pets) do

        if #EquippedPets == 0 or #EquippedPets < MaxPetEquip then
            GetEquippedPets()
        end

        --// Equip Best Pets
        if table.find(EquippedPets, Data.Id) then
            local Power = GetBasePower(Data)
            local HatchedPower = GetBasePower(Pet)
            if HatchedPower >= Power then
                GetEquippedPets()
                return
            end
        end

        --// Delete Pets
        local Rarity = Library.Pets[Data.Name].Rarity
        if not SaveRarities[Rarity] and not table.find(EquippedPets, Data.Id) then                
            if First then 
                Module.Fire("DeletePet", Data.Id, Data.Amount or 1, false)
                task.wait(0.7)
            end
            Module.Fire("DeletePet", Data.Id, Data.Amount or 1, false)
            task.wait(0.7)
            First = false
        end

    end
end

local BestRoll = tonumber(Module.RemoveSuffix(UI.SessionHatch.Text:split("/")[2]:gsub("%)", "")))
local function Webhook(Return)
    local Egg = Return.Name

    local Pet = Return.Pet
    local Rarity = Library.Pets[Pet.Name].Rarity

    local Name = Library.PetUtil:GetName(Pet)
    local Chance = Library.PetUtil:GetChance(Pet)
    local Power = Library.PetUtil:GetPower(Pet)
    local Stats = Library.PetUtil:GetStats(Pet)
    local Difficulty = 100 / Chance
    
    PetFunction(Pet)

    local Global = false
    local User = false
    local Notifications = Settings["Egg Settings"].Notifications
    if Notifications.Webhook and Notifications.Webhook ~= "" then
        if Notifications.Difficulty and Difficulty >= Module.RemoveSuffix(tostring(Notifications.Difficulty)) then
            User = true
        end
    end
    if Difficulty >= 1000000 then
        Global = true
    end

    local Color = Color3ToHex(Library.Constants.RarityColors[Rarity]) or 0
    local Description = {
        "<:Bubble:1361380205918163124> Bubbles: **`+"..Module.AddCommas(Stats.Bubbles or 0).."`**",
        "<:Coin:1361380591580348576> Coins: **`x"..Module.AddCommas(Stats.Coins or 0).."`**",
        "<:Gem:1361380483833004304> Gems: **`x"..Module.AddCommas(Stats.Gems or 0).."`**",
    }

    local Image;
    if Pet.Mythic or Pet.Shiny then
        Image = Library.Pets[Pet.Name].Images[("%*%*"):format(Pet.Mythic and "Mythic" or "", Pet.Shiny and "Shiny" or "")]
    else
        Image = Library.Pets[Pet.Name].Images.Normal
    end

    if Difficulty >= BestRoll then
        BestRoll = Difficulty
        UIText(UI.SessionHatch, "Session Roll: "..Name.." (1/"..Module.AddSuffix(Difficulty)..")")
    end
    UIText(UI.LastHatch, "Last Hatch: "..Name.." (1/"..Module.AddSuffix(Difficulty)..")")
    --.." | Hatches: "..Module.AddSuffix(Save.Stats.Hatches or 0))

    local Message = {
        ["username"] = "System Exodus | Egg Notifier",
        ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
        ["content"] = "", --(Global and Notifications["DiscordID"] and Notifications["DiscordID"] ~= "" and "<@"..tostring(Notifications["DiscordID"])..">") or "",
        ["embeds"] = {
            {
                ["color"] = Color,
                ["title"] = Name.." (1/"..Module.AddSuffix(Difficulty)..")",
                ["description"] = table.concat(Description, "\n"),
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ["footer"] = {
                    ["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
                    ["text"] = "@Jxnt - discord.gg/Jk28atjPas"
                },
                ["thumbnail"] = { 
                    ["url"] = "https://biggamesapi.io/image/"..(Image:gsub("rbxassetid://", "") or "0")
                },
            },
        },
    }

    if Global then
        request({
            Url = "https://discord.com/api/webhooks/sss/sss",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(Message)
        })
    end
    if User then
        if Rarity == "Secret" and Notifications["DiscordID"] and Notifications["DiscordID"] ~= "" then
            Message["content"] = "<@"..Notifications["DiscordID"]..">"
        end
        Message["embeds"][1]["title"] = "||"..LocalPlayer.Name.."|| - "..Name.." (1/"..Module.AddSuffix(Difficulty)..")"
        request({
            Url = Notifications.Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(Message)
        })
    end
end

local function GetActivePotions()
    local ActivePotions = {}
    for Effect, Data in pairs(Save.ActivePotions) do
        local Tier = Data.Active.Level
        local Duration = (Data.Active.Expiry.Duration-os.time())
        
        ActivePotions[Effect.." "..Tier] = {
            Name = Effect,
            Tier = Tier,
            Duration = Duration,
        }
        for Effect2, Data2 in pairs(Data.Queue) do
            local Tier = Data2.Level
            local Duration = (Data2.Expiry.Duration-os.time())
            ActivePotions[Effect.." "..Tier] = {
                Name = Effect,
                Tier = Tier,
                Duration = Duration,
            }
        end
    end
    return ActivePotions
end

local function GetActiveBuffs()
    local ActiveBuffs = {}
    for _, Data in pairs(Save.ActiveBuffs) do
        local Tier = Data.Level
        local Duration = (Data.Expiry.Duration-os.time())
        local Effect = Data.Name
        
        ActiveBuffs[Effect.." "..Tier] = {
            Name = Effect,
            Tier = Tier,
            Duration = Duration,
        }
    end
    return ActiveBuffs
end

Library.Event.OnClientEvent:Connect(function(...)
    local Args = {...}
    if Args[1] == "HatchEgg" and type(Args[2]) == "table" and Args[2].Pets then
        for _, Data in pairs(Args[2].Pets) do
            Webhook(Data)
        end
    end
end)
ActivePotions = GetActivePotions()
ActiveBuffs = GetActiveBuffs()

local function HatchEgg(Egg)
    if not Egg then return end
    local MaxHatches = Library.StatsUtil:GetMaxEggHatches(Save)
    local CanAfford = CanAffordEgg(Egg)
    local Minimum = math.min(MaxHatches, CanAfford)
    if Minimum <= 0 then 
        return Minimum
    end
    if not HatchedEggs[Egg] then HatchedEggs[Egg] = 0 end
    HatchedEggs[Egg] += 1
    Module.Fire("HatchEgg", Egg, math.max(1, Minimum))
    task.wait(Library.StatsUtil:GetHatchDuration(Save))
    return Minimum
end

local function UsePotion(ID, Tier)
    if not ActivePotions[ID.." "..Tier] then
        Module.Fire("UsePotion", ID, Tier)
    end
end

local BannedKeywords = {"Infinity", "Elixir"}
local function FindPotions()
    ActivePotions = GetActivePotions()
    local GroupedPotions = {}

    for _, Data in pairs(Save.Potions) do
        local Name = Data.Name
        local Tier = Data.Level
        local Amount = Data.Amount

        local IsBanned = false
        for _, BannedWord in ipairs(BannedKeywords) do
            if Name:find(BannedWord) and not CanUsePotions then
                IsBanned = true
                break
            end
        end
        if IsBanned then continue end

        local PotionData = Library.Potions[Name]
        if not PotionData or not PotionData.Buff or not PotionData.Buff.Expiry or #PotionData.Buff.Expiry == 0 then
            continue
        end

        GroupedPotions[Name] = GroupedPotions[Name] or {}
        table.insert(GroupedPotions[Name], Tier)
    end

    for Name, Tiers in pairs(GroupedPotions) do
        table.sort(Tiers, function(a, b) return a > b end)

        for _, Tier in ipairs(Tiers) do
            if Tier < 6 or (Tier >= 6 and CanUsePotions) then
                UsePotion(Name, Tier)
                break
            end
        end
    end
end

local function FindBuffs()
    ActiveBuffs = GetActiveBuffs()

    if not ActiveBuffs["GoldRush 1"] and not Debug["DisableUseGoldenOrb"] then
        Module.Fire("UseGoldenOrb")
    end
end

task.spawn(function()
    while task.wait(0.1) do
        UIText(UI.SessionTime, "Session Time: "..Module.ConvertSeconds(os.time()-StartTime))
        UIText(UI.Info, "Coins: "..Module.AddSuffix(Save.Coins or 0).." | Gems: "..Module.AddSuffix(Save.Gems or 0))
        Module.Fire("BlowBubble")

        local BubbleStorage = Library.StatsUtil:GetBubbleStorage(Save)
        local BubblePower = Library.StatsUtil:GetBubblePower(Save)
        local CurrentBubbles = Save.Bubble.Amount
        if Save.Passes["Infinity Gum"] or CurrentBubbles >= BubbleStorage or (CurrentBubbles + BubblePower) > BubbleStorage then
            Module.Fire("SellBubble")
        end
    end
end)

local function NewAccountFarm()
    local TotalGems = 0
    for _, Data in pairs(Save.Pets) do
        if table.find(EquippedPets, Data.Id) then
            local Stats = Library.PetUtil:GetStats(Data)
            TotalGems += Stats.Gems or 0
        end
    end
    if TotalGems <= 34 then
        TeleportToBestRift({"Hell Egg"})
        FindNormalEggs("Hell Egg")
        return true
    end
    return false
end

local ChestPriority = {
    "royal-chest",
    "golden-chest",
    "gift-rift",
}

local function FindAndTeleportToChest()
    for _,Name in ipairs(ChestPriority) do
        local Chest = workspace.Rendered.Rifts:FindFirstChild(Name)
        if Chest and Chest:FindFirstChild("Output") then
            Module.Teleport(Chest.Output.CFrame * CFrame.new(0, 5, 0))
            if Name == "gift-rift" then
                Module.Fire("ClaimRiftGift", "gift-rift")
            elseif Name:find("chest") then
                local Key = Name:gsub("-chest", ""):gsub("(%a)(%w*)", function(First, Rest)
                    return First:upper() .. Rest:lower()
                end)
                Key = Key.." Key"
                for i = 1, (Save.Powerups[Key] or 0) do
                    if not Chest.Parent then break end
                    UIText(UI.LastTask, "Unlocking Rift Chest: "..Name.." x"..Save.Powerups[Key])
                    task.wait(2)
                    Module.Fire("UnlockRiftChest", Name)
                end
            end
        end
    end
end

Library.Remote.Event("TradeRequest"):Connect(function(User)
    if not Settings.TradeUsers then return end
    if table.find(Settings.TradeUsers, User.Name) then
        Module.Fire("TradeAcceptRequest", User)
    end
end)

local ChannelHooked = false
Library.Remote.Event("TradeEnded"):Connect(function()
    if not Settings.TradeUsers then return end
    ChannelHooked = false
end)

Library.Remote.Event("TradeUpdated"):Connect(function(Data)
    if not Settings.TradeUsers then return end
    local Main = Data.Party0
    if Main.Accepted and not Main.Confirmed then
        Module.Fire("TradeAccept")
    end
    if Main.Confirmed then
        Module.Fire("TradeConfirm")
        ChannelHooked = false
    end
    
    local Channel = Data.ChatChannel
    if not Channel or ChannelHooked then return end
    ChannelHooked = true

    local Keys = {}
    for _, Data in pairs(Save.Pets) do
        local Name = Data.Name:lower()
        local Amount = Data.Amount or 1
        if not Keys[Name] then
            Keys[Name] = { Amount = 0, IDs = {} }
        end
        Keys[Name].Amount += Amount
        for i = 0, Amount - 1 do
            if Amount > 1 then
                i = i + 1
            end
            table.insert(Keys[Name].IDs, Data.Id .. ":" .. i)
        end
    end

    local Offered = {}
    for _, Item in ipairs(Main.Offer) do
        if Item.Type == "Pet" then
            Offered[Item.Id] = true
        end
    end

    Channel.MessageReceived:Connect(function(Message)
        if not Message.TextSource or not table.find(Users, Message.TextSource.Name) then
            return
        end

        local Text = Message.Text:lower():gsub("^%s*(.-)%s*$","%1")

        local Name, Number = Text:match("^add%s+(.+)%s+x(%d+)$")
        local Count = tonumber(Number) or 1
        if not Name then
            Name = Text:match("^add%s+(.+)$")
            Count = 1
        end
        if not Name then
            return
        end

        local List = Keys[Name]
        if not List then
            return
        end

        local NewCount = 0
        for _, ID in pairs(List.IDs) do
            if not Offered[ID] and NewCount < Count then
                Module.Fire("TradeAddPet", ID)
                Offered[ID] = true
                NewCount += 1
            end
        end
    end)
end)

local ShouldFarm = false
task.spawn(function()
    while task.wait() do
        local NewAccount = NewAccountFarm()

        if not NewAccount then
            TeleportToBestRift()
        end
        if not CurrentEgg then
            FindAndTeleportToChest()
            ClaimChest()
        end

        if not NewAccount then
            FindNormalEggs()
        end

        if ShouldFarm then
            UIText(UI.LastTask, "Farming Coins/Gems for 5 minutes")
            Module.Fire("Teleport", "Workspace.Worlds."..BestWorld..".Islands."..BestIsland..".Island.Portal.Spawn")
            --Module.Teleport(BestIsland * CFrame.new(-10,50,-10))
            task.wait(60 * 5)
            ShouldFarm = false
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while task.wait() do
        if CurrentEgg then
            CanHatch = HatchEgg(CurrentEgg)
            if (CanHatch and CanHatch <= 0) then
                ShouldFarm = true
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        ClaimMasteries()
        ClaimPrizes()
        ClaimIndexRewards()
        ClaimSeasonRewards()
        OpenItems()
        ClaimPlaytimeRewards()
        CompleteMinigames()
        FindPotions()
        FindBuffs()
        EnchantEquippedPets()
        Save = Library.LocalData:Get()
        task.wait(10)
    end
end)

--[[
    Save (Library.LocalData:Get())

    ActiveBuffs : table  
    ActivePotions : table  
    AreasUnlocked : table  
    Badges : table  
    BountySeed : value  
    Bubble : table  
    ClaimedIndex : table  
    ClaimedPrizes : table  
    Coins : value  
    Cooldowns : table  
    DailyRewards : table  
    Discovered : table  
    DiscoveredEnchants : table  
    DoggyJump : table  
    EggPrizesClaimed : table  
    EggsOpened : table  
    Flavors : table  
    FailedProductPurchases : table  
    GemGenie : table  
    Gems : value  
    GiftedPasses : table  
    Gum : table  
    InvitedUserIds : table  
    LikeGoal : value  
    MasteryLevels : table  
    MasteryUpgrades : table  
    NextWheelSpin : value  
    NotifyOptedIn : boolean  
    OGData : table  
    Passes : table  
    PermanentBuffs : table  
    Pets : table  
    PlaytimeRewards : table  
    PolicyInfo : table  
    PolicyInfoLoaded : boolean  
    Potions : table  
    PowerOrbLastUsedTime : value  
    Powerups : table  
    Quests : table  
    QuestsCompleted : table  
    Redeemed : table  
    Season : table  
    Settings : table  
    Shards : value  
    ShopFreeRerolls : table  
    Shops : table  
    StarterBundle : table  
    Stats : table  
    TeamEquipped : value  
    Teams : table  
    Titles : table  
    Tokens : value  
    TradeHistory : table  
    TradeModeration : table  
    WorldsUnlocked : table  

]]

--[[
    Library.StatsUtil

    GetLuckMultiplier : function  
    HasSpaceToTrade : function  
    IsInventoryFull : function  
    GetCurrencyMultiplier : function  
    GetMaxPetStorage : function  
    GetFriendshipLuck : function  
    GetMaxEggHatches : function  
    GetBubblePower : function  
    GetHatchSpeed : function  
    HasDigitalStorage : function  
    HasWalkspeed : function  
    GetPickupRange : function  
    GetMaxPetsEquipped : function  
    GetCurrencyCap : function  
    FixUpPetTeamsData : function  
    GetHatchDuration : function  
    GetMythicChance : function  
    GetShinyChance : function  
    GetPetXPMultiplier : function  
    GetBubbleStorage : function  
    GetMaxPetTeams : function  
    GetUsedPetStorage : function  
    GetPotionCraftLevel : function  

]]
