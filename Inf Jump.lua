local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

UserInputService.JumpRequest:Connect(function()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
