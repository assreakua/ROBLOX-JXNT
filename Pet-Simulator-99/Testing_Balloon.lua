getgenv().Settings = {
	
    Enabled = true, -- "Turn on/off."
    OpenGifts = true, -- "Open new gifts automatically."

	ServerHop = true, -- "Find more balloons with serverhopping."
	TeleportDelay = 10, -- "In seconds, delay between serverhopping (seconds.)"
	
	Webhook = "https://discord.com/api/webhooks/1221288329668984872/2E58aGIIlB8_DMoSt_yOE5QfI37ZsNKN2PJLCWjJjXUpnV1wEkTMx86FhXdMXUD5fRfN", -- "Notify yourself on how much you gain and more!"
	SendDelay = 1, -- "In minutes, delay between each message sent."

	[[
		Thank you for using System Exodus!
	]]

}






local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorldFolder = workspace.__THINGS

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart

local Library = require(ReplicatedStorage.Library)
local PlayerSave = require(ReplicatedStorage.Library.Client.Save) 
local BreakableCmds = require(ReplicatedStorage.Library.Client.BreakableCmds)
local Slingshot = getsenv(LocalPlayer.PlayerScripts.Scripts.Game.Misc.Slingshot)
local RAPValues = getupvalues(Library.DevRAPCmds.Get)[1]

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local Folders = {"System Exodus", "System Exodus/Pet Simulator 99"}
for _,v in next, Folders do
    if not isfolder(v) then
        makefolder(v)
    end
end

local SaveFile = "System Exodus/Pet Simulator 99/Balloon Settings.cfg"
local Stats = {
	ServerHops = 0,
	Time = 0
}
local function Save()
	writefile(SaveFile, HttpService:JSONEncode(Stats))
end

if not isfile(SaveFile) then
    Save()
end

local CurrentSave = HttpService:JSONDecode(readfile(SaveFile))
Stats.ServerHops = CurrentSave.ServerHops
Stats.Time = (CurrentSave.Time == 0 and os.time() or CurrentSave.Time)
Save()

local IDs = {}
local function GrabIDs(Repeat)
    task.spawn(function()
		local Site;
		local Cursor;
		local Repeat = Repeat or 1
		for i = 1, Repeat do
			if not Cursor then
				Site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
			else
				Site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..Cursor))
			end
			repeat task.wait() until Site
			if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
				Cursor = Site.nextPageCursor
			end

			for _,v in next, Site.data do
				if v.maxPlayers > v.playing and v.id then
					table.insert(IDs, v.id)
				end
			end
			task.wait(2)
		end
	end)
end
GrabIDs(999)

local function CommasBeADDED(Amount)
    local SuffixAdd = Amount
    while task.wait() do  
        SuffixAdd, b = string.gsub(SuffixAdd, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (b == 0) then
            break
        end
    end
    return SuffixAdd
end

local function CalcuateDiamonds(Gifts, Type)
    local TotalDiamonds = 0
    for i = 1, Gifts do
        if Type == "Small" then
            TotalDiamonds = TotalDiamonds + math.random(1000, 2000)
        else
            TotalDiamonds = TotalDiamonds + math.random(10000, 11000)
        end
    end
    return (TotalDiamonds)
end

local function CountGifts()
    local SmallGifts = 0
    local LargeGifts = 0
	for _,v in next, PlayerSave.Get()["Inventory"].Misc do
		if SmallGifts ~= 0 and LargeGifts ~= 0 then 
			break
		end
		if v.id == "Gift Bag" then
			SmallGifts = (v._am or 0)
		elseif v.id == "Large Gift Bag" then
			LargeGifts = (v._am or 0)
		end
	end
	return {tonumber(SmallGifts), tonumber(LargeGifts)}
end

local Gifts = CountGifts()
local StartingSmall = Gifts[1]
local StartingLarge = Gifts[2]

local function SendNotification()
	local Gifts = CountGifts()
	local EndingSmall = Gifts[1]
	local EndingLarge = Gifts[2]

	local Message = {
		["username"] = "System Exodus | Balloon Statistics",
		["avatar_url"] = "https://i.gyazo.com/dbefd0df338c7ff9c08fc85ecea0df94.png",
		["embeds"] = {{
			["color"] = 12035327,
			["title"] = "||"..LocalPlayer.Name.."|| Player Statistics:",
			["timestamp"] = DateTime.now():ToIsoDate(),
			["footer"] = {
				["icon_url"] = "https://i.gyazo.com/784ff41bd2b15e0046c8b621fab31990.png",
				["text"] = "Created by: Jxnt"
			},
			["fields"] = {
				{
					["name"] = ":gift: Gifts:",
					["value"] = "ㅤ• :tada: **Total Retrieved:** `"..(EndingSmall - StartingSmall) + (EndingLarge - EndingLarge).."`\nㅤ• :gem: **Est. Diamonds:** `"..CommasBeADDED(CalcuateDiamonds(EndingSmall - StartingSmall, "Small") + CalcuateDiamonds(EndingLarge - StartingLarge, "Large")).."`",
					["inline"] = true
				},
				{
					["name"] = ":wrench: Other:",
					["value"] = "ㅤ• :stopwatch: **Time Taken:** `"..math.round((os.time() - Stats.Time)/60).." minutes`\nㅤ• :rabbit2: **Server Hops:** `"..Stats.ServerHops.."`",
					["inline"] = true
				}
			},
		}}
	}
	
	request({
		Url = Settings.Webhook,
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"}, 
		Body = HttpService:JSONEncode(Message)
	})
end

local StartingTime = os.time()

function ServerHop()
    repeat task.wait() warn(#IDs) until (os.time() - StartingTime) >= Settings.TeleportDelay and #IDs >= 500
	Stats.ServerHops = Stats.ServerHops + 1
	while task.wait() do
		TeleportService:TeleportToPlaceInstance(game.PlaceId, IDs[Random.new():NextInteger(1, #IDs)], LocalPlayer)
		task.wait(1)
	end
end

if #WorldFolder.BalloonGifts:GetChildren() < 1 then
	return ServerHop()
end

WorldFolder.Orbs.ChildAdded:Connect(function(Orb)
	Library.Network.Fire("Orbs: Collect", {tonumber(Orb.Name)})
	Library.Network.Fire("Orbs_ClaimMultiple", {{Orb.Name}})
	task.wait()
	Orb:Destroy()
end)

WorldFolder.Lootbags.ChildAdded:Connect(function(Lootbag)
	Library.Network.Fire("Lootbags_Claim", {Lootbag.Name})
	task.wait()
	Lootbag:Destroy()
end)

function GetBalloonUID()
	local CurrentZone = Library["MapCmds"].GetCurrentZone() 
	for _,v in next, BreakableCmds.AllByZoneAndClass(CurrentZone, "Chest") do
        if v:GetAttribute("OwnerUsername") == LocalPlayer.Name and string.find(v:GetAttribute("BreakableID"), "Balloon Gift") then
			return v:GetAttribute("BreakableUID")
		elseif v:GetAttribute("OwnerUserName") ~= LocalPlayer.Name and string.find(v:GetAttribute("BreakableID"), "Balloon Gift") then
			return false
		end
	end
end

function FindBalloons()
	for _,v in next, Library.Network.Invoke("BalloonGifts_GetActiveBalloons") do
		if v.Id then
			while getgenv().Settings.Enabled and Library.Network.Invoke("BalloonGifts_GetActiveBalloons")[v.Id] and task.wait() do
				if not Character:FindFirstChild("WEAPON_"..LocalPlayer.Name) then 
					Library.Network.Invoke("Slingshot_Toggle")
				end
				local BalloonUID = GetBalloonUID()
                if BalloonUID then
					print("test1", BalloonUID)
					Library.Network.Fire("Breakables_PlayerDealDamage", BalloonUID)
				elseif BalloonUID ~= false then
					warn("test2", BalloonUID)
					HumanoidRootPart.CFrame = CFrame.new(v.LandPosition - Vector3.new(0, 4, 0))
					Slingshot.fireWeapon()
					Library.Network.Fire("BalloonGifts_BalloonHit", v.Id)
				end
				if Library["MapCmds"].GetCurrentZone() 
                if BalloonUID == false then break end
			end
            task.wait(0.5)
		end
	end
end

task.spawn(function()
	FindBalloons()

	if (os.time() - Stats.Time) >= (Settings.SendDelay * 60) then
		SendNotification()
		Stats.Time = os.time()
		Stats.ServerHops = 0
		Save()
	end

	ServerHop()
end)

local function Noclip()
    for _,v in next, LocalPlayer.Character:GetDescendants() do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end
if not HumanoidRootPart:FindFirstChild("LinearVelocity") and not ReplicatedStorage:FindFirstChild("LinearVelocity") then
    Attachment0 = Instance.new("Attachment", HumanoidRootPart)
    LinearVelocity = Instance.new("LinearVelocity", HumanoidRootPart)
    LinearVelocity.MaxForce = math.huge
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    LinearVelocity.Attachment0 = HumanoidRootPart.Attachment
else
    LinearVelocity = HumanoidRootPart:FindFirstChild("LinearVelocity") or ReplicatedStorage:FindFirstChild("LinearVelocity")
end

task.spawn(function()
    Velocity = nil
    NoclipVariable = nil
    while task.wait() do
        if getgenv().Settings.Enabled then
            if not NoclipVariable then
                NoclipVariable = game.RunService.Stepped:Connect(Noclip)
            end
            LinearVelocity.Parent = HumanoidRootPart
        else
            LinearVelocity.Parent = ReplicatedStorage
            if NoclipVariable then
                NoclipVariable = NoclipVariable:Disconnect()
            end
        end
    end
end)

