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

local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxntt/open-source/refs/heads/main/Pet-Simulator-99/Module.lua"))()

Module.EnterInstance("ConveyorInstance")

--// Gather & Purchase LuckyRaid Upgrades \\--
local Upgrades = {}
for ID, Data in next, Library.EventUpgrades do
    if ID:find("Conveyor") then
        Upgrades[ID] = Data
    end
end

local function PurchaseLowestUpgrade()
    local FactoryCoins = Library.CurrencyCmds.Get("FactoryCoins")
    local Upgrade, LowestCost = nil, math.huge
	for ID, Data in next, Upgrades do
        local Tier = Library.EventUpgradeCmds.GetTier(ID)
        if not Data.TierCosts[Tier + 1] or not Data.TierCosts[Tier + 1]._data then
			continue
		end
        local Cost = Data.TierCosts[Tier + 1]._data._am or 1
        if Cost and Cost < LowestCost and FactoryCoins >= Cost then
            LowestCost = Cost
            Upgrade = ID
        end
    end
	if Upgrade then
		Library.EventUpgradeCmds.Purchase(Upgrade)
	end
    return Upgrade
end

local Egg;
local function GetEgg()
    for UID, Info in next, Library.CustomEggsCmds.All() do
        if Info._id:find("Conveyor") and Info._hatchable then
            HumanoidRootPart.CFrame = CFrame.new(Info._position) * CFrame.new(0,-8,-20)
            setthreadidentity(2)
            Cost = Library.CalcEggPricePlayer(Info._dir)
            setthreadidentity(8)
            Egg = UID
        end
    end
end

local ClientPlot = require(NLibrary.Client.PlotCmds.ClientPlot)
local Conveyors = require(Library.Conveyors)
local Plot = ClientPlot.GetByPlayer(LocalPlayer)

local CheapestItemCost = 0
local CheapestItem = 0
--// Upgrade Conveyor Pets
for Pet, Data in next, Plot.LocalVariables.Conveyor.Pets do
    local Level = Plot.SaveVariables["Pet"..Pet].Level
    local FactoryCoins = Library.CurrencyCmds.Get("FactoryCoins")
    local NextUpgradeCost = Library.Conveyors.SpotUpgradeCost(Pet, Level + 1)
    if FactoryCoins >= NextUpgrade then
        Library.Network.Invoke("Plots_Invoke", Plot.Id, "Conveyor_PetUpgrade", Pet)
    end
end

--// Purchase Conveyor Pets
--[[for Pet, Data in next, Plot.LocalVariables.Conveyor.Buttons do
    if Plot.SaveVariables[tostring(Pet)] then continue end
    local NextUnlock = Library.Conveyors.SpotUnlockCost(Data.PetIndex)
    local FactoryCoins = Library.CurrencyCmds.Get("FactoryCoins")
    if FactoryCoins >= NextUpgrade then
        Library.Network.Invoke("Plots_Invoke", Plot.Id, "BuySlot", Data.PetIndex)
    end
end]]--

--[[
local Conveyors = require(game:GetService("ReplicatedStorage").Library.Types.Conveyors)
for Chest, Data in next, Conveyors.ChestDirectory do
    task.spawn(function()
        while task.wait() do
            Library.Network.Invoke("Plots_Invoke", 1, "Conveyor_OpenChest", Chest)
            task.wait(Data.OpenCooldown)
        end
    end)
end

]]
