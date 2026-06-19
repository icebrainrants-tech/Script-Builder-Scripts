local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

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
	warn("Boombox not found!")
	return
end

local clones = {}
local amount = 6

for i = 1, amount do
	local clone = boombox:Clone()
	clone.Parent = workspace

	local mainPart = clone:FindFirstChildWhichIsA("BasePart", true)

	if mainPart then
		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = true
				v.CanCollide = false

				local light = Instance.new("PointLight")
				light.Color = Color3.fromRGB(170, 0, 255)
				light.Brightness = 3
				light.Range = 15
				light.Parent = v
			end
		end

		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(170, 0, 255)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.4
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = clone

		table.insert(clones, {
			Model = clone,
			MainPart = mainPart
		})
	end
end

local radius = 8
local height = 2
local speed = 8

RunService.RenderStepped:Connect(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")

	if not hrp or not head then
		return
	end

	local t = tick() * speed

	for i, data in ipairs(clones) do
		local angle = t + ((math.pi * 2) / amount) * (i - 1)

		local pos = hrp.Position + Vector3.new(
			math.cos(angle) * radius,
			height,
			math.sin(angle) * radius
		)

		local cf = CFrame.lookAt(pos, head.Position)

		local oldCF = data.MainPart.CFrame
		data.MainPart.CFrame = cf

		for _, v in ipairs(data.Model:GetDescendants()) do
			if v:IsA("BasePart") and v ~= data.MainPart then
				local offset = oldCF:ToObjectSpace(v.CFrame)
				v.CFrame = cf * offset
			end
		end
	end
end)local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

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
	warn("Boombox not found!")
	return
end

local clones = {}
local amount = 9

for i = 1, amount do
	local clone = boombox:Clone()
	clone.Parent = workspace

	local mainPart = clone:FindFirstChildWhichIsA("BasePart", true)

	if mainPart then
		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = true
				v.CanCollide = false

				local light = Instance.new("PointLight")
				light.Color = Color3.fromRGB(170, 0, 255)
				light.Brightness = 3
				light.Range = 15
				light.Parent = v
			end
		end

		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(170, 0, 255)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.4
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = clone

		table.insert(clones, {
			Model = clone,
			MainPart = mainPart
		})
	end
end

local radius = 8
local height = 2
local speed = 8

RunService.RenderStepped:Connect(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")

	if not hrp or not head then
		return
	end

	local t = tick() * speed

	for i, data in ipairs(clones) do
		local angle = t + ((math.pi * 2) / amount) * (i - 1)

		local pos = hrp.Position + Vector3.new(
			math.cos(angle) * radius,
			height,
			math.sin(angle) * radius
		)

		local cf = CFrame.lookAt(pos, head.Position)

		local oldCF = data.MainPart.CFrame
		data.MainPart.CFrame = cf

		for _, v in ipairs(data.Model:GetDescendants()) do
			if v:IsA("BasePart") and v ~= data.MainPart then
				local offset = oldCF:ToObjectSpace(v.CFrame)
				v.CFrame = cf * offset
			end
		end
	end
end)
