local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local TEXTURE_ID = "rbxassetid://133906451206721"

local function applyTexture(tool)
	if not tool then return end

	for _, v in ipairs(tool:GetDescendants()) do
		if v:IsA("MeshPart") then
			v.TextureID = TEXTURE_ID
		elseif v:IsA("SpecialMesh") then
			v.TextureId = TEXTURE_ID
		elseif v:IsA("SurfaceAppearance") then
			v.ColorMap = TEXTURE_ID
		end
	end
end

local function hookCharacter(char)
	character = char

	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and string.lower(child.Name) == "boombox" then
			task.wait(0.1)
			applyTexture(child)
		end
	end)

	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") and string.lower(v.Name) == "boombox" then
			applyTexture(v)
		end
	end
end

local function hookBackpack()
	local backpack = player:WaitForChild("Backpack")

	backpack.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and string.lower(child.Name) == "boombox" then
			child.Equipped:Connect(function()
				task.wait(0.1)
				applyTexture(child)
			end)
		end
	end)

	for _, v in ipairs(backpack:GetChildren()) do
		if v:IsA("Tool") and string.lower(v.Name) == "boombox" then
			v.Equipped:Connect(function()
				task.wait(0.1)
				applyTexture(v)
			end)
		end
	end
end

hookCharacter(character)
player.CharacterAdded:Connect(hookCharacter)
hookBackpack()
