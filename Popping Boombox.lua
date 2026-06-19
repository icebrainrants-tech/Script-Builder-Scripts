local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

local TEXTURE = "rbxassetid://133906451206721"
local MUSIC_ID = "rbxassetid://5409360995"

local function findBoombox()
	local backpack = player:FindFirstChild("Backpack")
	local starterGear = player:FindFirstChild("StarterGear")

	local function search(container)
		if not container then return nil end
		for _, v in ipairs(container:GetChildren()) do
			if v:IsA("Tool") and string.lower(v.Name) == "boombox" then
				return v
			end
		end
	end

	return search(backpack) or search(starterGear)
end

local boombox = findBoombox()
if not boombox then
	warn("No boombox found")
	return
end

local clones = {}
local amount = 7

-- create boombox line
for i = 1, amount do
	local clone = boombox:Clone()
	local mainPart = clone:FindFirstChildWhichIsA("BasePart", true)

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end

		if v:IsA("MeshPart") then
			v.TextureID = TEXTURE
		elseif v:IsA("SpecialMesh") then
			v.TextureId = TEXTURE
		end
	end

	-- sound (only on first, but controls beat)
	local sound
	if i == 1 and mainPart then
		sound = Instance.new("Sound")
		sound.SoundId = MUSIC_ID
		sound.Looped = true
		sound.Volume = 1
		sound.Parent = mainPart
		sound:Play()
	end

	clone.Parent = workspace

	table.insert(clones, {
		Model = clone,
		MainPart = mainPart,
		offset = i,
		sound = sound
	})
end

-- movement settings
local spacing = 2.5
local shake = 0.12
local baseHeight = 2.5

local lastVolume = 0
local popStrength = 0

RunService.RenderStepped:Connect(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")
	if not hrp or not head then return end

	local t = tick()

	-- approximate beat using volume changes
	local sound = clones[1].sound
	if sound then
		local currentVolume = sound.PlaybackLoudness or 0

		-- detect spike (beat-like moment)
		if currentVolume > lastVolume + 20 then
			popStrength = 1
		end

		lastVolume = currentVolume
	end

	-- decay pop
	popStrength = math.clamp(popStrength - 0.05, 0, 1)

	for i, data in ipairs(clones) do
		if data.MainPart then

			-- line formation
			local basePos = hrp.Position
				+ hrp.CFrame.RightVector * ((i - (amount / 2)) * spacing)
				+ Vector3.new(0, baseHeight, 0)

			-- shake
			local shakeOffset = Vector3.new(
				math.sin(t * 6 + i) * shake,
				math.cos(t * 5 + i) * shake,
				math.sin(t * 4 + i) * shake
			)

			-- POP EFFECT (bounce outward then return)
			local popOffset = hrp.CFrame.LookVector * (popStrength * 1.5)

			local pos = basePos + shakeOffset + popOffset

			local cf = CFrame.lookAt(pos, head.Position)

			local oldCF = data.MainPart.CFrame
			data.MainPart.CFrame = cf

			for _, v in ipairs(data.Model:GetDescendants()) do
				if v:IsA("BasePart") and v ~= data.MainPart then
					local rel = oldCF:ToObjectSpace(v.CFrame)
					v.CFrame = cf * rel
				end
			end
		end
	end
end)
