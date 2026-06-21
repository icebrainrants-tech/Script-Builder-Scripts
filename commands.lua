local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

------------------------------------------------
-- HELPERS
------------------------------------------------

local function getHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("Humanoid")
end

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

------------------------------------------------
-- FLOAT
------------------------------------------------

local floatConnection

local function startFloat()
	if floatConnection then return end

	floatConnection = RunService.Heartbeat:Connect(function()
		local char = player.Character
		if not char then return end

		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 6, root.Velocity.Z)
		end
	end)
end

local function stopFloat()
	if floatConnection then
		floatConnection:Disconnect()
		floatConnection = nil
	end
end

------------------------------------------------
-- FLY (UNCHANGED)
------------------------------------------------

local flying = false
local flyConnection
local flySpeed = 2

local function startFly()
	if flying then return end
	flying = true

	local char = getCharacter()
	local hum = getHumanoid()

	hum.PlatformStand = true

	flyConnection = RunService.Heartbeat:Connect(function()
		if not flying then return end

		local character = player.Character
		if not character then return end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end

		if humanoid.MoveDirection.Magnitude > 0 then
			character:TranslateBy(humanoid.MoveDirection * flySpeed)
		end
	end)
end

local function stopFly()
	flying = false

	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.PlatformStand = false
	end

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
end

------------------------------------------------
-- CHAT COMMANDS
------------------------------------------------

player.Chatted:Connect(function(msg)
	msg = string.lower(msg)

	local speed = msg:match("^!speed%s+(-?%d+)$")
	if speed then
		getHumanoid().WalkSpeed = tonumber(speed)
		return
	end

	local jump = msg:match("^!jumpower%s+(-?%d+)$")
	if jump then
		local hum = getHumanoid()
		hum.UseJumpPower = true
		hum.JumpPower = tonumber(jump)
		return
	end

	local gravity = msg:match("^!gravity%s+(-?%d+)$")
	if gravity then
		workspace.Gravity = tonumber(gravity)
		return
	end

	if msg == "!float" then
		startFloat()
		return
	end

	if msg == "!unfloat" then
		stopFloat()
		return
	end

	if msg == "!fly" then
		startFly()
		return
	end

	if msg == "!unfly" then
		stopFly()
		return
	end

	if msg == "!rejoin" then
		TeleportService:Teleport(game.PlaceId, player)
		return
	end
end)
