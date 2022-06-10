local module = {}

local TweenService = game:GetService("TweenService")

local RenderSteppedFunctions = {}
local LockedProperties = {}
local TempUnlockedProperties = {}

local Mouse = game.Players.LocalPlayer:GetMouse()

local function GetGuiPositionFromMouse(UI)
	local pos = {X = 0, Y = 0}
	
	for i,v in pairs({"X","Y"}) do
		local startpos = UI.Parent.AbsolutePosition[v]
		local endpos = (startpos + UI.Parent.AbsoluteSize[v])
		
		pos[v] = math.clamp((Mouse[v]-startpos)/(endpos-startpos),0,1)
	end
	
	return UDim2.new(pos.X, 0, pos.Y, 0)
end

local function PropertyChanged(object, func) -- parameters passed: Propery, OldValue, newValue
	local properties = {}
	local value, tempunlocked, ok
	
	for i,v in pairs(object) do
		if type(v) ~= "function" then
			properties[i] = v
		end
	end
	
	table.insert(RenderSteppedFunctions,1,function()
		for Property ,OldValue in pairs(properties) do
			value = object[Property]
			tempunlocked = table.find(TempUnlockedProperties[object] or {}, Property)

			if value ~= OldValue or ((type(value) == "table" and type(OldValue) == "table") and #value ~= #OldValue) then
				if type(value) == "table" then
					ok = true

					for i,v in pairs(value) do
						if OldValue[i] ~= v then
							ok = false
						end
					end
					for i,v in pairs(OldValue) do
						if value[i] ~= v then
							ok = false
						end
					end
					
					if ok then return end
				end
				
				if type(value) ~= type(OldValue) or Property == "ClassName" or Property == "Parent" or (table.find(LockedProperties[object] or {}, Property) and not tempunlocked) then
					object[Property] = OldValue
					if tempunlocked then
						table.remove(TempUnlockedProperties[object], tempunlocked)
					end
					return error([[Attempt to change the property "]]..Property..[["]])
					
				else
					func(Property, properties[Property], value)
				end
				
				properties[Property] = object[Property]
			end
		end
	end)
end

local function UIListLayout(parent,padding)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = parent
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = padding
end

game:GetService("RunService").RenderStepped:Connect(function()
	for i,v in pairs(RenderSteppedFunctions) do
		v()
	end
end)

module.new = function(name)
	
	-- Instance
	
	local Base = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Frame = Instance.new("Frame")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local Frame_2 = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local Title = Instance.new("TextLabel")
	local TabButtons = Instance.new("ScrollingFrame")
	local Tabs = Instance.new("Folder")

	Base.Name = "Base"; Base.Parent = game.CoreGui; Base.ZIndexBehavior = Enum.ZIndexBehavior.Sibling	
	Main.Name = "Main"; Main.Parent = Base; Main.BackgroundColor3 = Color3.fromRGB(33, 33, 33); Main.Position = UDim2.new(0.298019797, 0, 0.316363633, 0); Main.Size = UDim2.new(0, 407, 0, 244)
	UICorner.Parent = Main
	Frame.Parent = Main; Frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65); Frame.BorderSizePixel = 0; Frame.Position = UDim2.new(0.295000017, 0, 0.109999985, 0); Frame.Size = UDim2.new(0, 1, 0, 217); Frame.ZIndex = 2
	UIAspectRatioConstraint.Parent = Main; UIAspectRatioConstraint.AspectRatio = 1.668
	Frame_2.Parent = Main; Frame_2.BackgroundColor3 = Color3.fromRGB(47, 47, 47); Frame_2.BorderSizePixel = 0; Frame_2.Position = UDim2.new(0, 0, 0.109999985, 0); Frame_2.Size = UDim2.new(0, 407, 0, 27)
	-- haroldjd2017ipad text
	TextLabel.Parent = Frame_2; TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TextLabel.BackgroundTransparency = 1.000; TextLabel.Position = UDim2.new(0, 0, 0.185185179, 0); TextLabel.Size = UDim2.new(0, 121, 0, 16); TextLabel.Font = Enum.Font.SourceSans; TextLabel.Text = "haroldjd2017ipad"; TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TextLabel.TextScaled = true; TextLabel.TextSize = 14.000; TextLabel.TextWrapped = true
	Title.Name = "Title"; Title.Parent = Main; Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1.000; Title.Position = UDim2.new(0.363636374, 0, 0, 0); Title.Size = UDim2.new(0, 110, 0, 19); Title.Font = Enum.Font.FredokaOne; Title.Text = "MM2 Hecks"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextScaled = true; Title.TextSize = 14.000; Title.TextWrapped = true
	TabButtons.Name = "TabButtons"; TabButtons.Parent = Main; TabButtons.Active = true; TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TabButtons.BackgroundTransparency = 1.000; TabButtons.Position = UDim2.new(0, 0, 0.27868852, 0); TabButtons.Size = UDim2.new(0, 120, 0, 176); TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0); TabButtons.AutomaticCanvasSize = Enum.AutomaticSize.Y

	Tabs.Name = "Tabs"
	Tabs.Parent = Main
	
	UIListLayout(TabButtons, UDim.new(0, 0))
	
	----------------------------------
	
	local UI = {
		Tabs = {},
		Name = name,
		ClassName = "GUI"
	}
	
	setmetatable(UI,{
		__index = function(table,index)
			return error("no")
		end,
	})
	
	function UI:NewTab(name)
		-- tab
		local Tab = Instance.new("ScrollingFrame")
		Tab.Name = name; Tab.Parent = Tabs; Tab.Active = true; Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Tab.BackgroundTransparency = 1.000; Tab.Position = UDim2.new(0.316953331, 0, 0.27868852, 0); Tab.Size = UDim2.new(0, 278, 0, 175); Tab.CanvasSize = UDim2.new(0, 0, 0, 0); Tab.ScrollBarThickness = 0; Tab.Visible = false; Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
		UIListLayout(Tab, UDim.new(0, 8))
		-------

		-- tab button
		local TabButton = Instance.new("TextButton")
		local Label = Instance.new("TextLabel")
		local Selected = Instance.new("Frame")

		TabButton.Name = "TabButton"; TabButton.Parent = TabButtons; TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TabButton.BackgroundTransparency = 1.000; TabButton.BorderSizePixel = 0; TabButton.Size = UDim2.new(1, 0, -0.130681813, 50); TabButton.ZIndex = 2; TabButton.Font = Enum.Font.SourceSans; TabButton.Text = ""; TabButton.TextColor3 = Color3.fromRGB(157, 157, 157); TabButton.TextSize = 14.000; TabButton.TextXAlignment = Enum.TextXAlignment.Left
		Label.Name = "Label"; Label.Parent = TabButton; Label.AnchorPoint = Vector2.new(0.5, 0.5); Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1.000; Label.Position = UDim2.new(0.558333337, 0, 0.5, 0); Label.Size = UDim2.new(0.883333325, 0, 0.600000024, 0); Label.ZIndex = 2; Label.Font = Enum.Font.SourceSans; Label.Text = "•  "..name; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextScaled = true; Label.TextSize = 14.000; Label.TextWrapped = true; Label.TextXAlignment = Enum.TextXAlignment.Left
		Selected.Name = "Selected"; Selected.Parent = TabButton; Selected.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Selected.Size = UDim2.new(1, 0, 1, 0); Selected.BackgroundTransparency = 1
		---------

		local tab = {
			Contents = {},
			Name = name,
			Selected = false,
			ClassName = "Tab"
		}
		
		LockedProperties[tab] = {"Contents"}
		
		tab.TabSelected = {}

		function tab.TabSelected:Connect(func)
			table.insert(tab.TabSelected, 1, func)
		end
		
		function tab:Delete()
			self = nil
			Tab:Destroy()
		end
		
		function tab:AddLineDivider()
			local Frame = Instance.new("Frame")
			Frame.Parent = Tab; Frame.BackgroundColor3 = Color3.fromRGB(70, 70, 70); Frame.BorderSizePixel = 0; Frame.Position = UDim2.new(0, 0, 0.365714282, 0); Frame.Size = UDim2.new(0.942446053, 0, 0, 1)
		end
		
		function tab:AddTextDivider(text)
			local TextLabel = Instance.new("TextLabel")
			TextLabel.Parent = Tab; TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TextLabel.BackgroundTransparency = 1.000; TextLabel.Position = UDim2.new(0, 0, 0.365714282, 0); TextLabel.Size = UDim2.new(0, 265, 0, 16); TextLabel.Font = Enum.Font.SourceSansBold; TextLabel.Text = text; TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TextLabel.TextScaled = true; TextLabel.TextSize = 14.000; TextLabel.TextWrapped = true
		end
		
		TabButton.MouseButton1Click:Connect(function()
			tab.Selected = true
		end)
		
		PropertyChanged(tab, function(property, OldValue, newValue)
			if property == "Name" then
				Label.Text = tab.Name
				Tab.Name = tab.Name
				
			elseif property == "Selected" then
				if tab.Selected then
					for i,v in pairs(tab.TabSelected) do
						if i ~= "Connect" then
							v()
						end
					end
					
					for i,v in pairs(UI.Tabs) do
						if v ~= tab then
							v.Selected = false
						end
					end
					
					TweenService:Create(Selected, TweenInfo.new(.1), {Transparency = 0}):Play()
					Tab.Visible = true
					
				else
					TweenService:Create(Selected, TweenInfo.new(.1), {Transparency = 1}):Play()
					Tab.Visible = false
				end
			end
		end)
		
		if #UI.Tabs == 0 then
			tab.Selected = true
		end
		
		setmetatable(tab, {
			__index = function(table, index)
				return error(index.." is not a valid member of a "..tab.ClassName)
			end,
		})
		
		local Items = {}
		
		Items.Toggle = function(label)
			if type(label) ~= "string" then
				return error("invalid arguments. arguments: label <string>")
			end

			local Toggle = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Label = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Button = Instance.new("TextButton")
			local UICorner_3 = Instance.new("UICorner")

			Toggle.Name = "Toggle"; Toggle.Parent = Tab; Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Toggle.Size = UDim2.new(0, 265, 0, 24)
			UICorner.Parent = Toggle
			Label.Name = "Label"; Label.Parent = Toggle; Label.AnchorPoint = Vector2.new(0, 0.5); Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1.000; Label.Position = UDim2.new(0.0716981143, 0, 0.5, 0); Label.Size = UDim2.new(0, 166, 0, 15); Label.Font = Enum.Font.Cartoon; Label.Text = label; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextScaled = true; Label.TextSize = 14.000; Label.TextWrapped = true; Label.TextXAlignment = Enum.TextXAlignment.Left
			Frame.Parent = Toggle; Frame.BackgroundColor3 = Color3.fromRGB(58, 58, 58); Frame.Position = UDim2.new(0.822641492, 0, 0.190476194, 0); Frame.Size = UDim2.new(0, 36, 0, 13)
			UICorner_2.Parent = Frame
			Button.Parent = Frame; Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Button.Size = UDim2.new(0.550000012, 0, 1, 0); Button.Font = Enum.Font.SourceSans; Button.Text = ""; Button.TextColor3 = Color3.fromRGB(0, 0, 0); Button.TextScaled = true; Button.TextSize = 14.000; Button.TextWrapped = true
			UICorner_3.Parent = Button
			------------------------------------

			local toggle = {
				Enabled = false,
				Label = label,
				ClassName = "Toggle",
				Parent = tab
			}

			toggle.Toggled = {}

			function toggle:Delete()
				self = nil
				Toggle:Destroy()
			end

			function toggle.Toggled:Connect(func)
				table.insert(toggle.Toggled, 1, func)
			end

			Button.MouseButton1Click:Connect(function()
				toggle.Enabled = not toggle.Enabled
			end)

			PropertyChanged(toggle, function(property, oldvalue, newvalue)
				if property == "Enabled" then
					for i,v in pairs(toggle.Toggled) do
						if i ~= "Connect" then
							v()
						end
					end

					if toggle.Enabled then
						TweenService:Create(Button, TweenInfo.new(.1), {Position = UDim2.new(.5,0,0,0), BackgroundColor3 = Color3.fromRGB(0,255,0)}):Play()
					else
						TweenService:Create(Button, TweenInfo.new(.1), {Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(255,0,0)}):Play()
					end

				elseif property == "Label" then
					Label.Text = toggle.Label
				end
			end)

			table.insert(tab.Contents, #tab.Contents+1, toggle)

			return toggle

		end

		Items.Button = function(label)
			local Button = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner",Button)
			local EffectContainer = Instance.new("ScrollingFrame",Button)

			Button.Name = "Button"; Button.Parent = Tab; Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Button.Size = UDim2.new(0, 265, 0, 21); Button.Font = Enum.Font.Cartoon; Button.Text = label; Button.TextColor3 = Color3.fromRGB(255, 255, 255); Button.TextSize = 14.000; Button.TextWrapped = true; Button.AutoButtonColor = false
			EffectContainer.Size = UDim2.new(1,0,1,0); EffectContainer.BackgroundTransparency = 1; EffectContainer.CanvasSize = UDim2.new(0,0,0,0)
			
			local btn = {
				Label = label,
				Parent = tab,
				ClassName = "Button"
			}
			
			for i,v in pairs({"MouseButton1Click","MouseButton1Down","MouseButton1Up","MouseButton2Click","MouseButton2Down","MouseButton2Up"}) do
				btn[v] = Button[v]
			end
			
			Button.MouseButton1Click:Connect(function()
				local Effect = Instance.new("Frame", EffectContainer)
				local UICorner = Instance.new("UICorner", Effect)
				
				UICorner.CornerRadius = UDim.new(1,0)
				Effect.AnchorPoint = Vector2.new(.5,.5); Effect.Position = GetGuiPositionFromMouse(Effect); Effect.BackgroundTransparency = .5; Effect.Size = UDim2.new(0,0,0,0)
				TweenService:Create(Effect, TweenInfo.new(1), {BackgroundTransparency = 1, Size = UDim2.new(0, 100, 0, 100)}):Play()
				
				wait(1)
				Effect:Destroy()
			end)
			
			Button.MouseEnter:Connect(function()
				Button.BackgroundColor3 = Color3.fromRGB(27.5, 27.5, 27.5)
			end)
			
			Button.MouseLeave:Connect(function()
				Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			end)

			function btn:Delete()
				self = nil
				btn:Destroy()
			end

			PropertyChanged(btn, function(property)
				if property == "Label" then
					Button.Text = Label
				end
			end)
			
			table.insert(tab.Contents, #tab.Contents+1, btn)

			return btn
		end
		
		Items.DropDown = function(label)
			local DropDown = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Label = Instance.new("TextLabel")
			local Selected = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local ItemSelected = Instance.new("TextLabel")
			local Button = Instance.new("TextButton")
			local ImageLabel = Instance.new("ImageLabel")
			local Selection = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")
			local UICorner_3 = Instance.new("UICorner")
			local Item = Instance.new("TextButton")

			DropDown.Name = "DropDown"; DropDown.Parent = Tab; DropDown.BackgroundColor3 = Color3.fromRGB(25, 25, 25); DropDown.Size = UDim2.new(0, 265, 0, 24); DropDown.ZIndex = 2
			UICorner.Parent = DropDown
			Label.Name = "Label"; Label.Parent = DropDown; Label.AnchorPoint = Vector2.new(0, 0.5); Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1.000; Label.Position = UDim2.new(0.0716981143, 0, 0.5, 0); Label.Size = UDim2.new(0, 143, 0, 15); Label.Font = Enum.Font.Cartoon; Label.Text = label; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextScaled = true; Label.TextSize = 14.000; Label.TextWrapped = true; Label.TextXAlignment = Enum.TextXAlignment.Left
			Selected.Name = "Selected"; Selected.Parent = DropDown; Selected.AnchorPoint = Vector2.new(0, 0.5); Selected.BackgroundColor3 = Color3.fromRGB(58, 58, 58); Selected.Position = UDim2.new(0.641509414, 0, 0.5, 0); Selected.Size = UDim2.new(0, 84, 0, 15); Selected.ZIndex = 3
			UICorner_2.Parent = Selected
			ItemSelected.Parent = Selected; ItemSelected.AnchorPoint = Vector2.new(0, 0.5); ItemSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255); ItemSelected.BackgroundTransparency = 1.000; ItemSelected.Position = UDim2.new(0.115942091, 0, 0.5, 0); ItemSelected.Size = UDim2.new(0, 47, 0, 13); ItemSelected.Font = Enum.Font.Cartoon; ItemSelected.Text = "None"; ItemSelected.TextColor3 = Color3.fromRGB(255, 255, 255); ItemSelected.TextScaled = true; ItemSelected.TextSize = 14.000; ItemSelected.TextWrapped = true; ItemSelected.TextXAlignment = Enum.TextXAlignment.Left
			Button.Parent = Selected; Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Button.BackgroundTransparency = 1.000; Button.Size = UDim2.new(1, 0, 1, 0); Button.Font = Enum.Font.SourceSans; Button.Text = ""; Button.TextColor3 = Color3.fromRGB(0, 0, 0); Button.TextSize = 14.000
			ImageLabel.Parent = Selected; ImageLabel.AnchorPoint = Vector2.new(0, 0.5); ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255); ImageLabel.BackgroundTransparency = 1.000; ImageLabel.Position = UDim2.new(0.74941206, 0, 0.550000012, 0); ImageLabel.Size = UDim2.new(0, 12, 0, 12); ImageLabel.Image = "rbxassetid://9811929304"
			Selection.Name = "Selection"; Selection.AutomaticSize = Enum.AutomaticSize.Y; Selection.Parent = DropDown; Selection.BackgroundColor3 = Color3.fromRGB(58, 58, 58); Selection.Position = UDim2.new(0.641509414, 0, 0.979166687, 0); Selection.Size = UDim2.new(0, 84, 0, 0); Selection.Visible = false; Selection.ZIndex = 2
			UIListLayout.Parent = Selection; UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout.Padding = UDim.new(0, 3)
			UICorner_3.Parent = Selection
			Item.Name = "Item"; Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Item.BackgroundTransparency = 1.000; Item.Size = UDim2.new(1, 0, 0, 12); Item.Font = Enum.Font.Cartoon; Item.Text = "Torso"; Item.TextColor3 = Color3.fromRGB(255, 255, 255); Item.TextScaled = true; Item.TextSize = 14.000; Item.TextWrapped = true
			--------------------------------------------
			
			local dropdown = {
				ClassName = "DropDown",
				Parent = tab,
				Label = label,
				Options = {},
				SelectedItem = "None",
			}
			
			LockedProperties[dropdown] = {"Selections"}
			
			dropdown.SelectedItemChanged = {}
			
			Button.MouseButton1Click:Connect(function()
				Selection.Visible = not Selection.Visible
			end)
			
			function dropdown.SelectedItemChanged:Connect(func)
				table.insert(dropdown.SelectedItemChanged,1,func)
			end
			
			PropertyChanged(dropdown, function(property, oldvalue)
				if property == "SelectedItem" then
					for i,v in pairs(dropdown.SelectedItemChanged) do
						if i ~= "Connect" then
							v()
						end
					end
					
					ItemSelected.Text = dropdown.SelectedItem
					
				elseif property == "Label" then
					Label.Text = dropdown.Label
				end
			end)
			
			function dropdown:Delete()
				DropDown:Destroy()
				dropdown = nil
			end
			
			function dropdown:AddOption(item)
				table.insert(dropdown.Options, #dropdown.Options+1, tostring(item))
				
				local newitem = Item:Clone()
				newitem.Parent = Selection
				newitem.Text = tostring(item)
				
				newitem.MouseButton1Click:Connect(function()
					dropdown.SelectedItem = newitem.Text
					Selection.Visible = false
				end)
			end
			
			function dropdown:RemoveOption(item)
				table.remove(dropdown.Options, table.find(dropdown.Options, item))
				
				if dropdown.SelectedItem == item then
					dropdown.SelectedItem = "None"
				end
				
				for i,v in pairs(Selection:GetChildren()) do
					if v.ClassName == "TextButton" then
						if v.Text == item then
							v:Destroy()
						end
					end
				end
			end
			
			table.insert(tab.Contents, #tab.Contents+1, dropdown)
			
			return dropdown
		end
		
		Items.Slider = function(label, MaxValue, MinValue, DefaultValue)
			local Slider = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Label = Instance.new("TextLabel")
			local Track = Instance.new("Frame")
			local SliderButton = Instance.new("TextButton")
			local UICorner_2 = Instance.new("UICorner")

			Slider.Name = "Slider"; Slider.Parent = Tab; Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Slider.Size = UDim2.new(0, 265, 0, 24)
			UICorner.Parent = Slider
			Label.Name = "Label"; Label.Parent = Slider; Label.AnchorPoint = Vector2.new(0, 0.5); Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1.000; Label.Position = UDim2.new(0.0716981143, 0, 0.5, 0); Label.Size = UDim2.new(0, 94, 0, 15); Label.Font = Enum.Font.Cartoon; Label.Text = label..": "..(DefaultValue and DefaultValue or (MinValue and MinValue or 0)); Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextScaled = true; Label.TextSize = 14.000; Label.TextWrapped = true; Label.TextXAlignment = Enum.TextXAlignment.Left
			Track.Name = "Track"; Track.Parent = Slider; Track.AnchorPoint = Vector2.new(0, 0.5); Track.BackgroundColor3 = Color3.fromRGB(62, 62, 62); Track.BorderSizePixel = 0; Track.Position = UDim2.new(0.449056596, 0, 0.5, 0); Track.Size = UDim2.new(0, 135, 0, 1)
			SliderButton.Name = "SliderButton"; SliderButton.Parent = Track; SliderButton.AnchorPoint = Vector2.new(0.5, 0.5); SliderButton.BackgroundColor3 = Color3.fromRGB(85, 255, 0); SliderButton.Position = UDim2.new(0, 0, 0.5, 0); SliderButton.Size = UDim2.new(0, 10, 0, 10); SliderButton.Font = Enum.Font.SourceSans; SliderButton.Text = ""; SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0); SliderButton.TextSize = 14.000
			UICorner_2.CornerRadius = UDim.new(1, 0); UICorner_2.Parent = SliderButton
			--------------------------
			
			local slider = {
				ClassName = "Slider",
				Parent = tab,
				Value = (DefaultValue and DefaultValue or 0),
				MinValue = (MinValue and MinValue or 0),
				MaxValue = (MaxValue and MaxValue or 0)
			}
			
			slider.ValueChanged = {}
			
			function slider.ValueChanged:Connect(func)
				table.insert(slider.ValueChanged, 1, func)
			end
			
			function slider:Delete()
				Slider:Destroy()
				slider = nil
			end
			
			local startpos = Track.AbsolutePosition.X
			local holding = false
			local mousepos, progress

			SliderButton.MouseButton1Down:Connect(function()
				holding = true
			end)

			game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					holding = false
				end
			end)
			
			table.insert(RenderSteppedFunctions, 1, function()
				if holding then
					mousepos =  game.Players.LocalPlayer:GetMouse().X
					progress = math.clamp((mousepos-startpos)/((startpos + Track.AbsoluteSize.X)-startpos), 0, 1)*100 -- with + operator is endpos

					slider.Value = slider.MinValue+(progress*(slider.MaxValue-slider.MinValue)/100)
					--SliderButton.Position = UDim2.new(progress, 0, .5, 0)
				end
			end)
			
			PropertyChanged(slider, function(property)
				if property == "Value" then
					Label.Text = label..": "..math.round(slider.Value)
					slider.Value = math.clamp(slider.Value, slider.MinValue, slider.MaxValue)
					SliderButton.Position = UDim2.new((slider.Value-slider.MinValue)/(slider.MaxValue-slider.MinValue),0, .5, 0)
					
					for i,v in pairs(slider.ValueChanged) do
						if i ~= "Connect" then
							v()
						end
					end
				end
			end)
			
			return slider
		end
		
		Items.TextBox = function(label, PlaceholderText)
			local TextBox = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Label = Instance.new("TextLabel")
			local TextBox_2 = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")

			TextBox.Name = "TextBox"; TextBox.Parent = Tab; TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25); TextBox.Size = UDim2.new(0, 265, 0, 24)
			UICorner.Parent = TextBox
			Label.Name = "Label"; Label.Parent = TextBox; Label.AnchorPoint = Vector2.new(0, 0.5); Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1.000; Label.Position = UDim2.new(0.0716981143, 0, 0.5, 0); Label.Size = UDim2.new(0, 118, 0, 15); Label.Font = Enum.Font.Cartoon; Label.Text = label; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextScaled = true; Label.TextSize = 14.000; Label.TextWrapped = true; Label.TextXAlignment = Enum.TextXAlignment.Left
			TextBox_2.Parent = TextBox; TextBox_2.AnchorPoint = Vector2.new(0, 0.5); TextBox_2.BackgroundColor3 = Color3.fromRGB(58, 58, 58); TextBox_2.BorderSizePixel = 0; TextBox_2.Position = UDim2.new(0.516981125, 0, 0.5, 0); TextBox_2.Size = UDim2.new(0, 117, 0, 15); TextBox_2.Font = Enum.Font.Cartoon; TextBox_2.Text = ""; TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255); TextBox_2.TextScaled = true; TextBox_2.TextSize = 14.000; TextBox_2.TextWrapped = true; TextBox_2.PlaceholderText = PlaceholderText or ""
			UICorner_2.Parent = TextBox_2
			------------------------
			
			local textbox = {
				ClassName = "TextBox",
				Parent = tab,
				Label = "",
				PlaceholderText = (PlaceholderText or "")
			}
			
			textbox.EnterKeyPressed = {}
			textbox.TextChanged = TextBox_2:GetPropertyChangedSignal("Text")
			
			for i,v in pairs({"Focused", "FocusLost"}) do
				textbox[v] = TextBox_2[v]
			end
			
			function textbox:Delete()
				TextBox:Destroy()
				textbox = nil
			end
			
			function textbox.EnterKeyPressed:Connect(func)
				table.insert(textbox.EnterKeyPressed, 1, func)
			end
			
			TextBox_2.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.Return then
					for i,v in pairs(textbox.EnterKeyPressed) do
						if i ~= "Connect" then
							v()
						end
					end
				end
			end)
			
			PropertyChanged(textbox, function(property)
				if property == "Label" then
					Label.Text = textbox.Label
				elseif property == "PlaceholderText" then
					TextBox_2.PlaceholderText = textbox.PlaceholderText
				end
			end)
			
			return textbox
		end
		
		function tab:AddItem(item,arg1,arg2,arg3,arg4,arg5)
			if Items[item] then
				if arg1 == nil then return error("Missing argument 1: label") end
				
				local item = Items[item](arg1,arg2,arg3,arg4,arg5)
				setmetatable(item, {
					__index = function(table, index)
						return error(index.." is not a valid property of a "..item.ClassName)
					end,
				})
				
				return item
			else
				return error(tostring(item).." is not a valid item")
			end
		end
		
		table.insert(UI.Tabs, #UI.Tabs+1, tab)
		
		return tab

	end
	
	return UI
end

return module
