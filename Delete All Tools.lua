local player = game.Players.LocalPlayer

local function clearTools(container)
	if not container then return end

	for _, item in ipairs(container:GetChildren()) do
		if item:IsA("Tool") then
			item:Destroy()
		end
	end
end

local function wipeAll()
	clearTools(player:FindFirstChild("Backpack"))
	clearTools(player:FindFirstChild("StarterGear"))
	clearTools(player.Character)
end

-- run once
wipeAll()

-- keep deleting tools if they come back
player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	clearTools(char)
end)

player:WaitForChild("Backpack").ChildAdded:Connect(function(child)
	if child:IsA("Tool") then
		task.wait()
		child:Destroy()
	end
end)
