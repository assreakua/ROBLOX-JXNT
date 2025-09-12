local Functions = require(game.ReplicatedStorage.Library.Functions)
local Directory = require(game.ReplicatedStorage.Library.Directory)
local EggCmds = game.ReplicatedStorage.Library.Client:FindFirstChild("CustomEggsCmds") and require(game.ReplicatedStorage.Library.Client.CustomEggsCmds)
local HttpService = game:GetService("HttpService")

local SuffixesLower = {"k", "m", "b", "t"}
local function AddSuffix(Amount)
    local a = math.floor(math.log(Amount, 1e3))
    local b = math.pow(10, a * 3)
    return ("%.2f"):format(Amount / b):gsub("%.?0+$", "") .. (SuffixesLower[a] or "")
end

local function GetDifferences(t1, t2)
    local differences = {}
    local t2Map = {}

    for _, item in ipairs(t2 or {}) do
        t2Map[item] = true
    end

    for _, item in ipairs(t1 or {}) do
        if not t2Map[item] then
            local name, newChance = item:match("^(.*) %- 1 in (.+)$")
            local matched = false

            for oldItem, _ in pairs(t2Map) do
                local oldName, oldChance = oldItem:match("^(.*) %- 1 in (.+)$")

                print("Comparing:", item, "vs", oldItem)

                if name == oldName then
                    matched = true
                    table.insert(differences, {old = item, new = oldItem})
                    t2Map[oldItem] = nil
                    break
                end
            end

            if not matched then
                table.insert(differences, {old = item, new = "N/A"})
            end
        else
            t2Map[item] = nil
        end
    end

    for oldItem, _ in pairs(t2Map) do
        print("Added Item:", oldItem)
        table.insert(differences, {old = "Added", new = oldItem})
    end

    print("Final Differences:", HttpService:JSONEncode(differences))
    return differences
end

local Chances = {}
for _, ClassFolder in ipairs(game.ReplicatedStorage["__DIRECTORY"].DropTables:GetChildren()) do
    local Class = ClassFolder.Name
    Chances[Class] = {}

    for _, Module in ipairs(ClassFolder:GetChildren()) do
        local Name = Module.Name
        local DisplayTable = require(Module):GetDisplayTable()
        
        local CloneDisplay = table.clone(DisplayTable)
        table.sort(CloneDisplay, function(i, v)
            return i.Probability > v.Probability
        end)
        
        Chances[Class][Name] = {}
        for _, v in ipairs(CloneDisplay) do
            table.insert(Chances[Class][Name], v.ItemBase:GetName() .. " - 1 in " .. AddSuffix(1 / (v.Probability)))
        end
    end
end

if EggCmds then
    for _, v in ipairs(EggCmds.All()) do
        if not Chances[v._id] then
            Chances[v._id] = {}
        end
        for _, v2 in ipairs(v._dir.pets) do
            table.insert(Chances[v._id], v2[1] .. " - 1 in " .. AddSuffix(1 / v2[2]))
        end
    end
end

local FolderPath = "System Exodus/" .. (game.PlaceId == 18901165922 and "PETS GO" or "Pet Simulator 99")
local File = FolderPath .. "/Chances.json"
local ChangesFile = FolderPath .. "/Changes.json"
if not isfolder("System Exodus") then makefolder("System Exodus") end
if not isfolder(FolderPath) then makefolder(FolderPath) end

local OldChances = {}
if isfile(File) then
    OldChances = HttpService:JSONDecode(readfile(File))
else
    print("File not found. Writing initial data.")
    writefile(File, HttpService:JSONEncode(Chances))
    return
end


local Changes = {}

for Class, Folders in pairs(Chances) do
    if not OldChances[Class] then
        print("New Class Detected:", Class)
        Changes[Class] = Folders
    else
        for Name, Items in pairs(Folders) do
            local OldItems = OldChances[Class][Name]

            if not OldItems then
                print("New Subcategory Detected:", Class, Name)
                Changes[Class] = Changes[Class] or {}
                Changes[Class][Name] = Items
            else
                local newChanges = GetDifferences(Items, OldItems)
                if #newChanges > 0 then
                    Changes[Class] = Changes[Class] or {}
                    Changes[Class][Name] = newChanges
                end
            end
        end
    end
end

for Class, Folders in pairs(OldChances) do
    if not Chances[Class] then
        print("Removed Class Detected:", Class)
        Changes[Class] = {}
        for Name, Items in pairs(Folders) do
            Changes[Class][Name] = {}
            for _, item in ipairs(Items) do
                table.insert(Changes[Class][Name], {old = item, new = "Removed"})
            end
        end
    else
        for Name, Items in pairs(Folders) do
            if not Chances[Class][Name] then
                print("Removed Subcategory Detected:", Class, Name)
                Changes[Class] = Changes[Class] or {}
                Changes[Class][Name] = {}
                for _, item in ipairs(Items) do
                    table.insert(Changes[Class][Name], {old = item, new = "Removed"})
                end
            end
        end
    end
end


if next(Changes) then
    print("Detected Changes:", HttpService:JSONEncode(Changes))
    writefile(ChangesFile, HttpService:JSONEncode(Changes))
else
    print("No Changes Detected.")
    writefile(ChangesFile, "{}")
end

writefile(File, HttpService:JSONEncode(Chances))
