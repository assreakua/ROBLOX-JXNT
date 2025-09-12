local Api = {}

local SaveFile = "InfinityRPG.data"

local DefaultSettings = {
    Keybind = "RightControl", -- initial keybind
    Sword = "",
    TargetMob = ""
}
    
    local Config
    
    if not pcall(function() readfile(SaveFile) end) then 
    writefile(SaveFile, game:service'HttpService':JSONEncode(DefaultSettings)) 
    end
    
    Config = game:service'HttpService':JSONDecode(readfile(SaveFile))
    
    local function Save()
    writefile(SaveFile,game:service'HttpService':JSONEncode(Config))
    end
    
    local plr = game:service"Players".LocalPlayer;
    local tween_s = game:service"TweenService";
    local info = TweenInfo.new(1,Enum.EasingStyle.Quad);
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
    
    function notify(titletxt, text, time)
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

function Api:Restart(Script)
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "nfkflburxaNwLHvJ4rwm" then
            v:Destroy()
            notify("Infinity RPG v1.0", "Restarting script...", 2)
        else
            for i,x in pairs(v:GetChildren()) do
                if x.Name == "Container" then
                    x:Destroy()
                    notify("Infinity RPG v1.0", "Restarting script...", 2)
                end
            end
        end
    end
end

function FreezeCharacter()
    local Force = Instance.new("BodyVelocity")
    Force.Name = ""
    Force.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    Force.MaxForce = Vector3.new(99999, 99999, 99999)
    Force.Velocity = Vector3.new(0, 0, 0)
    wait(0.001)
    Force:Destroy()
end

for i,v in pairs(game.CoreGui:GetChildren()) do
if v.Name == "nfkflburxaNwLHvJ4rwm" then
v:Destroy()
notify("Infinity RPG v1.0", "Restarting script...", 2)
else
for i,x in pairs(v:GetChildren()) do
if x.Name == "Container" then
x:Destroy()
notify("Infinity RPG v1.0", "Restarting script...", 2)
end
end
end
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/kSwu1ujj",true))()
local player = game.Players.LocalPlayer

local MainUI = library.new(true)
if Config.Keybind == nil then
MainUI.ChangeToggleKey(Enum.KeyCode.RightControl)
else
MainUI.ChangeToggleKey(Enum.KeyCode[Config.Keybind])
end

local Home = MainUI:Category("Home")
local InfinityRPGGUI = Home:Sector("Infinity RPG v1.0")
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
local Combat = Farming:Sector("Combat")

Combat:Cheat(
"Checkbox",
"Kill Aura",
function(State)
KillAura = State
game:GetService("RunService").RenderStepped:connect(function()
if KillAura then
    local player = game.Players.LocalPlayer
    for i,v in pairs(game.workspace.Mobs:GetChildren()) do
    if not v:IsA("Folder") then
    if v ~= player and v:FindFirstChild("Torso") and player:DistanceFromCharacter(v.Torso.Position) < 20 then
    local A_1 = v
    local Event = game:GetService("ReplicatedStorage").GameRemotes.DamageMelee
    Event:InvokeServer(A_1)
    end
    end
    end
end
end)
end)

Combat:Cheat(
    "Checkbox",
    "Target Mob (Settings)",
function(State)
TargetMobs = State
game:GetService("RunService").RenderStepped:connect(function()
if TargetMobs then
pcall(function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Mobs[Config.TargetMob].Torso.CFrame + Vector3.new(5, 0, 0)
local player = game.Players.LocalPlayer
for i,v in pairs(game.workspace.Mobs:GetChildren()) do
if not v:IsA("Folder") then
if v ~= player and v:FindFirstChild("Torso") and player:DistanceFromCharacter(v.Torso.Position) < 20 then
local A_1 = v
local Event = game:GetService("ReplicatedStorage").GameRemotes.DamageMelee
Event:InvokeServer(A_1)
FreezeCharacter()
end
end
end
end)
end
end)
end)

Combat:Cheat(
    "Checkbox",
    "Auto-Equip Sword (Settings)",
function(State)
equipSword = State
while wait(0.5) do
if equipSword then
sword = Config.Sword
pcall(function()
local player = game:GetService("Players").LocalPlayer
local Character = game:GetService("Players").LocalPlayer.Character
Character.Humanoid:EquipTool(player.Backpack[sword])
end)
end
end
end)

local Misc = MainUI:Category("Misc")
local Teleports = MainUI:Category("Teleports")
local Settings = MainUI:Category("Settings")

local FSettings = Settings:Sector("- Farming Settings")
FSettings:Cheat(
    "Textbox",
    "Target Mob",
function(Target)
        Config.TargetMob = Target
        Save()
end)

FSettings:Cheat(
    "Textbox",
    "Sword",
function(Sword)
Config.Sword = Sword
Save()
end)

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

notify("Infinity RPG v1.0", "GUI loaded. Scripted by xxxYoloxxx999 and Jxnt.", 3)
