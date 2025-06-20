local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
--local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")

--local LOGIN_STORE = DataStoreService:GetDataStore("userLogins")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system

local util57 = system["util-57"] 
local RemoteFunction = require(util57.Suphi.RemoteFunction)

local awaitGameLoaded = RemoteFunction.new("gameLoading")
local reqeustLogin = RemoteFunction.new("requestLogin")

local function getLocalizationFiles()
	local ok, result = pcall(function()
		return HttpService:GetAsync("http://country.io/names.json")
	end)

	if ok and result then
		return HttpService:JSONDecode(result)
	end
end

local function getCountryCode(player)
	local nations = getLocalizationFiles()
	if nations == nil then
		return "missing"
	end
	
	local ok, code = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, player)
	if ok and code then
		return nations[code]
	end
end

local function createLogin(player)
	local response = reqeustLogin:Fire(player, "Fetching login...")
	
	if response == "AUTO_REQUEST_COUNTRY" then
		local zone = getCountryCode(player)
		
		reqeustLogin:Fire(player, "OK")
		print(`Loaded login {player} for {player.DisplayName}. (ZONE: {zone})`)
	end
end

local function playerAdd(player)
	awaitGameLoaded.Event = function()
		createLogin(player)
	end
end

for _, player in Players:GetPlayers() do
	task.defer(playerAdd, player)
end

Players.PlayerAdded:Connect(playerAdd)
