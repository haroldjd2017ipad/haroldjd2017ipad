-- FINISHED PRODUCT: https://www.youtube.com/watch?v=-zBgK-azaUU


-- // LocalScript | This belongs in StarterCharacterScripts
local struck = false
local plr = game.Players.LocalPlayer
local backpack = plr:WaitForChild("Backpack")
local mouse = plr:GetMouse()

local t = Instance.new("Tool",plr:WaitForChild("Backpack"))
t.Name = "Lightning"

backpack.ChildRemoved:Connect(function(e) 
	if e.Name == "Lightning" then
		struck = true
	end
end)
backpack.ChildAdded:Connect(function(e) 
	if e.Name == "Lightning" then
		struck = false
	end
end)

mouse.Button1Down:Connect(function()
	if struck then
		game.ReplicatedStorage.Lightning:FireServer(mouse.Hit.Position)
	end
end)
-----------------------------------------------------------------
-----------------------------------------------------------------


-- // Server Script | This belongs in ServerScriptService //
local rem = Instance.new("RemoteEvent",game.ReplicatedStorage)
rem.Name = "Lightning"
function r(a,b)
	return math.random(a,b)
end
function line()
	local line = Instance.new("Part",workspace)
	line.Material = Enum.Material.Neon
	line.Color = Color3.fromRGB(253, 208, 35)
	line.Anchored = true
	line.CanCollide = false
	delay(2,function()
		line:Destroy()
	end)
	return line
end
function ee(e)
	local line = line()
	line.Size = Vector3.new(2,2,(e-prev).magnitude)
	line.CFrame = CFrame.new(prev,e)
	line.Position = line.Position+(line.CFrame.LookVector*(line.Size.Z/2))
end

rem.OnServerEvent:Connect(function(_,pos)
	local start = Vector3.new(pos.X+r(-10,10),700,pos.Z+r(-10,10))
	current = Vector3.new(pos.X+r(-8,8),start.Y-r(30,40),pos.Z+r(-8,8))
	prev = current
	while current.Y - pos.Y >= 40.01 do
		prev = current
		local pos2 = current
		current = Vector3.new(pos2.X+r(-8,8),pos2.Y-r(30,40),pos2.Z+r(-8,8))
		ee(current)
	end
	prev = current
	local pos2 = current
	current = pos
	ee(current)
	local s = Instance.new("Part",workspace)
	s.Position = pos
	s.Transparency = 1
	s.Anchored = true
	s.CanCollide = false
	local ss = Instance.new("Sound",s)
	ss.SoundId = "rbxassetid://1079408535"
	ss.Volume = 5
	ss:Play()
	for i = 1,10 do
		spawn(function()
			local e = Instance.new("Explosion",workspace)
			e.Position = pos
			e.DestroyJointRadiusPercent = 20
		end)
	end
	for i,v in pairs(workspace:GetDescendants()) do
		pcall(function()
			if (v.Position-pos).magnitude <= 10 and v ~= s then
				v.Anchored = false
			end
		end)
	end
end)
