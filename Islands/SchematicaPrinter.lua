local Printer = {}
do
    Printer.__index = Printer
    setmetatable(Printer, {
        __tostring = function()
            return "Printer"
        end
    })

    local Remotes = game.ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
    function Printer.new(Start, End, Block)
        return setmetatable({Start = Start, End = End, Block = Block, Abort = false}, Printer)
    end

    function Printer:SetStart(Start)
        self.Start = Start
    end

    function Printer:SetEnd(End)
        self.End = End
    end
    
    function Printer:SetBlock(Block)
        self.Block = Block
    end

    function Printer:IsTaken(Position, Block)
        local Parts = workspace:FindPartsInRegion3(Region3.new(Position, Position), nil, math.huge)
        for _,v in next, Parts do
            if v.Parent and v.Parent.Name == "Blocks" then
                return (Block and v or true)
            end
        end
        return false
    end
    
    function Printer:Build(Callback)
        local Counter = 0
        Callback.Start()
        
        
        local Start, End = Vector3.new(math.min(self.Start.X, self.End.X), math.min(self.Start.Y, self.End.Y), math.min(self.Start.Z, self.End.Z)), Vector3.new(math.max(self.Start.X, self.End.X), math.max(self.Start.Y, self.End.Y), math.max(self.Start.Z, self.End.Z))
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
                    local Position = Vector3.new(X, Y, Z)
                    if not self:IsTaken(Position) then
                        task.spawn(function()
                            Counter = Counter + 1
                            repeat task.wait() 
                                Callback.Build(Position)
                                Remotes["CLIENT_BLOCK_PLACE_REQUEST"]:InvokeServer({["cframe"] = CFrame.new(Position), ["blockType"] = self.Block, [Keys.PlaceBlockArgName] = Keys.PlaceBlockArgCode})
                            until self:IsTaken(Position) or self.Abort or not game.Players.LocalPlayer.Character:FindFirstChild(self.Block) or Counter == 0
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
        repeat task.wait() until Counter == 0 or self.Abort
        self.Abort = false
        Callback.End()
    end

    function Printer:Reverse(Callback)
        local Counter = 0
        Callback.Start() 
        
        
        local Start, End = Vector3.new(self.Start.X, self.Start.Y, self.Start.Z), Vector3.new(self.End.X, self.End.Y, self.End.Z)
        local Region = Region3.new(Start, End)
        for _,v in next, workspace:FindPartsInRegion3(Region, nil, math.huge) do
            if tostring(v.Parent) == "Blocks" and v:FindFirstChild("Health") and v.Name ~= "bedrock" and not v:FindFirstChild("portal-to-spawn") then
                if self.Abort then 
                    self.Abort = false
                    Counter = 0
                    break
                end
                task.spawn(function()
                    Counter = Counter + 1
                    repeat task.wait()
                        Callback.Build(v.Position)
                        Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = v, [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                    until not v or not v.Parent or Counter == 0
                    Counter = Counter - 1
                end)
                if Counter >= 50 then
                    repeat task.wait() until Counter == 0
                end
                task.wait(WAmount)
            end
        end
        repeat task.wait() until Counter == 0 or self.Abort
        Callback.End()
    end

    function Printer:Reverse2(Callback)
        local Counter = 0
        Callback.Start()
        
        
        local Start, End = Vector3.new(math.min(self.Start.X, self.End.X), math.min(self.Start.Y, self.End.Y), math.min(self.Start.Z, self.End.Z)), Vector3.new(math.max(self.Start.X, self.End.X), math.max(self.Start.Y, self.End.Y), math.max(self.Start.Z, self.End.Z))
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
                    local Position = Vector3.new(X, Y, Z)
                    if self:IsTaken(Position) then
                        task.spawn(function()
                            Counter = Counter + 1
                            repeat task.wait() 
                                Callback.Build(Position)
                                Remotes["CLIENT_BLOCK_HIT_REQUEST"]:InvokeServer({["block"] = self:IsTaken(Position, true), [Keys.DestroyBlockArgName] = Keys.DestroyBlockArgCode})
                            until not self:IsTaken(Position) or self.Abort or Counter == 0
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
        repeat task.wait() until Counter == 0 or self.Abort
        self.Abort = false
        Callback.End()
    end
end

return Printer