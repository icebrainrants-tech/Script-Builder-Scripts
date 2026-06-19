local IMAGE_ID = "rbxassetid://107783419017449"
local MUSIC_ID = "rbxassetid://95156028272944"

local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local soundService = game:GetService("SoundService")

-- SKY
local oldSky = lighting:FindFirstChildOfClass("Sky")
if oldSky then
	oldSky:Destroy()
end

local sky = Instance.new("Sky")
sky.SkyboxBk = IMAGE_ID
sky.SkyboxDn = IMAGE_ID
sky.SkyboxFt = IMAGE_ID
sky.SkyboxLf = IMAGE_ID
sky.SkyboxRt = IMAGE_ID
sky.SkyboxUp = IMAGE_ID
sky.Parent = lighting

-- MUSIC
local music = Instance.new("Sound")
music.SoundId = MUSIC_ID
music.Volume = 0.5
music.Looped = true
music.PlaybackSpeed = 0.2
music.Parent = soundService
music:Play()

-- DECALS ON PARTS
for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
			local decal = Instance.new("Decal")
			decal.Texture = IMAGE_ID
			decal.Face = face
			decal.Parent = obj
		end
	end
end

-- PARTICLES ABOVE HEAD
local function addParticles(character)
	local head = character:FindFirstChild("Head")
	if not head then return end

	local attachment = Instance.new("Attachment")
	attachment.Position = Vector3.new(0, 2, 0)
	attachment.Parent = head

	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = IMAGE_ID
	emitter.Rate = 25
	emitter.Lifetime = NumberRange.new(1, 2)
	emitter.Speed = NumberRange.new(1, 3)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Parent = attachment
end

for _, player in ipairs(players:GetPlayers()) do
	if player.Character then
		addParticles(player.Character)
	end
	player.CharacterAdded:Connect(addParticles)
end
