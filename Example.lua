-- LOCALSCRIPT OF THE HOUSE SYSTEM GUI by haroldjd2017ipad (Harold2701)
-- Game link: https://www.roblox.com/games/11878041993/House-system

-- Services
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local remote = RS:WaitForChild("HousingSystem")
local UIS = game:GetService("UserInputService")

-- Global Variables
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local main = script.Parent
local House
local Items = RS.Items
local Assets = main.Assets
local edit = Assets.Control.Frame.Frame

local control,container = main.Control, main.ItemContainer
local stop,place,grid,cancel = control.Stop, control.Place, control.Grid, control.Cancel

local gridSize = .5

local CanMove = true
local Editing = false
local RotateAngle = 0
local Mode	-- will be "move" or "place"

local Moving			-- model
local CanPlace, Hitbox	-- bool, part
local Selected			-- model (selected object on edit mode)

local locked = false	-- door lock

-- sets of item control buttons
local normal = {"Move","Delete","Rotate"}	-- item control buttons that will show when selecting an item on edit mode
local MobilePlace = {"Rotate","Place"}		-- item control buttons that will show when moving/placing objects on mobile
local Wall = {"Move","Delete"}				-- item control buttons that will show when moving/placing objects that are attached on walls


-- yields until the client claims a house
repeat wait()
until workspace.Houses:FindFirstChild(Player.Name)

House = workspace.Houses:FindFirstChild(Player.Name)
main.Edit.Visible = true
main.Lock.Visible = true

local function snap(p) -- returns the grid-snapped position of the given number
	-- if grid size is 0 then return the same but if not then round down ("p" divided by grid size plus 0.5) then multiply to grid size
	return gridSize == 0 and p or math.floor(p / gridSize + 0.5) * gridSize 
end

local function ctrlbuttons(set)	-- shows the given set of item control buttons then hide other else thats not in that set
	for i,v in pairs(edit:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("ImageButton") then
			if table.find(set,v.Name) then
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end
end

local function Select(item) -- it shows the selection box and item control buttons in the given item  
	if Rotate and Selected then -- if the rotate item control button was clicked and the item was deselected or selected again then apply the rotate changes to the server
		Rotate = false
		coroutine.wrap(function()
			remote:InvokeServer("move",{["item"] = Selected.ItemId.Value,["pos"] =Selected:GetBoundingBox()})
		end)()
	end
	Selected = item
	
	Assets.Select.Adornee = Selected
	ctrlbuttons(normal)
	Assets.Control.Adornee = Selected

	if Selected then
		Assets.Control.StudsOffset = Vector3.new(0,(Selected:GetExtentsSize().Y/2) +3,0) -- adjust the item control buttons height based on the selected item height
		
		if (Selected:FindFirstChild("PlaceOnWalls") or Instance.new("BoolValue")).Value then --  if the item is meant to be placed on walls then show the item control buttons for walls
			ctrlbuttons(Wall)
		end
	end
end

local function StopPlacing() -- called when clicking the "Stop Placing" button and after moving an item and when canceling a placement
	if Moving then
		CanMove = false
		
		if Mode == "Place" then -- delete the temporary model if you were placing an item
			Moving:Destroy()
		end
		
		if Mode == "Move" then -- if you were moving an item then if you cancelled moving then move back to original spot but if you moved the item successfuly then it doesnt change the position
			Moving:PivotTo(Oldpos)
		end
		
		-- hides item control buttons and selection box and resets rotate angle
		Moving = nil
		RotateAngle = 0
		cancel.Visible = false
		Assets.CantPlace.Adornee = nil
		Assets.Moving.Adornee = nil
		Assets.MobilePlace.Adornee = nil
	end
end


local function WaitForPlace() -- yiels until you place an item or finish moving an item or you cancel placement
	local clicked = false

	local event = UIS.InputBegan:Connect(function(input,processed) -- detect for mouse clicks
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed and CanPlace then
			clicked = true
		end
	end)
	
	local event2 = edit.Place.MouseButton1Down:Connect(function() -- detect for mobile's place button
		CanMove = false
		clicked = true
	end)
	
	-- yields until response (mouse click or place button click or cancel placement)
	repeat task.wait()
	until clicked or not Moving
	
	event:Disconnect()
	event2:Disconnect()
	
	return clicked -- returns true if plcement success or moving an item success, return false if placement is cancelled
end

local function Move(model,func)	-- sets up the stuff for moving an item then calls the func after you (place an item or finish moving an item or you cancel placement)
	local _,ry,_ = model:GetBoundingBox():ToEulerAnglesXYZ() -- gets the current model rotation
	
	RotateAngle = math.deg(ry)
	cancel.Visible = true
	CanMove = true
	Rotate = false
	container.Visible = false
	Moving = model	-- allows you to move the temporary model around with your mouse
	Assets.Moving.Adornee = model
	
	if not UIS.MouseEnabled then -- shows the mobile item control buttons for placing if your on mobile
		ctrlbuttons(MobilePlace)
	end
	
	coroutine.wrap(function() -- calls the func after you (place an item or finish moving an item or you cancel placement)
		if WaitForPlace() then
			CanMove = false
			coroutine.wrap(func)() -- func is the response (mouse click or place button click or cancel placement) handler function
			StopPlacing()
		end
	end)()
end

local function display(item) -- creates a button then displays the item model to the button using viewport then displays the button to the item selection
	local button = script.TextButton:Clone()
	local viewport = button.ViewportFrame
	local model = item:Clone()
	local camera = Instance.new("Camera",viewport)
	local size = (model:GetExtentsSize().magnitude)

	button.Parent = main.ItemContainer.ScrollingFrame.Frame
	model.Parent = viewport
	model:PivotTo(CFrame.new(0,0,0))
	camera.CFrame = CFrame.new(Vector3.new(0,0,0)+(Vector3.new(size/1.5,size/2,-size)/1.3),Vector3.new(0,0,0))
	viewport.CurrentCamera = camera
	button.TextLabel.Text = model.Name

	button.MouseButton1Click:Connect(function() -- place item when you click the button
		local tempmodel = model:Clone()

		tempmodel.Parent = workspace
		Mode = "Place"
		
		Move(tempmodel,function()
			container.Visible = true
			remote:InvokeServer("place",{["item"] = Moving.Name, ["pos"] = Moving:GetBoundingBox()})
		end)
	end)
end

game:GetService("RunService").RenderStepped:Connect(function() -- it moves the temporary placing model to your mouse cursor position in real-time
	Assets.Control.Enabled = Assets.Control.Adornee ~= nil
	
	if Moving then
		local part,pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(Mouse.UnitRay.Origin, Mouse.UnitRay.Direction*1000), {Moving, Player.Character})
		local rayp = RaycastParams.new() rayp.FilterDescendantsInstances = {Moving,Player.Character} rayp.FilterType = Enum.RaycastFilterType.Blacklist
		local ray = workspace:Raycast(Mouse.UnitRay.Origin, Mouse.UnitRay.Direction*1000, rayp)
		local size = Moving:GetExtentsSize()
		local modelPos = Moving:GetBoundingBox()
		
		if not part then return end
		
		local walls = (Moving:FindFirstChild("PlaceOnWalls") or Instance.new("BoolValue")).Value
		local wallplace = ((not part:IsDescendantOf(House.Items) and part:IsDescendantOf(House)) and walls == true)

		CanPlace = true
		
		if not Hitbox then
			Hitbox = Instance.new("Part"); Hitbox.Transparency = 1; Hitbox.CanCollide = false; Hitbox.Size = size; Hitbox.Anchored = true; Hitbox.CFrame = Moving:GetBoundingBox()
			Hitbox.Parent = Moving
			Hitbox.Touched:Connect(function() end)
		end
		
		Hitbox.CFrame = modelPos
		
		-- if your trying to place the item away from your house then you cant place the item
		if part ~= House.Plot and not wallplace then
			CanPlace = false
		end
		if wallplace and part == House.Plot then
			CanPlace = false
		end
		
		
		for i,v in pairs(Hitbox:GetTouchingParts()) do -- check if the model your placing is colliding with anything, if it is then you cant place it
			if not wallplace then
				if not v:IsDescendantOf(Moving) then
					CanPlace = false
				end
			elseif (v ~= part and not v:IsDescendantOf(Moving)) or (not v:IsDescendantOf(House) and v:IsDescendantOf(House.Items)) then
				CanPlace = false
			end
		end
		
		if wallplace then -- if your placing an item thats meant to be placed on your walls but your not placing it there then you cant place it
			local p1 = workspace:FindPartOnRayWithWhitelist(Ray.new((modelPos*CFrame.new(0,0,-(size.Z/2))).Position, Vector3.new(0,-9e9,0)),{House.Plot})
			if not p1 then
				CanPlace = false
			end
		end
		
		if not CanPlace then -- if its not letting you place the item then show the red selection box
			Assets.CantPlace.Adornee = Moving
			Assets.Moving.Adornee = nil
		else -- if its letting you place it then show the green selection box
			Assets.CantPlace.Adornee = nil
			Assets.Moving.Adornee = Moving
		end
		
		
		if CanMove then -- if you can move the item then snap it into the grid
			if not walls then
				Moving:PivotTo(CFrame.new(snap(pos.X),pos.Y+size.Y/2,snap(pos.Z)) * CFrame.Angles(0,math.rad(RotateAngle),0))
			else
				pos = ray.Position; pos = Vector3.new(snap(pos.X),snap(pos.Y),snap(pos.Z))
				local cf = CFrame.new(pos, pos+ray.Normal)
				local ofset = cf.LookVector*(size.Z/2)
				local _,p = workspace:FindPartOnRayWithWhitelist(Ray.new(pos+(cf.LookVector*100), -(cf.LookVector*9e9)),{part})
				pos = p

				Moving:PivotTo(CFrame.new(pos+ofset, pos+cf.LookVector*100))
			end
		end
	else
		if Hitbox then
			Hitbox:Destroy()
			Hitbox = nil
		end
	end
end)

UIS.InputBegan:Connect(function(input,proccessed)
	-- if your click on an item and your not currently moving ot placing another item then select the item that you clicked
	if not proccessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Editing and not Moving then
		local item = nil
		
		if Mouse.Target:IsDescendantOf(House.Items) then
			for i,v in pairs(House.Items:GetChildren()) do
				if Mouse.Target:IsDescendantOf(v) then
					item = v
				end
			end
		end
		
		Select(item)
	end
	
	-- if you pressed R when you currently moving/placing an item then rotate it
	if input.KeyCode == Enum.KeyCode.R and Moving then
		RotateAngle += 45
	end
end)

for i,v in pairs(Items:GetChildren()) do -- display all the items from items model folder to the item selection
	display(v)
end

main.Edit.MouseButton1Click:Connect(function() -- when edit button is clicked hide the button then show the placement control buttons on the top bar
	main.Edit.Visible = false
	main.Control.Visible = true
	Editing = true
end)

stop.MouseButton1Click:Connect(function() -- when "Stop Placing" button is clicked then stop placing and show the "Edit" button and hide the placement control buttons and hide the item selection and deselect the selected item
	Rotate = false
	Editing = false
	main.Edit.Visible = true
	main.Control.Visible = false
	main.ItemContainer.Visible = false
	
	StopPlacing()
	Select(nil)
end)

place.MouseButton1Click:Connect(function() -- when "Place" button is clicked then show the item selection
	if not Moving then
		container.Visible = true
	end
end)

grid.MouseButton1Click:Connect(function() -- when the grid size button is clicked then change it to 0 or 0.5 or 1 or 1.5 or 2 or 2.5 (it increments then back to 0)
	gridSize += .5
	if gridSize == 3 then
		gridSize = 0
	end
	
	grid.Text = "Grid Size: "..gridSize
end)
grid.Text = "Grid Size: "..gridSize 

cancel.MouseButton1Click:Connect(StopPlacing) -- stop placing when "Cancel" button is clicked

edit.Delete.MouseButton1Down:Connect(function() -- when the delete item control button is clicked then delete the item
	if Selected then
		coroutine.wrap(function()
			remote:InvokeServer("delete",Selected.ItemId.Value)
		end)()
		
		Selected:Destroy()
		Selected = nil
		
		Assets.Control.Adornee = nil
		Assets.Select.Adornee = nil
	end
end)

edit.Move.MouseButton1Down:Connect(function() -- when the move item control button is clicked then move the item
	local item = Selected
	Mode = "Move"
	Oldpos = item:GetBoundingBox() -- sets the current position of thr item
	
	Select(nil) -- deselect the selected item if there is
	Move(item,function() -- moves it then the function gets called after moving or canceling
		Oldpos = Moving:GetBoundingBox()
		remote:InvokeServer("move",{["item"] = Moving.ItemId.Value, ["pos"] = Moving:GetBoundingBox()})
		Select(item)
	end)
end)

edit.Rotate.MouseButton1Down:Connect(function()	-- when the rotate item control button of mobile is clicked then rotate the item
	Selected:PivotTo(Selected:GetBoundingBox() * CFrame.Angles(0,math.rad(45),0))
	Rotate = true
end)

container.Close.MouseButton1Click:Connect(function() -- when the item selection's close button is clicked then hide it
	container.Visible = false
end)

local db = false
main.Lock.MouseButton1Click:Connect(function() -- lock or unlock your door
	if not db then
		db = true
		remote:InvokeServer("lock")
		locked = not locked
		main.Lock.Text = locked and 'Unlock House' or "Lock House"
		db = false
	end
end)
