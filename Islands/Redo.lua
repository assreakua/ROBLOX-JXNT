--[[ Game Loading Wait ]]--
if not game:IsLoaded() then 
    game.Loaded:Wait()
end 

--[[ Services ]]--
local request = request or syn and syn.request or http and http.request or http_request or httprequest
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

--[[ Player Variables ]]--
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() 
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = (Humanoid and Humanoid.RootPart) or Character:WaitForChild("HumanoidRootPart")

--[[ Game Variables ]]--
local ReplicatedStorage = game.ReplicatedStorage
local RemoteStorage = ReplicatedStorage.TS.remotes
local Remotes = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
local CraftMeta = require(ReplicatedStorage.TS.crafting["workbench-meta"])
local ServerToClientEventId = require(ReplicatedStorage.TS.event["server-event-id"]).ServerToClientEventId
local SpawnExperienceEvent = Remotes["server_event_"..ServerToClientEventId.SPAWN_EXPERIENCE_ORBS]
local ClientInventoryService = require(LocalPlayer.PlayerScripts.TS.ui.inventory["client-inventory-service"]).ClientInventoryService 
local Entities = workspace:FindFirstChild("WildernessIsland") and workspace.WildernessIsland.Entities
local WildTriggers = workspace:FindFirstChild("spawnPrefabs") and workspace.spawnPrefabs.WildEventTriggers

--[[ Tools ]]--
local NonBlockPickaxes = {"voidMattock", "opalPickaxe", "diamondPickaxe", "gildedSteelPickaxe", "ironPickaxe", "stonePickaxe", "woodPickaxe"}
local BlockPickaxes = {"gregsHammer", "voidMattock", "opalPickaxe", "diamondPickaxe", "gildedSteelPickaxe", "ironPickaxe", "stonePickaxe", "woodPickaxe"}
local Axes = {"voidMattock", "opalAxe", "diamondAxe", "gildedSteelAxe", "ironAxe", "stoneAxe", "woodAxe"}
local Shovels = {"shovelWinter", "shovelIron", "shovelStone", "shovelWood"}
local FishingRods = {"fishingRodIron", "fishingRod"}
local CropList = {"wheat", "tomato", "potato", "carrot", "onion", "cactus", "spinach", "pumpkin", "radish", "chili", "spirit", "starfruit", "melon", "rice", "seaweed", "candyCane", "pineapple", "dragonfruit", "grapeVine", "voidParasite", "crystallineIvy", "opuntia"}

--[[ UI Variables ]]--
local DefaultSettings = {}
local Categories = {}
local Sectors = {}

--[[ Detect Universe Games ]]--
local UniversePlaces = {}
for _,v in next, AssetService:GetGamePlacesAsync():GetCurrentPage() do
    UniversePlaces[#UniversePlaces + 1] = v.PlaceId
end
if not table.find(UniversePlaces, 4872321990) then 
    return LocalPlayer:Kick("[Islands UI]: User not in Islands.")
end

--[[ Detect New Remote Storages ]]--
if #RemoteStorage:GetChildren() ~= 24 then
    return LocalPlayer:Kick("[Islands UI]: AC update detected, UI down until further notice! ("..#RemoteStorage:GetChildren()..")")
end

--[[ Luraph Functions ]]--
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
end

--[[ Create new Folders ]]--
local Folders = {"System Exodus", "System Exodus/Islands", "System Exodus/Islands/SaveFiles", "System Exodus/Islands/Schematica", "System Exodus/Islands/Schematica/BuildMaterialSaves", "System Exodus/Islands/UserItemInfoSaves"}
for _,v in next, Folders do
    if not isfolder(v) then
        makefolder(v)
    end
end

--[[ UI Destroy ]]--
if UI then
    UI:Destroy()
end

--[[ Get Remote Names ]]--
local GeneralRemotes = getscriptclosure(RemoteStorage["remotes"])
local CombatRemotes = getscriptclosure(RemoteStorage["combat-remotes"])
local NetRemotes = getscriptclosure(RemoteStorage["entity-net-remotes"])
local FishingRemotes = getscriptclosure(RemoteStorage["fishing-remotes"])

local AllNamespaces = getconstants(GeneralRemotes)
local AllCombatNames = getconstants(CombatRemotes)
local AllNetNames = getconstants(NetRemotes)
local AllFishingNames = getconstants(FishingRemotes)

local SwingSwordRemote = AllCombatNames[43]
local SwingNetRemote = AllNetNames[22]
local FishingSuccessRemote = AllFishingNames[23]
local FishingCastRemote = AllFishingNames[26]

for i = 1, #AllNamespaces do
    if AllNamespaces[i] == "EntityHeal" then
        CombatNamespace = AllNamespaces[i+2]
        VendingNamespace = AllNamespaces[i+3]
        NetNamespace = AllNamespaces[i+10]
        FishingNamespace = AllNamespaces[i+8]
        break
    end
end

local SwingSword = CombatNamespace.."/"..SwingSwordRemote
local SwingNet = NetNamespace.."/"..SwingNetRemote
local CastRod = FishingNamespace.."/"..FishingCastRemote
local FishingSuccess = FishingNamespace.."/"..FishingSuccessRemote

--[[ Get Remote Keys ]]--
getgenv().Keys = {
    PlaceBlockArgName,
    PlaceBlockArgCode,
    DestroyBlockArgName,
    DestroyBlockArgCode,
    PickupToolArgName,
    PickupToolArgCode,
    HarvestCropArgName,
    HarvestCropArgCode,
    DepositToolArgName,
    DepositToolArgCode,
    MobArgName,
    MobArgCode
}
local function GetRemoteKeys(Type)
    if Type == "Mobs" then
        if not Keys.MobArgName then
            for _,a in next, getgc() do
                if type(a) == "function" and getinfo(a).name == "attemptHit" then
                    FunctionProtos = getprotos(a)
                    FunctionConsants = getconstants(a)
                    if FunctionProtos and #FunctionProtos > 0 then
                        FunctionProtos = FunctionProtos[1]
                        FunctionConsants = getconstants(getproto(FunctionProtos, 1))
                    end
                    for i,v in next, FunctionConsants do
                        if v == "hitUnit" then
                            Keys.MobArgName = FunctionConsants[i+1]
                            break
                        end
                    end
                    break
                end
            end
        end
        if not Keys.MobArgCode then
            repeat task.wait() until Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):FindFirstChildOfClass("LocalScript")
            HeldTool = Character:FindFirstChildOfClass("Tool"):FindFirstChildOfClass("LocalScript")
            SwordClosure = getscriptclosure(HeldTool)
            SwordConstants = getconstants(SwordClosure)
            for i,v in next, SwordConstants do
                if tostring(v):find("\n") then
                    Keys.MobArgCode = SwordConstants[i]..SwordConstants[i+1]
                    break
                end
            end
        end
    elseif Type == "Blocks" then
        AxeTool = require(ReplicatedStorage.TS.tool.tools.shared["axe-tool"]).AxeTool
        AxeProtos = getproto(AxeTool.onBlockHit, 2)
        AxeConstants = getconstants(AxeProtos)
        BlockController = require(LocalPlayer.PlayerScripts.TS.flame.controllers.block["block-controller"]).BlockController
        BlockProtos = getproto(BlockController.onStart, 1)
        BlockConstants = getconstants(BlockProtos)
        CurrentTable = ""
        for i,v in next, {AxeConstants, BlockConstants} do
            for i,v in next, v do
                if tostring(v):find("norm") then
                    CurrentTable = "AxeConstants"
                    Keys.DestroyBlockArgName = AxeConstants[i+1] 
                end
                if tostring(v):find("blockType") then
                    CurrentTable = "BlockConstants"
                    Keys.PlaceBlockArgName = BlockConstants[i+1]
                end
                if tostring(v):find("\n") then
                    if CurrentTable == "AxeConstants" then
                        Keys.DestroyBlockArgCode = AxeConstants[i]..AxeConstants[i+1]
                    elseif CurrentTable == "BlockConstants" then
                        Keys.PlaceBlockArgCode = BlockConstants[i]..BlockConstants[i+1]
                    end
                end
                if Keys.DestroyBlockArgName and Keys.DestroyBlockArgCode and Keys.PlaceBlockArgName and Keys.PlaceBlockArgCode then
                    break
                end
            end
        end
    elseif Type == "Drops" then
        ClientInventoryService = require(LocalPlayer.PlayerScripts.TS.ui.inventory["client-inventory-service"]).ClientInventoryService
        InventoryConstants = getconstants(ClientInventoryService.pickupTool)
        for i,v in next, InventoryConstants do
            if tostring(v):find("tool") then
                Keys.PickupToolArgName = InventoryConstants[i+1]
            end
            if tostring(v):find("\n") then
                Keys.PickupToolArgCode = InventoryConstants[i]..InventoryConstants[i+1]
            end
            if Keys.PickupToolArgName and Keys.PickupToolArgCode then
                break
            end
        end
    elseif Type == "Crops" then
        CropService = require(LocalPlayer.PlayerScripts.TS.block.crop["crop-service"]).CropService
        CropConstants = getconstants(CropService.breakCrop)
        for i,v in next, CropConstants do
            if tostring(v):find("player") then
                Keys.HarvestCropArgName = CropConstants[i-1]
            end
            if tostring(v):find("\n") then
                Keys.HarvestCropArgCode = CropConstants[i]..CropConstants[i+1]
            end
            if Keys.HarvestCropArgName and Keys.HarvestCropArgCode then
                break
            end
        end
    elseif Type == "DepositTools" then
        WorkerController = require(LocalPlayer.PlayerScripts.TS.flame.controllers.workers["worker-controller"]).WorkerController
        WorkerConstants = getconstants(WorkerController.depositTool)
        for i,v in next, WorkerConstants do
            if tostring(v):find("amount") then
                Keys.DepositToolArgName = WorkerConstants[i+1]
            end
            if tostring(v):find("\n") then
                Keys.DepositToolArgCode = WorkerConstants[i]..WorkerConstants[i+1]
            end
            if Keys.DepositToolArgName and Keys.DepositToolArgCode then
                break
            end
        end        
    end
end
GetRemoteKeys("Blocks")
GetRemoteKeys("Drops")
GetRemoteKeys("DepositTools")

--[[ Load UI Items ]]--
getgenv().TextXAlignmentUI = "Left"
local Finity, Notification, Version = loadstring(game:HttpGet("https://scripts.system-exodus.com/assets/libraries/Library.lua"))()
local Version = Version:Get("Islands")

--[[ Config Settings ]]--
DefaultSettings.Keybinds = {
    ToggleKey = "RightShift",
    FlyKey = "G",
    NoclipKey = "N"
}

DefaultSettings.Farming = {
    Crops = {
        SickleCrops = false,
        SickleBushes = false,
        ReplaceCrops = false,
        WaterCrops = false,
        HardcoreMonsters = false,
        SellCrops = false,
        SellSeasonal = false,
        FarmWildCrops = false,
        SelectedCrop = "(Select/None)"
    },

    Ores = {
        HubEnabled = false,
        IslandEnabled = false,
        BreakUnderOres = false
    },

    Trees = {
        ChopTrees = false,
        ReplaceTrees = false,
        BreakUnderTrees = false
    },

    Totems = {
        CollectItems = false
    },

    Flowers = {
        WaterFertile = false,
        CollectFertile = false,
        CollectNonFertile = false
    },

    Creatures = {
        MobFarming = false,
        BossFarming = false,
        KorMineOres = false,

        UseBook = false,
        UseBow = false,
        AutoEquip = false,

        CollectFireflies = false,
        CollectBees = false,
        CollectRabbits = false,
        CollectFrogs  = false,
        CollectSpirits = false,

        Sword = "",
    }
}

DefaultSettings.Machinery = {
    Smelting = false,
    Sawing = false,
    Cutter = false,
    Compsot = false,
    Polish = false,
    UpgradeTotems = false,
}

DefaultSettings.Miscellaneous = {
    MiddleClick = false,
    AutoEat = false, 
    Plow = false,
    UnPlow = false,
    CollectNeatItems = false,
    AlwaysDay = false,
    AlwaysNight = false,
    Open2020Presents = false,
    Open2021Presents = false,
    Open2022Presents = false,
    CollectNearChests = false,
    FillNearChests = false,
}

DefaultSettings.WorldEdit = {
    ShowOutline = false,
    ShowOutline2 = false,
    ChangeEnd = false,
    ChangeStart = false,
    ChangingPosition = false,
    CFrameOne = 0,
    CFrameTwo = 0,
    DragCF = 0,
    Abort = false,
    UpgradeTotems = false,
    PlowGrass = false,
    SaveAsHTML = false,
    SaveWithMaterials = false
}

DefaultSettings.Other = {
    Version = 0,
    ServerType = "404",
    NeedsNoclip = false,
    InstantTeleport = false,
    RejoinLowServers = false,
    DetectNearPlayers = false
}

DefaultSettings.OreDropdown = {}
DefaultSettings.TreeDropdown = {}
DefaultSettings.TotemDropdown = {}
DefaultSettings.MobDropdown = {}
DefaultSettings.BossDropdown = {}
DefaultSettings.EatDropdown = {}
DefaultSettings.SmeltDropdown = {}
DefaultSettings.SawDropdown = {}
DefaultSettings.CutterDropdown = {}
DefaultSettings.CompostDropdown = {}
DefaultSettings.PolishDropdown = {}
DefaultSettings.TotemUpgrade = {}

ClientSettings = {
    Schematica = {}
}

--[[ Return User Whitelist ]]--
local Whitelisted, WhitelistedAmount, SaveFile
if (isLGPremium and isLGPremium()) == true or not LPH_OBFUSCATED then
    Whitelisted = true 
    getgenv().WAmount = 0
    WhitelistedAmount = {"1st", "2nd", "3rd"}
    SaveFile = "System Exodus/Islands/SaveFiles/"..LocalPlayer.Name.." - Settings.cfg"
else
    print("\n[Islands]: It seems that you aren\'t whitelisted for Premium. If you think this is a mistake and have bought Premium, please contact staff in our discord! (https://discord.gg/SystemExodus). Otherwise, consider buying Premium, it\'s a win-win for both of us ;)")
    setclipboard("Islands UI Discord: https://discord.gg/SystemExodus")
    WhitelistedAmount = {"1st"}
    getgenv().WAmount = 0.1
    SaveFile = "System Exodus/Islands/SaveFiles/Settings.cfg"
end

--[[ Save Settings ]]--
do 
    local function TableClone(t)
        local Copy = {}
        for i,v in next, t do
            if v and type(v) == "table" then
                v = TableClone(v)
            end
            Copy[i] = v
        end
        return Copy
    end

    if not pcall(readfile, SaveFile) then 
        writefile(SaveFile, game.HttpService:JSONEncode(DefaultSettings))
        Settings = TableClone(DefaultSettings)
    end

    Settings = game.HttpService:JSONDecode(readfile(SaveFile))
    function Save()
        writefile(SaveFile, game.HttpService:JSONEncode(Settings))
    end

    local function TableMerge(old, new) 
        for i,v in next, new do 
            if type(old[i]) ~= type(v) then 
                old[i] = v
            end
        end
    end 
    TableMerge(Settings, DefaultSettings)
    Save()
    local Fenv = getfenv()
    for i,v in next, Settings do 
        if type(v) == 'table' then 
            Fenv[i] = v 
        end
    end
end

--[[ Islands Place Ids ]]--
local Places = {}
Places[4872321990] = "MainIsland"
Places[5899156129] = "OnlineHub"
Places[5626342417] = "OnlineIsland"
Places[7456800858] = "OnlineUnderworld"
Places[9501318975] = "WildIslands"
Places[12815054798] = "DesertIsland"
Places[10529772199] = "VoidIsland"
Places[7176435327] = "Festival"
Places[11838346571] = "GameMode"
if workspace:FindFirstChild("PrivateServer") and workspace.PrivateServer.Value then
    Places["PrivateServer"] = true
end

if (Places[game.PlaceId] ~= Settings.Other.ServerType and not Places["PrivateServer"]) or Settings.Other.Version ~= Version.Version then
    writefile(SaveFile, game.HttpService:JSONEncode(DefaultSettings))
    Settings = game.HttpService:JSONDecode(readfile(SaveFile))
    Settings.Other.Version = Version.Version
end

Settings.Other.ServerType = Places[game.PlaceId]
if Places["PrivateServer"] then
    Settings.Other.ServerType = "PrivateServer"
end
Settings.Other.NeedsNoclip = false
Save()

--[[ Setting Variables ]]--
local FarmSettings = Settings.Farming
local MachinerySettings = Settings.Machinery
local MiscSettings = Settings.Miscellaneous
local WorldEditSettings = Settings.WorldEdit
local OtherSettings = Settings.Other

--[[ Fire Proixmity Prompt (STOLEN) ]]--
local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("ProximityPrompt expected")
    end
end

--[[ Equip Tools ]]--
local function EquipTool(Tool) 
    if Tool and Tool.Name and LocalPlayer.Backpack:FindFirstChild(Tool.Name) then
        ClientInventoryService:moveToHotbar(LocalPlayer.Backpack:FindFirstChild(Tool.Name))
        for i = 0, 7 do
            SlotItem = ClientInventoryService:getToolOnHotbarSlot(i)
            if SlotItem and SlotItem.Name == Tool.Name then
                ClientInventoryService:setSelectedHotbarIndex(i)  
                break
            end
        end
    end
end

--[[ Return Users Island ]]--
local function GetIsland()
    for _,v in next, workspace.Islands:GetChildren() do 
        if v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) <= 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) <= 1000 then 
            if not Whitelisted and v.Owners:FindFirstChild(""..LocalPlayer.UserId) then
                return v
            elseif Whitelisted and (v.Owners:FindFirstChild(""..LocalPlayer.UserId) or v.AccessBuild:FindFirstChild(""..LocalPlayer.UserId)) then
                return v
            end
        elseif v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) > 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) > 1000 and v.Owners:FindFirstChild(""..LocalPlayer.UserId) then
            return v
        end 
    end 
end

--[[ Return Users Nearest Island ]]--
local function GetNearestIsland()
    for _,v in next, workspace.Islands:GetChildren() do 
        if v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) <= 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) <= 1000 then 
            return v
        elseif v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) > 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) > 1000 and v.Owners:FindFirstChild(""..LocalPlayer.UserId) then
            return v
        end 
    end 
end

--[[ Return Item Actual Name ]]--
local function GetItemName(Item, Block, Sword, OnlyDisplay)
    for _,v in next, ReplicatedStorage.Tools:GetChildren() do 
        if (Sword and (v:FindFirstChild("sword") or v:FindFirstChild("rageblade"))) or (Block and v:FindFirstChild("block-place")) or (not Block and not Sword) then
            if OnlyDisplay and v:FindFirstChild("DisplayName") and (v.DisplayName.Value == Item) then
                return v.Name
            elseif not OnlyDisplay and v:FindFirstChild("DisplayName") and (v.DisplayName.Value == Item or v.Name == Item) then
                return v.Name
            end
        end
    end
end

--[[ Return Item Display Name ]]--
local function GetDisplayName(Item)
    for _,v in next, ReplicatedStorage.Tools:GetChildren() do 
        if v.Name:lower() == Item:lower() and v:FindFirstChild("DisplayName") then 
            return v.DisplayName.Value 
        end 
    end 
end

--[[ Position Taken / Return Finder ]]--
local function IsTaken(Position, ReturnBlock)
    local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
    for _,v in next, Parts do
        if v.Parent and v.Parent.Name == "Blocks" then
            return ReturnBlock and v or true
        end
    end
    return false
end

--[[ Return Nearby Block ]]--
local function GetNearBlocks(Range, Block)
    local Blocks = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Range, Range, Range), HumanoidRootPart.Position + Vector3.new(Range, Range, Range)), nil, math.huge) do
        if Block and v.Name:find(Block) then
            table.insert(Blocks, v)
        elseif not Block then
            table.insert(Blocks, v)
        end
    end
    return Blocks
end

--[[ Find Nearby Block ]]--
local function FindNearBlock(Range)
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Range, Range, Range), HumanoidRootPart.Position + Vector3.new(Range, Range, Range)), nil, math.huge) do
        if tostring(v.Parent) == "Blocks" and v.Size == Vector3.new(3,3,3) then
            return v
        end
    end
end

--[[ Return Best Item ]]--
local function GetBestItem(Items)
    for _,v in next, Items do
        if Character:FindFirstChild(v) or LocalPlayer.Backpack:FindFirstChild(v) then
            return Character:FindFirstChild(v) or LocalPlayer.Backpack:FindFirstChild(v)
        end
    end
    return nil
end

--[[ Find Players Item ]]--
local function FindItem(Item)
    if Character:FindFirstChild(Item) or LocalPlayer.Backpack:FindFirstChild(Item) then
        return true
    end
    return false
end

--[[ Return Under Block ]]--
local function GetUnderBlock(CFrame, Block)
    local FoundBlock
    local Position = Vector3.new(CFrame.X, CFrame.Y-3, CFrame.Z)
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge) do
        if Block and v.Name == Block then
            FoundBlock = v
            break
        elseif not Block then
            FoundBlock = v
            break
        end
    end
    return FoundBlock
end

--[[ Blacklisted Tree Terms ]]--
local BlacklistedTreeTerms = {"treecoconut", "treelemon", "treeapple", "treeorange", "treeavocado", "treekiwi", "treeplum", "furniture", "street", "banner", "cutter", "shaker", "cut", "light", "decorated", "machine", "sapling"}
local BlacklistedOreTerms = {"naturalRock1", "bedrock"}
local function BlacklistedTerms(Tree, Blacklist) 
    if table.find(Blacklist, Tree) then
        return true
    end
    return false
end

--[[ Insta/Disable XP ]]--
local function ToggleXP()
    require(ReplicatedStorage.TS.util["block-utils"]).BlockUtils.textDropEffect = function() end
    
    if getconnections then
        for _,v in next, getconnections(SpawnExperienceEvent.OnClientEvent) do
            v:Disable()    
        end
    end

    if Whitelisted then
        local ClientRequestId = require(ReplicatedStorage.TS.event["client-request-id"]).ClientRequestId
        SpawnExperienceEvent.OnClientEvent:Connect(function(Data)
            if Data.player == LocalPlayer and Whitelisted then
                Remotes["client_request_"..ClientRequestId.REDEEM_EXPERIENCE_ORB]:InvokeServer({["experienceSecret"] = Data.experienceSecret})
            end
        end)        
    end
end

--[[ Get Nearby Grass ]]--
local function GetNearGrass(Area)
    local Grass = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), Character, math.huge) do
        if v.Parent.Name == "grass" then
            table.insert(Grass, v.Parent)
        end
    end
    return Grass
end

--[[ Get Nearby Chests ]]--
local function GetNearChests(Area, NeedItems)
    local Chests = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), Character, math.huge) do
        if v.Name:lower():find("chest") and not v.Name:lower():find("industrial") and v:FindFirstChild("Contents") then
            if NeedItems and (v.Contents:FindFirstChildWhichIsA("Tool") and v.Contents:FindFirstChildWhichIsA("Tool").Amount) then
                table.insert(Chests, v)
            elseif not NeedItems then
                table.insert(Chests, v)
            end 
        end
    end
    return Chests
end

--[[ Get Crafting Items ]]--
local function GetCraftItems(Workbench)
    local CraftItems = {}
    for _,v in pairs(CraftMeta["WorkbenchMeta"][Workbench]["canCraft"]) do
        table.insert(CraftItems, GetDisplayName(v))
    end
    return CraftItems
end

--[[ Get Nearby Items ]]--
local function GetNearItems(Area)
    local Items = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), Character, math.huge) do
        if v.Parent:IsA("Tool") then
            table.insert(Items, v.Parent)
        end
    end
    return Items
end

--[[ Get Nearby Soil ]]--
local function GetNearSoil(Area)
    local Soil = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), Character, math.huge) do
        if v.Name == "soil" then
            table.insert(Soil, v)
        end
    end
    return Soil
end

--[[ Get Nearby Waterables ]]--
local function GetNearWaterables(Area, Block)
    local Waterables = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), Character, math.huge) do
        if Block and v.Name == Block and v:FindFirstChild("Watered") and not v.Watered.Value then
            table.insert(Waterables, v)
        elseif not Block and v:FindFirstChild("Watered") and not v.Watered.Value then
            table.insert(Waterables, v)
        end
    end
    return Waterables
end

--[[ Portal Requirements ]]--
local PortalRequirements = {
    ["slime-hub"] = 0,
    ["spirit-slime"] = 0,
    ["buffalkor-slime"] = 7,
    ["wizard-buffalkor"] = 20,
    ["desert-wizard"] = 36, 
    ["diamond_mine-buffalkor"] = 46,
    [""] = "",
}


--[[ Mob Portal TPs ]]--
local MobPortalTPs = {
    ["slime"] = "slime-hub",
    ["buffalkor"] = "buffalkor-slime",
    ["wizardLizard"] = "wizard-buffalkor",
    ["hostileCrab"] = "UseRemote",
    ["skeletonPirate"] = "UseRemote",
    ["magmaBlob"] = "UsePortal",
    ["magmaGolem"] = "UsePortal",
    ["voidDog"] = "UsePortal",
    ["skorp"] = "desert-wizard",
    ["skorpIron"] = "desert-wizard",
    ["skorpGold"] = "desert-wizard",
    ["skorpRuby"] = "desert-wizard"
}
--[[
local function MobZoneTP(Mob)
    return Mob == "slime" and "slime-hub" or Mob == "buffalkor" and "buffalkor-slime" or Mob == "wizardLizard" and "wizard-buffalkor" or (Mob == "hostileCrab" or Mob == "skeletonPirate") and "UseRemote" or (Mob == "magmaBlob" or Mob == "magmaGolem") and "UsePortal" or Mob == "voidDog" and "UsePortal" or (Mob == "skorp" or Mob == "skorpIron" or Mob == "skorpGold" or Mob == "skorpRuby") and "desert-wizard"
end
]]--

--[[ Boss Portal TPs ]]--
local BossPortalTP = {
    ["slimeKing"] = "slime-hub",
    ["slimeQueen"] = "slime-hub",
    ["wizardBoss"] = "wizard-buffalkor",
    ["desertBoss"] = "desert-wizard",
    ["skorpSerpent"] = "desert-wizard",
    ["golem"] = "diamond_mine-buffalkor",
    ["magmaDragon"] = "UsePortal",
    ["deerBoss"] = "UsePortal",
    ["voidSerpent"] = "UsePortal"
}
--[[
local function BossZoneTP(Mob)
    return (Mob == "slimeKing" or Mob == "slimeQueen") and "slime-hub" or Mob == "wizardBoss" and "wizard-buffalkor" or (Mob == "desertBoss" or Mob == "skorpSerpent") and "desert-wizard" or (Mob == "golem" or Mob == "magmaDragon" or Mob == "deerBoss"  or Mob == "voidSerpent") and "UsePortal"
end
]]--

--[[ Get Boss Spawn Name ]]--
local BossSpawnName = {
    ["slimeKing"] = "slime_king_spawn",
    ["slimeQueen"] = "slime_queen_spawn",
    ["wizardBoss"] = "wizard_boss_spawn",
    ["desertBoss"] = "desert_boss_spawn",
    ["golem"] = "golem_spawn",
    ["magmaDragon"] = "dragon_boss_spawn",
    ["deerBoss"] = "deer_boss_spawn",
    ["voidSerpent"] = "void_serpent_spawn"
}

local BossTokenAmount = {
    ["slimeQueen"] = 100,
    ["magmaDragon"] = 750,
    ["voidSerpent"] = 300,
}

local function CalculateTokens(Boss)
    local TokenAmount = BossTokenAmount[Boss] and BossTokenAmount[Boss] or 500
    if (Boss == "voidSerpent" and LocalPlayer.Backpack:FindFirstChild("voidBossToken") and LocalPlayer.Backpack.voidBossToken.Amount.Value >= TokenAmount) or (Boss == "magmaDragon" and LocalPlayer.Backpack:FindFirstChild("underworldDragonToken") and LocalPlayer.Backpack.underworldDragonToken.Amount.Value >= TokenAmount) or (LocalPlayer.Backpack:FindFirstChild(Boss.."Token") and LocalPlayer.Backpack[Boss.."Token"].Amount.Value >= TokenAmount) or Boss == "deerBoss" then
        return true
    end
    return false
end

--[[
local function GetWildSpawnName(Boss)
    return Boss == "slimeKing" and "slime_king_spawn" or Boss == "slimeQueen" and "slime_queen_spawn" or Boss == "wizardBoss" and "wizard_boss_spawn" or Boss == "desertBoss" and "desert_boss_spawn" or Boss == "golem" and "golem_spawn" or Boss == "magmaDragon" and "dragon_boss_spawn" or Boss == "deerBoss" and "deer_boss_spawn" or Boss == "voidSerpent" and "void_serpent_spawn"
end
]]--

--[[ Get Boss Spawn Coords ]]--
local BossSpawnCoords = {
    ["slimeKing"] = CFrame.new(724, 155, 142),
    ["slimeQueen"] = CFrame.new(709, 204, 514),
    ["wizardBoss"] = CFrame.new(1803, 406, -1001),
    ["desertBoss"] = CFrame.new(639, 302, -2096),
    ["golem"] = CFrame.new(2862, 273, 1179),
    ["magmaDragon"] = CFrame.new(-9194, 395, -1401),
    ["deerBoss"] = CFrame.new(-1157, 279, -1111),
    ["voidSerpent"] = CFrame.new(-10216, 270, 9252)
}
--[[
local function GetSpawnCoords(Boss)
    return Boss == "slimeKing" and CFrame.new(724, 172, 142) or Boss == "slimeQueen" and CFrame.new(709, 221, 514) or Boss == "wizardBoss" and CFrame.new(1803, 421, -1001) or Boss == "desertBoss" and CFrame.new(639, 317, -2096) or Boss == "golem" and CFrame.new(2862, 288, 1179) or Boss == "magmaDragon" and CFrame.new(-9194, 410, -1401) or Boss == "deerBoss" and CFrame.new(-1157, 294, -1111) or Boss == "voidSerpent" and CFrame.new(-10216, 285, 9252)
end
]]--

local OrePortalsTP = {
    ["rockStone"] = "hub-slime",
    ["rockCoal"] = "hub-slime",
    ["rockIron"] = "hub-slime",
    ["pileSnow"] = "hub-slime",
    ["rockIce"] = "hub-slime",
    ["rockPrismarine"] = "hub-slime",
    ["rockClay"] = "hub-slime",
    ["rockGranite"] = "hub-slime",
    ["rockDiorite"] = "hub-slime",
    ["rockAndesite"] = "hub-slime",

    ["rockSlate"] = "buffalkor-slime",
    ["rockElectrite"] = "buffalkor-slime",
    ["rockGold"] = "buffalkor-slime",

    ["rockSandstoneRed"] = "desert-wizard",
}

--[[ Return Dead or not ]]--
local function IsMobDead(Mob)
    if not Mob or not Mob:FindFirstChild("HumanoidRootPart") or (Mob:FindFirstChild("IsDead") and Mob.IsDead.Value) then
        return true
    end
    return false
end

--[[ Add Emojis ]]--
local function AddEmoji(Text, Emoji, Spaces, Custom)
    local Add = (Spaces and "     -> ") or (Custom ~= nil and Custom) or ""
    return Add..Version.Emojis[Emoji].." "..Text
end

--[[ Notify ]]--
local function Notify(Description, Time, State)
    NewDescription = ""
    Color = Color3.fromRGB(205, 329, 255)
    if State ~= nil then
        NewDescription = State and " <font color='rgb(130, 220, 120)'>enabled.</font>" or " <font color='rgb(255, 84, 84)'>disabled.</font>"
        Color = State and Color3.fromRGB(130, 220, 120) or Color3.fromRGB(255, 84, 84)
    end
    Notification:Notify(
        {Title = AddEmoji("Islands | System Exodus", "Island", false, " "), Description = Description..NewDescription},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = Time, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color}
    )
end

--[[ Tween Teleport ]]--
local function TweenTeleport(Position, Enabled, Waiting)
    if Tween and Tween.Cancel then
        Tween:Cancel()
        Tween = nil
        if Enabled == false then 
            return
        end
    end

    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, Position.Y, HumanoidRootPart.Position.Z)
    Distance = (HumanoidRootPart.Position - Position.p).magnitude
    TweenTime = Distance / 27
    getgenv().Tween = game.TweenService:Create(HumanoidRootPart, TweenInfo.new(TweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position.p)})
    Tween:Play()
    if Waiting then
        Tween.Completed:Wait()
    end
end

local function TooFarAway(Position, IslandONLY)
    if (HumanoidRootPart.CFrame.p - Position.p).magnitude >= (IslandONLY and 5000 or 2000) then
        if IslandONLY then
            Hub()
            task.wait(1)
            return false
        end
        return true
    end
    return false
end

local function Teleport(Position, Enabled, Waiting, DistanceThing)
    if not TooFarAway(Position, DistanceThing) then
        TweenTeleport(Position, Enabled, Waiting)
    end
end

--[[ Hub Portal Coords ]]--
local GetCoords = {
    ["hub-slime"] = Vector3.new(313, 26, -1073),
    ["slime-hub"] = Vector3.new(690, 195, -224),
    ["buffalkor-slime"] = Vector3.new(1178, 377, 101),
    ["wizard-buffalkor"] = Vector3.new(1178, 377, 101),
    ["diamond_mine-buffalkor"] = Vector3.new(2475, 239, 890),
    ["spirit-slime"] = Vector3.new(30, 290, 857),
    ["desert-wizard"] = Vector3.new(1474, 335, -875)
}

--[[ Teleport to Island ]]--
local function Hub(PersonalIsland)
    local Island = GetIsland().Blocks
    if Island:FindFirstChild("portalToSpawn") then
        Remotes["CLIENT_VISIT_ISLAND_REQUEST"]:InvokeServer({["island"] = workspace.Islands[Island.Parent.Name]})
    end
end

--[[ Island Teleporting ]]--
local LastTeleported = nil
local LastTeleportedTime = tick()
local function IslandTeleport(Island)
    local Portals = {}
    for _,v in next, workspace.WildernessBlocks:GetChildren() do
        if v.Name == "portal" and v:FindFirstChild("WildDestination") then
            local WildDestination = tostring(v.WildDestination.Value)
            table.insert(Portals, WildDestination)
            if Island == WildDestination then
                Distance = (HumanoidRootPart.Position - GetCoords[Island]).magnitude
                if Distance >= 2000 or LastTeleported ~= Island then
                    local OldPosition = HumanoidRootPart.Position 
                    local Timer = tick()
                    OtherSettings.NeedsNoclip = false
                    task.wait(0.3)
                    repeat task.wait() until Humanoid:GetState() == Enum.HumanoidStateType.Running
                    repeat task.wait()
                        firetouchinterest(HumanoidRootPart, v.Frame, 0)
                        firetouchinterest(HumanoidRootPart, v.Frame, 1)
                        print((tick()-Timer >= (tick()-LastTeleportedTime >= 4 and 2 or 5)))
                    until (HumanoidRootPart.Position - OldPosition).magnitude >= 20 or (tick()-Timer >= (tick()-LastTeleportedTime >= 4 and 2 or 5))
                    repeat task.wait() until Humanoid:GetState() == Enum.HumanoidStateType.Running
                    task.wait(0.3)
                    LastTeleportedTime = tick()
                    LastTeleported = Island
                    OtherSettings.NeedsNoclip = true
                    break
                else
                    return
                end
            end
        end
    end
    if not table.find(Portals, Island) and Island ~= "UseRemote" and Island ~= "UsePortal" then
        local Timer = os.time()
        HumanoidRootPart.Anchored = true
        task.wait(0.5)
        repeat task.wait()
            HumanoidRootPart.CFrame = CFrame.new(GetCoords[Island])
        until os.time()-Timer > 2
        task.wait(0.5)
        HumanoidRootPart.Anchored = false
        task.wait(0.5)
        IslandTeleport(Island)
    end
end

--[[ Destroy Queen Crystals ]]--
local function CheckIfQueen(Boss)
    if Boss == "slimeQueen" and workspace.WildernessBlocks:FindFirstChild("slimeScepterBlock") then
        local OldEquipped = Character:FindFirstChildWhichIsA("Tool") 
        local QueenHeal = workspace.WildernessBlocks:FindFirstChild("slimeScepterBlock")
        repeat task.wait()
            QueenHeal = workspace.WildernessBlocks:FindFirstChild("slimeScepterBlock")
            if QueenHeal then
                EquipTool(GetBestItem(Pickaxes))
                Teleport(QueenHeal.CFrame * CFrame.new(0, -10, 0))
                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = QueenHeal, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
            end
        until not QueenHeal or not FarmSettings.Creatures.BossFarming
        EquipTool(OldEquipped)
    end
end

--[[ Colors for Image -> Blocks ]]-- 
getgenv().Colors = {
    ["blackBlock"] = {17, 17, 17},
    ["whiteBlock"] = {248, 248, 248},
    ["redBlock"] = {255, 0, 0},
    ["orangeBlock"] = {218, 133, 65},
    ["yellowBlock"] = {255, 255, 0},
    ["lightGreenBlock"] = {0, 255, 0},
    ["darkGreenBlock"] = {40, 127, 71},
    ["cyanBlock"] = {18, 238, 212},
    ["blueBlock"] = {0, 0, 255},
    ["purpleBlock"] = {98, 37, 209},
    ["pinkBlock"] = {255, 102, 204},
  
    ["stone"] = {162,158,152},

    ["pastelPinkBlock"] = {244, 167, 204},
    ["pastelPurpleBlock"] = {183, 133, 200},
    ["pastelBlueBlock"] = {155, 195, 255},
    ["pastelGreenBlock"] = {104, 200, 123},
    ["pastelYellowBlock"] = {200, 181, 113},
    ["pastelOrangeBlock"] = {200, 155, 109},
    ["pastelRedBlock"] = {200, 119, 116},
  
    ["woodPlank"] = {153, 119, 68},
    ["pinePlank"] = {97, 71, 54},
    ["birchPlank"] = {198, 176, 123},
    ["maplePlank"] = {170, 118, 82},
    ["hickoryPlank"] = {218, 196, 102},
    ["spiritPlank"] = {161, 144, 173},
    ["cherryBlossomPlank"] = {188, 143, 135},  
}

getgenv().Colors2 = {
    ["blackBlock"] = {1, 1, 1},
    ["whiteBlock"] = {1, 1, 1},
    ["redBlock"] = {1, 1, 1},
    ["orangeBlock"] = {1, 1, 1},
    ["yellowBlock"] = {1, 1, 1},
    ["lightGreenBlock"] = {1, 1, 1},
    ["darkGreenBlock"] = {1, 1, 1},
    ["cyanBlock"] = {1, 1, 1},
    ["blueBlock"] = {1, 1, 1},
    ["purpleBlock"] = {1, 1, 1},
    ["pinkBlock"] = {1, 1, 1},
  
    ["stone"] = {1,1,1},

    ["pastelPinkBlock"] = {1, 1, 1},
    ["pastelPurpleBlock"] = {1, 1, 1},
    ["pastelBlueBlock"] = {1, 1, 1},
    ["pastelGreenBlock"] = {1, 1, 1},
    ["pastelYellowBlock"] = {1, 1, 1},
    ["pastelOrangeBlock"] = {1, 1, 1},
    ["pastelRedBlock"] = {1, 1, 1},
  
    ["woodPlank"] = {1, 1, 1},
    ["pinePlank"] = {1, 1, 1},
    ["birchPlank"] = {1, 1, 1},
    ["maplePlank"] = {1, 1, 1},
    ["hickoryPlank"] = {1, 1, 1},
    ["spiritPlank"] = {1, 1, 1},
    ["cherryBlossomPlank"] = {1, 1, 1},  
}

--[[ Crop Handler ]]--
local CropHandler = {}
CropHandler.__index = CropHandler

function CropHandler.newCrop(Crop)
    Crop:WaitForChild("stage", 9e9)
    
    local FarmableStage = 3
    local CropName = Crop.Name:lower():find("berrybush") and "berryBush" or Crop.Name 
    if CropName == "berryBush" then
        FarmableStage = 2
    end
    if Crop.stage.Value == FarmableStage then
        CollectionService:AddTag(Crop, "READY: "..CropName)
    end

    Crop.stage.Changed:Connect(function(Stage)
        task.wait()
        if Stage == FarmableStage then
            CollectionService:AddTag(Crop, "READY: "..CropName)
        else
            CollectionService:RemoveTag(Crop, "READY: "..CropName)
        end
    end)
end

function CropHandler.new()
    local self = setmetatable({}, CropHandler)
    CollectionService:GetInstanceAddedSignal("crop-logic"):Connect(self.newCrop)
    for i,v in next, CollectionService:GetTagged("crop-logic") do
        self.newCrop(v)
    end
    return self
end

function CropHandler:Get(Crop)
    return CollectionService:GetTagged("READY: "..Crop)
end

--[[ Flower Handler ]]--
local FlowerHandler = {}
FlowerHandler.__index = FlowerHandler

function FlowerHandler.newFlower(Flower)
    Flower:WaitForChild("Watered", 9e9)
    
    local FlowerName = Flower.Name:lower():find("flower") and "Flowerables"
    if not Flower.Watered.Value then
        CollectionService:AddTag(Flower, "READY: "..FlowerName)
    end

    Flower.Watered.Changed:Connect(function(Watered)
        task.wait()
        if not Watered then
            CollectionService:AddTag(Flower, "READY: "..FlowerName)
        else
            CollectionService:RemoveTag(Flower, "READY: "..FlowerName)
        end
    end)
end

function FlowerHandler.new()
    local self = setmetatable({}, FlowerHandler)
    CollectionService:GetInstanceAddedSignal("flower"):Connect(self.newFlower)
    for i,v in next, CollectionService:GetTagged("flower") do
        self.newFlower(v)
    end
    return self
end

function FlowerHandler:Get(Flower)
    return CollectionService:GetTagged("READY: "..Flower)
end

--[[ Matrix -> Blocks ]]--
local function MatrixToBlocks(Matrix, Block, Block2)
	QRBlocks1 = {}
    if Block2 and Block2 ~= "" then
		QRBlocks2 = {}
	end
    
    for i = 1, #Matrix do
        for j = 1, #Matrix[i] do
            if Matrix[i][j] == 1 then
                table.insert(QRBlocks1, {
                    C = { i * 3, 0, j * 3, 1, 0, 0, 0, 1, 0, 0, 0, 1 }
                })
            elseif Matrix[i][j] == 0 and Block2 then
				table.insert(QRBlocks2, {
                    C = { i * 3, 0, j * 3, 1, 0, 0, 0, 1, 0, 0, 0, 1 }
                })
			end
        end
    end
    if Block2 then
		return {Blocks = {[Block] = QRBlocks1, [Block2] = QRBlocks2}, Size = {#Matrix*3, 3, #Matrix[1]*3}}
	else
		return {Blocks = {[Block] = QRBlocks1}, Size = {#Matrix*3, 3, #Matrix[1]*3}}
	end
end

--[[ Destroy Old World Edit Stuff ]]--
for _,v in next, workspace:GetChildren() do
    if v.Name == "Model" then
        v:Destroy()
    end
end
for _,v in next, game.CoreGui:GetChildren() do
    if v.Name == "Handles" then
        v:Destroy()
    end
end

--[[ Mod Numbers ]]--
local function Mod(Number, Amount)
    if typeof(Number) == "number" then
        if Number < 0 then
            return - (math.abs(Number) - (math.abs(Number) % Amount))
        end
        return Number - (Number % Amount)
    end
end

--[[ World Edit Handel & Box ]]--
local Mouse = LocalPlayer:GetMouse()
local Model = Instance.new("Model")

local SelectionBox = Instance.new("SelectionBox")
SelectionBox.SurfaceColor3 = Color3.fromRGB(199, 120, 255)
SelectionBox.Color3 = Color3.new(1, 1, 1)
SelectionBox.LineThickness = 0.15
SelectionBox.SurfaceTransparency = 0.85
SelectionBox.Visible = false
SelectionBox.Adornee = Model
SelectionBox.Parent = Model

local IndicatorStart = Instance.new("Part")
IndicatorStart.Size = Vector3.new(3.3, 3.3, 3.3)
IndicatorStart.Transparency = 1
IndicatorStart.Anchored = true
IndicatorStart.CanCollide = false
IndicatorStart.Color = Color3.fromRGB(170, 170, 255)
IndicatorStart.Material = "SmoothPlastic"
IndicatorStart.TopSurface = Enum.SurfaceType.Smooth
IndicatorStart.Parent = Model

local ResizeHandle = Instance.new("Handles")
ResizeHandle.Style = Enum.HandlesStyle.Resize
ResizeHandle.Visible = false
ResizeHandle.Adornee = IndicatorStart
ResizeHandle.Parent = game.CoreGui
ResizeHandle.Color3 = Color3.fromRGB(255, 204, 204)
Model.Parent = workspace

local PreviousDistance = 0
local HandleSize = 0
local HandleCFrame = 0
ResizeHandle.MouseButton1Down:Connect(function()
    PreviousDistance = 0
	HandleCFrame = ResizeHandle.Adornee.CFrame
	HandleSize = ResizeHandle.Adornee.Size
end)

ResizeHandle.MouseDrag:Connect(function(Face, Distance)
	local Distance = Distance - (Distance % 3)
    local ResizeDirection = Vector3.FromNormalId(Face) 
	if PreviousDistance ~= Distance then
        if ResizeDirection.X == -1 or ResizeDirection.Y == -1 or ResizeDirection.Z == -1 then
            ResizeHandle.Adornee.Size = HandleSize + (-1 * ResizeDirection * Distance)
        else
		    ResizeHandle.Adornee.Size = HandleSize + (ResizeDirection * Distance)
		end
        ResizeHandle.Adornee.CFrame = HandleCFrame + (ResizeDirection * Distance) / 2
		PreviousDistance = Distance
	end
end)

Mouse.Button1Down:Connect(function()
    if Mouse.Target then
        if WorldEditSettings.ChangeStart then
            local ToChange = WorldEditSettings.ChangeStart and "Start"
            if Mouse.Target.Parent.Name == "Blocks" or Mouse.Target.Parent.Parent.Name == "Blocks" then
                local Part = Mouse.Target.Parent.Name == "Blocks" and Mouse.Target or Mouse.Target.Parent.Parent.Name == "Blocks" and Mouse.Target.Parent
                WorldEditSettings[ToChange] = Part.Position
                if ToChange == "Start" then
                    ResizeHandle.Visible = WorldEditSettings.ShowOutline2 or WorldEditSettings.ShowOutline
                    IndicatorStart.Transparency = WorldEditSettings.ShowOutline2 or WorldEditSettings.ShowOutline and 0.5 or 1
                end
                if WorldEditSettings.Start then
                    SelectionBox.Visible = WorldEditSettings.ShowOutline2 or WorldEditSettings.ShowOutline
                    if ToChange == "Start" then
                        IndicatorStart.Size = Vector3.new(3.3, 3.3, 3.3)
                        IndicatorStart.Position = Part.Position
                    end
                else
                    IndicatorStart.Size = Vector3.new(3.3, 3.3, 3.3)
                    IndicatorStart.Position = Part.Position
                end
                WorldEditSettings.ChangeStart = false
                WorldEditSettings.ChangeEnd = false
            end
        end
    end
end)

local Indicator = Instance.new("Part")
Indicator.Size = Vector3.new(3.1, 3.1, 3.1)
Indicator.Transparency = 0.5
Indicator.Anchored = true
Indicator.CanCollide = false
Indicator.Color = Color3.fromRGB(170, 170, 255)
Indicator.TopSurface = Enum.SurfaceType.Smooth
Indicator.Parent = workspace
Indicator.Material = "SmoothPlastic"

local Handles = Instance.new("Handles")
Handles.Style = Enum.HandlesStyle.Movement
Handles.Adornee = Indicator
Handles.Visible = false
Handles.Parent = game.CoreGui
Handles.Color3 = Color3.fromRGB(255, 204, 204)
Handles.MouseButton1Down:Connect(function()
    WorldEditSettings.DragCF = Handles.Adornee.CFrame
end)

Handles.MouseDrag:Connect(function(Face, Distance)
    if Indicator.Parent.ClassName == "Model" then
        Indicator.Parent:SetPrimaryPartCFrame(WorldEditSettings.DragCF + Vector3.FromNormalId(Face) * (math.round(Distance / 3) * 3))
    else
        Indicator.CFrame = WorldEditSettings.DragCF + Vector3.FromNormalId(Face) * (math.round(Distance / 3) * 3)
    end
end)





























--[[ UI Messages ]]--
local LoadMessages = {
    "(Pro Max Ultra Wide 8G Wi-Fi 1950watts GeForce RTX 5090 Ti 340Hz Version)",
    "(Ultra Lucky! Version)",
    "(Shiny Pokemon Version)",
    "(INSANE Edition)",
    '("RARE" Version)',
    "(20w14∞ Version)",
    "(BLEHHHH :P Version)",
    "(turtl Version)",
    "(YIPPPEEEEE Version)",
    "(1/25 Version)",
    "(silly little guy Version)",
    "(Boykisser Version)"
}

local UIMessages = {
    "Thanks for using our script! <3",
    "Hey guys, did you know that in terms of human Pokemon bree-",
    "Fun Fact: This script contains 3k+ lines of code!",
    "WOAH! I see your using the all new ultra shiny System Exodus script!!!!",
    "Shoutout to the System Exodus Mods <3",
    "VASTTTLAYYYY is NOT cool.",
    "Projezt Z? more like.. Project L OOOHHHH",
    "System Exodus was once called Jxnt Scripts!",
    "Machinery coming soon to a script near you...",
    "...love ya<3",
    "wYn on YouTube has some pretty good tutorials.",
    "i-i-... love you Vorlias!",
    "i-i-... love you Potat!",
    "Wowzers *GULP* you are a... shooting star!!",
    "System Exodus on TOPPPP.. EVERYONE JUST A FOLLOWER",
    "Life... is Roblox...",
    "TELL EM TO BRING OUT THE LOBSTER",
    "3 years and we still on top? wow",
    "Islands 2 when?",
    "Only added these because I was bored lols",
    "ZAMNN :drool: hot UI",
    '"System Exodus fell off after Pet Simulator X" :pensive:',
    "when am i gonna get a girl :sob:",
    "felling a bit silly right now :P",
    "already sorry for y'all when happy pet game comes out..."
}

--[[ Load UI ]]--
local UI = Finity.new("Islands | System Exodus", UDim2.new(0, 680, 0, 370), nil, function(Data) 
    Data.tip.Text = (AddEmoji("<font color=\"rgb(255,255,255)\">Islands | System Exodus </font>", "Island", false, " ")..(Whitelisted and (math.random(1, 25) == 1 and LoadMessages[math.random(1, #LoadMessages)] or "(Premium Version)") or "(Free Version)"))
end)

--[[ Categories ]]--
local Home = UI:Category(AddEmoji("Home", "Clipboard", false, " ")) 
local Farming = UI:Category(AddEmoji("Farming", "Tractor", false, " "))
local Mobs = UI:Category(AddEmoji("Creatures", "Sword", false, " ")) 
local Vending = UI:Category(AddEmoji("Vendings", "FlyingMoney", false, " ")) 
local Machinery = UI:Category(AddEmoji("Machinery", "Machine", false, " ")) 
local Misc = UI:Category(AddEmoji("Miscellaneous", "Glass", false, " "))
local WorldEdit = UI:Category(AddEmoji("World Edit", "Barrier", false, " ")) 
local SettingsTab = UI:Category(AddEmoji("Settings", "Gear", false, " ")) 

--[[ Home Sectors ]]--
local DiscordInviteEmoji = AddEmoji("Discord Invite", "Link", false)
local Islands = Home:Sector("Islands")
Islands:Cheat("Label", AddEmoji("Scripted by: @Jxnt", "Scroll", false))
Islands:Cheat("Label", AddEmoji("UI by: deto & @xxxYoloxxx999", "PurpleHeart", false))
Islands:Cheat("Label", AddEmoji("To minimize the UI, press "..Settings.Keybinds.ToggleKey, "Sparkle", false))
Islands:Cheat("Button", DiscordInviteEmoji, function()
    Notify("Invite link was copied to your keyboard!", 3)
    UI.Features[DiscordInviteEmoji].button.Text = "Copied / Joined"
	setclipboard("https://discord.gg/SystemExodus")
    for i = 6453, 6464 do
        task.spawn(function()
            request({Url = "http://127.0.0.1:"..tostring(i).."/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"}, Body = game:GetService("HttpService"):JSONEncode({["cmd"] = "INVITE_BROWSER", ["nonce"] = game:GetService("HttpService"):GenerateGUID(false), ["args"] = {["invite"] = {["code"] = tostring("systemexodus"), }, ["code"] = tostring("systemexodus")}})})
        end)
    end
    task.wait(1)
    UI.Features[DiscordInviteEmoji].button.Text = "Copy / Join"
end, {text = "Copy / Join"})
Islands:Cheat("Label", ("\n"):rep(29)..UIMessages[math.random(1, #UIMessages)])
UI.ChangeToggleKey(Enum.KeyCode[Settings.Keybinds.ToggleKey])

Updates = Home:Sector("UI Update ("..Version.Date..")")  
for _,v in next, Version.Changelog do
    Updates:Cheat("Label", v) 
end

--[[ Farming Sectors ]]--
local Crops = Farming:Sector("Crops")
local Ores = Farming:Sector("Ores")
local Trees = Farming:Sector("Trees")
local Totems = Farming:Sector("Totems")
local Shh = Farming:Sector("")
local Flowers = Farming:Sector("Flowers")
for i = 1,5 do
    Farming:Sector("")
end

--[[ Creatures Sectors ]]--
local NormalMobs = Mobs:Sector("Mobs")
local Bosses = Mobs:Sector("Bosses")
local Fishing = Mobs:Sector("Fishing")
local OtherCreatures = Mobs:Sector("Other")
for i = 1,5 do
    Mobs:Sector("")
end

--[[ Machinery Sectors ]]--
local Smelt = Machinery:Sector("Smelting")
local Saw = Machinery:Sector("Sawing")
local Cutter = Machinery:Sector("Cutting")
local Compost = Machinery:Sector("Compost")
local Polish = Machinery:Sector("Polish")
local UpgradeTotems = Machinery:Sector("Upgrade Totems")
local OtherMachines = Machinery:Sector("Other")
for i = 1,10 do
    Machinery:Sector("")
end

--[[ Misc Sectors ]]--
local Player = Misc:Sector("Player")
local InventoryViewer = Misc:Sector("Player Info")
local AutoEat = Misc:Sector("Auto Eat")
local VendingMachines = Misc:Sector("Vending Machines")
local CraftAnywhere = Misc:Sector("Craft Items")
local OtherMisc = Misc:Sector("Other")
for i = 1,15 do
    Misc:Sector("")
end

--[[ World Edit ]]--
local Print = WorldEdit:Sector("Print/Destroy")
local Setup1 = WorldEdit:Sector("Select Area")
local Shh = WorldEdit:Sector("")
local Setup = WorldEdit:Sector("Manage")
local Load = WorldEdit:Sector("Load/Save")
local Shh = WorldEdit:Sector("")
local Shh = WorldEdit:Sector("")
local ConvertImages = WorldEdit:Sector("Convert Images")
local QRCode = WorldEdit:Sector("Create QR Codes")
for i = 1,5 do
    WorldEdit:Sector("")
end

--[[ Settings Sectors ]]--
local Keybinds = SettingsTab:Sector("Keybinds")
local SettingsOther = SettingsTab:Sector("Other")

















local function GetNewServers()
    local Servers = {}
    local NextPage = ""
    task.spawn(function()
        while task.wait() do
            Places = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..(NextPage and NextPage)))
            for i,v in next, Places.data do
                if v.playing <= 10 and v.id ~= game.JobId and not table.find(Servers, v.id) then
                    Servers[#Servers + 1] = v.id
                end
            end
            if not Places.nextPageCursor or Places.nextPageCursor == nil or Places.nextPageCursor == "null" then
                print("Islands | System Exodus: Found every possible server.")
            else
                NextPage = Places.nextPageCursor
            end
            task.wait(0.5)
        end
    end)
    repeat task.wait() until #Servers >= 1
    return Servers[math.random(1, #Servers)]
end











Keybinds:Cheat("Keybind", AddEmoji("UI Toggle", "Keyboard"), function(Bind)
    UI.ChangeToggleKey(Bind)
    Settings.Keybinds.ToggleKey = Bind.Name
    Save()
end)

SettingsOther:Cheat("Button", AddEmoji("Save Weapon", "Sword"), function()
    if Character:FindFirstChildOfClass("Tool") then
        FarmSettings.Creatures.Sword = Character:FindFirstChildOfClass("Tool").Name
        Notify("Saved Weapon: "..GetDisplayName(FarmSettings.Creatures.Sword), 3)
        Save()
    end
end, {text = "*Equip a Weapon*"})

SettingsOther:Cheat("Checkbox", AddEmoji("Rejoin Low Servers", "Skull"), function(State)
    OtherSettings.RejoinLowServers = State
    Notify("Rejoin Low Servers was", 3, State)
    Save()

    task.spawn(function()
        while OtherSettings.RejoinLowServers and task.wait() do
            if #Players:GetPlayers() >= 15 then
                Notify("Rejoining a new server in 10s, please disable to abort.", 10)
                task.wait(10)
                if not OtherSettings.RejoinLowServers then
                    break
                end
                while OtherSettings.RejoinLowServers and task.wait() do
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, GetNewServers())
                    task.wait(5)
                end
            end
        end
    end)
end, {enabled = OtherSettings.RejoinLowServers})

SettingsOther:Cheat("Checkbox", AddEmoji("Detect Near Players", "Skull"), function(State)
    OtherSettings.DetectNearPlayers = State
    Notify("Detect Near Players was", 3, State)
    Save()

    task.spawn(function()
        while OtherSettings.DetectNearPlayers and task.wait() do
            OldPosition = HumanoidRootPart.CFrame
            task.wait(0.5)
            for _,v in next, Players:GetPlayers() do
                if v.Name ~= LocalPlayer.Name and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (OldPosition.p - v.Character.HumanoidRootPart.Position).magnitude <= 100 and OtherSettings.DetectNearPlayers then
                    Timer = tick()
                    repeat task.wait()
                        task.spawn(function()
                            TweenTeleport(OldPosition * CFrame.new(0, 1000, 0))
                        end)
                    until not v.Character or not v.Character:FindFirstChild("HumanoidRootPart") or (OldPosition.p - v.Character.HumanoidRootPart.Position).magnitude > 100 or not OtherSettings.DetectNearPlayers
                    if not OtherSettings.NeedsNoclip then
                        OtherSettings.NeedsNoclip = true
                    end
                    TweenTeleport(OldPosition * CFrame.new(0, 1, 0))
                    OtherSettings.NeedsNoclip = false
                end
            end
        end
    end)
end, {enabled = OtherSettings.DetectNearPlayers})

--[[ Crop Farming ]]--
Crops:Cheat("Dropdown", "Selected Crop", function(SelectedCrop)  
    if SelectedCrop == "(Select/None)" then 
        FarmSettings.Crops.SelectedCrop = nil 
    else
        FarmSettings.Crops.SelectedCrop = SelectedCrop == "Candy Cane" and "candyCaneVine" or SelectedCrop == "Grape" and "grapeVine" or SelectedCrop == "Chili" and "chiliPepper" or SelectedCrop == "Spirit" and "spiritCrop" or SelectedCrop == "Crystalline Ivy" and "crystallineIvy" or SelectedCrop:lower()
    end
    Save()
end, {["options"] = {"(Select/None)", "Wheat", "Tomato", "Potato", "Carrot", "Onion", "Cactus", "Spinach", "Pumpkin", "Radish", "Chili", "Spirit", "Starfruit", "Melon", "Rice", "Seaweed", "Candy Cane", "Pineapple", "Dragonfruit", "Void Parasite", "Opuntia", "Crystalline Ivy"}, ["default"] = FarmSettings.Crops.SelectedCrop})

local CropCounter = 0
local NeverExecutedBefore = false
SickleCrops = Crops:Cheat("Checkbox", AddEmoji("Farm Crops", "Crop"), function(State) 
    FarmSettings.Crops.SickleCrops = State
    OtherSettings.NeedsNoclip = State
    ToggleXP()
    
    Notify("Farm Crops was", 3, State)
    Save()

    if FarmSettings.Crops.SickleCrops and not NeverExecutedBefore then
        GetCrops = CropHandler.new()
        NeverExecutedBefore = true
    end
    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Crops.SickleCrops and task.wait() do
            local CropEater = FarmSettings.Crops.HardcoreMonsters and GetIsland().Entities:FindFirstChild("voidCropEater") or nil
            if CropEater then

                if not Keys.MobArgName or not Keys.MobArgCode then
                    repeat task.wait() 
                        EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                        GetRemoteKeys("Mobs")
                        task.wait(1)
                    until Keys.MobArgName and Keys.MobArgCode
                end
                
                for _,v in next, GetIsland().Entities:GetChildren() do
                    if not IsMobDead(v) then
                        
                        repeat task.wait()
                            task.spawn(function()
                                EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                                Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,-12,0), FarmSettings.Creatures.MobFarming)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                Remotes[SwingSword]:FireServer("", {{["hitUnit"] = v, [Keys.MobArgName] = Keys.MobArgCode}})
                            end)
                            
                            task.wait(0.1)
                            if not IsMobDead(v) and FarmSettings.Creatures.Sword ~= "rageblade" then
                                task.wait(0.4) 
                            end

                        until not FarmSettings.Crops.SickleCrops or not FarmSettings.Crops.HardcoreMonsters or IsMobDead(v)
                    end
                end
            end

            if FarmSettings.Crops.WaterCrops and (LocalPlayer.Backpack:FindFirstChild("wateringCan") or Character:FindFirstChild("wateringCan")) then
                for _,v in next, GetNearWaterables(30, "soil") do
                    task.spawn(function()
                        EquipTool(LocalPlayer.Backpack:FindFirstChild("wateringCan") or Character:FindFirstChild("wateringCan"))
                        Remotes["CLIENT_WATER_BLOCK"]:InvokeServer({["block"] = v})
                    end)
                    task.wait()
                end
            end

            local SelectedCrop = GetCrops:Get(FarmSettings.Crops.SelectedCrop)
            if SelectedCrop[1] then
                Teleport(SelectedCrop[1].CFrame, nil, nil, true)
                Remotes["SwingSickle"]:InvokeServer(Whitelisted and "sickleDiamond" or "sickleStone", SelectedCrop)
                if FarmSettings.Crops.ReplaceCrops then
                    for _,v in next, SelectedCrop do
                        if v.Position and not IsTaken(v.Position) then
                            task.spawn(function()
                                CropCounter = CropCounter + 1
                                repeat task.wait()                                     
                                    Teleport(v.CFrame)
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["cframe"] = v.CFrame, ["blockType"] = FarmSettings.Crops.SelectedCrop, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                until not FarmSettings.Crops.SickleCrops or IsTaken(v.Position) or not v.Position
                                CropCounter = CropCounter - 1
                            end)
                            if not Whitelisted then
                                task.wait(0.07)
                            else
                                task.wait()
                            end
                            if CropCounter >= 50 then
                                repeat task.wait() until CropCounter == 0 or not FarmSettings.Crops.SickleCrops
                            end
                        end
                    end
                    repeat task.wait() until CropCounter == 0 or not FarmSettings.Crops.SickleCrops
                end
            end
        end
    end)
end, {enabled = FarmSettings.Crops.SickleCrops})

Crops:Cheat("Checkbox", AddEmoji("Replant Crops", "Seed", true), function(State)
    FarmSettings.Crops.ReplaceCrops = State
    Notify("Replant Crops was", 3, State)
    Save()
end, {enabled = FarmSettings.Crops.ReplaceCrops})

Crops:Cheat("Checkbox", AddEmoji("Water Nearby Soil", "Droplet", true), function(State)
    FarmSettings.Crops.WaterCrops = State
    Notify("Water Nearby Soil was", 3, State)
    Save()
end, {enabled = FarmSettings.Crops.WaterCrops})

Crops:Cheat("Checkbox", AddEmoji("Kill Hardcore Cutie Patooties", "Sword", true), function(State)
    if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
        return Notify("Please setup a sword in the Settings Tab", 3)
    end
    FarmSettings.Crops.HardcoreMonsters = State
    Notify("Wittle Pookie Bear Killer was", 3, State)
    Save()
end, {enabled = FarmSettings.Crops.HardcoreMonsters})


--[[ Berry Farming ]]--
SickleBush = Crops:Cheat("Checkbox", AddEmoji("Farm Berry Bushes", "Berry"), function(State) 
    FarmSettings.Crops.SickleBush = State
    Settings.Other.NeedsNoclip = State
    ToggleXP()

    Notify("Farm Bushes was", 3, State)
    Save()

    if FarmSettings.Crops.SickleBush and not NeverExecutedBefore then
        GetCrops = CropHandler.new()
        NeverExecutedBefore = true
    end
    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Crops.SickleBush and not FarmSettings.Crops.SickleCrops and task.wait() do
            local SelectedCrop = GetCrops:Get("berryBush")
            if SelectedCrop[1] then
                Teleport(SelectedCrop[1].CFrame, nil, nil, true)
                Remotes["SwingSickle"]:InvokeServer(Whitelisted and "sickleDiamond" or "sickleStone", SelectedCrop)
            end
        end
    end)
end, {enabled = FarmSettings.Crops.SickleBush})


--[[ Ore Farming ]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Ores["Ore Dropdown"..v:split("")[1]] = Ores:Cheat("Dropdown", v.." Ore", function(SelectedOre)
        if SelectedOre == "(Select/None)" then 
            Settings.OreDropdown[ID] = nil 
        else
            Settings.OreDropdown[ID] = SelectedOre == "Snow" and "pileSnow" or SelectedOre == "Red Sandstone" and "rockSandstoneRed" or SelectedOre == "Aquamarine" and "rockPrismarine" or SelectedOre == "Current Island" and "Current Island" or SelectedOre and "rock"..SelectedOre
        end
        Save()
    end, {default = Settings.OreDropdown[ID], options = {"(Select/None)", "Stone", "Coal", "Iron", "Gold", "Diamond", "Opal", "Obsidian", "Aquamarine", "Electrite", "Marble", "Slate", "Granite", "Diorite", "Andesite", "Basalt", "Sandstone", "Red Sandstone", "Clay", "Snow", "Ice", "Current Island"}})
end

--[[ Hub Ore Farming ]]--
MineOresHub = Ores:Cheat("Checkbox", AddEmoji("Mine Ores (Hub Area)", "Pickaxe"), function(State)
    FarmSettings.Ores.HubEnabled = State
    OtherSettings.NeedsNoclip = State
    
    Notify("Mine Ores (Hub) was", 3, State)
    Save()

    task.spawn(function()
        local CollectedOres = {}
        Teleport(HumanoidRootPart.CFrame)
        if table.find(Settings.OreDropdown, "Current Island") then
            for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(500, 500, 500), HumanoidRootPart.Position + Vector3.new(500, 500, 500)), nil, math.huge) do
                if v.Parent.Name:find("rock") and v.Parent.Name ~= "rockMimic" and v.Parent:FindFirstChild("RegenBlockTable") then
                    CurrentType = v.Parent.RegenBlockTable.Value
                    break
                end
            end
        end
        while FarmSettings.Ores.HubEnabled and task.wait() do
            for _,v in next, workspace.WildernessBlocks:GetChildren() do
                if v:FindFirstChild("RegenBlockTable") and (table.find(Settings.OreDropdown, "Current Island") and v.RegenBlockTable.Value == CurrentType) or table.find(Settings.OreDropdown, v.Name) then
                    CollectedOres[#CollectedOres + 1] = v
                end
            end
            table.sort(CollectedOres, function(i, v)
                return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
            end)
            
            local Ore = CollectedOres[1]
            if Ore and (HumanoidRootPart.Position - Ore.Position).magnitude > 700 or not Ore then
                for _,v in next, Settings.OreDropdown do
                    if not table.find(Settings.OreDropdown, "Current Island") then
                        print(OrePortalsTP[v])
                        IslandTeleport(OrePortalsTP[v])
                    end
                end
            end
            repeat task.wait()
                if Ore and Ore:FindFirstChild("RegenBlockTable") then
                    Teleport(Ore.CFrame, FarmSettings.Ores.HubEnabled)
                    if Ore.Name == "pileSnow" then
                        EquipTool(GetBestItem(Shovels)) 
                        Remotes["client_request_21"]:InvokeServer({["shovelType"] = GetBestItem(Shovels).Name, ["block"] = Ore})
                    else
                        EquipTool(GetBestItem(NonBlockPickaxes))
                        Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = Ore, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                    end
                end
            until not Ore or not Ore.Parent or not FarmSettings.Ores.HubEnabled or not Ore:FindFirstChild("RegenBlockTable")
            for _,v in next, CollectedOres do
                CollectedOres[_] = nil
            end
        end
    end)
end, {enabled = FarmSettings.Ores.HubEnabled})


--[[ Island Ore Farming ]]--
MineOresIsland = Ores:Cheat("Checkbox", AddEmoji("Mine Ores (Personal Island)", "Pickaxe"), function(State)
    FarmSettings.Ores.IslandEnabled = State
    OtherSettings.NeedsNoclip = State
    
    Notify("Mine Ores (Island) was", 3, State)
    Save()

    task.spawn(function()
        local CollectedOres = {}
        local NewIslandOres = GetIsland().Blocks.ChildAdded:Connect(function(Ore)
            if Ore.Name:find("rock") and not BlacklistedTerms(Ore.Name:lower(), BlacklistedOreTerms) then
                CollectedOres[#CollectedOres + 1] = Ore
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:find("rock") and not BlacklistedTerms(v.Name:lower(), BlacklistedOreTerms) then
                CollectedOres[#CollectedOres + 1] = v
            end
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Ores.IslandEnabled and task.wait() do
            table.sort(CollectedOres, function(i, v)
                return (HumanoidRootPart.Position - i.Position).magnitude < (HumanoidRootPart.Position - v.Position).magnitude
            end)
    
            for _,v in next, CollectedOres do
                if FarmSettings.Ores.IslandEnabled then
                    if table.find(Settings.OreDropdown, v.Name) or table.find(Settings.OreDropdown, "Current Island") then
                        repeat task.wait()
                            Teleport(v.CFrame * CFrame.new(0,5,0), FarmSettings.Ores.IslandEnabled, nil, true)
                            if LocalPlayer:DistanceFromCharacter(v.Position) <= 20 and not FarmSettings.Ores.OreAura then
                                if not FarmSettings.Ores.BreakUnderOres then
                                    EquipTool(GetBestItem(NonBlockPickaxes))
                                    Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                                else
                                    UnderBlock = GetUnderBlock(v.CFrame)
                                    EquipTool(GetBestItem(NonBlockPickaxes)) 
                                    Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = UnderBlock, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                                end
                            end
                        until not v.Parent or not FarmSettings.Ores.IslandEnabled
                        
                        if FarmSettings.Ores.BreakUnderOres then
                            task.spawn(function()
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = UnderBlock.Name, ["cframe"] = CFrame.new(v.CFrame.X, v.CFrame.Y - 3, v.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                            end)
                        end
                        
                        table.remove(CollectedOres, _)
                        break
                    end
                end
            end
        end

        if not FarmSettings.Ores.IslandEnabled and NewIslandOres then 
            NewIslandOres:Disconnect()
            NewIslandOres = nil
        end
    end)

end, {enabled = FarmSettings.Ores.IslandEnabled})

BreakUnderOres = Ores:Cheat("Checkbox", AddEmoji("Break Block Under", "Sparkle", true), function(State)
    if State and not Whitelisted then
        FarmSettings.Ores.BreakUnderOres = false 
        BreakUnderOres:toggleState(false)
        Notify("Purchase Premium @ discord.gg/SystemExodus <3", 10)
    elseif Whitelisted then
        FarmSettings.Ores.BreakUnderOres = State 
        Notify("Break Block Under (Ores) was", 3, State)
        Save()
    end
end, {enabled = FarmSettings.Ores.BreakUnderOres})

BreakNearOres = Ores:Cheat("Checkbox", AddEmoji("Break Near Ores", "Sparkle", true), function(State)
    FarmSettings.Ores.OreAura = State 
    Save()

    task.spawn(function()
        while FarmSettings.Ores.OreAura  and task.wait() do
            if FarmSettings.Ores.IslandEnabled then
                for _,v in next, GetNearBlocks(20, "rock") do
                    if LocalPlayer:DistanceFromCharacter(v.Position) <= 25 and FarmSettings.Ores.OreAura and FarmSettings.Ores.IslandEnabled and not BlacklistedTerms(v.Name:lower(), BlacklistedOreTerms) and table.find(Settings.OreDropdown, v.Name) or table.find(Settings.OreDropdown, "Current Island") then
                        repeat task.wait()
                            Teleport(v.CFrame * CFrame.new(0,5,0), FarmSettings.Ores.IslandEnabled, nil, true)
                            if not FarmSettings.Ores.BreakUnderOres then
                                EquipTool(GetBestItem(NonBlockPickaxes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                UnderBlock = GetUnderBlock(v.CFrame)
                                EquipTool(GetBestItem(NonBlockPickaxes)) 
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = UnderBlock, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        until not v.Parent or not FarmSettings.Ores.IslandEnabled or not FarmSettings.Ores.OreAura or LocalPlayer:DistanceFromCharacter(v.Position) >= 25
                        
                        if FarmSettings.Ores.BreakUnderOres then
                            task.spawn(function()
                                repeat task.wait()
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = UnderBlock.Name, ["cframe"] = CFrame.new(v.CFrame.X, v.CFrame.Y - 3, v.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                until IsTaken(v.Position) or not FarmSettings.Ores.IslandEnabled or not FarmSettings.Ores.OreAura
                            end)
                        end
                    end
                end
            end
        end
    end)
end, {enabled = FarmSettings.Trees.TreeAura})

--[[ Tree Farming ]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Trees["Tree Dropdown"..v:split("")[1]] = Trees:Cheat("Dropdown", v.." Tree", function(SelectedTree)
        if SelectedTree == "(Select/None)" then 
            Settings.TreeDropdown[ID] = nil 
        else
            Settings.TreeDropdown[ID] = SelectedTree == "Oak Tree" and "tree" or SelectedTree == "All" and "All" or "tree"..SelectedTree:split(" ")[1]
        end
        Save()
    end, {default = Settings.TreeDropdown[ID], options = {"(Select/None)", "Oak Tree", "Pine Tree", "Birch Tree", "Hickory Tree", "Maple Tree", "Spirit Tree", "All"}})
end

ChopTrees = Trees:Cheat("Checkbox", AddEmoji("Chop Trees", "Axe"), function(State)
    FarmSettings.Trees.ChopTrees = State
    OtherSettings.NeedsNoclip = State
    
    Notify("Chop Trees was", 3, State)
    Save()

    task.spawn(function()
        local CollectedTrees = {}
        local NewIslandTrees = GetIsland().Blocks.ChildAdded:Connect(function(Tree)
            if Tree.Name:find("tree") and not BlacklistedTerms(Tree.Name:lower(), BlacklistedTreeTerms) then
                CollectedTrees[#CollectedTrees + 1] = Tree
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:find("tree") and not BlacklistedTerms(v.Name:lower(), BlacklistedTreeTerms) then
                CollectedTrees[#CollectedTrees + 1] = v
            end
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Trees.ChopTrees and task.wait() do
            table.sort(CollectedTrees, function(i, v)
                if i and v then
                    return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
                end
            end)

            local Tree = CollectedTrees[1]
            if Tree and IsTaken(Tree.Position) then
                if FarmSettings.Trees.ChopTrees and table.find(Settings.TreeDropdown, Tree.Name:gsub("%d", "")) or table.find(Settings.TreeDropdown, "All") then
                    repeat task.wait()
                        Teleport(Tree.CFrame * CFrame.new(0,3,0), FarmSettings.Trees.ChopTrees, nil, true)
                        if LocalPlayer:DistanceFromCharacter(Tree.Position) <= 20 and not FarmSettings.Trees.TreeAura then
                            if not FarmSettings.Trees.BreakUnderTrees then
                                EquipTool(GetBestItem(Axes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = Tree, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(BlockPickaxes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetUnderBlock(Tree.CFrame, "grass"), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        end
                    until not Tree.Parent or not FarmSettings.Trees.ChopTrees
                    
                    if FarmSettings.Trees.ReplaceTrees and not FarmSettings.Trees.TreeAura then
                        if not FarmSettings.Trees.BreakUnderTrees then
                            Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..Tree.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = Tree.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                        else
                            task.spawn(function()
                                repeat task.wait()
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "grass", ["cframe"] = CFrame.new(Tree.CFrame.X, Tree.CFrame.Y - 3, Tree.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..Tree.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = Tree.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                until IsTaken(Tree.Position) or not FarmSettings.Trees.ChopTrees
                            end)
                        end
                    end
                end
                table.remove(CollectedTrees, 1)
            else
                table.remove(CollectedTrees, 1)
            end
        end

        if not FarmSettings.Trees.ChopTrees and NewIslandTrees then 
            NewIslandTrees:Disconnect()
            NewIslandTrees = nil 
        end
    end)
end, {enabled = FarmSettings.Trees.ChopTrees})

Trees:Cheat("Checkbox", AddEmoji("Replant Saplings", "Seed", true), function(State)
    FarmSettings.Trees.ReplaceTrees = State
    Notify("Replant Saplings was", 3, State)
    Save()
end, {enabled = FarmSettings.Trees.ReplaceTrees})

BreakUnderTrees = Trees:Cheat("Checkbox", AddEmoji("Break Block Under", "Sparkle", true), function(State)
    if State and not Whitelisted then
        FarmSettings.Trees.BreakUnderTrees = false 
        BreakUnderTrees:toggleState(false)
        Notify("Purchase Premium @ discord.gg/SystemExodus <3", 10)
    elseif Whitelisted then
        FarmSettings.Trees.BreakUnderTrees = State 
        Save()
    end
end, {enabled = FarmSettings.Trees.BreakUnderTrees})

TreeAura = Trees:Cheat("Checkbox", AddEmoji("Break Near Trees", "Sparkle", true), function(State)
    FarmSettings.Trees.TreeAura = State 
    Save()

    task.spawn(function()
        while FarmSettings.Trees.TreeAura and task.wait() do
            if FarmSettings.Trees.ChopTrees then
                for _,v in next, GetNearBlocks(20, "tree") do
                    if LocalPlayer:DistanceFromCharacter(v.Position) <= 25 and FarmSettings.Trees.TreeAura and FarmSettings.Trees.ChopTrees and not BlacklistedTerms(v.Name:lower(), BlacklistedTreeTerms) and table.find(Settings.TreeDropdown, v.Name:gsub("%d", "")) or table.find(Settings.TreeDropdown, "All") then
                        repeat task.wait()
                            if not FarmSettings.Trees.BreakUnderTrees then
                                EquipTool(GetBestItem(Axes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(BlockPickaxes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetUnderBlock(v.CFrame, "grass"), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        until not v.Parent or not FarmSettings.Trees.TreeAura or not FarmSettings.Trees.ChopTrees or LocalPlayer:DistanceFromCharacter(v.Position) >= 25

                        if FarmSettings.Trees.ReplaceTrees then
                            if not FarmSettings.Trees.BreakUnderTrees then
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..v.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = v.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                            else
                                task.spawn(function()
                                    repeat task.wait()
                                        Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "grass", ["cframe"] = CFrame.new(v.CFrame.X, v.CFrame.Y - 3, v.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                        Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..v.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = v.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                    until IsTaken(v.Position) or not FarmSettings.Trees.ChopTrees or not FarmSettings.Trees.TreeAura
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end, {enabled = FarmSettings.Trees.TreeAura})


--[[ Collect Totem Items ]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Totems["Totem Dropdown"..v:split("")[1]] = Totems:Cheat("Dropdown", v.." Totem", function(SelectedTotem)
        if SelectedTotem == "(Select/None)" then 
            Settings.TotemDropdown[ID] = nil 
        else
            Settings.TotemDropdown[ID] = "totem"..SelectedTotem:split(" ")[1]
        end
        Save()
    end, {default = Settings.TotemDropdown[ID], options = {"(Select/None)", "Clay Totem", "Stone Totem", "Coal Totem", "Iron Totem", "Marble Totem", "Slate Totem", "Aquamarine Totem", "Sandstone Totem", "Obsidian Totem", "Wheat Totem", "Tomato Totem", "Potato Totem", "Carrot Totem", "Radish Totem", "Onion Totem", "Pumpkin Totem", "Melon Totem", "Starfruit Totem"}})
end

TotemCollectItems = Totems:Cheat("Checkbox", AddEmoji("Collect Totem Items", "Box"), function(State)
    FarmSettings.Totems.CollectItems = State
    OtherSettings.NeedsNoclip = State

    Notify("Collect Totem Items was", 3, State)
    Save()
    
    task.spawn(function()
        local CollectedTotems = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:find("totem") and not table.find(CollectedTotems, v) then
                CollectedTotems[#CollectedTotems + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Totems.CollectItems and task.wait() do
            for _,x in next, Settings.TotemDropdown do
                if x ~= "(Select/None)" and x ~= false and x ~= nil then
                    for _,y in next, CollectedTotems do
                        if ((x == "All" and y.Name:find("totem")) or (x ~= "All" and y.Name == x)) and y:FindFirstChild("WorkerContents") and #y.WorkerContents:GetChildren() > 0 then
                            if not FarmSettings.Totems.CollectItems then break end
                            repeat task.wait()
                                Teleport(y.CFrame * CFrame.new(0, 3, 0), nil, nil, true)
                                for _,z in next, y.WorkerContents:GetChildren() do
                                    task.spawn(function()
                                        ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = z, [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                                    end)
                                end
                            until not y.Parent or not y:FindFirstChild("WorkerContents") or #y.WorkerContents:GetChildren() == 0 or not FarmSettings.Totems.CollectItems
                        end
                    end
                end
            end
        end
    end)
end, {enabled = FarmSettings.Totems.CollectItems})


--[[ Flower Farming ]]--
local NeverExecutedBefore2 = false
WaterFertile = Flowers:Cheat("Checkbox", AddEmoji("Water Fertile", "Droplet"), function(State)
    FarmSettings.Flowers.WaterFertile = State
    OtherSettings.NeedsNoclip = State

    Notify("Water Fertile was", 3, State)
    Save()

    task.spawn(function()
        if FarmSettings.Flowers.WaterFertile and not NeverExecutedBefore2 then
            GetFlowers = FlowerHandler.new()
            NeverExecutedBefore2 = true
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Flowers.WaterFertile and task.wait() do

            local SelectedFlower = GetFlowers:Get("Flowerables")
            table.sort(SelectedFlower, function(i, v)
                if i and v then
                    return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
                end
            end)

            if SelectedFlower[1] then
                Teleport(SelectedFlower[1].CFrame, nil, nil, true)
                for _,v in next, GetNearWaterables(30) do
                    task.spawn(function()
                        EquipTool(LocalPlayer.Backpack:FindFirstChild("wateringCan") or Character:FindFirstChild("wateringCan"))
                        Remotes["CLIENT_WATER_BLOCK"]:InvokeServer({["block"] = v})
                    end)
                    if math.random(1,20) == 1 then
                        task.wait()
                    end
                end
            end
        end
    end)

end, {enabled = FarmSettings.Flowers.WaterFertile})


CollectFertile = Flowers:Cheat("Checkbox", AddEmoji("Collect Fertile Flowers", "Flower"), function(State)
    FarmSettings.Flowers.CollectFertile = State

    Notify("Collect Fertile was", 3, State)
    Save()

    task.spawn(function()
        local CollectedFlowers = {}
        local NewIslandFlowers = GetIsland().Blocks.ChildAdded:Connect(function(Flower)
            if Flower.Name:lower():find("fertile") and Flower.Name:lower():find("flower") and not Flower.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = Flower
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:lower():find("fertile") and v.Name:lower():find("flower") and not v.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = v
            end
        end

        while task.wait() and FarmSettings.Flowers.CollectFertile do
            for _,v in next, CollectedFlowers do
                task.spawn(function()
                    Remotes["client_request_1"]:InvokeServer({["flower"] = v})
                end)
                task.wait()
            end
        end

        if not State and NewIslandFlowers then 
            NewIslandFlowers:Disconnect()
            NewIslandFlowers = nil 
        end
    end)
end, {enabled = FarmSettings.Flowers.CollectFertile})


CollectNonFertile = Flowers:Cheat("Checkbox", AddEmoji("Collect non-Fertile Flowers", "Flower"), function(State)
    FarmSettings.Flowers.CollectNonFertile = State

    Notify("Collect non-Fertile was", 3, State)
    Save()

    task.spawn(function()
        local CollectedFlowers = {}
        local NewIslandFlowers = GetIsland().Blocks.ChildAdded:Connect(function(Flower)
            if not Flower.Name:lower():find("fertile") and Flower.Name:lower():find("flower") and not Flower.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = Flower
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if not v.Name:lower():find("fertile") and v.Name:lower():find("flower") and not v.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = v
            end
        end

        while task.wait() and FarmSettings.Flowers.CollectNonFertile do
            for _,v in next, CollectedFlowers do
                task.spawn(function()
                    Remotes["client_request_1"]:InvokeServer({["flower"] = v})
                end)
                task.wait()
            end
        end

        if not State and NewIslandFlowers then 
            NewIslandFlowers:Disconnect()
            NewIslandFlowers = nil 
        end
    end)
end, {enabled = FarmSettings.Flowers.CollectNonFertile})


--[[ Mob Farming ]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    NormalMobs["Mob Dropdown"..v:split("")[1]] = NormalMobs:Cheat("Dropdown", v.." Mob", function(SelectedMob)
        if SelectedMob == "(Select/None)" then 
            Settings.MobDropdown[ID] = nil 
        else
            Settings.MobDropdown[ID] = SelectedMob == "Gingerbread" and "evilGingerbread" or SelectedMob == "Slimes" and "slime" or SelectedMob == "Buffalos" and "buffalkor" or SelectedMob == "Wizards" and "wizardLizard" or SelectedMob == "Skorps" and "skorp" or SelectedMob == "Crabs" and "hostileCrab" or SelectedMob == "Skeletons" and "skeletonPirate" or SelectedMob == "Magma Blobs" and "magmaBlob" or SelectedMob == "Magma Golem" and "magmaGolem" or SelectedMob == "Void Dogs" and "voidDog"
        end
        Save()
    end, {default = Settings.MobDropdown[ID], options = {"(Select/None)", "Slimes", "Buffalos", "Wizards", "Skorps", "Crabs", "Skeletons", "Void Dogs", "Magma Blobs", "Magma Golem"}})
end

local Mobs = {}
MobFarming = NormalMobs:Cheat("Checkbox", AddEmoji("Farm Mobs", "SkullCross"), function(State)
    FarmSettings.Creatures.MobFarming = State
    Settings.Other.NeedsNoclip = State
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    InitialY = nil

    Notify("Mob Farming was", 3, State)
    Save()
    
    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab", 10)
        end

        if not Keys.MobArgName or not Keys.MobArgCode then
            repeat task.wait() 
                if not Keys.MobArgName or not Keys.MobArgCode then
                    EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                    GetRemoteKeys("Mobs")
                    task.wait(1)
                end
            until Keys.MobArgName and Keys.MobArgCode
        end

        for _,v in next, Settings.MobDropdown do
            if FarmSettings.Creatures.MobFarming and v ~= "skorp" and ((not Entities:FindFirstChild(v) or not Entities[v]:FindFirstChild("HumanoidRootPart")) or (v == "skeletonPirate" or v == "hostileCrab")) then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                local Zone = MobPortalTPs[v]
                if Zone == "UsePortal" then
                    Notify("Please teleport to the area to farm this mob.", 10)
                elseif Zone == "UseRemote" then
                    Remotes["TravelPirateIsland"]:FireServer(false)
                else
                    if Places["PrivateServer"] then
                        IslandTeleport(Zone)
                    end
                end
            elseif FarmSettings.Creatures.MobFarming and v == "skorp" and (not Entities:FindFirstChild("skorpIron") or not Entities:FindFirstChild("skorpGold") or not Entities:FindFirstChild("skorpRuby")) then
                if Places["PrivateServer"] then
                    IslandTeleport(MobPortalTPs["skorp"])
                end
            end
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.MobFarming and task.wait() do
            Mobs = {}
            for _,v in next, Entities:GetChildren() do
                if (table.find(Settings.MobDropdown, v.Name) or (table.find(Settings.MobDropdown, "skorp") and v.Name:find("skorp"))) and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.MobFarming then
                    table.insert(Mobs, v)
                end
            end

            table.sort(Mobs, function(i, v)
                return (HumanoidRootPart.Position - Vector3.new(i.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, i.HumanoidRootPart.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, v.HumanoidRootPart.Position.Z)).magnitude
            end)
            
            CurrentMob = Mobs[1]
            if not IsMobDead(CurrentMob) then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                if not FarmSettings.Creatures.UseBook and not FarmSettings.Creatures.UseBow then
                    if Places["PrivateServer"] then
                        IslandTeleport(MobPortalTPs[CurrentMob.Name:find("skorp") and "skorp" or CurrentMob.Name])
                    end
                    
                    task.spawn(function()
                        repeat task.wait()
                            if not IsMobDead(CurrentMob) then
                                --[[if not InitialY then
                                    InitialY = CurrentMob.HumanoidRootPart.CFrame.Y
                                end]]--
                                --[[if (OtherSettings.AntiAir and (not CurrentMob:FindFirstChild("Humanoid") or (CurrentMob:FindFirstChild("Humanoid") and CurrentMob.Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and CurrentMob.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and CurrentMob.Humanoid:GetState() ~= Enum.HumanoidStateType.FallingDown))) or not OtherSettings.AntiAir then
                                    if CurrentMob:FindFirstChild("Humanoid") then
                                        print(CurrentMob.Humanoid:GetState())
                                    end
                                    Teleport(CurrentMob.HumanoidRootPart.CFrame * CFrame.new(0,-12,0), FarmSettings.Creatures.MobFarming)
                                else
                                    if OtherSettings.AntiAir then
                                        task.wait(0.8)
                                    end
                                end]]--
                                Teleport(CurrentMob.HumanoidRootPart.CFrame * CFrame.new(0,-11,0), FarmSettings.Creatures.MobFarming)
                            end
                        until IsMobDead(CurrentMob) or not FarmSettings.Creatures.MobFarming
                        InitialY = nil
                    end)

                    repeat task.wait()
                        if not IsMobDead(CurrentMob) and LocalPlayer:DistanceFromCharacter(CurrentMob.HumanoidRootPart.Position) <= 25 then
                            EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            Remotes[SwingSword]:FireServer("", {{["hitUnit"] = CurrentMob, [Keys.MobArgName] = Keys.MobArgCode}})
                            
                            task.wait(0.1)
                            if not IsMobDead(CurrentMob) and FarmSettings.Creatures.Sword ~= "rageblade" then
                                task.wait(0.4) 
                            end
                        end
                    until IsMobDead(CurrentMob) or not FarmSettings.Creatures.MobFarming

                end
            end
        end
    end)
end, {enabled = FarmSettings.Creatures.MobFarming})

--[[Kill Aura]]--
KillAura = NormalMobs:Cheat("Checkbox", AddEmoji("Kill Aura", "Sparkle"), function(State)
    FarmSettings.Creatures.KillAura = State

    Notify("Kill Aura was", 3, State)
    Save()

    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab", 10)
        end

        if not Keys.MobArgName or not Keys.MobArgCode then
            repeat task.wait() 
                if not Keys.MobArgName or not Keys.MobArgCode then
                    EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                    GetRemoteKeys("Mobs")
                    task.wait(1)
                end
            until Keys.MobArgName and Keys.MobArgCode
        end
        
        while FarmSettings.Creatures.KillAura and task.wait() do
            for _,v in next, Entities:GetChildren() do
                if v:FindFirstChild("HumanoidRootPart") and LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position) <= 25 then
                    task.spawn(function()
                        EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        Remotes[SwingSword]:FireServer("", {{["hitUnit"] = v, [Keys.MobArgName] = Keys.MobArgCode}})
                    end)
                    
                    task.wait(0.1)
                    if not IsMobDead(CurrentMob) and FarmSettings.Creatures.Sword ~= "rageblade" then
                        task.wait(0.4) 
                    end
                end
            end
        end
    end)
end)


--[[ Boss Farming ]]--
for _,v in next, {"1st"} do 
    local ID = tonumber(v:split("")[1])
    Bosses["Boss Dropdown"..v:split("")[1]] = Bosses:Cheat("Dropdown", v.." Boss", function(SelectedBoss)
        if SelectedBoss == "(Select/None)" then 
            Settings.BossDropdown[ID] = nil 
        else
            Settings.BossDropdown[ID] = SelectedBoss == "Slime King" and "slimeKing" or SelectedBoss == "Slime Queen" and "slimeQueen" or SelectedBoss == "Wizard Boss" and "wizardBoss" or SelectedBoss == "Bhaa Boss" and "desertBoss" or SelectedBoss == "Kor Boss" and "golem" or SelectedBoss == "Dragon Boss" and "magmaDragon" or SelectedBoss == "Deer Boss" and "deerBoss" or SelectedBoss == "Void Serpent" and "voidSerpent" or SelectedBoss == "Azarathian Serpent" and "skorpSerpent"
        end
        Save()
    end, {default = Settings.BossDropdown[ID], options = {"(Select/None)", "Slime King", "Slime Queen", "Wizard Boss", "Bhaa Boss", "Kor Boss", "Dragon Boss", "Deer Boss", "Void Serpent", "Azarathian Serpent"}})
end

BossFarming = Bosses:Cheat("Checkbox", AddEmoji("Farm Bosses", "SkullCross"), function(State)
    FarmSettings.Creatures.BossFarming = State
    Settings.Other.NeedsNoclip = State
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    AlreadyActivated = false

    Notify("Boss Farming was", 3, State)
    Save()

    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab", 10)
        end

        repeat task.wait() 
            if not Keys.MobArgName or not Keys.MobArgCode then
                EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                GetRemoteKeys("Mobs")
                task.wait(1)
            end
        until Keys.MobArgName and Keys.MobArgCode
        
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.BossFarming and task.wait() do

            for _,v in next, Settings.BossDropdown do
                local Zone = BossPortalTP[v]
                if Zone == "UsePortal" then
                    return Notify("Please teleport to the area to farm this boss.", 3)
                else
                    if Places["PrivateServer"] then
                        IslandTeleport(Zone)
                    end
                end
                local CurrentTrigger = BossSpawnName[v] and WildTriggers:FindFirstChild(BossSpawnName[v])
                if not CurrentTrigger and FarmSettings.Creatures.BossFarming and BossSpawnName[v] then
                    Teleport(BossSpawnCoords[v])
                    WildTriggers:WaitForChild(BossSpawnName[v])
                end

                if FarmSettings.Creatures.BossFarming and (Entities:FindFirstChild(v) or (CurrentTrigger and CalculateTokens(v))) then
                    if not Entities:FindFirstChild(v) then
                        Teleport(BossSpawnCoords[v])
                    end

                    OldCameraCFrame = workspace.CurrentCamera.CFrame
                    if CurrentTrigger then
                        repeat task.wait()
                            if LocalPlayer:DistanceFromCharacter(CurrentTrigger.Position) <= 20 then
                                workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                                workspace.CurrentCamera.CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(0, 70, 0), CurrentTrigger.Position)
                                if (CurrentTrigger.CanBeTriggered.Value and FarmSettings.Creatures.BossFarming) then
                                    fireproximityprompt(CurrentTrigger.ProximityPrompt, 1, true)
                                    if v.Name == "golem" then
                                        task.wait(0.5)
                                    end
                                end
                            end
                        until Entities:FindFirstChild(v) or not FarmSettings.Creatures.BossFarming
                        workspace.CurrentCamera.CFrame = OldCameraCFrame
                        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    end
                    
                    local Boss = Entities:WaitForChild(v)
                    Boss:WaitForChild("HumanoidRootPart")

                    task.spawn(function()
                        repeat task.wait()
                            if not IsMobDead(Boss) and FarmSettings.Creatures.BossFarming then
                                if (OtherSettings.AntiAir and Boss.Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and Boss.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and Boss.Humanoid:GetState() ~= Enum.HumanoidStateType.Landed and Boss.Humanoid:GetState() ~= Enum.HumanoidStateType.FallingDown) or not OtherSettings.AntiAir then
                                    Teleport(Boss.HumanoidRootPart.CFrame * (v == "slimeKing" and CFrame.new(0, -14, 0) or CFrame.new(0, 12, 0)))
                                else
                                    if OtherSettings.AntiAir then
                                        task.wait(0.6)
                                    end
                                end
                            end
                        until IsMobDead(Boss) or not FarmSettings.Creatures.BossFarming
                    end)

                    repeat task.wait()
                        if not IsMobDead(Boss) and LocalPlayer:DistanceFromCharacter(Boss.HumanoidRootPart.Position) <= 25 then
                            EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            Remotes[SwingSword]:FireServer("", {{["hitUnit"] = Boss, [Keys.MobArgName] = Keys.MobArgCode}})
                            
                            task.wait(0.1)
                            if not IsMobDead(Boss) and FarmSettings.Creatures.Sword ~= "rageblade" then
                                task.wait(0.4) 
                            end
                        end
                    until IsMobDead(Boss) or not FarmSettings.Creatures.BossFarming
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    
                    if v == "golem" and FarmSettings.Creatures.KorMineOres and FarmSettings.Creatures.BossFarming then
                        task.wait(2)
                        local OldEquipped = Character:FindFirstChildWhichIsA("Tool") 
                        for _,z in next, workspace.WildernessBlocks:GetChildren() do
                            if z.Name:lower():find("diamond") and FarmSettings.Creatures.BossFarming then
                                repeat task.wait()
                                    EquipTool(GetBestItem(Pickaxes))
                                    Teleport(z.CFrame * CFrame.new(0, -5, 0))
                                    Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = z, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                                until not z.Parent or not FarmSettings.Creatures.BossFarming
                            end
                        end
                        EquipTool(OldEquipped)
                    end

                end
            end
        end
    end)
end, {enabled = FarmSettings.Creatures.BossFarming})  

Bosses:Cheat("Checkbox", AddEmoji("Mine Kor Ores", "Pickaxe", true), function(State)
    FarmSettings.Creatures.KorMineOres = State 
    Save()
end, {enabled = FarmSettings.Creatures.KorMineOres})    

























local function Noclip()
    for _,v in next, LocalPlayer.Character:GetDescendants() do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

if not HumanoidRootPart:FindFirstChild("LinearVelocity") and not ReplicatedStorage:FindFirstChild("LinearVelocity") then
    Attachment0 = Instance.new("Attachment", HumanoidRootPart)
    LinearVelocity = Instance.new("LinearVelocity", HumanoidRootPart)
    LinearVelocity.MaxForce = math.huge
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    LinearVelocity.Attachment0 = HumanoidRootPart.Attachment
else
    LinearVelocity = HumanoidRootPart:FindFirstChild("LinearVelocity") or ReplicatedStorage:FindFirstChild("LinearVelocity")
end

task.spawn(function()
    Velocity = nil
    NoclipVariable = nil
    while task.wait() do
        if Settings.Other.NeedsNoclip then
            if not NoclipVariable then
                NoclipVariable = game.RunService.Stepped:Connect(Noclip)
            end
            LinearVelocity.Parent = HumanoidRootPart
        else
            LinearVelocity.Parent = ReplicatedStorage
            if NoclipVariable then
                NoclipVariable:Disconnect()
                NoclipVariable = nil
            end
        end
    end
end)