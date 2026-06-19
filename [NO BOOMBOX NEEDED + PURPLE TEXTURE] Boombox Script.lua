local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local BOOMBOX_TEXTURE = "rbxassetid://133906451206721"
local FALLBACK_MESH = "rbxassetid://212302951"

ContentProvider:PreloadAsync({BOOMBOX_TEXTURE})

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

local clones = {}
local amount = 20

for i = 1, amount do
	local model = Instance.new("Model")

	local mainPart

	if boombox then
		local clone = boombox:Clone()

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = true
				v.CanCollide = false
			end

			if v:IsA("MeshPart") then
				v.TextureID = BOOMBOX_TEXTURE
			elseif v:IsA("SpecialMesh") then
				v.TextureId = BOOMBOX_TEXTURE
			end
		end

		clone.Parent = model
		mainPart = clone:FindFirstChildWhichIsA("BasePart", true)

	else
		-- FALLBACK (FIXED AS REQUESTED)
		mainPart = Instance.new("Part")
		mainPart.Anchored = true
		mainPart.CanCollide = false
		mainPart.Material = Enum.Material.Neon
		mainPart.Color = Color3.fromRGB(170, 0, 255)
		mainPart.Name = "FallbackPart"

		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.FileMesh
		mesh.MeshId = FALLBACK_MESH
		mesh.TextureId = BOOMBOX_TEXTURE
		mesh.Scale = Vector3.new(4, 4, 4) -- ✅ YOUR REQUEST
		mesh.Parent = mainPart

		mainPart.Parent = model
	end

	model.Parent = workspace

	table.insert(clones, {
		Model = model,
		MainPart = mainPart
	})
end

local radius = 10
local height = 2
local speed = 8

RunService.RenderStepped:Connect(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")
	if not hrp or not head then return end

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
