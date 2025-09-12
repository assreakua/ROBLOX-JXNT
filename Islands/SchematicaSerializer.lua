local Serializer = {}
do
    
    Serializer.__index = Serializer
    setmetatable(Serializer, {
        __tostring = function()
            return "Serializer"
        end
    })

    local CropList = {"wheat", "tomato", "potato", "carrot", "onion", "cactus", "spinach", "pumpkin", "radish", "chili", "spirit", "starfruit", "melon", "rice", "seaweed", "candyCane", "pineapple", "dragonfruit", "grapeVine", "voidParasite"}
    function Serializer.new(Start, End)
        return setmetatable({Start = Start, End = End}, Serializer)
    end

    function Serializer:Round(Number) 
        if typeof(Number) == "number" then
            return math.round(Number / 3) * 3
        end
    end

    function Serializer:Format(CF)
        local x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33 = CF:components()
        return CFrame.new(self:Round(x), self:Round(y), self:Round(z), m11, m12, m13, m21, m22, m23, m31, m32, m33)
    end

    function Serializer:SetStart(Start)
        self.Start = Start
    end

    function Serializer:SetEnd(End)
        self.End = End
    end
    
    function Serializer:Serialize()
        local Start, End = Vector3.new(math.min(self.Start.X, self.End.X), math.min(self.Start.Y, self.End.Y), math.min(self.Start.Z, self.End.Z)), Vector3.new(math.max(self.Start.X, self.End.X), math.max(self.Start.Y, self.End.Y), math.max(self.Start.Z, self.End.Z))
        local Region = Region3.new(Start, End)
        local Output = {}

        local Model = Instance.new("Model")
        for _,v in next, workspace:FindPartsInRegion3(Region, nil, math.huge) do
            if v.Parent.Name == "Blocks" and not table.find(CropList, v.Name) then
                local Clone = v:Clone()
                if not (Clone:FindFirstChild("top") or Clone:FindFirstChild("bottom")) then
                    if Clone:FindFirstChild("UpgradeProgress") then
                        for _,v in next, Clone:GetChildren() do
                            if v.Name ~= "UpgradeProgress" and v.Name ~= "Bottom" then
                                v:Destroy()
                            end
                        end
                    else
                        Clone:ClearAllChildren()
                    end
                end
                Clone.Parent = Model
                if Output[v.Name] == nil then 
                    Output[v.Name] = {}
                end
            end
        end

        local CF, Size = Model:GetBoundingBox()
        local Start, End = CF.Position - Size / 2, CF.Position + Size / 2
        local Center = self:Format(CFrame.new((Start + End) / 2)) 

        for _,v in next, Model:GetChildren() do
            local InsertTable = {}
            if v.ClassName == "Model" then
                InsertTable.C = {Center:ToObjectSpace(self:Format(v.PrimaryPart.CFrame)):components()}
            elseif v:IsA("BasePart") then
                InsertTable.C = {Center:ToObjectSpace(self:Format(v.CFrame)):components()}
                if v:FindFirstChild("bottom") and v.bottom.Transparency == 1 then
                    InsertTable.U = true
                end
                if v:FindFirstChild("UpgradeProgress") then
                    InsertTable.Q = v.UpgradeProgress.quality.Value
                    InsertTable.E = v.UpgradeProgress.efficiency.Value
                    InsertTable.U = v.UpgradeProgress.utility.Value
                end
            end
            table.insert(Output[v.Name], InsertTable)
        end
        
        return {Size = {Size.X, Size.Y, Size.Z}, Blocks = Output}
    end
end

return Serializer