function GenerateNumber(x)
    finalrandomizedstring = ""
    local alotofletters = "1234567890"
    local letterscramped = {}
	for i = 1,string.len(alotofletters) do
	   table.insert(letterscramped,string.sub(alotofletters,i,i))
	end

    local function CombineLetters()
        for q = 1,x do
	       local randomletter =  letterscramped[math.random(1,#letterscramped)]
	       finalrandomizedstring = finalrandomizedstring..randomletter
        end
    end
    CombineLetters()
    return finalrandomizedstring
end

local User = {
    IsARetard = false,
    IsBlacklisted = false,
    IsABetaUser = false
}

if game:FindFirstChild("cc0hub") or game:GetService("Players").LocalPlayer:IsInGroup("989775") then
User.IsABetaUser = true
end

local WeirdExploit = {IsCalamari = false}

if CALAMARI_PLATFORM then 
WeirdExploit.IsCalamari = true
end

function ToServer()
    if syn then
 rconsolename("You have been blacklisted.")
    rconsoleerr("You have been blacklisted.")
    wait(0.5)
    rconsoleerr("Appeal if you feel like this was a mistake.")
    wait(0.5)
    rconsoleerr("And be prepared to show proof.")
    wait(0.5)
    rconsoleerr("---------------------------------------------------------------------------")
    rconsoleerr("People To Appeal To")
    wait(0.5)
    rconsoleerr("---------------------------------------------------------------------------")
    wait(0.5)
    rconsolewarn("Jxnt#9946")
    wait(1)
    rconsolewarn("xxxYoloxxx999#2166")
    wait(1)
    rconsolewarn("Sypher#3415")
    wait(1)
    rconsolewarn("Peace#7593")
	rconsoleerr("-----------------------------------------------------------------------------")
    rconsoleerr("How to appeal")
    wait(1)
    rconsoleerr("-----------------------------------------------------------------------------")
    wait(0.5)
    rconsoleerr("Roblox Username:")
    rconsoleerr("Roblox UserID:")
    rconsoleerr("What you were doing at the time.")
    rconsoleerr("Why were you using setclipboard.")
    rconsoleerr("Why you want to be unblacklisted.")
    else
        game.Players.LocalPlayer:Kick("You have been blacklisted. DM the one following people to appeal your blacklist: \n xxxYoloxxx999#2166 \n Sypher#3415 \n Jxnt#9946 \n Peace#7593")
    end
        while wait() do
        pcall(function()
        game.Players.LocalPlayer:Destroy()
    workspace[game.Players.LocalPlayer.Name]:Destroy()
game.Players.LocalPlayer:Remove()
        end)
    end

        msg = {
            ["embeds"] = {{
                ["color"] = 16711680,
                ["description"] = "Player's ROBLOX Username: "..game.Players.LocalPlayer.Name.."\n".."Player's ROBLOX User ID: "..game.Players.LocalPlayer.UserId.."\n".."Player's Hardware ID: "..game:GetService("RbxAnalyticsService"):GetClientId().."\n".."The Player's Information has been listed as above.",
                ["author"] = {
                    ["name"] = "A Blacklisted Player's Information Has Been Logged"
                }}
            }
        }
        
        local response = syn.request(
            {
                Url = "https://discordapp.com/api/webhooks/ss/ss-ss-oGKP8",
               Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body =  game:GetService("HttpService"):JSONEncode(msg)
            }
        )
        counter = counter + 1
    end

local UserIdsToLog = {}

for i,b in pairs(UserIdsToLog) do
if b == game.Players.LocalPlayer.UserId then
ToServer()
else
end
end


for i,l in pairs(game.ReplicatedStorage:GetChildren()) do
if l.Name == "ninja_legends_v2.loaded" then
l:Destroy()
end
end

local SaveFile = "NinjaLegendsV2Settings.bin"

local DefaultSettings = {
Keybind = "RightShift" -- initial keybind
}

local Config

if not WeirdExploit.IsCalamari then
if not pcall(function() readfile(SaveFile) end) then 
writefile(SaveFile, game:GetService("HttpService"):JSONEncode(DefaultSettings)) 
end
end

if not WeirdExploit.IsCalamari then
Config = game:GetService("HttpService"):JSONDecode(readfile(SaveFile))
end

if not WeirdExploit.IsCalamari then
local function Save()
writefile(SaveFile,game:GetService("HttpService"):JSONEncode(Config))
end
end

local Api = {}
local TeleportService = game:GetService("TeleportService")
local user = game:GetService("Players").LocalPlayer
local mouse = game:GetService('Players').LocalPlayer:GetMouse() -- i needed the mouse because it comes with the keyboard functions

function Api:Rejoin()
TeleportService:Teleport(3956818381, user)
end

function Notify(titletxt, text, time)
    local GUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame", GUI)
    local title = Instance.new("TextLabel", Main)
    local message = Instance.new("TextLabel", Main)
    GUI.Name = "Notification"
    GUI.Parent = game.CoreGui
    Main.Name = "MainFrame"
    Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(1, 5, 0, 50)
    Main.Size = UDim2.new(0, 330, 0, 100)

    title.BackgroundColor3 = Color3.new(0, 0, 0)
    title.BackgroundTransparency = 0.89999997615814
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Font = Enum.Font.SourceSansSemibold
    title.Text = titletxt
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 17
    
    message.BackgroundColor3 = Color3.new(0, 0, 0)
    message.BackgroundTransparency = 1
    message.Position = UDim2.new(0, 0, 0, 30)
    message.Size = UDim2.new(1, 0, 1, -30)
    message.Font = Enum.Font.SourceSansLight
    message.Text = text
    message.TextColor3 = Color3.new(1, 1, 1)
    message.TextSize = 16

    wait(0.1)
    Main:TweenPosition(UDim2.new(1, -330, 0, 50), "Out", "Sine", 0.5)
    wait(time)
    Main:TweenPosition(UDim2.new(1, 5, 0, 50), "Out", "Sine", 0.5)
    wait(0.6)
    GUI:Destroy();
end

function Api:Restart()
loadstring(game:HttpGet("https://jxnt-scripts.com/scripts/ninjalegends/NinjaLegendsV2.lua",true))()
end

for i,x in ipairs(game.CoreGui:GetChildren()) do
for i,gui in ipairs(x:GetChildren()) do
if gui:IsA("ImageLabel") and gui.Name == "Container" then
x:Destroy()
Notify("Ninja Legends v2.9", "Restarting script...", 2)
end
end
end

Notify("Ninja Legends v2.9", "Checking for updates...", 1)
Notify("Ninja Legends v2.9", "Updated to the latest version. Loading...", 2)
local player = game.Players.LocalPlayer
local library = loadstring(game:HttpGet("https://pastebin.com/raw/VMhQa3F5",true))()

local plr = game:service"Players".LocalPlayer; 
local tween_s = game:service"TweenService";
local info = TweenInfo.new(0.3,Enum.EasingStyle.Quad);
function tp(...)
   local tic_k = tick();
   local params = {...};
   local cframe = CFrame.new(params[1],params[2],params[3]);
   local tween,err = pcall(function()
       local tween = tween_s:Create(plr.Character["HumanoidRootPart"],info,{CFrame=cframe});
       tween:Play();
   end)
   if not tween then return err end
end

-- Debug
local SellCircle = nil -- We don't have one yet

function Get(scr)
if string.find(scr, "rstorage") or string.find(scr, "r-storage") or string.find(scr, "r_storage") or string.find(scr, "r-str") or string.find(scr, "r_str") or string.find(scr, "rstr") or string.find(scr, "repstorage") or string.find(scr, "rep-storage") or string.find(scr, "rep_storage") or string.find(scr, "repstr") or string.find(scr, "rep_str") or string.find(scr, "rep-str") or string.find(scr, "rp-str") or string.find(scr, "rp_str") or string.find(scr, "rpstr") or string.find(scr, "rp_storage") or string.find(scr, "rpstorage") or string.find(scr, "rp-storage") then
return game:GetService("ReplicatedStorage")
else 
if string.find(scr, "space") or string.find(scr, "spc") or string.find(scr, "wrkspc") or string.find(scr, "wrk-spc") or string.find(scr, "wrk_spc") or string.find(scr, "wrk_space") or string.find(scr, "wrk-space") or string.find(scr, "wrkspace") or string.find(scr, "workspc") or string.find(scr, "work-spc") or string.find(scr, "work_spc") or string.find(scr, "w-space") or string.find(scr, "wspace") or string.find(scr, "w_space") or string.find(scr, "w-space") or string.find(scr, "wspace") or string.find(scr, "w_spc") or string.find(scr, "wkspace") or string.find(scr, "wk-space") or string.find(scr, "wk_space") or string.find(scr, "wkspc") or string.find(scr, "wk-spc") or string.find(scr, "wk_spc")  then
return game:GetService("Workspace")
else
if string.find(scr, "core_ui") or string.find(scr, "core-ui") or string.find(scr, "coreui") or string.find(scr, "coregui") or string.find(scr, "core_gui") or string.find(scr, "core-gui") or string.find(scr, "c_gui") or string.find(scr, "c-gui") or string.find(scr, "cgui") or string.find(scr, "cui") or string.find(scr, "c-ui") or string.find(scr, "c_ui") or string.find(scr, "cr_gui") or string.find(scr, "cr-gui") or string.find(scr, "crgui") then
return game:GetService("CoreGui")
else
if string.find(scr, "plrName") or string.find(scr, "plr_name") or string.find(scr, "player_name") or string.find(scr, "playername") or string.find(scr, "plr-Name") or string.find(scr, "player-name") then
return game:GetService("Players").LocalPlayer.Name
else
if string.find(scr, "plr") or string.find(scr, "player") then
return game:GetService("Players").LocalPlayer
else
if string.find(scr, "plrs") or string.find(scr, "Players") then
return game:GetService("Players")
else
if string.find(scr, "Light") or string.find(scr, "Lighting") then
return game:GetService("Lighting")
else
if string.find(scr, "starter_ui") or string.find(scr, "starter-ui") or string.find(scr, "starterui") or string.find(scr, "startergui") or string.find(scr, "starter_gui") or string.find(scr, "starter-gui") or string.find(scr, "s_gui") or string.find(scr, "s-gui") or string.find(scr, "sgui") or string.find(scr, "sui") or string.find(scr, "s-ui") or string.find(scr, "s_ui") or string.find(scr, "sr_gui") or string.find(scr, "sr-gui") or string.find(scr, "srgui") then  
return game:GetService("StarterGui")
else
if string.find(scr, "plrGui") or string.find(scr, "pGui") or string.find(scr, "playerGui") or string.find(scr, "p_ui") or string.find(scr, "pui") or string.find(scr, "p-ui") or string.find(scr, "p-gui") or string.find(scr, "player-gui") or string.find(scr, "plr-gui") or string.find(scr, "plr_gui") then
return game:GetService("Players").LocalPlayer["PlayerGui"]
else
return game:GetService(scr)   
end
end
end
end
end
end
end
end
end
end

-- Grabbing Sell Circle with x10 Multipler 
local SellCircles = {}

for i,v in pairs(workspace.sellAreaCircles:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
if x:IsA("IntValue") and x.Name == "sellMultiplier" then
table.insert(SellCircles, x.Value)
end
end
end

table.sort(SellCircles, function(a,b) return tonumber(a) > tonumber(b) end)

for i,v in pairs(workspace.sellAreaCircles:GetChildren()) do
if v:FindFirstChild("sellMultiplier") and v:FindFirstChild("sellMultiplier").Value == SellCircles[1] then
SellCircle = v
end
end

-- Grabbing Crystals
local CrystalsList = {}

for i,c in pairs(game:GetService("Workspace").mapCrystalsFolder:GetChildren()) do
table.insert(CrystalsList, c.Name)
end

-- Grabbing Islands
local IslandList = {}

for i,is in pairs(game:GetService("Workspace").islandUnlockParts:GetChildren()) do
table.insert(IslandList, is.Name)
end

-- Grabbing Elements
local Elements = {}

for i,e in pairs(game:GetService("ReplicatedStorage").Elements:GetChildren()) do
table.insert(Elements, e.Name)
end

-- Grabbing Tools
local Tools = {}

for i,t in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
table.insert(Tools, t.Name)
end

-- Chests
local e6d910dfb57f2b6d68c6f332ee378f0760e4f9a7eb9e5a96cd1ab96e37bbe6af = {} -- Normal Chests
local a202224e2c2c6b7ca7f808c6119301f52dfa2d4427a224375f07663194068311 = {} -- Karma Chests

for i,cx in pairs(game:GetService("ReplicatedStorage").chestRewards:GetChildren()) do
if cx.Name == "Evil Karma Chest" or cx.Name == "Light Karma Chest" then
table.insert(a202224e2c2c6b7ca7f808c6119301f52dfa2d4427a224375f07663194068311, cx.Name)
else
table.insert(e6d910dfb57f2b6d68c6f332ee378f0760e4f9a7eb9e5a96cd1ab96e37bbe6af, cx.Name)
end
end

-- Keybinds
RAlt = "RightAlt"
RCtrl = "RightControl"
RControl = "RightControl"
RShift = "RightShift"
LAlt = "LeftAlt"
LCtLl = "LeftControl"
LContLol = "LeftControl"
LShift = "LeftShift"

-- Predefined states
AutoSwing = false
AutoSell = false
AutoFullSell = false
AutoPetLevels = false
AutoChi = false
FarmRobotBosses = false
FarmEternalBosses = false
FarmAncientMagmaBosses = false
FarmAllBosses = false
GoodKarma = false
BadKarma = false
FarmMW = false
FarmSOL = false
FarmET = false
FarmLP = false
FarmT = false
FarmSOA = false
AutoSwords = false
AutoBelts = false
AutoRank = false
AutoF = false
AutoL = false
AI = false
AutoSkills = false
AutoShurkiens = false
AutoLightSkills = false
AutoDarkSkills = false
SCSDR = false
AutoEvolve = false
AutoEternalize = false
AutoImmortalize = false
AutoLegendize = false
AutoElementalize = false
AutoXGenesis = false
AutoZMaster = false
FastShuriken = false
SlowShuriken = false
GoInvisible = false
MaxJump = false
OpenEggs = false
SpamJoinDuel = false
AHN = false

-- Default Settings
local MainUI = library.new(true) 

if WeirdExploit.IsCalamari then
MainUI.ChangeToggleKey(Enum.KeyCode.RightShift) -- Toggle Key
end

if WeirdExploit.IsCalamari == false then
MainUI.ChangeToggleKey(Enum.KeyCode[Config.Keybind])
end

local Home = MainUI:Category("Home")
local Farming = MainUI:Category("Farming")

local Beta;
local BMF;
if User.IsABetaUser then -- can only be accessed by people using coolhub
local Beta = MainUI:Category("Beta Testing")
local BMF = Beta:Sector("Beta Functions") -- be my friend :)

BMF:Cheat(
    "Checkbox",
    "No Swing Cooldown",
function(smelly_farts)
NWC = smelly_farts
while NWC do
local oh_get_gc = getgc or false
local oh_is_x_closure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or checkclosure or false
local oh_get_info = debug.getinfo or getinfo or false
local oh_set_upvalue = debug.setupvalue or setupvalue or setupval or false

if not oh_get_gc and not oh_is_x_closure and not oh_get_info and not oh_set_upvalue then
    warn("Your exploit does not support this script")
    return
end

local oh_find_function = function(name)
    for i,v in pairs(oh_get_gc()) do
        if type(v) == "function" and not oh_is_x_closure(v) then
            if oh_get_info(v).name == name then
                return v
            end
        end
    end
end

local oh_wait = oh_find_function("wait")
local oh_index;
for i = 1,10 do
oh_index = i
end
local oh_new_value = 0 
oh_set_upvalue(oh_wait, oh_index, oh_new_value)
end
end)
end

local Autobuy = MainUI:Category("Auto Buy")
local PetFunctions = MainUI:Category("Pet Modules")
local PetEvolution = MainUI:Category("Pet Evolution")
local Misc = MainUI:Category("Misc")
local Teleports = MainUI:Category("Teleports")
local Settings = MainUI:Category("Settings")


local NinjaLegendsGUI = Home:Sector("Ninja Legends v2.9")
local div6 = Home:Sector("")
local CreatedBy = Home:Sector("    - by Jxnt#9946 and xxxYoloxxx999#2166")
local div69 = Home:Sector("")
local UILibBy = Home:Sector("    - UI Library by deto#7612") 
local div4 = Home:Sector("")
local div5
if WeirdExploit.IsCalamari then
div5 = Home:Sector("    - Toggle Key is RightShift")
end
if not WeirdExploit.IsCalamari then
div5 = Home:Sector("    - Toggle Key is "..Config.Keybind or Enum.KeyCode.RightShift)
end
local div4 = Home:Sector("")
local div1 = Home:Sector("")
local div2 = Home:Sector("")
local YoloDiscord = Home:Sector("Yolo's Discord - https://discord.gg/q2ZTgc5")
local div7 = Home:Sector("")
local JxntDiscord = Home:Sector("Jxnt's Discord - https://discord.gg/svAaXUr")
local div8 = Home:Sector("")
local div71238 = Home:Sector("")
local div21378912737812637812 = Home:Sector("")
local dasdiv = Home:Sector("")
local div213 = Home:Sector("")
local d523iv = Home:Sector("")
local div543 = Home:Sector("")
local div2135 = Home:Sector("")
local div643 = Home:Sector("")
local div2134 = Home:Sector("")

local div21434 = Home:Sector("")
local div532353213421 = Home:Sector("")
local div532132353213421 = Home:Sector("") 
local Thanks = Home:Sector("Thanks for using our script, " ..player.Name)
local MainModules = Farming:Sector("- Main Functions -")
    
MainModules:Cheat(
"Checkbox",
"Auto Swing",
function(State)
AutoSwing = State
while AutoSwing do
    pcall(function()
wait(.0001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
game.Players.LocalPlayer.ninjaEvent:FireServer("swingKatana")
else
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
wait(.0001)
if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)                            
end
end
end
end
end
end)
end
end)
    
MainModules:Cheat(
"Checkbox",
"Auto Sell",
function(State)
AutoSell = State
while AutoSell do
    pcall(function()
wait(0.01)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if AutoFullSell then
SellCircle.circleInner.CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
wait(.0000000000001)
SellCircle.circleInner.CFrame = game.Workspace.Part.CFrame
else
SellCircle.circleInner.CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
wait(.0000000000001)
SellCircle.circleInner.CFrame = game.Workspace.Part.CFrame
end
end
end)
end
end)

MainModules:Cheat(
    "Checkbox",
    "Auto-Collect Dojo Income",
function(State)
ACDI = State
while ACDI do
wait()
game:GetService("Workspace").dojoCircles.dojoCollectCircle["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
wait(.05)
game:GetService("Workspace").dojoCircles.dojoCollectCircle["circleInner"].CFrame = game.Workspace.Part.CFrame
end
end)

MainModules:Cheat(
"Checkbox",
"Auto Pet Levels",
function(State)
AutoPetLevels = State
while AutoPetLevels do
pcall(function()
wait(0.1)
local plr = game.Players.LocalPlayer
for _,v in pairs(workspace.Hoops:GetDescendants()) do
if v.ClassName == "MeshPart" then
v.touchPart.CFrame = plr.Character.HumanoidRootPart.CFrame
end
end
end)
end
end)
    
MainModules:Cheat(
"Checkbox",
"Auto Chi",
function(State)
AutoChi = State
while AutoChi do 
pcall(function()
wait(0.033)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Workspace.spawnedCoins.Valley:GetChildren()) do
if v.Name == "Blue Chi Crate" then 
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
wait(.16)
end
end
end
end)
end
end)
    

    
local BossFarming = Farming:Sector("- Boss Farms -")
    
BossFarming:Cheat(
"Checkbox",
"Farm Robot Boss",
function(State) 
FarmRobotBosses = State
while FarmRobotBosses do
    pcall(function()
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if game:GetService("Workspace").bossFolder:FindFirstChild("RobotBoss"):FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame
if player.Character:FindFirstChildOfClass("Tool") then
player.Character:FindFirstChildOfClass("Tool"):Activate()
else
for i,v in pairs(player.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then
v.attackTime.Value = 0
player.Character.Humanoid:EquipTool(v)
if attackfar then
for i,v in pairs(player.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then
player.Character.Humanoid:EquipTool(v)
end
end
end
end
end
end
end
end
end)
end
end)
    
BossFarming:Cheat(
"Checkbox",
"Farm Eternal Boss",
function(State)
FarmEternalBosses = State
while FarmEternalBosses do
    pcall(function()
    wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    if game:GetService("Workspace").bossFolder:FindFirstChild("EternalBoss"):FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame
    if player.Character:FindFirstChildOfClass("Tool") then
    player.Character:FindFirstChildOfClass("Tool"):Activate()
    else
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then
    v.attackTime.Value = 0
    player.Character.Humanoid:EquipTool(v)
    if attackfar then
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then
    player.Character.Humanoid:EquipTool(v)
end
end
end
end
end
end
end
end
end)
end
end)

BossFarming:Cheat(
"Checkbox",
"Farm Ancient Magma Boss",
function(State)
FarmAncientMagmaBosses = State
while FarmAncientMagmaBosses do 
    pcall(function()
    wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    if game:GetService("Workspace").bossFolder:FindFirstChild("AncientMagmaBoss"):FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame
    if player.Character:FindFirstChildOfClass("Tool") then
    player.Character:FindFirstChildOfClass("Tool"):Activate()
    else
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then
    v.attackTime.Value = 0
    player.Character.Humanoid:EquipTool(v)
    if attackfar then
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then
    player.Character.Humanoid:EquipTool(v)
end
end
end
end
end
end
end
end
end)
end
end)
    
BossFarming:Cheat(
"Checkbox",
"Farm All Bosses",
function(State)
FarmAllBosses = State
while FarmAllBosses do
    pcall(function()
    wait(.0001)
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    if game.Workspace.bossFolder:FindFirstChild("AncientMagmaBoss") and game.workspace.bossFolder:FindFirstChild("AncientMagmaBoss").Humanoid.Health > 0 then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame
    else
    if not game.Workspace.bossFolder:FindFirstChild("AncientMagmaBoss") then
    if game.Workspace.bossFolder:FindFirstChild("EternalBoss") and game.workspace.bossFolder:FindFirstChild("EternalBoss").Humanoid.Health > 0 then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame
    else
    if not game.Workspace.bossFolder:FindFirstChild("EternalBoss") then
    if game.Workspace.bossFolder:FindFirstChild("RobotBoss") and game.workspace.bossFolder:FindFirstChild("RobotBoss").Humanoid.Health > 0  then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame
    end
    end
    end
    end
    end
    end
    if player.Character:FindFirstChildOfClass("Tool") then
    player.Character:FindFirstChildOfClass("Tool"):Activate()
    else
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then
    v.attackTime.Value = 0
    player.Character.Humanoid:EquipTool(v)
    if attackfar then
    for i,v in pairs(player.Backpack:GetChildren()) do
    if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then
    player.Character.Humanoid:EquipTool(v)
    end
    end
    end
    end
    end
end
end)
end
end)

game:GetService("RunService").Stepped:connect(function()
if FarmAllBosses or FarmAncientMagmaBosses or FarmEternalBosses or FarmRobotBosses then
if not TpBossToPlayer then
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(11)
end
end
end)


local KarmaSection = Farming:Sector("- Karma Farms -")
    
KarmaSection:Cheat(
"Checkbox",
"Farm Good Karma",
function(State)
GoodKarma = State
while GoodKarma do
    wait(.001)
game.Players.LocalPlayer.Character:findFirstChildOfClass("Humanoid"):ChangeState(11)
loadstring(game:HttpGet("https://pastebin.com/raw/AaqHqPyw",true))()
end
end)
    
KarmaSection:Cheat(
"Checkbox",
"Farm Bad Karma",
function(State)
BadKarma = State
while BadKarma do
    wait(.001)
game.Players.LocalPlayer.Character:findFirstChildOfClass("Humanoid"):ChangeState(11)
loadstring(game:HttpGet("https://pastebin.com/raw/wEEB3nQt",true))()
end
end)
    
local GoodKarmaSector = Farming:Sector("- Good Karma Areas -")
GoodKarmaSector:Cheat(
"Checkbox",
"Farm Mystical Waters",
function(State)
FarmMW = State
while FarmMW do 
wait(0.5)
tp(324.245667, 8830.52148, 86.1195679, 0.161275432, -2.06057429e-08, 0.986909449, 5.90549725e-08, 1, 1.12286154e-08, -0.986909449, 5.64710092e-08, 0.161275432);
wait(0.5)
tp(355.762909, 8829.71289, 142.792297, -0.971595705, 2.82195742e-08, -0.236647025, 5.11458076e-09, 1, 9.82487336e-08, 0.236647025, 9.42476959e-08, -0.971595705)    
end
end)

GoodKarmaSector:Cheat(
"Checkbox",
"Farm Sword Of Legends",
function(State)
FarmSOL = State
while FarmSOL do
tp(1834.19189, 38.7064781, -171.400024, -0.336450309, 1.1713405e-07, -0.941701233, 6.06731945e-08, 1, 1.02708299e-07, 0.941701233, -2.25797816e-08, -0.336450309);
wait(0.5)
tp(1809.11023, 38.7064857, -116.755051, -0.949999392, 9.91566385e-09, -0.312251717, 3.08319237e-08, 1, -6.20481657e-08, 0.312251717, -6.85730441e-08, -0.949999392)
wait(0.5)
tp(1860.70386, 38.7064857, -97.9324799, -0.24555853, -4.51638593e-09, -0.96938175, 1.57527202e-09, 1, -5.05807707e-09, 0.96938175, -2.76909407e-09, -0.24555853);
wait(0.5)
tp(1888.76477, 38.7064857, -157.529434, -0.597174525, 4.34115943e-09, -0.802111328, -2.48334171e-08, 1, 2.39007267e-08, 0.802111328, 3.41920696e-08, -0.597174525);
wait(0.5)
end
end)
    
GoodKarmaSector:Cheat(
"Checkbox",
"Farm Elemental Tornado",
function(State)
FarmET = State
while FarmET do
tp(262.150757, 30383.0977, -33.7057495, 0.898321033, -2.46213983e-08, -0.439339638, 6.44923848e-09, 1, -4.28550244e-08, 0.439339638, 3.5664165e-08, 0.898321033);
wait(0.5)
tp(311.967194, 30383.0977, 43.3573341, 0.598963678, 6.29690149e-08, -0.800776184, -1.44970302e-08, 1, 6.77914969e-08, 0.800776184, -2.89957693e-08, 0.598963678)
wait(0.5)
tp(380.829071, 30383.0977, -31.3893471, 0.723254144, -8.26298603e-08, -0.690581977, 5.8592164e-08, 1, -5.82882755e-08, 0.690581977, 1.69454395e-09, 0.723254144)
wait(0.5)
tp(317.873505, 30383.0977, -82.5569458, 0.649077475, -1.77226234e-08, -0.760722339, -1.16149002e-08, 1, -3.32073782e-08, 0.760722339, 3.03898737e-08, 0.649077475);
wait(0.5)
end
end)

GoodKarmaSector:Cheat(
"Checkbox",
"Farm Zen Master",
function(State)
FarmZM = State
while FarmZM do
tp(5020.43457, 38.7044945, 1567.45227);
wait(0.5)
tp(5000.93262, 38.7044945, 1644.99146)
wait(0.5)
tp(5058.44141, 38.7044945, 1648.5415)
wait(0.5)
tp(5081.64551, 38.7044945, 1583.02893);
wait(0.5)
end
end)
    
local BadKarmaSector = Farming:Sector("- Bad Karma Areas -")

BadKarmaSector:Cheat(
"Checkbox",
"Farm Lava Pit",
function(State)
FarmLP = State
while FarmLP do
    tp(-115.474503, 12958.5537, 291.777313, 0.772090137, -3.11468407e-09, 0.635513008, -1.0921504e-10, 1, 5.03374098e-09, -0.635513008, -3.95590938e-09, 0.772090137)
    wait(0.5)
    tp(-140.728409, 12957.5498, 246.088654, -0.824688554, 1.74805692e-09, -0.565587163, -1.13095728e-08, 1, 1.95813001e-08, 0.565587163, 2.25450236e-08, -0.824688554);
wait(0.5)
end
end)
    
BadKarmaSector:Cheat(
"Checkbox",
"Farm Tornado",
function(State)
FarmT = State	
while FarmT do
tp(274.607849, 16872.0996, -17.1396866, -0.64378798, -9.8007618e-08, -0.765203893, -8.10185199e-08, 1, -5.99171841e-08, 0.765203893, 2.34217232e-08, -0.64378798)
wait(0.5)
tp(326.984253, 16872.0996, 36.6794586, 0.454351634, 9.23998211e-09, -0.890822411, -8.80537527e-08, 1, -3.45381785e-08, 0.890822411, 9.41327372e-08, 0.454351634);
wait(0.5)
tp(370.643341, 16872.0957, -14.0209064, 0.654380083, -3.53731373e-08, 0.756165802, 1.07627621e-07, 1, -4.63605119e-08, -0.756165802, 1.11721718e-07, 0.654380083)
wait(0.5)
tp(317.7276, 16872.0957, -75.0421524, -0.677615225, 2.71169505e-08, 0.735416651, -2.20696617e-08, 1, -5.72079628e-08, -0.735416651, -5.49953825e-08, -0.677615225);
end
end)
    
BadKarmaSector:Cheat(
"Checkbox",
"Farm Sword Of Ancients",
function(State)
FarmSOA = State
while FarmSOA do
tp(643.52301, 38.7064857, 2387.37183, -0.975888491, 3.80665028e-08, -0.218269736, 4.29616236e-08, 1, -1.76811135e-08, 0.218269736, -2.66320175e-08, -0.975888491)
wait(0.5)
tp(591.633789, 38.7064857, 2417.67651, -0.99675113, 8.08746847e-08, -0.0805428773, 8.15328676e-08, 1, -4.88304819e-09, 0.0805428773, -1.14340759e-08, -0.99675113);
wait(0.5)
tp(609.927307, 38.7064781, 2461.33398, -0.943295419, -4.07039558e-08, -0.331954479, -5.96086238e-08, 1, 4.6767223e-08, 0.331954479, 6.39026538e-08, -0.943295419)
wait(0.5)
tp(666.854187, 38.7064781, 2445.65161, 0.264961451, -2.46404905e-08, -0.964259028, 3.14949737e-08, 1, -1.68995431e-08, 0.964259028, -2.5891584e-08, 0.264961451);    
wait(0.5)
end
end)

BadKarmaSector:Cheat(
"Checkbox",
"Farm Infinity Blade",
function(State)
FarmIB = State
while FarmIB do
tp(1819.94519, 38.7044868, -6806.93652)
wait(0.5)
tp(1886.11157, 38.7044868, -6767.1543);
wait(0.5)
tp(1911.61438, 38.704483, -6808.51563)
wait(0.5)
tp(1864.40344, 38.7044907, -6844.40918);    
wait(0.5)
end
end)

local Purchases = Autobuy:Sector("- Purchasable Items -")

Purchases:Cheat(
"Checkbox",
"Auto-Ranks",
function(State)
AutoRank = State
while AutoRank do
    pcall(function()
wait(.2)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local oh1 = "buyRank"
local oh2 = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()
for i = 1,#oh2 do
game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i].Name)
end
end
end)
end
end)

Purchases:Cheat(
"Checkbox",
"Auto Swords",
function(State)
AutoSwords = State
while AutoSwords do
pcall(function()
wait(.2)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
local A_1 = "buyAllSwords"
local A_2 = v.Name
local Event = game:GetService("Players")[game.Players.LocalPlayer.Name].ninjaEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end)
    
Purchases:Cheat( 
"Checkbox",
"Auto Belt",
function(State)
AutoBelts = State
while AutoBelts do
    pcall(function()
wait(.2)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("ReplicatedStorage").Belts:GetChildren()) do
local A_1 = "buyAllBelts"
local A_2 = v.Name
local Event = game:GetService("Players")[game.Players.LocalPlayer.Name].ninjaEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end)
  
Purchases:Cheat(
"Checkbox",
"Auto Skills",
function(State)
AutoSkills = State
while AutoSkills do
    pcall(function() 
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("ReplicatedStorage").Skills:GetChildren()) do
local A_1 = "buyAllSkills"
local A_2 = v.Name
local Event = game:GetService("Players")[game.Players.LocalPlayer.Name].ninjaEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end)
    
Purchases:Cheat(
"Checkbox",
"Auto Shurikens",
function(State)
AutoShurikens = State
while AutoShurikens do
    pcall(function()
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("ReplicatedStorage").Shurikens:GetChildren()) do
local A_1 = "buyAllShurikens"
local A_2 = v.Name
local Event = game:GetService("Players")[game.Players.LocalPlayer.Name].ninjaEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end)
    
Purchases:Cheat(
"Checkbox",
"Auto Light Skills",
function(State)
AutoLightSkills = State
while AutoLightSkills do
    pcall(function()
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    for i,v in pairs(game.ReplicatedStorage["Light Skills"]:GetChildren()) do
        for i,x in pairs(v:GetChildren()) do
        local A_1 = "buyLightSkill"
        local A_2 = x.Name
        local Event = game:GetService("Players").LocalPlayer.ninjaEvent
        Event:FireServer(A_1, A_2)
        end
    end
 end
end)
end
end)
    
Purchases:Cheat(
"Checkbox",
"Auto Dark Skills",
function(State)
AutoDarkSkills = State
while AutoDarkSkills do
    pcall(function()
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    for i,v in pairs(game.ReplicatedStorage["Dark Skills"]:GetChildren()) do
        for i,x in pairs(v:GetChildren()) do
        local A_1 = "buyDarkSkill"
        local A_2 = x.Name
        local Event = game:GetService("Players").LocalPlayer.ninjaEvent
        Event:FireServer(A_1, A_2)
        end
    end
 end
end)
end
end)

local RP = Autobuy:Sector("- Elements -")

RP:Cheat(
    "Button",
    "Give Inferno",
function()
local A_1 = "Inferno"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Lightning",
function()
local A_1 = "Lightning"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Frost",
function()
local A_1 = "Frost"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Shadow",
function()
local A_1 = "Shadow Charge"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Wrath",
function()
local A_1 = "Masterful Wrath"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Electral",
function()
local A_1 = "Electral Chaos"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end, {placeholder = "Give Element"})

RP:Cheat(
    "Button",
    "Give Shadowfire",
function()
local A_1 = "Shadowfire"
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end)

RP:Cheat(
    "Button",
    "Give Eternity",
function()
    local A_1 = "Eternity Storm"
    local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
    Event:FireServer(A_1)
end)

RP:Cheat(
    "Button",
    "Give All Elements",
function()
for i,element in pairs(Elements) do
local A_1 = element.Name
local Event = game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent
Event:FireServer(A_1)
end
end)

local OpenEggsSector = PetFunctions:Sector("- Pet Functions -")
local RaritySelling = PetFunctions:Sector("- Rarity Selling -")
local SellSector = PetFunctions:Sector("- Pet Selling -") 
local Evolving = PetEvolution:Sector("- Evolving -")

local CrystalDropdown = OpenEggsSector:Cheat(
"Dropdown", 
"Crystals", 
function(CrystalChosen)
while OpenEggs do
    wait(.001)
    local A_1 = "openCrystal"
    local A_2 = CrystalChosen
    local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
    Event:InvokeServer(A_1, A_2)
    end
end, {options = CrystalsList})
CrystalDropdown:SetValue("(Select A Crystal)")

OpenEggsSector:Cheat(
"Checkbox",
"Open Crystals (Toggle First)",
function(State)
OpenEggs = State
end)
    
SellSector:Cheat(
"Checkbox",
"Sell Secret Shadows Leviathan",
function(State)
SCSDR = State
while SCSDR do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    for i,v in pairs(game.Players.LocalPlayer.petsFolder["Soul Master"]:GetChildren()) do
    if v.Name == "Secret Shadows Leviathan" then
    game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
    end
    end
    end
end
end)

RaritySelling:Cheat(
"Checkbox",
"Sell All Basic Pets",
function(State)
SBP = State
while SBP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    for i,v in pairs(game.Players.LocalPlayer.petsFolder.Basic:GetChildren()) do
    game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
    end
    end
    end
end)

RaritySelling:Cheat(
"Checkbox",
"Sell All Advanced Pets",
function(State)
SAP = State
while SAP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    for i,v in pairs(game.Players.LocalPlayer.petsFolder.Advanced:GetChildren()) do
    game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
    end
    end
    end
end)
    
RaritySelling:Cheat(
"Checkbox",
"Sell All Rare Pets",
function(State)
SAR = State
while SAR do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Rare:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)
    
RaritySelling:Cheat(
"Checkbox",
"Sell All Epic Pets",
function(State)
SEP = State
while SEP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Epic:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(
"Checkbox",
"Sell All Unique Pets",
function(State) 
SUP = State
while SUP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(
"Checkbox",
"Sell All Omega Pets",
function(State)
SOP = State
while SOP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Omega:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)
    
RaritySelling:Cheat(
"Checkbox",
"Sell All Elite Pets",
function(State)
SELP = State
while SELP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Elite:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)
    
RaritySelling:Cheat(   
"Checkbox",
"Sell All Infinity Pets",
function(State)
SIP = State
while SIP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(   
"Checkbox",
"Sell All Awakened Pets",
function(State)
SAAP = State
while SAAP do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder.Awakened:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(   
"Checkbox",
"Sell All Master Legend Pets",
function(State)
ML = State
while ML do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder["Master Legend"]:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(   
"Checkbox",
"Sell All Beast Pets",
function(State)
SBeast = State
while ML do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder["BEAST"]:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(   
"Checkbox",
"Sell All Skystorm Pets",
function(State)
SStorm = State
while SStorm do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder["Skystorm"]:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

RaritySelling:Cheat(   
"Checkbox",
"Sell All Soul Master Pets",
function(State)
SSoulMaster = State
while SSoulMaster do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
for i,v in pairs(game.Players.LocalPlayer.petsFolder["Soul Master"]:GetChildren()) do
game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)
end
end
end
end)

Evolving:Cheat(
    "Checkbox",
    "Auto-Max Evolution",
function(State)
AutoEvolution = State
while AutoEvolution do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local A_1 = "autoEvolvePets"
local Event = game:GetService("ReplicatedStorage").rEvents.autoEvolveRemote
Event:InvokeServer(A_1)
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Evolve",
function(State)
AutoEvolve = State
while AutoEvolve do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "evolvePet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(oh1, oh2)
end
end
end
end
end)
    
Evolving:Cheat(
"Checkbox",
"Auto-Eternalize",
function(State)
AutoEternalize = State
while AutoEternalize do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "eternalizePet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petEternalizeEvent:FireServer(oh1, oh2)
end
end
end
end
end)
    
Evolving:Cheat( 
"Checkbox",
"Auto-Immortalize",
function(State)
AutoImmortalize = State
while AutoImmortalize do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "immortalizePet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petImmortalizeEvent:FireServer(oh1, oh2)
end
end
end
end
end)
    
Evolving:Cheat( 
"Checkbox",
"Auto-Legendize",
function(State)
AutoLegendize = State
while AutoLegendize do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "legendizePet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petLegendEvent:FireServer(oh1, oh2)
end
end
end
end
end)
    
Evolving:Cheat(
"Checkbox",
"Auto-Elementalize",
function(State)
AutoElementalize = State
while AutoElementalize do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "elementalizePet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petElementalizeEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-X-Genesis",
function(State)
AutoXGenesis = State
while AutoXGenesis do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "xGenesisPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petxGenesisEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Z-Master",
function(State)
AutoZMaster = State
while AutoZMaster do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "zMasterPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petzMasterEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Ultra Beast",
function(State)
UltraBeast = State
while UltraBeast do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "ultraBeastPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petUltraBeastEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Infinity Lord",
function(State)
InfinityLord = State
while InfinityLord do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "infinityLordPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petInfinityLordEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Chaos Titan",
function(State)
ChaosTitan = State
while ChaosTitan do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "chaostitanPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petInfinityLordEvent:FireServer(oh1, oh2)
end
end
end
end
end)

Evolving:Cheat(
"Checkbox",
"Auto-Z-Legend",
function(State)
ZLegend = State
while ZLegend do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
for i,x in pairs(v:GetChildren()) do
local oh1 = "ZXLegendPet"
local oh2 = x.Name
game:GetService("ReplicatedStorage").rEvents.petZXLegendEvent:FireServer(oh1, oh2)
end
end
end
end
end)

local MiscModules = Misc:Sector("- Shurikens -")

MiscModules:Cheat(
"Checkbox",
"Fast Shuriken",
function(State)
FastShuriken = State
while FastShuriken do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local plr = game.Players.LocalPlayer
local Mouse = plr:GetMouse()
local velocity = 1000
for _,p in pairs(game.Workspace.shurikensFolder:GetChildren()) do
if p.Name == "Handle" then
if p:FindFirstChild("BodyVelocity") then
local bv = p:FindFirstChildOfClass("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
bv.Velocity = Mouse.Hit.lookVector * velocity
end
end
end
end
end
end)

MiscModules:Cheat(
"Checkbox",
"Slow Shuriken",
function(State)
SlowShuriken = State
while SlowShuriken do
wait(.001)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local plr = game.Players.LocalPlayer
local Mouse = plr:GetMouse()
local velocity = 35
for _,p in pairs(game.Workspace.shurikensFolder:GetChildren()) do
if p.Name == "Handle" then
if p:FindFirstChild("BodyVelocity") then
local bv = p:FindFirstChildOfClass("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
bv.Velocity = Mouse.Hit.lookVector * velocity
end
end
end
end
end
end)

local Chest = Misc:Sector("- Chest Collector -")

Chest:Cheat(
"Button", 
"Collect All Chests", 
function()
for _,a6849498f0988bf9064151b4d39dfe63cddc39aa3009f24f08fcad04f7bf4e4 in pairs(e6d910dfb57f2b6d68c6f332ee378f0760e4f9a7eb9e5a96cd1ab96e37bbe6af) do -- no skids allowed! ! ! !
wait(3.5)
local A_1 = a6849498f0988bf9064151b4d39dfe63cddc39aa3009f24f08fcad04f7bf4e4
local Event = game:GetService("ReplicatedStorage").rEvents.checkChestRemote
Event:InvokeServer(A_1)
end
end, {placeholder = "Collect Chests"})

Chest:Cheat(
"Button", 
"Collect Light Chest", 
function()
local A_1 = a202224e2c2c6b7ca7f808c6119301f52dfa2d4427a224375f07663194068311[1]
local Event = game:GetService("ReplicatedStorage").rEvents.checkChestRemote
Event:InvokeServer(A_1)
end, {placeholder = "Collect Light Chests"})

Chest:Cheat(
"Button", 
"Collect Dark Chest", 
function()
local A_1 = a202224e2c2c6b7ca7f808c6119301f52dfa2d4427a224375f07663194068311[2]
local Event = game:GetService("ReplicatedStorage").rEvents.checkChestRemote
Event:InvokeServer(A_1)
end, {placeholder = "Collect Dark Chests"})

local Other = Misc:Sector("- Other Stuff -")

Other:Cheat(
"Button", 
"Inf Jumps", 
function()
    local oh_get_gc = getgc or false
    local oh_is_x_closure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or checkclosure or false
    local oh_get_info = debug.getinfo or getinfo or false
    local oh_set_upvalue = debug.setupvalue or setupvalue or setupval or false
    
    if not oh_get_gc and not oh_is_x_closure and not oh_get_info and not oh_set_upvalue then
        game.Players.LocalPlayer.multiJumpCount.Value = 50 
        return
    end
    
    local oh_find_function = function(name)
        for i,v in pairs(oh_get_gc()) do
            if type(v) == "function" and not oh_is_x_closure(v) then
                if oh_get_info(v).name == name then
                    return v
                end
            end
        end
    end
    
    local oh_jumpRequested = oh_find_function("jumpRequested")
    local oh_index = 8
    local oh_new_value = 999999999999999999 
    oh_set_upvalue(oh_jumpRequested, oh_index, oh_new_value)
game.Players.LocalPlayer.multiJumpCount.Value = 999999999999999999
end, {placeholder = "Enable"})

Other:Cheat(
"Checkbox",
"Invisibility",
function(State)
GoInvisible = State
while GoInvisible do
    wait(.0001)
    local A_1 = "goInvisible"
    local Event = game.Players.LocalPlayer.ninjaEvent
    Event:FireServer(A_1)
    end
end)

Other:Cheat(
    "Checkbox",
    "Break Duels",
function(State)
SpamJoinDuel = State
while SpamJoinDuel do
wait(.001)
game.ReplicatedStorage.rEvents.duelEvent:FireServer("joinDuel")
end
end)

Other:Cheat(
    "Checkbox",
    "Toggle Popups",
function(State)
Popups = State
while wait(2.5) do
if Popups then
game:GetService("Players").LocalPlayer.PlayerGui.statEffectsGui.Enabled = false
game:GetService("Players").LocalPlayer.PlayerGui.hoopGui.Enabled = false
else
game:GetService("Players").LocalPlayer.PlayerGui.statEffectsGui.Enabled = true
game:GetService("Players").LocalPlayer.PlayerGui.hoopGui.Enabled = true 
end
end
end)

Other:Cheat(
"Checkbox",
"Hide Name",
function(State)
AHN = State
while wait(2.5) do
if AHN then -- fix maybe?
game:GetService("Players").LocalPlayer.Character.Head.nameGui.Enabled = false
else
if not AHN then
game:GetService("Players").LocalPlayer.Character.Head.nameGui.Enabled = true
end
end
end
end)

Other:Cheat(
"Button",
"Rejoin Game",
function()
Api:Rejoin()
end, {placeholder = "Rejoin Game"})

local TpModules = Teleports:Sector("- Teleports -")

TpModules:Cheat(
"Dropdown", 
"Shops", 
function(Util)
if Util == "Shop" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").shopAreaCircles["shopAreaCircle17"].circleInner.CFrame
end
if Util == "Skills Shop" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").skillAreaCircles["skillsAreaCircle15"].circleInner.CFrame
end
if Util == "G-Karma Shop" then
tp(-116.49514, 3.24800324, 0.0838552266)
end
if Util == "B-Karma Shop" then
tp(-116.549767, 3.24800324, 58.087841)
end
if Util == "Cloning Altar" then
tp(4616.16846, 134.10881, 1446.32678, -0.459531546, 8.16062524e-08, -0.88816148, 1.2634959e-07, 1, 2.6509408e-08, 0.88816148, -1.00036921e-07, -0.459531546)
end
if Util == "Altar Of Elements" then
local A_1 = "travelToArea"
local A_2 = game:GetService("Workspace").areaCircles.masterElementsAreaCircle
local Event = game:GetService("ReplicatedStorage").rEvents.areaTravelRemote
Event:InvokeServer(A_1, A_2)
end
if Util == "Zen Master" then
tp(389.629456, 59709.4258, -25.1997089, 0.316550285, -3.3454139e-08, -0.948575735, -6.20949479e-08, 1, -5.59895312e-08, 0.948575735, 7.66252626e-08, 0.316550285)
end
if Util == "Sensei Training Shop" then
tp(-4340.30371, 124.317329, -5970.49658, -6.43730164e-06, 0.173615217, 0.984813571, -1, -6.43730164e-06, -5.48362732e-06, 5.48362732e-06, -0.984813571, 0.173615217)
end
if Util == "Ninja Training Shop" then
tp(-3981.30151, 124.317329, -6107.0957, -6.43730164e-06, -0.173615277, -0.984813631, -1, 6.37769699e-06, 5.42402267e-06, 5.42402267e-06, 0.984813631, -0.173615336)
end
if Util == "Dojo Capacity Shop" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").dojoCircles["dojoCapacityCircle"].circleInner.CFrame
end
end, { 
options = {
"(Select Shop)",
"Shop",
"Skills Shop",
"G-Karma Shop",
"B-Karma Shop",
"Cloning Altar",
"Altar Of Elements",
"Zen Master",
"Sensei Training Shop",
"Ninja Training Shop",
"Dojo Capacity Shop"
}
})

local IslandsDropdown = TpModules:Cheat(
"Dropdown", 
"Islands", 
function(Island)
if Island == "Ground" then
    tp(-7.51416588, 3.19600391, 70.7879868)
else
if Island == "(Select An Island)" then
local Loaded = Instance.new("BoolValue")
Loaded.Name = "ninja_legends_v2.loaded"
Loaded.Value = true
Loaded.Parent = game.ReplicatedStorage
else
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.islandUnlockParts[Island].CFrame
end
end
end, {options = IslandList})
IslandsDropdown:SetValue("(Select An Island)")

TpModules:Cheat(
"Button", 
"Unlock Islands", 
function()
if game.workspace:FindFirstChild("islandUnlockParts") then 
for i,v in pairs(game.workspace.islandUnlockParts:GetChildren()) do 
game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame;
wait(1)
end
end
end, {placeholder = "Unlock Islands"})

local SSettings = Settings:Sector("- Settings -")

SSettings:Cheat(
    "Button",
    "Kill GUI",
function()
for i,x in ipairs(game.CoreGui:GetChildren()) do
for i,gui in ipairs(x:GetChildren()) do
if gui:IsA("ImageLabel") and gui.Name == "Container" then
x:Destroy()
Notify("Ninja Legends v2.9", "Stopped the script. Script functions may still be active.", 3)
end
end
end
end, {placeholder = "Kill GUI"})

SSettings:Cheat(
    "Button",
    "Restart Script",
function()
Api:Restart()
end, {placeholder = "Restart Script"})

local FarmSettings = Settings:Sector("- Farming Settings -")

FarmSettings:Cheat(
    "Checkbox",
    "Sell When Full",
function(State)
AutoFullSell = State
end)

local HSettings = Settings:Sector("- Keybind Settings -")

HSettings:Cheat(
    "Keybind",
    "Change Keybind",
function(Keybind)
if WeirdExploit.IsCalamari then
MainUI.ChangeToggleKey(Enum.KeyCode[Keybind.Name])
end
if not WeirdExploit.IsCalamari then
MainUI.ChangeToggleKey(Enum.KeyCode[Keybind.Name])
Config.Keybind = Keybind.Name
Save()
end
end)

local TSettings = Settings:Sector("- Theme Settings - ")
TSettings:Cheat("Label", "This feature comes next update.")

--[[
    Anti AFK
--]]

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(
function()
vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
wait(1)
vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end) 

Notify("Ninja Legends v2.9", "GUI loaded. Scripted by xxxYoloxxx999 and Jxnt.", 3)
