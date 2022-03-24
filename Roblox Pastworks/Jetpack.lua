-- FINISHED PRODUCT: https://www.youtube.com/watch?v=E4h-GrYt4j0
-- INSERT A TOOL PARENTED TO THE LOCALSCRIPT NAMED "Jetpack"
-- INSERT THE JETPACK MODEL PARENTED TO THE LOCALSCRIPT AND NAME IT "Jetpack". THE DEFAULT MODEL IS IN THE ASSETS FOLDER 

-- // LocalScript | Belongs to StarterCharacterScripts //
local plr = game.Players.LocalPlayer
local tool = script:WaitForChild("Jetpack")
local UIS = game:GetService("UserInputService")
local char = script.Parent
local model = script.Jetpack_
local root = char:WaitForChild("HumanoidRootPart")
local p = Instance.new("Part",workspace)
local feet = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")

local combo = 0
local t = 0
local up = false
local enabled = false

local accel = .25
local maxspeed = 5
local speed = accel

local keys = {w=0,a=0,s=0,d=0}
local keys_hold = {w=false,a=false,s=false,d=false}

local rot

tool.Parent = plr.Backpack
model.Middle.Weld.Part1 = char:WaitForChild("HumanoidRootPart")
p.Anchored = true
p.Name = "bruhlol"
p.CanCollide = false

feet.Touched:Connect(function(e)
	if not e:IsDescendantOf(char) and enabled then
		enabled = false
		char.Humanoid.PlatformStand = false
		rot:Destroy()
		for i,v in pairs(keys) do
			keys[i] = 0
		end
		for i,v in pairs(model:GetDescendants()) do
			if v.Name == "Fire" then
				v.Enabled = false
			end
		end
	end
end)

UIS.InputBegan:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.Space and tool.Parent == char then
		if combo == 1 and tick()-t < 1 then
			char.Humanoid.PlatformStand = true
			rot = Instance.new("BodyGyro",root)
			rot.P = 7000
			rot.MaxTorque = Vector3.new(9e9,9e9,9e9)
			rot.CFrame = CFrame.new(root.Position,root.Position+root.CFrame.LookVector)
			root.Velocity = Vector3.new(0,root.Velocity.Y*-1,0)
			enabled = true
			up = true
			for i,v in pairs(model:GetDescendants()) do
				if v.Name == "Fire" then
					v.Enabled = true
				end
			end
			speed = 1
			combo = 0
		else 
			if enabled then
				up = true
				speed = accel
				warn("ok")
			else
				combo = 1
				t = tick()
			end
		end
	end
	local k = tostring(i.KeyCode):split(".")[3]:lower()
	local ok = false
	for i,v in pairs(keys_hold) do
		if i == k then
			ok = true
		end
	end
	if ok then
		keys_hold[k] = true
	end
end)

function set(t)
	for i,v in pairs(model:GetChildren()) do
		pcall(function()
			if v.Name:find("Flame") == nil then
				v.Transparency = t
			end
		end)
	end
end

char.ChildAdded:Connect(function(t)
	if t == tool then
		model.Parent = char
		model.Middle.Weld.Part1 = root
		set(0)
	end
end)
char.ChildRemoved:Connect(function(t)
	if t == tool then
		set(1)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.Space and enabled then
		up = false
		while speed > 0 do
			wait()
			speed -= accel/10
		end
	end
	local k = tostring(i.KeyCode):split(".")[3]:lower()
	local ok = false
	for i,v in pairs(keys_hold) do
		if i == k then
			ok = true
		end
	end
	if ok then
		keys_hold[k] = false
	end
end)

while wait() do
	if enabled then
		if up then
			speed += accel/70
		else
			speed -= accel/50
		end
		local vel = Vector3.new(0,(speed < maxspeed and speed or maxspeed)*20,0)
		for i,v in pairs(keys) do
			if keys_hold[i] and v < maxspeed then
				keys[i] += accel/7
			elseif v ~= 0 and not keys_hold[i] then
				local n = accel/3
				keys[i] = (v-n >= 0 and v-n or 0)
			end
		end
		vel += root.CFrame.LookVector*(keys.w*10) * Vector3.new(1,0,1)
		
		local ee = (((root.CFrame.LookVector*5) + ((root.CFrame*CFrame.new(keys.d - keys.a, 0,0)).Position)) * Vector3.new(1,0,1) + Vector3.new(0,root.Position.Y,0)) - Vector3.new(0,keys.w/1.5,0)
		rot.CFrame = CFrame.new(root.Position,ee)
		--p.Position = ee
		root.Velocity = vel
	end
end