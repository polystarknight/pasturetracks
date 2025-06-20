local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local user = Players.LocalPlayer
local mouse = user:GetMouse()

local newMouse = require("@self/cache/mouse")
local cache = script.cache
local models = cache.models

local Splash = models.Splash:Clone()
local Vignette = models.Vignette:Clone()
local Document = Splash.Document
local PlayerGui = user:WaitForChild("PlayerGui")

ReplicatedFirst:RemoveDefaultLoadingScreen()
ContentProvider:PreloadAsync({ Document, Document.TextLabel, Document.Terminal.Disp })
Splash.Parent = PlayerGui
Vignette.Parent = PlayerGui
-- ...

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Root = ReplicatedStorage:WaitForChild("Root", 10)

local Common = Root.Common
local Core = Common.Core
local system = Core.system
local util57 = system["util-57"]

local RemoteFunction = require(util57.Suphi.RemoteFunction)
local awaitGameLoaded = RemoteFunction.new("gameLoading")

local loadJob = ReplicatedStorage:GetDescendants()

local function preloadGame()
	for _, asset in pairs(loadJob) do
		--print(`LOAD: {asset}`)
		ContentProvider:PreloadAsync({ asset })
	end
	
	task.spawn(awaitGameLoaded.Fire, awaitGameLoaded)
	Splash:Destroy()
end

local ok, process = pcall(require, system.newProcess)

if ok then
	mouse.Move:Connect(newMouse)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	preloadGame()
	task.defer(process.launch, process)
else
	warn("PROCESS FAIL:", process)
	task.delay(3, user.Kick, user, `PROCESS FAIL! {process}`)
end