getgenv().Options = {
    Enabled = true,
    
    PineappleAccount = "5s8eg59ngiz0vukla52s",
    WatermelonAccount = "6yubvi1ymzwil9re2pzv",
    ShipwreckAccount = "GivingShipwrecks",

    PineappleSeeds = {
        ["Meshes/crateMetal_melon"] = 23,
        ["pineapple"] = 21
    },

    WatermelonSeeds = {
        ["Meshes/crateMetal_melon"] = 18,
        ["pineapple"] = 16
    },

    ShipwreckPodiums = {
        ["Meshes/crateMetal_melon"] = 52,
        ["pineapple"] = 48
    },

    Remotes = {
        ["PromptTrade"] = "ikjkrGNdpazZpOtsTsqjjiM/apfjUcaowovsUtwnunjicdfjuuxcwgs",
        ["AddItem"] = "ikjkrGNdpazZpOtsTsqjjiM/ehyoasaph",
        ["AcceptTrade"] = "ikjkrGNdpazZpOtsTsqjjiM/odyqWnilzsApdhhotaia"
    },

}

local Webhooks = {
    ["pineappleSeeds"] = "",
    ["melonSeeds"] = "https://discord.com/api/webhooks/asdasd/asdsa-dgqzYsHXOnt",
    ["festivalFishShipwreck"] = "https://discord.com/api/webhooks/asd/asdasd"
}

local function ShopNotifier(Webhook, Account, PurchasedWith, SeedAmount, CrateAmount)
    local msg = {
        ["username"] = "Traskers Purchase Notifier",
        ["avatar_url"] = "https://i.gyazo.com/4fef671d3a361f8c009c074525f27189.webp",
        ["embeds"] = {{
            ["color"] = 12035327,
            ["title"] = Account.." account has made a new sale!",
            ["fields"] = {
                {
                    ["name"] = ":money_with_wings: Purchased with: `"..PurchasedWith.."`",
                    ["value"] = "ㅤ• :pinching_hand: **Items sold:** `"..SeedAmount.."`.\nㅤ• :package: **Crates made:** `"..CrateAmount.."`.",
                    ["inline"] = true
                }
            },
        }}
    }
    syn.request({
        Url = Webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"}, 
        Body = game:GetService("HttpService"):JSONEncode(msg)
    })
end

if not game:IsLoaded() or not game.Players.LocalPlayer.PlayerGui:FindFirstChild("Chat") then 
    game.Loaded:Wait()
    wait(3.5)
end 
workspace:WaitForChild("Islands")

local UI = game.Players.LocalPlayer.PlayerGui
local LocalPlayer = game.Players.LocalPlayer
local Remotes = game.ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
local AccountType = LocalPlayer.Name == Options.WatermelonAccount and "Watermelon" or LocalPlayer.Name == Options.PineappleAccount and "Pineapple" or LocalPlayer.Name == Options.ShipwreckAccount and "Shipwreck"
local SeedType = AccountType == "Watermelon" and "melonSeeds" or AccountType == "Pineapple" and "pineappleSeeds" or AccountType == "Shipwreck" and "festivalFishShipwreck"
local Type = AccountType == "Watermelon" and Options.WatermelonSeeds or AccountType == "Pineapple" and Options.PineappleSeeds or AccountType == "Shipwreck" and Options.ShipwreckPodiums
local Amount = AccountType == "Watermelon" and LocalPlayer.Backpack.melonSeeds.Amount.Value or AccountType == "Pineapple" and LocalPlayer.Backpack.pineappleSeeds.Amount.Value or AccountType == "Shipwreck" and LocalPlayer.Backpack.festivalFishShipwreck.Amount.Value
local TradedPlayer

function CheckOffer(Offer)
    if Offer and Offer:FindFirstChildOfClass("MeshPart") and (Offer:FindFirstChildOfClass("MeshPart").Name == "Meshes/crateMetal_melon" or Offer:FindFirstChildOfClass("MeshPart").Name == "pineapple") then
        return true
    end
    return false
end

task.spawn(function()
    while task.wait() and Options.Enabled do
        if not UI:FindFirstChild("Roact_Trade") then
            for _,v in next, game.Players:GetPlayers() do
                if v.Name ~= Options.PineappleAccount and v.Name ~= Options.WatermelonAccount and v.Name ~= Options.ShipwreckAccount then
                    Remotes[Options.Remotes.PromptTrade]:FireServer("", {{ ["targetUserId"] = v.UserId }})
                    task.wait(0.5)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) and Options.Enabled do
        repeat task.wait() until UI:FindFirstChild("Roact_Trade")
        task.spawn(function()
            local TradeUI = UI["Roact_Trade"]["2"]["2"]["5"].TradeLocalOffers["4"]["4"]
            local OfferUI = TradeUI["1"]["3"]["1"]["2"]
            local OfferAmount = OfferUI:FindFirstChild("2")
            local TradeOffer = OfferUI["1"]["1"]:FindFirstChild("2") and OfferUI["1"]["1"]["2"].Wrapper.Handle or nil
            if OfferAmount and CheckOffer(TradeOffer) then
                OfferType = TradeOffer:FindFirstChildOfClass("MeshPart").Name
                SeedCount = math.floor((OfferAmount.Text/Type[OfferType]))
                Remotes[Options.Remotes.AddItem]:FireServer("", {{ ["toolName"] = SeedType, ["quantity"] = SeedCount }})
                
                repeat task.wait() until TradeUI:FindFirstChild("_Stroke")
                OfferUI = TradeUI["2"]["3"]["1"]["2"]
                TradeOffer = OfferUI["1"]["1"]:FindFirstChild("2") and OfferUI["1"]["1"]["2"].Wrapper.Handle or nil
                OfferAmount = OfferUI:FindFirstChild("2")
                OfferType = TradeOffer:FindFirstChildOfClass("MeshPart").Name

                if CheckOffer(TradeOffer) and tonumber(math.floor(OfferAmount.Text/Type[OfferType])) == tonumber(SeedCount) then
                    OldSeedAmount = LocalPlayer.Backpack:FindFirstChild(SeedType).Amount.Value
                    OldCrateAmount = OfferType == "Meshes/crateMetal_melon" and LocalPlayer.Backpack:FindFirstChild("crateMetalMelon").Amount.Value or LocalPlayer.Backpack:FindFirstChild("crateMetalPineapple").Amount.Value
                    Remotes[Options.Remotes.AcceptTrade]:FireServer("", {{ ["accepted"] = true }} )
                end
            end
        end)
        task.wait(0.5)

    end
end)

task.spawn(function()
    while task.wait() and Options.Enabled do
        if OldSeedAmount and OldCrateAmount and SeedCount then
            if OldSeedAmount > LocalPlayer.Backpack:FindFirstChild(SeedType).Amount.Value then
                NewCrateAmount = OfferType == "Meshes/crateMetal_melon" and LocalPlayer.Backpack:FindFirstChild("crateMetalMelon").Amount.Value or LocalPlayer.Backpack:FindFirstChild("crateMetalPineapple").Amount.Value
                CrateType = OfferType == "Meshes/crateMetal_melon" and "Large Melon Crate" or "Large Pineapple Crate"
                ShopNotifier(Webhooks[SeedType], AccountType, CrateType, SeedCount, NewCrateAmount-OldCrateAmount)
                SeedCount = nil
                OldSeedAmount = nil
                OldCrateAmount = nil
            end
        end
    end
end)

local Cooldown = os.time()
game.Players.PlayerAdded:Connect(function(Player)
    Player.Chatted:Connect(function(Chat)
        if Chat == "!stock" and os.time()-Cooldown >= 10 then
            Cooldown = os.time()
            if LocalPlayer.Backpack:FindFirstChild("festivalFishShipwreck") then
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("I have "..LocalPlayer.Backpack:FindFirstChild("festivalFishShipwreck").Amount.Value.." Fishwreck Podiums", "All")
            else
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("I have 0 Fishwreck Podiums, sorry!!", "All")
            end
        end
    end)
end)

--[[task.spawn(function()
    while task.wait() and Options.Enabled do
        if (AccountType == "Watermelon" and LocalPlayer.Backpack.melonSeeds.Amount.Value or AccountType == "Pineapple" and LocalPlayer.Backpack.pineappleSeeds.Amount.Value) < Amount and TradedPlayer then
            Remotes["CLIENT_CHANGE_ISLAND_ACCESS_LEVEL"]:InvokeServer({ ["player"] = game.Players[TradedPlayer], ["accessRank"] = 1 })
            Amount = AccountType == "Watermelon" and LocalPlayer.Backpack.melonSeeds.Amount.Value or AccountType == "Pineapple" and LocalPlayer.Backpack.pineappleSeeds.Amount.Value
            TradedPlayer = nil
        end
    end
end)]]

LocalPlayer.Idled:Connect(function()
    game.VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game.VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)