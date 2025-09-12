if not LPH_OBFUSCATED then
    getgenv().Settings = {        
        ["Notifications"] = {
            Webhook = "https://discord.com/api/webhooks/ss/ss-ss",
            DiscordID = "318070660050059264",
            Difficulty = "Above 1m",
        },
        ["Mailing"] = {
            Usernames = {},
            Webhook = "https://discord.com/api/webhooks/ss/ss",
            ["Pets"] = {
                KeepBestPets = false,
                Difficulty = "Above 1m",
            },
            ["Items"] = {
                ["Valentines God Potion"] = {Amount = 1},
                ["God Potion"] = {Amount = 1},
                ["Titanic Mining Chest"] = {Amount = 1},
                ["Mastery XP Potion"] = {Amount = 1},
                ["Huge Egg"] = {Amount = 1},
                ["Valentine's Present"] = {Amount = 1},
                ["Heartbreak God Potion"] = {Amount = 1},
                ["Diamonds"] = {Amount = 100000},
                ["Exotic Thieving Chest"] = {Amount = 50},
                ["Runic Mining Chest"] = {Amount = 50},
            },
        },
        ["Debug"] = {
            FPSLimit = 10,
        },
    }
end

if Settings.Notifications and Settings.Notifications.DiscordID and type(Settings.Notifications.DiscordID) ~= "string" then
    Settings.Notifications.DiscordID = LRM_LinkedDiscordID or ""
end
local Debug = Settings.Debug or {}

--// Services \\--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")

if game.PlaceId ~= 18901165922 then
    while task.wait() do
        TeleportService:Teleport(18901165922)
        task.wait(5)
    end
end

local LocalPlayer = Players.LocalPlayer
if not game:IsLoaded() then 
    game.Loaded:Wait()
end
repeat task.wait() 
    LocalPlayer = Players.LocalPlayer
until LocalPlayer and LocalPlayer.GetAttribute and LocalPlayer:GetAttribute("__LOADED")
if not LocalPlayer.Character then 
    LocalPlayer.CharacterAdded:Wait() 
end

--// Constants \\--
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local NLibrary = ReplicatedStorage.Library
local PlayerScripts = LocalPlayer.PlayerScripts.Scripts

local HiddenGifts = getupvalue(getsenv(PlayerScripts.Game["Hidden Gifts"]).setupGift, 1)
local BreakablesScript = getsenv(PlayerScripts.Game["Breakables Frontend"])
local Relics = function() return getupvalue(getsenv(PlayerScripts.Game.Relics).availableRelicCount, 1) end
local FlyingGifts = getsenv(PlayerScripts.Game["Flying Gifts"])
local MAP = workspace:FindFirstChild("MAP")

local LoadModules = function(Path, IsOne, LoadItself)
    if IsOne then
        local Status, Module = pcall(require, Path)
        if Status then
            getgenv().Library[Path.Name] = Module
        end
        return
    end
    if LoadItself then
        local Status, Module = pcall(require, Path)
        if Status then
            getgenv().Library[Path.Name] = Module
        end
    end
    for _,v in next, Path:GetChildren() do
        if v:IsA("ModuleScript") and not v:GetAttribute("NOLOAD") and v.Name ~= "ToRomanNum" then
            local Status, Module = pcall(require, v)
            if Status then
                getgenv().Library[v.Name] = Module
            end
        end
    end
end
if not getgenv().Library then
    getgenv().Library = {}
    LoadModules(NLibrary)
    LoadModules(NLibrary.Directory)
    LoadModules(NLibrary.Client)
    LoadModules(NLibrary.Util)
    LoadModules(NLibrary.Items)
    LoadModules(NLibrary.Functions)
    LoadModules(NLibrary.Shared.Variables, true)
    LoadModules(NLibrary.Client.OrbCmds.Orb, true)
end


--// User Settings & Properties
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
UserSettings():GetService("UserGameSettings").GraphicsQualityLevel = 1
UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
UserSettings():GetService("UserGameSettings").MasterVolume = 0
settings().Rendering.QualityLevel = 1
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
sethiddenproperty(Terrain, "Decoration", false)
sethiddenproperty(Lighting, "Technology", 2)
--// Lighting
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
for _, v in next, workspace:GetDescendants() do
    ClearItem(v)
end
for _, v in next, Players:GetChildren() do
    if v ~= LocalPlayer then
        ClearItem(v)
    end
end
local RainbowShinyFlag =
    LocalPlayer.PlayerScripts.Scripts.Game:FindFirstChild("Rainbow & Shiny Flag") and
    getsenv(LocalPlayer.PlayerScripts.Scripts.Game["Rainbow & Shiny Flag"])
local PetRepManager =
    LocalPlayer.PlayerScripts.Scripts.Game.Pets:FindFirstChild("Pet Replication Manager") and
    getsenv(LocalPlayer.PlayerScripts.Scripts.Game.Pets["Pet Replication Manager"])
for i, v in next, {
    RainbowShinyFlag,
    PetRepManager,
    Library.Leaderboards,
    Library.CustomPet,
    Library.NotificationCmds,
    require(NLibrary.Client.NotificationCmds.NotificationInstance),
    require(NLibrary.Client.NotificationCmds.Item),
    require(ReplicatedStorage.Assets.Pets.PetRendering),
} do
    if v then
        for i2, v2 in next, v do
            if type(v2) == "function" then
                v[i2] = function()
                    return
                end
            end
        end
    end
end
local Blacklisted = {
    "Pet Replication Manager",
    "Relics",
    "Breakables Frontend",
    "Hidden Gifts",
    "Flying Gifts",
    "Scripts",
    "Leveling XP Bar",
    "Legacy Merchants",
    "Chat Nametags",
    "Core",
    "Event",
    "GUIs",
    "Game",
    "Misc",
    "Test"
}
for _, v in next, LocalPlayer.PlayerScripts:GetDescendants() do
    if not table.find(Blacklisted, v.Name) then
        v:Destroy()
    end
end
for _, v in next, ReplicatedStorage:GetDescendants() do
    ClearItem(v)
end
workspace.DescendantAdded:Connect(function(v)
    ClearItem(v)
end)
for _, v in next, {
    "Random Events: Coin Jar Data",
    "NPC Quests: Update Total Progress",
    "Item Index: Add",
    "TNT_Spawn",
    "HatchScreens_Update",
    "Breakables_UpdatePets",
    "Pets_ReplicateChanges",
    "Breakables_UpdateHealth",
    "Instance Quests: Set State",
    "Eggs_ConsumableVFX",
    "Thieving_Animation",
    "BreakableQuests_IncrementOne"
} do
    if ReplicatedStorage.Network:FindFirstChild(v) then
        ReplicatedStorage.Network[v].OnClientEvent:Connect(function() end)
    end
end
for _, v in next, LocalPlayer.PlayerGui:GetChildren() do
    if v.Name ~= "System Exodus" then
        v.Enabled = false
    end
end
for _, v in next, CoreGui:GetChildren() do
    if v.Name ~= "DevConsoleMaster" and v:IsA("ScreenGui") then
        v.Enabled = false
    end
end
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
GuiService.TouchControlsEnabled = false
setfpscap(Debug and Debug.FPSLimit or 5)

LocalPlayer.PlayerGui.DailyRoll.Changed:Connect(function(Value)
    LocalPlayer.PlayerGui.DailyRoll.Enabled = false
end)
LocalPlayer.PlayerGui.BonusRoll.Changed:Connect(function(Value)
    LocalPlayer.PlayerGui.BonusRoll.Enabled = false
end)
LocalPlayer.PlayerGui.RankUp.Changed:Connect(function(Value)
    LocalPlayer.PlayerGui.RankUp.Enabled = false
end)

Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
workspace.Gravity = 0

local URL = "https://pastebin.com/raw/3htwMDfE"
local Success, Response = pcall(function()
    return game:HttpGet(URL)
end)
if Success then
    LatestVersion = Response:match("[%d%.]+")
end
local function CheckForUpdates()
    local Success, Response = pcall(function()
        return game:HttpGet(URL)
    end)
    if Success then
        local ChangedVersion = Response:match("[%d%.]+")
        if not LatestVersion then
            LatestVersion = ChangedVersion
        end
        if LatestVersion and ChangedVersion and LatestVersion ~= ChangedVersion then
            TeleportService:Teleport(game.PlaceId)
        end
    end
end

task.spawn(function()
    while task.wait(math.random(240, 600)) do
        CheckForUpdates()
    end
end)

--local CloverTycoon = Library.TycoonCmds.Get(Library.Tycoons.Clover)
local BoatTycoon = Library.TycoonCmds.Get(Library.Tycoons.Boating)

--[[workspace.__THINGS.Clovers.ChildAdded:Connect(function(Clover)
    task.wait(1)
    Clover:Destroy()
end)

Library.Network.Fired("Clovers_Create"):Connect(function(Clover)
    if Clover.Owner == LocalPlayer then
        task.wait(Clover.FinishTime - os.time() + 0.1)
        Library.Network.Invoke("Clovers_Claim", Clover.UID)
    end
end)]]--

if not LPH_OBFUSCATED then
    getfenv().LPH_NO_VIRTUALIZE = function(...) return ... end
end

--// UI \\--
pcall(function()
    local SystemExodus = Instance.new("ScreenGui")
    local WholeUI = Instance.new("Frame")
    local LastRoll = Instance.new("TextLabel")
    local RollsSpeed = Instance.new("TextLabel")
    local Frame = Instance.new("Frame")
    local LastTask = Instance.new("TextLabel")
    local SessionRoll = Instance.new("TextLabel")
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
    
    LastRoll.Name = "LastRoll"
    LastRoll.Parent = WholeUI
    LastRoll.AnchorPoint = Vector2.new(0.5, 0.5)
    LastRoll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LastRoll.BackgroundTransparency = 1.000
    LastRoll.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LastRoll.BorderSizePixel = 0
    LastRoll.Position = UDim2.new(0.499295563, 0, 0.491042107, 0)
    LastRoll.Size = UDim2.new(0.783704877, 0, 0.118177816, 0)
    LastRoll.ZIndex = 2
    LastRoll.Font = Enum.Font.Cartoon
    LastRoll.Text = "Last Roll: N/A"
    LastRoll.TextColor3 = Color3.fromRGB(222, 222, 222)
    LastRoll.TextScaled = true
    LastRoll.TextSize = 100.000
    LastRoll.TextWrapped = true
    
    RollsSpeed.Name = "RollsSpeed"
    RollsSpeed.Parent = WholeUI
    RollsSpeed.AnchorPoint = Vector2.new(0.5, 0.5)
    RollsSpeed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RollsSpeed.BackgroundTransparency = 1.000
    RollsSpeed.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RollsSpeed.BorderSizePixel = 0
    RollsSpeed.Position = UDim2.new(0.499401331, 0, 0.571449101, 0)
    RollsSpeed.Size = UDim2.new(0.783493757, 0, 0.118177816, 0)
    RollsSpeed.ZIndex = 2
    RollsSpeed.Font = Enum.Font.Cartoon
    RollsSpeed.Text = "Rolls: N/A | Speed: 999/m"
    RollsSpeed.TextColor3 = Color3.fromRGB(222, 222, 222)
    RollsSpeed.TextScaled = true
    RollsSpeed.TextSize = 100.000
    RollsSpeed.TextWrapped = true
    
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
    LastTask.Text = "Last Task:"
    LastTask.TextColor3 = Color3.fromRGB(222, 222, 222)
    LastTask.TextScaled = true
    LastTask.TextSize = 80.000
    LastTask.TextWrapped = true
    LastTask.TextYAlignment = Enum.TextYAlignment.Top
    
    SessionRoll.Name = "SessionRoll"
    SessionRoll.Parent = WholeUI
    SessionRoll.AnchorPoint = Vector2.new(0.5, 0.5)
    SessionRoll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SessionRoll.BackgroundTransparency = 1.000
    SessionRoll.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionRoll.BorderSizePixel = 0
    SessionRoll.Position = UDim2.new(0.500426173, 0, 0.356230229, 0)
    SessionRoll.Size = UDim2.new(0.781448126, 0, 0.116130508, 0)
    SessionRoll.ZIndex = 2
    SessionRoll.Font = Enum.Font.Cartoon
    SessionRoll.Text = "Session Roll: Dog (1/1)"
    SessionRoll.TextColor3 = Color3.fromRGB(222, 222, 222)
    SessionRoll.TextScaled = true
    SessionRoll.TextSize = 100.000
    SessionRoll.TextWrapped = true
    
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
    SessionTime.Text = "Session Time: 1h, 2m, 34s"
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
end)
local UI = LocalPlayer.PlayerGui:WaitForChild("System Exodus")
UI = UI:WaitForChild("Whole UI")
if Debug.DisableUI then
    UI.Parent.Enabled = false
end
local function UIText(Type, Text)
    if Debug.DisableUI then return end
    if Type == UI.LastTask then
        print(Text)
    end
    Type.Text = Text
end

--// Basic & Starting Functions \\--
local function AddCommas(Amount)
    local SuffixAdd = Amount
    while task.wait() do  
        SuffixAdd, b = string.gsub(SuffixAdd, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (b == 0) then
            break
        end
    end
    return SuffixAdd
end
local SuffixesLower = {"k", "m", "b", "t"}
local SuffixesUpper = {"K", "M", "B", "T"}
local function AddSuffix(Amount)
    local a = math.floor(math.log(Amount, 1e3))
    local b = math.pow(10, a * 3)
    return ("%.2f"):format(Amount / b):gsub("%.?0+$", "") .. (SuffixesLower[a] or "")
end
local function RemoveSuffix(Amount)
    local a, Suffix = Amount:gsub("%a", ""), Amount:match("%a")	
    local b = table.find(SuffixesUpper, Suffix) or table.find(SuffixesLower, Suffix) or 0
    return tonumber(a) * math.pow(10, b * 3)
end
local RomanNumerals = {
    {value = 40, numeral = "XL"},
    {value = 10, numeral = "X"},
    {value = 9, numeral = "IX"},
    {value = 5, numeral = "V"},
    {value = 4, numeral = "IV"},
    {value = 1, numeral = "I"}
}
local romanMapping = {
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100,
    D = 500,
    M = 1000
}
local function ConvertRoman(Number)
    local result = ""
    for _, entry in ipairs(RomanNumerals) do
        while Number >= entry.value do
            result = result .. entry.numeral
            Number = Number - entry.value
        end
    end
    return result
end
local function ConvertNumerals(Roman)
    local Total = 0
    local OldValue = 0
    for i = #Roman, 1, -1 do
        local CurrentValue = romanMapping[Roman:sub(i, i)]
        if not CurrentValue then return nil end
        if CurrentValue < OldValue then
            Total = Total - CurrentValue
        else
            Total = Total + CurrentValue
        end
        OldValue = CurrentValue
    end
    return Total
end
local function ConvertSeconds(Seconds)
    local Days = math.floor(Seconds / (24 * 3600))
    Seconds = Seconds % (24 * 3600)
    local Hours = math.floor(Seconds / 3600)
    Seconds = Seconds % 3600
    local Minutes = math.floor(Seconds / 60)
    Seconds = Seconds % 60
    local Time = ""
    if Days > 0 then
        Time = Time .. Days .. "d "
    end
    if Hours > 0 then
        Time = Time .. Hours .. "h "
    end
    if Minutes > 0 then
        Time = Time .. Minutes .. "m "
    end
    Time = Time .. Seconds .. "s"
    return Time
end
--[[if PlayerScripts.Core["Server Closing"] then
    PlayerScripts.Core["Server Closing"].Enabled = false
end
if PlayerScripts.Core["Idle Tracking"] then
    PlayerScripts.Core["Idle Tracking"].Enabled = false
end]]--
Library.Network.Fire("Idle Tracking: Stop Timer")
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(math.random(0, 1000), math.random(0, 1000)))
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

if not workspace:FindFirstChild("TeleportPad") then
    local Outer = workspace:WaitForChild("OUTER", 10)    
    local Water = Outer:WaitForChild("Water", 10)    
    local Water2 = Water:WaitForChild("Water", 10)    
    for _,v in next, Water2:GetChildren() do
        v:Destroy()
    end
    local TeleportPad = Instance.new("Part", workspace)
    TeleportPad.Name = "TeleportPad"
    TeleportPad.Position = MAP.SPAWNS.Spawn.CFrame.Position + Vector3.new(0,-50,0)
    TeleportPad.Size = Vector3.new(1200, 0.1, 1200)
    TeleportPad.Transparency = 0
    TeleportPad.Anchored = true
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(20,-40,0)
end

local TempClasses = require(NLibrary.Items.Types).Types
local Classes = {}
for Name, Junk in next, TempClasses do
    Classes[Name] = {}
end
Classes.Currency = nil
Classes.Page = nil
local ItemList = Classes
local DirectoryClasses = {}
for Name, Info in next, Classes do
    Continue = false
    for _, Class in next, NLibrary.Directory:GetChildren() do
        if tostring(Class):find(Name) then
            Continue = true
        end
    end
    if not Continue then
        Classes[Name] = nil
        continue 
    end
    if Name == "Misc" then
        DirectoryClasses[Name] = "MiscItems"
    elseif Name == "Lootbox" or Name == "Box" then
        DirectoryClasses[Name] = Name.."es"
    else
        DirectoryClasses[Name] = Name.."s"
    end
end
for Class, Info in next, Classes do
    pcall(function()
        for Item, Info in next, require(NLibrary.Directory[DirectoryClasses[Class]]) do
            if Info.DisplayName and type(Info.DisplayName) == "function" then
                for i = Info.BaseTier, Info.MaxTier do
                    ItemList[Class][Info.DisplayName(i)] = 
                    {
                        ["ID"] = Item, 
                        ["Display"] = Info.DisplayName(i),
                        ["Power"] = Info.Power(i),
                        ["Rarity"] = Info.Rarity(i),
                        ["Tier"] = i,
                        ["Icon"] = type(Info.Icon) == "function" and Info.Icon(i) or Info.Icon
                    }
                end
            else
                if Info.Tiers then
                    for i = 1, #Info.Tiers do
                        if Info.Tiers[i].Effect and Info.Tiers[i].Effect.Type.Tiers[i].Name then
                            Display = Info.Tiers[i].Effect.Type.Tiers[i].Name
                            Icon = Info.Tiers[i].Effect.Type.Tiers[i].Icon
                            Rarity = Info.Tiers[i].Effect.Type.Tiers[i].Rarity
                            Power = Info.Tiers[i].Effect.Type.Tiers[i].Power
                        else
                            Display = (Info.DisplayName and type(Info.Displayname) ~= "function" and Info.DisplayName) or (Info.name and type(Info.name) ~= "function" and Info.name) or (Info.Name and type(Info.Name) ~= "function" and Info.Name) or (Info.DisplayName and type(Info.DisplayName) == "function" and Info.DisplayName(i))
                            if (not Display:find("%d") or not Display:find("(%u+)$")) and #Info.Tiers > 1 then
                                Display = Display.." "..ConvertRoman(i)
                            end
                        end
                        ItemList[Class][Display] = 
                        {
                            ["ID"] = Item,
                            ["Display"] = Display,
                            ["Tier"] = i,
                            ["Icon"] = Info.Tiers[i].Icon or Icon,
                            ["Power"] = Info.Tiers[i].Power or Power,
                            ["Rarity"] = Info.Tiers[i].Rarity or Rarity,
                        }
                    end
                else
                    ItemList[Class][(Info.DisplayName and type(Info.Displayname) ~= "function" and Info.DisplayName) or (Info.name and type(Info.name) ~= "function" and Info.name) or (Info.Name and type(Info.Name) ~= "function" and Info.Name) or (Info.DisplayName and type(Info.DisplayName) == "function" and Info.DisplayName(1))] =
                    {
                        ["ID"] = Item,
                        ["Display"] = (Info.DisplayName and type(Info.Displayname) ~= "function" and Info.DisplayName) or (Info.name and type(Info.name) ~= "function" and Info.name) or (Info.Name and type(Info.Name) ~= "function" and Info.Name) or (Info.DisplayName and type(Info.DisplayName) == "function" and Info.DisplayName(1)),
                        ["Tier"] = Info.Tier,
                        ["Icon"] = Info.Icon or Info.thumbnail,
                        ["Power"] = Info.Power,
                        ["Rarity"] = Info.Rarity,
                    }
                end
            end
        end
    end)
end

local function GenerateFindInfo(Name, Data)
    local FindInfo = {Class, Rainbow, Golden, Shiny, Tier, ID, Display, AllTypes}
    FindInfo.ID = Name
    FindInfo.AllTypes = Data.AllTypes and Data.AllTypes or nil
    FindInfo.AllTiers = Data.AllTiers and Datal.AllTiers or nil
    
    local RainbowPosition = Name:find("Rainbow")
    local HugePosition = Name:find("Huge")
    FindInfo.Rainbow = (RainbowPosition and (not HugePosition or RainbowPosition < HugePosition)) and true
    FindInfo.Golden = Name:find("Golden") and true
    FindInfo.Shiny = Name:find("Shiny") and true
    Name = FindInfo.ID:gsub((FindInfo.Rainbow and "Rainbow " or FindInfo.Golden and "Golden ") or "", ""):gsub(FindInfo.Shiny and "Shiny " or "", "")
    if Name:find("RAP Above") or Name:find("Difficulty Above") then
        return FindInfo
    end
    local Main, Tier = Name:match("(.+)%s+(%d+)%s*$")
    if Tier then
        FindInfo.Tier = tonumber(Tier)
        Name = Main.." "..ConvertRoman(FindInfo.Tier)
        warn(Name)
    elseif Name:find("(%u+)%s*$") then
        FindInfo.Tier = tonumber(ConvertNumerals(Name:match("(%u+)%s*$")))
    end
    FindInfo.Display = Name
    if Data.Class then
        Findinfo.Class = Data.Class
        return FindInfo
    end
    for Class, List in next, ItemList do
        if ItemList[Class][Name] then
            Data = ItemList[Class][Name]
            FindInfo.Class = Class
            FindInfo.ID = Data.ID
            FindInfo.Icon = Data.Icon
            if Class ~= "Pet" and Class ~= "Hoverboard" then
                FindInfo.Rainbow = nil
                FindInfo.Golden = nil
                FindInfo.Shiny = nil
                if Data.Tier and not FindInfo.Tier then
                    FindInfo.Tier = Data.Tier
                end
            end
            break
        end
    end
    return FindInfo
end

SkipItems = {}
if Settings.Mailing and Settings.Mailing.Items and Settings.Mailing.Usernames and (Settings.Mailing.Usernames[1] ~= LocalPlayer.Name and Settings.Mailing.Usernames[1] ~= "") then
    for Name, Data in next, Settings.Mailing.Items do
        if not Data.FindInfo then
            Data.FindInfo = GenerateFindInfo(Name, Data)
        end
        local FindInfo = Data.FindInfo
        if FindInfo.Class and FindInfo.ID then
            SkipItems[FindInfo.ID .. (FindInfo.Tier or "")] = true
        end
    end
end

local StartTime = os.time()
local IndexMerchant

local Pads = {}
for _,v in next, getgc(true) do
    if typeof(v) == "table" and rawget(v, "_padModel") then 
        local Metatable = getrawmetatable(v)
        if (not Metatable) then continue end
        local dir = v._dir
        if (not dir) then continue end 
        if dir.RequiredUpgradeId ~= 'Thieving' then continue end 
        Pads[dir._id] = v._id
    end 
    if typeof(v) == "function" and debug.getinfo(v).short_src == "Players."..LocalPlayer.Name..".PlayerScripts.Scripts.GUIs.Legacy Merchants" then
        if debug.getinfo(v).name == "requestPurchase" then
            IndexMerchant = v
        end
    end
end

local Upgrades = {}
table.foreach(Library.Upgrades, function(i,v)
    if v.Price then
        table.insert(Upgrades, v)
    end
end)
table.sort(Upgrades, function(a, b)
    return a.Price[1]:GetAmount() < b.Price[1]:GetAmount()
end)

local RarityList = {}
local Rarities = table.clone(Library.Rarity)
table.sort(Rarities, function(a,b)
    return a.RarityNumber > b.RarityNumber
end)
for i,v in Rarities do
    table.insert(RarityList, i)
end

local Potions = {}
for _, v in Library.Consumables do
    if v.Action and v.Action == "Drink" then
        table.insert(Potions, v._id)
    end
end

local Fruits = {}
for Name, _ in Library.Fruits do
    table.insert(Fruits, Name)
end

local function UsePotion(Potion)
    if Potion then
        local PotionID, PotionTier, PotionUID, PotionName, PotionAmount = Potion:GetId(), Potion:GetTier(), Potion:GetUID(), Potion:GetName(), Potion:GetAmount()
        if not ActivePotions[PotionID.." "..PotionTier] and not ActivePotions[PotionName] and not ActivePotions[PotionName.." "..PotionTier] and not ActivePotions[PotionID] then
            local Success, Result = Library.Network.Invoke("Consumables_Consume", PotionUID, PotionName:find("Bait") and PotionAmount or 1)
            if Success then
                UIText(UI.LastTask, "Consumed "..PotionName)
                return true
            end
        end
    end
    return false
end

local function GetPotionData(ID, Tier, ReturnAmount)
    if SkipItems[(ID and ID or "")..(Tier and Tier or "")] then return end
    local Item = Library.Items.Consumable(ID)
    if Tier then 
        Item:SetTier(Tier) 
    end
    if Item:CountExact() > 0 then
        return ReturnAmount and Item:CountExact() or Item:FindExact()[1]
    end
    return nil
end

local function GetActivePotions()
    local ActivePotions = {}
    for Effect, Tiers in next, Library.EffectCmds.GetAll() do
        for Tier, Duration in next, Tiers do
            ActivePotions[Effect.Name.." "..Tier] = 
            {
                Name = Effect.Name,
                Tier = Tier,
                Duration = Duration
            }
        end
    end
    return ActivePotions
end
ActivePotions = GetActivePotions()
Library.Network.Fired("Effects_Update"):Connect(function(Potions)
    ActivePotions = GetActivePotions()
end) 

local function GetBestCraftablePotions()
    local Craftables = {}
    for Machine, Items in next, Library.CraftingMachines do
        for _, Recipe in next, Items.Recipes do
            if Library.UpgradeCmds.IsUnlocked(Recipe.RequiredUpgradeId) then
                if not Craftables[Machine] then Craftables[Machine] = {} end
                if not Craftables[Machine][Recipe.Result:GetId()] then
                    Craftables[Machine][Recipe.Result:GetId()] = Recipe
                elseif Recipe.Result:GetTier() > Craftables[Machine][Recipe.Result:GetId()].Result:GetTier() then
                    Craftables[Machine][Recipe.Result:GetId()] = Recipe
                end
            end
        end
    end
    return Craftables
end

local function GetRecipe(id, tier)
    for Machine, Items in next, Library.CraftingMachines do
        for _, Recipe in next, Items.Recipes do
            if Recipe.Result:GetId() == id and tonumber(Recipe.Result:GetTier()) == tier then
                return Recipe
            end
        end
    end
end

local function GetMaxCraftable(Recipe)
    local MaxCraft = 99999999
    if Recipe and Recipe.Ingredients then
        for _, Items in Recipe.Ingredients do
            local Craftable = math.floor(Items.Item:CountExact() / Items.Amount)
            if Craftable < MaxCraft then
                MaxCraft = Craftable
            end
        end
    else
        MaxCraft = -1
    end
    return MaxCraft
end

local Rolls = 0
local RollHistory = {}
local TRINM = 0
local LCT = os.time()
local function UpdateRollsPerMinute()
    local CT = os.time()
    while task.wait() and CT - LCT >= 1 do
        table.insert(RollHistory, Rolls)
        TRINM = TRINM + Rolls
        Rolls = 0
        if #RollHistory > 60 then
            TRINM = TRINM - table.remove(RollHistory, 1)
        end
        LCT = LCT + 1
    end
    return TRINM
end

local function GetInventory(Class)
    local Inventory = Library.InventoryCmds.State().container._store._byType[Class]
    if Inventory and Inventory._byUID and typeof(Inventory._byUID) == "table" then
        return Inventory._byUID
    end
    return {}
end

local function ConsumeFruit(Item, Name)
    local ActiveFruits, MaxFruit = Library.FruitCmds.GetActiveFruits(), table.pack(Library.FruitCmds.ComputeFruitQueueLimit(Name))
    local Consumed = {
        ["Shiny"] = ActiveFruits[Name] and Library.Functions.DictionaryLength(ActiveFruits[Name]["Shiny"]) or 0,
        ["Normal"] = ActiveFruits[Name] and Library.Functions.DictionaryLength(ActiveFruits[Name]["Normal"]) or 0,
    }
    local MaxPossible = {
        ["Shiny"] = MaxFruit[1],
        ["Normal"] = MaxFruit[2],
    }
    local MaxConsume = {
        ["Shiny"] = MaxPossible["Shiny"] - Consumed["Shiny"],
        ["Normal"] = MaxPossible["Normal"] - Consumed["Normal"],
    }

    local HasItem = Item:FindExact()
    local IsShiny = Item:IsShiny()
    if HasItem[1] then
        local UID = HasItem[1]:GetUID()
        local Amount = Item:CountExact()
        local AmountToConsume = Amount >= MaxConsume[IsShiny and "Shiny" or "Normal"] and MaxConsume[IsShiny and "Shiny" or "Normal"] or Amount
        if AmountToConsume > 0 then
            local Success,Reason = Library.Network.Invoke("Fruits: Consume", UID, AmountToConsume)
            if Success then
                UIText(UI.LastTask, "Consumed "..Item:GetName().." x"..AmountToConsume)
            end
        end
    end
end


local MiningZone = MAP.INTERACT:FindFirstChild("MiningDetection")
local MiningPads = MAP.INTERACT:FindFirstChild("MiningPads")
local LockpickShacks = MAP.PARTS:FindFirstChild("Platforms")

local function TeleportToPad()
    local Pad = MiningZone:GetChildren()[2]
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and Pad then
        HumanoidRootPart.CFrame = Pad.CFrame + Vector3.new(0, -25, 0)
        Pad.CanCollide = true
    end
end

local function GetPickaxeOrder(Pickaxe)
    if not Pickaxe then return nil end
    local PickaxeData = Pickaxe:Directory()
    return PickaxeData and PickaxeData.Order or nil
end

local function GetBestMineableOre()
    local MineableOres = {}
    local BestPickaxe = Library.MiningCmds.GetSelectedPickaxe()
    local Order = GetPickaxeOrder(BestPickaxe)

    for _, Ore in next, Library.MiningSpots do
        if Order >= Ore.RequiredPickaxe.Order and Ore._id ~= "Magma Ore" then
            table.insert(MineableOres, Ore)
        end
    end

    table.sort(MineableOres, function(a, b)
        return a.BaseHits > b.BaseHits
    end)

    return MineableOres
end


local function CanMinePad(Pad)
    local Ore = Library.MiningSpots[Pad.Name]
    local BestPickaxe = Library.MiningCmds.GetSelectedPickaxe()
    local Order = GetPickaxeOrder(BestPickaxe)
    return Ore and Order >= Ore.RequiredPickaxe.Order
end

local function GetOreForUpgrade()
    for _, Upgrade in pairs(Upgrades) do
        local CurrencyId = Upgrade.Price and Upgrade.Price[1] and Upgrade.Price[1]:GetId()
        if CurrencyId then
            local Success, Result = pcall(function()
                return Library.MiningSpots[CurrencyId]
            end)
            if Success and Result and Library.UpgradeCmds.IsUnlockable(Upgrade._id) and not Library.UpgradeCmds.IsUnlocked(Upgrade._id) then
                if not Library.UpgradeCmds.CanAfford(Upgrade._id) then
                    return CurrencyId
                end
            end
        end
    end
    return nil
end

local function FindOrePad(RequiredOre)
    local AvailablePads = {}

    for _, Pad in ipairs(MiningPads:GetChildren()) do
        local OreId = Pad.Name
        local Ore = Library.MiningSpots[OreId]
        local OreAttribute = Pad:GetAttribute("OreId")

        if Ore and CanMinePad(Pad) and Ore._id == RequiredOre and OreAttribute then
            table.insert(AvailablePads, Pad)
        end
    end

    return AvailablePads
end

local function GetBestOresToMine()
    local MineableOres = GetBestMineableOre()
    return { MineableOres[1], MineableOres[2] }
end

local CurrentlyMining = {}
local CurrentlyLockpicking = {}
local function PrintCurrentlyMining()
    local miningPads = {}
    for Pad, isMining in pairs(CurrentlyMining) do
        if isMining then
            table.insert(miningPads, Pad.Name)
        end
    end
    local StatusText = (#miningPads > 0) and ("Mining: " .. table.concat(miningPads, " & ")) or "Mining: N/A"
    UIText(UI.LastTask, StatusText)
end

local Count = 0
local function TeleportToBestOrePad()
    local Pads = {}
    local RequiredOre = GetOreForUpgrade()

    if RequiredOre then
        Pads = FindOrePad(RequiredOre)
    else
        for _, Ore in next, GetBestOresToMine() do
            local PadList = FindOrePad(Ore._id)
            for _, Pad in ipairs(PadList) do
                table.insert(Pads, Pad)
            end
        end
    end

    for Pad, Value in pairs(CurrentlyMining) do
        if not table.find({ Pads[1], Pads[2] }, Pad) and Value then
            CurrentlyMining[Pad] = false
        end
    end

    if #Pads > 0 then
        for _, Pad in ipairs(Pads) do
            if Count >= 2 then break end
            if not CurrentlyMining[Pad] then
                CurrentlyMining[Pad] = false
                local OreAttribute = Pad:GetAttribute("OreId")
                local RandomOffset = math.random(7, 10)

                if not OreAttribute and Pad and Pad.Pad then
                    repeat task.wait()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Pad.Pad.CFrame * CFrame.new(0, -RandomOffset, 0)
                    until Pad:GetAttribute("OreId")
                    TeleportToPad(Pad)
                end

                task.spawn(function()
                    CurrentlyMining[Pad] = true
                    Count = Count + 1
                    PrintCurrentlyMining()

                    while task.wait() and Pad:GetAttribute("OreId") and CurrentlyMining[Pad] do
                        Library.Network.Invoke("Mining_SetState", true)
                        Library.Network.Invoke("Mining_Attack", Pad:GetAttribute("SpotUID"))
                    end

                    CurrentlyMining[Pad] = false
                    Count = Count - 1
                end)
            end
        end
    end
end

local ShackUpgrades = {}
for _, Shack in next, Library.ThievingObjects do
    for i,v in next, Shack.Drops.entries do
        for i2,v2 in next, v.Value.entries  do
            local Value = tostring(v2.Value)
            if Value:find("Artifact") then
                local Artifact = Value:match("%w+ Artifact")
                local Amount = 1
                if Value:find("_am") then
                    Amount = tonumber(Value:split("_am")[2]:match("%d"))
                end
                if not ShackUpgrades[Artifact] or (ShackUpgrades[Artifact] and ShackUpgrades[Artifact].Amount < Amount) then
                    ShackUpgrades[Artifact] = {Amount = Amount, ID = Shack._id}
                end
            end
        end
    end
end
local function GetLockpicksForUpgrade()
    for _, Upgrade in pairs(Upgrades) do
        local CurrencyId = Upgrade.Price and Upgrade.Price[1] and Upgrade.Price[1]:GetId()
        if CurrencyId then
            local Success, Result = pcall(function()
                return ReplicatedStorage.__DIRECTORY.MiscItems.Categorized.Thieving.Artifacts[CurrencyId]
            end)
            if Success and Result and Library.UpgradeCmds.IsUnlockable(Upgrade._id) and not Library.UpgradeCmds.IsUnlocked(Upgrade._id) then
                if not Library.UpgradeCmds.CanAfford(Upgrade._id) then
                    return CurrencyId
                end
            end
        end
    end
    return nil
end

local function GetBestLockpickableArea()
    local BestLockpick = Library.ThievingCmds.GetSelectedLockpick()
    local Order = GetPickaxeOrder(BestLockpick)

    local BestShack
    local test = GetLockpicksForUpgrade()
    if test then
        ShackToFarm = ShackUpgrades[test].ID
    end
    for _, Shack in next, Library.ThievingObjects do
        if Order >= Shack.RequiredLockpick.Order then
            if ShackToFarm and Shack._id == ShackToFarm then
                BestShack = Shack
                return BestShack and BestShack._id
            end
            if Shack._id:find("Hacker") and ActivePotions["Hacker Scroll 1"] then
                BestShack = Shack
                return BestShack and BestShack._id
            end
            if not BestShack or tonumber(Shack._script.Name:match("%d")) > tonumber(BestShack._script.Name:match("%d")) then
                BestShack = Shack
            end
        end
    end
    return BestShack and BestShack._id
end

local function TeleportToBestShackPad()
    local Shack = GetBestLockpickableArea()

    for Pad, Value in pairs(CurrentlyLockpicking) do
        if Shack ~= Pad and Value then
            CurrentlyLockpicking[Pad] = false
        end
    end

    if Shack and Pads[Shack] then
        if not CurrentlyLockpicking[Shack] then
            task.spawn(function()
                CurrentlyLockpicking[Shack] = true
                UIText(UI.LastTask, "Lockpicking: "..Shack)
                
                while task.wait(0.25) and CurrentlyLockpicking[Shack] and not Library.InstancingCmds.IsInInstance() do
                    NewShack = GetBestLockpickableArea()
                    if NewShack ~= Shack then break end
                    Library.Network.Invoke("Thieving_Thieve", Pads[Shack])
                end

                CurrentlyLockpicking[Shack] = false
            end)
        end
    end
end

if ReplicatedStorage.Network:FindFirstChild("Eggs_ConsumableVFX") then
    ReplicatedStorage.Network.Eggs_ConsumableVFX.OnClientEvent:Connect(function() end)
end
if ReplicatedStorage.Network:FindFirstChild("Thieving_Animation") then
    ReplicatedStorage.Network.Thieving_Animation.OnClientEvent:Connect(function() end)
end
if ReplicatedStorage.Network:FindFirstChild("BreakableQuests_IncrementOne") then
    ReplicatedStorage.Network.BreakableQuests_IncrementOne.OnClientEvent:Connect(function() end)
end

local Vaults = {}
workspace.__THINGS.ThievingObjects.ChildAdded:Connect(function(Model)
    local Instance;
    repeat task.wait(0.25)
        Instance = Library.ThievingCmds.GetObjectByModel(Model)
    until Instance
    if Instance and Instance._dir and Instance._dir.DisplayName then
        local Name = tostring(Instance._dir.DisplayName)
        if Name:find("Vault") then
            Vaults[Name] = {Model = Model, ID = Instance._id}
        end
    end
end)

--// Gather & Purchase LuckyRaid Upgrades \\--
local Upgrades = {}
for ID, Data in next, Library.EventUpgrades do
    if ID:find("Easter") then
        Upgrades[ID] = Data
    end
end

local AlreadyCalled = 1
local PotionBlacklist = os.time()-70
local IndexBlacklist = os.time()-70
local CustomBlacklist = os.time()-70
local CraftingBlacklist = os.time()-70

local Counter = 0
task.spawn(function()
    while task.wait(5) do
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        GuiService.TouchControlsEnabled = false
        
        --// Vending Machine \\--
        if Library.MachineCmds.All()["PotionVendingMachine"] and (os.time() - PotionBlacklist) >= 60 then
            for Name, Stock in Library.Save.Get().VendingStocks do
                if tonumber(Stock) > 0 then
                    for i = 1, tonumber(Stock) do
                        if not Library.MachineCmds.CanUse(Name) then
                            HumanoidRootPart.CFrame = CFrame.new(Library.MachineCmds.All()[Name][1].Pad.arrow.Position + Vector3.new(0,-30,0))
                        end
                        local Success, Return = Library.Network.Invoke("VendingMachines_Purchase", Name)
                        if Success and Return then
                            UIText(UI.LastTask, "Purchased "..Return[1].data.id.." "..Return[1].data.tn.." from "..Name)
                        end
                    end
                end
            end
        end

        LPH_NO_VIRTUALIZE(function()
            --// Purchase Merchant \\--
            if Library.UpgradeCmds.IsUnlocked("Index Shop") and Library.UpgradeCmds.IsUnlocked("Advanced Index Shop") and (os.time() - IndexBlacklist) >= 60 then
                local CustomOffers = {"Rainbow Dice Potion", "Lucky Potion"}
                for Name, Merchant in next, debug.getupvalues(IndexMerchant)[3] do
                    for ID, Data in Merchant.Offers do
                        local Cost = Library.Items.From(Data.PriceData.class, Data.PriceData.data)
                        local Item = Library.Items.From(Data.ItemData.class, Data.ItemData.data)
                        if not Library.MachineCmds.CanUse(Name) and Library.MachineCmds.All()[Name] then
                            HumanoidRootPart.CFrame = CFrame.new(Library.MachineCmds.All()[Name][1].Pad.arrow.Position + Vector3.new(0,-30,0))
                            task.wait(0.5)
                        end
                        for i = 1, Data.Stock do
                            if Cost:CountExact() >= Cost:GetAmount() and Data.Stock > 0 and (Cost:GetAmount() >= 8 or table.find(CustomOffers, Item:GetId())) then
                                Success, Result = Library.Network.Invoke("Merchant_RequestPurchase", Name, tonumber(ID))
                                if Success then
                                    UIText(UI.LastTask, "Purchased "..Item:GetName().." from "..Name)
                                end
                            end
                        end
                    end
                end
                IndexBlacklist = os.time()
            end

            --// Purchase Custom Merchants \\--
            if (os.time() - CustomBlacklist) >= 60 then
                for Name, Table in next, Library.CustomMerchants do
                    if Debug and Debug["Disable"..Name] then
                        continue
                    end
                    Seed = Table.Seed(LocalPlayer)
                    Offers = Table.Offers(LocalPlayer, Seed)
                    for Slot, Info in next, Offers do
                        if Info.Requirement() then
                            local Item = Info.Item()
                            local Price = Info.Price()
                            local Stock = Info.Stock()
                            Stock = math.min(Stock, math.floor(Price:CountExact() / Price:GetAmount()))
                            if Stock > 0 and (Name ~= "MiningMerchant" or Name == "MiningMerchant" and GetOreForUpgrade() ~= Price:GetId() and Item:GetName() ~= "Exotic Mining Chest") and (Name ~= "BlackMarketMerchant" or Name == "BlackMarketMerchant" and GetLockpicksForUpgrade() ~= Price:GetId()) and (Name ~= "SpaceMerchant" or Name == "SpaceMerchant" and Library.UpgradeCmds.IsUnlocked("Event Titanic Luck III")) then
                                if not Library.MachineCmds.CanUse(Name) and Library.MachineCmds.All()[Name] then
                                    HumanoidRootPart.CFrame = CFrame.new(Library.MachineCmds.All()[Name][1].Pad.arrow.Position + Vector3.new(0,-30,0))
                                    task.wait(0.5)
                                end
                                for i = 1, Stock do
                                    Success, Result = Library.Network.Invoke("CustomMerchants_Purchase", Name, Slot)
                                    if Success then
                                        UIText(UI.LastTask, "Purchased "..Item:GetName().." from "..Name)
                                    end
                                end
                            end
                        end
                    end
                end
                CustomBlacklist = os.time()
            end

            pcall(function()
                --// Claim Flying Gifts \\--
                for _,v in next, debug.getupvalues(FlyingGifts.create)[4] do
                    FlyingGifts.claim(v.UID)
                    UIText(UI.LastTask, "Claimed Flying Gift")
                end

                --// Dig Hidden Spots \\--
                if #workspace.__THINGS.Digging:GetChildren() >= 1 then
                    local Locations = debug.getupvalue(Library.DiggingCmds.GetNearest, 1)._table
                    for _, v in next, Locations do
                        for _, v2 in v do
                            for _,v in next, Library.PetNetworking.EquippedPets() do
                                Pet = v
                                break
                            end
                            if Pet then
                                Library.Network.Invoke("Digging_Target", v2.val.uid, Pet.euid)
                                Library.Network.Invoke("Digging_Claim", v2.val.uid)
                                UIText(UI.LastTask, "Dug up Hidden Treasure")
                            end
                        end
                    end
                end

                --// Hidden Gift Collection \\--
                if HiddenGifts[1] then
                    for i,v in next, HiddenGifts do
                        HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, -15, 0)
                        task.wait(0.25)
                        local Success, Return = Library.Network.Invoke("HiddenGifts_Found", {
                            ["Id"] = v.Id,
                            ["DirectoryId"] = v.DirectoryId,
                            ["CFrame"] = v.CFrame
                        })
                        if Success then
                            HiddenGifts[i] = nil
                            v.Model:Destroy()
                            UIText(UI.LastTask, "Broke Hidden Gift")
                        end
                    end
                end

            end)
        end)()

        local Beans = Library.Items.Misc("Jelly Bean")
        if Beans:CountExact() >= 10 then
            local Count = math.floor(Beans:CountExact() / 10)
            Library.Network.Invoke("GiftMachine_Activate", "Jelly Bean Gift", 1, math.round(Count))
        end

        local EasterCoins = Library.CurrencyCmds.Get("Easter Coins")
        local Upgrade, LowestCost = nil, math.huge
        for ID, Data in next, Upgrades do
            local Tier = Library.EventUpgradeCmds.GetTier(ID)
            if not Data.TierCosts[Tier + 1] or not Data.TierCosts[Tier + 1]._data then
                continue
            end
            local Cost = Data.TierCosts[Tier + 1]._data._am or 1
            if Cost and Cost < LowestCost and EasterCoins >= Cost then
                LowestCost = Cost
                Upgrade = ID
            end
        end
        if Upgrade then
            Library.EventUpgradeCmds.Purchase(Upgrade)
        end
        

        --// Purchase Upgrades \\--
        local LastTier = 0
        local LastEgg = "Cracked Egg"
        if AlreadyCalled <= 10 then
            Library.Network.Invoke("Upgrades_Purchase", "Root")
            AlreadyCalled = AlreadyCalled + 1
        end
        for _, Upgrade in next, Upgrades do
            local UpgradeID = Upgrade._id
            if UpgradeID:find("Easter") then continue end
            local GroupID = Upgrade.GroupId
            if not UpgradeID:find("Skin") and not UpgradeID:find("Hoverboard") and Library.UpgradeCmds.IsUnlockable(UpgradeID) and not Library.UpgradeCmds.IsUnlocked(UpgradeID) and Library.UpgradeCmds.CanAfford(UpgradeID) then
                local Success, Result = pcall(function()
                    return Library.UpgradeCmds.Unlock(UpgradeID)
                end)

                if Success and Result then
                    UIText(UI.LastTask, "Unlocked Upgrade: " .. UpgradeID)
                end
            end
            if UpgradeID:find("Egg") and Library.UpgradeCmds.IsUnlocked(UpgradeID) then
                if not Debug.UseEventEggs then
                    if GroupID == "Luckier" then
                        local Tier = tonumber(Upgrade.Depth) or 0
                        if Tier > LastTier then
                            LastTier = Tier
                            LastEgg = Upgrade.DisplayName
                        end
                    end
                else
                    if GroupID:find("Event") or GroupID:find("Holiday") then
                        LastEgg = Upgrade.DisplayName
                    end
                end
            end
        end
        if Library.Save.Get().EquippedEggId ~= LastEgg then
            Library.Network.Invoke("Eggs_Equip", LastEgg)
            UIText(UI.LastTask, "Equipped: " .. LastEgg)
        end

        --// Equip Pickaxe Upgrades \\--
        --[[pcall(function()
            local BestPickaxe = Library.MiningCmds.GetSelectedPickaxe()
            if BestPickaxe then
                local InventoryEnchants = {}
                for UID, ItemTable in pairs(GetInventory("PickaxeEnchant")) do
                    local ID = ItemTable:Directory()._id
                    if not InventoryEnchants[ID] or (InventoryEnchants[ID] and InventoryEnchants[ID].Tier < ItemTable._data["tn"]) then
                        InventoryEnchants[ID] = {Tier = ItemTable._data["tn"], UID = UID}
                    end
                end
                local CurrentEnchants = {}
                for _, Enchant in next, BestPickaxe:GetEnchants() do
                    CurrentEnchants[Enchant.dir._id] = Enchant.tier
                end
                local ToEquip = {}
                local EnchantSlots = BestPickaxe:GetEnchantSlots()
                local CurrentEnchantCount = #BestPickaxe:GetEnchants()
                for Enchant, Data in next, InventoryEnchants do
                    if (Enchant == "Strength" or Enchant == "Speed") and 
                    (not CurrentEnchants[Enchant] or CurrentEnchants[Enchant] < Data.Tier) then
                        table.insert(ToEquip, { ID = Enchant, Tier = Data.Tier, UID = Data.UID })
                    end
                end
                if #ToEquip >= CurrentEnchantCount then
                    local PickaxeUID = BestPickaxe:GetUID()
                    local Success, Result = Library.Network.Invoke("Pickaxe_RemoveEnchants", PickaxeUID)
                    if Success then
                        ToEquip = {}
                        for Enchant, Data in next, InventoryEnchants do
                            if (Enchant == "Strength" or Enchant == "Speed") then
                                table.insert(ToEquip, { ID = Enchant, Tier = Data.Tier, UID = Data.UID })
                                if #ToEquip >= EnchantSlots then
                                    break
                                end
                            end
                        end
                    end
                end
                for _, EnchantData in next, ToEquip do
                    local Success, Result = Library.Network.Invoke("Mining_PickaxeAddEnchant", BestPickaxe:GetUID(), EnchantData.UID)
                    if Success then
                        UIText(UI.LastTask, "Equipped Pickaxe Enchant: "..EnchantData.ID.." "..EnchantData.Tier)
                    end
                end
            end
        end)]]--

        --// Consume Fruits \\--
        for _,Name in Fruits do
            local Item = Library.Items.Fruit(Name)
            ConsumeFruit(Item, Name)
            if Item:CanBeShiny() then
                Item:SetShiny(true)
                ConsumeFruit(Item, Name)
            end
        end

        --// Craft Fruits \\--
        local CurrentFruits = {}
        local CanCraftShiny = {}
        local CanCraftRainbow = true
        local ShinyAmount = 25
        if Library.UpgradeCmds.IsUnlocked("Cheaper Shiny Fruit") then
            ShinyAmount = 18
        elseif Library.UpgradeCmds.IsUnlocked("Discount Shiny Fruit") then
            ShinyAmount = 15
        end

        local maxRainbowInventoryLimit = 100
        local totalFruitsNeeded = 25
        local currentRainbowCount = Library.Items.Fruit("Rainbow"):CountExact()
        if currentRainbowCount >= maxRainbowInventoryLimit then
            CanCraftRainbow = false
        end

        local currentShinyRainbowCount = Library.Items.Fruit("Rainbow"):SetShiny(true):CountExact()
        local maxShinyRainbowLimit = 20

        for _, v in next, Fruits do
            local Item = Library.Items.Fruit(v)
            local HasFruit = Item:FindExact()

            if not CanCraftShiny["Shiny "..v] then
                CanCraftShiny["Shiny "..v] = true
            end

            if Library.Items.Fruit(v):SetShiny(true):CountExact() > ShinyAmount then
                CanCraftShiny["Shiny "..v] = false
            end

            if CanCraftShiny["Shiny "..v] then
                if HasFruit[1] then
                    CurrentFruits["Shiny "..v] = {UID = HasFruit[1]:GetUID(), Amount = Item:CountExact()}
                else
                    CanCraftShiny["Shiny "..v] = false
                end
            end

            if v ~= "Rainbow" then
                CurrentFruits[v] = {
                    UID = HasFruit[1] and HasFruit[1]:GetUID() or nil,
                    Amount = Item:CountExact()
                }
            end
        end

        if CanCraftRainbow then
            local totalAvailableFruits = 0
            local fruitAmounts = {}

            for Name, Data in next, CurrentFruits do
                if Data.Amount > 0 then
                    fruitAmounts[Name] = Data.Amount
                    totalAvailableFruits = totalAvailableFruits + Data.Amount
                end
            end

            local maxAllowedCraft = maxRainbowInventoryLimit - currentRainbowCount
            local maxCraftable = math.floor(totalAvailableFruits / totalFruitsNeeded)
            local rainbowFruitsToCraft = math.min(maxAllowedCraft, maxCraftable)

            if rainbowFruitsToCraft > 0 then
                local FruitDistribution = {}
                local remainingFruits = rainbowFruitsToCraft * totalFruitsNeeded
                local availableFruitTypes = {}
                for Name in pairs(fruitAmounts) do
                    table.insert(availableFruitTypes, Name)
                end
                while remainingFruits > 0 and #availableFruitTypes > 0 do
                    local splitAmount = math.ceil(remainingFruits / #availableFruitTypes)

                    for i = #availableFruitTypes, 1, -1 do
                        local fruit = availableFruitTypes[i]
                        local useAmount = math.min(fruitAmounts[fruit], splitAmount)
                        if useAmount > 0 then
                            FruitDistribution[CurrentFruits[fruit].UID] = (FruitDistribution[CurrentFruits[fruit].UID] or 0) + useAmount
                            fruitAmounts[fruit] = fruitAmounts[fruit] - useAmount
                            remainingFruits = remainingFruits - useAmount
                        end
                        if fruitAmounts[fruit] <= 0 then
                            table.remove(availableFruitTypes, i)
                        end
                    end
                end
                if next(FruitDistribution) then
                    local Success, Result = Library.Network.Invoke("UpgradeFruitsMachine_Activate", FruitDistribution, false)
                    if Success then
                        UIText(UI.LastTask, "Crafted: Rainbow Fruit x"..rainbowFruitsToCraft)
                    end
                end
            end
        end
        for Name, Data in next, CurrentFruits do
            if Name:find("Shiny") and CanCraftShiny[Name] then
                local MaxPossibleShiny = math.floor(Data.Amount / ShinyAmount)
                local ShinyToCraft = math.min(MaxPossibleShiny, 20)
                if ShinyToCraft > 0 then
                    local Success, Result = Library.Network.Invoke("UpgradeFruitsMachine_Activate", {[Data.UID] = ShinyToCraft * ShinyAmount}, true)
                    if Success then
                        print("Crafted: "..Name.." x"..ShinyToCraft)
                    end
                end
            end
        end

        --// Craft Potions \\--
        local Craftable = GetBestCraftablePotions()
        if Craftable and (os.time() - CraftingBlacklist) >= 60 then
            for Machine, Potions in Craftable do
                if not Library.MachineCmds.CanUse(Machine) then
                    HumanoidRootPart.CFrame = CFrame.new(Library.MachineCmds.All()[Machine][1].Pad.arrow.Position + Vector3.new(0,-30,0))
                    task.wait(0.5)
                end
                for _,v in next, Potions do
                    local Potion = v.Result:GetId()
                    local MaxTier = v.Result:GetTier()
                    for Tier = 0, MaxTier do
                        local Recipe = GetRecipe(Potion, tonumber(Tier))
                        if Recipe then
                            local MaxCraftable = GetMaxCraftable(Recipe) 
                            local ItemName = Recipe.Result:GetName()
                            local ItemID = Recipe.Result:GetId()
                            local InventoryCount = Recipe.Result:CountExact()
                            if MaxCraftable > 0 then
                                if InventoryCount >= 5 or
                                ItemName == "Instant Luck Potion IV" and not Debug.CraftInsta4PotionsSoICanSellThem or
                                ItemName == "The Cocktail" and InventoryCount >= 3 and not Debug.CraftInsta4PotionsSoICanSellThem then
                                    continue
                                end
                                MaxCraftable = math.min(6, MaxCraftable)
                                local Success, Result;
                                if not Library.UpgradeCmds.IsUnlocked("Batch Potion Craft") then
                                    MaxCraftable = 1
                                end
                                Success, Result, Test = Library.Network.Invoke("CraftingMachine_Craft", Machine, tonumber(Recipe.RecipeIndex), MaxCraftable)
                                if Success then
                                    UIText(UI.LastTask, "Crafted: "..Recipe.Result:GetName().." x"..MaxCraftable)
                                end
                            end
                        end
                    end
                end
            end
            CraftingBlacklist = os.time()
        end

        --// Juice Potions \\--
        local JuiceRecipe = Library.JuicerUtil.Recipes[4]
        local JuicerPets = {}
        local JuicerGrabbedPets = 0
        local PetsRequired = Library.JuicerUtil.ComputeTruePrice(LocalPlayer, JuiceRecipe, Library.JuicerUtil.ComputeBatteryPower())
        if JuiceRecipe.Requirement() and Library.UpgradeCmds.IsUnlocked("Juicer") and PetsRequired < 40 then
            local Inventory = GetInventory("Pet")
            if Inventory then
                for UID, ItemTable in pairs(Inventory) do
                    if not UID then continue end
                    local PetDifficulty = ItemTable:GetDifficulty()
                    local PetAmount = ItemTable._data["_am"] or 1
                    if PetDifficulty >= JuiceRecipe.DifficultyMinimum() and PetDifficulty < 10000000 then
                        local UseablePets = math.min(PetAmount, PetsRequired - JuicerGrabbedPets)
                        if UseablePets > 0 then
                            JuicerPets[UID] = UseablePets
                            JuicerGrabbedPets = JuicerGrabbedPets + UseablePets
                        end
                        if JuicerGrabbedPets >= PetsRequired then
                            break
                        end
                    end
                end
            end
        end
        if next(JuicerPets) then
            local Success, Result = Library.Network.Invoke("Juicer_Craft", 4, JuicerPets)
            if Success then
                UIText(UI.LastTask, "Juiced Potion w/ "..JuicerGrabbedPets.." pets")
            end
        end

        if not (Debug and Debug.KeepCrystalParts) then
            local UpperHalf = Library.Items.Misc("Crystal Key Upper Half")
            local LowerHalf = Library.Items.Misc("Crystal Key Lower Half")
            if UpperHalf:FindExact()[1] and LowerHalf:FindExact()[1] and not SkipItems[UpperHalf:GetId()] and not SkipItems[LowerHalf:GetId()] then
                local Amount = math.min(UpperHalf:CountExact() or 1, LowerHalf:CountExact() or 1)
                Success, Result = Library.Network.Invoke("LootKey_Combine", Amount)
                if Success then
                    UIText(UI.LastTask, "Crafted Crystal Key x"..Amount)
                end
            end
        end
        if not (Debug and Debug.KeepCrystalKeys) then
            local Key = Library.Items.Misc("Crystal Key")
            if not SkipItems[Key:GetId()] and Key:FindExact()[1]  then
                local Amount = math.min(10, Key:CountExact())
                Success, Result = Library.Network.Invoke("LootChest_Unlock", Amount, false)
                if Success then
                    UIText(UI.LastTask, "Used Crystal Key x"..Amount)
                end
            end
        end

        --// Claim Free Forever Pack \\--
        local ForeverPackState = Library.ForeverPackCmds.GetState("Default")
        if ForeverPackState then
            if not ForeverPackState.Slots[ForeverPackState.Slot + 1].Price then
                Library.Network.Invoke("ForeverPacks: Claim Free", "Default")
                UIText(UI.LastTask, "Claimed Free Forever Pack")
            end
        end

        if not (Debug and Debug.KeepVaultKeys) and Library.UpgradeCmds.IsUnlocked("Vault Duration V") and not Library.InstancingCmds.IsInInstance() then
            VaultKey = Library.Items.Misc("Vault Key")
            if VaultKey:FindExact()[1] then
                Counter = Counter + 1
                UIText(UI.LastTask, "Opening Vault Door #"..Counter)
                Library.Network.Invoke("ThievingVault_Open")
                task.wait(2)
                BreakTimer = os.time()
                HumanoidRootPart.CFrame = workspace.__THINGS.Instances.VaultInstance.Teleports.Enter.CFrame
                repeat task.wait() until Library.InstancingCmds.IsInInstance() or (os.time()-BreakTimer) >= 10
                for i = 1,8 do
                    UIText(UI.LastTask, "Farming Room "..i.. ".")
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
                    repeat task.wait() until Vaults["Vault "..i]
                    local Chest = Vaults["Vault "..i]
                    AlreadySent1Notification = false
                    AlreadySent2Notification = false
                    repeat task.wait()
                        NextRoom = Vaults["Vault "..i+1]
                        CanAttackChest = Library.ThievingCmds.GetObjectByModel(Chest.Model)
                        if CanAttackChest then
                            Library.Network.Invoke("Thieving_Thieve", Chest.ID)
                        elseif not CanAttackChest and not AlreadySent1Notification then
                            AlreadySent1Notification = true
                            UIText(UI.LastTask, "Vault Room "..i.. " Chest was unlocked! " ..ConvertSeconds(180 - (os.time()-BreakTimer)).." left")
                        end
                        if i ~= 8 and not NextRoom then
                            Library.Network.Invoke("Instancing_InvokeCustomFromClient", "VaultInstance", "JoinDoor", i)
                        elseif NextRoom and not AlreadySent2Notification then
                            AlreadySent2Notification = true
                            UIText(UI.LastTask, "Vault Room "..i.." Door was unlocked!  " ..ConvertSeconds(180 - (os.time()-BreakTimer)).." left")
                        end
                    until ((i == 8 or NextRoom) and not CanAttackChest) or not Library.InstancingCmds.IsInInstance()
                end
                Vaults = {}
                Library.InstancingCmds.Leave()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(10) do
        --// Opssen Lootboxes 'n use fish bait \\--
        pcall(function()
            if not (Debug and Debug.KeepLootboxes) then
                local Inventory = GetInventory("Lootbox")
                if Inventory then
                    for UID, ItemTable in pairs(Inventory) do
                        local ID = ItemTable:Directory()._id
                        local Amount = ItemTable._data["_am"] or 1
                        if SkipItems[ID] then
                            continue
                        end
                        local IsValidLootbox =
                        ID:find("Treasure Chest") or
                        (ID:find("Gift") and not ID:find("Tech") and not ID:find("Royal")) or
                        (ID:find("Mining Chest") and not ID:find("Runic")) or
                        (ID:find("Thieving Chest") and not ID:find("Exotic")) or
                        ID:find("Enchant Safe") or
                        ID:find("Boosts") or
                        ID:find("Scrolls") or
                        ID:find("Locked")

                        if IsValidLootbox then
                            while task.wait() and Amount > 0 do
                                local ToOpen = math.min(Amount, 50)
                                local Success, Result = Library.Network.Invoke("Lootbox: Open", UID, ToOpen)
                                if Success then
                                    UIText(UI.LastTask, "Opened: " .. ID .. " x" .. ToOpen)
                                    Amount = Amount - ToOpen
                                else
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if not (Debug and Debug.KeepFishingBait) then
                local Inventory = GetInventory("Consumable")
                if Inventory then
                    for UID, ItemTable in pairs(Inventory) do
                        local ID = ItemTable:Directory()._id
                        local Amount = ItemTable._data["_am"] or 1
                        local Tier = ItemTable._data["tn"] or 0
                        if SkipItems[ID..Tier] then
                            continue
                        end
                        local IsBait = ID:find("Fishing Bait")
                        if IsBait then
                            local Success, Result = Library.Network.Invoke("Consumables_Consume", UID, Amount)
                        end
                    end
                end
            end
            if not (Debug and Debug.KeepEggItems) then
                local Inventory = GetInventory("Egg")
                if Inventory then
                    for UID, ItemTable in pairs(Inventory) do
                        local ID = ItemTable:Directory()._id
                        local Amount = ItemTable._data["_am"] or 1
                        if SkipItems[ID] then
                            continue
                        end
                        local IsEgg = ID:find("Egg")
                        local IsHugeEgg = ID:find("Huge")
                        local IsHypeEgg = ID:find("Hype")
                        local IsMagmaEgg = ID:find("Magma")
                        local IsSantaEgg = ID:find("Santa")

                        if IsEgg and Amount >= 30 and not (IsHugeEgg or IsHypeEgg or IsMagmaEgg or IsSantaEgg) then
                            Debug.DisableAutoRolling = true
                            while task.wait() and Amount > 0 do
                                local ToOpen = math.min(Amount, 30)
                                local Success, Result;
                                pcall(function()
                                    Success, Result = Library.Network.Invoke("Eggs_Open", UID, ToOpen)
                                end)
                                if Success then
                                    UIText(UI.LastTask, "Opened: " .. ID .. " x" .. ToOpen)
                                    Amount = Amount - ToOpen
                                elseif not Success and not tostring(Result):find("Already") then
                                    break
                                end
                            end
                            Debug.DisableAutoRolling = false
                        end
                    end
                end
            end
        end)

        pcall(function()
            --CloverTycoon = CloverTycoon or Library.TycoonCmds.Get(Library.Tycoons.Clover)
            BoatTycoon = BoatTycoon or Library.TycoonCmds.Get(Library.Tycoons.Boating)
            for i,Tycoon in next, {BoatTycoon} do
                if Tycoon and Tycoon._dir and Tycoon._dir.Purchasables then
                    for Name, Data in next, Tycoon._dir.Purchasables do
                        if not Tycoon:GetState(Name) then
                            local CanUnlock = Tycoon:MeetsAllRequirements(Name)
                            if not Data.Price then
                                local Success, Return = Library.Network.Invoke("Tycoons: Purchase", Name, "Boating")
                                if Success then
                                    UIText(UI.LastTask, "Purchased Item: "..Name)
                                    break
                                end
                            else
                                local Amount = Data.Price._data._am
                                local CurrencyID = Data.Price._data.id
                                local Token;
                                if CurrencyID ~= "Clovers" then
                                    Token = Library.Items.Misc(CurrencyID)
                                end
                                if CanUnlock and ((Token and Token:FindExact()[1] and (Token:CountExact() or 1) >= Amount) or not Token and Library.CurrencyCmds.CanAfford(CurrencyID, Amount)) then
                                    local Success, Return = Library.Network.Invoke("Tycoons: Purchase", Name, "Boating")
                                    if Success then
                                        UIText(UI.LastTask, "Purchased Item: "..Name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        --[[local CurrentPoints = CloverTycoon and Library.CloverEventCmds.GetEggPoints(CloverTycoon) or 0
        local MaxPoints = CloverTycoon and Library.CloverEventCmds.GetMaxEggPoints(CloverTycoon) or 0
        if CloverTycoon and not Debug.DisableCloverEgg then
            if Debug.ConstantlyOpenCloverEgg and not Debug.DisableAutoRolling then
                Debug.DisableAutoRolling = true
                task.spawn(function()
                    while task.wait(0.25) do
                        local Success = Library.Network.Invoke("Clovers_HatchEgg")
                        if Success then
                            UIText(UI.LastTask, "Opened: Clover Egg")
                        end
                    end
                end)
            else
                Debug.DisableAutoRolling = true
                repeat task.wait(0.25)
                    Success = Library.Network.Invoke("Clovers_HatchEgg")
                until Success or CurrentPoints < MaxPoints
                Debug.DisableAutoRolling = false
                if Success then
                    UIText(UI.LastTask, "Opened: Clover Egg")
                end
            end
        end]]--
        Library.Network.Invoke("Fishing_FishermanClaim")
        --Library.Network.Invoke("Clovers_HopperClaim")
    end
end)

local function Fish(Area)
    local Success, NA, Data = Library.Network.Invoke("Fishing_Fish", Area)
    if Success and Data then
        UIText(UI.LastTask, "Fishing Spot: "..Area)
        task.spawn(function()
            task.wait(Data.CatchDuration)
            Library.Network.Fire("Fishing_Success")
        end)
    end
end

local function EnterInstance(Name)
	if Library.InstancingCmds.GetInstanceID() == Name then return end
    setthreadidentity(2) 
    Library.InstancingCmds.Enter(Name) 
    setthreadidentity(8)
	task.wait(0.25)
	if Library.InstancingCmds.GetInstanceID() ~= Name then
		EnterInstance(Name)
	end
end

local Board = "Desert"
task.spawn(function()
    while task.wait(0.25) do

        --// Mine Ores \\--
        if MiningZone and MiningPads and Library.UpgradeCmds.IsUnlocked("Mine Shaft") then
            TeleportToBestOrePad()
        end
        if Library.UpgradeCmds.IsUnlocked("Thieving") and not Library.InstancingCmds.IsInInstance() then
            TeleportToBestShackPad()
        end

        --// Roll Board \\--
        --[[if MAP.INTERACT:FindFirstChild("Boards") and MAP.INTERACT.Boards:FindFirstChild("Desert") then
            local Success = Library.BoardCmds.Roll(Board)
            if Success then
                local CurrentTile = Library.BoardCmds.GetTileNumber(Board)
                local CurrentTier = Library.BoardCmds.GetUpgradeTier(Board, CurrentTile)
                local Tile = Library.BoardTiles[Library.Boards[Board].Tiles[CurrentTile].Directory._id]
                local MaxTier = #Tile.Tiers
                if CurrentTier ~= MaxTier then
                    for Tier = CurrentTier + 1, MaxTier do
                        local Success = Library.BoardCmds.UpgradeTile(Board, CurrentTile, Tier)
                        if not Success then break end
                        UIText(UI.LastTask, "Upgraded Tile: "..CurrentTile.." to Tier "..Tier-1)
                    end
                end
            end
            if MAP.INTERACT.Boards.Desert.Interact:FindFirstChild("Pad") then
                UIText(UI.LastTask, "Entering PharaohsTomb")
                EnterInstance("PharaohsTomb")
                local Chests = Library.Network.Invoke("GetSpawnedPharaohChests")
                for ID, Data in next, Chests do
                    if ID:find("Basic") then
                        for ID2, Data2 in next, Data do
                            if not Data2.opened then
                                HumanoidRootPart.CFrame = Data2.cframe
                                local Success;
                                repeat task.wait()
                                    print("yes")
                                    Success = Library.Network.Invoke("AttemptPharaohChestOpen", ID2)
                                until Success
                                UIText(UI.LastTask, "Opened Tomb: "..ID)
                            end
                        end
                    else
                        if not Data.opened then
                            HumanoidRootPart.CFrame = Data2.cframe
                            local Success;
                            repeat task.wait()
                                print("yes")
                                Success = Library.Network.Invoke("AttemptPharaohChestOpen", ID:gsub("spawned"))
                            until Success
                            UIText(UI.LastTask, "Opened Tomb: "..ID)
                        end
                    end
                end
                
                local Key = Library.Items.Misc("Ancient Key")
                if Key:CountExact() >= 1 and not SkipItems["Ancient Key"] then
                    
                end
                Library.InstancingCmds.Leave()
            end
        end]]--

        --// Consume Potions \\--
        local BannedKeywords = { "God Potion", "Instant Luck", "Dice Potion", "Santa's Scroll", "Egg Charge", "Factory", "Magma" }
        local Inventory = GetInventory("Consumable")
        if Inventory then
            for _, ItemTable in pairs(Inventory) do
                local Name = ItemTable:GetId()
                local IsBanned = false
                for _, BannedWord in ipairs(BannedKeywords) do
                    if Name:find(BannedWord) then
                        IsBanned = true
                        break
                    end
                end
                if IsBanned then continue end
                local PotionData = Library.Consumables[Name]
                if not PotionData or not PotionData.Tiers or #PotionData.Tiers == 0 then
                    continue
                end
                local Potion
                for Tier = #PotionData.Tiers, 1, -1 do
                    Potion = GetPotionData(Name, Tier)
                    if Potion then
                        UsePotion(Potion)
                        GetActivePotions()
                        break
                    end
                end
            end
        end

        --// Auto Fishing \\--
        if ActivePotions["Kraken Tentacle 1"] and Library.UpgradeCmds.IsUnlocked("Kraken Tentacles III") then
            Fish("Kraken")
        elseif Library.UpgradeCmds.IsUnlocked("Boating") then
            Fish("Boating")
        elseif ActivePotions["Corrupted Huge Bait 1"] and Library.UpgradeCmds.IsUnlocked("Dark Ice Fishing") then
            Fish("Corrupted")
        elseif Library.UpgradeCmds.IsUnlocked("Ice Fishing") then
            Fish("Ice")
        elseif Library.UpgradeCmds.IsUnlocked("Fishing") then
            Fish("Default")
        end
    end
end)

local BlacklistedIDs = {}
--// Mailing Details \\--
if Settings.Mailing and Settings.Mailing.Pets and Settings.Mailing.Pets.Difficulty then
    Settings.Mailing.Pets.Difficulty = tonumber(RemoveSuffix(Settings.Mailing.Pets.Difficulty:split("Above ")[2]))
end
local function SendItem(Class, UID, ItemTable, Username)
    Library.Network.Invoke("Locking_SetLocked", UID, false)
    local Cost = Library.Variables.MailboxCoinsCost * (Library.UpgradeCmds.IsUnlocked("Cheaper Mailbox") and 0.75 or 1)
    if Library.CurrencyCmds.CanAfford("Coins", math.floor(Cost)) then
        local ItemID = ItemTable:Directory()._id
        local Amount = ItemTable._data["_am"] or 1
        local Timeout = os.time()
        if Class == "Pet" then
            print("adding item", ItemID)
            table.insert(BlacklistedIDs, ItemID)
        end
        repeat task.wait(0.5)
            Success, Result = Library.Network.Invoke("Mailbox: Send", Username, ItemID, Class, UID, Amount)
        until Success or os.time()-Timeout >= 7
        if Success then
            UIText(UI.LastTask, "Sending "..ItemID.." to: "..Username)
            if Settings.Mailing.Webhook and Settings.Mailing.Webhook ~= "" and Settings.Mailing.Webhook ~= "Webhook URL" then
                local Difficulty = ItemTable.GetDifficulty and ItemTable:GetDifficulty() or nil
                if ItemTable.IsShiny and ItemTable:IsShiny() and Difficulty then
                    Difficulty = Difficulty * 100
                end
                local Rarity = ItemTable.GetRarity and ItemTable:GetRarity()._id or "Secret"
                if Rarity == "Secret" then
                    Difficulty = 1000000000
                end
                local Color = tonumber("0x"..Rarities[Rarity].Color:ToHex()) or "0x0000"
                local RAP = ItemTable.GetRAP and ItemTable:GetRAP() or 0
                local Description = {
                    "**<:Diamond:1235403834969296896> RAP:** `"..AddSuffix(RAP).."`",
                    "**<:User:1313379146759536700> Account:** ||`"..LocalPlayer.Name.."`||",
                }
                local Message = {
                    ["username"] = "System Exodus | Mail Notifier",
                    ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
                    ["content"] = (table.find({"Exclusive", "Secret"}, Rarity) and Settings.Notifications["DiscordID"] and Settings.Notifications["DiscordID"] ~= "" and "<@"..tostring(Settings.Notifications["DiscordID"])..">") or "",
                    ["embeds"] = {
                        {
                            ["color"] = Color,
                            ["title"] = ItemID..(Difficulty and " (1/"..AddSuffix(Difficulty)..")" or "").." x"..Amount,
                            ["description"] = table.concat(Description, "\n"),
                            ["timestamp"] = DateTime.now():ToIsoDate(),
                            ["footer"] = {
                                ["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
                                ["text"] = "@Jxnt - discord.gg/Jk28atjPas"
                            },
                            ["thumbnail"] = { 
                                ["url"] = "https://biggamesapi.io/image/"..Library.Functions.ParseAssetId(ItemTable:GetIcon())
                            },
                        },
                    },
                }
                request({
                    Url = Settings.Mailing.Webhook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"}, 
                    Body = HttpService:JSONEncode(Message)
                })
            end
        end
    end
end

local StoredMailingOptions = {}  
for Name, Data in next, Settings.Mailing.Items do
    if Name == "Diamonds" then
        Data.FindInfo = {Class = "Currency", ID = Name}
    end
    if not Data.FindInfo then
        Data.FindInfo = GenerateFindInfo(Name, Data)
    end
    local FindInfo = Data.FindInfo
    if not FindInfo.Class then 
        continue 
    end
    StoredMailingOptions[FindInfo.Class] = StoredMailingOptions[FindInfo.Class] or {}
    table.insert(StoredMailingOptions[FindInfo.Class], {FindInfo = FindInfo, Data = Data})
end

task.spawn(function()
    while task.wait(120) do
        if Settings.Mailing.Usernames and (Settings.Mailing.Usernames[1] == LocalPlayer.Name or Settings.Mailing.Usernames[1] == "" or #Settings.Mailing.Usernames == 0) then break end
        
        local EquippedPets = {}
        if Settings.Mailing.Pets then
            if Settings.Mailing.Pets.KeepBestPets then
                for Name, PetData in next, Library.PetNetworking.EquippedPets() do
                    if PetData.uid then
                        table.insert(EquippedPets, PetData.uid)
                    end
                end
            end
            local Inventory = GetInventory("Pet")
            if Inventory then
                for UID, ItemTable in pairs(Inventory) do
                    if table.find(EquippedPets, UID) then continue end
                    local ID = ItemTable:Directory()._id
                    local Amount = ItemTable._data["_am"] or 1
                    local Username = Settings.Mailing.Usernames[math.random(1, #Settings.Mailing.Usernames)]
                    if (Settings.Mailing.Pets.Rarities and ItemTable.GetRarity and table.find(Settings.Mailing.Pets.Rarities, ItemTable:GetRarity())) or (Settings.Mailing.Pets.Difficulty and ItemTable.GetDifficulty and ItemTable:GetDifficulty() >= Settings.Mailing.Pets.Difficulty) then
                        SendItem("Pet", UID, ItemTable, Username)
                    end
                end
            end
        end
        if Settings.Mailing.Items then
            for Class, Items in pairs(StoredMailingOptions) do
                local Inventory = GetInventory(Class)
                if not Inventory then continue end
                for UID, ItemTable in pairs(Inventory) do
                    local ID = ItemTable:Directory()._id
                    local Amount = ItemTable._data["_am"] or 1
                    local Tier = ItemTable._data["tn"] or 0
                    local Username = Settings.Mailing.Usernames[1]
                    for _, ItemData in ipairs(Items) do
                        local FindInfo = ItemData.FindInfo
                        local Data = ItemData.Data
                        if FindInfo.ID == ID and (not FindInfo.Tier or FindInfo.Tier == Tier) and Amount >= Data.Amount then
                            SendItem(Class, UID, ItemTable, Username)
                        end
                    end
                end
            end
        end
    end
end)


--// Webhook Details \\--
local OriginalColor = UI.BackgroundColor3
local IsFlashing = false
local CurretTween;
local function FlashUI(Color)
    if CurretTween then
        CurretTween:Cancel()
    end
    IsFlashing = true
    coroutine.wrap(function()
        while task.wait() and IsFlashing do
            local Tween = TweenService:Create(UI, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {BackgroundColor3 = Color})
            CurretTween = Tween
            Tween:Play()
            Tween.Completed:Wait()

            Tween = TweenService:Create(UI, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {BackgroundColor3 = OriginalColor})
            CurretTween = Tween
            Tween:Play()
            Tween.Completed:Wait()
        end
    end)()
end

if Settings.Notifications and Settings.Notifications.Difficulty then
    Settings.Notifications.Difficulty = tonumber(RemoveSuffix(Settings.Notifications.Difficulty:split("Above ")[2]))
end
local LastSentMessages = {}
local BestRoll = tonumber(RemoveSuffix(UI["SessionRoll"].Text:split("/")[2]:gsub("%)", "")))
local function Webhook(Return)
    for UID, v in next, Return do
        local Item = Library.Items.From("Pet", v)
        local Name = Item.GetName and Item:GetName() or "Unknown"
        local Difficulty = Item.GetDifficulty and Item:GetDifficulty() or 0
        local Rarity = Item.GetRarity and Item:GetRarity()._id or "Secret"
        local ID = Item.GetId and Item:GetId() or "Unknown"
        if table.find(BlacklistedIDs, ID) then 
            BlacklistedIDs[ID] = nil
            continue
        end
        if Item.IsShiny and Item:IsShiny() then
            Difficulty = Difficulty * 100
        end
        if Difficulty >= BestRoll then
            BestRoll = Difficulty
            UIText(UI["SessionRoll"], "Session Roll: "..Name.." (1/"..AddSuffix(Difficulty)..")")
        end
        UIText(UI["LastRoll"], "Last Roll: "..Name.." (1/"..AddSuffix(Difficulty)..")")
        UIText(UI["RollsSpeed"], "Total: "..AddSuffix(Library.Save.Get().TotalRolls).." | Speed: "..(UpdateRollsPerMinute().."/m"))
        
        local Global = false
        local User = false

        if Settings.Notifications.Webhook and Settings.Notifications.Webhook ~= "" then
            if Settings.Notifications.Rarities and table.find(Settings.Notifications.Rarities, Rarity) then
                User = true
            elseif Settings.Notifications.Difficulty and Difficulty >= Settings.Notifications.Difficulty then
                User = true
            end
        end

        if table.find({"Exclusive", "Secret"}, Rarity) or Name:find("Huge") or Name:find("Titanic") then
            --if game.PlaceId == 18901165922 or game.PlaceId == 125597998995485 then
                Global = true
            --end
        end

        if Global or User then            
            if Rarity == "Secret" and Difficulty == 10000000000 then
                FlashUI(Color3.fromRGB(250,224,224))
                Difficulty = 1000000000
            end
            if Rarity == "Exclusive" and Name:find("Huge") then 
                FlashUI(Color3.fromRGB(120,245,182))
            end
            if Rarity == "Exclusive" and Name:find("Titanic") then 
                FlashUI(Color3.fromRGB(245,120,120))
            end

            local RAP = Item.GetRAP and Item:GetRAP() or 0
            local Exist = Item.GetExistCount and Item:GetExistCount() or 1
            local TotalRolls = Library.Save.Get().TotalRolls or 0
            local Color = tonumber("0x"..Rarities[Rarity].Color:ToHex()) or "0x0000"
            local Description = {
                "**<:Diamond:1235403834969296896> RAP:** `"..AddSuffix(RAP).."`",
                "**<:Dice:1294557128362688563> Dice Rolled:** `"..AddSuffix(TotalRolls).."`",
                "**<:Pet:1236781782314127410> Exist Count:** `"..AddCommas(Exist).."`",
            }
            local Message = {
                ["username"] = "System Exodus | Roll Notifier",
                ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
                ["content"] = (table.find({"Exclusive", "Secret"}, Rarity) and Settings.Notifications["DiscordID"] and Settings.Notifications["DiscordID"] ~= "" and "<@"..tostring(Settings.Notifications["DiscordID"])..">") or "",
                ["embeds"] = {
                    {
                        ["color"] = Color,
                        ["title"] = Name.." (1/"..AddSuffix(Difficulty)..")",
                        ["description"] = table.concat(Description, "\n"),
                        ["timestamp"] = DateTime.now():ToIsoDate(),
                        ["footer"] = {
                            ["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
                            ["text"] = "@Jxnt - discord.gg/Jk28atjPas"
                        },
                        ["thumbnail"] = { 
                            ["url"] = "https://biggamesapi.io/image/"..Library.Functions.ParseAssetId(Item:GetIcon())
                        },
                    },
                },
            }
            local MessageHash = HttpService:JSONEncode(Message)
            if LastSentMessages[MessageHash] and (tick() - LastSentMessages[MessageHash] < 60) then
                continue
            end
            LastSentMessages[MessageHash] = tick()

            if Global then
                --[[if Message["content"] == "<@318070660050059264>" then
                    Message["content"] = ""
                end]]--
                request({
                    Url = "https://discord.com/api/webhooks/ss/ss-ss",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"}, 
                    Body = HttpService:JSONEncode(Message)
                })
            end
            if User then
                Message["embeds"][1]["title"] = "||"..LocalPlayer.Name.."|| - "..Name.." (1/"..AddSuffix(Difficulty)..")"
                request({
                    Url = Settings.Notifications.Webhook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"}, 
                    Body = HttpService:JSONEncode(Message)
                })
            end
        end
    end
end

Library.Network.Fired("Items: Update"):Connect(function(Player, Items)
    task.wait(2)
    if Items and Items.set and Items.set.Pet then
        return Webhook(Items.set.Pet)
    end
end)


--// Rolling 'n Combo Details \\--
local RollingUpgradesUnlocked = false
task.spawn(function()
    while task.wait() do
        UIText(UI.SessionTime, "Session Time: "..ConvertSeconds(os.time()-StartTime))
        
        if RollingUpgradesUnlocked or (not Debug.CraftInsta4PotionsSoICanSellThem and Library.UpgradeCmds.IsUnlocked("Golden Dice") and Library.UpgradeCmds.IsUnlocked("Rainbow Dice") and Library.UpgradeCmds.IsUnlocked("Blazing Dice")) then
            RollingUpgradesUnlocked = true

            local BlazingPotion = GetPotionData("Blazing Dice Potion")
            local RainbowPotion = GetPotionData("Rainbow Dice Potion")
            local GoldenPotion = GetPotionData("Golden Dice Potion")
            local InstaLuck = GetPotionData("Instant Luck Potion", 4)
            if not InstaLuck then 
                InstaLuck = GetPotionData("Instant Luck Potion", 3)
            end

            local Combos = Library.EggUtils.ComputeCombos()
            local Blazing, Rainbow, Golden = Combos.Blazing, Combos.Rainbow, Combos.Gold
            if (InstaLuck and Debug.IgnoreGalaxyCombo) or (InstaLuck and (BlazingPotion or Blazing.Progress == Blazing.Interval) and (RainbowPotion or Rainbow.Progress == Rainbow.Interval) and (GoldenPotion or Golden.Progress == Golden.Interval)) then
                if Blazing.Progress ~= Blazing.Interval then
                    UsePotion(BlazingPotion)
                end
                if Rainbow.Progress ~= Rainbow.Interval then
                    UsePotion(RainbowPotion)
                end
                if Golden.Progress ~= Golden.Interval then
                    UsePotion(GoldenPotion)
                end
                UsePotion(InstaLuck)
            end
        end

        if Library.BonusRollCmds.HasAvailable() then
            Library.Network.Fire("Retention Dice: Claim")
            Library.LoginStreakCmds.RequestBonusRoll()
            local TerminateTimer = os.time()
            repeat task.wait()
                Success, Result = Library.Network.Invoke("Bonus Rolls: Claim")
                print()
            until Success or not Library.BonusRollCmds.HasAvailable() or (os.time()-TerminateTimer) >= 5
            if Success then
                UIText(UI.LastTask, "Claimed Bonus Roll")
            end
        end

        if not Debug.DisableAutoRolling then
            Success, Reason, Return = Library.Network.Invoke("Eggs_Roll")
            if Success then
                Library.Network.Fire("Eggs_RequestMessages")
                Library.Network.Fire("Eggs_AnimationComplete", Return.Id)
                Rolls = Rolls + 1
            end
        end
    end
end)

Library.Network.Fired("Inbox Updated"):Connect(function(Mail)
    for _,Items in next, Mail.Inbox do
        if Items.Item and Items.Item.data and Items.Item.data.id then
            table.insert(BlacklistedIDs, Items.Item.data.id)
        end
    end
end)

task.spawn(function()
    while task.wait(31) do
        local Success, Return = Library.Network.Invoke("Mailbox: Claim All")
    end
end)


if BreakablesScript then
    local Breakables = {}
    local BreakableId_PetId = {}
    local PetId_BreakableId = {}
    local Pets_To_Breakables = {}
    local Pets = {}

    local function safeCreateBreakable(Breakable)
        local success, err = pcall(function()
            Breakables[Breakable.u] = {
                Uid = Breakable.u,
                CFrame = Breakable.cf,
                Id = Breakable.id,
            }
        end)

        if not success then
        end
    end

    local function safeCleanupBreakable(Breakable)
        local success, err = pcall(function()
            Breakables[Breakable] = nil

            local PetIds = BreakableId_PetId[Breakable]
            if PetIds then
                if typeof(PetIds) == "table" then
                    for _, v in next, PetIds do
                        PetId_BreakableId[v] = nil
                    end
                else
                    PetId_BreakableId[PetIds] = nil
                end
                BreakableId_PetId[Breakable] = nil
            end
        end)

        if not success then
        end
    end

    local function safeDestroyBreakable(BreakableId)
        safeCleanupBreakable(BreakableId)
    end

    Breakables_Created = Library.Network.Fired("Breakables_Created"):Connect(function(Breakables)
        local success, err = pcall(function()
            for _, Breakable in next, unpack(Breakables) do
                safeCreateBreakable(Breakable)
            end
        end)

        if not success then
        end
    end)

    Breakables_Destroyed = Library.Network.Fired("Breakables_Destroyed"):Connect(function(Breakables1)
        local success, err = pcall(function()
            for _, Breakable in next, unpack(Breakables1) do
                safeDestroyBreakable(Breakable)
            end
        end)

        if not success then
        end
    end)

    BreakablesScript.createBreakable = safeCreateBreakable
    BreakablesScript.cleanupBreakable = safeCleanupBreakable
    BreakablesScript.destroyBreakable = safeDestroyBreakable
    BreakablesScript.updateBreakable = function(...) end

    for _, v in next, workspace.__THINGS.Breakables:GetChildren() do
        if v:IsA("Model") then
            local Uid = v:GetAttribute("BreakableUID")
            local CFrame = v:GetPivot()
            local Id = v:GetAttribute("BreakableID")
            Breakables[Uid] = { Uid = Uid, CFrame = CFrame, Id = Id }
        end
    end

    PetsUpdated = Library.Network.Fired("Pets_LocalPetsUpdated"):Connect(function(...)
        for _, v in next, ... do
            Pets[v.ePet.euid] = v.ePet.euid
        end
    end)

    PetsUnequipped = Library.Network.Fired("Pets_LocalPetsUnequipped"):Connect(function(...)
        for _, v in next, ... do
            Pets[v], PetId_BreakableId[v], Pets_To_Breakables[v] = nil, nil, nil
            local BreakableId = PetId_BreakableId[v]
            if BreakableId then
                BreakableId_PetId[BreakableId] = nil
            end
        end
    end)

    for _, v in next, Library.PetNetworking.EquippedPets() do
        Pets[v.euid] = v.euid
    end

    task.spawn(function()
        while task.wait(0.7) do
            local Closest, Distance
            for Name, Table in next, Breakables do
                if Table.Id:find("Ore") then continue end
                if Debug.DisablePinata and (Table.Id:find("Pinata") or Table.Id:find("Piñata")) then continue end

                if Table.Id:lower():find("chest") then
                    Library.Network.UnreliableFire("Breakables_PlayerDealDamage", Table.Uid)
                else
                    local Part = workspace.__THINGS.Breakables:FindFirstChild(Name)
                    if Part and Part:IsA("BasePart") then
                        local dist = (Part.Position - HumanoidRootPart.Position).Magnitude
                        if not Distance or dist < Distance then
                            Closest, Distance = Name, dist
                        end
                    end
                end
            end

            if Closest then
                Library.Network.UnreliableFire("Breakables_PlayerDealDamage", Closest)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            for i, v in next, Pets_To_Breakables do
                if not Breakables[v] then
                    Pets_To_Breakables[i] = nil
                end
            end
            for Name, Table in next, Breakables do
                for PetId, _ in next, Pets do
                    if Table.Id:find("Ore") then continue end
                    if Debug.DisablePinata and (Table.Id:find("Pinata") or Table.Id:find("Piñata")) then continue end
                    if not Pets_To_Breakables[PetId] and not PetId_BreakableId[PetId] and not BreakableId_PetId[Name] then
                        PetId_BreakableId[PetId] = Name
                        BreakableId_PetId[Name] = PetId
                        Pets_To_Breakables[PetId] = Table.Uid
                    end
                end
            end
            if next(Pets_To_Breakables) then
                Library.Network.Fire("Breakables_JoinPetBulk", Pets_To_Breakables)
            end
        end
    end)
end

if Library.Orb then
    Library.Orb.new = function(...) return end
    Library.Orb.ComputeInitialCFrame = function(...) return CFrame.new() end

    Drops = Library.Network.Fired("Orbs: Create"):Connect(function(Orbs)
        local OrbsToCollect = {}
        for _, v in next, Orbs do
            table.insert(OrbsToCollect, tonumber(v.id))
        end
        Library.Network.Fire("Orbs: Collect", OrbsToCollect)
    end)

    WorkspaceDrops = workspace.__THINGS.Orbs.ChildAdded:Connect(function(Orb)
        if Orb then
            Orb:Destroy()
        end
    end)
end
