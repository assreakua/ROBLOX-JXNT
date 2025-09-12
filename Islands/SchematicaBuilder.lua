local Builder = {}
do
    Builder.__index = Builder
    setmetatable(Builder, {
        __tostring = function()
            return "Builder"
        end
    })

    local ReplicatedStorage = game.ReplicatedStorage
    local Remotes = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
    local CropList = {"wheat", "tomato", "potato", "carrot", "onion", "cactus", "spinach", "pumpkin", "radish", "chili", "spirit", "starfruit", "melon", "rice", "seaweed", "candyCane", "pineapple", "dragonfruit", "grapeVine", "voidParasite"}
    local LocalPlayer = game.Players.LocalPlayer
    local ClientInventoryService = require(LocalPlayer.PlayerScripts.TS.ui.inventory["client-inventory-service"]).ClientInventoryService 
    function Builder.new(Data)
        return setmetatable({Data = Data.Blocks, Size = Vector3.new(Data.Size[1], Data.Size[2], Data.Size[3]), Abort = false, Visibility = 0.5}, Builder)
    end

    function Builder:Round(Number) 
        if typeof(Number) == "number" then
            return math.round(Number / 3) * 3
        end
    end

    function Builder:SetupBlock(Model)
        for _,v in next, Model:GetDescendants() do
            if v:IsA("BasePart") then
                v.CanCollide = false
                if v.Transparency ~= self.Visibility and v.Transparency < 1 then
                    v.Transparency = tonumber(self.Visibility) == 1 and 0.99 or self.Visibility
                end
            end
        end
    end

    function Builder:Init()
        local Model = Instance.new("Model")
        Model.Name = "Schematic"
        local Center = Instance.new("Part")
        Center.Position = Vector3.new(0, 0, 0)
        Center.Size = Vector3.new(3, 3, 3)
        Center.Transparency = 1
        Center.CanCollide = false
        Center.Anchored = true
        Center.Name = "[Center]"
        Center.Parent = Model
        Model.PrimaryPart = Center
        for Block, Array in next, self.Data do
            for _,v in next, Array do
                local Part = ReplicatedStorage.Blocks[Block]:Clone()
                if Part:IsA("Model") then
                    Part:SetPrimaryPartCFrame(CFrame.new(unpack(v.C)))
                    if v.U and Part:FindFirstChild("bottom", true) then
                        local Bottom = Part:FindFirstChild("bottom", true)
                        Bottom.Transparency = 1
                        local Top = Part:FindFirstChild("top", true)
                        Top.Transparency = 0
                    end
                    if v.Q and v.E and v.U then
                        local Folder = Instance.new("Folder")
                        Folder.Parent = Part
                        Folder.Name = "UpgradeProgress"
                        for a,b in next, {"quality", "efficiency", "utility"} do
                            local NewName = b
                            local b = Instance.new("IntValue")
                            b.Parent = Folder
                            b.Name = NewName
                            b.Value = NewName == "quality" and v.Q or NewName == "efficiency" and v.E or v.U
                        end
                    end
                elseif Part:IsA("BasePart") then
                    Part.CFrame = CFrame.new(unpack(v.C))
                end
                Part.Parent = Model
                self:SetupBlock(Part)
            end
        end
        self.Model = Model
    end

    function Builder:SetCFrame(CF)
        if self.Model then
            self.Model:SetPrimaryPartCFrame(CF)
            self.Model.PrimaryPart.CFrame = CFrame.new(CF.Position.X, CF.Position.Y, CF.Position.Z)
        end
    end

    function Builder:SetVisibility(Value)
        self.Visibility = Value
        local Skip = 0
        if self.Model then
            for _,v in next, self.Model:GetChildren() do
                self:SetupBlock(v)
                Skip = Skip + 1
                if Skip >= 250 then
                    Skip = 0
                    task.wait()
                end
            end
        end
    end

    function Builder:RecursiveParents(Block, StopAt, NeverAt)
        if NeverAt and (Block and Block.Parent and Block.Parent.Name == StopAt) then
            return false
        end
        if Block and Block.Parent and Block.Parent.Name ~= StopAt then
            return self:RecursiveParents(Block.Parent, StopAt, NeverAt)
        end
        return Block
    end

    --[[function Builder:IsTaken(Position, Block, InModel)
        local Position = Position.p and Position.p or Position
        local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
        for _,v in next, Parts do
            if v:IsA("Model") or v:IsA("BasePart") then
                if not InModel then
                    NewBlock = self:RecursiveParents(v, "Blocks")
                    print(NewBlock)
                end
                if v.Parent and (InModel and v.Parent.Parent.Name == "Schematic") or (not InModel and NewBlock) then
                    return (Block and (InModel and v.Parent or NewBlock) or true)
                end
            end
        end
        return nil
    end

    function Builder:IsTaken(Position, Block, InModel)
        local Position = Position.p and Position.p or Position
        local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
        for _,v in next, Parts do
            if v.Parent and (InModel and v.Parent.Parent.Name == "Schematic") or (not InModel and v.Parent.Name == "Blocks") then
                return (Block and (InModel and v.Parent or v) or true)
            end
        end
        return nil
    end]]--

    function Builder:IsTaken(Position, Block, InModel)
        local Position = Position.p and Position.p or Position
        local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
        local NewBlock = nil
        for _,v in next, Parts do
            if (v:IsA("BasePart") or v:IsA("Model") or v:IsA("Part")) and v.Name ~= "Totem" then
                if not InModel and self:RecursiveParents(v, "Schematic", true) then
                    NewBlock = self:RecursiveParents(v, "Blocks")
                end
                if InModel and v.Parent.Parent.Name == "Schematic" or not InModel and NewBlock then
                    return (Block and (InModel and v.Parent or NewBlock) or true)
                end
            end
        end
        return nil
    end

    function Builder:Render(Appear)
         if self.Model then
             self.Model.Parent = Appear and workspace or ReplicatedStorage
         end
    end

    function Builder:EquipTool(Tool) 
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

    function Builder:Mod(Number, Amount)
        if typeof(Number) == "number" then
            if Number < 0 then
                return - (math.abs(Number) - (math.abs(Number) % Amount))
            end
            return Number - (Number % Amount)
        end
    end

    function Builder:Build(Callback)
        local Counter = 0
        Callback.Start()
        
        local CF, Size = self.Model:GetBoundingBox()
        local Start, End = CF.Position - Size / 2, CF.Position + Size / 2
        local Start, End = Vector3.new(self:Mod(Start.X, 3), self:Mod(Start.Y+3, 3), self:Mod(Start.Z, 3)), Vector3.new(self:Mod(End.X-3, 3), self:Mod(End.Y, 3), self:Mod(End.Z-3, 3))


        for X = Start.X, End.X, 3 do
            if self.Abort then 
                Counter = 0
                break
            end
            for Y = Start.Y, End.Y, 3 do
                if self.Abort then 
                    Counter = 0
                    break
                end
                for Z = Start.Z, End.Z, 3 do
                    if self.Abort then 
                        Counter = 0
                        break
                    end
                    
                    local Position = CFrame.new(X, Y, Z)
                    local ModelBlock = self:IsTaken(Position, true, true)
                    if ModelBlock then
                        local Name = ((ModelBlock.Name == "soil" or ModelBlock.Name == "dirt") and "grass") or ModelBlock.Name
                        local Part = ModelBlock.ClassName == "Model" and ModelBlock.PrimaryPart or ModelBlock:IsA("BasePart") and ModelBlock
                        local Position = Part.CFrame
                        if not self:IsTaken(Position) and not table.find(CropList, Name) and (LocalPlayer.Backpack:FindFirstChild(Name) or LocalPlayer.Character:FindFirstChild(Name)) then
                            task.spawn(function()
                                Counter = Counter + 1
                                repeat task.wait()
                                    Callback.Build(Position)
                                    local Bottom = ModelBlock:FindFirstChild("bottom", true)
                                    Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["cframe"] = Position, ["blockType"] = Name, ["upperSlab"] = Bottom and Bottom.Transparency == 1, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                                    if self.Abort then 
                                        break
                                    end
                                until self:IsTaken(Position) or (not LocalPlayer.Backpack:FindFirstChild(Name) and not LocalPlayer.Character:FindFirstChild(Name)) or self.Abort or Count == 0
                            
                                if UpgradeTotems and ModelBlock:FindFirstChild("UpgradeProgress") then
                                    local UpgradeProgress = ModelBlock.UpgradeProgress
                                    local TotemType = (ModelBlock.Name == "totemWheat" or ModelBlock.Name == "totemTomato" or ModelBlock.Name == "totemPotato" or ModelBlock.Name == "totemCarrot" or ModelBlock.Name == "totemRadish" or ModelBlock.Name == "totemOnion" or ModelBlock.Name == "totemPumpkin" or ModelBlock.Name == "totemPineapple" or ModelBlock.Name == "totemMelon" or ModelBlock.Name == "totemStarfruit") and "totem_crop" or "totem_rock"
                                    local Block = self:IsTaken(Position, true)
                                    if Block and Block:FindFirstChild("UpgradeProgress") then
                                        for _,v in next, {"utility", "efficiency", "quality"} do
                                            repeat task.wait()
                                                if Block.UpgradeProgress[v].Value < UpgradeProgress[v].Value then
                                                    Upgraded = Remotes["UpgradeBlock"]:InvokeServer(Block, TotemType, v).success
                                                    if not Upgraded then
                                                        repeat task.wait() until Upgraded
                                                    end
                                                    Upgraded = false
                                                end
                                            until not Block or not UpgradeTotems or Block.UpgradeProgress[v].Value >= UpgradeProgress[v].Value
                                        end
                                    end
                                end
                                
                                if ModelBlock.Name == "soil" and PlowGrass then
                                    local Tool = LocalPlayer.Backpack:FindFirstChild("hoe") or LocalPlayer.Character:FindFirstChild("hoe")
                                    if Tool then
                                        self:EquipTool(Tool)
                                        Remotes["CLIENT_PLOW_BLOCK_REQUEST"]:InvokeServer({["block"] = self:IsTaken(Position, true)})
                                    end
                                end
                                
                                Counter = Counter - 1
                            end)
                            if Counter >= 50 then
                                repeat task.wait() until Counter == 0 
                            end
                            task.wait(WAmount)
                        end
                    end
                end
            end
        end

        repeat task.wait() until Counter == 0 or self.Abort
        self.Abort = false
        Callback.End()
    
        --[[local Counter = 0
        Callback.Start()
        for _,v in next, self.Model:GetChildren() do
            if self.Abort then 
                self.Abort = false
                Counter = 0
                break
            end
            local Name = ((v.Name == "soil" or v.Name == "dirt") and "grass") or v.Name
            local Part = v.ClassName == "Model" and v.PrimaryPart or v:IsA("BasePart") and v
            if not self:IsTaken(Part.Position) and not table.find(CropList, Name) then
                task.spawn(function()
                    Counter = Counter + 1
                    repeat task.wait()
                        Callback.Build(Part.CFrame)
                        local Bottom = v:FindFirstChild("bottom", true)
                        Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["cframe"] = Part.CFrame, ["blockType"] = Name, ["upperSlab"] = Bottom and Bottom.Transparency == 1, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                    until self:IsTaken(Part.Position) or (not game.Players.LocalPlayer.Backpack:FindFirstChild(Name) and not game.Players.LocalPlayer.Character:FindFirstChild(Name)) or self.Abort or Count == 0
                    
                    
                    if UpgradeTotems and v:FindFirstChild("UpgradeProgress") then
                        local UpgradeProgress = v.UpgradeProgress
                        local TotemType = (v.Name == "totemWheat" or v.Name == "totemTomato" or v.Name == "totemPotato" or v.Name == "totemCarrot" or v.Name == "totemRadish" or v.Name == "totemOnion" or v.Name == "totemPumpkin" or v.Name == "totemPineapple" or v.Name == "totemMelon" or v.Name == "totemStarfruit") and "totem_crop" or "totem_rock"
                        local Block = self:IsTaken(Part.Position, true)
                        if Block and Block:FindFirstChild("UpgradeProgress") then
                            for _,v in next, {"utility", "efficiency", "quality"} do
                                local UpgradeBlock = true
                                repeat task.wait()
                                    if Block.UpgradeProgress[v].Value < UpgradeProgress[v].Value then
                                        task.spawn(function()
                                            UpgradeBlock = Remotes["UpgradeBlock"]:InvokeServer(Block, TotemType, v).success
                                        end)
                                        task.wait()
                                    end
                                until not Block or not UpgradeTotems or not UpgradeBlock or Block.UpgradeProgress[v].Value >= UpgradeProgress[v].Value
                            end
                        end
                    end
                    
                    
                    if v.Name == "soil" and PlowGrass then
                        local Block = self:IsTaken(Part.Position, true)
                        local Tool = LocalPlayer.Backpack:FindFirstChild("hoe") or game.Players.LocalPlayer.Character:FindFirstChild("hoe")
                        if Tool then
                            self:EquipTool(Tool)
                            Remotes["CLIENT_PLOW_BLOCK_REQUEST"]:InvokeServer({["block"] = Block})
                        end
                    end
                    
                    Counter = Counter - 1
                end)
                if Counter >= 200 then
                    repeat task.wait() until Counter == 0 or self.Abort
                end
                task.wait(WAmount)
            end
        end
        repeat task.wait() until Counter == 0 or self.Abort
        self.Abort = false
        Callback.End()]]--
    end

    function Builder:Abort()
        self.Abort = true
    end

    function Builder:Destroy()
        self.Model:Destroy()
        self.Model = nil
        self.Abort = true
        self = nil
    end
end

return Builder