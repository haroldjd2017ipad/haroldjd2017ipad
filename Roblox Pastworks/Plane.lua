-- FINISHED PRODUCT: https://www.youtube.com/watch?v=9d_JMxal67E
-- GET THE GUI IN THE ASSETS FOLDER AND PARENT IT TO THE LOCALSCRIPT


-- // LocalScript | Belongs to StarterCharacterScripts //
local plr = game.Players.LocalPlayer
local char = plr.Character
local PlaneSeat = nil -- SET THIS TO THE PLANE'S DRIVER SEAT
local mouse = plr:GetMouse()
local UIS = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local gui

local taxxing = true
local engine = false
local stall = false
local keys = {w=false,a=false,s=false,d=false}
local key = {w=0,a=0,s=0,d=0}

local acel = 2
local breaks = 2
local maxspeed = 200

local speed = 0
local add = 1
local less = 1
local o = 0
local throttle = 0

local a = Instance.new("ScreenGui",plr.PlayerGui);local f = Instance.new("Frame",a); f.Position = UDim2.new(1,0,1,0);local p = Instance.new("Part",workspace); p.Anchored = true; p.CanCollide = false; p.Name = "jetlmao"

jet = PlaneSeat
plr.CharacterAdded:Connect(function(e) char = e end)

for i,v in pairs(jet.Parent.Parent:GetDescendants()) do
	if v.Name:lower():find("gear") ~= nil then
		for _,v2 in pairs(v:GetDescendants()) do
			pcall(function()
				v2.Touched:Connect(function()
					if stall then
						taxxing = true
						stall = false
						gui.Taxiing.Visible = true
						gui.Stall.Visible = false
						face.MaxTorque = Vector3.new(0,9e9,9e9)
						fly.MaxForce = Vector3.new(9e9,0,9e9)
						face.D = 500
					end
				end)
			end)
		end
	end
end

jet.Changed:Connect(function(ee)
	if ee == "Occupant" then
		if jet.Occupant == char.Humanoid then
			gui = script.Plane:Clone()
			gui.Parent = plr.PlayerGui
			spawn(function()
				cam.Changed:Wait()
				cam.CameraSubject = char.Humanoid
			end)
			root = char.HumanoidRootPart
			face = Instance.new("BodyGyro",root)
			face.MaxTorque = Vector3.new(0,9e9,9e9)
			fly = Instance.new("BodyVelocity",root)
			fly.MaxForce = Vector3.new(9e9,0,9e9)
			fly.Velocity = jet.CFrame.LookVector*speed

		else
			pcall(function()
				fly:Destroy()
				fly = nil
				face:Destroy()
				gui:Destroy()
				gui = nil
			end)
		end
	end
end)

UIS.InputBegan:Connect(function(e)
	local k = tostring(e.KeyCode):split(".")[3]:lower()
	for i,v in pairs(keys) do
		if i == k then
			keys[k] = true
		end
	end
	if e.KeyCode == Enum.KeyCode.E and gui then
		engine = not engine
		if not engine and not taxxing then
			gui.Stall.Visible = true
			stall = true
			face.D = 1000
			gui.Main.engine.Visible = true
		end
		if engine then
			gui.Main.engine.Visible = false
			stall = false
			face.D = 500
			gui.Stall.Visible = false
		end
	end
end)
UIS.InputEnded:Connect(function(e)
	local k = tostring(e.KeyCode):split(".")[3]:lower()
	for i,v in pairs(keys) do
		if i == k then
			keys[k] = false
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if fly then
		local x,y = mouse.X/f.AbsolutePosition.X, mouse.Y/f.AbsolutePosition.Y
		local look = ((((root.CFrame.LookVector*5) + (root.CFrame*CFrame.new(x > .5 and (x-.5)*2 or (.5-x)*-2,0,0)).Position) + Vector3.new(0,y > .5 and (y-.5)*-2 or (.5-y)*2,0)) - Vector3.new(0,stall and .05 or 0, 0))
		face.CFrame = CFrame.new(root.Position,look) * CFrame.Angles(0,0,not taxxing and math.rad(x > .5 and (x-.5)*-70 or (.5-x)*70,0,0) or 0)
		local e = root.Position.Y-look.Y
		if o > e and add > 1 then
			local aa = o-e
			add -= (add-aa > 1 and aa or add-1)
		elseif e > 0 then
			add += e/400
		end
		o = e
		fly.Velocity = ((root.CFrame.LookVector*speed) - Vector3.new(0,stall and 10 or 0, 0)) * add
		print(add)
	end
end)

while wait() do
	if gui ~= nil then
		if keys.w and throttle < maxspeed then
			throttle += 1
			print("E")
		end
		if keys.s and throttle > 0 then
			throttle -= 1
		end
		if throttle > speed and engine then
			speed += acel/10
		elseif not stall then
			speed -= acel/10
		end
		local meter = gui.Main.SpeedMeter.Frame
		meter.TakeOff.Position = UDim2.new(70/maxspeed,0,0,0)
		meter.Line.Position = UDim2.new(throttle/maxspeed,0,0,0)
		meter.Meter.Size = UDim2.new(speed/maxspeed,0,1,0)
		for i,v in pairs(keys) do
			if keys[i] and key[i] < 1 and engine then
				key[i] += .01
			elseif key[i] ~= 0 and not keys[i] then
				local n = .2
				key[i] = (key[i]-n >= 0 and key[i]-n or 0)
			end
		end
		if speed > 70 and taxxing then
			taxxing = false
			gui.Stall.Visible = false
			gui.Taxiing.Visible = false
			face.MaxTorque = Vector3.new(9e9,9e9,9e9)
			fly.MaxForce = Vector3.new(9e9,9e9,9e9)
			face.D = 500
		end
		if not taxxing and speed < 70 then
			gui.Stall.Visible = true
			stall = true
			face.D = 1000
		end
		if taxxing then
			local ss = root.Velocity.magnitude
			face.D = 70/(ss >= 1 and ss or 1)*500
		end
		if stall and speed > 20 then 
			speed -= 0.05
		end
		gui.Main.speed.Text = tostring(math.round(root.Velocity.magnitude))
		gui.Main.alt.Text = tostring(math.round(root.Position.Y))
	end
end
