-- FINISHED PRODUCT: https://www.youtube.com/watch?v=lz-FB6Q4ucg
-- THE BALL TOOL SHOULD HAVE ANYTHING PARENTED TO IT NAMED "25137124"
-- INSERT THE SLIDER GUI IN THE STARTERGUI FOR IT TO FUNDTION. THE SLIDER IS IN THE ASSETS FOLDER


--// LocalScript | This belongs in StarterPlayerScripts //
local tw = game:GetService("TweenService")
local plr = game.Players.LocalPlayer
local b = plr.PlayerGui:WaitForChild("BallKickSlider").Frame
local c = nil
local UIS = game:GetService("UserInputService")
local pow = b.Parent.power
local s = b.Slider
local db = false
local pr = false
local k = game.ReplicatedStorage.ball_kick.Kick:InvokeServer("23787125481")
local ballName = ""

for i,v in pairs(workspace:GetDescendants()) do
	local id = v:FindFirstChild("id") or Instance.new("IntValue")
	if id.Value == 634721846132 then
		v.Touched:Connect(function(h)
			if h:FindFirstChild("_2716312451723") then
				h.goal.Enabled = true
			end
		end)
	end
end

UIS.InputBegan:Connect(function(e,t)
	if e.KeyCode == Enum.KeyCode.E and not t and not b.Visible and not db and plr.Character:FindFirstChild("25137124",true) then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://8783411483"
		
		pcall(function()
			plr.Character.Humanoid:LoadAnimation(anim):Play()
		end)
		ballName = plr.Character:FindFirstChildOfClass("Tool").Name
		pr = true
		s.Position = UDim2.new(0,0,0,0)
		b.Visible = true
		c = tw:Create(s,TweenInfo.new(1.25,Enum.EasingStyle.Linear),{Position = UDim2.new(0.994,0,0,0)})
		c:Play()
	end
end)

function cn()
	plr.Backpack.ChildAdded:Connect(function(e)
		if e.Name == "Ball" and pr then
			pr = false
			c:Cancel()
			b.Visible = false
		end
	end)
end
cn()
plr.CharacterAdded:Connect(cn)

UIS.InputEnded:Connect(function(e,t)
	if e.KeyCode == Enum.KeyCode.E and not t and not db and pr then
		pr = false
		db = true
		c:Cancel()
		pow.Visible = true
		local p = 0
		local x = s.Position.X.Scale
		p = (x < .5 and x/.5*100 or (1-x)/.5*100)
		p = (p > 95 and 100 or (math.round(p) == 1 and 0 or p))
		local po = p
		pow.Text = tostring(math.round(p)).."%"
		
		p = math.round(p)*1.25
		p += (125-p)/2
		
		local ball,i = game.ReplicatedStorage.ball_kick.Kick:InvokeServer(p,k,ballName,po)
		k = i
		local ii = Instance.new("IntValue",ball)
		ii.Name = "_2716312451723"
		
		wait(1)
		pow.Visible = false
		b.Visible = false
		
		wait(.5)
		db = false
	end
end)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


--// Server Script | This belongs in ServerScriptService //
local f = game.ReplicatedStorage.ball_kick
local ids = {}
local ps = game:GetService("PhysicsService")

ps:CreateCollisionGroup("Balls")
ps:CollisionGroupSetCollidable("Balls","Balls",false)

function func(pl,p,i,b,po)
	local id
	if p == "23787125481" then
		if ids[pl.Name] ~= nil then
			if ids[pl.Name] ~= "none" then
				return pl:Kick("\n sussy exploits")
			end
		end
		id = math.random(0000,9999)
		ids[pl.Name] = id
		return id
	end
	if i ~= ids[pl.Name] then
		return pl:Kick("\n sussy exploits")
	else
		id = math.random(0000,9999)
		ids[pl.Name] = id
	end
	local ball = script.Parent.ballShop:FindFirstChild(b,true):Clone()
	for i,v in pairs(f.contents:GetChildren()) do
		local cc = v:Clone()
		cc.Parent = ball
	end
	local char = pl.Character
	local l = char.HumanoidRootPart.CFrame.LookVector*2
	local kick = Instance.new("BodyForce",ball)
	local pp = Instance.new("IntValue",ball)
	pp.Name = "Points"
	local goal
	for i,v in pairs(workspace:GetDescendants()) do
		pcall(function()
			if v.id.Value == 634721846132 then
				goal = v
			end
		end)
	end
	pp.Value = math.floor((char.HumanoidRootPart.Position-goal.Position).magnitude/4.5)
	ball.Multiplier.Value *= math.floor(po/10)
	ball.plr.Value = pl.Name
	ball.CFrame = CFrame.new(char.RightFoot.Position + l + Vector3.new(0,1,0) + (char.HumanoidRootPart.Velocity/2))
	ball.Parent = workspace
	local force = (l*(p*7))+Vector3.new(0,10*p,0)
	kick.Force = force*2
	return ball, id
end
f.Kick.OnServerInvoke = func

game.Players.PlayerRemoving:Connect(function(p)
	ids[p.Name] = "none"
end)