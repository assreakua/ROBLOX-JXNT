repeat task.wait() until game:IsLoaded()
game.Players.LocalPlayer:WaitForChild("PlayerGui")
game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("HUD")
game.Players.LocalPlayer.PlayerGui.ScreenGui.HUD:WaitForChild("Debug")
game.Players.LocalPlayer.PlayerGui.ScreenGui.HUD.Debug:WaitForChild("Debug14")

if game.PlaceId ~= 9551640993 then
    return
end

if UI then 
    Env.UI = game.Destroy(UI)
end



local HttpGet = game.HttpGet
local ReplicatedStorage = game.ReplicatedStorage
local TweenService = game.TweenService
local RunService = game.RunService
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character.HumanoidRootPart
local ModuleLoader = require(ReplicatedStorage.LoadModule)
local Request = request or syn and syn.request or http and http.request or http_request or httprequest
local Fenv = getfenv()



local htgetf do
    function htgetf(Link)
        return HttpGet(game, Link)
    end
end

local yolo, Notify, Emojis, Version do
    yolo = loadstring(htgetf("https://scripts.system-exodus.com/assets/libraries/YolosLib.lua"))() 
    Notify = loadstring(htgetf("https://scripts.system-exodus.com/assets/modules/HotNotify.lua"))()
    Version = loadstring(htgetf("https://scripts.system-exodus.com/assets/VersionChecker.lua"))("Mining Simulator 2"):Get()
end



local function sendNotification(T, D, I, L)
    Notify:message{Title = T, Description = D, Icon = I, Length = L}
end

local Modules do
    Modules = {"OpenEgg", "OpenCrate", "Blocks", "Eggs", "Crates", "ChunkUtil", "ToolCanMineBlock", "LocalData", "GetGearData", "Network", "GetRebirthCost", "GetCurrencyMultiplier", "GetLuckMultiplier", "GetSellTeleport", "GetLayer", "GetWorld", "GetBackpackStatus", "GetHatchSpeed"}
    for _,v in next, Modules do
        getgenv()[v] = ModuleLoader(v)
    end                               
end

local BlockData = {}
for i,v in next, Blocks do 
    BlockData[i] = v.Value
end

local TweenTime;
local PlayerData = LocalData:GetData()
local RebirthsSession = 0
local RebirthTimer = os.time()
local MineOresTimer = tick()
local worldToCell = ChunkUtil.worldToCell
local cellToWorld = ChunkUtil.cellToWorld
local function tp(x, y, z)
    Tween = game.TweenService:Create(HumanoidRootPart, TweenInfo.new(TweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(x, y, z)})
    Tween:Play()
    Tween.Completed:Wait()
end

local function TweenTeleport(Position, GoUnder)    
    if Tween and Tween.Cancel then
        Tween:Cancel()
        Tween = nil
    end
    
    Distance = (Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z) - Vector3.new(Position.X, 0, Position.Z)).magnitude
    TweenTime = Distance / (Humanoid.WalkSpeed)
    if GoUnder then
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, Position.Y-150, HumanoidRootPart.Position.Z)
    else
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, Position.Y, HumanoidRootPart.Position.Z)
    end
    task.wait()

    getgenv().Tween = game.TweenService:Create(HumanoidRootPart, TweenInfo.new(TweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position.X, HumanoidRootPart.CFrame.Y, Position.Z)})
    Tween:Play()
    Tween.Completed:Wait()
end

local function GetOre(Ore)
    local GatheredOres = {}
    for _,v in next, game.Workspace.Chunks:GetChildren() do
        if v:FindFirstChild(Ore) then
            table.insert(GatheredOres, v[Ore])
        end
    end
    table.sort(GatheredOres, function(i, v)
        return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
    end)
    return GatheredOres[1]
end

local function GetHouse()
    local GatheredHouses = {}
    for _,v in next, workspace.Worlds["Halloween World"].Decorations.Houses:GetChildren() do
        if v.Activation.Active.Value then
            table.insert(GatheredHouses, v.Activation.Root)
        end
    end
    table.sort(GatheredHouses, function(i, v)
        return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
    end)
    return GatheredHouses[1]
end


function GetChest(Chest)
    local GatheredChests = {}
    for _,v in next, workspace.Chests:GetChildren() do
        if v.Name == Chest and v:FindFirstChild("Part") and v.Part.Position then
            table.insert(GatheredChests, v)
        end
    end
    return GatheredChests[1]
end

local function LoadOres()
    Distance = (HumanoidRootPart.Position - Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y-9000, HumanoidRootPart.Position.Z)).magnitude
    TweenTime = Distance / 200
    tp(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y-9000, HumanoidRootPart.Position.Z)
end

local function GetBackpackValue()
    local Values, Multipliers = {}, {}
    for _,v in next, PlayerData.BackpackInventory do
        local BlockName, BlockAmount = unpack(v)
        local BlockCurrency, BlockValue = unpack(BlockData[BlockName])
        if not Multipliers[BlockCurrency] then
            Multipliers[BlockCurrency] = GetCurrencyMultiplier(LocalPlayer, BlockCurrency)
        end
        BlockValue = BlockValue * Multipliers[BlockCurrency] * BlockAmount
        Values[BlockCurrency] = Values[BlockCurrency] and Values[BlockCurrency] + BlockValue or BlockValue
    end
    return Values
end

local function MineBlock(Part, Cell)
    local Cell = Cell or ChunkUtil.worldToCell(Part.Position)
    local ToolPower = GetGearData("Tool", PlayerData.Tool, PlayerData, true).Power
    local BlockHealth = Part:GetAttribute("Health")

    if ToolPower >= BlockHealth then
        Network:FireServer("MineBlock", Cell)
    else
        while task.wait() and Part.Parent and BlockHealth > 0 do
            Network:FireServer("MineBlock", Cell)
            BlockHealth = Part:GetAttribute("Health")
        end
    end
end

local function AddEmoji(Text, Emoji, Spaces)
    local Add = Spaces and "     → " or ""
    return Add..Version.Emojis[Emoji].." "..Text
end

local Chunks = workspace.Chunks
local GetNearbyBlocks, GetPartAtCell do
    local OverlapParams = OverlapParams.new()
    OverlapParams.FilterDescendantsInstances = {Chunks}
    OverlapParams.FilterType = Enum.RaycastFilterType.Whitelist
    OverlapParams.MaxParts = 1
    local GetPartBoundsInBox = workspace.GetPartBoundsInBox
    local Size = Vector3.new(4, 10, 4)
    function GetNearbyBlocks()
        return GetPartBoundsInBox(HumanoidRootPart.CFrame, Size, OverlapParams)
    end
    function GetPartAtCell(Cell)
        return GetPartBoundsInBox(workspace, CFrame.new(cellToWorld(Cell)), Vector3.one, OverlapParams)[1]
    end
end

local Sell do
    function Sell(TeleportBack)
        for i in next, PlayerData.LockedInventory do
            Network:FireServer("LockOre", i)
        end
        local OldCFrame = HumanoidRootPart.CFrame
        Network:FireServer("Teleport", GetSellTeleport(LocalPlayer))
        repeat task.wait() until #PlayerData.BackpackInventory <= 0
        if TeleportBack then
            task.wait(0.35)
            TweenTeleport(OldCFrame)
        end
        task.wait(0.35)
    end
end

local Repeat do
    function Repeat(LastPosition) 
        TweenTeleport(LastPosition)
        task.wait(0.5)
        if (HumanoidRootPart.Position - LastPosition).magnitude > 5 then
            Repeat(LastPosition)
        end
    end
end

local Rebirth do
    function Rebirth(LastLocation)
        local RebirthCost = GetRebirthCost(PlayerData.Rebirths, PlayerData.GemEnchantments)
        local BackpackValue = GetBackpackValue().Coins or 0
        local Rebirths = PlayerData.Rebirths
        if BackpackValue + PlayerData.Coins >= RebirthCost then
            for i in next, PlayerData.LockedInventory do
                Network:FireServer("LockOre", i)
            end
            if PlayerData.Coins < RebirthCost then
                Network:FireServer("Teleport", GetSellTeleport(LocalPlayer))
                repeat task.wait() until PlayerData.Coins >= RebirthCost
            end
            Network:FireServer("Rebirth")
            repeat task.wait() until PlayerData.Rebirths > Rebirths
            RebirthTimer = os.time()
            RebirthsSession = RebirthsSession + 1
            if LastLocation then
                Repeat(LastLocation)
            end
        end
    end
end

local Suffixes = {"K", "M", "B", "T", "QDT"}
local function SuffixBeGONE(Amount)
	local a, Suffix = string.match(Amount, "(.*)(%a)$")
	local b = table.find(Suffixes, Suffix) or 0
	return tonumber(a) * math.pow(10, b * 3)
end

local function SuffixBeADDED(Amount)
	local a = math.floor(math.log(Amount, 1e3))
	local b = math.pow(10, a * 3)
	return ("%.1f"):format(Amount / b):gsub("%.?0+$", "") .. (Suffixes[a] or "")
end

local function CommasBeADDED(Amount)
    local SuffixAdd = Amount
    while task.wait() do  
        SuffixAdd, b = string.gsub(SuffixAdd, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (b == 0) then
            break
        end
    end
    return SuffixAdd
end

function gcd(a, b)
	if b ~= 0 then
		return gcd(b, a % b)
	else
		return math.abs(a)
	end
end

local PetDatabase = require(ReplicatedStorage.SharedModules.Data.Pets)
local Ores = {"(Select/None)"}
local ChestTypes = {"(Select/None)"}
local CrateTypes = {"(Select/None)"}
local EggTypes = {"(Select/None)"}
local Layers = {"(Select/None)"}
local FactoryRecipes = {"(Select/None)"}
local EggValueCurrency = {}
local OreSorter = {}
for i,v in next, Blocks do
    if v.Type:find("Ore") or v.Type:find("Gemstone") then
        OreSorter[#OreSorter + 1] = v
    end
end
sort(OreSorter, function(i, v)
    return i.Value[2] < v.Value[2]
end)
for _,v in next, OreSorter do
    Ores[#Ores + 1] = v.Name
end
for i in next, require(ReplicatedStorage.SharedModules.Data.Treasures).Data do
    ChestTypes[#ChestTypes + 1] = i    
end
for i,v in next, Eggs do
    local Cost = v.Cost[1]
    if Cost ~= 'Robux' then
        EggValueCurrency[i] = Cost
        EggTypes[#EggTypes + 1] = i
    end
end
for i in next, Crates do
    CrateTypes[#CrateTypes + 1] = i
end
for _,v in next, workspace.Checkpoints:GetChildren() do
    if v:FindFirstChild("Root") then
        table.insert(Layers, v.Name)
    end
end
for i,v in next, require(ReplicatedStorage.SharedModules.Data.FactoryRecipes) do
    table.insert(FactoryRecipes, i.." (".. v.Duration/60 .."m)")
end
table.sort(FactoryRecipes, function(i, v)
    return i < v
end)


if not isfolder("MiningSimulator2") then
    makefolder("MiningSimulator2")
end
if not isfolder("MiningSimulator2/SaveFiles") then
    makefolder("MiningSimulator2/SaveFiles")
end



local DefaultSettings = {}
DefaultSettings.Keybinds = {
    ToggleKey = "RightShift"
}

DefaultSettings.Mining = {
    Mine3x3 = false, 
    MineSelected = false, 
    RebirthFarm = false, 
    AutoRebirth = false, 
    AutoSell = false,
    CollectChests = false
}

DefaultSettings.Webhook = {
    SendPetHatches = false,
    SendMiscStats = false,
    RatioChance = false,
    Legendary = false,
    Rare = false,
    Epic = false,
    URL = "",
}

DefaultSettings.Misc = {
    AutoEquipBestPets = false,
    AutoBuyBackpacks = false,
    AutoBuyPickaxes = false,
    
    AutoClaimGroup = false,
    
    UseFactory = false,
    ClaimGems = false,
    SelectedRecipe = "(Select/None)",
    
    AutoFish = false,
    SelectedFishSpot = "(Select/None)",
    
    AutoGuessPets = false
} 

DefaultSettings.Open = {
    SelectedCrate = "(Select/None)",
    SelectedEgg = "(Select/None)",
    CrateCooldown = 0.01,
    TripleHatch = false,
    Eggs = false
}

DefaultSettings.Other = {
    Noclip = false,
    Version = 0
}

DefaultSettings.OreDropdown = {}
DefaultSettings.ChestDropdown = {}
DefaultSettings.RarityDropdown = {}


--// Save File
local SaveFile = "MiningSimulator2/SaveFiles/"..LocalPlayer.Name.." - Settings.cfg"
local JSONEncode, JSONDecode do 
    local JSONEncodef = HttpService.JSONEncode
    local JSONDecodef = HttpService.JSONDecode
    JSONEncode = (function(t)
        return JSONEncodef(HttpService, t)
    end)
    JSONDecode = (function(t)
        return JSONDecodef(HttpService, t)
    end)
end

if not pcall(readfile, SaveFile) then 
    writefile(SaveFile, JSONEncode(DefaultSettings))
end

local function Clone(t) 
    local Copy = {} 
    for _,v in next, t do 
        if type(v) == "table" then 
            v = Clone(v) 
        end 
        Copy[i] = v 
    end
    return Copy 
end 

local Settings = HttpService:JSONDecode(readfile(SaveFile))
local function Save()
    writefile(SaveFile, JSONEncode(Settings))
end

do 
    local function Merge(old, new) 
        for i,v in next, new do 
            if type(old[i]) ~= type(v) then 
                old[i] = v
            end
        end
    end 
    Merge(Settings, DefaultSettings)
    Save()
    for i,v in next, Settings do 
        if type(v) == "table" then 
            Fenv[i] = v 
        end 
    end
end

if Settings.Other.Version ~= Version.Version then
    sendNotification("Mining Simulator 2", "Your Settings have been reset due to a UI Update!")
    writefile(SaveFile, game.HttpService:JSONEncode(DefaultSettings))
    Settings = game.HttpService:JSONDecode(readfile(SaveFile))
    Settings.Other.Version = Version.Version
    Save()
end

--[[if (math.floor(os.difftime(os.time(), os.time{day = Version.Timebomb.Day, year = 2022, month = Version.Timebomb.Month}) / (24 * 60 * 60)) >= 0) then
    return game.Players.LocalPlayer:Kick("MS2 UI: You are using an outdated version! (please execute our loadstring) discord.gg/SystemExodus")
end]]--






--// UI
local UI = yolo.library.new("Mining Simulator 2 | System Exodus", UDim2.new(0, 740, 0, 370), nil, function(Data) 
    Data.tip.Text = ("<font color=\"rgb(255,255,255)\">Mining Simulator 2 | System Exodus </font>")
end)

local Home = UI:Category("Home") 
local Farming = UI:Category("Farming")
local Misc = UI:Category("Miscellaneous") 
local Stats = UI:Category("Statistics") 
local SettingsTab = UI:Category("Settings") 

local MiningSimulator2 = Home:Sector("Mining Simulator 2")  
MiningSimulator2:Cheat("Label", "- Scripted by: Jxnt#9946 & xxxYoloxxx999#2166") 
MiningSimulator2:Cheat("Label", "- Special Thanks to: VIPER#0001") 
MiningSimulator2:Cheat("Label", "- UI by: deto#1153 & xxxYoloxxx999#2166")
MiningSimulator2:Cheat("Label", "- To minimize the script, press "..Settings.Keybinds.ToggleKey)
MiningSimulator2:Cheat("Button", "- Discord Invite:", function()
    sendNotification("Mining Simulator 2", "Invite link was copied to your keyboard!", 6035056475)
    UI.Features["- Discord Invite:"].button.Text = "Copied / Joined"
	setclipboard("https://discord.gg/SystemExodus")
    for i = 6453, 6464 do
        spawn(function()
            request({Url = "http://127.0.0.1:"..tostring(i).."/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"}, Body = game:GetService("HttpService"):JSONEncode({["cmd"] = "INVITE_BROWSER", ["nonce"] = game:GetService("HttpService"):GenerateGUID(false), ["args"] = {["invite"] = {["code"] = tostring("SystemExodus"), }, ["code"] = tostring("SystemExodus")}})})
        end)
    end
    task.wait(1)
    UI.Features["- Discord Invite:"].button.Text = "Copy / Join"
end, {text = "Copy / Join"})
MiningSimulator2:Cheat("Label", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThanks for using our script!")
UI.ChangeToggleKey(Enum.KeyCode[Settings.Keybinds.ToggleKey])

do
    local Updates = Home:Sector("UI Update ("..Version.Date..")")  
    for _,v in next, Version.Changelog do
        Updates:Cheat("Label", v) 
    end
end

--// Farming Sectors
local Mining = Farming:Sector("Mining")
local Eggs = Farming:Sector("Eggs")
Farming:Sector("")
local Chests = Farming:Sector("Chests")

--// Misc Sectors
local Summer = Misc:Sector("Summer")
local Webhooks = Misc:Sector("Webhooks")
local Crates = Misc:Sector("Crates")
local OtherMisc = Misc:Sector("Other")
local Factory = Misc:Sector("Gem Factory")
Misc:Sector("")
local AutoDelete = Misc:Sector("Auto Delete")

--// Stats Sectors
local MiningStats = Stats:Sector("Mining")
local InventoryStats = Stats:Sector("Inventory")

--// Settings Sectors
local Keybinds = SettingsTab:Sector("Keybinds")

local MiningSettings = Settings.Mining
local OpenSettings = Settings.Open
local WebhookSettings = Settings.Webhook
local MiscSettings = Settings.Misc

for _ = 1,5 do
    Misc:Sector("")
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

MiningStats:Cheat("Label", "Mining Status: N/A")
MiningStats:Cheat("Label", "Collapse Status: N/A")
MiningStats:Cheat("Label", "Coins Per Minute: N/A")
MiningStats:Cheat("Label", "Rebirths Per Minute: N/A")
MiningStats:Cheat("Label", "Rebirths This Session: N/A")
MiningStats:Cheat("Label", "Last Rebirth: N/A")
InventoryStats:Cheat("Label", "Rebirth Status: ")
InventoryStats:Cheat("Label", "Backpack Worth: ")
local Stats = game.CoreGui.nfkflburxaNwLHvJ4rwm.Container.Categories.Statistics
local MiningStatus = Stats.L.Mining.Container["Mining Status: N/A"].Title
local CoinsPerMinute = Stats.L.Mining.Container["Coins Per Minute: N/A"].Title
local RebirthsPerMinute = Stats.L.Mining.Container["Rebirths Per Minute: N/A"].Title
local RebirthsThisSession = Stats.L.Mining.Container["Rebirths This Session: N/A"].Title
local CollapseBlocks = Stats.L.Mining.Container["Collapse Status: N/A"].Title
local LastRebirth = Stats.L.Mining.Container["Last Rebirth: N/A"].Title
local RebirthStatus = Stats.R.Inventory.Container["Rebirth Status: "].Title
local BackpackWorthLabel = Stats.R.Inventory.Container["Backpack Worth: "].Title

for _,v in next, {"1st", "2nd", "3rd"} do 
    local ID = tonumber(v:split("")[1])
    Mining["Ore Dropdown"..v:split("")[1]] = Mining:Cheat("Dropdown", v.." Ore", function(SelectedOre)
        if SelectedOre == "(Select/None)" then 
            Settings.OreDropdown[ID] = nil 
        else
            Settings.OreDropdown[ID] = SelectedOre:gsub(" ", ""):lower()
        end
        Save()
    end, {default = Settings.OreDropdown[ID], options = Ores})
end

Mining.MineSelected = Mining:Cheat("Checkbox", AddEmoji("Auto Mine (Selected Ores^)", "Pickaxe"), function(State)
     MiningSettings.MineSelected = State
     Settings.Other.Noclip = State
     MiningStatus.Text = "N/A"
     Save()
     if State then
         task.spawn(function()
             while MiningSettings.MineSelected and task.wait() do
                 
                 if MiningSettings.AutoSell and GetBackpackStatus().Full then
                     MiningStatus.Text = "Mining Status: Selling Ores."
                     Sell()
                 end
                 if MiningSettings.AutoRebirth then
                     MiningStatus.Text = "Mining Status: Rebirthing."
                     Rebirth()
                 end

                 if workspace.Terrain:FindFirstChild("Collapsed") then
                     repeat task.wait() until not workspace.Terrain:FindFirstChild("Collapsed")
                     task.wait(0.5)
                 end

                 for _,v in next, Settings.OreDropdown do
                     if v ~= nil then
                         local Ore = GetOre(v)
                         if not Ore then
                             LoadOres()
                         else
                             if GetWorld.fromPlayer(LocalPlayer) ~= GetWorld.fromWorldPos(Ore.Position) then
                                 game.ReplicatedStorage.Events.Teleport:FireServer(GetWorld.fromWorldPos(Ore.Position))
                                 task.wait(1)
                             end
                             MiningStatus.Text = "Mining Status: Teleporting to "..Ore.Name:gsub("^%l", string.upper).."."
                             TweenTeleport(Ore.Position)
                             MiningStatus.Text = "Mining Status: Mining "..Ore.Name:gsub("^%l", string.upper).."."
                             MineOresTimer = tick()
                             repeat task.wait()
                                 MineBlock(Ore)
                                 task.wait(0.1)
                             until not Ore.Parent or tick()-MineOresTimer > 5
                         end
                     end
                 end
             end

         end)
     end
end, {enabled = MiningSettings.MineSelected})

local Directions = {Vector3.zero, Vector3.new(-1, 0, 0), Vector3.xAxis, Vector3.new(0, 0, -1), Vector3.zAxis, Vector3.new(-1, 0, -1), Vector3.new(1, 0, 1), Vector3.new(-1, 0, 1), Vector3.new(1, 0, -1)}
Mining.Mine3x3 = Mining:Cheat("Checkbox", AddEmoji("Auto Mine (3x3 Area)", "Pickaxe"), function(State)
    MiningSettings.Mine3x3 = State
    MiningStatus.Text = "N/A"
    Save()
    if State then
        task.spawn(function()
            local LastPosition = HumanoidRootPart.Position
            local Layer = GetLayer.fromWorldPos(LastPosition)
            while MiningSettings.Mine3x3 and task.wait() do
                
                if MiningSettings.AutoSell and GetBackpackStatus().Full then
                    MiningStatus.Text = "Mining Status: Selling Ores."
                    Settings.Other.Noclip = true
                    Sell(true)
                    Settings.Other.Noclip = false
                end

                local Cell = worldToCell(HumanoidRootPart.Position) + Vector3.yAxis
                if workspace.Terrain:FindFirstChild("Collapsed") then
                    repeat task.wait() until not workspace.Terrain:FindFirstChild("Collapsed")
                    if MiningSettings.Mine3x3 then
                        if Layer ~= "Surface" then
                            local CheckpointPos = workspace.Checkpoints[Layer].Root.Position
                            Network:FireServer("Teleport", Layer)
                            task.wait(1)
                            TweenTeleport(Vector3.new(CheckpointPos.X, CheckpointPos.Y+5, CheckpointPos.Z))
                        else
                            TweenTeleport(Vector3.new(0, 3, 0))
                        end
                    else
                        return
                    end
                    task.wait(0.5)
                end

                if Cell then
                    LastPosition = HumanoidRootPart.Position
                    Layer = GetLayer.fromWorldPos(LastPosition)
                    timertick = tick()
                    for _,v in next, Directions do
                        local NextCell = Cell + v
                        local Part = GetPartAtCell(NextCell)
                        if Part and ToolCanMineBlock(PlayerData.Tool, Part.Name, PlayerData.Rebirths) and not GetBackpackStatus().Full then
                            MiningStatus.Text = "Mining Status: Mining "..Part.Name:gsub("^%l", string.upper).."."
                            MineBlock(Part, NextCell)
                            MineOresTimer = tick()
                            repeat task.wait() until not GetPartAtCell(NextCell) or tick()-MineOresTimer > 1
                        end
                        if MiningSettings.AutoRebirth then
                            MiningStatus.Text = "Mining Status: Rebirthing."
                            Settings.Other.Noclip = true
                            Rebirth(LastPosition)
                            Settings.Other.Noclip = false
                        end
                    end
                end

            end
        end)
    end
end, {enabled = MiningSettings.Mine3x3})

Mining.SellWhenFull = Mining:Cheat("Checkbox", AddEmoji("Auto Sell When Full", "Cash"), function(State)
    MiningSettings.AutoSell = State
    Save()
end, {enabled = MiningSettings.AutoSell})

Mining.AutoRebirth = Mining:Cheat("Checkbox", AddEmoji("Auto Rebirth", "Sparkle"), function(State)
    MiningSettings.AutoRebirth = State
    Save()
end, {enabled = MiningSettings.AutoRebirth})
Mining:Cheat("Label", "")

Mining.RebirthFarming = Mining:Cheat("Checkbox", AddEmoji("Advanced AI 7G Rebirth Farming", "Pickaxe"), function(State)
    if State then 
        Mining.RebirthFarming:toggleState(false)
        sendNotification("Mining Simulator 2", "Currently disabled (Caves were removed temporarily).")
    else
        MiningSettings.RebirthFarm = State
        Settings.Other.Noclip = State
        MiningStatus.Text = "N/A"
        Save()
        if State then
            
            if MiningSettings.AutoRebirth then 
                Mining.AutoRebirth:toggleState(false)
            end
            if MiningSettings.AutoSell then
                Mining.SellWhenFull:toggleState(false)
            end
            if MiningSettings.Mine3x3 then
                Mining.Mine3x3:toggleState(false)
            end
            if MiningSettings.MineSelected then
                Mining.MineSelected:toggleState(false)
                task.wait(1.5)
            end

            task.spawn(function()
                Network:FireServer("Teleport", "Crystal CavernSell")
                task.wait(0.5)
                if not workspace.Terrain:FindFirstChild("Collapsed") then 
                    MiningStatus.Text = "Mining Status: Loading Ores."
                    LoadOres()
                end
                while MiningSettings.RebirthFarm and task.wait() do

                    if workspace.Terrain:FindFirstChild("Collapsed") then
                        Network:FireServer("Teleport", "Crystal CavernSell")
                        repeat task.wait() until not workspace.Terrain:FindFirstChild("Collapsed")
                        Network:FireServer("Teleport", "Crystal CavernSell")
                        task.wait(0.5)
                    end

                    MiningStatus.Text = "Mining Status: Rebirthing."
                    Rebirth()
                    
                    local Ore = GetOre("larimar")
                    if not Ore then
                        MiningStatus.Text = "Mining Status: Loading Ores."
                        LoadOres()
                    else
                        MiningStatus.Text = "Mining Status: Teleporting to "..Ore.Name:gsub("^%l", string.upper).."."
                        TweenTeleport(Ore.Position)
                        MiningStatus.Text = "Mining Status: Mining "..Ore.Name:gsub("^%l", string.upper).."."
                        MineBlock(Ore)
                        MineOresTimer = tick()
                        repeat task.wait() until not Ore.Parent or tick()-MineOresTimer > 0.1
                    end

                end
            end)
        end
    end
end, {enabled = MiningSettings.RebirthFarm})
Mining:Cheat("Label", "     → Will NOT Auto-Buy Pickaxes/Backpacks.")



Eggs:Cheat("Dropdown", "Egg Types", function(Value)  
    OpenSettings.SelectedEgg = Value
    Save()
end, {options = EggTypes, default = OpenSettings.SelectedEgg})

Eggs:Cheat("Checkbox", AddEmoji("Open Eggs", "HatchedEgg"), function(State) 
    OpenSettings.OpenEggs = State
    Save()
    spawn(function()
        local HatchSpeed = GetHatchSpeed(PlayerData.Passes, PlayerData.GemEnchantments)
        while OpenSettings.OpenEggs and task.wait(HatchSpeed) do
            Network:FireServer("OpenEgg", OpenSettings.SelectedEgg, OpenSettings.TripleHatch, true)
        end
    end)
end, {enabled = OpenSettings.OpenEggs})

Eggs.TripleHatch = Eggs:Cheat("Checkbox", AddEmoji("Triple Hatch", "Sparkle", true), function(State) 
    local TripleHatch = PlayerData.Passes["Triple Hatch"] 
    if State and not TripleHatch then
        OpenSettings.TripleHatch = false 
        Eggs.TripleHatch:toggleState(false)
        sendNotification("Mining Simulator 2", "You don't own `Triple Hatch` Gamepass.")
    else
        OpenSettings.TripleHatch = State
        Save()
    end
end, {enabled = OpenSettings.TripleHatch})

Eggs:Cheat("Checkbox", AddEmoji("Teleport To Egg", "Sparkle", true), function(State) 
    OpenSettings.TeleportToEgg = State
    Save()
    spawn(function()
        while OpenSettings.TeleportToEgg and task.wait(0.5) do
            local EggPos = workspace.Eggs[OpenSettings.SelectedEgg].Price.Position
            if GetWorld.fromPlayer(LocalPlayer) ~= GetWorld.fromWorldPos(EggPos) then
                game.ReplicatedStorage.Events.Teleport:FireServer(GetWorld.fromWorldPos(EggPos))
                task.wait(1)
            end
            if (HumanoidRootPart.Position - EggPos).Magnitude > 15 then
                Settings.Other.Noclip = true
                TweenTeleport(EggPos)
                Settings.Other.Noclip = false
            end
        end
    end)
end, {enabled = OpenSettings.TeleportToEgg})

Eggs:Cheat("Button", AddEmoji("No Animation", "Sparkle", true), function()
    LPH_NO_VIRTUALIZE(function()
        hookfunction(require(ReplicatedStorage.LoadModule)("OpenEgg"), function() end)
    end)
end, {text = "Use Before Opening"})


for _,v in next, {"1st", "2nd", "3rd"} do 
    local ID = tonumber(v:split("")[1])
    Chests["Chest Dropdown"..v:split("")[1]] = Chests:Cheat("Dropdown", v.." Chest", function(SelectedChest)
        if SelectedChest == "(Select/None)" then 
            Settings.ChestDropdown[ID] = nil 
        else
            Settings.ChestDropdown[ID] = SelectedChest
        end
        Save()
    end, {default = Settings.ChestDropdown[ID], options = ChestTypes})
end

Chests.CollectChests = Chests:Cheat("Checkbox", AddEmoji("Collect Chests", "Key"), function(State) 
    Mining.CollectChests = State
    Settings.Other.Noclip = State
    Save()
    task.spawn(function()
        while Mining.CollectChests and task.wait() do

            for _,v in next, Settings.ChestDropdown do
                if v ~= nil then
                    Chest = GetChest(v)
                    if Chest and Chest:FindFirstChild("Part") then

                        if GetWorld.fromPlayer(LocalPlayer) ~= GetWorld.fromWorldPos(Chest.Part.Position) then
                            game.ReplicatedStorage.Events.Teleport:FireServer(GetWorld.fromWorldPos(Chest.Part.Position))
                            task.wait(0.5)
                        end     
                        TweenTeleport(Chest.Part.Position)
                        local CheestTimer = tick()
                        repeat task.wait()
                            if Chest and Chest:FindFirstChild("Part") then
                                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.CFrame.X, Chest.Part.Position.Y, HumanoidRootPart.CFrame.Z)
                            end
                        until not Chest.Parent or not Mining.CollectChests or tick()-CheestTimer > 2

                    end
                end
            end     
        end
    end)
end, {enabled = Mining.CollectChests})



Crates:Cheat("Dropdown", "Crates", function(Value)  
    OpenSettings.SelectedCrate = Value
    Save()
end, {options = CrateTypes, default = OpenSettings.SelectedCrate})

Crates:Cheat("Checkbox", AddEmoji("Open Crates", "Toolbox"), function(State) 
    OpenSettings.OpenCrates = State
    Save()
    spawn(function()
        while OpenSettings.OpenCrates and task.wait(OpenSettings.CrateCooldown) do
            Network:FireServer("OpenCrate", OpenSettings.SelectedCrate)
        end
    end)
end, {enabled = OpenSettings.OpenCrates})

Crates:Cheat("Slider", AddEmoji("Cooldown", "Yawn", true), function(Value)
    OpenSettings.CrateCooldown = Value
    Save()
end, {min = 0.01, max = 2, suffix = ""})

Crates:Cheat("Button", AddEmoji("No Animation", "Sparkle", true), function()
    LPH_NO_VIRTUALIZE(function()
        hookfunction(require(ReplicatedStorage.LoadModule)("OpenCrate"), function() end)
    end)
end, {text = "Use Before Opening"})



Summer:Cheat("Dropdown", "Fishing Locations", function(Value)  
    if Value ~= "(Select/None)" then
        MiscSettings.SelectedFishSpot = workspace.Worlds["Summer Fair"].Fishing[Value].Part
        Save()
    end
end, {options = {"(Select/None)", "Mountain", "River", "Pond", "Ocean"}, default = MiscSettings.SelectedFishSpot})

Summer:Cheat("Checkbox", AddEmoji("Auto Fish", "Fishing"), function(State) 
    MiscSettings.AutoFish = State
    Save()
    spawn(function()
        while MiscSettings.AutoFish and task.wait() do
            repeat task.wait() until not HumanoidRootPart.Anchored
            Network:FireServer("FishingCast", MiscSettings.SelectedFishSpot, MiscSettings.SelectedFishSpot.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
        end
    end)
end, {enabled = MiscSettings.AutoFish})



OtherMisc:Cheat("Dropdown", "Teleports", function(Value)  
    Network:FireServer("Teleport", Value)
end, {options = Layers, default = "(Select/None)"})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Deposit Fire Shards", "Fire"), function(State) 
    MiscSettings.AutoDepositFireshards = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoDepositFireshards and task.wait() do
            for _,v in next, PlayerData.BackpackInventory do
                if v[1] == "fireshard" then
                    Network:FireServer("DepositShards")
                end
                task.wait()
            end
        end
    end)
end, {enabled = MiscSettings.AutoDepositFireshards})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Buy Pickaxes", "Pickaxe"), function(State) 
    MiscSettings.AutoBuyPickaxes = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoBuyPickaxes and task.wait() do
            for i,v in next, require(ReplicatedStorage.SharedModules.Data.Shops) do
                if i:find("Tool") and MiscSettings.AutoBuyPickaxes then
                    for a = 1, #v do
                        Network:FireServer("PurchaseShopItem", i, a)
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
end, {enabled = MiscSettings.AutoBuyPickaxes})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Buy Backpacks", "Backpack"), function(State) 
    MiscSettings.AutoBuyBackpacks = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoBuyBackpacks and task.wait() do
            for i,v in next, require(ReplicatedStorage.SharedModules.Data.Shops) do
                if i:find("Backpack") and MiscSettings.AutoBuyBackpacks then
                    for a = 1, #v do
                        Network:FireServer("PurchaseShopItem", i, a)
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
end, {enabled = MiscSettings.AutoBuyBackpacks})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Equip Best Pets", "Cat"), function(State) 
    MiscSettings.AutoEquipBestPets = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoEquipBestPets and task.wait(1) do
            Network:FireServer("EquipBestPets")
        end
    end)
end, {enabled = MiscSettings.AutoEquipBestPets})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Collect Mining Pass", "Key"), function(State) 
    MiscSettings.AutoCollectMiningPass = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoCollectMiningPass and task.wait() do
            for i = 1,20 do
                Network:FireServer("ClaimMiningPassReward", i, false)
                Network:FireServer("ClaimMiningPassReward", i, true)
            end
            task.wait(15)
        end
    end)
end, {enabled = MiscSettings.AutoCollectMiningPass})

OtherMisc:Cheat("Checkbox", AddEmoji("Auto Claim Group Rewards", "Clover"), function(State) 
    MiscSettings.AutoClaimGroup = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoClaimGroup and task.wait(1) do
            Network:InvokeServer("ClaimGroupBenefits")
        end
    end)
end, {enabled = MiscSettings.AutoClaimGroup})

--[[OtherMisc:Cheat("Checkbox", AddEmoji("Auto Trick Or Treat", "Halloween"), function(State) 
    MiscSettings.TrickOrTreat = State
    Settings.Other.Noclip = State
    Save()
    task.spawn(function()
        if GetWorld.fromPlayer(LocalPlayer) ~= GetWorld.fromWorldPos(GetHouse().Position) then
            game.ReplicatedStorage.Events.Teleport:FireServer(GetWorld.fromWorldPos(GetHouse().Position))
            task.wait(1)
        end
        while MiscSettings.TrickOrTreat and task.wait() do
            local House = GetHouse()
            TweenTeleport(House.CFrame)
        end
    end)
end, {enabled = MiscSettings.TrickOrTreat})]]--



Factory:Cheat("Dropdown", "Recipes", function(Value)  
    MiscSettings.SelectedRecipe = Value:split(" (")[1]
    print(MiscSettings.SelectedRecipe)
    Save()
end, {options = FactoryRecipes, default = MiscSettings.SelectedRecipe})

Factory:Cheat("Checkbox", AddEmoji("Convert Coins", "Factory"), function(State) 
    MiscSettings.UseFactory = State
    Save()
    task.spawn(function()
        while MiscSettings.UseFactory and task.wait() do
            for i = 1,3 do
                Network:FireServer("StartFactoryCraft", MiscSettings.SelectedRecipe, i)
            end
            wait(10)
        end
    end)
end, {enabled = MiscSettings.UseFactory})

Factory:Cheat("Checkbox", AddEmoji("Auto Claim Gems", "Gem", true), function(State) 
    MiscSettings.ClaimGems = State
    Save()
    task.spawn(function()
        while MiscSettings.ClaimGems and task.wait() do
            for i = 1,3 do
                Network:FireServer("ClaimFactoryCraft", i)
            end
            wait(10)
        end
    end)
end, {enabled = MiscSettings.ClaimGems})


for _,v in next, {"1st", "2nd", "3rd"} do 
    local ID = tonumber(v:split("")[1])
    AutoDelete["Chest Dropdown"..v:split("")[1]] = AutoDelete:Cheat("Dropdown", v.." Rarity", function(SelectedRarity)
        if SelectedRarity == "(Select/None)" then 
            Settings.RarityDropdown[ID] = nil 
        else
            Settings.RarityDropdown[ID] = SelectedRarity
        end
        Save()
    end, {default = Settings.RarityDropdown[ID], options = {"Common", "Unique", "Rare", "Epic"}})
end

local DeletedPets = {}
AutoDelete:Cheat("Button", AddEmoji("Delete Pets", "Hamster"), function()
    for _,v in next, Settings.RarityDropdown do
        if v ~= nil then
            for _,z in next, PlayerData.Pets do 
                if PetDatabase[z[2]].Rarity == v then
                    table.insert(DeletedPets, z[1])
                end
            end
        end
    end
    Network:FireServer("MultiDeletePets", DeletedPets)
    task.wait(0.1)
    DeletedPets = nil
    DeletedPets = {}
end, {text = ""})



Webhooks:Cheat("Textbox", "URL", function(Value)
    WebhookSettings.WebhookURL = Value
    Save()
end, {placeholder = "..."})

Webhooks:Cheat("Checkbox", AddEmoji("Send Pet Hatches", "DogFace"), function(State) 
    WebhookSettings.SendPetHatches = State
    Save()
end, {enabled = WebhookSettings.SendPetHatches})

for _,v in next, {"Rare", "Epic", "Legendary"} do
    Webhooks:Cheat("Checkbox", AddEmoji(v, "Sparkle", true), function(State) 
        WebhookSettings[v] = State
        Save()
    end, {enabled = WebhookSettings[v]})
end

Webhooks:Cheat("Checkbox", AddEmoji("Send Miscellaneous Stats", "Ribbon"), function(State) 
    if not WebhookSettings.SendPetHatches then
        sendNotification("Mining Simulator 2", "Please enable `Send Pet Hatches` to use this feature.")
    end
    WebhookSettings.SendMiscStats = State
    Save()
end, {enabled = WebhookSettings.SendMiscStats})

Webhooks:Cheat("Checkbox", AddEmoji("Ratio Chances", "Gear"), function(State) 
    WebhookSettings.RatioChance = State
    Save()
end, {enabled = WebhookSettings.RatioChance})




local Colors = {
    ["Rare"] = 16719390,
    ["Epic"] = 10158335,
    ["Legendary"] = 16755773,
}

local NewPets = {}
local CurrentPets = {}
for _,v in next, PlayerData.Pets do
    table.insert(CurrentPets, v[1])
end

--// Webhook Sender
do
    local CurrentEggCurrency
    local function GetChance(PetName, IsShiny)
        for _,v in next, require(ReplicatedStorage.SharedModules.Data.Eggs) do
            for _,x in next, v.Chances do
                if x[2] == PetName then
                    local Chance = x[3]
                    CurrentEggCurrency = v.Cost
                    Chance = Chance * GetLuckMultiplier(PlayerData)
                    if IsShiny then
                        Chance = Chance / (PlayerData.Passes["Lucky Pass"] and 50 or 100)
                    end
                    return Chance.."%"
                end
            end
        end
    end
    local function GetRatioChance(PetName, IsShiny)
        PetChance = GetChance(PetName, IsShiny):gsub("%%", "")
        number1 = tonumber(math.round(PetChance / (gcd(PetChance, 100)), 0))
        number2 = tonumber(math.round(100 / (gcd(PetChance, 100)), 0))
        divided = tostring(number2/number1)
        if number1 < 2 then
            return number1.." in "..number2
        else
            if divided:find("e") then
                return "1 in "..string.format("%."..(divided:split("e-")[2]+1).."f", divided)
            else
                return "1 in "..SuffixBeADDED(number2/number1)
            end
        end
    end
    local function RandomStats(CurrentCoins, RemainingEggs, CurrentCyberTokens, TimePlayed, TimePlayedDays)
        local msg = {
            ["username"] = "System Exodus Hatch Notifier",
            ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
            ["content"] = ("—"):rep(20),
            ["embeds"] = {{
                ["color"] = 12035327,
                ["title"] = "||"..LocalPlayer.Name.."|| Player Stats:",
                ["fields"] = {
                    {
                        ["name"] = ":egg: Eggs:",
                        ["value"] = "ㅤ• :clap: **Total Hatched:** `"..SuffixBeADDED(TrackedStats["EggsOpened"]).."`\nㅤ• :pinching_hand: **Remaining Eggs:** `"..CommasBeADDED(RemainingEggs).."`\nㅤ• :sparkles: **Shiny Pets Hatched:** `"..CommasBeADDED(TrackedStats["ShinyHatched"]).."`\nㅤ• :pray: **Secret Pets Hatched:** `"..TrackedStats["SecretHatched"].."`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = ":wrench: Other:",
                        ["value"] = "ㅤ• :coin: **Coins:** `"..CurrentCoins.."`\nㅤ• :rocket: **Cyber Tokens:** `"..SuffixBeADDED(CurrentCyberTokens).."`\nㅤ• :pick: **Blocks Mined:** `"..SuffixBeADDED(TrackedStats["BlocksMined"]).."`\nㅤ• :alarm_clock: **Time Played:** `"..TimePlayed.."m ("..TimePlayedDays.."h)`",
                        ["inline"] = true
                    }
                },
            }}
        }
        Request({
            Url = WebhookSettings.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = JSONEncode(msg)
        })
    end
    local function PetHatches(PetName, Rarity, Chance, Power, Speed, Icon, Color, Coins, CyberTokens)
        local msg = {
            ["username"] = "System Exodus Hatch Notifier",
            ["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
            ["embeds"] = {{
                ["color"] = tonumber(Color),
                ["title"] = "New Pet: "..PetName.." :tada:",
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ["thumbnail"] = {
                    ["url"] = Icon
                },
                ["footer"] = {
                    ["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
                    ["text"] = "Created by Jxnt#9946"
                },
                ["fields"] = {
                    {
                        ["name"] = ":star: Statistics:",
                        ["value"] = "ㅤ• :pick: **Power:** `"..Power.."`\nㅤ• :dash: **Speed:** `"..Speed.."`\nㅤ• :coin: **Coins:** `"..Coins.."`\nㅤ• :rocket: **Cyber Tokens:** `"..CyberTokens.."`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = ":wrench: Other:",
                        ["value"] = "ㅤ• :gem: **Rarity:** `"..Rarity.."`\nㅤ• :slot_machine: **Chance:** `"..Chance.."`",
                        ["inline"] = true
                    }
                },
            }
        }}
        Request({
            Url = WebhookSettings.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, 
            Body = JSONEncode(msg)
        })
    end
    spawn(function()
        local RandomStatsTimer = tick()
        local PetIconsURL = "https://raw.githubusercontent.com/HugeGamesLol/MiningSimulator2Assets/main/Pets/"
        local CoinTable = {}
        local RebirthTable = {}
        local I = 1
        while task.wait(0.1) do
            RebirthCount = PlayerData.Rebirths
            RebirthAmount = GetRebirthCost(PlayerData.Rebirths, PlayerData.GemEnchantments)
            
            local Collapse = workspace.Worlds["The Overworld"].Sign.Display.SurfaceGui.Info.Text:split(" ")[1]
            local BackpackWorth = GetBackpackValue().Coins or 0

            CoinTable[I] = BackpackWorth
            RebirthTable[I] = RebirthCount
            local CoinDifference = BackpackWorth - (CoinTable[I-600] or CoinTable[1])
            local RebirthDifference = RebirthCount - (RebirthTable[I-600] or RebirthTable[1])
            I += 1
        
            CoinsPerMinute.Text = "Coins Per Minute: "..SuffixBeADDED(CoinDifference)
            RebirthsPerMinute.Text = "Rebirths Per Minute: "..SuffixBeADDED(RebirthDifference)
            RebirthsThisSession.Text = "Rebirths This Session: "..RebirthsSession
            
            if RebirthsSession > 0 then
                LastRebirth.Text = "Last Rebirth: "..os.time()-RebirthTimer.." seconds ago."
            end
            
            RebirthStatus.Text = "Rebirth Status: "..SuffixBeADDED(BackpackWorth + PlayerData.Coins).."/"..SuffixBeADDED(RebirthAmount)
            BackpackWorthLabel.Text = "Backpack Worth: "..SuffixBeADDED(BackpackWorth)
            CollapseBlocks.Text = "Collapse Status: "..Collapse.." Blocks until reset."
            
            
            if WebhookSettings.SendPetHatches then
                for _,v in next, PlayerData.Pets do
                    if not table.find(CurrentPets, v[1]) then
                        table.insert(NewPets, v)
                        table.insert(CurrentPets, v[1])
                    end
                end

                for _,v in next, NewPets do
                    local PetName = v[2]
                    local PetData = PetDatabase[PetName]
                    local ShinyPet = (v[3] == 1 or v[3] == 2 and true) or false

                    local Power = PetData.Data.Power and "+"..PetData.Data.Power or "N/A"
                    local Speed = PetData.Data.Speed and PetData.Data.Speed.."x" or "N/A"
                    local Coins = PetData.Data.Coins and PetData.Data.Coins.."x" or "N/A"
                    local CyberTokens = PetData.Data.CyberTokens and PetData.Data.CyberTokens.."x" or "N/A"

                    PetImage = ShinyPet and PetIconsURL.."Shiny_"..PetName..".png" or PetIconsURL..PetName..".png"
                    PetImage = PetImage:gsub(" ", "%%20")
                    local Chance = WebhookSettings.RatioChance and GetRatioChance(PetName, ShinyPet) or GetChance(PetName, ShinyPet)

                    TrackedStats = {}
                    for i,v in next, PlayerData.TrackedStats do
                        TrackedStats[i] = v
                    end

                    if tick()-RandomStatsTimer > 4 then
                        if WebhookSettings.SendMiscStats then
                            local EggsLeft
                            local CurrentCoins = PlayerData.Coins
                            local CurrentCyberTokens = PlayerData.CyberTokens
                            local TimePlayed = math.round(TrackedStats["TimePlayed"]/60)
                            local TimePlayedDays = math.round((TimePlayed)/60)
                            if CurrentEggCurrency[1] == "Coins" then
                                EggsLeft = math.round(CurrentCoins / CurrentEggCurrency[2])
                            elseif CurrentEggCurrency[1] == "CyberTokens" then
                                EggsLeft = math.round(CurrentCyberTokens / CurrentEggCurrency[2])
                            end
                            RandomStats(CurrentCoins, EggsLeft, CurrentCyberTokens, TimePlayed, TimePlayedDays)
                        end
                    end
                    RandomStatsTimer = tick()

                    if ShinyPet then
                        PetHatches("__*Shiny*__ "..PetName, PetData.Rarity, Chance, Power, Speed, PetImage, Colors[PetData.Rarity], Coins, CyberTokens)
                    else
                        PetHatches(PetName, PetData.Rarity, Chance, Power, Speed, PetImage, Colors[PetData.Rarity], Coins, CyberTokens)
                    end
                end
                NewPets = nil
                NewPets = {}
            end
        end
    end)
end



Keybinds:Cheat("Keybind", "UI Keybind", function(Value)
    Settings.Keybinds.ToggleKey = Value.Name
    UI.ChangeToggleKey(Enum.KeyCode[Settings.Keybinds.ToggleKey])
    Save()
end)


local function Noclip()
    for _,v in next, LocalPlayer.Character:GetDescendants() do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end


task.spawn(function()
    local Velocity = nil
    local NoclipVariable = nil
    while task.wait() do
        if Settings.Other.Noclip then
            if not NoclipVariable then
                NoclipVariable = game.RunService.Stepped:Connect(Noclip)
            end
            if not Velocity then
                Velocity = Instance.new("LinearVelocity")
                Velocity.MaxForce = math.huge
                Velocity.Parent = HumanoidRootPart
                Velocity.Attachment0 = HumanoidRootPart.RootRigAttachment
            end
        else
            if NoclipVariable then
                NoclipVariable:Disconnect()
                NoclipVariable = nil
            end
            if Velocity then
                Velocity:Destroy()
                Velocity = nil
            end
        end
    end
end)


--// Anti AFK
for _,v in next, getconnections(LocalPlayer.Idled) do
    v:Disable()
end
