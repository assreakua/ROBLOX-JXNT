-- OKAY
-- LOOK
--[[
    local Folder = "Bubble Gum Egg Names"
if makefolder == nil then
	Folder = ""
	else
	Folder = Folder .. "\\"
	makefolder(Folder)
end

for i,v in pairs(workspace.Eggs:GetChildren()) do -- its gonna  create multiple files with egg name data
    -- but i want it in one file
writefile(Folder..syn.crypt.encrypt("BGS.DATA.EGG.NAME.INFO", "BGS.UNLOCK.GIVEDATA"), "\n"..v.Name)
end
]]

_VERSION = 1

local SaveFile = "BubbleGumSimulatorSettings.data"

local DefaultSettings = {
Keybind = "RightControl"
}

local Config

if not pcall(function() readfile(SaveFile) end) then 
writefile(SaveFile, game:service'HttpService':JSONEncode(DefaultSettings)) 
end

Config = game:service'HttpService':JSONDecode(readfile(SaveFile))

local function Save()
writefile(SaveFile,game:service'HttpService':JSONEncode(Config))
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
for i,x in ipairs(game.CoreGui:GetChildren()) do
for i,gui in ipairs(x:GetChildren()) do
if gui:IsA("Frame") and gui.Name == "Container" then
x:Destroy()
Notify("Bubble Gum Simulator v1.0", "Restarting script...", 2)
end
end
end
end

for i,x in ipairs(game.CoreGui:GetChildren()) do
for i,gui in ipairs(x:GetChildren()) do
if gui:IsA("Frame") and gui.Name == "Container" then
x:Destroy()
Notify("Bubble Gum Simulator v1.0", "Restarting script...", 2)
end
end
end

Notify("Bubble Gum Simulator v1.0", "Checking for updates...", 1)
Notify("Bubble Gum Simulator v1.0", "Updated to the latest version. Loading...", 2)
local player = game.Players.LocalPlayer
local library = loadstring(game:HttpGet("https://pastebin.com/raw/0D1xKEFL",true))()
local plr = game:service"Players".LocalPlayer; 
local tween_s = game:service"TweenService";
local info = TweenInfo.new(1.7,Enum.EasingStyle.Quad);
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

local MainUI = library.new(true) -- Dark Mode 

if Config.Keybind == nil then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl) -- Toggle Key
else
MainUI.ChangeToggleKey(Enum.KeyCode[Config.Keybind])
end

local Home = MainUI:Category("Home")
local BubbleGumUI = Home:Sector("Bubblw Gum Simulator v1.0")
local div6 = Home:Sector("")
local CreatedBy = Home:Sector("    - by Jxnt#9946 and xxxYoloxxx999#2166")
local div69 = Home:Sector("")
local UILibBy = Home:Sector("    - UI Library by deto#7612")
local div1337 = Home:Sector("")
if Config.Keybind == nil then
local div4 = Home:Sector("    - Toggle Key is RightShift")
else
local div4 = Home:Sector("    - Toggle Key is "..Config.Keybind)
end
local div5 = Home:Sector("")
local div4 = Home:Sector("")
local div532132353213421 = Home:Sector("") 
local YoloDiscord = Home:Sector("Yolo's Discord - https://discord.gg/q2ZTgc5")
local div7 = Home:Sector("")
local JxntDiscord = Home:Sector("Jxnt's Discord - https://discord.gg/3uaNYfK")
local div8 = Home:Sector("")
local div71238 = Home:Sector("")
local div21378912737812637812 = Home:Sector("")
local dasdiv = Home:Sector("")
local d523iv = Home:Sector("")
local div543 = Home:Sector("")
local div2135 = Home:Sector("")
local div643 = Home:Sector("")
local div2134 = Home:Sector("")
local div5313421 = Home:Sector("")
local div643243243 = Home:Sector("")
local div21434 = Home:Sector("")
local div532353213421 = Home:Sector("")
local Thanks = Home:Sector("Thanks for using our script, " ..player.Name)

local Farming = MainUI:Category("Farming")
local FS = Farming:Sector("- General Farming - ")

FS:Cheat(
    "Checkbox",
    "Auto Blow Bubbles",
function(State)
ABB = State
while ABB do
wait()
pcall(function()
local A_1 = "BlowBubble"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1)
end)
end
end)

FS:Cheat(
    "Checkbox",
    "Auto Sell",
function(State)
AS = State
while AS do
wait()
local BubbleAmounts = string.split(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Bubble.Amount.Text, "/")
local CurrentBubbles = tonumber(BubbleAmounts[1])
local MaxBubbles = tonumber(BubbleAmounts[2])
if CurrentBubbles == MaxBubbles then
local A_1 = "SellBubble"
local A_2 = "TwilightSell"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
end
end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
local Autobuy = MainUI:Category("Auto Buy")
local AS = Autobuy:Sector("- Auto Buy -")
-----------------------------------------------------------------------------------------------------------------------------------------
local PetFunctions = MainUI:Category("Pet Modules")
local PF = PetFunctions:Sector("Pet Functions")

PF:Cheat(
"Dropdown", 
"Eggs", 
function(EggChosen)
print("You have selected the egg:", EggChosen)
end, { 
options = {
"(Select Egg)",
"Common",
"Spotted",
"Ice Shard",
"Spikey",
"Magma",
"Crystal",
"Lunar",
"Void",
"Nightmare",
"Hell",
"Rainbow",
"Ice Cream",
"Gummy",
"Slushy",
"Jelly",
"Dominus",
"Wind-Up",
"Block",
"Toy",
"Rubber",
"Bee",
"Coconut",
"Sand",
"Beach",
"Balloon",
"Water",
"Crab",
"Kelp",
"Ocean",
"Darkness",
"Coral",
"Ancient",
"Red",
"Orange",
"Colorful",
"Fancy",
"Stone",
"Obsidian",
"Fire",
"Evil",
"Dark",
"Sparkly"
	}
})

PF:Cheat(
    "Checkbox",
    "Open Eggs",
function(State)
OE = State
while OE do
local A_1 = "PurchaseEgg"
local A_2 = EggChosen.." Egg"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait()
end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
local Misc = MainUI:Category("Misc")
local MS = Misc:Sector("- Misc - ")
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleports = MainUI:Category("Teleports")
local TS = Teleports:Sector("- Teleports - ")

TS:Cheat(
"Dropdown", 
"Islands", 
function(Island)
print("Island:", Island)
if Island == "Sky Island" then
    local A_1 = "TeleportToCheckpoint"
    local A_2 = "The Floating Island"
    local Event = game:GetService("ReplicatedStorage").real
    Event:FireServer(A_1, A_2)
end
if Island == "The Skylands" then
    local A_1 = "TeleportToCheckpoint"
    local A_2 = "The Skylands"
    local Event = game:GetService("ReplicatedStorage").real
    Event:FireServer(A_1, A_2)
end
if Island == "The Void" then
    local A_1 = "TeleportToCheckpoint"
    local A_2 = "The Void"
    local Event = game:GetService("ReplicatedStorage").real
end
if Island == "Gem Collector" then
    tp(86.2299576, 40699.125, -259.262848, -0.362266272, 6.28259427e-23, 0.932074666, -2.04929497e-23, 1, -7.5369336e-23, -0.932074666, -4.6404727e-23, -0.362266272)
end
if Island == "XP Island" then
    tp(83.2667923, 53432.1211, -256.892883, -0.271137893, -4.69291379e-08, 0.962540507, -3.804006e-08, 1, 3.8039996e-08, -0.962540507, -2.63010129e-08, -0.271137893)
end
end, { 
    options = {
    "(Select Island)",
    "Ground",
    "Sky Island",
    "The Skylands",
    "The Void",
    "Gem Collector",
    "XP Island"
    }
})

TS:Cheat(
    'Button',
    'Unlock Islands',
function()
local A_1 = "TeleportToCheckpoint"
local A_2 = "The Floating Island"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait(1)
local A_1 = "TeleportToCheckpoint"
local A_2 = "Space"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait(1)
local A_1 = "TeleportToCheckpoint"
local A_2 = "The Twilight"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait(1)
local A_1 = "TeleportToCheckpoint"
local A_2 = "The Skylands"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait(1)
local A_1 = "TeleportToCheckpoint"
local A_2 = "The Void"
local Event = game:GetService("ReplicatedStorage").real
Event:FireServer(A_1, A_2)
wait(1)
tp(86.2299576, 40699.125, -259.262848, -0.362266272, 6.28259427e-23, 0.932074666, -2.04929497e-23, 1, -7.5369336e-23, -0.932074666, -4.6404727e-23, -0.362266272)
wait(3)
tp(83.2667923, 53432.1211, -256.892883, -0.271137893, -4.69291379e-08, 0.962540507, -3.804006e-08, 1, 3.8039996e-08, -0.962540507, -2.63010129e-08, -0.271137893)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
local Settings = MainUI:Category("Settings")
local HSettings = Settings:Sector("- Keybind Settings -")

HSettings:Cheat(
    "Textbox",
    "Change Keybind",
function(Text)
if Text == "RightShift" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "Right Shift" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightShift)
Config.Keybind = "RightShift"
Save()
else
if Text == "RightAlt" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "Right Alt" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightAlt)
Config.Keybind = "RightAlt"
Save()
else
if Text == "RightControl" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "RightCtrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "Right Control" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "Right Ctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "LeftShift" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "Left Shift" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftShift)
Config.Keybind = "LeftShift"
Save()
else
if Text == "LeftAlt" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "Left Alt" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftAlt)
Config.Keybind = "LeftAlt"
Save()
else
if Text == "LeftControl" then
MainUI.ChangeToggleKey(Enum.KeyCode[Text])
Config.Keybind = Text
Save()
else
if Text == "LeftCtrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "Left Control" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "Left Ctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "right shift" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightShift)
Config.Keybind = "RightShift"
Save() 
else
if Text == "rightalt" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightAlt)
Config.Keybind = "RightAlt"
Save()
else
if Text == "right alt" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightAlt)
Config.Keybind = "RightAlt"
Save()
else
if Text == "rightcontrol" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "rightctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "right control" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "right ctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
Config.Keybind = "RightControl"
Save()
else
if Text == "leftshift" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftShift)
Config.Keybind = "LeftShift"
Save()
else
if Text == "left shift" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftShift)
Config.Keybind = "LeftShift"
Save()
else
if Text == "leftalt" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftAlt)
Config.Keybind = "LeftAlt"
Save()
else
if Text == "left alt" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftAlt)
Config.Keybind = "LeftAlt"
Save()
else
if Text == "leftcontrol" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "leftctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "left control" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "left ctrl" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftControl)
Config.Keybind = "LeftControl"
Save()
else
if Text == "~" then
MainUI.ChangeToggleKey(Enum.Keycode.Tilde)
Config.Keybind = "Tidle"
Save()
else
if Text == "." then
MainUI.ChangeToggleKey(Enum.Keycode.Period)
Config.Keybind = "Period"
Save()
else
if Text == "," then
MainUI.ChangeToggleKey(Enum.Keycode.Period)
Config.Keybind = "Period"
Save()
else 
if Text == ">" then
MainUI.ChangeToggleKey(Enum.Keycode.GreaterThan)
Config.Keybind = "GreaterThan"
Save()
else
if Text == "<" then
MainUI.ChangeToggleKey(Enum.Keycode.LessThan)
Config.Keybind = "LessThan"
Save()
else
if Text == ";" then
MainUI.ChangeToggleKey(Enum.Keycode.Semicolon)
Config.Keybind = "Semicolon"
Save()
else
if Text == "(" then
MainUI.ChangeToggleKey(Enum.Keycode.LeftParenthesis)
Config.Keybind = "LeftParenthesis"
Save()
else
if Text == ")" then
MainUI.ChangeToggleKey(Enum.Keycode.RightParenthesis)
Config.Keybind = "RightParenthesis"
Save()
else
if Text == "{" then
MainUI.ChangeToggleKey(Enum.Keycode.LeftBracket)
Config.Keybind = "LeftBracket"
Save()
else
if Text == "}" then
MainUI.ChangeToggleKey(Enum.Keycode.RightBracket)
Config.Keybind = "RightBracket"
Save()
else
if Text == "/" then
MainUI.ChangeToggleKey(Enum.Keycode.Slash)
Config.Keybind = "Slash"
Save()
else
if Text == "`" then
MainUI.ChangeToggleKey(Enum.Keycode.Tilde)
Config.Keybind = "Tidle"
Save()
else
if Text == '"' then
MainUI.ChangeToggleKey(Enum.Keycode.Quote)
Config.Keybind = "Quote"
Save()
else
if Text == "'" then
MainUI.ChangeToggleKey(Enum.Keycode.Quote)
Config.Keybind = "Quote"
Save()
else
if Text == "F1" then
MainUI.ChangeToggleKey(Enum.KeyCode.F1)
Config.Keybind = "F1"
Save()
else
if Text == "F2" then
MainUI.ChangeToggleKey(Enum.KeyCode.F2)
Config.Keybind = "F2"
Save()
else
if Text == "F3" then
MainUI.ChangeToggleKey(Enum.KeyCode.F3)
Config.Keybind = "F3"
Save()
else
if Text == "F4" then 
MainUI.ChangeToggleKey(Enum.KeyCode.F4) 
Config.Keybind = "F4"
Save()
else
if Text == "F5" then
MainUI.ChangeToggleKey(Enum.KeyCode.F5)
Config.Keybind = "F5"
Save()
else
if Text == "F6" then
MainUI.ChangeToggleKey(Enum.KeyCode.F6)
Config.Keybind = "F6"
Save()
else
if Text == "F7" then
MainUI.ChangeToggleKey(Enum.KeyCode.F7)
Config.Keybind = "F7"
Save()
else
if Text == "F8"  then
MainUI.ChangeToggleKey(Enum.KeyCode.F8)
Config.Keybind = "F8"
Save()
else
if Text == "F9" then
MainUI.ChangeToggleKey(Enum.KeyCode.F9)
Config.Keybind = "F9"
Save()
else
if Text == "F10" then
MainUI.ChangeToggleKey(Enum.KeyCode.F10)
Config.Keybind = "F10"
Save()
else
if Text == "F11" then
MainUI.ChangeToggleKey(Enum.KeyCode.F11)
Config.Keybind = "F11"
Save()
else   
if Text == "F12" then
MainUI.ChangeToggleKey(Enum.KeyCode.F12)
Config.Keybind = "F12"
Save()
else
if Text == "&" or Text == "Ampersand" then
MainUI.ChangeToggleKey(Enum.KeyCode.Ampersand)
Config.Keybind = "Ampersand"
Save()
else
if Text == "Dollar" or Text == "$" or Text == "Dollar Sign" or Text == "DollarSign" then
MainUI.ChangeToggleKey(Enum.KeyCode.Dollar)
Config.Keybind = "Dollar"
Save()
else
if Text == "Percent" or Text == "%" or Text == "PercentSign" or Text == "Percent Sign" then
MainUI.ChangeToggleKey(Enum.KeyCode.Percent)
Config.Keybind = "Percent"
Save()
else
if Text == "Asterisk" or Text == "*" then
MainUI.ChangeToggleKey(Enum.KeyCode.Asterisk)
Config.Keybind = "Asterisk"
Save()
else
if Text == "Minus" or Text == "Minus Sign" or Text == "MinusSign" or Text == "-" then
MainUI.ChangeToggleKey(Enum.KeyCode.Minus)
Config.Keybind = "Minus"
Save()
else
if Text == ":" or Text == "Colon" or Text == "Colon Sign" then -- how stupid are you to put "Colon Sign"
MainUI.ChangeToggleKey(Enum.KeyCode.Colon) -- if you actually manage to not get this to work i'll be disappointed
Config.Keybind = "Colon" -- like very, very disappointed.
Save()
else
if Text == "?" or Text == "Question" or Text == "QuestionMark" or Text == "Question Mark" then
MainUI.ChangeToggleKey(Enum.KeyCode.Question)
Config.Keybind = "Question"
Save()
else
if Text == "@" or Text == "At" or Text == "At Sign" or Text == "AtSign" then
MainUI.ChangeToggleKey(Enum.KeyCode.At)
Config.Keybind = "At"
Save()
else
if Text == "^" or Text == "Caret" then
MainUI.ChangeToggleKey(Enum.KeyCode.Caret)
Config.Keybind = "Caret"
Save()
else
if Text == "`" or Text == "Backquote" or Text == "Back Quote" then
MainUI.ChangeToggleKey(Enum.KeyCode.Backquote)
Config.Keybind = "Backquote"
Save()
else
if Text == "_" or Text == "Underscore" then
MainUI.ChangeToggleKey(Enum.KeyCode.Underscore)
Config.Keybind = "Underscore"
Save()
else
if Text == "|" or Text == "Pipe" then
MainUI.ChangeToggleKey(Enum.KeyCode.Pipe)
Config.Keybind = "Pipe"
Save()
else
if Text == "{" or Text == "LeftCurly" or Text == "Left Curly" then
MainUI.ChangeToggleKey(Enum.KeyCode.LeftCurly)
Config.Keybind = "LeftCurly"
Save()
else
if Text == "}" or Text == "RightCurly" or Text == "Right Curly" then
MainUI.ChangeToggleKey(Enum.KeyCode.RightCurly)
Config.Keybind = "RightCurly"
Save()
else
local key = Text
local upped = string.upper(key)
Config.Keybind = upped
MainUI.ChangeToggleKey(Enum.KeyCode[upped])
Save()
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
end
end, {placeholder = "Keybind (Case Sensitive)"})