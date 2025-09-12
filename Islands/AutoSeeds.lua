getgenv().Info = {
    ["AutoBuy"] = true,
    ["AutoDrop"] = true,

    ["MoneyDropper"] = "ss",
    
    ["IslandCode"] = "3BEI9",
    ["MoneyType"] = "crateMetalPineapple",

    ["Excluded"] = {
        "ss",s
        "ss",
        "ss",
        "ss",
        "ss",
        "ss"
    }
}


if not game:IsLoaded() or not game.Players.LocalPlayer.PlayerGui:FindFirstChild("Chat") then 
    game.Loaded:Wait()
    task.wait(3)
end 
workspace:WaitForChild("Islands")

local LocalPlayer = game.Players.LocalPlayer
local Remotes = game.ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]

local function GetIsland(Player)
    for _,v in next, workspace.Islands:GetChildren() do 
        if v.Owners:FindFirstChild(""..Player.UserId) then 
            return v
        end 
    end 
end

local function MerchantRequest(Merchant, Id, Amount)
    Remotes["CLIENT_MERCHANT_ORDER_REQUEST"]:InvokeServer({["merchant"] = Merchant, ["offerId"] = Id, ["amount"] = Amount})
end

LocalPlayer.Idled:Connect(function()
    game.VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game.VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function ResetSaves()
    warn("[Islands]: Resetting Saves!")
    repeat task.wait() 
        for _,v in next, Remotes["GetProfiles"]:InvokeServer().profiles do
            if v.profileId ~= Remotes["GetProfiles"]:InvokeServer().activeProfile then
                Remotes["ResetProfile"]:InvokeServer(v.profileId)
                task.wait(0.5)
            end
        end
    until #Remotes["GetProfiles"]:InvokeServer().profiles < 2
    warn("[Islands]: Finished Resetting Saves!")
end

local function CreateProfile()
    warn("[Islands]: Creating a new profile!")
    Remotes["CreateProfile"]:FireServer()
    if #Remotes["GetProfiles"]:InvokeServer().profiles == 1 then
        task.wait(1)
        CreateProfile()
    end
end

if LocalPlayer.Name == Info.MoneyDropper then
    repeat task.wait() until GetIsland(LocalPlayer) and GetIsland(LocalPlayer):FindFirstChild("Drops")
    local Drops = GetIsland(LocalPlayer).Drops
    
    --[[game.Players.ChildAdded:Connect(function(Player)
        Remotes["CLIENT_DROP_TOOL_REQUEST"]:InvokeServer({ ["tool"] = LocalPlayer.Backpack:FindFirstChild("crateMetalMelon"), ["amount"] = 1 })
    end)]]

    local Keys = {
        PickupToolArgName,
        PickupToolArgCode,
    }
    local function GetRemoteKeys(Type)
        local ClientInventoryService = require(LocalPlayer.PlayerScripts.TS.ui.inventory["client-inventory-service"]).ClientInventoryService
        local InventoryConstants = getconstants(ClientInventoryService.pickupTool)
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
    end
    GetRemoteKeys()
    Drops.ChildAdded:Connect(function(Item)
        if Item.Name ~= "crateMetalMelon" then
            Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({ ["tool"] = Item, [Keys.PickupToolArgName] = Keys.PickupToolArgCode })
        end
    end)

elseif LocalPlayer.Name ~= Info.MoneyDropper and not table.find(Info.Excluded, game.Players.LocalPlayer.Name) then

    --// Join Money Droppers Island
    if not game.Players:FindFirstChild(Info.MoneyDropper) then
        warn("[Islands]: Joining Island!")
        repeat task.wait()
            task.spawn(function()
                Remotes["VISIT_ONLINE_ISLAND"]:InvokeServer({["joinCode"] = Info.IslandCode})
            end)
            task.wait(1)
        until game.Players:FindFirstChild(Info.MoneyDropper)
    end

    --// Might Help :/
    setfpscap(60)
    game:GetService("RunService"):Set3dRenderingEnabled(false)

    --// Reset Other Saves
    ResetSaves()

    --[[
    --// Pickup Money Item
    local MoneyIsland = GetIsland(game.Players[Info.MoneyDropper])
    MoneyIsland:WaitForChild("Drops")
    warn("[Islands]: Waiting for crate!")
    repeat task.wait()
        if MoneyIsland.Drops:FindFirstChild(Info.MoneyType) then
            Remotes["CLIENT_TOOL_PICKUP_REQUEST"]:InvokeServer({ ["tool"] = MoneyIsland.Drops:FindFirstChild(Info.MoneyType) })
        end
    until LocalPlayer.Backpack:FindFirstChild(Info.MoneyType)
    warn("[Islands]: Picked up crate!")

    --// Sell Item
    MerchantRequest("wholesaler", 170, 1)
    repeat task.wait() until LocalPlayer.leaderstats.Coins.Value > 0
    ]]--
    
    --// Buy Seeds
    --MerchantRequest("melon_shop", 2, 3)
    --MerchantRequest("spring_shop_pineapple", 2, 6)
    --MerchantRequest("lunar", 1, 1)
    --repeat task.wait() until (LocalPlayer.Backpack:FindFirstChild("melonSeeds") and LocalPlayer.Backpack:FindFirstChild("pineappleSeeds") and LocalPlayer.Backpack:FindFirstChild("redEnvelope") and LocalPlayer.Backpack:FindFirstChild("festivalFishShipwreck")) or os.time() > 5
    local Timer = os.time()
    repeat task.wait() 
        Remotes["client_request_35"]:InvokeServer()
    until LocalPlayer.Backpack:FindFirstChild("festivalFishShipwreck") or os.time()-Timer > 5

    --// Drop Seeds
    --local MelonSeeds = LocalPlayer.Backpack:FindFirstChild("melonSeeds")
    --local PineappleSeeds = LocalPlayer.Backpack:FindFirstChild("pineappleSeeds")
    --local Envelope = LocalPlayer.Backpack:FindFirstChild("redEnvelope")
    --for _,v in next, {MelonSeeds, PineappleSeeds, Envelope, Shipwreck} do
    local Shipwreck = LocalPlayer.Backpack:FindFirstChild("festivalFishShipwreck")
    for _,v in next, {Shipwreck} do
        for i = 1, v.Amount.Value do
            Remotes["CLIENT_DROP_TOOL_REQUEST"]:InvokeServer({ ["tool"] = v, ["amount"] = 1 })
        end
    end

    --// Create a new Profile
    CreateProfile()
end