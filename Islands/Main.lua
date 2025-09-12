--[[Wait 4 Game]]--
if not game:IsLoaded() then 
    game.Loaded:Wait()
end 
workspace:WaitForChild("Islands")

--[[Variables]]--
local request = request or syn and syn.request or http and http.request or http_request or httprequest
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local CollectionService = game:GetService("CollectionService")
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character.Humanoid
local HumanoidRootPart = Character.HumanoidRootPart
local ReplicatedStorage = game.ReplicatedStorage
local RemoteStorage = game.ReplicatedStorage.TS.remotes
local Remotes = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
local DefaultSettings = {}
local Sectors = {}
local Categories = {}

--[[Search Universe]]--
if AssetService then
    UniversePlaces = {}
    for _,v in next, AssetService:GetGamePlacesAsync():GetCurrentPage() do
        UniversePlaces[#UniversePlaces + 1] = v.PlaceId
    end
    if not table.find(UniversePlaces, 4872321990) then 
        LocalPlayer:Kick("[Islands UI]: User not in Islands.")
    end
end

--[[Luraph Functions]]--
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
end

--[[Remote Updates]]--
local TS = ReplicatedStorage:FindFirstChild("TS")
if not TS or not TS:FindFirstChild("remotes") then
    return LocalPlayer:Kick("[Islands UI]: AC update detected, UI down until further notice! (IFP)")
elseif #TS:FindFirstChild("remotes"):GetChildren() >= 26 then
    return LocalPlayer:Kick("[Islands UI]: AC update detected, UI down until further notice! ("..#TS:FindFirstChild("remotes"):GetChildren()..")")
end


--[[UI Stuff]]--
if UI then 
    UI:Destroy()
end
getgenv().TextXAlignmentUI = "Left"
local Finity, Notification, Version = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/f103405308832d3ba6e0df27d6182a96.lua"))()
local Version = Version:Get("Islands")

--local yolo = loadstring(game:HttpGet("https://system-exodus.com/scripts/Islands/Temp/YolosLib.lua", true))() 
--local NotifyUI = loadstring(game:HttpGet("https://system-exodus.com/scripts/Islands/Temp/HotNotify.lua", true))()
--local Version = loadstring(game:HttpGet("https://system-exodus.com/scripts/Islands/Temp/VersionChecker.lua", true))("Islands"):Get()

--[[Create new Folders]]--
local Folders = {"System Exodus", "System Exodus/Islands", "System Exodus/Islands/SaveFiles", "System Exodus/Islands/Schematica", "System Exodus/Islands/Schematica/BuildMaterialSaves", "System Exodus/Islands/UserItemInfoSaves"}
for _,v in next, Folders do
    if not isfolder(v) then
        makefolder(v)
    end
end

--[[Get Remote Names]]--
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

--[[Get Remote Keys]]--
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

--[[Config Settings]]--
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
        SellCrops = false,
        SellSeasonal = false,
        FarmWildCrops = false,
        SelectedCrop = "(Select/None)"
    }, 
    Ores = {
        HubEnabled = false,
        IslandEnabled = false
    },
    Trees = {
        ChopTrees = false,
        ReplaceTrees = false,
        KYSGrass = false
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
    InstantTeleport = false
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
MoreSettings = {}
MoreSettings.Schematica = {}

--[[Return User Whitelist]]--
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

--[[Save Settings]]--
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
local function Save()
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

--[[Places]]--
local Places = {}
Places[4872321990] = "MainIsland"
Places[5899156129] = "OnlineHub"
Places[5626342417] = "OnlineIsland"
Places[7456800858] = "OnlineUnderworld"
Places[9501318975] = "WildIslands"
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

--[[Setting Variables]]--
local FarmSettings = Settings.Farming
local MachinerySettings = Settings.Machinery
local MiscSettings = Settings.Miscellaneous
local WorldEditSettings = Settings.WorldEdit
local OtherSettings = Settings.Other


--local CropTable = {"(Select/None)", "Wheat", "Tomato", "Potato", "Carrot", "Onion", "Cactus", "Spinach", "Pumpkin", "Radish", "Chili", "Spirit", "Starfruit", "Melon", "Rice", "Seaweed", "Candy Cane", "Pineapple", "Dragonfruit", "Void Parasite"}
--local TreeBlacklist = {"treecoconut", "treelemon", "treeapple", "treeorange", "treeavocado", "treekiwi", "treeplum", "furniture", "street", "banner", "cutter", "shaker", "cut", "light", "decorated", "machine", "sapling"}
--local NormalTrees = {"treebirch", "treepine", "treehickory", "treemaple", "treespirit", "tree"}
--local Bows = {"bow3", "bow2", "bow1"}
--local SpellBooks = {"spellbookAquamarine", "spellbook"}
local Pickaxes = {"voidMattock", "opalPickaxe", "diamondPickaxe", "gildedSteelPickaxe", "ironPickaxe", "stonePickaxe", "woodPickaxe"}
local Pickaxes2 = {"gregsHammer", "voidMattock", "opalPickaxe", "diamondPickaxe", "gildedSteelPickaxe", "ironPickaxe", "stonePickaxe", "woodPickaxe"}
local Axes = {"voidMattock", "opalAxe", "diamondAxe", "gildedSteelAxe", "ironAxe", "stoneAxe", "woodAxe"}
local Shovels = {"shovelWinter", "shovelIron", "shovelStone", "shovelWood"}
local FishingRods = {"fishingRodIron", "fishingRod"}
local CropList = {"wheat", "tomato", "potato", "carrot", "onion", "cactus", "spinach", "pumpkin", "radish", "chili", "spirit", "starfruit", "melon", "rice", "seaweed", "candyCane", "pineapple", "dragonfruit", "grapeVine", "voidParasite"}

--[[Equip Tool]]--
ClientInventoryService = require(LocalPlayer.PlayerScripts.TS.ui.inventory["client-inventory-service"]).ClientInventoryService 
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

--[[Fire Proixmity Prompt]]--
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
        error("userdata<ProximityPrompt> expected")
    end
end

--[[Find If Taken]]--
local function IsTaken(Position, BlockName)
    local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
    for _,v in next, Parts do
        if v.Parent and v.Parent.Name == "Blocks" then
            if BlockName and v.Name == BlockName then
                return true
            else
                return true
            end
        end
    end
    return false
end

--[[Find Block]]--
local function IsTaken2(Position)
    local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
    for _,v in next, Parts do
        if v.Parent and v.Parent.Name == "Blocks" then
            return v
        end
    end
    return nil
end

--[[Create QR Code]]--
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

--[[Destroy Old Models]]--
for _,v in next, workspace:GetChildren() do
    if v.Name:find("Schematic") then
        v:Destroy()
    end
end
for _,v in next, game.CoreGui:GetChildren() do
    if v.Name == "Handles" then
        v:Destroy()
    end
end

--[[Handles / Box]]--
local Mouse = LocalPlayer:GetMouse()
local Model = Instance.new("Model")
Model.Name = "SchematicOutline"

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

--[[Mouse.Button1Down:Connect(function()
    if Mouse.Target then
        if WorldEditSettings.ChangingPosition then
            if Mouse.Target.Parent.Name == "Blocks" or Mouse.Target.Parent.Parent.Name == "Blocks" then
                local Part = Mouse.Target.Parent.Name == "Blocks" and Mouse.Target or Mouse.Target.Parent.Parent.Name == "Blocks" and Mouse.Target.Parent
                Handles.Visible = WorldEditSettings.ShowBuild
                if Indicator.Parent and Indicator.Parent.ClassName == "Model" then
                    Indicator.Parent:SetPrimaryPartCFrame(CFrame.new(Part.Position))
                else
                    Indicator.CFrame = CFrame.new(Part.Position)
                end
            end
        end
    end
end)]]--

--[[Get Islands]]--
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

local function GetNearestIsland()
    for _,v in next, workspace.Islands:GetChildren() do 
        if v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) <= 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) <= 1000 then 
            return v
        elseif v:FindFirstChild("Root") and math.abs(v.PrimaryPart.Position.X - Character:WaitForChild("HumanoidRootPart").Position.X) > 1000 and math.abs(v.PrimaryPart.Position.Z - Character:WaitForChild("HumanoidRootPart").Position.Z) > 1000 and v.Owners:FindFirstChild(""..LocalPlayer.UserId) then
            return v
        end 
    end 
end

--[[Get Item Names]]--
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

local function GetDisplayName(Item)
    for _,v in next, ReplicatedStorage.Tools:GetChildren() do 
        if v.Name:lower() == Item:lower() and v:FindFirstChild("DisplayName") then 
            return v.DisplayName.Value 
        end 
    end 
end

--[[Taken Block]]--
local function IsTaken(Position)
    local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
    for _,v in next, Parts do
        if v.Parent and v.Parent.Name == "Blocks" then
            return true
        end
    end
    return false
end

--[[Get Near Blocks]]--
local function GetNearBlocks(Block, Range)
    local Blocks = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Range, Range, Range), HumanoidRootPart.Position + Vector3.new(Range, Range, Range)), nil, math.huge) do
        if v.Name:find(Block) and not v.Name:find("rasp") then
            table.insert(Blocks, v)
        end
    end
    return Blocks
end

local function GetNearBlocks2(Range)
    local Blocks = {}
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Range, Range, Range), HumanoidRootPart.Position + Vector3.new(Range, Range, Range)), nil, math.huge) do
        if v.Name:find("tree") then
            table.insert(Blocks, v)
        end
    end
    return Blocks
end

local function FindNearBlock(Range)
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Range, Range, Range), HumanoidRootPart.Position + Vector3.new(Range, Range, Range)), nil, math.huge) do
        if tostring(v.Parent) == "Blocks" and v.Size == Vector3.new(3,3,3) then
            return v
        end
    end
end

--[[Get Best Item]]--
local function GetBestItem(item)
    for _,v in next, item do
        if Character:FindFirstChild(v) or LocalPlayer.Backpack:FindFirstChild(v) then
            return Character:FindFirstChild(v) or LocalPlayer.Backpack:FindFirstChild(v)
        end
    end
    return nil
end

local function FindItem(Item)
    if Character:FindFirstChild(Item) or LocalPlayer.Backpack:FindFirstChild(Item) then
        return true
    end
    return false
end

--[[Get Closest Blocks]]--
local function GetClosestBlock(Area, CFrame)
    local FoundBlock
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(HumanoidRootPart.Position - Vector3.new(Area, Area, Area), HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), nil, math.huge) do
        if math.floor(v.CFrame.X + 0.5) == math.floor(CFrame.X + 0.5) and (math.floor(v.CFrame.Y + 0.5)+3 or math.floor(v.CFrame.Y-1 + 0.5)+3 or math.floor(v.CFrame.Y+1 + 0.5)+1) == math.floor(CFrame.Y + 0.5) and math.floor(v.CFrame.Z + 0.5) == math.floor(CFrame.Z + 0.5) then
            FoundBlock = v
            break
        end
    end
    return FoundBlock
end

local function GetClosestBlock2(CFrame)
    local FoundBlock
    local Position = Vector3.new(CFrame.X, CFrame.Y-3, CFrame.Z)
    for _,v in next, workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge) do
        if v.Name == "grass" then
            FoundBlock = v
            break
        end
    end
    return FoundBlock
end

--[[Bad Trees]]--
local TreeBlacklist = {"treecoconut", "treelemon", "treeapple", "treeorange", "treeavocado", "treekiwi", "treeplum", "furniture", "street", "banner", "cutter", "shaker", "cut", "light", "decorated", "machine", "sapling"}
local function BadTrees(Tree, Blacklist) 
    if table.find(Blacklist, Tree) then
        return true
    end
    return false
end

--[[Coords]]--
local GetCoords = {
    ["hub-slime"] = Vector3.new(313, 26, -1073),
    ["slime-hub"] = Vector3.new(690, 195, -224),
    ["buffalkor-slime"] = Vector3.new(1178, 377, 101),
    ["wizard-buffalkor"] = Vector3.new(1178, 377, 101),
    ["diamond_mine-buffalkor"] = Vector3.new(2475, 239, 890),
    ["spirit-slime"] = Vector3.new(30, 290, 857),
    ["desert-wizard"] = Vector3.new(1474, 335, -875)
}

--[[TP Hub / Island]]--
local function Hub(PersonalIsland)
    local Island = GetIsland().Blocks
    if Island:FindFirstChild("portalToSpawn") then
        Remotes["CLIENT_VISIT_ISLAND_REQUEST"]:InvokeServer({["island"] = workspace.Islands[Island.Parent.Name]})
    end
end

--[[ Island Teleporting ]]--
local LastTeleported = nil
local function IslandTeleport(Island, Mob)
    local Portals = {}
    for _,v in next, workspace.WildernessBlocks:GetChildren() do
        if v.Name == "portal" and v:FindFirstChild("WildDestination") then
            local WildDestination = tostring(v.WildDestination.Value)
            table.insert(Portals, WildDestination)
            if Island == WildDestination then
                Distance = (HumanoidRootPart.Position - GetCoords[Island]).magnitude
                if Distance >= 2000 or LastTeleported ~= Island then
                    local OldPosition = HumanoidRootPart.Position 
                    local Timer = os.time()
                    OtherSettings.NeedsNoclip = false
                    repeat task.wait()
                        firetouchinterest(HumanoidRootPart, v.Frame, 0)
                        firetouchinterest(HumanoidRootPart, v.Frame, 1)
                    until (HumanoidRootPart.Position - OldPosition).magnitude >= 10 or os.time()-Timer >= 5
                    task.wait(0.5)
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

--[[XP Related]]--
local function XP()
    local ServerToClientEventId = require(ReplicatedStorage.TS.event["server-event-id"]).ServerToClientEventId
    local SpawnExperienceEvent = Remotes["server_event_"..ServerToClientEventId.SPAWN_EXPERIENCE_ORBS]
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

--[[Get Near Grass]]--
local function GetNearGrass(Area)
    local Grass = {}
    for _,v in next, game.Workspace:FindPartsInRegion3(Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(Area, Area, Area), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), game.Players.LocalPlayer.Character, math.huge) do
        if v.Parent.Name == "grass" then
            table.insert(Grass, v.Parent)
        end
    end
    return Grass
end

--[[Get Near Chests]]--
local function GetNearChests(Area, NeedItems)
    local Chests = {}
    for _,v in next, game.Workspace:FindPartsInRegion3(Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(Area, Area, Area), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), game.Players.LocalPlayer.Character, math.huge) do
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

--[[Get Craft Items]]--
local function GetCraftItems(Workbench)
    local CraftItems = {}
    local CraftMeta = require(game.ReplicatedStorage.TS.crafting["workbench-meta"])
    for _,v in pairs(CraftMeta["WorkbenchMeta"][Workbench]["canCraft"]) do
        table.insert(CraftItems, GetDisplayName(v))
    end
    return CraftItems
end

--[[Get Near Items]]--
local function GetNearItems(Area)
    local items = {}
    for _,v in next, game.Workspace:FindPartsInRegion3(Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(Area, Area, Area), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), game.Players.LocalPlayer.Character, math.huge) do
        if v.Parent:IsA("Tool") then
            table.insert(items, v.Parent)
        end
    end
    return items
end

--[[Get Near Soil]]--
local function GetNearSoil(Area)
    local Soil = {}
    for _,v in next, game.Workspace:FindPartsInRegion3(Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(Area, Area, Area), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(Area, Area, Area)), game.Players.LocalPlayer.Character, math.huge) do
        if v.Name == "soil" then
            table.insert(Soil, v)
        end
    end
    return Soil
end

--[[Get Mob TPs]]--
local function MobZoneTP(Mob)
    return Mob == "slime" and "slime-hub" or Mob == "buffalkor" and "buffalkor-slime" or Mob == "wizardLizard" and "wizard-buffalkor" or (Mob == "hostileCrab" or Mob == "skeletonPirate") and "UseRemote" or (Mob == "magmaBlob" or Mob == "magmaGolem") and "UsePortal" or Mob == "voidDog" and "UsePortal" or (Mob == "skorp" or Mob == "skorpIron" or Mob == "skorpGold" or Mob == "skorpRuby") and "desert-wizard"
end

--[[Get Boss TPs]]--
local function BossZoneTP(Mob)
    return (Mob == "slimeKing" or Mob == "slimeQueen") and "slime-hub" or Mob == "wizardBoss" and "wizard-buffalkor" or (Mob == "desertBoss" or Mob == "skorpSerpent") and "desert-wizard" or (Mob == "golem"  or Mob == "magmaDragon" or Mob == "deerBoss"  or Mob == "voidSerpent") and "UsePortal"
end

--[[Return if Dead]]--
local function FindIfDead(Mob)
    if Mob:FindFirstChild("HumanoidRootPart") then
        if Mob:FindFirstChild("IsDead") and Mob.IsDead.Value or (Mob:FindFirstChild("ActiveAnimations") and (Mob.ActiveAnimations:FindFirstChild("7370460811") or Mob.ActiveAnimations:FindFirstChild("7441173000"))) then 
            return false
        end
        return true
    end
    return false
end

--[[Mod Numbers]]--
local function Mod(Number, Amount)
    if typeof(Number) == "number" then
        if Number < 0 then
            return - (math.abs(Number) - (math.abs(Number) % Amount))
        end
        return Number - (Number % Amount)
    end
end


--[[Add Emojis]]--
local function AddEmoji(Text, Emoji, Spaces, Custom)
    local Add = (Spaces and "     → ") or (Custom ~= nil and Custom) or ""
    return Add..Version.Emojis[Emoji].." "..Text
end

--[[Notify]]--
local function Notify(Description, Time)
    Color = Color3.fromRGB(205, 329, 255)
    Notification:Notify(
        {Title = AddEmoji("Islands | System Exodus", "Island", false, " "), Description = Description},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = Time, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color}
    )

end

--[[Teleport Function]]--
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

--[[Return String]]--
local function GetMessage(Toggled)
    return Toggled and "<font color='rgb(130, 220, 120)'>enabled.</font>" or "<font color='rgb(224, 38, 42)'>disabled.</font>"
end

--[[Get Wild Spawn name]]--
local function GetWildSpawnName(Boss)
    return Boss == "slimeKing" and "slime_king_spawn" or Boss == "slimeQueen" and "slime_queen_spawn" or Boss == "wizardBoss" and "wizard_boss_spawn" or Boss == "desertBoss" and "desert_boss_spawn" or Boss == "golem" and "golem_spawn" or Boss == "magmaDragon" and "dragon_boss_spawn" or Boss == "deerBoss" and "deer_boss_spawn" or Boss == "voidSerpent" and "void_serpent_spawn"
end

--[[Get Spawn Coords]]--
local function GetSpawnCoords(Boss)
    return Boss == "slimeKing" and CFrame.new(724, 172, 142) or Boss == "slimeQueen" and CFrame.new(709, 221, 514) or Boss == "wizardBoss" and CFrame.new(1803, 421, -1001) or Boss == "desertBoss" and CFrame.new(639, 317, -2096) or Boss == "golem" and CFrame.new(2862, 288, 1179) or Boss == "magmaDragon" and CFrame.new(-9194, 410, -1401) or Boss == "deerBoss" and CFrame.new(-1157, 294, -1111) or Boss == "voidSerpent" and CFrame.new(-10216, 285, 9252)
end

--[[ Destroy Queen Crystals ]]--
local function CheckIfQueen(Boss)
    if Boss == "slimeQueen" and workspace.WildernessBlocks:FindFirstChild("slimeScepterBlock") then
        local OldEquipped = Character:FindFirstChildWhichIsA("Tool") 
        local QueenHeal = workspace.WildernessBlocks:FindFirstChild("slimeScepterBlock")
        repeat task.wait()
            if QueenHeal then
                EquipTool(GetBestItem(Pickaxes))
                Teleport(QueenHeal.CFrame * CFrame.new(0, -10, 0))
                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = QueenHeal, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
            else
                QueenHeal = nil
            end
        until not QueenHeal or not FarmSettings.Creatures.BossFarming
        task.wait(1)
        EquipTool(OldEquipped)
    end
end

--[[Resize Image]]--
local function ImageResize(Image, Size)
    local Size = Vector2.new(Image.size.X/Size,Image.size.Y/Size)
    local NewImage = {}
    local Checking = Vector2.new(Image.size.X/Size.X, Image.size.Y/Size.Y)
    local Skip = 0
    for x = 1,Size.X do
        for y = 1,Size.Y do
            LPH_NO_VIRTUALIZE(function()
                local Pixel = Image.image[tostring(Vector2.new(math.floor(x*Checking.X+0.5),math.floor(y*Checking.Y+0.5)))]
                Pixel.x = x
                Pixel.y = y
                NewImage[#NewImage+1] = Pixel
            end)()
        end
        task.wait()
    end
    return NewImage
end

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

local function rgb2lab(color)
    local r = color[1] / 255
    local g = color[2] / 255
    local b = color[3] / 255
    if r > 0.04045 then r = ((r + 0.055) / 1.055) ^ 2.4 else r = r / 12.92 end
    if g > 0.04045 then g = ((g + 0.055) / 1.055) ^ 2.4 else g = g / 12.92 end
    if b > 0.04045 then b = ((b + 0.055) / 1.055) ^ 2.4 else b = b / 12.92 end
    local x = r * 0.4124 + g * 0.3576 + b * 0.1805
    local y = r * 0.2126 + g * 0.7152 + b * 0.0722
    local z = r * 0.0193 + g * 0.1192 + b * 0.9505
    local x_ref = 0.9642
    local y_ref = 1.0000
    local z_ref = 0.8249
    local x_ratio = x / x_ref
    local y_ratio = y / y_ref
    local z_ratio = z / z_ref
    if x_ratio > 0.008856 then x_ratio = x_ratio ^ (1/3) else x_ratio = (7.787 * x_ratio) + (16/116) end
    if y_ratio > 0.008856 then y_ratio = y_ratio ^ (1/3) else y_ratio = (7.787 * y_ratio) + (16/116) end
    if z_ratio > 0.008856 then z_ratio = z_ratio ^ (1/3) else z_ratio = (7.787 * z_ratio) + (16/116) end
    local l = (116 * y_ratio) - 16
    local a = 500 * (x_ratio - y_ratio)
    local b = 200 * (y_ratio - z_ratio)
    return {l, a, b}
end
  
local function colorDiff(color1, color2)
    local lab1 = rgb2lab(color1)
    local lab2 = rgb2lab(color2)
    local delta_l = lab2[1] - lab1[1]
    local c1 = math.sqrt(lab1[2] * lab1[2] + lab1[3] * lab1[3])
    local c2 = math.sqrt(lab2[2] * lab2[2] + lab2[3] * lab2[3])
    local c_mean = (c1 + c2) / 2
    local g = 0.5 * (1 - math.sqrt(c_mean ^ 7 / (c_mean ^ 7 + 25 ^ 7)))
    local a1 = (1 + g) * lab1[2]
    local a2 = (1 + g) * lab2[2]
    local c1_ = math.sqrt(a1 * a1 + lab1[3] * lab1[3])
    local c2_ = math.sqrt(a2 * a2 + lab2[3] * lab2[3])
    local h1_ = math.atan2(lab1[3], a1) * 180 / math.pi
    local h2_ = math.atan2(lab2[3], a2) * 180 / math.pi
    if h1_ < 0 then h1_ = h1_ + 360 end
    if h2_ < 0 then h2_ = h2_ + 360 end
    local delta_l_ = lab2[1] - lab1[1]
    local delta_c_ = c2_ - c1_
    local delta_h_ = 0
    if c1_ * c2_ ~= 0 then
        if math.abs(h2_ - h1_) <= 180 then
            delta_h_ = h2_ - h1_
        elseif h2_ - h1_ > 180 then
            delta_h_ = h2_ - h1_ - 360
        else
            delta_h_ = h2_ - h1_ + 360
        end
    end
    local delta_h_prime = 2 * math.sqrt(c1_ * c2_) * math.sin(delta_h_ / 2 * math.pi / 180)
    local h_mean_prime = 0
    if c1_ * c2_ ~= 0 then
        if math.abs(h2_ - h1_) <= 180 then
            h_mean_prime = (h1_ + h2_) / 2
        elseif h1_ + h2_ < 360 then
            h_mean_prime = (h1_ + h2_ + 360) / 2
        else
            h_mean_prime = (h1_ + h2_ - 360) / 2
        end
    end
    local t = 1 - 0.17 * math.cos((h_mean_prime - 30) * math.pi / 180) + 0.24 * math.cos((2 * h_mean_prime) * math.pi / 180) + 0.32 * math.cos((3 * h_mean_prime + 6) * math.pi / 180)
    local s_l = 1 + (0.015 * (lab1[1] - 50) ^ 2) / math.sqrt(20 + (lab1[1] - 50) ^ 2)
    local s_c = 1 + 0.045 * c_mean
    local s_h = 1 + 0.015 * c_mean * t
    local r_t = -2 * math.sqrt(c_mean ^ 7 / (c_mean ^ 7 + 25 ^ 7)) * math.sin(60 * math.exp(-((h_mean_prime - 275) / 25) ^ 2) * math.pi / 180)
    local delta_e = math.sqrt((delta_l_ / s_l) ^ 2 + (delta_c_ / s_c) ^ 2 + (delta_h_prime / s_h) ^ 2 + r_t * (delta_c_ / s_c) * (delta_h_prime / s_h))
    return delta_e
end

local function GetNearestColor(Color)
    local Minimum = math.huge
    local LastColor = ""
    local TestVariable = false
    local NewColor = nil
    local NewName = nil
    for i,v in next, Colors2 do
        if v[1] == Color[1] and v[2] == Color[2] and v[3] == Color[3] then
            NewColor = {Colors[i][1], Colors[i][2], Colors[i][3]}
            NewName = i
            break
        end
    end
    if not NewColor then
        for i,v in next, Colors do
            local Distance = colorDiff(v, Color)
            if Distance < Minimum then
                LastColor = i
                Minimum = Distance
            end
        end
        Colors2[LastColor] = Color
        return LastColor
    elseif NewColor then
        return NewName
    end
end

--[[Load UI]]--
local LoadMessages = {
    "(Pro Max Ultra Wide 8G Wi-Fi 1950watts GeForce RTX 5090 Ti 340Hz Version)",
    "(Ultra Lucky! Version)",
    "(Shiny Pokemon Version)",
    "(INSANE Edition)",
    '("RARE" Version)',
    "(20w14∞ Version)"
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
    "i-i-... love you Potat!"
}
local UI = Finity.new("Islands | System Exodus", UDim2.new(0, 680, 0, 370), nil, function(Data) 
    Data.tip.Text = (AddEmoji("<font color=\"rgb(255,255,255)\">Islands | System Exodus </font>", "Island", false, " ")..(Whitelisted and (math.random(1, 25) == 1 and LoadMessages[math.random(1, #LoadMessages)] or "(Premium Version)") or "(Free Version)"))
end)

--[[Categories]]--
local Home = UI:Category(AddEmoji("Home", "Clipboard", false, " ")) 
local Farming = UI:Category(AddEmoji("Farming", "Tractor", false, " "))
local Mobs = UI:Category(AddEmoji("Creatures", "Sword", false, " ")) 
local Machinery = UI:Category(AddEmoji("Machinery", "Machine", false, " ")) 
local Misc = UI:Category(AddEmoji("Miscellaneous", "Glass", false, " "))
local WorldEdit = UI:Category(AddEmoji("World Edit", "Barrier", false, " ")) 
local SettingsTab = UI:Category(AddEmoji("Settings", "Gear", false, " ")) 

--[[Home Sectors]]--
local Islands = Home:Sector("Islands")
Islands:Cheat("Label", AddEmoji("Scripted by: @Jxnt", "Scroll", false))
Islands:Cheat("Label", AddEmoji("UI by: deto & @xxxYoloxxx999", "PurpleHeart", false))
Islands:Cheat("Label", AddEmoji("To minimize the UI, press "..Settings.Keybinds.ToggleKey, "Sparkle", false))
Islands:Cheat("Button", AddEmoji("Discord Invite", "Link", false), function()
    Notify("Invite link was copied to your keyboard!", 3)
    UI.Features["- Discord Invite:"].button.Text = "Copied / Joined"
	setclipboard("https://discord.gg/SystemExodus")
    for i = 6453, 6464 do
        task.spawn(function()
            request({Url = "http://127.0.0.1:"..tostring(i).."/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"}, Body = game:GetService("HttpService"):JSONEncode({["cmd"] = "INVITE_BROWSER", ["nonce"] = game:GetService("HttpService"):GenerateGUID(false), ["args"] = {["invite"] = {["code"] = tostring("systemexodus"), }, ["code"] = tostring("systemexodus")}})})
        end)
    end
    task.wait(1)
    UI.Features["- Discord Invite:"].button.Text = "Copy / Join"
end, {text = "Copy / Join"})
Islands:Cheat("Label", ("\n"):rep(29)..UIMessages[math.random(1, #UIMessages)])
UI.ChangeToggleKey(Enum.KeyCode[Settings.Keybinds.ToggleKey])

Updates = Home:Sector("UI Update ("..Version.Date..")")  
for _,v in next, Version.Changelog do
    Updates:Cheat("Label", v) 
end

--[[Home Sectors]]--
local Crops = Farming:Sector("Crops")
local Ores = Farming:Sector("Ores")
local Trees = Farming:Sector("Trees")
local Totems = Farming:Sector("Totems")
local Flowers = Farming:Sector("Flowers")
for i = 1,5 do
    Farming:Sector("")
end

--[[Creatures Sectors]]--
local NormalMobs = Mobs:Sector("Mobs")
local Bosses = Mobs:Sector("Bosses")
local Fishing = Mobs:Sector("Fishing")
local OtherCreatures = Mobs:Sector("Other")
for i = 1,5 do
    Mobs:Sector("")
end

--[[Machinery Sectors]]--
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

--[[Misc Sectors]]--
local Player = Misc:Sector("Player")
local InventoryViewer = Misc:Sector("Player Info")
local AutoEat = Misc:Sector("Auto Eat")
local VendingMachines = Misc:Sector("Vending Machines")
local CraftAnywhere = Misc:Sector("Craft Items")
local OtherMisc = Misc:Sector("Other")
for i = 1,15 do
    Misc:Sector("")
end

--[[World Edit]]--
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

--[[Settings Sectors]]--
local Keybinds = SettingsTab:Sector("Keybinds")
local SettingsOther = SettingsTab:Sector("Other")
Keybinds:Cheat("Keybind", AddEmoji("UI Toggle", "Keyboard"), function(Bind)
    UI.ChangeToggleKey(Bind)
    Settings.Keybinds.ToggleKey = Bind.Name
    Save()
end)

SettingsOther:Cheat("Button", AddEmoji("Save Weapon", "Sword"), function()
    if Character:FindFirstChildOfClass("Tool") then
        FarmSettings.Creatures.Sword = Character:FindFirstChildOfClass("Tool").Name
        Notify("Saved Weapon: "..FarmSettings.Creatures.Sword, 1)
        Save()
    end
end, {text = "*Equip it*"})

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
        end
        if FarmableStage == 2 and Stage ~= 2 then
            CollectionService:RemoveTag(Crop, "READY: "..CropName)
        end
    end)
end

function CropHandler.new()
    local self = setmetatable({}, CropHandler)
    CollectionService:GetInstanceAddedSignal("crop-logic"):Connect(self.newCrop)
    for i, v in pairs(CollectionService:GetTagged("crop-logic")) do
        self.newCrop(v)
    end
    return self
end

function CropHandler:Get(Crop)
    return CollectionService:GetTagged("READY: "..Crop)
end

--[[Crop Farming]]--
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
    XP()
    
    Notify("Farm Crops was "..GetMessage(State), 1)
    Save()

    if FarmSettings.Crops.SickleCrops and not NeverExecutedBefore then
        GetCrops = CropHandler.new()
        NeverExecutedBefore = true
    end
    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Crops.SickleCrops and task.wait() do
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

Crops:Cheat("Checkbox", AddEmoji("Replace Crops", "Sparkle", true), function(State)
    FarmSettings.Crops.ReplaceCrops = State
    Save()
end, {enabled = FarmSettings.Crops.ReplaceCrops})

--[[Berry Farming]]--
SickleBush = Crops:Cheat("Checkbox", AddEmoji("Farm Berry Bushes", "Berry"), function(State) 
    FarmSettings.Crops.SickleBush = State
    Settings.Other.NeedsNoclip = State
    XP()

    Notify("Farm Bushes was "..GetMessage(State), 1)
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

--[[Ore Farming]]--
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

local function OreAreaTP(Ore)
    return (Ore:find("Stone") or Ore:find("Coal") or Ore:find("Iron") or Ore:find("Snow") or Ore:find("Ice") or Ore:find("Prismarine") or Ore:find("Clay")) and "hub-slime" or (Ore:find("Granite") or Ore:find("Diorite") or Ore:find("Andesite")) and "hub-slime" or (Ore:find("Marble") or Ore:find("Slate") or Ore:find("Electrite") or Ore:find("Gold")) and "buffalkor-slime"
end

--[[Hub Ore Farming]]--
MineOresHub = Ores:Cheat("Checkbox", AddEmoji("Mine Ores (Hub Area)", "Pickaxe"), function(State)
    FarmSettings.Ores.HubEnabled = State
    OtherSettings.NeedsNoclip = State
    Notify("Mine Ores (Hub) was "..GetMessage(State), 1)
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
            if (HumanoidRootPart.Position - Ore.Position).magnitude > 700 then
                for _,v in next, Settings.OreDropdown do
                    if not table.find(Settings.OreDropdown, "Current Island") then
                        IslandTeleport(OreAreaTP(v))
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
                        EquipTool(GetBestItem(Pickaxes))
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

--[[Island Ore Farming]]--
MineOresIsland = Ores:Cheat("Checkbox", AddEmoji("Mine Ores (Personal Island)", "Pickaxe"), function(State)
    FarmSettings.Ores.IslandEnabled = State
    OtherSettings.NeedsNoclip = State
    Notify("Mine Ores (Island) was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local CollectedOres = {}
        local NewIslandOres = GetIsland().Blocks.ChildAdded:Connect(function(Ore)
            if Ore.Name:find("rock") then
                CollectedOres[#CollectedOres + 1] = Ore
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:find("rock") then
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
                    if table.find(Settings.OreDropdown, v.Name) or table.find(Settings.OreDropdown, "All") then
                        repeat task.wait()
                            Teleport(v.CFrame * CFrame.new(0,5,0), FarmSettings.Ores.IslandEnabled, nil, true)
                            if not FarmSettings.Ores.KYSGrass then
                                EquipTool(GetBestItem(Pickaxes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(Pickaxes2)) 
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetClosestBlock(15, v.CFrame.p), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        until not v.Parent or not FarmSettings.Ores.IslandEnabled
                        
                        if FarmSettings.Ores.KYSGrass then
                            task.spawn(function()
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "grass", ["cframe"] = CFrame.new(v.CFrame.X, v.CFrame.Y - 3, v.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
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
        FarmSettings.Ores.KYSGrass = false 
        BreakUnderOres:toggleState(false)
        Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    elseif Whitelisted then
        FarmSettings.Ores.KYSGrass = State 
        Save()
    end
end, {enabled = FarmSettings.Ores.KYSGrass})

--[[Tree Farming]]--
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
    
    Notify("Chop Trees was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local CollectedTrees = {}
        local NewIslandTrees = GetIsland().Blocks.ChildAdded:Connect(function(Tree)
            if Tree.Name:find("tree") and not BadTrees(Tree.Name:lower(), TreeBlacklist) then
                CollectedTrees[#CollectedTrees + 1] = Tree
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:find("tree") and not BadTrees(v.Name:lower(), TreeBlacklist) then
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
                            if not FarmSettings.Trees.KYSGrass then
                                EquipTool(GetBestItem(Axes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = Tree, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(Pickaxes2))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetClosestBlock2(Tree.CFrame.p), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        end
                    until not Tree.Parent or not FarmSettings.Trees.ChopTrees
                    
                    if FarmSettings.Trees.ReplaceTrees and not FarmSettings.Trees.TreeAura then
                        if not FarmSettings.Trees.KYSGrass then
                            Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..Tree.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = Tree.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                        else
                            task.spawn(function()
                                repeat task.wait()
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "grass", ["cframe"] = CFrame.new(Tree.CFrame.X, Tree.CFrame.Y - 3, Tree.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..Tree.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = Tree.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                until IsTaken(Tree.Position)
                            end)
                        end
                    end
                end
                table.remove(CollectedTrees, 1)
            else
                table.remove(CollectedTrees, 1)
            end

            --[[for _,v in next, CollectedTrees do
                if _ == nil then
                    table.remove(CollectedTrees, _)
                end
                if FarmSettings.Trees.ChopTrees and table.find(Settings.TreeDropdown, v.Name:gsub("%d", "")) or table.find(Settings.TreeDropdown, "All") then
                    repeat task.wait()
                        Teleport(v.CFrame * CFrame.new(0,5,0), FarmSettings.Trees.ChopTrees)
                        if LocalPlayer:DistanceFromCharacter(v.Position) <= 35 then
                            if not FarmSettings.Trees.KYSGrass then
                                EquipTool(GetBestItem(Axes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(Pickaxes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetClosestBlock(10, v.CFrame.p), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        end
                    until not v.Parent or not FarmSettings.Trees.ChopTrees
                    
                    if FarmSettings.Trees.ReplaceTrees then
                        if not FarmSettings.Trees.KYSGrass then
                            Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..v.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = v.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                        else
                            task.spawn(function()
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "grass", ["cframe"] = CFrame.new(v.CFrame.X, v.CFrame.Y - 3, v.CFrame.Z), [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["blockType"] = "sapling"..v.Name:gsub("tree", ""):gsub("%d", ""), ["cframe"] = v.CFrame, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                            end)
                        end
                    end

                    CollectedTrees[_] = nil
                    break
                end
            end]]--
        end

        if not FarmSettings.Trees.ChopTrees and NewIslandTrees then NewIslandTrees:Disconnect(); NewIslandTrees = nil end
    end)
end, {enabled = FarmSettings.Trees.ChopTrees})

Trees:Cheat("Checkbox", AddEmoji("Replant Sapling", "Sparkle", true), function(State)
    FarmSettings.Trees.ReplaceTrees = State
    Save()
end, {enabled = FarmSettings.Trees.ReplaceTrees})

BreakUnderTrees = Trees:Cheat("Checkbox", AddEmoji("Break Block Under", "Sparkle", true), function(State)
    if State and not Whitelisted then
        FarmSettings.Trees.KYSGrass = false 
        BreakUnderTrees:toggleState(false)
        Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    elseif Whitelisted then
        FarmSettings.Trees.KYSGrass = State 
        Save()
    end
end, {enabled = FarmSettings.Trees.KYSGrass})

TreeAura = Trees:Cheat("Checkbox", AddEmoji("Break Nearby Trees", "Sparkle", true), function(State)
    FarmSettings.Trees.TreeAura = State 
    Save()
    task.spawn(function()
        while FarmSettings.Trees.TreeAura and task.wait() do
            if FarmSettings.Trees.ChopTrees then
                for _,v in next, GetNearBlocks2(20) do
                    if LocalPlayer:DistanceFromCharacter(v.Position) <= 25 and FarmSettings.Trees.TreeAura and FarmSettings.Trees.ChopTrees and not BadTrees(v.Name:lower(), TreeBlacklist) and table.find(Settings.TreeDropdown, v.Name:gsub("%d", "")) or table.find(Settings.TreeDropdown, "All") then
                        repeat task.wait()
                            if not FarmSettings.Trees.KYSGrass then
                                EquipTool(GetBestItem(Axes))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            else
                                EquipTool(GetBestItem(Pickaxes2))
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = GetClosestBlock2(v.CFrame.p), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            end
                        until not v.Parent or not FarmSettings.Trees.TreeAura or not FarmSettings.Trees.ChopTrees or LocalPlayer:DistanceFromCharacter(v.Position) >= 25

                        if FarmSettings.Trees.ReplaceTrees then
                            if not FarmSettings.Trees.KYSGrass then
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

--[[Collect Totem Items]]--
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
    Notify("Collect Totem Items was "..GetMessage(State), 1)
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
                                Teleport(y.CFrame * CFrame.new(3,3,0), nil, nil, true)
                                for _,z in next, y.WorkerContents:GetChildren() do
                                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = z, [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                                end
                            until not y.Parent or not y:FindFirstChild("WorkerContents") or #y.WorkerContents:GetChildren() == 0 or not FarmSettings.Totems.CollectItems
                        end
                    end
                end
            end
        end
    end)
end, {enabled = FarmSettings.Totems.CollectItems})

--[[Flower Farming]]--
WaterFertile = Flowers:Cheat("Checkbox", AddEmoji("Water Fertile", "Droplet"), function(State)
    FarmSettings.Flowers.WaterFertile = State
    OtherSettings.NeedsNoclip = State
    Notify("Water Fertile was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local CollectedFlowers = {}
        local NewIslandFlowers = GetIsland().Blocks.ChildAdded:Connect(function(Flower)
            if Flower.Name:lower():find("fertile") and Flower.Name:lower():find("flower") and not Flower.Name:lower():find("pot") and not Flower.Watered.Value then
                CollectedFlowers[#CollectedTrees + 1] = Tree
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:lower():find("fertile") and v.Name:lower():find("flower") and not v.Name:lower():find("pot") and not v.Watered.Value then
                CollectedFlowers[#CollectedFlowers + 1] = v
            end
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Flowers.WaterFertile and task.wait() do
            table.sort(CollectedFlowers, function(i, v)
                return (HumanoidRootPart.Position - i.Position).magnitude < (HumanoidRootPart.Position - v.Position).magnitude
            end)

            for _,v in next, CollectedFlowers do
                if not FarmSettings.Flowers.WaterFertile then break end
                repeat task.wait()
                    Teleport(v.CFrame, nil, nil, true)
                    EquipTool(LocalPlayer.Backpack:FindFirstChild("wateringCan") or Character["wateringCan"])
                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["CLIENT_WATER_BLOCK"]:InvokeServer({["block"] = v})
                until not v.Parent or v.Watered.Value or not FarmSettings.Flowers.WaterFertile
                table.remove(CollectedFlowers, _)
                break
            end
        end
    end)

    if not FarmSettings.Flowers.WaterFertile and NewIslandFlowers then NewIslandFlowers:Disconnect(); NewIslandFlowers = nil end
end, {enabled = FarmSettings.Flowers.WaterFertile})

CollectFertile = Flowers:Cheat("Checkbox", AddEmoji("Collect Fertile Flowers", "Flower"), function(State)
    FarmSettings.Flowers.CollectFertile = State
    Notify("Collect Fertile was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local CollectedFlowers = {}
        local NewIslandFlowers = GetIsland().Blocks.ChildAdded:Connect(function(Flower)
            if Flower.Name:lower():find("fertile") and Flower.Name:lower():find("flower") and not Flower.Name:lower():find("pot") then
                CollectedFlowers[#CollectedTrees + 1] = Tree
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name:lower():find("fertile") and v.Name:lower():find("flower") and not v.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = v
            end
        end

        while task.wait() and FarmSettings.Flowers.CollectFertile do
            for _,v in next, CollectedFlowers do
                if not FarmSettings.Flowers.CollectFertile then break end
                task.spawn(function()
                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["client_request_1"]:InvokeServer({["flower"] = v})
                end)
            end
        end

        if not State and NewIslandFlowers then NewIslandFlowers:Disconnect(); NewIslandFlowers = nil end
    end)
end, {enabled = FarmSettings.Flowers.CollectFertile})

CollectNonFertile = Flowers:Cheat("Checkbox", AddEmoji("Collect non-Fertile Flowers", "Flower"), function(State)
    FarmSettings.Flowers.CollectNonFertile = State
    Notify("Collect non-Fertile was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local CollectedFlowers = {}
        local NewIslandFlowers = GetIsland().Blocks.ChildAdded:Connect(function(Flower)
            if not Flower.Name:lower():find("fertile") and Flower.Name:lower():find("flower") and not Flower.Name:lower():find("pot") then
                CollectedFlowers[#CollectedTrees + 1] = Tree
            end
        end)

        for _,v in next, GetIsland().Blocks:GetChildren() do
            if not v.Name:lower():find("fertile") and v.Name:lower():find("flower") and not v.Name:lower():find("pot") then
                CollectedFlowers[#CollectedFlowers + 1] = v
            end
        end

        while task.wait() and FarmSettings.Flowers.CollectNonFertile do
            for _,v in next, CollectedFlowers do
                if not FarmSettings.Flowers.CollectNonFertile then break end
                task.spawn(function()
                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["client_request_1"]:InvokeServer({["flower"] = v})
                end)
            end
        end

        if not State and NewIslandFlowers then NewIslandFlowers:Disconnect(); NewIslandFlowers = nil end
    end)
end, {enabled = FarmSettings.Flowers.CollectNonFertile})

--[[Mob Farming]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    NormalMobs["Mob Dropdown"..v:split("")[1]] = NormalMobs:Cheat("Dropdown", v.." Mob", function(SelectedMob)
        if SelectedMob == "(Select/None)" then 
            Settings.MobDropdown[ID] = nil 
        else
            Settings.MobDropdown[ID] = SelectedMob == "Gingerbread" and "evilGingerbread" or SelectedMob == "Slimes" and "slime" or SelectedMob == "Buffalos" and "buffalkor" or SelectedMob == "Wizards" and "wizardLizard" or SelectedMob == "Skorps" and "skorp" or SelectedMob == "Crabs" and "hostileCrab" or SelectedMob == "Skeletons" and "skeletonPirate" or SelectedMob == "Magma Blobs" and "magmaBlob" or SelectedMob == "Magma Golem" and "magmaGolem" or SelectedMob == "Void Dogs" and "voidDog"
        end
        Save()
    end, {default = Settings.MobDropdown[ID], options = {"(Select/None)", "Slimes", "Buffalos", "Wizards", "Skorps", "Crabs", "Skeletons", "Void Dogs", "Magma Blobs", "Magma Golem", "Gingerbread"}})
end

local Mobs = {}
local Entities = workspace.WildernessIsland:FindFirstChild("Entities") and workspace.WildernessIsland.Entities
local VirtualInputManager = game:GetService("VirtualInputManager")
MobFarming = NormalMobs:Cheat("Checkbox", AddEmoji("Farm Mobs", "SkullCross"), function(State)
    FarmSettings.Creatures.MobFarming = State
    Settings.Other.NeedsNoclip = State
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

    Notify("Mob Farming was "..GetMessage(State), 1)
    Save()
    
    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab")
        end
        repeat task.wait() 
            if not Keys.MobArgName or not Keys.MobArgCode then
                EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                GetRemoteKeys("Mobs")
                task.wait(1)
            end
        until Keys.MobArgName and Keys.MobArgCode
        for _,v in next, Settings.MobDropdown do
            if FarmSettings.Creatures.MobFarming and v ~= "skorp" and (not Entities:FindFirstChild(v) or not Entities[v]:FindFirstChild("HumanoidRootPart")) then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                local Zone = MobZoneTP(v)
                if Zone == "UsePortal" then
                    Notify("Please teleport to the area to farm this mob.", 5)
                elseif Zone == "UseRemote" then
                    Remotes["TravelPirateIsland"]:FireServer(false)
                else
                    IslandTeleport(Zone)
                end
            elseif FarmSettings.Creatures.MobFarming and v == "skorp" and (not Entities:FindFirstChild("skorpIron") or not Entities:FindFirstChild("skorpGold") or not Entities:FindFirstChild("skorpRuby")) then
                warn()
                IslandTeleport(MobZoneTP("skorp"))
            end
        end

        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.MobFarming and task.wait() do
            Mobs = {}
            for _,v in next, workspace.WildernessIsland.Entities:GetChildren() do
                if (table.find(Settings.MobDropdown, v.Name) or (table.find(Settings.MobDropdown, "skorp") and v.Name:find("skorp"))) and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.MobFarming then
                    table.insert(Mobs, v)
                end
            end

            table.sort(Mobs, function(i, v)
                return (HumanoidRootPart.Position - Vector3.new(i.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, i.HumanoidRootPart.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, v.HumanoidRootPart.Position.Z)).magnitude
            end)
            for _,v in next, Mobs do
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                --// Book Farming
                if Whitelisted and FarmSettings.Creatures.UseBook then

                --// Sword Farming
                elseif not FarmSettings.Creatures.UseBook and not FarmSettings.Creatures.UseBow then
                    IslandTeleport(MobZoneTP(v == "skorp" and "skorp" or tostring(v)))
                    task.spawn(function()
                        repeat task.wait()
                            if FindIfDead(v) then
                                Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,-12,0), FarmSettings.Creatures.MobFarming)
                            else
                                break
                            end
                        until not v.Parent or not FarmSettings.Creatures.MobFarming
                    end)
                    repeat task.wait()
                        if FindIfDead(v) then
                            EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            Remotes[SwingSword]:FireServer("", {{["hitUnit"] = v, [Keys.MobArgName] = Keys.MobArgCode}})
                            task.wait(0.1)
                            if FindIfDead(v) then
                                if FarmSettings.Creatures.Sword ~= "rageblade" then
                                    task.wait(0.4) 
                                end
                            end
                        else
                            break
                        end
                    until not v.Parent or not FarmSettings.Creatures.MobFarming
                end
                break
            end    
        end
    end)
end, {enabled = FarmSettings.Creatures.MobFarming})

--[[Kill Aura]]--
KillAura = NormalMobs:Cheat("Checkbox", AddEmoji("Kill Aura", "Sparkle"), function(State)
    FarmSettings.Creatures.KillAura = State
    Notify("Kill Aura was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab")
        end
        repeat task.wait() 
            if not Keys.MobArgName or not Keys.MobArgCode then
                EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                GetRemoteKeys("Mobs")
                task.wait(1)
            end
        until Keys.MobArgName and Keys.MobArgCode
        
        while FarmSettings.Creatures.KillAura and task.wait() do
            for _,v in next, workspace.WildernessIsland.Entities:GetChildren() do
                if v:FindFirstChild("HumanoidRootPart") and LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position) <= 15 then
                    task.spawn(function()
                        EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        Remotes[SwingSword]:FireServer("", {{["hitUnit"] = v, [Keys.MobArgName] = Keys.MobArgCode}})
                    end)
                    task.wait(0.1)
                    if FindIfDead(v) then
                        if FarmSettings.Creatures.Sword ~= "rageblade" then
                            task.wait(0.4) 
                        end
                    end
                end
            end
        end
    end)
end)


--[[Boss Farming]]--
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

local Entities = workspace:FindFirstChild("WildernessIsland") and workspace.WildernessIsland.Entities
BossFarming = Bosses:Cheat("Checkbox", AddEmoji("Farm Bosses", "SkullCross"), function(State)
    FarmSettings.Creatures.BossFarming = State
    Settings.Other.NeedsNoclip = State
    
    Notify("Boss Farming was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        if FarmSettings.Creatures.Sword == nil or not FindItem(FarmSettings.Creatures.Sword) then
            return Notify("Please setup a sword in the Settings Tab")
        end
        repeat task.wait() 
            if not Keys.MobArgName or not Keys.MobArgCode then
                EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                GetRemoteKeys("Mobs")
                task.wait(1)
            end
        until Keys.MobArgName and Keys.MobArgCode

        for _,v in next, Settings.BossDropdown do
            if FarmSettings.Creatures.BossFarming then
                local Zone = BossZoneTP(v)
                if Zone == "UsePortal" then
                    Notify("Please teleport to the area to farm this boss.", 3)
                else
                    IslandTeleport(Zone)

                end
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.BossFarming and task.wait() do
            WildTriggers = workspace:FindFirstChild("spawnPrefabs") and workspace.spawnPrefabs.WildEventTriggers            
            for _,v in next, Settings.BossDropdown do
                local TriggerName = GetWildSpawnName(v)
                local SpawnCoords = GetSpawnCoords(v)

                if FarmSettings.Creatures.BossFarming and Entities:FindFirstChild(v) or (WildTriggers:FindFirstChild(TriggerName) and ((v == "voidSerpent" and LocalPlayer.Backpack:FindFirstChild("voidBossToken") and LocalPlayer.Backpack.voidBossToken.Amount.Value >= 300) or (v == "magmaDragon" and LocalPlayer.Backpack:FindFirstChild("underworldDragonToken") and LocalPlayer.Backpack.underworldDragonToken.Amount.Value >= 750) or (v ~= "deerBoss" and LocalPlayer.Backpack:FindFirstChild(v.."Token") and LocalPlayer.Backpack[v.."Token"].Amount.Value >= (v == "slimeQueen" and 100 or 500)))) then
                    if not Entities:FindFirstChild(v) and WildTriggers:FindFirstChild(TriggerName) then

                        Teleport(SpawnCoords)
                        if WildTriggers[TriggerName]:FindFirstChild("CanBeTriggered") then
                            WildTriggers[TriggerName].CanBeTriggered:Destroy()
                        end

                        repeat task.wait()
                            if Entities:FindFirstChild(v) or not FarmSettings.Creatures.BossFarming then 
                                break
                            end
                            fireproximityprompt(WildTriggers[TriggerName].ProximityPrompt, 1, true)
                            if v == "golem" then 
                                task.wait(8)
                            else
                                task.wait(0.5)
                            end
                        until Entities:FindFirstChild(v) or not FarmSettings.Creatures.BossFarming

                    end

                    Entities:WaitForChild(v)
                    Entities[v]:WaitForChild("HumanoidRootPart")

                    task.spawn(function()
                        repeat task.wait()
                            if Entities:FindFirstChild(v) and Entities[v]:FindFirstChild("HumanoidRootPart") then
                                CheckIfQueen(v)
                                Teleport(Entities[v].HumanoidRootPart.CFrame * ((v == "slimeQueen" or v == "slimeKing") and CFrame.new(0,-14,0) or CFrame.new(0,12,0)))
                            end
                        until not Entities:FindFirstChild(v) or not FarmSettings.Creatures.BossFarming
                    end)

                    repeat task.wait(0.1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        if Entities:FindFirstChild(v) and Entities[v]:FindFirstChild("HumanoidRootPart") then
                            EquipTool(GetBestItem({FarmSettings.Creatures.Sword}))
                            Remotes[SwingSword]:FireServer("", {{["hitUnit"] = Entities[v], [Keys.MobArgName] = Keys.MobArgCode}})
                            if Entities:FindFirstChild(v) and Entities[v]:FindFirstChild("ActiveAnimations") and Entities[v].ActiveAnimations:FindFirstChild("12635266011") then
                                Position = HumanoidRootPart.CFrame
                                repeat task.wait()
                                    TweenTeleport(Position * CFrame.new(0,25,0))
                                until not Entities:FindFirstChild(v) or not Entities[v]:FindFirstChild("ActiveAnimations") or not Entities[v].ActiveAnimations:FindFirstChild("12635266011") or not FarmSettings.Creatures.BossFarming
                                Timer = tick()
                                repeat task.wait()
                                    TweenTeleport(Position * CFrame.new(0,25,0))
                                until tick() - Timer >= 2 or not FarmSettings.Creatures.BossFarming
                            end
                            if Entities:FindFirstChild(v) then
                                if FarmSettings.Creatures.Sword ~= "rageblade" then
                                    task.wait(0.4) 
                                end
                            end
                        end
                    until not Entities:FindFirstChild(v) or not FarmSettings.Creatures.BossFarming

                    if v == "golem" and FarmSettings.Creatures.KorMineOres and FarmSettings.Creatures.BossFarming then
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
                        task.wait(1)
                        EquipTool(OldEquipped)
                    end
                end

                if not WildTriggers:FindFirstChild(TriggerName) and v ~= "skorpSerpent" then
                    Teleport(SpawnCoords)
                    WildTriggers:WaitForChild(TriggerName)
                end
            end
        end
    end)
end, {enabled = FarmSettings.Creatures.BossFarming})  

Bosses:Cheat("Checkbox", AddEmoji("Mine Kor Ores", "Pickaxe", true), function(State)
    FarmSettings.Creatures.KorMineOres = State 
    Save()
end, {enabled = FarmSettings.Creatures.KorMineOres})    

local LastCast = tick()
local ExistingBobbers = {}
Fishing:Cheat("Checkbox", AddEmoji("Auto Fishing", "Fish"), function(State)
    FarmSettings.Creatures.AutoFish = State
    Settings.Other.NeedsNoclip = State
    Notify("Auto Fishing was "..GetMessage(State), 1)
    Save()
    
    task.spawn(function()
        if FarmSettings.Creatures.AutoFish and tick()-LastCast >= 4 then
            EquipTool(GetBestItem(FishingRods))
            LastCast = tick()
            Remotes[CastRod]:FireServer("", {{["playerLocation"] = HumanoidRootPart.Position, ["direction"] = HumanoidRootPart.CFrame.lookVector, ["strength"] = math.random()}})
        end
        while FarmSettings.Creatures.AutoFish and task.wait() do
            ExistingBobbers = {}
            EquipTool(GetBestItem(FishingRods))
            
            if LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar:FindFirstChild("RoactTree") then
                task.wait(0.1)
                Remotes[FishingSuccess]:FireServer({["success"] = true})
                LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar.RoactTree:Destroy()
                
                repeat task.wait() until tick()-LastCast >= 6
                LastCast = tick()
                Remotes[CastRod]:FireServer("", {{["playerLocation"] = HumanoidRootPart.Position, ["direction"] = HumanoidRootPart.CFrame.lookVector, ["strength"] = math.random()}})
            end

            for _,v in next, workspace:GetChildren() do
                if v.Name == "Bobber" and v:FindFirstChild("Player") then
                    table.insert(ExistingBobbers, v.Player.Value)
                end
            end
            if (#ExistingBobbers == 0 or not table.find(ExistingBobbers, LocalPlayer)) and not LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar:FindFirstChild("RoactTree") and tick()-LastCast >= 6 then
                LastCast = tick()
                Remotes[CastRod]:FireServer("", {{["playerLocation"] = HumanoidRootPart.Position, ["direction"] = HumanoidRootPart.CFrame.lookVector, ["strength"] = math.random()}})
            end

        end
    end)
end, {enabled = FarmSettings.Creatures.AutoFish})
Fishing:Cheat("Label", AddEmoji("RISK OF BAN", "Warning", true))

CollectFireflies = OtherCreatures:Cheat("Checkbox", AddEmoji("Collect Fireflies", "Firefly"), function(State)
    FarmSettings.Creatures.CollectFireflies = State
    Settings.Other.NeedsNoclip = State
    Notify("Collect Fireflies was "..GetMessage(State), 1)
    Save()
    
    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.CollectFireflies and task.wait() do
            for _,v in next, GetIsland().Entities:GetChildren() do
                if v.Name == "firefly" and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.CollectFireflies then
                    repeat task.wait()
                        if v:FindFirstChild("HumanoidRootPart") then
                            Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0), nil, nil, true)
                            Remotes[SwingNet]:FireServer("", {{["entity"] = v}})
                        end
                    until not v.Parent or not FarmSettings.Creatures.CollectFireflies
                end
            end
            task.wait()
        end 
    end)
end, {enabled = FarmSettings.Creatures.CollectFireflies})

CollectBees = OtherCreatures:Cheat("Checkbox", AddEmoji("Collect Bees", "Bee"), function(State)
    FarmSettings.Creatures.CollectBees = State
    Settings.Other.NeedsNoclip = State
    Notify("Collect Bees was "..GetMessage(State), 1)
    Save()
    
    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.CollectBees and task.wait() do
            for _,v in next, GetIsland().Entities:GetChildren() do
                if v.Name == "bee" and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.CollectBees then
                    repeat task.wait()
                        if v:FindFirstChild("HumanoidRootPart") then 
                            Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0), nil, nil, true)
                            Remotes[SwingNet]:FireServer("", {{["entity"] = v}})
                        end
                    until not v.Parent or not FarmSettings.Creatures.CollectBees
                end
            end
            task.wait()
        end 
    end)
end, {enabled = FarmSettings.Creatures.CollectBees})

CollectRabbits = OtherCreatures:Cheat("Checkbox", AddEmoji("Collect Rabbits", "Rabbit"), function(State)
    FarmSettings.Creatures.CollectRabbits = State
    Settings.Other.NeedsNoclip = State
    Notify("Collect Rabbits was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.CollectRabbits and task.wait() do
            for _,v in next, GetIsland().Entities:GetChildren() do
                if v.Name == "rabbit" and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.CollectRabbits then
                    repeat task.wait()
                        if v:FindFirstChild("HumanoidRootPart") then 
                            Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0), nil, nil, true)
                            Remotes[SwingNet]:FireServer("", {{["entity"] = v}})
                        end
                    until not v.Parent or not FarmSettings.Creatures.CollectRabbits
                end
            end
            task.wait()
        end 
    end)
end, {enabled = FarmSettings.Creatures.CollectRabbits})

CollectFrogs = OtherCreatures:Cheat("Checkbox", AddEmoji("Collect Frogs", "Frog"), function(State)
    FarmSettings.Creatures.CollectFrogs = State
    Settings.Other.NeedsNoclip = State
    Notify("Collect Frogs was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.CollectFrogs and task.wait() do
            for _,v in next, GetIsland().Entities:GetChildren() do
                if v.Name == "frog" and v:FindFirstChild("HumanoidRootPart") and FarmSettings.Creatures.CollectFrogs then
                    repeat task.wait()
                        if v:FindFirstChild("HumanoidRootPart") then 
                            Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0), nil, nil, true)
                            Remotes[SwingNet]:FireServer("", {{["entity"] = v}})
                        end
                    until not v.Parent or not FarmSettings.Creatures.CollectFrogs
                end
            end
            task.wait()
        end 
    end)
end, {enabled = FarmSettings.Creatures.CollectFrogs})

CollectSpirits = OtherCreatures:Cheat("Checkbox", AddEmoji("Collect Spirits", "Ghost"), function(State)
    FarmSettings.Creatures.CollectSpirits = State
    Settings.Other.NeedsNoclip = State
    Notify("Collect Spirits was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local Spirits = {}
        Teleport(HumanoidRootPart.CFrame)
        while FarmSettings.Creatures.CollectSpirits and task.wait() do
            for _,v in next, workspace.WildernessIsland.Entities:GetChildren() do
                if v.Name == "spirit" and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.CFrame.Y >= 240 and FarmSettings.Creatures.CollectSpirits then
                    table.insert(Spirits, v)
                end
            end
            table.sort(Spirits, function(i, v)
                if i:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart") then
                    return (HumanoidRootPart.Position - Vector3.new(i.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, i.HumanoidRootPart.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, v.HumanoidRootPart.Position.Z)).magnitude
                end
            end)
            for _,v in next, Spirits do
                if v.Name == "spirit" and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.CFrame.Y >= 240 and FarmSettings.Creatures.CollectSpirits then
                    repeat task.wait()
                        if not v:FindFirstChild("HumanoidRootPart") or (v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.CFrame.Y <= 240) then break end
                        Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0))
                        Remotes[SwingNet]:FireServer("", {{["entity"] = v}})
                    until not v.Parent or not FarmSettings.Creatures.CollectSpirits
                    break
                end
            end
        end 
    end)
end, {enabled = FarmSettings.Creatures.CollectSpirits})

--[[Auto Smelting]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Smelt["Item Dropdown"..v:split("")[1]] = Smelt:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.SmeltDropdown[ID] = nil 
        else
            Settings.SmeltDropdown[ID] = SelectedItem == "Iron" and "ironOre" or SelectedItem == "Gold" and "goldOre" or SelectedItem == "Copper" and "copperOre" or SelectedItem:lower()
        end
        Save()
    end, {default = Settings.SmeltDropdown[ID], options = {"(Select/None)", "Iron", "Gold", "Clay", "Bamboo", "Grass", "Sand"}})
end

Smelt:Cheat("Checkbox", AddEmoji("Smelt Items (Small Furnaces)", "Fire"), function(State)
    MachinerySettings.Smelting = State
    Settings.Other.NeedsNoclip = false
    Notify("Auto Smelting was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local Smelters = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name == "smallFurnace" and not table.find(Smelters, v) then
                Smelters[#Smelters + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while MachinerySettings.Smelting and task.wait() do            
            for _,x in next, Settings.SmeltDropdown do
                for _,y in next, Smelters do
                    if LocalPlayer.Backpack:FindFirstChild(x) and (not y.WorkerContents:FindFirstChildOfClass("Tool") or y.WorkerContents:FindFirstChildOfClass("Tool"):FindFirstChild("Amount").Value < 50)  then
                        Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = x, [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if LocalPlayer.Backpack:FindFirstChild("coal") and not y.WorkerFuel:FindFirstChildOfClass("Tool") then
                       Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = "coal", [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if y.WorkerOutputContents:FindFirstChildOfClass("Tool") then
                        Settings.Other.NeedsNoclip = true
                        Teleport(y.CFrame * CFrame.new(0, 7, 0), MachinerySettings.Smelting, true, true)
                        Settings.Other.NeedsNoclip = false
                        Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = y.WorkerOutputContents:FindFirstChildOfClass("Tool"), [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                    end
                end
                task.wait()
            end
        end
    end)
end, {enabled = MachinerySettings.Smelting})

--[[Auto Saw]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Saw["Item Dropdown"..v:split("")[1]] = Saw:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.SawDropdown[ID] = nil 
        else
            Settings.SawDropdown[ID] = SelectedItem == "Oak Wood" and "wood" or SelectedItem == "Cherry Blossom" and "woodCherryBlossom" or "wood"..SelectedItem:split(" ")[1]
        end
        Save()
    end, {default = Settings.SawDropdown[ID], options = {"(Select/None)", "Oak Wood", "Pine Wood", "Birch Wood", "Maple Wood", "Hickory Wood", "Spirit Wood", "Cherry Blossom"}})
end

Saw:Cheat("Checkbox", AddEmoji("Sawmill Items", "Axe"), function(State)
    MachinerySettings.Sawing = State
    Settings.Other.NeedsNoclip = false
    Notify("Auto Sawmill was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local Sawmills = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name == "sawmill" and not table.find(Sawmills, v) then
                Sawmills[#Sawmills + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while MachinerySettings.Sawing and task.wait() do            
            for _,x in next, Settings.SawDropdown do
                for _,y in next, Sawmills do
                    if LocalPlayer.Backpack:FindFirstChild(x) and (not y.WorkerContents:FindFirstChildOfClass("Tool") or y.WorkerContents:FindFirstChildOfClass("Tool"):FindFirstChild("Amount").Value < 50)  then
                        Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = x, [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if LocalPlayer.Backpack:FindFirstChild("coal") and not y.WorkerFuel:FindFirstChildOfClass("Tool") then
                       Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = "coal", [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if y.WorkerOutputContents:FindFirstChildOfClass("Tool") then
                        Settings.Other.NeedsNoclip = true
                        Teleport(y.CFrame * CFrame.new(0, 7, 0), MachinerySettings.Sawing, true, true)
                        Settings.Other.NeedsNoclip = false
                        Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = y.WorkerOutputContents:FindFirstChildOfClass("Tool"), [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                    end
                end
                task.wait()
            end
        end
    end)
end, {enabled = MachinerySettings.Sawing})

--[[Auto Cutter]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Cutter["Item Dropdown"..v:split("")[1]] = Cutter:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.CutterDropdown[ID] = nil 
        else
            Settings.CutterDropdown[ID] = SelectedItem == "Compact Ice" and "iceCompact" or SelectedItem == "Red Sandstone" and "sandstoneRed" or SelectedItem == "Slate" and "slateBlock" or SelectedItem == "Marble" and "marbleBlock" or SelectedItem == "Aquamarine" and "prismarineBlock" or SelectedItem == "Diorite Brick" and "dioriteBrick" or SelectedItem == "Andesite Brick" and "andesiteBrick" or SelectedItem == "Granite Brick" and "graniteBrick" or SelectedItem == "Marble Brick" and "marbleBrick" or SelectedItem == "Slate Brick" and "slateBrick" or SelectedItem == "Aquamarine Brick" and "aquamarineBrick" or SelectedItem == "Stone Brick" and "stoneBrick" or SelectedItem == "Diorite Tiles" and "dioriteTiles" or SelectedItem == "Andesite Tiles" and "andesiteTiles" or SelectedItem == "Granite Tiles" and "graniteTiles" or SelectedItem == "Marble Tiles" and "marbleTiles" or SelectedItem == "Slate Tiles" and "slateTiles" or SelectedItem == "Aquamarine Tiles" and "aquamarineTiles" or SelectedItem == "Stone Tiles" and "stoneTiles" or SelectedItem == "Smooth Aquamarine" and "aquamarineSmooth" or SelectedItem == "Smooth Sandstone" and "sandstoneSmooth" or SelectedItem == "Smooth Red Sandstone" and "sandstoneRedSmooth" or SelectedItem:lower()
        end
        Save()
    end, {default = Settings.CutterDropdown[ID], options = {"(Select/None)", "Stone", "Sandstone", "Red Sandstone", "Aquamarine", "Slate", "Marble", "Compact Ice", "Diorite", "Andesite", "Granite", "Diorite Brick", "Andesite Brick", "Granite Brick", "Marble Brick", "Aquamarine Brick", "Slate Brick", "Stone Brick", "Diorite Tiles", "Andesite Tiles", "Granite Tiles", "Marble Tiles", "Aquamarine Tiles", "Slate Tiles", "Stone Tiles", "Smooth Aquamarine", "Smooth Sandstone", "Smooth Red Sandstone"}})
end

Cutter:Cheat("Checkbox", AddEmoji("Stonecut Items", "Craft"), function(State)
    MachinerySettings.Cutter = State
    Settings.Other.NeedsNoclip = false
    Notify("Auto Stonecut was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local Stonecutters = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name == "stonecutter" and not table.find(Stonecutters, v) then
                Stonecutters[#Stonecutters + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while MachinerySettings.Cutter and task.wait() do            
            for _,x in next, Settings.CutterDropdown do
                for _,y in next, Stonecutters do
                    if LocalPlayer.Backpack:FindFirstChild(x) and (not y.WorkerContents:FindFirstChildOfClass("Tool") or y.WorkerContents:FindFirstChildOfClass("Tool"):FindFirstChild("Amount").Value < 50)  then
                        Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = x, [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if LocalPlayer.Backpack:FindFirstChild("coal") and not y.WorkerFuel:FindFirstChildOfClass("Tool") then
                       Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = "coal", [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if y.WorkerOutputContents:FindFirstChildOfClass("Tool") then
                        Settings.Other.NeedsNoclip = true
                        Teleport(y.CFrame * CFrame.new(0, 7, 0), MachinerySettings.Cutter, true, true)
                        Settings.Other.NeedsNoclip = false
                        Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = y.WorkerOutputContents:FindFirstChildOfClass("Tool"), [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                    end
                end
                task.wait()
            end
        end
    end)
end, {enabled = MachinerySettings.Cutter})

--[[Auto Compost]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Compost["Item Dropdown"..v:split("")[1]] = Compost:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.CompostDropdown[ID] = nil 
        else
            Settings.CompostDropdown[ID] = "fish"..SelectedItem
        end
        Save()
    end, {default = Settings.CompostDropdown[ID], options = {"(Select/None)", "Carp", "Salmon", "Catfish", "Clownfish", "Eel", "Grouper", "RedSnapper", "RoyalBlueTang", "Spirit", "Swordfish", "Talapia", "Trout", "Tuna"}})
end

Compost:Cheat("Checkbox", AddEmoji("Compost Fish", "Fish"), function(State)
    MachinerySettings.Compost = State
    Settings.Other.NeedsNoclip = false
    Notify("Auto Compost was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local Composters = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name == "composter" and not table.find(Composters, v) then
                Composters[#Composters + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while MachinerySettings.Compost and task.wait() do            
            for _,x in next, Settings.CompostDropdown do
                for _,y in next, Composters do
                    if LocalPlayer.Backpack:FindFirstChild(x) and (not y.WorkerContents:FindFirstChildOfClass("Tool") or y.WorkerContents:FindFirstChildOfClass("Tool"):FindFirstChild("Amount").Value < 20)  then
                        Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = x, [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    if y.WorkerOutputContents:FindFirstChildOfClass("Tool") then
                        Settings.Other.NeedsNoclip = true
                        Teleport(y.CFrame * CFrame.new(0, 7, 0), MachinerySettings.Compost, true, true)
                        Settings.Other.NeedsNoclip = false
                        Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = y.WorkerOutputContents:FindFirstChildOfClass("Tool"), [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                    end
                end
                task.wait()
            end
        end
    end)
end, {enabled = MachinerySettings.Compost})

--[[Auto Polish]]--
for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    Polish["Item Dropdown"..v:split("")[1]] = Polish:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.PolishDropdown[ID] = nil 
        else
            Settings.PolishDropdown[ID] = SelectedItem == "Sandstone" and "sandstone" or SelectedItem == "Sandstone Red" and "sandstoneRed" or SelectedItem == "Aquamarine" and "prismarineBlock" or SelectedItem == "Slate" and "slateBlock" or SelectedItem == "Marble" and "marbleBlock" or SelectedItem:lower()
        end
        Save()
    end, {default = Settings.PolishDropdown[ID], options = {"(Select/None)", "Sandstone", "Sandstone Red", "Aquamarine", "Marble", "Slate", "Stone", "Diorite", "Andesite", "Granite"}})
end

Polish:Cheat("Checkbox", AddEmoji("Polish Items", "Shine"), function(State)
    MachinerySettings.Polish = State
    Settings.Other.NeedsNoclip = false
    Notify("Auto Polish was "..GetMessage(State), 1)
    Save()

    task.spawn(function()
        local PolishTables = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if v.Name == "polishingStation" and not table.find(PolishTables, v) then
                PolishTables[#PolishTables + 1] = v
            end
        end
        Teleport(HumanoidRootPart.CFrame)
        while MachinerySettings.Polish and task.wait() do            
            for _,x in next, Settings.PolishDropdown do
                for _,y in next, PolishTables do
                    if LocalPlayer.Backpack:FindFirstChild(x) and v:FindFirstChild("WorkerContents") and #v.WorkerContents:GetChildren() < 2 then
                        Remotes["CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST"]:InvokeServer({["amount"] = 1, ["block"] = y, ["toolName"] = x, [Keys.DepositToolArgName] = Keys.DepositToolArgCode})
                    end
                    for _,z in next, v.WorkerContents:GetChildren() do
                        if z.Name ~= "sandstone" and z.Name ~= "sandstoneRed" and z.Name ~= "prismarineBlock" and z.Name ~= "marbleBlock" and z.Name ~= "slateBlock" and z.Name ~= "stone" and z.Name ~= "diorite" and z.Name ~= "andesite" and z.Name ~= "granite" then
                            Settings.Other.NeedsNoclip = true
                            Teleport(y.CFrame * CFrame.new(0, 7, 0), MachinerySettings.Polish, true, true)
                            Settings.Other.NeedsNoclip = false
                            Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = z, [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                        end
                    end
                end
                task.wait()
            end
        end
    end)
end, {enabled = MachinerySettings.Polish})

local Utility = 0
UpgradeTotems:Cheat("Textbox", "Utility", function(Value)
    Utility = tonumber(Value)
end, {placeholder = "Ex. "..math.random(1,40)})

local Efficiency = 0
UpgradeTotems:Cheat("Textbox", "Efficiency", function(Value)
    Efficiency = tonumber(Value)
end, {placeholder = "Ex. "..math.random(1,40)})

local Quality = 0
UpgradeTotems:Cheat("Textbox", "Quality", function(Value)
    Quality = tonumber(Value)
end, {placeholder = "Ex. "..math.random(1,40)})

for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    UpgradeTotems["Item Dropdown"..v:split("")[1]] = UpgradeTotems:Cheat("Dropdown", v.." Item", function(SelectedItem)
        if SelectedItem == "(Select/None)" then 
            Settings.TotemUpgrade[ID] = nil 
        else
            Settings.TotemUpgrade[ID] = "totem"..SelectedItem
        end
        Save()
    end, {default = Settings.TotemUpgrade[ID], options = {"(Select/None)", "Wheat", "Tomato", "Potato", "Carrot", "Radish", "Onion", "Pumpkin", "Pineapple", "Melon", "Starfruit", "Clay", "Aquamarine", "Sandstone", "RedSandstone", "Obsidian", "Andesite", "Diorite", "Granite", "Stone", "Iron", "Coal", "Slate", "Marble"}})
end

UpgradeTotems:Cheat("Checkbox", AddEmoji("Upgrade Totems", "Box"), function(State)
    MachinerySettings.UpgradeTotems = State
    Notify("Totem Upgrader was "..GetMessage(State), 1)
    
    task.spawn(function()
        local Totems = {}
        for _,v in next, GetIsland().Blocks:GetChildren() do
            if table.find(Settings.TotemUpgrade, v.Name) and not table.find(Totems, v) then
                Totems[#Totems + 1] = v
            end
        end
        while MachinerySettings.UpgradeTotems and task.wait() do
            for _,v in next, Totems do
                if MachinerySettings.UpgradeTotems and v:FindFirstChild("UpgradeProgress") then
                    local UpgradeProgress = v.UpgradeProgress
                    local TotemType = (v.Name == "totemWheat" or v.Name == "totemTomato" or v.Name == "totemPotato" or v.Name == "totemCarrot" or v.Name == "totemRadish" or v.Name == "totemOnion" or v.Name == "totemPumpkin" or v.Name == "totemPineapple" or v.Name == "totemMelon" or v.Name == "totemStarfruit") and "totem_crop" or "totem_rock"
                    if UpgradeProgress.utility.Value < Utility then
                        task.spawn(function()
                            repeat task.wait() 
                                OldValue = UpgradeProgress.utility.Value
                                if UpgradeProgress.utility.Value < Utility then
                                    Remotes["UpgradeBlock"]:InvokeServer(v, TotemType, "utility")
                                end
                                repeat task.wait() until OldValue ~= UpgradeProgress.utility.Value
                            until not v.Parent or not MachinerySettings.UpgradeTotems or UpgradeProgress.utility.Value >= Utility
                            --print("Utility Finished: "..UpgradeProgress.utility.Value)
                        end)
                    end
                    if UpgradeProgress.efficiency.Value < Efficiency then
                        task.spawn(function()
                            repeat task.wait() 
                                OldValue = UpgradeProgress.efficiency.Value
                                if UpgradeProgress.efficiency.Value < Efficiency then
                                    Remotes["UpgradeBlock"]:InvokeServer(v, TotemType, "efficiency")
                                end
                                repeat task.wait() until OldValue ~= UpgradeProgress.efficiency.Value
                            until not v.Parent or not MachinerySettings.UpgradeTotems or UpgradeProgress.efficiency.Value >= Efficiency
                            --print("Efficiency Finished: "..UpgradeProgress.efficiency.Value)
                        end)
                    end
                    if UpgradeProgress.quality.Value < Quality then
                        task.spawn(function()
                            repeat task.wait() 
                                OldValue = UpgradeProgress.quality.Value
                                if UpgradeProgress.quality.Value < Quality then
                                    Remotes["UpgradeBlock"]:InvokeServer(v, TotemType, "quality")
                                end
                                repeat task.wait() until OldValue ~= UpgradeProgress.quality.Value
                            until not v.Parent or not MachinerySettings.UpgradeTotems or UpgradeProgress.quality.Value >= Quality
                            --print("Quality Finished: "..UpgradeProgress.quality.Value)
                        end)
                    end
                    repeat task.wait() until UpgradeProgress.utility.Value >= Utility and UpgradeProgress.efficiency.Value >= Efficiency and UpgradeProgress.quality.Value >= Quality
                end
            end
        end
    end)
end, {enabled = MachinerySettings.UpgradeTotems})


local flying = true
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local speed, maxspeed = 20, 20
local oldspeed = speed
function Fly()
    local bg = Instance.new("BodyGyro", Character.UpperTorso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = Character.UpperTorso.CFrame
    local bv = Instance.new("BodyVelocity", Character.UpperTorso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    repeat task.wait()
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed + (speed / maxspeed) + 100
            if speed > maxspeed then
                speed = maxspeed
            end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed - 100
            if speed < 0 then
                speed = 0
            end
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity = ((game:GetService("Workspace").CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
        else
            bv.velocity = Vector3.new(0,0.2,0)
        end
        bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*1*speed/maxspeed),0,0)
    until not flying
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = oldspeed
    bg:Destroy()
    bv:Destroy()
    speed = oldspeed
end

Player:Cheat("Button", AddEmoji("Fly", "Fly"), function()
    Notify("Fly Keybind: "..Settings.Keybinds.FlyKey, 1)
    LocalPlayer:GetMouse().KeyDown:connect(function(key)
        if key:lower() == Settings.Keybinds.FlyKey:lower() then
            if flying then 
                flying = false
            else
                flying = true
                Fly()
            end
        elseif key:lower() == "w" then
            ctrl.f = 1
        elseif key:lower() == "s" then
            ctrl.b = -1
        elseif key:lower() == "a" then
            ctrl.l = -1
        elseif key:lower() == "d" then
            ctrl.r = 1
        end
    end)
    LocalPlayer:GetMouse().KeyUp:connect(function(key)
        if key:lower() == "w" then
            ctrl.f = 0
        elseif key:lower() == "s" then
            ctrl.b = 0
        elseif key:lower() == "a" then
            ctrl.l = 0
        elseif key:lower() == "d" then
            ctrl.r = 0
        end
    end)
end, {text = ""})

Player:Cheat("Button", AddEmoji("Noclip", "Noclip"), function()
    Notify("Noclip Keybind: "..Settings.Keybinds.NoclipKey, 1)
    LocalPlayer:GetMouse().KeyDown:connect(function(key)
        if key:lower() == Settings.Keybinds.NoclipKey:lower() then
            local plr = game:GetService("Players")local Z=game:GetService("Players").LocalPlayer;function Torso(plr)if plr.Character then if plr.Character:FindFirstChild("UpperTorso")then return plr.Character.UpperTorso else return plr.Character.Torso end end end;if Clip==true then Clip=false;return end;Clip=true;game:GetService("RunService").Stepped:connect(function()Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.RightFoot.Touched:connect(function(_)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.LeftFoot.Touched:connect(function(a0)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.RightLowerLeg.Touched:connect(function(a1)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.LeftLowerLeg.Touched:connect(function(a2)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.RightHand.Touched:connect(function(a3)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.LeftHand.Touched:connect(function(a4)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.Head.Touched:connect(function(a5)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)Z.Character.Torso.Touched:connect(function(a6)Torso(Z).CanCollide=not Clip;Z.Character.Head.CanCollide=not Clip;Z.Character:WaitForChild("HumanoidRootPart").CanCollide=not Clip;if Z.Character.UpperTorso then Z.Character.LowerTorso.CanCollide=not Clip end end)
        end
    end)
end, {text = ""})

local PlayerGamepasses = {}
local PlayerItems = {}
local SearchedUsername = nil
local MiscName = AddEmoji("Miscellaneous", "Glass", false, " ")
local PlayerName = AddEmoji("Player Name", "Eyes")
InventoryViewer:Cheat("Textbox", AddEmoji("Player Name", "Eyes"), function(Value)
    PlayerGamepasses = {}
    PlayerItems = {}
    for _,v in next, UI.container.Categories[MiscName].R["Player Info"].Container:GetChildren() do 
        if v.Name ~= PlayerName and v.Name ~= "UIListLayout" then 
            UI.Features[v.Name] = v:Destroy()
        end
    end
    if Value == "" or Value == " " then
        return
    end
    for _,v in next, game.Players:GetChildren() do
        if string.find(v.Name:lower(), Value:lower()) then
            SearchedUsername = v.Name
            break
        end
    end
    for _,v in next, game.Players[SearchedUsername].Backpack:GetChildren() do
        if v.DisplayName then
            table.insert(PlayerItems, v.DisplayName.Value..": "..v.Amount.Value)
        end
    end
    for _,v in next, game.Players[SearchedUsername].Gamepasses:GetChildren() do
        if v.Value and v.Name ~= "LoadedGamepasses" then
            table.insert(PlayerGamepasses, v.Name)
        end
    end
    table.sort(PlayerItems, function(a, b)
        return a:lower() < b:lower()
    end)

    InventoryViewer:Cheat("Label", "Name: "..game.Players[SearchedUsername].DisplayName.." ("..game.Players[SearchedUsername].Name..")")
    InventoryViewer:Cheat("Label", "Device: "..game.Players[SearchedUsername].DeviceType.Value)
    InventoryViewer:Cheat("Label", "Country Code: "..game.Players[SearchedUsername].CountryCode.Value)
    InventoryViewer:Cheat("Label", "Island Code: "..game.Players[SearchedUsername].JoinCode.Value)
    InventoryViewer:Cheat("Label", "Session Start: "..os.date("%I", game.Players[SearchedUsername].SessionStartTime.Value)..":"..os.date("%M", game.Players[SearchedUsername].SessionStartTime.Value)..":"..os.date("%S", game.Players[SearchedUsername].SessionStartTime.Value).." "..os.date("%p", game.Players[SearchedUsername].SessionStartTime.Value))
    if #PlayerGamepasses == 0 then table.insert(PlayerGamepasses, "N/A") end
    
    InventoryViewer:Cheat("Dropdown", "Gamepasses", function(Value) 
    end, {options = PlayerGamepasses, default = "Open 2 View"})

    InventoryViewer:Cheat("Button", "Save Items List", function()
        writefile("System Exodus/Islands/UserItemInfoSaves/UserItemsList.txt", game.HttpService:JSONEncode(PlayerItems))
        Notify("List has been saved into your exploits workspace folder\n\nSystem Exodus/Islands/UserItemInfoSaves", 5)
    end, {text = ""})
end, {placeholder = "..."})

local FoodItems = {"(Select/None)"}
for _,v in next, ReplicatedStorage.Tools:GetChildren() do
    if v:FindFirstChild("food") then
        table.insert(FoodItems, v.Name)
    end
end

for _,v in next, WhitelistedAmount do 
    local ID = tonumber(v:split("")[1])
    AutoEat["Item Dropdown"..v:split("")[1]] = AutoEat:Cheat("Dropdown", v.." Item", function(SelectedEatItem)
        if SelectedBoss == "(Select/None)" then 
            Settings.EatDropdown[ID] = nil 
        else
            Settings.EatDropdown[ID] = SelectedEatItem
        end
        Save()
    end, {default = Settings.EatDropdown[ID], options = FoodItems})
end

local EatCooldown = 900
AutoEat:Cheat("Textbox", AddEmoji("Cooldown (s)", "Watch"), function(Value)
    EatCooldown = Value
end, {placeholder = "Ex. 900"})

AutoEat:Cheat("Checkbox", AddEmoji("Auto Eat Food", "Food"), function(State)
    MiscSettings.AutoEat = State
    Save()
    task.spawn(function()
        while MiscSettings.AutoEat and task.wait() do
            for _,v in next, Settings.EatDropdown do 
                if LocalPlayer.Backpack:FindFirstChild(v) or Character[v] then
                    EquipTool(LocalPlayer.Backpack[v] or Character[v])
                    Remotes["CLIENT_EAT_FOOD"]:InvokeServer({["tool"] = Character[v]})
                    task.wait(.3)
                end
            end
            wait(EatCooldown)
        end
    end)
end, {enabled = MiscSettings.AutoEat})

OtherMisc:Cheat("Button", "Insta Collect XP", function()
    if not Whitelisted then
        Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    elseif Whitelisted then
        XP()
    end
end, {text = ""})

OtherMisc:Cheat("Button", "Disable XP", function()
    local ServerToClientEventId = require(ReplicatedStorage.TS.event["server-event-id"]).ServerToClientEventId
    local spawnExperienceEvent = ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["server_event_"..ServerToClientEventId.SPAWN_EXPERIENCE_ORBS]
    require(ReplicatedStorage.TS.util["block-utils"]).BlockUtils.textDropEffect = function() end
    for i,v in next, getconnections(spawnExperienceEvent.OnClientEvent) do
        v:Disable()
    end
end, {text = ""})

OtherMisc:Cheat("Button", "Disable Dropping", function()
    for _,v in next, require(ReplicatedStorage.TS.tool["tool-meta"]).ToolMeta do
        v["notDroppable"] = not v["notDroppable"]
    end
end, {text = ""})

OtherMisc:Cheat("Button", "Remove Grass", function()    
    local Grass = {}
    for _,v in next, GetIsland().Blocks:GetChildren() do
        if v.Name:find("tallGrass") then
            table.insert(Grass, v)
        end
    end
    table.sort(Grass, function(i, v)
        return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
    end)
    for _,v in next, Grass do
        if v.Name:find("tallGrass") then
            repeat task.wait()
                EquipTool(GetBestItem(Pickaxes))
                Teleport(v.CFrame * CFrame.new(0, 4, 0), nil, nil, true)
                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
            until not v.Parent
        end
    end
end, {text = ""})

OtherMisc:Cheat("Button", "Remove Rocks", function()    
    local Rocks = {}
    for _,v in next, GetIsland().Blocks:GetChildren() do
        if v.Name:find("naturalRock") then
            table.insert(Rocks, v)
        end
    end
    table.sort(Rocks, function(i, v)
        return (HumanoidRootPart.Position - Vector3.new(i.Position.X, HumanoidRootPart.Position.Y, i.Position.Z)).magnitude < (HumanoidRootPart.Position - Vector3.new(v.Position.X, HumanoidRootPart.Position.Y, v.Position.Z)).magnitude
    end)
    for _,v in next, Rocks do
        if v.Name:find("naturalRock") then
            repeat task.wait()
                EquipTool(GetBestItem(Pickaxes))
                Teleport(v.CFrame * CFrame.new(0, 4, 0), nil, nil, true)
                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
            until not v.Parent
        end
    end
end, {text = ""})

OtherMisc:Cheat("Checkbox", "Collect Nearby Items", function(State)
    MiscSettings.CollectNearItems = State
    Save()
    task.spawn(function()
        while MiscSettings.CollectNearItems and task.wait() do
            for _,v in next, GetNearItems(20) do 
                task.spawn(function()
                    Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({["tool"] = v, [Keys.PickupToolArgName] = Keys.PickupToolArgCode})
                end)
            end
            task.wait()
        end
    end)
end, {enabled = MiscSettings.CollectNearItems})

OtherMisc:Cheat("Checkbox", "Plow Nearby", function(State)
    MiscSettings.Plow = State
    Save()
    task.spawn(function()
        while MiscSettings.Plow and task.wait() do
            for _,v in next, GetNearGrass(8) do 
                task.spawn(function()
                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["CLIENT_PLOW_BLOCK_REQUEST"]:InvokeServer({["block"] = v})
                end)
            end
            task.wait(0.1)
        end
    end)
end, {enabled = MiscSettings.Plow})

OtherMisc:Cheat("Checkbox", "UnPlow Nearby", function(State)
    MiscSettings.UnPlow = State
    Save()
    task.spawn(function()
        while MiscSettings.UnPlow and task.wait() do
            for _,v in next, GetNearSoil(8) do 
                task.spawn(function()
                    ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]["CLIENT_PLOW_BLOCK_REQUEST"]:InvokeServer({["block"] = v})
                end)
            end
            task.wait(0.1)
        end
    end)
end, {enabled = MiscSettings.UnPlow})

OtherMisc:Cheat("Checkbox", "Always Day", function(State)
    MiscSettings.AlwaysDay = State
    Save()
    task.spawn(function()
        while MiscSettings.AlwaysDay and task.wait() do
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 12
        end
    end)
end, {enabled = MiscSettings.AlwaysDay})

OtherMisc:Cheat("Checkbox", "Always Night", function(State)
    MiscSettings.AlwaysNight = State
    Save()
    task.spawn(function()
        while MiscSettings.AlwaysNight and task.wait() do
            game.Lighting.ClockTime = 0
        end
    end)
end, {enabled = MiscSettings.AlwaysNight})

OtherMisc:Cheat("Checkbox", "Open 2020 Presents", function(State)
    MiscSettings.Open2020Presents = State
    Save()
    task.spawn(function()
        while MiscSettings.Open2020Presents and task.wait() do
            if LocalPlayer.Backpack:FindFirstChild("christmasPresentTool") then
                EquipTool(LocalPlayer.Backpack.christmasPresentTool or Character["christmasPresentTool"])
                Remotes["client_request_22"]:InvokeServer({})
            end
        end
    end)
end, {enabled = MiscSettings.Open2020Presents})

OtherMisc:Cheat("Checkbox", "Open 2021 Presents", function(State)
    MiscSettings.Open2021Presents = State
    Save()
    task.spawn(function()
        while MiscSettings.Open2021Presents and task.wait() do
            if LocalPlayer.Backpack:FindFirstChild("christmasPresentTool2") then
                EquipTool(LocalPlayer.Backpack.christmasPresentTool2 or Character["christmasPresentTool2"])
                Remotes["client_request_22"]:InvokeServer({})
            end
        end
    end)
end, {enabled = MiscSettings.Open2021Presents})

OtherMisc:Cheat("Checkbox", "Open 2022 Presents", function(State)
    MiscSettings.Open2022Presents = State
    Save()
    task.spawn(function()
        while MiscSettings.Open2022Presents and task.wait() do
            if LocalPlayer.Backpack:FindFirstChild("christmasPresentTool3") then
                EquipTool(LocalPlayer.Backpack.christmasPresentTool3 or Character["christmasPresentTool3"])
                Remotes["client_request_22"]:InvokeServer({})
            end
        end
    end)
end, {enabled = MiscSettings.Open2022Presents})

OtherMisc:Cheat("Checkbox", "Collect Nearby Chests", function(State)
    MiscSettings.CollectNearChests = State
    Save()
    task.spawn(function()
        while MiscSettings.CollectNearChests and task.wait() do
            for _,v in next, GetNearChests(20, true) do 
                task.spawn(function()
                    Remotes["CLIENT_CHEST_TRANSACTION"]:InvokeServer({["chest"] = v, ["tool"] = v.Contents:FindFirstChildWhichIsA("Tool"), ["action"] = "withdraw", ["amount"] = v.Contents:FindFirstChildWhichIsA("Tool").Amount.Value})
                end)
            end
            task.wait(.05)
        end
    end)
end, {enabled = MiscSettings.CollectNearChests})

OtherMisc:Cheat("Checkbox", "Fill Nearby Chest w/ Held Item", function(State)
    MiscSettings.FillNearChests = State
    Save()
    task.spawn(function()
        while MiscSettings.FillNearChests and task.wait() do
            for _,v in next, GetNearChests(20, false) do 
                task.spawn(function()
                    Remotes["CLIENT_CHEST_TRANSACTION"]:InvokeServer({["chest"] = v, ["tool"] = Character:FindFirstChildOfClass("Tool"), ["action"] = "deposit", ["amount"] = 5})
                end)
            end
            task.wait(.05)
        end
    end)
end, {enabled = MiscSettings.FillNearChests})

local VendingItem
local VendingType
VendingMachines:Cheat("Button", AddEmoji("Locate", "Pin"), function()
    if not Whitelisted then
        return Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    end
    local Found = 0
    for _,v in next, GetNearestIsland().Blocks:GetChildren() do
        if v.Name:find("vendingMachine") and v:FindFirstChild("Mode") and (VendingType == "Buy" and v.Mode.Value == 0 or VendingType == "Sell" and v.Mode.Value == 1) and v:FindFirstChild("SellingContents") and v.SellingContents:FindFirstChild(VendingItem) then
            task.spawn(function()
                if v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = v
                Highlight.Adornee = v.VendingMachine
                Highlight.Enabled = true
                Highlight.FillColor = Color3.fromRGB(0,255,0)
                Highlight.OutlineColor = Color3.fromRGB(0,0,0)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                Found = Found + 1
                task.wait(30)
                v.Highlight:Destroy()
            end)
        end
    end
    if Found == 0 then
        Notify(VendingItem.." was not found for "..VendingType.." Vendings.", 5)
    else
        Notify(VendingItem.." was found and highlighted in "..Found.." "..VendingType.." Vending(s) for 30 seconds.", 5)
    end
end, {text = ""})

VendingMachines:Cheat("Textbox", AddEmoji("Set Item", "Sparkle", true), function(Value)
    VendingItem = GetItemName(Value, nil, nil, true)
end, {placeholder = "Ex. Steel Press"})

VendingMachines:Cheat("Dropdown", AddEmoji("Type", "Sparkle", true), function(Value)  
    VendingType = Value
end, {options = {"Buy", "Sell"}, default = "(Select/None)"})

local CraftItem = nil
local CraftAmount = 1
local NewItems = {}
local Colors = {"Pink", "DarkGreen", "Cyan", "Orange", "Red", "White", "Black", "Purple", "Blue", "Yellow", "LightGreen"}
for _,v in next, GetCraftItems("coloringStation") do
    if v:find("Red") then
        for i = 1, #Colors do
            if not table.find(NewItems, tostring(string.gsub(v, "Red", Colors[i]))) then
                table.insert(NewItems, tostring(string.gsub(v, "Red", Colors[i])))
            end
        end
    elseif v:find("White") then
        for i = 1, #Colors do
            if not table.find(NewItems, tostring(string.gsub(v, "White", Colors[i]))) then
                table.insert(NewItems, tostring(string.gsub(v, "White", Colors[i])))
            end
        end
    end
end

CraftAnywhere:Cheat("Dropdown", "Crafting Items", function(Value)  
    CraftItem = GetItemName(Value)
    Bench = "bench"
end, {options = GetCraftItems("workbench4"), default = "(Select/None)"})

CraftAnywhere:Cheat("Dropdown", "Anvil Items", function(Value)  
    CraftItem = GetItemName(Value)
    Bench = "anvil"
end, {options = GetCraftItems("anvil"), default = "(Select/None)"})

CraftAnywhere:Cheat("Dropdown", "Colored Items", function(Value)  
    CraftItem = GetItemName(Value)
    Bench = "coloringStation"
end, {options = NewItems, default = "(Select/None)"})

CraftAnywhere:Cheat("Textbox", AddEmoji("Amount", "Amount"), function(Value)
    CraftAmount = tonumber(Value)
end, {placeholder = "Ex. 100"})

CraftAnywhere:Cheat("Button", AddEmoji("Craft Item(s)", "Craft"), function()
    if Bench == "bench" then
        Workbench = GetIsland().Blocks:FindFirstChild("workbench4") or GetIsland().Blocks:FindFirstChild("workbench3") or GetIsland().Blocks:FindFirstChild("workbench2")
    else
        Workbench = GetIsland().Blocks:FindFirstChild(Bench) 
    end

    if not Workbench then 
        return Notify("No Workbench Found.", 3)
    end

    if not table.find(GetCraftItems(Workbench.Name), GetDisplayName(CraftItem)) then 
        return Notify("Item is not in "..Workbench.Name, 3)
    end

    Settings.Other.NeedsNoclip = true
    Teleport(Workbench.CFrame * CFrame.new(0, 5, 0), nil, true)
    Settings.Other.NeedsNoclip = false
    Remotes["CraftTool"]:FireServer("", {{["amount"] = CraftAmount, ["workbenchBlock"] = Workbench, ["toolName"] = CraftItem}})	
end, {text = ""})

Setup1:Cheat("Button", AddEmoji("Select Position", "Purple"), function()
    if WorldEditSettings.ChangeEnd then WorldEditSettings.ChangeEnd = false end
    WorldEditSettings.ChangeStart = true
end, {text = ""})

Setup1:Cheat("Checkbox", AddEmoji("Show Outline", "Map"), function(State)
    WorldEditSettings.ShowOutline = State
    Save()
    IndicatorStart.Transparency = State and 0.5 or 1
    if WorldEditSettings.Start then
        ResizeHandle.Visible = State
    end
    SelectionBox.Visible = State
end, {enabled = WorldEditSettings.ShowOutline})

Setup1:Cheat("Label", "")
Setup1:Cheat("Label", "")

Print:Cheat("Button", AddEmoji("Print Area", "Print"), function()
    if WorldEditSettings.Start then
        if Character:FindFirstChildOfClass("Tool") then
            local BlockType = Character:FindFirstChildOfClass("Tool").Name:gsub("Seeds", "")
            
            local CF, Size = Model:GetBoundingBox()
            local Start, End = CF.Position - Size / 2, CF.Position + Size / 2
            local Start, End = Vector3.new(Mod(Start.X, 3), Mod(Start.Y+3, 3), Mod(Start.Z, 3)), Vector3.new(Mod(End.X-3, 3), Mod(End.Y, 3), Mod(End.Z-3, 3))

            if not Printer then
                Printer = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/4ef058b34331016bdaec5d1ff73c3932.lua"))()
            end
            WorldEditSettings.Printing = Printer.new(Start, End)
            WorldEditSettings.Printing:SetBlock(BlockType)
            WorldEditSettings.Printing:Build({
                Start = function() 
                    Settings.Other.NeedsNoclip = true
                end;
                Build = function(Pos)
                    if LocalPlayer:DistanceFromCharacter(Pos) > 35 then
                        Teleport(CFrame.new(Pos) * CFrame.new(0,10,0), Settings.Other.NeedsNoclip, nil, true)
                    end
                end;
                End = function()
                    Settings.Other.NeedsNoclip = false
                    Teleport(HumanoidRootPart.CFrame)
                end;
            })
        else
            return Notify("Please hold a block of your choice to place.", 3)
        end
    else
        return Notify("Please select both an area to print.", 3)
    end
end, {text = ""})

Print:Cheat("Button", AddEmoji("Destroy Area", "Hammer"), function()
    local CF, Size = Model:GetBoundingBox()
    local Start, End = CF.Position - Size / 2, CF.Position + Size / 2
    local Start, End = Vector3.new(Mod(Start.X, 3), Mod(Start.Y+3, 3), Mod(Start.Z, 3)), Vector3.new(Mod(End.X-3, 3), Mod(End.Y, 3), Mod(End.Z-3, 3))

    if WorldEditSettings.Start then
        if not Printer then
            Printer = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/4ef058b34331016bdaec5d1ff73c3932.lua"))()
        end
        WorldEditSettings.Printing = Printer.new(Start, End)
        WorldEditSettings.Printing:Reverse2({
            Start = function() 
                Settings.Other.NeedsNoclip = true
            end;
            Build = function(Pos)
                if LocalPlayer:DistanceFromCharacter(Pos) > 20 then
                    Teleport(CFrame.new(Pos) * CFrame.new(0,5,0), Settings.Other.NeedsNoclip, nil, true)
                end
            end;
            End = function()
                Settings.Other.NeedsNoclip = false
                Teleport(HumanoidRootPart.CFrame)
            end;
        })
    end
end, {text = ""})

Print:Cheat("Button", AddEmoji("Abort", "Abort"), function()
    if WorldEditSettings.Printing then
        WorldEditSettings.Printing.Abort = true
        Settings.Other.NeedsNoclip = false
        Teleport(HumanoidRootPart.CFrame)
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("Rotate Build X", "Rotate"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.Angles(math.rad(90), 0, 0))
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("Rotate Build Y", "Rotate"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.Angles(0, math.rad(90), 0))
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("Rotate Build Z", "Rotate"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.Angles(0, 0, math.rad(90)))
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("+0.1 Build X", "Add"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.new(0.1, 0, 0))
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("+0.1 Build Y", "Add"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.new(0, 0.1, 0))
    end
end, {text = ""})

Setup:Cheat("Button", AddEmoji("+0.1 Build Z", "Add"), function()
    if MoreSettings.Schematica.Build then
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame * CFrame.new(0, 0, 0.1))
    end
end, {text = ""})

local SchematicaFileName = ""
Load:Cheat("Textbox", AddEmoji("File Name", "File"), function(Value)
    SchematicaFileName = Value:find(".lua") and Value or Value..".lua"
end, {placeholder = "Ex. Build.lua"})

Setup:Cheat("Textbox", AddEmoji("Transparency", "Eyes"), function(Value)
    MoreSettings.Schematica.Build:SetVisibility(Value)
end, {placeholder = "Ex. 0.5"})

Load:Cheat("Button", AddEmoji("Load Build", "Rocket"), function()
    if isfile("System Exodus/Islands/Schematica/"..SchematicaFileName) then
        if MoreSettings.Schematica.Build then 
            Indicator.Parent = workspace
            MoreSettings.Schematica.Build:Destroy()
        end
        local Data = game.HttpService:JSONDecode(readfile("System Exodus/Islands/Schematica/"..SchematicaFileName))
        if not Builder then
            Builder = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/1c7acd5ba2e3382617c85e0edabc4f42.lua"))()
        end
        MoreSettings.Schematica.Build = Builder.new(Data)
    else
        return Notify(SchematicaFileName.." was not found.", 3)
    end
    if Indicator and MoreSettings.Schematica.Build then
        if MoreSettings.Schematica.Build.Model then
            Indicator.Parent = workspace
            MoreSettings.Schematica.Build.Model:Destroy()
        end
        WorldEditSettings.ChangingPosition = false
        MoreSettings.Schematica.Build:Init()
        MoreSettings.Schematica.Build:SetVisibility(0.5)
        MoreSettings.Schematica.Build:Render(WorldEditSettings.ShowBuild)
        MoreSettings.Schematica.Build:SetCFrame(Indicator.CFrame)    
        
        Indicator.Parent = MoreSettings.Schematica.Build.Model
        MoreSettings.Schematica.Build.Model.PrimaryPart = Indicator
    end
    Notify("Schematic has been loaded from your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica", 3)
end, {text = ""})

Load:Cheat("Button", AddEmoji("Print Build", "Print"), function()

    if MoreSettings.Schematica.Build and MoreSettings.Schematica.Build.Model then
        MoreSettings.Schematica.Build:Build({
            Start = function() 
                Settings.Other.NeedsNoclip = true
            end;
            Build = function(Pos)
                if LocalPlayer:DistanceFromCharacter(Pos.Position) > 35 then
                    Teleport(Pos * CFrame.new(0,-10,0), nil, nil, true)
                end
            end;
            End = function()
                Settings.Other.NeedsNoclip = false
                Teleport(HumanoidRootPart.CFrame)
            end;
        })
    end
end, {text = ""})

SchematicaUpgradeTotems = Load:Cheat("Checkbox", AddEmoji("Upgrade Totems", "Box", true), function(State)
    if State and not Whitelisted then
        WorldEditSettings.UpgradeTotems = false
        SchematicaUpgradeTotems:toggleState(false)
        Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    elseif Whitelisted then
        WorldEditSettings.UpgradeTotems = State
        getgenv().UpgradeTotems = State
        Save()
    end
end, {enabled = WorldEditSettings.UpgradeTotems})

Load:Cheat("Checkbox", AddEmoji("Plow Grass", "Herb", true), function(State)
    WorldEditSettings.PlowGrass = State 
    getgenv().PlowGrass = State
    Save()
end, {enabled = WorldEditSettings.PlowGrass})

Load:Cheat("Button", AddEmoji("Abort", "Abort"), function()
    MoreSettings.Schematica.Build.Abort = true
    Settings.Other.NeedsNoclip = false
    Teleport(HumanoidRootPart.CFrame)
end, {text = ""})

local Count = 0
Load:Cheat("Button", AddEmoji("Save Area", "Save"), function()
    if (not Whitelisted and GetNearestIsland().Owners:FindFirstChild(""..LocalPlayer.UserId)) or Whitelisted then
        
        if isfile("System Exodus/Islands/Schematica/"..SchematicaFileName) and Count == 0 then
            Count = Count + 1
            return Notify("Duplicate file found.. Save again to override.", 3)
        end
        if SchematicaFileName == ".lua" or SchematicaFileName == "" or SchematicaFileName == " " or SchematicaFileName == nil then
            return Notify("Please type in a file name.", 3)
        end
        Count = 0
        
        local CF, Size = Model:GetBoundingBox()
        local Start, End = CF.Position - Size / 2, CF.Position + Size / 2
        local Start, End = Vector3.new(Mod(Start.X, 3), Mod(Start.Y+3, 3), Mod(Start.Z, 3)), Vector3.new(Mod(End.X-3, 3), Mod(End.Y, 3), Mod(End.Z-3, 3))
        if not Serializer then
            Serializer = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b86d1276c3ed22e1b3a0e79bd1c0cba3.lua"))()
        end
        writefile("System Exodus/Islands/Schematica/"..SchematicaFileName, game.HttpService:JSONEncode(Serializer.new(Start, End):Serialize()))
        Notify("Schematic has been saved into your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica", 3)
    else
        Notify("Saving other builds on Islands is Premium ONLY!", 3)
    end
end, {text = ""})

Load:Cheat("Button", AddEmoji("Save Island", "Save"), function()
    if (not Whitelisted and GetNearestIsland().Owners:FindFirstChild(""..LocalPlayer.UserId)) or Whitelisted then
        if isfile("System Exodus/Islands/Schematica/"..SchematicaFileName) and Count == 0 then
            Count = Count + 1
            return Notify("Duplicate file found.. Save again to override.", 3)
        end
        if SchematicaFileName == ".lua" or SchematicaFileName == "" or SchematicaFileName == " " or SchematicaFileName == nil then
            return Notify("Please type in a file name.", 3)
        end
        Count = 0

        local Center, Size = GetNearestIsland():GetBoundingBox()
        if not Serializer then
            Serializer = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b86d1276c3ed22e1b3a0e79bd1c0cba3.lua"))()
        end
        writefile("System Exodus/Islands/Schematica/"..SchematicaFileName, game.HttpService:JSONEncode(Serializer.new(Center.Position - Size / 2, Center.Position + Size / 2):Serialize()))
        Notify("Schematic has been saved into your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica", 3)
    else
        Notify("Saving other Islands is Premium ONLY!", 3)
    end
end, {text = ""})

Load:Cheat("Button", AddEmoji("Save Materials", "Save"), function()
    if not isfile("System Exodus/Islands/Schematica/"..SchematicaFileName) then
        return Notify(SchematicaFileName.." was not found.", 3)
    end
    
    itemsNeeded = {}
    
    HTML = '<html> <head> <meta charSet="utf-8"/> <meta name="viewport" content="width=device-width, initial-scale=1"/> <link rel="icon" type="image/png" href="https://cdn.discordapp.com/icons/868496249001746443/a_fdeaac466269194b300775e07c599ce4.gif?size=16"/> <title>Build Materials</title> <script>window.$discordMessage={profiles:{"318070660050059264":{"author":"Jxnt","avatar":"https://cdn.discordapp.com/avatars/318070660050059264/538f928c13e9d14943cea156e8461e87.webp? size=64","roleColor":"#7f79ff"},"944593879213178950":{}}}</script><script>document.addEventListener("click",t=>{let e=t.target;if(!e)return;let o=e?.getAttribute("data-goto");if(o){let r=document.getElementById(`m-${o}`);r?(r.scrollIntoView({behavior:"smooth",block:"center"}),r.style.backgroundColor="rgba(148, 156, 247, 0.1)",r.style.transition="background-color 0.5s ease",setTimeout(()=>{r.style.backgroundColor="transparent"},1e3)):console.warn("Message ${goto} not found.")}});</script><script type="module" src="https://cdn.jsdelivr.net/npm/@derockdev/discord-components-core@^3.5.2/dist/derockdev-discord-components-core/derockdev-discord-components-core.esm.js"></script> </head> <body style="margin:0;min-height:100vh"> <discord-messages style="min-height:100vh"> <discord-header guild="System Exodus" channel="Build-Materials" icon="https://cdn.discordapp.com/icons/868496249001746443/a_fdeaac466269194b300775e07c599ce4.gif?size=128">Thanks for using our script! <33</discord-header>  <discord-message edited="false" highlight="true" profile="318070660050059264"> <discord-bold>Build Materials needed for:</discord-bold> BUILDNAMEHERE <br/> LMAO </discord-message>  <div style="text-align:center;width:100%">https://discord.gg/SystemExodus</div> </discord-messages> </body></html>'
    HTML = HTML:gsub("BUILDNAMEHERE", SchematicaFileName)
    for i,v in next, game.HttpService:JSONDecode(readfile("System Exodus/Islands/Schematica/"..SchematicaFileName)).Blocks do
        if not WorldEditSettings.SaveAsHTML then
            if not WorldEditSettings.SaveWithMaterials then
                table.insert(itemsNeeded, GetDisplayName(i)..": "..#v)
            else
                if LocalPlayer.Backpack:FindFirstChild(i) and LocalPlayer.Backpack[i].Amount then
                    table.insert(itemsNeeded, GetDisplayName(i)..": "..LocalPlayer.Backpack[i].Amount.Value.."/"..#v)
                else
                    table.insert(itemsNeeded, GetDisplayName(i)..": 0/"..#v)
                end
            end
        else
            if HTML:find("LMAO") then
                if WorldEditSettings.SaveWithMaterials then
                    if LocalPlayer.Backpack:FindFirstChild(i) and LocalPlayer.Backpack[i].Amount then
                        HTML = HTML:gsub("LMAO", GetDisplayName(i)..": "..LocalPlayer.Backpack[i].Amount.Value.."/"..#v.."<br/>LMAO")
                    else
                        HTML = HTML:gsub("LMAO", GetDisplayName(i)..": 0/"..#v.."<br/>LMAO")
                    end
                else
                    HTML = HTML:gsub("LMAO", GetDisplayName(i)..": "..#v.."<br/>LMAO")
                end
            end
        end
    end
    HTML = HTML:gsub("LMAO", "")
    
    if not WorldEditSettings.SaveAsHTML then
        table.sort(itemsNeeded, function(a, b)
            return a:lower() < b:lower()
        end)
        if WorldEditSettings.SaveWithMaterials then
            writefile("System Exodus/Islands/Schematica/BuildMaterialSaves/"..SchematicaFileName.." - Materials.lua", "--// Items owned out of items needed.\n"..game.HttpService:JSONEncode(itemsNeeded))
        end
        if not WorldEditSettings.SaveWithMaterials then
            writefile("System Exodus/Islands/Schematica/BuildMaterialSaves/"..SchematicaFileName.." - Materials.lua", game.HttpService:JSONEncode(itemsNeeded))
        end
    else
        writefile("System Exodus/Islands/Schematica/BuildMaterialSaves/"..SchematicaFileName.." - Materials.html", HTML)
    end
    Notify("Build Materials have been saved into your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica/BuildMaterialSaves", 3)
end, {text = ""})

Load:Cheat("Checkbox", AddEmoji("Save as HTML", "Paper", true), function(State)
    WorldEditSettings.SaveAsHTML = State 
    Save()
end, {enabled = WorldEditSettings.SaveAsHTML})

Load:Cheat("Checkbox", AddEmoji("Save with `Have/Needed`", "Add", true), function(State)
    WorldEditSettings.SaveWithMaterials = State 
    Save()
end, {enabled = WorldEditSettings.SaveWithMaterials})

local function FindNearestBlock()

end
Setup:Cheat("Button", AddEmoji("Teleport Build", "Box"), function()
    Handles.Visible = WorldEditSettings.ShowBuild
    Block = nil
    Count = 0
    repeat task.wait() 
        Count = Count + 1
        Block = FindNearBlock(Count)
    until Block
    NumberX = nil
    NumberZ = nil
    if Block.Position.X%3 ~= 0 then
        NumberX = Block.Position.X
    end
    if Block.Position.Z%3 ~= 0 then
        NumberZ = Block.Position.Z
    end
    if Indicator.Parent and Indicator.Parent.ClassName == "Model" then
        Indicator.Parent:SetPrimaryPartCFrame(CFrame.new((NumberX and NumberX or Mod(HumanoidRootPart.Position.X, 3)), Mod(HumanoidRootPart.Position.Y, 3), (NumberZ and NumberZ or Mod(HumanoidRootPart.Position.Z, 3))))
    else
        Indicator.CFrame = CFrame.new((NumberX and NumberX or Mod(HumanoidRootPart.Position.X, 3)), Mod(HumanoidRootPart.Position.Y, 3), (NumberZ and NumberZ or Mod(HumanoidRootPart.Position.Z, 3)))
    end
    NumberX = nil
    NumberZ = nil
end, {text = ""})

Setup:Cheat("Checkbox", AddEmoji("Show Build", "Glass"), function(State)
    WorldEditSettings.ShowBuild = State
    Save()
    Indicator.Transparency = WorldEditSettings.ShowBuild and 0.5 or 1
    Handles.Parent = WorldEditSettings.ShowBuild and game.CoreGui or ReplicatedStorage
    if MoreSettings.Schematica.Build then
        if MoreSettings.Schematica.Build.Model then
            MoreSettings.Schematica.Build:Render(WorldEditSettings.ShowBuild)
        end
    end
end, {enabled = WorldEditSettings.ShowBuild})

--[[local VideoLinkThing = AddEmoji("Video Link", "Link")
Load:Cheat("Label", "\nHow To: Printer / Schematica 101")
Load:Cheat("Button", VideoLinkThing, function()
    UI.Features[VideoLinkThing].button.Text = "Copied"
    setclipboard("https://youtu.be/pyjxDvzcLhI")
    task.wait(1)
    UI.Features[VideoLinkThing].button.Text = "Copy"
end, {text = "Copy"})
Load:Cheat("Label", "\n\n\n\n\n\n\n\n\n\n\n\nThanks to boyrobuxgangster249 for letting me use and modify all this!")]]--

QRCodeFileName = ""
QRCode:Cheat("Textbox", AddEmoji("File Name", "File"), function(Value)
    QRCodeFileName = Value:find(".lua") and Value or Value..".lua"
end, {placeholder = "Ex. QRCode.lua"})

Text = ""
QRCode:Cheat("Textbox", AddEmoji("QR Code Text", "Paper"), function(Value)
    Text = Value
end, {placeholder = "Ex. Islands<3"})

InsideBlock = ""
QRCode:Cheat("Textbox", AddEmoji("Inside Block", "White"), function(Value)
    InsideBlock = GetItemName(Value, true, nil, true)
end, {placeholder = "Ex. Iron Block"})

OutsideBlock = ""
QRCode:Cheat("Textbox", AddEmoji("Outside Block", "Black"), function(Value)
    OutsideBlock = (Value:lower() == "air" or Value == "") and nil or GetItemName(Value, true, nil, true)
end, {placeholder = "Ex. Air"})

QRCode:Cheat("Button", AddEmoji("Save QR Code", "Save"), function()
    if not Whitelisted then
        return Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    end
    if not QRCodeGen then
        QRCodeGen = loadstring(game:HttpGet("https://system-exodus.com/scripts/Islands/Dependencies/CreateQR.lua", true))()
    end
    Matrix = QRCodeGen(Text)
    JSON = MatrixToBlocks(Matrix, InsideBlock, OutsideBlock)
    writefile("System Exodus/Islands/Schematica/"..QRCodeFileName, game.HttpService:JSONEncode(JSON))
    Notify("Schematic has been saved into your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica", 3)
end, {text = ""})

ImageFileName = ""
ConvertImages:Cheat("Textbox", AddEmoji("File Name", "File"), function(Value)
    ImageFileName = Value:find(".lua") and Value or Value..".lua"
end, {placeholder = "Ex. Mario.lua"})

PNG = ""
ConvertImages:Cheat("Textbox", AddEmoji("PNG Link", "Link"), function(Value)
    PNG = Value
end, {placeholder = "Ex. https://..."})

PNGScale = ""
ConvertImages:Cheat("Textbox", AddEmoji("PNG Scale", "Scale"), function(Value)
    PNGScale = Value
end, {placeholder = "Ex. 5"})
ConvertImages:Cheat("Label", AddEmoji("PNG Scale gets divided by the number.", "Warning"))

Skip = 0
ConvertImages:Cheat("Button", AddEmoji("Save PNG", "Save"), function()
    if not Whitelisted then
        return Notify("PREMIUM ONLY, IM POOR SORRY", 3)
    end
    if not ImageConverter then
        ImageConverter = loadstring(game:HttpGet("https://system-exodus.com/scripts/Islands/Dependencies/ConvertImages.lua", true))()
    end
    Blocks = {}

    Notify("Converting PNG to Pixels. (might take a bit)", 5)
    task.wait(0.5)
    Pixels = ImageConverter:ImageConvert(PNG)
    Notify("Resizing PNG. (might take a bit)", 5)
    task.wait(0.5)
    Resized = ImageConverter:ImageResize(Pixels, PNGScale)
    BlockCount = #Resized
    if BlockCount >= 50000 then
        NewSize = PNGScale + math.round((BlockCount/50000) + 0.5)
        Notify("Image was automatically reduced to under 50k blocks. (Scale: "..NewSize..")", 5)
        task.wait(0.5)
        Resized = ImageConverter:ImageResize(Pixels, NewSize)
    end
    Notify("Converting Pixels to Blocks. (might take a bit)", 5)
    task.wait(0.5)
    for _,v in next, Resized do
        if v.a ~= 0 then
            Name = ImageConverter:GetNearestColor({v.r*255, v.g*255, v.b*255})
            if not Blocks[Name] then
                Blocks[Name] = {}
            end
            table.insert(Blocks[Name], {C = {v.x * 3, 0, v.y * 3, 1, 0, 0, 0, 1, 0, 0, 0, 1}})
        end
        Skip = Skip + 1
        if Skip >= 250 then
            task.wait()
            Skip = 0
        end
    end
    writefile("System Exodus/Islands/Schematica/"..ImageFileName, game.HttpService:JSONEncode({Blocks = Blocks, Size = {3, 3, 3}}))
    Notify("Schematic has been saved into your exploits workspace folder.\n\nSystem Exodus/Islands/Schematica", 3)
end, {text = ""})


if Version.PlaceVersion ~= game.PlaceVersion then
    Notify("UI is not updated for this version. Beware of possible Anti Cheat updates!", 5)
end

if isfolder("Islands") and isfolder("Islands/Schematica") then
    Files = listfiles("Islands/Schematica")
    for _,v in next, Files do
        if not isfolder(v) then
            Data = game.HttpService:JSONDecode(readfile(v))
            writefile("System Exodus/"..v, game.HttpService:JSONEncode(Data))
        end
    end
    delfolder("Islands")
end




























































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
