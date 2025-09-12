local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

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

local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local NLibrary = ReplicatedStorage.Library
local PlayerScripts = LocalPlayer.PlayerScripts.Scripts

local function LoadModules(Path, IsOne, LoadItself)
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
    for _,v in next, {NLibrary, NLibrary.Directory, NLibrary.Client, NLibrary.Util, NLibrary.Items, NLibrary.Functions, NLibrary.Modules, NLibrary.Balancing} do
        LoadModules(v)
    end
    LoadModules(NLibrary.Shared.Variables, true)
    LoadModules(NLibrary.Client.OrbCmds.Orb, true)
    LoadModules(NLibrary.Client.MiningCmds.BlockWorldClient, true)
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
EnterInstance("MiningEvent")

local function TeleportToZone(SpecificZone)
    local CurrentZone = SpecificZone or Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber()
    local InstanceData = Library.InstancingCmds.Get()
    local Teleports = InstanceData.model:FindFirstChild("Teleports")
    local TeleportPad = Teleports:FindFirstChild(tostring(CurrentZone))
    HumanoidRootPart.CFrame = TeleportPad.CFrame
    task.wait(1)
end

local function AddCommas(Amount)
    local Add = Amount
    while task.wait() do  
        Add, b = string.gsub(Add, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (b == 0) then
            break
        end
    end
    return Add
end

--// Anti AFK
LocalPlayer.PlayerScripts.Scripts.Core["Server Closing"].Enabled = false
LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
Library.Network.Fire("Idle Tracking: Stop Timer")
LocalPlayer.Idled:Connect(function() 
	VirtualUser:CaptureController() 
	VirtualUser:ClickButton2(Vector2.new()) 
end)


TeleportToZone(7)

local Pickaxes = {}
local Inventory = Library.InventoryCmds.State().container._store._byType["Pickaxe"]._byUID
for UID, Data in pairs(Inventory) do
    local ID = Data:GetId()
    if table.find(Settings.Pickaxes, ID) and not Data._data["_lk"] then
        Pickaxes[UID] = Data
    elseif Data._data["_lk"] then
        print(Data._data["_lk"])
    end
end

local FinishedPickaxes = 0
local NeededPickaxes = 0
local RemoteData = {}
for UID, Data in next, Pickaxes do
    NeededPickaxes += 1
    RemoteData[UID] = 1
end

local Count = 0;
local Emeralds = Library.Items.Misc("Emerald Gem")
repeat task.wait()
    Count += 1
    local Distance = (HumanoidRootPart.Position - Vector3.new(20795, -29, -12814)).Magnitude
    if Distance >= 10 then
        HumanoidRootPart.CFrame = CFrame.new(20795, -29, -12814)
    end

    for UID, Data in pairs(Inventory) do
        local ID = Data:GetId()
        if not table.find(Settings.Pickaxes, ID) or not Pickaxes[UID] then
            continue
        end

        local Enchants = {}
        for _,EnchantData in next, Data:GetEnchants() do
            --print(EnchantData.dir.Name..EnchantData.tier)
            table.insert(Enchants, EnchantData.dir.Name.." "..EnchantData.tier)
        end

        local NeededEnchants = 0
        local EnchantsGotten = 0
        for Name, EnchantData in pairs(Settings.Enchants) do
            if type(Name) ~= "string" then 
                warn("[System Exodus]: SCRIPT UPDATED, please look for an updated version with a new config!")
                return
            end
            NeededEnchants += 1
        
            for _, CurrentEnchant in ipairs(Enchants) do
                local CurrentName, CurrentTier = CurrentEnchant:match("(.+)%s(%d+)")
                CurrentTier = tonumber(CurrentTier)
                
                if CurrentName == Name then
                    local RequiredTier = EnchantData.Tier or 1
        
                    if CurrentTier == RequiredTier or (EnchantData.HigherTiers and CurrentTier >= RequiredTier) then
                        EnchantsGotten += 1
                        break
                    end
                end
            end
        end

        if (Settings["Require All Enchants"] and EnchantsGotten >= NeededEnchants) or (not Settings["Require All Enchants"] and EnchantsGotten >= 1) then
            --warn("OMG!!!") 
            FinishedPickaxes += 1
            Pickaxes[UID] = nil
            RemoteData[UID] = nil
        end
    end
    task.wait(1)
    local Success = Library.Network.Invoke("Pickaxe Enchants Machine: Activate", {}, RemoteData)
    print("[System Exodus]: Enchanting Pickaxes. #"..AddCommas(Count).." ("..FinishedPickaxes.."/"..NeededPickaxes..")")
    task.wait(2)
until FinishedPickaxes >= NeededPickaxes or Emeralds:CountExact() <= (NeededPickaxes - FinishedPickaxes)
warn("[System Exodus]: Stopped / Finished Enchanting! "..Emeralds:CountExact().." Emeralds left, "..(NeededPickaxes - FinishedPickaxes).." pickaxes unenchanted.")local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

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

local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local NLibrary = ReplicatedStorage.Library
local PlayerScripts = LocalPlayer.PlayerScripts.Scripts

local function LoadModules(Path, IsOne, LoadItself)
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
    for _,v in next, {NLibrary, NLibrary.Directory, NLibrary.Client, NLibrary.Util, NLibrary.Items, NLibrary.Functions, NLibrary.Modules, NLibrary.Balancing} do
        LoadModules(v)
    end
    LoadModules(NLibrary.Shared.Variables, true)
    LoadModules(NLibrary.Client.OrbCmds.Orb, true)
    LoadModules(NLibrary.Client.MiningCmds.BlockWorldClient, true)
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
EnterInstance("MiningEvent")

local function TeleportToZone(SpecificZone)
    local CurrentZone = SpecificZone or Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber()
    local InstanceData = Library.InstancingCmds.Get()
    local Teleports = InstanceData.model:FindFirstChild("Teleports")
    local TeleportPad = Teleports:FindFirstChild(tostring(CurrentZone))
    HumanoidRootPart.CFrame = TeleportPad.CFrame
    task.wait(1)
end

local function AddCommas(Amount)
    local Add = Amount
    while task.wait() do  
        Add, b = string.gsub(Add, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (b == 0) then
            break
        end
    end
    return Add
end

--// Anti AFK
LocalPlayer.PlayerScripts.Scripts.Core["Server Closing"].Enabled = false
LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
Library.Network.Fire("Idle Tracking: Stop Timer")
LocalPlayer.Idled:Connect(function() 
	VirtualUser:CaptureController() 
	VirtualUser:ClickButton2(Vector2.new()) 
end)


TeleportToZone(7)

local Pickaxes = {}
local Inventory = Library.InventoryCmds.State().container._store._byType["Pickaxe"]._byUID
for UID, Data in pairs(Inventory) do
    local ID = Data:GetId()
    if table.find(Settings.Pickaxes, ID) and not Data._data["_lk"] then
        Pickaxes[UID] = Data
    elseif Data._data["_lk"] then
        print(Data._data["_lk"])
    end
end

local FinishedPickaxes = 0
local NeededPickaxes = 0
local RemoteData = {}
for UID, Data in next, Pickaxes do
    NeededPickaxes += 1
    RemoteData[UID] = 1
end

local Count = 0;
local Emeralds = Library.Items.Misc("Emerald Gem")
repeat task.wait()
    Count += 1
    local Distance = (HumanoidRootPart.Position - Vector3.new(20795, -29, -12814)).Magnitude
    if Distance >= 10 then
        HumanoidRootPart.CFrame = CFrame.new(20795, -29, -12814)
    end

    for UID, Data in pairs(Inventory) do
        local ID = Data:GetId()
        if not table.find(Settings.Pickaxes, ID) or not Pickaxes[UID] then
            continue
        end

        local Enchants = {}
        for _,EnchantData in next, Data:GetEnchants() do
            --print(EnchantData.dir.Name..EnchantData.tier)
            table.insert(Enchants, EnchantData.dir.Name.." "..EnchantData.tier)
        end

        local NeededEnchants = 0
        local EnchantsGotten = 0
        for Name, EnchantData in pairs(Settings.Enchants) do
            if type(Name) ~= "string" then 
                warn("[System Exodus]: SCRIPT UPDATED, please look for an updated version with a new config!")
                return
            end
            NeededEnchants += 1
        
            for _, CurrentEnchant in ipairs(Enchants) do
                local CurrentName, CurrentTier = CurrentEnchant:match("(.+)%s(%d+)")
                CurrentTier = tonumber(CurrentTier)
                
                if CurrentName == Name then
                    local RequiredTier = EnchantData.Tier or 1
        
                    if CurrentTier == RequiredTier or (EnchantData.HigherTiers and CurrentTier >= RequiredTier) then
                        EnchantsGotten += 1
                        break
                    end
                end
            end
        end

        if (Settings["Require All Enchants"] and EnchantsGotten >= NeededEnchants) or (not Settings["Require All Enchants"] and EnchantsGotten >= 1) then
            --warn("OMG!!!") 
            FinishedPickaxes += 1
            Pickaxes[UID] = nil
            RemoteData[UID] = nil
        end
    end
    task.wait(1)
    local Success = Library.Network.Invoke("Pickaxe Enchants Machine: Activate", {}, RemoteData)
    print("[System Exodus]: Enchanting Pickaxes. #"..AddCommas(Count).." ("..FinishedPickaxes.."/"..NeededPickaxes..")")
    task.wait(2)
until FinishedPickaxes >= NeededPickaxes or Emeralds:CountExact() <= (NeededPickaxes - FinishedPickaxes)
warn("[System Exodus]: Stopped / Finished Enchanting! "..Emeralds:CountExact().." Emeralds left, "..(NeededPickaxes - FinishedPickaxes).." pickaxes unenchanted.")
