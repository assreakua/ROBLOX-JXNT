if not LPH_OBFUSCATED then
    getgenv().Settings = {
        ["Open Egg"] = "Best Egg",
        
        ["Target Rifts"] = {},
        ["Minimum Rift Luck"] = 5,
        ["Target Highest Luck"] = false,
        --// true --> Targets highest luck out of ALL selected rifts.
        --// false --> Targets highest luck out of the BEST selected rift.
    
        ["Webhook"] = "https://discord.com/api/webhooks/1242913623261708351/YGe4PiWwclfrCe9H4CWQevp-eUfKgcRbBvXrDdIsryAnQjXNoUJabrowNT7a2oqE0H7D",
        ["Discord ID"] = "",
        ["Minimum Send Difficulty"] = "1m",
    
        ["Trade Users"] = {"MainAccount1", "MainAccount2", "MainAccount3"},
    
        ["Debug"] = {
            DisableUI = true,
        }
    }
end
local Debug = Settings and Settings.Debug or {}
local MinimumBuffLevel = Debug.MinimumBuffLevel or 16
local StartTime = os.time()

if not game:IsLoaded() then 
    game.Loaded:Wait()
end

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

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
if not LocalPlayer.Character then 
    LocalPlayer.CharacterAdded:Wait() 
end

local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

if game.PlaceId ~= 85896571713843 then
    return 
end

if not LibraryMods then
    getgenv().LibraryMods = {}
    LibraryMods.Unloaded = {}
    local function LoadModules(Path)
        if type(Path) == "Module" then
            LibraryMods.Unloaded[Path.Name] = Path
        end
        for _,v in pairs(Path:GetDescendants()) do
            if v:IsA("ModuleScript") then
                LibraryMods.Unloaded[v.Name] = v
            elseif (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Parent.Name ~= "SendSystemMessage" then
                LibraryMods[v.Name] = v
            end
        end
    end
    LoadModules(ReplicatedStorage.Client)
    LoadModules(ReplicatedStorage.Remotes)
    LoadModules(ReplicatedStorage.Shared)
end

local function Library(Name)
    if LibraryMods.Unloaded[Name] then
        local Status, Module = pcall(require, LibraryMods.Unloaded[Name])
        if Status then
            LibraryMods[Name] = Module
        end
        LibraryMods.Unloaded[Name] = nil
    end
    return LibraryMods[Name]
end

local IsTeleporting = false
local function Teleport(CF, DontGoHigh)
    if not HumanoidRootPart or not Humanoid then
        warn("Character doesn't exist")
        return
    end

    if (HumanoidRootPart.Position - CF.Position).Magnitude < 7 or IsTeleporting then
        return
    end

    IsTeleporting = true
    local High = (DontGoHigh == false) and 0 or 20000
    local originXZ = Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z)
    local targetXZ = Vector3.new(CF.Position.X, 0, CF.Position.Z)
    local horizDist = (originXZ - targetXZ).Magnitude
    local speed = math.max(Humanoid:GetAttribute("ExpectedWalkSpeed"), 1)
    local Duration  = horizDist / speed
    print(Duration, speed, horizDist)

    local Cancel = false
    task.spawn(function()
        while not Cancel and IsTeleporting do
            task.wait()
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        end
    end)

    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, High, 0)
    task.wait(0.5)

    local TargetHigh = HumanoidRootPart.CFrame.Y
    local TweenCFrame = CFrame.new(CF.Position.X, TargetHigh, CF.Position.Z)
    local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(HumanoidRootPart, TweenInfo, {CFrame = TweenCFrame})

    Tween:Play()
    Tween.Completed:Wait()

    Cancel = true
    HumanoidRootPart.CFrame = CF
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

    task.wait(0.5)
    IsTeleporting = false
end

local BlacklistedRemotes = {"ClaimGift", "GrabVisualItem", "Teleport", "HatchEgg", "BlowBubble", "SellBubble", "CraftPotion", "RerollEnchant"}
local function Fire(...)
    local Args = {...}
    local Remote = Args[1]
    if not table.find(BlacklistedRemotes, Remote) then
        task.wait(0.8)
    end
    if LibraryMods[Remote] and LibraryMods[Remote].ClassName == "RemoteEvent" then
        table.remove(Args, 1)
        return LibraryMods[Remote]:FireServer(unpack(Args))
    end
    return Library("Remote").FireServer("Event", ...)
end

local function Invoke(...)
    local Args = {...}
    local Remote = Args[1]
    if LibraryMods[Remote] and type(LibraryMods[Remote]) == "RemoteFunction" then
        table.remove(Args, 1)
        return LibraryMods[Remote]:InvokeServer(unpack(Args))
    end
    return Library("Remote").InvokeServer("Function", ...)
end

local function GetElement(PathString, StartObject)
    local Current = StartObject or game
    for Part in string.gmatch(PathString, "[^%.]+") do
        if Current:FindFirstChild(Part) then
            Current = Current[Part]
        else
            return false
        end
    end
    return Current
end


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
    Amount = math.round(Amount)
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

local Save = Library("LocalData"):Get()
while not Save do
    Save = Library("LocalData"):Get()
    RunService.Heartbeat:Wait()
end

if Library("Intro").IsPlaying then
    Fire("SetSetting", "Low Detail Mode", true)
    LocalPlayer.PlayerGui.ScreenGui.Enabled = true
    if LocalPlayer.PlayerGui:FindFirstChild("Intro") then
        LocalPlayer.PlayerGui.Intro.Parent = nil
    end
    pcall(function()
        StarterGui:SetCoreGuiEnabled("All", true)
    end)
    task.wait(1)
end

if not Debug.DisableAutoRejoins then
    local LatestVersion;
    local URL = "https://system-exodus.com/scripts/BGSI/Version.lua"
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
        while task.wait(900) do
            CheckForUpdates()
        end
    end)
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local ScreenGui = GetElement("PlayerGui.ScreenGui", LocalPlayer)
if ScreenGui then
    ScreenGui.ChildAdded:Connect(function(v)
        if v:IsA("Frame") and v.Name == "Prompt" and v:FindFirstChild("ExternalClose") then
            v.ExternalClose:Invoke()
        end
    end)
end

local Benefits = GetElement("PlayerGui.ScreenGui.HUD.Left.Currency.Coins.Bundles.Benefits", LocalPlayer)
if Benefits and Benefits.Visible then
    Fire("ClaimBenefits")
end

local NotifyGame = GetElement("PlayerGui.ScreenGui.HUD.NotifyGame", LocalPlayer)
if NotifyGame then
    NotifyGame.Changed:Connect(function()
        NotifyGame.Visible = false
    end)
end

local Playtime = GetElement("PlayerGui.ScreenGui.Playtime", LocalPlayer)
if Playtime then
    Playtime.Changed:Connect(function()
        Playtime.Visible = false
    end)
end

local AFKReveal = GetElement("PlayerGui.ScreenGui.AFKReveal", LocalPlayer)
if AFKReveal then
    AFKReveal.Changed:Connect(function()
        AFKReveal.Visible = false
    end)
end

local DailyRewards = GetElement("PlayerGui.ScreenGui.DailyRewards", LocalPlayer)
if DailyRewards then
    if DailyRewards.Visible then
        Fire("DailyRewardClaimStars")
    end
    DailyRewards.Changed:Connect(function()
        pcall(function()
            Fire("DailyRewardClaimStars")
            DailyRewards.Visible = false
        end)
    end)
end

local AFK = GetElement("PlayerScripts.AFK", LocalPlayer)
if AFK then
    AFK.Enabled = false
end

--[[local Chunker = require(game.ReplicatedStorage.Shared.Utils.Chunker)
local LastCoord = CFrame.new(0,0,0);
function Chunker:Update(WorldPosition)
    LastCoord = WorldPosition
    local Center = self:ToCoord(WorldPosition)
    local RenderDistance = self.RenderDistance
    local Folder = self._folder
    for Key,Instances in pairs(self._chunks) do
        local dx = Key.X - Center.X
        local dz = Key.Z - Center.Z
        if math.abs(dx) < RenderDistance and math.abs(dz) < RenderDistance then
            if not self._loaded[Key] then
                for _,Instance in ipairs(Instances) do
                    if typeof(Instance) == "Instance" then
                        Instance.Parent = folder
                    end
                    self.Loaded:Fire(Instance, Key)
                end
                self._loaded[Key] = true
            end
        else
            if self._loaded[Key] then
                for _,Instance in ipairs(Instances) do
                    if typeof(Instance) == "Instance" then
                        Instance.Parent = nil
                    end
                    self.Unloaded:Fire(Instance, Key)
                end
                self._loaded[Key] = nil
            end
        end
    end
end]]--

if not Debug.DisableUI then
    for _,v in pairs(ReplicatedStorage.Client:GetChildren()) do
        if v.Name ~= "Gui" and v.Name ~= "Framework" then
            v.Parent = nil
        end
    end
    Fire("SetSetting", "Hide Bubbles", true)
    Fire("SetSetting", "Hide All Pets", true)
    Fire("SetSetting", "Low Detail Mode", true)
    --[[for _,v in pairs(LocalPlayer.PlayerScripts:GetChildren()) do
        v.Parent = nil
    end]]
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    pcall(function()
        UserSettings():GetService("UserGameSettings").GraphicsQualityLevel = 1
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        UserSettings():GetService("UserGameSettings").MasterVolume = 0
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        sethiddenproperty(Terrain, "Decoration", false)
        sethiddenproperty(Lighting, "Technology", 2)
    end)
    for _, v in Lighting:GetChildren() do
        v:Destroy()
    end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 1
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.FogEnd = 0
        Lighting.FogStart = 0
        Lighting.Technology = Enum.Technology.Voxel
    end)
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
        if v:IsA("Workspace") then
            v.Terrain.WaterWaveSize = 0
            v.Terrain.WaterWaveSpeed = 0
            v.Terrain.Elasticity = 0
            v.Terrain.WaterReflectance = 0
            v.Terrain.WaterTransparency = 1
            sethiddenproperty(v, "StreamingTargetRadius", 64)
            sethiddenproperty(v, "StreamingPauseMode", 2)
            sethiddenproperty(v.Terrain, "Decoration", false)
        elseif v:IsA("Model") and sethiddenproperty then
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
        elseif v:IsA("Lighting") and sethiddenproperty then
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
            --v:SetOutgoingKBPSLimit(100)
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
    for _, v in pairs(game:GetDescendants()) do
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
    pcall(function()
        for _, v in pairs(CoreGui:GetChildren()) do
            if v.Name ~= "DevConsoleMaster" and v:IsA("ScreenGui") then
                v.Enabled = false
            end
        end
    end)
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
    local Username = Instance.new("TextButton")
    
    SystemExodus.Name = "System Exodus"
    SystemExodus.Parent = LocalPlayer.PlayerGui
    SystemExodus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SystemExodus.DisplayOrder = 999
    SystemExodus.IgnoreGuiInset = true
    if Debug.DisableUI then
        SystemExodus.Enabled = false
    else
        SystemExodus.Enabled = true
    end
    SystemExodus.ResetOnSpawn = false

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
    Info.Text = "Coins: Loading1 | Gems: Loading"
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
    LastTask.Text = "Last Task:"
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
    
    Username.Name = "Username"
    Username.Parent = WholeUI
    Username.AnchorPoint = Vector2.new(0.5, 0.5)
    Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Username.BackgroundTransparency = 1.000
    Username.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Username.BorderSizePixel = 0
    Username.Position = UDim2.new(0.502401173, 0, 0.947248161, 0)
    Username.Size = UDim2.new(0.993496597, 0, 0.0938402116, 0)
    Username.Font = Enum.Font.SourceSans
    Username.Text = "Reveal Username"
    Username.TextColor3 = Color3.fromRGB(222, 222, 222)
    Username.TextScaled = true
    Username.TextSize = 14.000
    Username.TextWrapped = true
    Username.MouseButton1Click:Connect(function()
        if Username.Text == "Reveal Username" then
            Username.Text = LocalPlayer.Name
        else
            Username.Text = "Reveal Username"
        end
    end)
    if Debug.ShowUsername then
        Username.Text = LocalPlayer.Name
    end
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

Library("StatsUtil").GetPickupRange = function(...)
    return 9999
end

--// Initialize Gum Items by Storage
local Gum = {}
for ID, Data in pairs(Library("Gum")) do
    if ID:find("Infinity") then continue end
    table.insert(Gum, {ID = ID, Storage = Data.Storage, Cost = Data.Cost, Area = Data.Area})
end
table.sort(Gum, function(a,b)
    return a.Storage > b.Storage
end)

local Flavors = {}
for ID, Data in pairs(Library("Flavors")) do
    if ID:find("VIP") then continue end
    table.insert(Flavors, {ID = ID, Bubbles = Data.Bubbles, Cost = Data.Cost, Area = Data.Area})
end
table.sort(Flavors, function(a,b)
    return a.Bubbles > b.Bubbles
end)

local function Color3ToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return r * 65536 + g * 256 + b
end

local Rarities = Library("Constants").RarityOrder
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

--// Currency Order
local Currency = {}
for Name, Data in pairs(Library("Currency")) do
    Currency[Name] = Data.LayoutOrder
end

--// Egg Order
local Eggs = {}
local EggData = {}
for Name, Data in pairs(Library("Eggs")) do
    if not Data.Cost or Data.ProductId or Name:find("Season") then continue end
    Data.Name = Name
    table.insert(Eggs, Data)
    EggData[Name] = Data
end
table.sort(Eggs, function(a, b)
    local Egg1 = Currency[a.Cost.Currency] or math.huge
    local Egg2 = Currency[b.Cost.Currency] or math.huge
    if Egg1 == Egg2 then
        return a.Cost.Amount > b.Cost.Amount
    else
        return Egg1 > Egg2
    end
end)
local EggNames = {}
for _, Data in pairs(Eggs) do
    table.insert(EggNames, Data.Name)
end

--// Egg ID vs Display Translation
local EggTranslation = {}
for ID, Data in pairs(Library("Rifts")) do
    if Data.Egg then
        EggTranslation[Data.Egg] = ID
        EggTranslation[ID] = Data.Egg
    end
end


local function GetBasePower(Pet, Currency)
    local BaseStats = table.clone(Library("Pets")[Pet.Name].Stats)
    if not BaseStats then return 1 end

    local Multi = 1
    if Pet.Shiny then Multi += 0.5 end
    if Pet.Mythic then Multi += 0.75 end

    for Name, Value in pairs(BaseStats) do
        BaseStats[Name] = Value * Multi
    end

    local Power = 1
    for Name, Value in pairs(BaseStats) do
        if Name == Currency then
            Power *= Value
        end
    end

    return Power
end

local Worlds = {}
local WorldsData = {}
for World, WorldData in pairs(Library("Worlds")) do
    WorldData.Name = World
    table.insert(Worlds, WorldData)
    WorldsData[World] = WorldData
end
table.sort(Worlds, function(a,b)
    return a.Order < b.Order
end)

local function GetPlayerWorld()
	local Worlds = workspace:WaitForChild("Worlds")
	for _, World in pairs(Worlds:GetChildren()) do
		local Spawn = World:FindFirstChild("Spawn")
		if Spawn and Spawn:IsA("BasePart") then
			local PlayerXZ = Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z)
			local SpawnXZ = Vector3.new(Spawn.Position.X, 0, Spawn.Position.Z)
			local Distance = (PlayerXZ - SpawnXZ).Magnitude
			if Distance < 1000 then
				return World.Name
			end
		end
	end
	return "The Overworld"
end

local EquippedPets = {}
local function GetEquippedPets()
    local NewEquippedPets = {}
    local Count = 0
    --[[for _, UID in pairs(Save.Teams[Save.TeamEquipped or 1].Pets or {}) do
        Count += 1
        NewEquippedPets[UID] = true
    end]]--
    for _, Team in pairs(Save.Teams) do
        for _, UID in pairs(Team.Pets) do
            Count += 1
            NewEquippedPets[UID] = true
        end
    end
    EquippedPets = NewEquippedPets
    return Count
end
GetEquippedPets()

local IsEquippingPets = false
local LastWorld = GetPlayerWorld()
local function EquipBestPets()
    if IsEquippingPets or Debug.DisableEquipPets then
        return
    end
    --[[local CurrentWorld = GetPlayerWorld()
    local WorldData = WorldsData[CurrentWorld]
    if Save.TeamEquipped ~= WorldData.Order then
        repeat task.wait()
            Fire("EquipTeam", WorldData.Order)
            task.wait(1)
        until Save.TeamEquipped == WorldData.Order
    end]]--

    IsEquippingPets = true

    local CurrentWorld = GetPlayerWorld()
    local WorldData = WorldsData[CurrentWorld]
    if not WorldData then
        IsEquippingPets = false
        return
    end

    if Save.TeamEquipped ~= WorldData.Order then
        repeat task.wait()
            Fire("EquipTeam", WorldData.Order)
            task.wait(1)
        until Save.TeamEquipped == WorldData.Order
    end

    GetEquippedPets()
    local PetPowers = {}
    local PetLib = Library("Pets")
    local MaxEquip = Library("StatsUtil"):GetMaxPetsEquipped(Save)

    for _, Data in pairs(Save.Pets) do
        local PetData = PetLib[Data.Name]
        if PetData and PetData.Rarity == "Secret" and Debug.UnequipSecretPets then 
            continue
        end
        local Power = GetBasePower(Data, WorldData.Currency)
        local Count = Data.Amount or 1
        for i = 1, Count do
            table.insert(PetPowers, {UID = Data.Id, Power = Power})
        end
    end

    table.sort(PetPowers, function(a, b)
        return a.Power > b.Power
    end)

    local CurrentEquipped = {}
    for _, Data in pairs(Save.Pets) do
        if EquippedPets[Data.Id] then
            local Power = GetBasePower(Data, WorldData.Currency)
            table.insert(CurrentEquipped, {UID = Data.Id, Power = Power})
        end
    end
    table.sort(CurrentEquipped, function(a, b)
        return a.Power < b.Power
    end)

    local AlreadyEquipped = {}
    for _, pet in ipairs(CurrentEquipped) do
        AlreadyEquipped[pet.UID] = true
    end

    local i = 1
    while #CurrentEquipped < MaxEquip and i <= #PetPowers do
        local Pet = PetPowers[i]
        if not EquippedPets[Pet.UID] and not AlreadyEquipped[Pet.UID] and CurrentWorld == GetPlayerWorld() then
            Fire("EquipPet", Pet.UID)
            table.insert(CurrentEquipped, Pet)
            EquippedPets[Pet.UID] = true
            AlreadyEquipped[Pet.UID] = true
        end
        i += 1
    end

    for _, Better in ipairs(PetPowers) do
        if AlreadyEquipped[Better.UID] then continue end

        local Worst, Index = nil, nil
        for i, Pet in ipairs(CurrentEquipped) do
            if not Worst or Pet.Power < Worst.Power then
                Worst = Pet
                Index = i
            end
        end

        if Worst and Better.Power > Worst.Power and CurrentWorld == GetPlayerWorld() then
            Fire("UnequipPet", Worst.UID)
            Fire("EquipPet", Better.UID)
            table.remove(CurrentEquipped, Index)
            table.insert(CurrentEquipped, Better)
            EquippedPets[Worst.UID] = nil
            EquippedPets[Better.UID] = true
            AlreadyEquipped[Better.UID] = true

            table.sort(CurrentEquipped, function(a, b)
                return a.Power < b.Power
            end)
        else
            break
        end
    end

    IsEquippingPets = false
    --Fire("EquipBestPets")
    GetEquippedPets()
end

EquipBestPets()

local Masteries = {}
for Mastery in pairs(Library("Mastery").Upgrades) do
    Masteries[#Masteries + 1] = Mastery
end
local function ClaimMasteries()
    for _,v in pairs(Masteries) do
        if Save.MasteryLevels and Save.MasteryLevels[v] then
            local TrueLevel = Save.MasteryLevels[v] + 1 -- #MasteryUtil:GetUpgrades(Save, v)
            for Index, Value in pairs(Library("Mastery").Upgrades[v].Levels) do
                if Index == TrueLevel and (not Value.Cost or Save[Value.Cost.Currency] >= Value.Cost.Amount) then
                    UIText(UI.LastTask, "Purchased Mastery: "..v.." "..TrueLevel)
                    Fire("UpgradeMastery", tostring(v))
                end
            end
        else
            local Level = Library("Mastery").Upgrades[v].Levels[1]
            if (not Level.Cost or Save[Level.Cost.Currency] >= Level.Cost.Amount) and (v ~= "Shops" or (v == "Shops" and (Save.MasteryLevels["Buffs"] or 0) >= MinimumBuffLevel)) then
                UIText(UI.LastTask, "Initialized Mastery: "..v)
                Fire("UpgradeMastery", v)
            end
        end
    end
end

local Prizes = Library("Prizes")
local PrizeTranslation = {["Eggs"] = "Hatches", ["Bubbles"] = "Bubbles"}
local function ClaimPrizes()
    for i,v in pairs(Prizes) do
        local Type = PrizeTranslation[v.Type]
        if Save.ClaimedPrizes[v.Key] then
            continue
        end
        if Save.Stats[Type] >= v.Requirement then
            UIText(UI.LastTask, "Claimed Prize: "..i.." ("..v.Key..")")
            Fire("ClaimPrize", i)
        end
    end
end

local function ClaimIndexRewards()
    for i,v in pairs(Library("Eggs")) do
        if not v.Reward then continue end
        if not Save.EggPrizesClaimed["S"..i] then
            local Data = Library("IndexUtil"):GetEggCompleted(Save, v.World, "Shiny", i)
            if (Data.Total - Data.Found) <= 0 then
                UIText(UI.LastTask, "Claimed Index Reward: "..i)
                Fire("EggPrizeClaim", i, true)
            end
        end
        if not Save.EggPrizesClaimed[i] then
            local Data = Library("IndexUtil"):GetEggCompleted(Save, v.World, "Normal", i)
            if (Data.Total - Data.Found) <= 0 then
                UIText(UI.LastTask, "Claimed Index Reward: "..i)
                Fire("EggPrizeClaim", i, false)
            end
        end
    end
end

local function ClaimCodes()
    for Code in pairs(Library("Codes") or {}) do
        if table.find(Save.Redeemed, Code) then
            continue
        end
        UIText(UI.LastTask, "Redeemed Code: "..Code)
        Invoke("RedeemCode", Code)
    end
end
ClaimCodes()

workspace.Rendered.Gifts.ChildAdded:Connect(function(Gift)
    Fire("ClaimGift", Gift.Name)
    Gift.Parent = nil
end)
local SeasonID = Library("SeasonUtil"):GetCurrentSeason()
if SeasonID then
    SeasonID = SeasonID.ID
end
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
                    if Library("StatsUtil"):GetMaxPetStorage(Save) <= (Library("StatsUtil"):GetUsedPetStorage(Save)+10) then break end

                    UIText(UI.LastTask, "Opened: "..Item.." x10")
                    Fire("HatchPowerupEgg", Item, 10)
                end
            end
        end

        if Item:match("Series %d Egg") then
            local Series = tonumber(Item:match("Series%s+(%d+)%s+Egg"))
            if Series == SeasonID then
                local Times = math.floor(Amount / 6)
                for i = 1, Times do
                    if Library("StatsUtil"):GetMaxPetStorage(Save) <= (Library("StatsUtil"):GetUsedPetStorage(Save)+10) then break end
                    UIText(UI.LastTask, "Opened: "..Item.." x10")
                    Fire("HatchPowerupEgg", Item, 6)
                end
            end
        end

        if Item:find("Box") then
            local Times = math.floor(Amount / 10)
            for i = 1, Times do
                if Library("StatsUtil"):GetMaxPetStorage(Save) <= (Library("StatsUtil"):GetUsedPetStorage(Save)+10) then break end
                UIText(UI.LastTask, "Opened: "..Item.." x10")
                Fire("UseGift", Item, 10)
                task.wait(1.5)
            end
        end
    end
end

workspace.Rendered.Generic.ChildAdded:Connect(function(Item)
    if Item:IsA("Part") and Item.Name:find("-") then
        Fire("GrabVisualItem", {Item.Name})
        Item.Parent = nil
    end
    if Item.Name == "Portal" then
        task.wait(0.5)
        if Item:FindFirstChild("Display") and Item.Display:FindFirstChild("TouchInterest") then
            Item.Display.TouchInterest:Destroy()
        end
    end
end)

local function ClaimChest()
    for Item, Cooldown in pairs(Save.Cooldowns) do
        if Item:find("Chest") and (os.time()-Cooldown) >= 0 and not Debug["Disable"..Item:gsub(" ", "")] then            
            if Save.MasteryLevels["Buffs"] and Save.MasteryLevels["Buffs"] <= 14 then
                Fire("Teleport", "Workspace.Rendered.Chests."..Item)
                task.wait(1)
                Fire("ClaimChest", Item)
            else
                Fire("ClaimChest", Item, true)
            end

            UIText(UI.LastTask, "Claimed Chest: "..Item)
        end
    end
end

local function PurchaseBaseShop()
    for _,v in pairs(Flavors) do
        if v.Cost and type(v.Cost) == "table" and v.Cost.Currency then
            if not Save.Flavors[v.ID] and v.Bubbles > Library("Flavors")[Save.Bubble.Flavor].Bubbles and Save[v.Cost.Currency] >= v.Cost.Amount then
                UIText(UI.LastTask, "Purchased Item: "..v.ID)
                Fire("GumShopPurchase", v.ID)
                break
            end
        end
    end
    
    for _,v in pairs(Gum) do
        if v.Cost and type(v.Cost) == "table" and v.Cost.Currency then
            if not Save.Gum[v.ID] and v.Storage > Library("StatsUtil"):GetBubbleStorage(Save) and Save[v.Cost.Currency] >= v.Cost.Amount then
                UIText(UI.LastTask, "Purchased Item: "..v.ID)
                Fire("GumShopPurchase", v.ID)
                break
            end
        end
    end
end
Library("LocalData"):ConnectDataChanged("Stats", PurchaseBaseShop)

local function ClaimPlaytimeRewards()
    local Current = (os.time() - Save.PlaytimeRewards.Start)
    for i,v in pairs(Library("Playtime").Gifts) do
        if (Current > v.Time) and (not Save.PlaytimeRewards.Claimed[tostring(i)]) then
            UIText(UI.LastTask, "Claimed Playtime Reward: "..i)
            Invoke("ClaimPlaytime", i)
        end
    end
end

local BestIsland;
local BestWorld;
local function UnlockIslands()
    for _, WorldData in pairs(Worlds) do
        local World = WorldData.Name
        if Save.WorldsUnlocked[World] then
            for _, AreaData in pairs(WorldData.Islands) do
                local Height = workspace.Worlds[World].Islands[AreaData.Name].Island.UnlockHitbox.CFrame
                if not Save.AreasUnlocked[AreaData.Name] then
                    if GetPlayerWorld() ~= World then
                        repeat task.wait()
                            Fire("Teleport", "Workspace.Worlds."..World..".FastTravel.Spawn")
                            task.wait(1)
                        until GetPlayerWorld() == World
                    end
                    repeat RunService.Heartbeat:Wait()
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.CFrame.X + math.random(0,5), Height.Y + 5, HumanoidRootPart.CFrame.Z + math.random(0,5))
                    until Save.AreasUnlocked[AreaData.Name]
                end
                BestIsland = AreaData.Name
                BestWorld = World
            end
        else
            if Save[WorldsData[World].UnlockCost.Currency] >= WorldsData[World].UnlockCost.Amount then
                Fire("UnlockWorld", World)
            end
        end
    end
end
UnlockIslands()

local MinigameBuilder = {"Easy","Medium","Hard","Insane"}
if Library("Cart Escape") and debug.getupvalue then
    local StageVariables = debug.getupvalue(Library("Cart Escape"), 2)
    if type(StageVariables) == "table" and StageVariables.Easy then
        for Difficulty, Data in pairs(StageVariables) do
            Data.TimeScale = 50
            Data.ObstacleVariation = 0
        end
    end
end

local function CompleteMinigames()
    if (Save.NextWheelSpin-os.time()) <= 0 then
        UIText(UI.LastTask, "Claimed Free Wheel Spin")
        Fire("ClaimFreeWheelSpin")
    end

    if Save.Powerups["Spin Ticket"] and not Debug["DisableUseSpinTicket"] then
        for i = 1, Save.Powerups["Spin Ticket"] do
            UIText(UI.LastTask, "Spun Minigame Wheel")
            Invoke("WheelSpin")
            Fire("ClaimWheelSpinQueue")
        end
    end

    if (Save.DoggyJump.Claimed) ~= 3 then
        UIText(UI.LastTask, "Completed Doggy Jump Minigame")
        Fire("DoggyJumpWin", 3)
    end

    for Name, Data in pairs(Library("Minigames")) do
        if not Save.Cooldowns[Name] or (Save.Cooldowns[Name] and (Save.Cooldowns[Name]-os.time()) <= 0 and not Debug["DisableMinigame"..Name:gsub(" ", "")]) then
            local Cost = Data.Cost
            local Duration = Data.ItemDelay
            if Save[Cost.Currency] >= Cost.Amount then
                Fire("StartMinigame", Name, MinigameBuilder[Save.MinigameLevels[Name]])
                task.wait(Duration+5 or 5)
                if Name == "Robot Claw" then
                    if not workspace:FindFirstChild("ClawMachine") then continue end
                    for _,Ball in pairs(workspace.ClawMachine:GetChildren()) do
                        local ItemID = Ball:GetAttribute("ItemGUID")
                        if ItemID then
                            Fire("GrabMinigameItem", ItemID)
                            task.wait(Duration)
                        end
                    end
                end
                
                if Name == "Cart Escape" then
                    task.wait(17)
                end
                local MinigameHUD = GetElement("PlayerGui.ScreenGui.MinigameHUD", LocalPlayer)
                repeat task.wait()
                    Fire("FinishMinigame")
                    task.wait(0.5)
                until not MinigameHUD.Parent or not MinigameHUD.Visible
            end
            task.wait(5)
        end
    end
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

local function FindBuffs()
    ActiveBuffs = GetActiveBuffs()

    if not ActiveBuffs["GoldRush 1"] and not Debug["DisableUseGoldenOrb"] and IsFarming then
        Fire("UseGoldenOrb")
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

local function UsePotion(ID, Tier)
    if not ActivePotions[ID.." "..Tier] and not ActivePotions[ID..Tier] and not ActivePotions[ID] and not Debug["DisableUse"..ID..Tier] then
        Fire("UsePotion", ID, Tier)
        UIText(UI.LastTask, "Used Potion: "..ID.." "..Tier)
        GetActivePotions()
    end
end

local BannedPotions = {"Infinity"}
local HatchingPotions = {"Lucky", "Speed", "Mythic"}
local FarmingPotions = {"Coins", "Tickets"}
local function FindPotions()
    ActivePotions = GetActivePotions()
    local GroupedPotions = {}

    for _, Data in pairs(Save.Potions) do
        local Name = Data.Name
        local Tier = Data.Level
        local Amount = Data.Amount

        local IsBanned = false
        for _, Potion in ipairs(BannedPotions) do
            if Name:find(Potion) then
                IsBanned = true
                break
            end
        end
        if IsBanned then continue end

        local PotionData = Library("Potions")[Name]
        if not PotionData or not PotionData.Buff or not PotionData.Buff.Expiry or #PotionData.Buff.Expiry == 0 then
            continue
        end

        GroupedPotions[Name] = GroupedPotions[Name] or {}
        table.insert(GroupedPotions[Name], Tier)
    end

    for Name, Tiers in pairs(GroupedPotions) do
        table.sort(Tiers, function(a, b) return a > b end)

        if (not IsHatching and table.find(HatchingPotions, Name)) 
        or (not IsFarming and table.find(FarmingPotions, Name)) then continue end
        for _, Tier in ipairs(Tiers) do
            if Tier < 6 or (Tier >= 6 and (CanUsePotions or (IsFarmin and not IsHatching))) then
                UsePotion(Name, Tier)
                break
            end
        end
    end
end

local function GetPotionData(Potion, Tier)
    for _, Data in pairs(Save.Potions) do
        if Data.Name == Potion and (not Tier or Tier and Data.Level == Tier) then
            return Data
        end
    end
end

local function CraftPotions()
    if Debug.DisableCraftPotions or (Save.MasteryLevels["Buffs"] or 0) < MinimumBuffLevel or Save.Gems <= 20000 then return end
    
    for Name, Data in pairs(Library("Potions")) do
        local Cost = Data.CraftingCosts
        if Cost then
            for i, CurrencyData in pairs(Cost) do
                local Potions = CurrencyData.Potions
                local Gems = CurrencyData.Gems
                local PotionData = GetPotionData(Name, i)
                if Save.Gems >= Gems and PotionData and PotionData.Amount >= Potions then
                    local MaxByPotions = math.floor(PotionData.Amount / Potions)
                    local MaxByGems = math.floor(Save.Gems / Gems*Potions)
                    local MaxCrafts = math.min(MaxByPotions, MaxByGems)
                    
                    if MaxCrafts >= 1 then
                        Fire("CraftPotion", Name, i + 1, true)
                        UIText(UI.LastTask, "Crafted Potion: "..Name.." "..(i+1).." x"..MaxCrafts)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end

local function PurchaseMerchants()
    if Debug.DisablePurchaseMerchants or (Save.MasteryLevels["Buffs"] or 0) < MinimumBuffLevel then return end
    
    for Shop, ShopData in pairs(Library("Shops")) do
        if Shop == "temp-shop" then continue end
        if not ShopData.Unlocked(Save) then continue end
        local ItemData, Stock = Library("ShopUtil"):GetItemsData(Shop, LocalPlayer, Save)
        for i, Data in pairs(ItemData) do
            local Item = Data.Product
            local Cost = Data.Cost
            local Stock = Stock[i] - (Save.Shops[Shop].Bought[i] or 0)
            if Stock < 1 then continue end
            local MaxByGems = math.min(Stock, math.floor(Save[Cost.Currency]/Cost.Amount))
            if MaxByGems < 1 then continue end
            UIText(UI.LastTask, "Purchasing "..Item.Name.." "..Stock.." from "..Shop)
            for Times = 1, MaxByGems do
                Fire("BuyShopItem", Shop, i)
            end
            if Shop == "shard-shop" and Library("ShopUtil"):GetMaxFreeRerolls(Save) >= (Save.ShopFreeRerolls.Used or 0) then
                Fire("ShopFreeReroll", Shop)
            end
        end
    end
end

local function EnchantEquippedPets()
    if not Settings["Enchant Equipped"]
    or Save.Gems <= 100000
    or Save.Stats.Hatches <= 500
    or (Save.MasteryLevels["Buffs"] or 0) < MinimumBuffLevel then 
        return
    end

    local EnchantsNeeded = 0
    for _, v in pairs(Settings["Enchant Equipped"]) do
        EnchantsNeeded += 1
    end

    local EnchantingPets = {}
    for UID in pairs(EquippedPets) do
        table.insert(EnchantingPets, UID)
    end

    repeat task.wait()
        for _, Data in pairs(Save.Pets) do
            if table.find(EnchantingPets, Data.Id) then
                if not Data.Enchants then
                    continue
                end

                local EnchantsGotten = 0
                local BadSlots = {}

                for Slot, Enchant in ipairs(Data.Enchants) do
                    local Name = Enchant.Id:gsub("-", " "):gsub("(%a)([%w_']*)", function(f, r)
                        return f:upper() .. r:lower()
                    end)

                    local SettingEnchant = Settings["Enchant Equipped"][Name]
                    local IsGood = SettingEnchant and (Enchant.Level == SettingEnchant.Tier or (SettingEnchant.HigherTiers and Enchant.Level >= SettingEnchant.Tier))

                    if IsGood then
                        EnchantsGotten += 1
                    else
                        table.insert(BadSlots, Slot)
                    end

                    if (Settings["Require All Enchants"] and EnchantsGotten >= EnchantsNeeded) or (not Settings["Require All Enchants"] and EnchantsGotten >= 1) then
                        table.remove(EnchantingPets, table.find(EnchantingPets, Data.Id))
                        break
                    end
                end

                if table.find(EnchantingPets, Data.Id) then
                    local RerollSlot = BadSlots[1] or 1

                    if Save.Powerups["Reroll Orb"] and Save.Powerups["Reroll Orb"] >= 1 and not Debug["DisableUseRerollOrb"] then
                        Fire("RerollEnchant", Data.Id, RerollSlot)
                    else
                        Invoke("RerollEnchants", Data.Id)
                    end
                    task.wait(0.1)
                end
            end
        end
    until #EnchantingPets == 0 or Save.Gems <= 100000

    return Save.Gems <= 100000 and "User ran out of Gems!" or "Successfully Enchanted Equipped Pets!"
end

local ChestPriority = {
    ["royal-chest"] = "The Overworld",
    ["golden-chest"] = "The Overworld",
    ["gift-rift"] = "The Overworld",
    ["dice-rift"] = "Minigame Paradise",
}
local function FindChests()
    for Name, World in ipairs(ChestPriority) do
        local Chest = workspace.Rendered.Rifts:FindFirstChild(Name)
        local ChestName = Name:gsub("-chest", ""):gsub("-rift", ""):gsub("(%a)(%w*)", function(First, Rest)
            return First:upper() .. Rest:lower()
        end)
        if Chest and Chest:FindFirstChild("Output") and not Debug["Disable"..ChestName.."Rift"] then
            local CurrentWorld = GetPlayerWorld()
            if CurrentWorld ~= World then
                repeat task.wait()
                    Fire("Teleport", "Workspace.Worlds."..World..".FastTravel.Spawn")
                    task.wait(1)
                until GetPlayerWorld() == World
            end
            Teleport(Chest.Output.CFrame * CFrame.new(0, 10, 0))

            if Name == "gift-rift" then
                Fire("ClaimRiftGift", "gift-rift")
            elseif Name:find("chest") or Name:find("dice") then
                Key = ChestName.." Key"
                for i = 1, (Save.Powerups[Key] or 0) do
                    if not Chest.Parent or Save.Powerups[Key] <= 0 then break end
                    UIText(UI.LastTask, "Unlocking Rift Chest: "..Name.." x"..Save.Powerups[Key])
                    task.wait(1.5)
                    Fire("UnlockRiftChest", Name)
                end
            end
        end
    end
end

local function IsGoodGenieReward(Panel)
    local IsInf = false
    local IsGems = false

    for _, Reward in pairs(Panel.Rewards) do
        if Reward.Type == "Potion" and Reward.Name == "Infinity Elixir" then
            IsInf = Reward.Amount
        elseif Reward.Type == "Currency" and Reward.Currency == "Gems" then
            IsGems = Reward.Amount
        end
    end

    return IsInf, IsGems
end

local function IsBadGenieTask(Panel)
    for _,Task in pairs(Panel.Tasks) do
        if Task.Type == "Hatch" and Task.Egg then
            return true
        end
    end
    return false
end

local function StartGenieQuest()
    if (Save.GemGenie.Next - os.time()) > 0 then return end
    local GemAmount = {Amount = 0, Quest = 0}
    local InfAmount = {Amount = 0, Quest = 0}
    for i = 0, 2 do
        local Quest = Library("GenieQuest")(Save, Save.GemGenie.Seed + i)
        local IsInf, IsGems = IsGoodGenieReward(Quest)
        if IsBadGenieTask(Quest) then continue end

        if IsInf and IsInf > InfAmount.Amount then
            InfAmount.Amount = IsInf
            InfAmount.Quest = i+1
        elseif IsGems and IsGems > GemAmount.Amount then
            GemAmount.Amount = IsGems
            InfAmount.Quest = i+1
        end
    end
    if InfAmount.Quest ~= 0 then
        return Fire("StartGenieQuest", InfAmount.Quest)
    end
    if GemAmount.Quest ~= 0 then
        return Fire("StartGenieQuest", GemAmount.Quest)
    end
    if GemAmount.Amount == 0 or InfAmount.Amount == 0 and Save.Powerups["Reroll Orb"] >= 20 then
        return Fire("RerollGenie")
    end
end

Library("Remote").Event("TradeRequest"):Connect(function(User)
    if not Settings["Trade Users"] then return end
    if table.find(Settings["Trade Users"], User.Name) then
        Fire("TradeAcceptRequest", User)
    end
end)

local ChannelHooked = false
Library("Remote").Event("TradeEnded"):Connect(function()
    if not Settings["Trade Users"] then return end
    ChannelHooked = false
end)

Library("Remote").Event("TradeUpdated"):Connect(function(Data)
    if not Settings["Trade Users"] then return end
    local Main = Data.Party0
    if Main.Accepted and not Main.Confirmed then
        task.wait(0.5)
        Fire("TradeAccept")
    end
    if Main.Confirmed then
        task.wait(0.5)
        Fire("TradeConfirm")
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
        if not Message.TextSource or not table.find(Settings["Trade Users"], Message.TextSource.Name) then
            return
        end

        local Text = Message.Text:lower():gsub("^%s*(.-)%s*$","%1")

        local Name, Number = Text:match("^add%s+(.+)%s+x(%d+)$")
        if not Name then
            Name, Number = Text:match("^add%s+(.+)%s+(%d+)x$")
        end

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
                Fire("TradeAddPet", ID)
                Offered[ID] = true
                NewCount += 1
            end
        end
    end)
end)

local function PetFunction(Pet)
    local CurrentWorld = GetPlayerWorld()
    if LastWorld ~= CurrentWorld or GetEquippedPets() < Library("StatsUtil"):GetMaxPetsEquipped(Save) then
        LastWorld = GetPlayerWorld()
        EquipBestPets()
    end
    for _, Data in pairs(Save.Pets) do
        if EquippedPets[Data.Id] then
            local Power = GetBasePower(Data, WorldsData[CurrentWorld].Currency)
            local HatchedPower = GetBasePower(Pet, WorldsData[CurrentWorld].Currency)
            if Power ~= 1 and HatchedPower > Power then
                EquipBestPets()
                break
            end
        end
    end
end

local IsDeleting = false
local function DeletePets()
    if IsDeleting or IsEquippingPets or Debug.DisableAutoDelete then return end
    --[[local TotalEquipped = GetEquippedPets()
    if ((TotalEquipped or 0) - (Library("StatsUtil"):GetMaxPetsEquipped(Save) or 0)) ~= 0 then
        return EquipBestPets()
    end]]--
    
    GetEquippedPets()
    IsDeleting = true
    local MultiDelete = {}
    for _, Data in pairs(Save.Pets) do
        local PetData = Library("Pets")[Data.Name]
        local Amount = Data.Amount or 1
        if Data.Locked then continue end
        if (not SaveRarities[PetData.Rarity] or 
        (PetData.Rarity == "Legendary" and (PetData.Tier or 1) <= (Debug.DeleteLegendaryTier or 2) and not PetData.Tag and not Data.Shiny and not Data.Mythic)) 
        and not EquippedPets[Data.Id] and not IsEquippingPets then
            if #MultiDelete >= 100 then break end
            if Amount == 1 then
                table.insert(MultiDelete, Data.Id.."-0")
            else
                for i = 1, math.min(100, Amount) do
                    table.insert(MultiDelete, Data.Id.."-stack")
                end
            end
        end
    end
    if not IsEquippingPets then
        Fire("MultiDeletePets", MultiDelete)
    end
    IsDeleting = false
end

local OriginalColor = UI.BackgroundColor3
local IsFlashing = false
local CurretTween;
local function FlashUI(Color)
    if CurretTween then
        CurretTween:Cancel()
        IsFlashing = false
        UI.BackgroundColor3 = OriginalColor
        task.wait(5)
    end
    IsFlashing = true
    coroutine.wrap(function()
        while task.wait() and IsFlashing do
            local Tween = TweenService:Create(UI, TweenInfo.new(2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color})
            CurretTween = Tween
            Tween:Play()
            Tween.Completed:Wait()

            Tween = TweenService:Create(UI, TweenInfo.new(2, Enum.EasingStyle.Linear), {BackgroundColor3 = OriginalColor})
            CurretTween = Tween
            Tween:Play()
            Tween.Completed:Wait()
        end
    end)()
end


local TurnOffWebhook = false
local BestRoll = tonumber(RemoveSuffix(UI.SessionHatch.Text:split("/")[2]:gsub("%)", "")))
local function Webhook(Return, IsSeasonPass)
    --local Egg = Return.Name
    if TurnOffWebhook then return end

    local Pet = Return
    local Rarity = Library("Pets")[Pet.Name].Rarity

    local Name = Library("PetUtil"):GetName(Pet)
    local Chance = Library("PetUtil"):GetChance(Pet)
    local Stats = Library("PetUtil"):GetStats(Pet)
    local Difficulty = 100 / Chance
    
    PetFunction(Pet)

    local Global = false
    local User = false
    if Settings.Webhook and Settings.Webhook ~= "" then
        if Rarity == "Secret" or Settings["Minimum Send Difficulty"] and Difficulty >= RemoveSuffix(tostring(Settings["Minimum Send Difficulty"])) then
            User = true
        end
    end
    if Difficulty >= 5000000 or Rarity == "Secret" then
        Global = true
    end

    if Rarity == "Secret" then
        FlashUI(Color3.fromRGB(255, 77, 77))
    end

    local Color = Color3ToHex(Library("Constants").RarityColors[Rarity]) or 0
    local Description = {
        "<:Bubble:1361380205918163124> Bubbles: **`+"..AddCommas(Stats.Bubbles or 0).."`**",
        "<:Coin:1361380591580348576> Coins: **`x"..AddCommas(Stats.Coins or 0).."`**",
        "<:Gem:1361380483833004304> Gems: **`x"..AddCommas(Stats.Gems or 0).."`**",
    }

    local Image;
    if Pet.Mythic or Pet.Shiny then
        Image = Library("Pets")[Pet.Name].Images[("%*%*"):format(Pet.Mythic and "Mythic" or "", Pet.Shiny and "Shiny" or "")]
    else
        Image = Library("Pets")[Pet.Name].Images.Normal
    end

    if Difficulty >= (BestRoll or 0) then
        BestRoll = Difficulty
        UIText(UI.SessionHatch, "Session Roll: "..Name.." (1/"..AddSuffix(Difficulty)..")")
    end
    UIText(UI.LastHatch, "Last Hatch: "..Name.." (1/"..AddSuffix(Difficulty)..")")

    local Message = {
        ["username"] = "System Exodus | Egg Notifier",
        ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
        ["content"] = "",
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
                    ["url"] = "https://biggamesapi.io/image/"..(Image:gsub("rbxassetid://", "") or "0")
                },
            },
        },
    }

    if Global and not IsSeasonPass then
        request({
            Url = "https://discord.com/api/webhooks/s/ss-ssss?thread_id=ssss",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(Message)
        })
    end
    if User then
        if Rarity == "Secret" and Settings["Discord ID"] and Settings["Discord ID"] ~= "" then
            Message["content"] = "<@"..Settings["Discord ID"]..">"
        end
        Message["embeds"][1]["title"] = "||"..LocalPlayer.Name.."|| - "..Name.." (1/"..AddSuffix(Difficulty)..")"..(IsSeasonPass and " !PREMIUM PASS!" or "")
        request({
            Url = Settings.Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(Message)
        })
    end
end

local SeasonUtil = Library("SeasonUtil")
local Season = SeasonUtil:GetCurrentSeason()
local IsSent = false
local function ClaimSeasonRewards()
    if not Season or not Season.ID then return end

    local CurrentLevel = Save.Season.Level
    local CurrentPoints = Save.Season.Points

    if CurrentLevel >= 15 and not Save.Season.IsInfinite then
        Fire("BeginSeasonInfinite")
    end

    if not Save.Season.IsInfinite then
        for Index = 1, #Season.Track do
            if Index <= CurrentLevel then continue end
            local Requirement = SeasonUtil:GetRequirement(Season, Index)
            if Requirement <= CurrentPoints and not Save.Season.IsInfinite then
                Fire("ClaimSeason")
            end
        end
    else
        local InfiniteSegment = SeasonUtil:GetInfiniteSegment({ Season = Save.Season }, Season, CurrentLevel)
        local InfiniteSegmentRewards = SeasonUtil:GetInfinityRewards(Save, CurrentLevel)
        local Free = InfiniteSegmentRewards.Free
        local Paid = InfiniteSegmentRewards.Premium
        if (Paid.Name or ""):find("Luminosity") and not Save.Passes["Season Premium"] and not IsSent then
            Webhook(Paid, true)
            IsSent = true
            return
        end
        if InfiniteSegment and InfiniteSegment.Requirement >= 0 and CurrentPoints >= InfiniteSegment.Requirement then
            Fire("ClaimSeason")
        end
    end
end

local OldPets = {}
for _,Data in pairs(Save.Pets) do
    OldPets[Data.Id] = (Data.Amount or 1)
end
Library("LocalData"):ConnectDataChanged("Pets", function(NewSave)
    if IsSendingWebhook then return end
    IsSendingWebhook = true
    local NewPets = {}
    for _,Data in pairs(NewSave.Pets) do
        NewPets[Data.Id] = (Data.Amount or 1)
        if not OldPets[Data.Id] or OldPets[Data.Id] < (Data.Amount or 1) then
            Webhook(Data)
        end
    end
    OldPets = NewPets
    IsSendingWebhook = false
end)

local HatchedEggs = {}
local CurrentEgg = {}
Library("RemoteEvent").OnClientEvent:Connect(function(...)
    local Args = {...}
    if Args[1] == "HatchEgg" then
        if CurrentEgg.Name and not HatchedEggs[CurrentEgg.Name] then 
            HatchedEggs[CurrentEgg.Name] = 0
        end
        if CurrentEgg.Name then
            HatchedEggs[CurrentEgg.Name] += 1
        end
    end
    if Args[1] == "MadePetShiny" then
        TurnOffWebhook = true
        task.wait(2)
        TurnOffWebhook = false
    end
end)

local function CanAffordEgg(Egg)
    if Egg == "Infinity Egg" then
        Egg = Library("GetInfinityEgg")(LocalPlayer)
    else
        Egg = Library("Eggs")[Egg]
    end
    if not Egg then return 0 end
    local CostPerEgg = Library("ItemUtil"):GetAmount(Egg.Cost)
    local CurrencyOwned = Library("ItemUtil"):GetOwnedAmount(Save, Egg.Cost)
    local CanAfford = math.floor(CurrencyOwned / CostPerEgg)
    return CanAfford
end


local Generic = workspace.Rendered.Generic
local InvalidEggs = {"Silly Egg", "Aura Egg", "Underworld Egg"}
local UserEgg = Settings["Open Egg"]:lower()
local function FindEgg(Custom)
    if ((not Settings["Open Egg"] or Settings["Open Egg"] and Settings["Open Egg"] == "") and not Custom) or CurrentSource == "Rift" then return end
    local TargetLower = Custom and Custom:lower() or UserEgg
    for _, Data in pairs(Eggs) do
        local NameLower = Data.Name:lower()
        if table.find(InvalidEggs, Data.Name) then continue end
        if Custom and NameLower ~= TargetLower and TargetLower ~= "infinity egg" then continue end
        if not Custom and not TargetLower:find("best") and NameLower ~= TargetLower and TargetLower ~= "infinity egg" then continue end

        if TargetLower == "infinity egg" then
            Data.Name = "Infinity Egg"
        end
        if CanAffordEgg(Data.Name) < 1 then
            ShouldFarm = true
            return
        end
        if Data.Name == "Infinity Egg" and not Save.AreasUnlocked["Hatching Zone"] and Save.Gems >= 10000 then
            Fire("UnlockHatchingZone")
        end

        CurrentEgg.Name = Data.Name
        CurrentSource = "Normal"

        local World = Data.World and workspace.Worlds:FindFirstChild(Data.World)

        if not Generic:FindFirstChild(Data.Name) or (Generic:FindFirstChild(Data.Name) and World and GetPlayerWorld() ~= World.Name) then
            UIText(UI.LastTask, "Loading in "..CurrentEgg.Name.."!")
            if Data.Island and World and Data.Name ~= "Infinity Egg" then
                Fire("Teleport", "Workspace.Worlds."..Data.World..".Islands."..Data.Island..".Island.Portal.Spawn")
            elseif Data.Event and Data.Name ~= "Throwback Egg" and Data.Name ~= "200M Egg" and Data.Name ~= "Game Egg" then
                Fire("Teleport", "Workspace.Event.Portal.Spawn")
                task.wait(1)
                Teleport(CFrame.new(-399, 12015, 28))
            else
                Fire("Teleport", "Workspace.Worlds."..(Data.Name == "Game Egg" and "Minigame Paradise" or Data.World or "The Overworld")..".FastTravel.Spawn")
                task.wait(1)
            end
        end

        task.wait(1)

        for _, Chunker in pairs(workspace.Rendered:GetChildren()) do
            if Chunker.Name == "Chunker" then
                for _, Egg in pairs(Chunker:GetChildren()) do
                    if Egg.Name == CurrentEgg.Name then
                        local Position = Egg.Plate.CFrame * CFrame.new(math.random(0, 3), 6, math.random(0, 3))
                        local Rotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
                        UIText(UI.LastTask, "Teleporting & Hatching "..CurrentEgg.Name)
                        Teleport(Position * Rotation)
                        CurrentEgg.Position = Position.Position
                        return
                    end
                end
            end
        end
        --if CurrentEgg.Name == "100M Egg" and not 
    end
end

local function ToTimestamp(Seconds)
    if type(Seconds) ~= "number" or Seconds <= 0 then
        return "Unknown"
    end

    local future = os.time() + math.floor(Seconds)
    return string.format("<t:%d:R>", future)
end

local function rahh(str, offset)
    offset = offset or 5
    local obf = ""
    for i = 1, #str do
        local c = string.byte(str, i)
        obf ..= string.char((c + offset) % 126)
    end
    return string.reverse(obf)
end

local function RiftWebhook(Rift, Height, Luck, Expiry)
    local Description = {
        "<:user:1363986371634790564> Players: **`"..#Players:GetPlayers().."/12`**",
        "<:luck:1363970364547534858> Luck: **`x"..Luck.."`**",
        ":straight_ruler: Height: **`"..Height.."m`**",
        "<:clock:1363970135768956979> Despawns: **"..ToTimestamp(Expiry).."**",
        "<:gear:1363992535277506660> Server: **[Link](https://www.system-exodus.com/scripts/BGSI/Rifts/redirect.php?JobID="..game.JobId..")**",
        '```lua\ngame:GetService("TeleportService"):TeleportToPlaceInstance(85896571713843, "'..game.JobId..'")```'
    }

    local Image = Library("Eggs")[Rift] and Library("Eggs")[Rift].Image
    if Image then
        local URL = ("https://thumbnails.roblox.com/v1/assets?assetIds=%d&size=420x420&format=Png"):format(Image and Image:gsub("rbxassetid://", "") or "0")
        local Success, Response = pcall(function()
            return game:HttpGet(URL)
        end)
        if Success and Image then
            local Data = HttpService:JSONDecode(Response).data
            Image = Data[1].imageUrl
        end
    end
    if not Image then
        Image = "https://tr.rbxcdn.com/180DAY-04670804a6cf34686b89f00a182ba2cd/420/420/Image/Png/noFilter?format=webp&width=462&height=462"
    end
    local Message = {
        ["username"] = "System Exodus | Rift Notifier",
        ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
        ["content"] = "",
        ["jobId"] = game.JobId,
        ["embeds"] = {
            {
                ["color"] = 12035327,
                ["title"] = Rift.." Rift was found!",
                ["description"] = table.concat(Description, "\n"),
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ["footer"] = {
                    ["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
                    ["text"] = "@Jxnt - discord.gg/Jk28atjPas"
                },
                ["thumbnail"] = { 
                    ["url"] = Image,
                },
            },
        },
    }

    local Body = HttpService:JSONEncode(Message)
    local Timestamp = tostring(os.time())
    Message.timestamp = Timestamp

    local Token = "RIFT-" .. HttpService:GenerateGUID(false)
    local Encoded = rahh(Token, 7)


    local success, response = pcall(function()

    end)
end

local WebhookEggs = {"Underworld Egg", "Silly Egg", "Rainbow Egg", "Void Egg", "Nightmare Egg", "Cyber Egg"}
local WorkspaceRifts = workspace.Rendered.Rifts
local function RiftData(Rift)
    Rift:WaitForChild("Display", 3)
    local Name = EggTranslation[Rift.Name] or Rift.Name
    local Display = Rift:FindFirstChild("Display")
    local LuckLabel = Display and Display:FindFirstChild("SurfaceGui")
    and Display.SurfaceGui:FindFirstChild("Icon")
    and Display.SurfaceGui.Icon:FindFirstChild("Luck")
    local Expiry = Rift:GetAttribute("DespawnAt") and (Rift:GetAttribute("DespawnAt")-os.time()) or 10*60
    if LuckLabel then
        local Luck = tonumber(LuckLabel.Text:match("%d+%.?%d*") or "0") or 0
        if Name == "Silly Egg" or (table.find(WebhookEggs, Name) and Luck >= 25) then
            RiftWebhook(Name, math.round(Rift.Output.CFrame.Y), Luck, Expiry)
        end
    end
    if not LuckLabel and (Name == "royal-chest" or Name == "bubble-rift" or Name == "dice-rift") then
        RiftWebhook(Name == "royal-chest" and "Royal Chest" or Name == "bubble-rift" and "Bubble" or "Dice", math.round(Rift.Output.CFrame.Y), 1, Expiry)
    end
end
for _, Rift in pairs(WorkspaceRifts:GetChildren()) do
    RiftData(Rift)
end
WorkspaceRifts.ChildAdded:Connect(function(Rift)
    RiftData(Rift)
end)

local Top4Eggs = {}
for _, EggData in ipairs(Eggs) do
    table.insert(Top4Eggs, EggData.Name)
    if #Top4Eggs >= 4 then break end
end

local function FindRift(Custom)
    local FinalRifts = {}
    local SelectedEggs = {}

    if Custom then
        SelectedEggs = Custom
    elseif #Settings["Target Rifts"] > 0 then
        SelectedEggs = Settings["Target Rifts"]
    else
        SelectedEggs = Top4Eggs
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
        local Display = Rift:FindFirstChild("Display")
        local LuckLabel = Display and Display:FindFirstChild("SurfaceGui")
        and Display.SurfaceGui:FindFirstChild("Icon")
        and Display.SurfaceGui.Icon:FindFirstChild("Luck")
        if not LuckLabel then continue end
        local Luck = tonumber(LuckLabel.Text:match("%d+%.?%d*") or "0") or 0
        local Expiry = Display.SurfaceGui:FindFirstChild("Timer") and Display.SurfaceGui.Timer.Text
        if table.find(ActiveEggs, Name) and Luck >= (Settings["Minimum Rift Luck"] or 5)  then    
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
    
    FinalRifts = {}
    for _, Data in pairs(RiftByEgg) do
        table.insert(FinalRifts, Data)
    end

    if Settings["Target Highest Luck"] then
        table.sort(FinalRifts, function(a, b)
            if a.Name == "Silly Egg" then
                return true
            elseif b.Name == "Silly Egg" then
                return false
            else
                return a.Luck > b.Luck
            end
        end)
    else
        table.sort(FinalRifts, function(a, b)
            return table.find(EggNames, a.Name) < table.find(EggNames, b.Name)
        end)
    end

    if #FinalRifts > 0 then
        local BestRift = FinalRifts[1]
        if CanAffordEgg(BestRift.Name) >= 1 then
            if BestRift.Name == "Silly Egg" or BestRift.Luck >= 25 then
                CanUsePotions = true
            else
                CanUsePotions = false
            end
            local World = EggData[BestRift.Name].World or "The Overworld"
            if World ~= GetPlayerWorld() then
                repeat task.wait()
                    Fire("Teleport", "Workspace.Worlds."..World..".FastTravel.Spawn")
                    task.wait(1)
                until GetPlayerWorld() == World
            end

            UIText(UI.LastTask, "Teleporting & Hatching Rift: "..BestRift.Name.." ("..BestRift.Luck.."x)")
            local Position = BestRift.CFrame * CFrame.new(math.random(0, 3), 5, math.random(0, 3))
            local Rotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

            CurrentEgg.Name = BestRift.Name
            CurrentEgg.Position = Position.Position
            CurrentSource = "Rift"

            Teleport(Position * Rotation)
        else
            CurrentSource = nil
            CurrentEgg = {}
            ShouldFarm = true
        end
    else
        if CurrentSource ~= "Normal" then
            CurrentEgg = {}
            CurrentSource = nil
        end
    end
end

local function GetEquippedCurrency(Currency)
    local TotalCurrency = 0
    GetEquippedPets()
    for _, Data in pairs(Save.Pets) do
        if EquippedPets[Data.Id] then
            local Stats = Library("PetUtil"):GetStats(Data)
            for i = 1, (Data.Amount or 1) do
                TotalCurrency += (Stats and tonumber(Stats[Currency]) or 0)
            end
        end
    end
    return TotalCurrency
end

local OldEggOpen = 0
local function HatchEgg(Egg)
    if not Egg then return end
    local MaxHatches = Library("StatsUtil"):GetMaxEggHatches(Save)
    local CanAfford = CanAffordEgg(Egg)
    local Minimum = math.min(MaxHatches, CanAfford)
    if Minimum <= 0 then 
        return Minimum
    end

    local NextEggOpenAt = LocalPlayer:GetAttribute("NextEggOpenAt")
    if not NextEggOpenAt then
        NextEggOpenAt = OldEggOpen
    end
    OldEggOpen = NextEggOpenAt
    local TimeToWait = math.max(1, NextEggOpenAt - workspace:GetServerTimeNow())

    task.wait(TimeToWait)
    Fire("HatchEgg", Egg, math.max(1, Minimum))


    return Minimum
end


task.spawn(function()
    while task.wait(0.1) do
        if CurrentEgg.Position and (HumanoidRootPart.Position - CurrentEgg.Position).Magnitude <= 10 then
            CanHatch = HatchEgg(CurrentEgg.Name)
            if (CanHatch and CanHatch <= 0) then
                ShouldFarm = true
                IsHatching = false
            elseif (CanHatch and CanHatch >= 1) then
                IsHatching = true
            end
        end
    end
end)


local function SafeCall(Name, Fn)
    local Success, Error = xpcall(Fn, function(v) 
        return debug.traceback(v) 
    end)
    if not Success then
        warn(("[System Exodus] %s failed:\n%s"):format(Name, Error))
        WebhookError(Name, Error)
    end
end

--[[task.spawn(function()
    while task.wait() do
        SafeCall("DeletePets", DeletePets)
        SafeCall("ClaimMasteries", ClaimMasteries)
        SafeCall("ClaimPrizes", ClaimPrizes)
        SafeCall("ClaimIndexRewards", ClaimIndexRewards)
        SafeCall("ClaimSeasonRewards", ClaimSeasonRewards)
        SafeCall("OpenItems", OpenItems)
        SafeCall("ClaimPlaytimeRewards", ClaimPlaytimeRewards)
        SafeCall("CompleteMinigames", CompleteMinigames)
        SafeCall("FindBuffs", FindBuffs)
        SafeCall("FindPotions", FindPotions)
        SafeCall("PurchaseMerchants", PurchaseMerchants)
        SafeCall("CraftPotions", CraftPotions)
        SafeCall("EnchantEquippedPets", EnchantEquippedPets)
        SafeCall("StartGenieQuest", StartGenieQuest)
        task.wait(15)
    end
end)]]--

task.spawn(function()
    while task.wait(5) do
        for _,Dice in pairs({"Dice", "Giant Dice"}) do
            if Save.Powerups[Dice] and Save.Powerups[Dice] >= 1 then
                for i = 1, Save.Powerups[Dice] do
                    Fire("RollDice", Dice)
                    task.wait(1)
                    Fire("ClaimTile")
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
            DeletePets()
            ClaimMasteries()
            ClaimPrizes()
            ClaimIndexRewards()
            ClaimSeasonRewards()
            OpenItems()
            ClaimPlaytimeRewards()
            CompleteMinigames()
            FindBuffs()
            FindPotions()
            PurchaseMerchants()
            CraftPotions()
            EnchantEquippedPets()
            StartGenieQuest()
        task.wait(15)
    end
end)

local function FarmForMastery()
    local Position = CFrame.new(math.random(0, 10), 15977, math.random(7,30))
    local Rotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
    IsFarming = true
    repeat task.wait()
        Fire("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn")
        task.wait(1)
    until GetPlayerWorld() == "The Overworld"
    repeat task.wait(5) 
        IsFarming = true
        UIText(UI.LastTask, "Farming Coins / Gems til Mastery Level: "..MinimumBuffLevel)
        Teleport(Position * Rotation)
        if GetEquippedPets() < Library("StatsUtil"):GetMaxPetsEquipped(Save) then
            IsFarming = false
            repeat task.wait(1)
                if CanAffordEgg("Rainbow Egg") < 1 then
                    IsFarming = true
                    repeat task.wait(5)
                        UIText(UI.LastTask, "Farming Coins / Gems til Can Afford Rainbow Egg")
                        Fire("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn")
                    until CanAffordEgg("Rainbow Egg") >= 5
                    IsFarming = false
                end

                FindRift({"Rainbow Egg"})
                FindEgg("Rainbow Egg")
            until HatchedEggs["Rainbow Egg"] and HatchedEggs["Rainbow Egg"] >= 5
        end
    until (Save.MasteryLevels["Buffs"] or 0) >= MinimumBuffLevel
end

local function FarmStarterAccount()
    Debug.SellBubbles = true
    Fire("FreeNotifyLegendary")
    task.wait(1)
    EquipBestPets()
    for _,Egg in pairs({"Common Egg", "Void Egg", "Hell Egg", "Rainbow Egg"}) do
        if Egg == "Hell Egg" then
            Debug.SellBubbles = false
        end
        repeat task.wait(1)
            if CanAffordEgg(Egg) < 1 then
                IsFarming = true
                repeat task.wait(5)
                    UIText(UI.LastTask, "Farming Coins / Gems til Can Afford "..Egg)
                    Fire("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn")
                until CanAffordEgg(Egg) >= 5
                IsFarming = false
            end

            FindRift({Egg})
            FindEgg(Egg)
        until HatchedEggs[Egg] and ((table.find({"Common Egg", "Void Egg", "Rainbow Egg"}, Egg) and HatchedEggs[Egg] >= 5) or (Egg == "Hell Egg" and GetEquippedCurrency("Gems") >= (Library("StatsUtil"):GetMaxPetsEquipped(Save)*6)))
    end
    --or (Egg == "Rainbow Egg" and GetEquippedCurrency("Gems") >= (Library("StatsUtil"):GetMaxPetsEquipped(Save)*8))
    if (Save.MasteryLevels["Buffs"] or 0) < MinimumBuffLevel then
        FarmForMastery()
    end
end

local function HatchNewWorldEgg()
    local CurrentWorld = GetPlayerWorld()
    for _, Egg in pairs(Eggs) do
        if Egg.World == CurrentWorld then
            EggName = Egg.Name
        end
    end
    if CanAffordEgg(EggName) < 1 then
        IsFarming = true
        repeat task.wait(5)
            Fire("Teleport", "Workspace.Worlds."..BestWorld..".Islands."..BestIsland..".Island.Portal.Spawn")
        until CanAffordEgg(EggName) >= 5
        IsFarming = false
    end
    repeat task.wait()
        CurrentWorld = GetPlayerWorld()
        FindRift({EggName})
        FindEgg(EggName)
        EquipBestPets()
    until (HatchedEggs[EggName] and HatchedEggs[EggName] >= 5) or GetEquippedCurrency(WorldsData[CurrentWorld].Currency) >= 1
end

task.spawn(function()
    while task.wait(0.45) do
        UIText(UI.SessionTime, "Session Time: "..ConvertSeconds(os.time()-StartTime))
        UIText(UI.Info, "Coins: "..AddSuffix(Save.Coins or 0).." | Gems: "..AddSuffix(Save.Gems or 0))

        local BubbleStorage = Library("StatsUtil"):GetBubbleStorage(Save) or 0
        local BubblePower = Library("StatsUtil"):GetBubblePower(Save) or 0
        local CurrentBubbles = Save.Bubble.Amount or 0
        if CurrentBubbles < BubbleStorage then
            Fire("BlowBubble")
        end
        if Debug.SellBubbles and not IsTeleporting and CurrentSource ~= "Rift" and ((Save.Passes["Infinity Gum"] and CurrentBubbles >= 10000000) or CurrentBubbles >= BubbleStorage or (CurrentBubbles + BubblePower) > BubbleStorage) then
            IsTeleporting = true
            Fire("Teleport", "Workspace.Worlds.The Overworld.Islands.Twilight.Island.Sell.Root")
            task.wait(0.5)
            Fire("SellBubble")
            task.wait(0.5)
            IsTeleporting = false
        end
    end
end)

local TotalGems = GetEquippedCurrency("Gems")
if (TotalGems or 0) < (Library("StatsUtil"):GetMaxPetsEquipped(Save)*6) and Save.TeamEquipped == 1 then
    UIText(UI.LastTask, "Activating New Account Farming")
    FarmStarterAccount()
end
if (Save.MasteryLevels["Buffs"] or 0) < MinimumBuffLevel then
    FarmForMastery()
end

local DefaultEgg = Debug.CompetitiveDefaultEgg or "Infinity Egg"
local function GetHatchQuest()
    local ReturnEgg = DefaultEgg
    local DoesAppear = false
    for _,Data in pairs(Save.Quests) do
        if Data.Id and Data.Id:find("competitive") and Data.Tasks and Data.Tasks[1] and Data.Tasks[1].Type then
            local Task = Data.Tasks[1]
            local Quest = Task.Type
            if Quest ~= "Hatch" then continue end
            if Task.Egg and ReturnEgg == DefaultEgg then
                ReturnEgg = Task.Egg
            end
            if Task.Mythic then
                DoesAppear = true
            end
        end
    end
    if DoesAppear and ReturnEgg == DefaultEgg then
        ReturnEgg = "Spikey Egg"
    end
    return ReturnEgg
end

local AlreadyDone = false
task.spawn(function()
    while task.wait() do
        local CurrentWorld = GetPlayerWorld()
        if GetEquippedCurrency(WorldsData[CurrentWorld].Currency) <= 0 and not AlreadyDone then
            HatchNewWorldEgg()
            AlreadyDone = true
        end

        UnlockIslands()
        if not Debug.FarmCompetitiveQuests then
            FindRift()
            if not CurrentEgg.Name then
                FindChests()
                ClaimChest()
            end

            FindEgg()
        else
            local QuestEgg = GetHatchQuest()
            FindRift({QuestEgg})
            FindEgg(QuestEgg)
            warn(QuestEgg)
        end

        if ShouldFarm then
            IsFarming = true
            local MinimumTime = Debug.MinFarmTime and tonumber(Debug.MinFarmTime) or 15
            CurrentEgg = {}
            local Timer = os.time()
            repeat task.wait(5)
                UIText(UI.LastTask, "Farming Currency for "..MinimumTime.." minutes")
                Fire("Teleport", "Workspace.Worlds."..BestWorld..".Islands."..BestIsland..".Island.Portal.Spawn")
                EquipBestPets()
            until (os.time() - Timer) >= (MinimumTime*60) or CurrentWorld ~= GetPlayerWorld()
            ShouldFarm = false
            IsFarming = false
        end
        task.wait(5)
    end
end)
