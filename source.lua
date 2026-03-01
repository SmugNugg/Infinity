--[[
	 ______ _____ _   _ _____ _________     __
	|  ____|_   _| \ | |_   _|__   __\ \   / /
	| |__    | | |  \| | | |    | |   \ \_/ / 
	|  __|   | | | . ` | | |    | |    \   /  
	| |     _| |_| |\  |_| |_   | |     | |   
	|_|    |_____|_| \_|_____|  |_|     |_|   
	
	Source:
		https://d3to-finity.000webhostapp.com/files/source-0.1.2.txt
	Version:
	 0.1.5
	Date: 
		April 21th, 2020
	Author: 
		detourious @ v3rmillion.netf
					
--]]


local finity = {}
finity.gs = {}

-- Config System
finity.config = {}
finity.config.data = {}
finity.config.saveName = "FinityConfig"

function finity.config:Save()
	local HttpService = finity.gs["HttpService"]
	if not HttpService then return end
	
	local success, encoded = pcall(function()
		return HttpService:JSONEncode(self.data)
	end)
	
	if success and encoded then
		-- Use writefile if available (executor-specific)
		if writefile then
			local success2, err = pcall(function()
				writefile(self.saveName .. ".json", encoded)
			end)
			if not success2 then
				warn("Config save error:", err)
			end
		else
			-- Fallback: Store in player data
			local player = finity.gs["Players"].LocalPlayer
			if player then
				local success3, err = pcall(function()
					-- Try to save to player's data
					if player:FindFirstChild("FinityConfig") then
						player.FinityConfig:Destroy()
					end
					local stringValue = Instance.new("StringValue")
					stringValue.Name = "FinityConfig"
					stringValue.Value = encoded
					stringValue.Parent = player
				end)
				if not success3 then
					warn("Config save error:", err)
				end
			end
		end
	end
end

function finity.config:Load()
	local HttpService = finity.gs["HttpService"]
	if not HttpService then return {} end
	
	local data = {}
	
	-- Try to load from file
	if readfile then
		local success, fileData = pcall(function()
			return readfile(self.saveName .. ".json")
		end)
		if success and fileData then
			local success2, decoded = pcall(function()
				return HttpService:JSONDecode(fileData)
			end)
			if success2 and decoded then
				data = decoded
			end
		end
	else
		-- Fallback: Load from player data
		local player = finity.gs["Players"].LocalPlayer
		if player and player:FindFirstChild("FinityConfig") then
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(player.FinityConfig.Value)
			end)
			if success and decoded then
				data = decoded
			end
		end
	end
	
	self.data = data
	return data
end

function finity.config:Get(key, default)
	return self.data[key] or default
end

function finity.config:Set(key, value)
	self.data[key] = value
	self:Save()
end

-- Global Keybind Manager
finity.keybinds = {}
finity.keybinds.binds = {}
finity.keybinds.connections = {}

function finity.keybinds:Register(key, callback, name)
	if not key or not callback then return end
	
	local bindId = name or tostring(key)
	
	-- Remove existing bind if present
	if self.binds[bindId] then
		self:Unregister(bindId)
	end
	
	self.binds[bindId] = {
		key = key,
		callback = callback,
		name = bindId
	}
	
	local connection = finity.gs["UserInputService"].InputBegan:Connect(function(Input, Processed)
		if not Processed and Input.KeyCode == key then
			local success, err = pcall(callback, Input)
			if not success then
				warn("Keybind error (" .. bindId .. "):", err)
			end
		end
	end)
	
	self.connections[bindId] = connection
	return bindId
end

function finity.keybinds:Unregister(bindId)
	if self.connections[bindId] then
		self.connections[bindId]:Disconnect()
		self.connections[bindId] = nil
	end
	self.binds[bindId] = nil
end

function finity.keybinds:Clear()
	for bindId, _ in pairs(self.connections) do
		self:Unregister(bindId)
	end
end

 finity.theme = { -- light
	main_container = Color3.fromRGB(249, 249, 255),
	separator_color = Color3.fromRGB(223, 219, 228),

	text_color = Color3.fromRGB(96, 96, 96),

	category_button_background = Color3.fromRGB(223, 219, 228),
	category_button_border = Color3.fromRGB(200, 196, 204),

	checkbox_checked = Color3.fromRGB(114, 214, 112),
	checkbox_outer = Color3.fromRGB(198, 189, 202),
	checkbox_inner = Color3.fromRGB(249, 239, 255),

	slider_color = Color3.fromRGB(114, 214, 112),
	slider_color_sliding = Color3.fromRGB(114, 214, 112),
	slider_background = Color3.fromRGB(198, 188, 202),
	slider_text = Color3.fromRGB(112, 112, 112),

	textbox_background = Color3.fromRGB(198, 189, 202),
	textbox_background_hover = Color3.fromRGB(215, 206, 227),
	textbox_text = Color3.fromRGB(112, 112, 112),
	textbox_text_hover = Color3.fromRGB(50, 50, 50),
	textbox_placeholder = Color3.fromRGB(178, 178, 178),

	dropdown_background = Color3.fromRGB(198, 189, 202),
	dropdown_text = Color3.fromRGB(112, 112, 112),
	dropdown_text_hover = Color3.fromRGB(50, 50, 50),
	dropdown_scrollbar_color = Color3.fromRGB(198, 189, 202),
	
	button_background = Color3.fromRGB(198, 189, 202),
	button_background_hover = Color3.fromRGB(215, 206, 227),
	button_background_down = Color3.fromRGB(178, 169, 182),
	
	scrollbar_color = Color3.fromRGB(198, 189, 202),
}

finity.dark_theme = { -- dark
	main_container = Color3.fromRGB(32, 32, 33),
	separator_color = Color3.fromRGB(63, 63, 65),

	text_color = Color3.fromRGB(206, 206, 206),

	category_button_background = Color3.fromRGB(63, 62, 65),
	category_button_border = Color3.fromRGB(72, 71, 74),

	checkbox_checked = Color3.fromRGB(132, 255, 130),
	checkbox_outer = Color3.fromRGB(84, 81, 86),
	checkbox_inner = Color3.fromRGB(132, 132, 136),

	slider_color = Color3.fromRGB(177, 177, 177),
	slider_color_sliding = Color3.fromRGB(132, 255, 130),
	slider_background = Color3.fromRGB(88, 84, 90),
	slider_text = Color3.fromRGB(177, 177, 177),

	textbox_background = Color3.fromRGB(103, 103, 106),
	textbox_background_hover = Color3.fromRGB(137, 137, 141),
	textbox_text = Color3.fromRGB(195, 195, 195),
	textbox_text_hover = Color3.fromRGB(232, 232, 232),
	textbox_placeholder = Color3.fromRGB(135, 135, 138),

	dropdown_background = Color3.fromRGB(88, 88, 91),
	dropdown_text = Color3.fromRGB(195, 195, 195),
	dropdown_text_hover = Color3.fromRGB(232, 232, 232),
	dropdown_scrollbar_color = Color3.fromRGB(118, 118, 121),
	
	button_background = Color3.fromRGB(103, 103, 106),
	button_background_hover = Color3.fromRGB(137, 137, 141),
	button_background_down = Color3.fromRGB(70, 70, 81),
	
	scrollbar_color = Color3.fromRGB(118, 118, 121),
}

setmetatable(finity.gs, {
	__index = function(_, service)
		return game:GetService(service)
	end,
	__newindex = function(t, i)
		t[i] = nil
		return
	end
})


local mouse = finity.gs["Players"].LocalPlayer:GetMouse()

function finity:Create(class, properties)
	local object = Instance.new(class)

	for prop, val in next, properties do
		if object[prop] and prop ~= "Parent" then
			object[prop] = val
		end
	end

	return object
end

function finity:addShadow(object, transparency)
	local shadow = self:Create("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 6, 1, 6),
		Image = "rbxassetid://1316045217",
		ImageTransparency = transparency and true or 0.5,
		ImageColor3 = Color3.fromRGB(35, 35, 35),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118)
	})

	shadow.Parent = object
end

function finity.new(isdark, gprojectName, thinProject)
	local finityObject = {}
	local self2 = finityObject
	local self = finity

	if not finity.gs["RunService"]:IsStudio() and self.gs["CoreGui"]:FindFirstChild("FinityUI") then
		self.gs["CoreGui"]:FindFirstChild("FinityUI"):Destroy()
		warn("finity:", "instance already exists in coregui!")
		task.wait(.1)
	end

	local theme = finity.theme
	local projectName = false
	local thinMenu = false
	
	if isdark == true then theme = finity.dark_theme end
	if gprojectName then projectName = gprojectName end
	if thinProject then thinMenu = thinProject end
	
	local toggled = true
	local typing = false
	local firstCategory = true
    local savedposition = UDim2.new(0.5, 0, 0.5, 0)
    

	local finityData
	finityData = {
		UpConnection = nil,
		ToggleKey = Enum.KeyCode.Home,
	}

	self2.ChangeToggleKey = function(NewKey)
		finityData.ToggleKey = NewKey
		
		if not projectName then
			self2.tip.Text = "Press '".. string.sub(tostring(NewKey), 14) .."' to hide this menu"
		end
		
		if finityData.UpConnection then
			finityData.UpConnection:Disconnect()
		end

		finityData.UpConnection = finity.gs["UserInputService"].InputEnded:Connect(function(Input)
			if Input.KeyCode == finityData.ToggleKey and not typing then
                toggled = not toggled

                pcall(function() self2.modal.Modal = toggled end)

                if toggled then
					pcall(self2.container.TweenPosition, self2.container, savedposition, "Out", "Sine", 0.5, true)
                else
                    savedposition = self2.container.Position;
					pcall(self2.container.TweenPosition, self2.container, UDim2.new(savedposition.Width.Scale, savedposition.Width.Offset, 1.5, 0), "Out", "Sine", 0.5, true)
				end
			end
		end)
	end
	
	self2.ChangeBackgroundImage = function(ImageID, Transparency)
		self2.container.Image = ImageID
		
		if Transparency then
			self2.container.ImageTransparency = Transparency
		else
			self2.container.ImageTransparency = 0.8
		end
	end

	finityData.UpConnection = finity.gs["UserInputService"].InputEnded:Connect(function(Input)
		if Input.KeyCode == finityData.ToggleKey and not typing then
			toggled = not toggled

			if toggled then
				self2.container:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Sine", 0.5, true)
			else
				self2.container:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), "Out", "Sine", 0.5, true)
			end
		end
	end)

	self2.userinterface = self:Create("ScreenGui", {
		Name = "FinityUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
	})

	self2.container = self:Create("ImageLabel", {
		Draggable = true,
		Active = true,
		Name = "Container",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.main_container,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 800, 0, 500),
		ZIndex = 2,
		ImageTransparency = 1
    })
    
    self2.modal = self:Create("TextButton", {
        Text = "";
        Transparency = 1;
        Modal = true;
    }) self2.modal.Parent = self2.userinterface;
	
	if thinProject and typeof(thinProject) == "UDim2" then
		self2.container.Size = thinProject
	end

	-- Smooth dragging system
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	local topbarDrag = finity:Create("TextButton", {
		Name = "DragHandle",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 10,
		Text = "",
		Active = true
	})
	
	topbarDrag.MouseButton1Down:Connect(function()
		dragging = true
		dragStart = Vector2.new(mouse.X, mouse.Y)
		startPos = self2.container.Position
	end)
	
	local moveConnection
	moveConnection = mouse.Move:Connect(function()
		if dragging and dragStart and startPos then
			local deltaX = mouse.X - dragStart.X
			local deltaY = mouse.Y - dragStart.Y
			local newX = startPos.X.Offset + deltaX
			local newY = startPos.Y.Offset + deltaY
			
			-- Smooth position update
			self2.container.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
		end
	end)
	
	finity.gs["UserInputService"].InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if dragging then
				dragging = false
				dragStart = nil
				startPos = nil
			end
		end
	end)

	self2.sidebar = self:Create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = theme.main_container,
		BackgroundTransparency = 1,
		BorderColor3 = theme.separator_color,
		Size = UDim2.new(0, 120, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		ZIndex = 2,
	})

	self2.categories = self:Create("Frame", {
		Name = "Categories",
		BackgroundColor3 = theme.main_container,
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderColor3 = theme.separator_color,
		Size = UDim2.new(1, -120, 1, -30),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 30),
		ZIndex = 2,
	})
	self2.categories.ClipsDescendants = true

	self2.topbar = self:Create("Frame", {
		Name = "Topbar",
		ZIndex = 2,
		Size = UDim2.new(1,0,0,30),
		BackgroundTransparency = 2
	})

	self2.tip = self:Create("TextLabel", {
		Name = "TopbarTip",
		ZIndex = 2,
		Size = UDim2.new(1, -30, 0, 30),
		Position = UDim2.new(0, 30, 0, 0),
		Text = "Press '".. string.sub(tostring(self.ToggleKey), 14) .."' to hide this menu",
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		TextColor3 = theme.text_color,
	})
	
	if projectName then
		self2.tip.Text = projectName
	else
		self2.tip.Text = "Press '".. string.sub(tostring(self.ToggleKey), 14) .."' to hide this menu"
	end
    
    function finity.settitle(text)
        self2.tip.Text = tostring(text)
    end

	local separator = self:Create("Frame", {
		Name = "Separator",
		BackgroundColor3 = theme.separator_color,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 118, 0, 30),
		Size = UDim2.new(0, 1, 1, -30),
		ZIndex = 6,
	})
	separator.Parent = self2.container
	separator = nil

	local separator = self:Create("Frame", {
		Name = "Separator",
		BackgroundColor3 = theme.separator_color,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 30),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 6,
	})
	separator.Parent = self2.container
	separator = nil

	local uipagelayout = self:Create("UIPageLayout", {
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Vertical,
		TweenTime = 0.7,
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.InOut,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	uipagelayout.Parent = self2.categories
	uipagelayout = nil

	local uipadding = self:Create("UIPadding", {
		PaddingTop = UDim.new(0, 3),
		PaddingLeft = UDim.new(0, 2)
	})
	uipadding.Parent = self2.sidebar
	uipadding = nil

	local uilistlayout = self:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	uilistlayout.Parent = self2.sidebar
	uilistlayout = nil

	function self2:Category(name)
		local category = {}
		
		category.button = finity:Create("TextButton", {
			Name = name,
			BackgroundColor3 = theme.category_button_background,
			BackgroundTransparency = 1,
			BorderMode = Enum.BorderMode.Inset,
			BorderColor3 = theme.category_button_border,
			Size = UDim2.new(1, -4, 0, 25),
			ZIndex = 2,
			AutoButtonColor = false,
			Font = Enum.Font.GothamSemibold,
			Text = name,
			TextColor3 = theme.text_color,
			TextSize = 14
		})

		category.container = finity:Create("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 2,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarImageColor3 = theme.scrollbar_color or Color3.fromRGB(118, 118, 121),
			BottomImage = "rbxassetid://967852042",
			MidImage = "rbxassetid://967852042",
			TopImage = "rbxassetid://967852042",
			ScrollBarImageTransparency = 1 --
		})

		category.hider = finity:Create("Frame", {
			Name = "Hider",
			BackgroundTransparency = 0, --
			BorderSizePixel = 0,
			BackgroundColor3 = theme.main_container,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 5
		})

		category.L = finity:Create("Frame", {
			Name = "L",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 3),
			Size = UDim2.new(0.5, -20, 1, -3),
			ZIndex = 2
		})
		
		if not thinProject then
			category.R = finity:Create("Frame", {
				Name = "R",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0, 3),
				Size = UDim2.new(0.5, -20, 1, -3),
				ZIndex = 2
			})
		end
		
		if thinProject then
			category.L.Size = UDim2.new(1, -20, 1, -3)
		end
		
		if firstCategory then
			finity.gs["TweenService"]:Create(category.hider, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			finity.gs["TweenService"]:Create(category.container, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()
		end
		
		do
			local uilistlayout = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})
	
			local uilistlayout2 = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			local function computeSizeChange()
				local largestListSize = 0
				
				largestListSize = uilistlayout.AbsoluteContentSize.Y
				
				if uilistlayout2.AbsoluteContentSize.Y > largestListSize then
					largestListSize = largestListSize
				end
				
				category.container.CanvasSize = UDim2.new(0, 0, 0, largestListSize + 5)
			end
			
			uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(computeSizeChange)
			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(computeSizeChange)
			
			uilistlayout.Parent = category.L
			uilistlayout2.Parent = category.R
		end
		
		category.button.MouseEnter:Connect(function()
			finity.gs["TweenService"]:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
		end)
		category.button.MouseLeave:Connect(function()
			finity.gs["TweenService"]:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end)
		category.button.MouseButton1Down:Connect(function()
			for _, categoryf in next, self2.userinterface["Container"]["Categories"]:GetChildren() do
				if categoryf:IsA("ScrollingFrame") then
					if categoryf ~= category.container then
						finity.gs["TweenService"]:Create(categoryf.Hider, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
						finity.gs["TweenService"]:Create(categoryf, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
					end
				end
			end

			finity.gs["TweenService"]:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			finity.gs["TweenService"]:Create(category.hider, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			finity.gs["TweenService"]:Create(category.container, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()

			self2.categories["UIPageLayout"]:JumpTo(category.container)
		end)
		category.button.MouseButton1Up:Connect(function()
			finity.gs["TweenService"]:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end)

		category.container.Parent = self2.categories
		category.button.Parent = self2.sidebar
		
		if not thinProject then
			category.R.Parent = category.container
		end
		
		category.L.Parent = category.container
		category.hider.Parent = category.container

		local function calculateSector()
			if thinProject then
				return "L"
			end
			
			local R = #category.R:GetChildren() - 1
			local L = #category.L:GetChildren() - 1

			if L > R then
				return "R"
			else
				return "L"
			end
		end

		function category:Sector(name)
			local sector = {}

			sector.frame = finity:Create("Frame", {
				Name = name,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25),
				ZIndex = 2
			})

			sector.container = finity:Create("Frame", {
				Name = "Container",
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 22),
				Size = UDim2.new(1, -5, 1, -30),
				ZIndex = 2
			})

			sector.title = finity:Create("TextLabel", {
				Name = "Title",
				Text = name,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -5, 0, 25),
				ZIndex = 2,
				Font = Enum.Font.GothamSemibold,
				TextColor3 = theme.text_color,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local uilistlayout = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

            uilistlayout.Changed:Connect(function()
                pcall(function()
                    sector.frame.Size = UDim2.new(1, 0, 0, sector.container["UIListLayout"].AbsoluteContentSize.Y + 25)
                    sector.container.Size = UDim2.new(1, 0, 0, sector.container["UIListLayout"].AbsoluteContentSize.Y)
                end)
			end)
			uilistlayout.Parent = sector.container
			uilistlayout = nil

			function sector:Cheat(kind, name, callback, data)
				local cheat = {}
				cheat.value = nil

				cheat.frame = finity:Create("Frame", {
					Name = name,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25),
					ZIndex = 2,
				})

				cheat.label = finity:Create("TextLabel", {
					Name = "Title",
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 2,
					Font = Enum.Font.Gotham,
					TextColor3 = theme.text_color,
					TextSize = 13,
					Text = name,
					TextXAlignment = Enum.TextXAlignment.Left
				})

                function cheat:SetLabel(text)
                    local Text = tostring(text) or tostring("Hello World!")
                    cheat.label.Text = Text
                end

				cheat.container	= finity:Create("Frame", {
					Name = "Container",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 150, 0, 22),
					ZIndex = 2,
				})
				
				if kind then
					if string.lower(kind) == "checkbox" or string.lower(kind) == "toggle" then
						if data then
							if data.enabled then
								cheat.value = true
							end
						end

						-- Toggle function that can be called by keybind
						local function toggleCheckbox()
							cheat.value = not cheat.value

							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn("error: ".. e) end
							end

							if cheat.value then
								finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							else
								finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
							end
						end

						-- Check if keybind is provided
						local keybindData = {key = data and data.keybind or nil}
						local keybindConnection = nil
						
						-- Adjust container size if keybind exists
						if keybindData.key then
							cheat.container.Size = UDim2.new(0, 180, 0, 22)
						end

						-- Create interactive keybind button if keybind is provided
						if keybindData.key then
							local waitingForInput = false
							
							cheat.keybindBtn = finity:Create("ImageButton", {
								Name = "KeybindButton",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundColor3 = Color3.new(1, 1, 1),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -30, 0.5, 0),
								Size = UDim2.new(0, 25, 0, 20),
								ZIndex = 2,
								Image = "rbxassetid://3570695787",
								ImageColor3 = theme.button_background,
								ImageTransparency = 0.5,
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = Rect.new(100, 100, 100, 100),
								SliceScale = 0.02
							})

							local function updateKeybindText()
								if waitingForInput then
									cheat.keybindText.Text = "..."
								elseif keybindData.key then
									cheat.keybindText.Text = tostring(keybindData.key.Name)
								else
									cheat.keybindText.Text = "None"
								end
							end

							cheat.keybindText = finity:Create("TextLabel", {
								Name = "KeybindText",
								BackgroundColor3 = Color3.new(1, 1, 1),
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 3,
								Font = Enum.Font.Gotham,
								Text = tostring(keybindData.key.Name),
								TextColor3 = theme.textbox_text,
								TextSize = 11,
								TextXAlignment = Enum.TextXAlignment.Center
							})

							updateKeybindText()

							-- Setup keybind listener for toggling checkbox
							local function setupKeybindListener()
								if keybindConnection then
									if typeof(keybindConnection) == "RBXScriptConnection" then
										keybindConnection:Disconnect()
									elseif keybindConnection == true and finity.gs["ContextActionService"] and keybindData.key then
										-- ContextActionService was used, unbind it
										finity.gs["ContextActionService"]:UnbindAction("FinityKeybind_" .. tostring(keybindData.key))
									end
									keybindConnection = nil
								end
								
								if keybindData.key and not waitingForInput then
									local lastPressedTime = 0
									
									-- Use ContextActionService with high priority to override game keybinds
									if finity.gs["ContextActionService"] then
										local actionName = "FinityKeybind_" .. tostring(keybindData.key)
										-- Bind with high priority (2000) to override game actions
										finity.gs["ContextActionService"]:BindActionAtPriority(actionName, function(actionName, inputState, inputObject)
											if waitingForInput then return Enum.ContextActionResult.Pass end
											
											-- Check if chat is open
											local chatBox = finity.gs["UserInputService"]:GetFocusedTextBox()
											if chatBox then return Enum.ContextActionResult.Pass end
											
											if inputState == Enum.UserInputState.Begin then
												local currentTime = tick()
												if currentTime - lastPressedTime > 0.15 then
													lastPressedTime = currentTime
													toggleCheckbox()
													-- Sink the input to prevent game from processing it
													return Enum.ContextActionResult.Sink
												end
											end
											return Enum.ContextActionResult.Pass
										end, false, Enum.ContextActionPriority.High.Value, keybindData.key)
										keybindConnection = true -- Mark as connected
									else
										-- Fallback: Use InputBegan with immediate connection
										local lastPressed = false
										keybindConnection = finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
											if waitingForInput then return end
											
											local chatBox = finity.gs["UserInputService"]:GetFocusedTextBox()
											if chatBox then return end
											
											-- Don't check Process - capture ALL key presses
											if Input.KeyCode == keybindData.key then
												local currentTime = tick()
												if currentTime - lastPressedTime > 0.15 then
													lastPressedTime = currentTime
													toggleCheckbox()
												end
											end
										end)
									end
								end
							end

							setupKeybindListener()

							-- Make keybind button interactive (using ImageButton directly)
							cheat.keybindBtn.MouseEnter:Connect(function()
								if not waitingForInput then
									finity.gs["TweenService"]:Create(cheat.keybindBtn, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
								end
							end)

							cheat.keybindBtn.MouseLeave:Connect(function()
								if not waitingForInput then
									finity.gs["TweenService"]:Create(cheat.keybindBtn, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
								end
							end)

							cheat.keybindBtn.MouseButton1Down:Connect(function()
								if not waitingForInput then
									finity.gs["TweenService"]:Create(cheat.keybindBtn, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
								end
							end)

							cheat.keybindBtn.MouseButton1Up:Connect(function()
								if waitingForInput then return end
								
								finity.gs["TweenService"]:Create(cheat.keybindBtn, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
								
								-- Disable keybind listener while waiting for input
								if keybindConnection then
									if typeof(keybindConnection) == "RBXScriptConnection" then
										keybindConnection:Disconnect()
									elseif finity.gs["ContextActionService"] and keybindData.key then
										finity.gs["ContextActionService"]:UnbindAction("FinityKeybind_" .. tostring(keybindData.key))
									end
									keybindConnection = nil
								end
								
								-- Start waiting for keybind
								waitingForInput = true
								updateKeybindText()
								
								local inputConnection
								inputConnection = finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
									if Process then return end
									
									if Input.UserInputType == Enum.UserInputType.Keyboard then
										if Input.KeyCode ~= finityData.ToggleKey and Input.KeyCode ~= Enum.KeyCode.Backspace then
											keybindData.key = Input.KeyCode
											waitingForInput = false
											updateKeybindText()
											setupKeybindListener()
											
											inputConnection:Disconnect()
											inputConnection = nil
										elseif Input.KeyCode == Enum.KeyCode.Backspace then
											keybindData.key = nil
											waitingForInput = false
											updateKeybindText()
											
											if keybindConnection then
												if typeof(keybindConnection) == "RBXScriptConnection" then
													keybindConnection:Disconnect()
												elseif keybindConnection == true and finity.gs["ContextActionService"] and keybindData.key then
													finity.gs["ContextActionService"]:UnbindAction("FinityKeybind_" .. tostring(keybindData.key))
												end
												keybindConnection = nil
											end
											
											inputConnection:Disconnect()
											inputConnection = nil
										end
									end
								end)
							end)

							cheat.keybindBtn.MouseButton2Up:Connect(function()
								if waitingForInput then return end
								
								-- Right click to clear
								keybindData.key = nil
								updateKeybindText()
								
								if keybindConnection then
									if typeof(keybindConnection) == "RBXScriptConnection" then
										keybindConnection:Disconnect()
									elseif finity.gs["ContextActionService"] and keybindData.key then
										finity.gs["ContextActionService"]:UnbindAction("FinityKeybind_" .. tostring(keybindData.key))
									end
									keybindConnection = nil
								end
							end)

							cheat.keybindText.Parent = cheat.keybindBtn
							cheat.keybindBtn.Parent = cheat.container

							-- Method to change keybind programmatically
							function cheat:SetKeybind(key)
								keybindData.key = key
								updateKeybindText()
								setupKeybindListener()
							end
						end

						cheat.checkbox = finity:Create("Frame", {
							Name = "Checkbox",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0, 0),
							Size = UDim2.new(0, 25, 0, 25),
							ZIndex = 2,
						})

						cheat.outerbox = finity:Create("ImageLabel", {
							Name = "Outer",
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(0, 20, 0, 20),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.checkbox_outer,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.06,
						})

						cheat.checkboxbutton = finity:Create("ImageButton", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Name = "CheckboxButton",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 14, 0, 14),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.checkbox_inner,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.04
						})

						if data then
							if data.enabled then
								finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							end
						end

						cheat.checkboxbutton.MouseEnter:Connect(function()
							local lightertheme = Color3.fromRGB((theme.checkbox_outer.R * 255) + 20, (theme.checkbox_outer.G * 255) + 20, (theme.checkbox_outer.B * 255) + 20)
							finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = lightertheme}):Play()
						end)
						cheat.checkboxbutton.MouseLeave:Connect(function()
							if not cheat.value then
								finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
							else
								finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							end
						end)
						cheat.checkboxbutton.MouseButton1Down:Connect(function()
							if cheat.value then
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
							else
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							end
						end)
						cheat.checkboxbutton.MouseButton1Up:Connect(function()
							toggleCheckbox()
						end)

						cheat.checkboxbutton.Parent = cheat.outerbox
                        cheat.outerbox.Parent = cheat.container
                    elseif string.lower(kind) == "color" or string.lower(kind) == "colorpicker" then
                        cheat.value = Color3.new(1, 1, 1);

						if data then
							if data.color then
								cheat.value = data.color
							end
                        end
                        
                        local hsvimage = "rbxassetid://4613607014"
                        local lumienceimage = "rbxassetid://4613627894"
                        
                        cheat.hsvbar = finity:Create("ImageButton", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Name = "HSVBar",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 6),
							ZIndex = 2,
                            Image = hsvimage
                        })

                        cheat.arrowpreview = finity:Create("ImageLabel", {
                            Name = "ArrowPreview",
                            BackgroundColor3 = Color3.new(1, 1, 1),
                            BackgroundTransparency = 1,
                            ImageTransparency = 0.25,
                            Position = UDim2.new(0.5, 0, 0.5, -6),
                            Size = UDim2.new(0, 6, 0, 6),
                            ZIndex = 3,
                            Image = "rbxassetid://2500573769",
                            Rotation = -90
                        })
                        
                        cheat.hsvbar.MouseButton1Down:Connect(function()
                            local rs = finity.gs["RunService"]
                            local uis = finity.gs["UserInputService"]local last = cheat.value;

                            cheat.hsvbar.Image = hsvimage

                            while uis:IsMouseButtonPressed'MouseButton1' do
                                local mouseloc = uis:GetMouseLocation()
                                local sx = cheat.arrowpreview.AbsoluteSize.X / 2;
                                local offset = (mouseloc.x - cheat.hsvbar.AbsolutePosition.X) - sx
                                local scale = offset / cheat.hsvbar.AbsoluteSize.X
                                local position = math.clamp(offset, -sx, cheat.hsvbar.AbsoluteSize.X - sx) / cheat.hsvbar.AbsoluteSize.X

                                finity.gs["TweenService"]:Create(cheat.arrowpreview, TweenInfo.new(0.1), {Position = UDim2.new(position, 0, 0.5, -6)}):Play()
                                
                                cheat.value = Color3.fromHSV(math.clamp(scale, 0, 1), 1, 1)

                                if cheat.value ~= last then
                                    last = cheat.value
                                    
                                    if callback then
                                        local s, e = pcall(function()
                                            callback(cheat.value)
                                        end)
        
                                        if not s then warn("error: ".. e) end
                                    end
                                end

                                rs.RenderStepped:wait()
                            end
                        end)
                        cheat.hsvbar.MouseButton2Down:Connect(function()
                            local rs = finity.gs["RunService"]
                            local uis = finity.gs["UserInputService"]
                            local last = cheat.value;

                            cheat.hsvbar.Image = lumienceimage

                            while uis:IsMouseButtonPressed'MouseButton2' do
                                local mouseloc = uis:GetMouseLocation()
                                local sx = cheat.arrowpreview.AbsoluteSize.X / 2
                                local offset = (mouseloc.x - cheat.hsvbar.AbsolutePosition.X) - sx
                                local scale = offset / cheat.hsvbar.AbsoluteSize.X
                                local position = math.clamp(offset, -sx, cheat.hsvbar.AbsoluteSize.X - sx) / cheat.hsvbar.AbsoluteSize.X

                                finity.gs["TweenService"]:Create(cheat.arrowpreview, TweenInfo.new(0.1), {Position = UDim2.new(position, 0, 0.5, -6)}):Play()
                                
                                cheat.value = Color3.fromHSV(1, 0, 1 - math.clamp(scale, 0, 1))

                                if cheat.value ~= last then
                                    last = cheat.value

                                    if callback then
                                        local s, e = pcall(function()
                                            callback(cheat.value)
                                        end)
        
                                        if not s then warn("error: ".. e) end
                                    end
                                end

                                rs.RenderStepped:wait()
                            end
                        end)

                        function cheat:SetValue(value)
                            cheat.value = value
                            if cheat.value then
                                finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
                            else
                                finity.gs["TweenService"]:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
								finity.gs["TweenService"]:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
                            end
                            if callback then
                                local s, e = pcall(function()
                                    callback(cheat.value)
                                end)
                                if not s then 
                                    warn("error: "..e) 
                                end
                            end
                        end

						cheat.hsvbar.Parent = cheat.container
						cheat.arrowpreview.Parent = cheat.hsvbar
					elseif string.lower(kind) == "dropdown" then
						if data then
							if data.default then
								cheat.value = data.default
							elseif data.options then
								cheat.value = data.options[1]
							else
								cheat.value = "None"
							end
						end
						
						local options
						
						if data and data.options then
							options = data.options
						end

						cheat.dropped = false

						cheat.dropdown = finity:Create("ImageButton", {
							Name = "Dropdown",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.dropdown_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.selected = finity:Create("TextLabel", {
							Name = "Selected",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0, 0),
							Size = UDim2.new(1, -35, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = tostring(cheat.value),
							TextColor3 = theme.dropdown_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left
						})

						cheat.list = finity:Create("ScrollingFrame", {
							Name = "List",
							BackgroundColor3 = theme.dropdown_background,
							BackgroundTransparency = 0.2,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 1, 0),
							Size = UDim2.new(1, 0, 0, 100),
							ZIndex = 3,
							BottomImage = "rbxassetid://967852042",
							MidImage = "rbxassetid://967852042",
							TopImage = "rbxassetid://967852042",
							ScrollBarThickness = 4,
							VerticalScrollBarInset = Enum.ScrollBarInset.None,
							ScrollBarImageColor3 = theme.dropdown_scrollbar_color
						})

						local uilistlayout = finity:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 2)
						})
						uilistlayout.Parent = cheat.list
						uilistlayout = nil
						local uipadding = finity:Create("UIPadding", {
							PaddingLeft = UDim.new(0, 2)
						})
						uipadding.Parent = cheat.list
						uipadding = nil
						
						local function refreshOptions()
							if cheat.dropped then
								cheat.fadelist()
							end	
							
							for _, child in next, cheat.list:GetChildren() do
								if child:IsA("TextButton") then
									child:Destroy()
								end
							end
							
							for _, value in next, options do
								local button = finity:Create("TextButton", {
									BackgroundColor3 = Color3.new(1, 1, 1),
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 20),
									ZIndex = 3,
									Font = Enum.Font.Gotham,
									Text = value,
									TextColor3 = theme.dropdown_text,
									TextSize = 13
								})
	
								button.Parent = cheat.list
	
								button.MouseEnter:Connect(function()
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
								end)
								button.MouseLeave:Connect(function()
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
								end)
								button.MouseButton1Click:Connect(function()
									if cheat.dropped then
										cheat.value = value
										cheat.selected.Text = value
	
										cheat.fadelist()
										
										if callback then
											local s, e = pcall(function()
												callback(cheat.value)
											end)
	
											if not s then warn("error: ".. e) end
										end
									end
								end)
								
								
								finity.gs["TweenService"]:Create(button, TweenInfo.new(0), {TextTransparency = 1}):Play()
							end
							
							finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, cheat.list["UIListLayout"].AbsoluteContentSize.Y), ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
						end
						
						
						function cheat.fadelist()
							cheat.dropped = not cheat.dropped

							if cheat.dropped then
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
									end
								end

								finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.clamp(cheat.list["UIListLayout"].AbsoluteContentSize.Y, 0, 150)), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 0, BackgroundTransparency = 0.5}):Play()
							else
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
									end
								end

								finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
							end
						end

						cheat.dropdown.MouseEnter:Connect(function()
							finity.gs["TweenService"]:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
						end)
						cheat.dropdown.MouseLeave:Connect(function()
							finity.gs["TweenService"]:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
						end)
						cheat.dropdown.MouseButton1Click:Connect(function()
							cheat.fadelist()
						end)

						refreshOptions()
						
						function cheat:RemoveOption(value)
							local removed = false
							for index, option in next, options do
								if option == value then
									table.remove(options, index)
									removed = true
									break
								end
							end
							
							if removed then
								refreshOptions()
							end
							
							return removed
						end
						
						function cheat:AddOption(value)
							table.insert(options, value)
							
							refreshOptions()
						end
						
						function cheat:GetOption()
							return 	options;
						end
						
						function cheat:ClearOption()
							table.clear(options)
							refreshOptions()
						end
						
						function cheat:SetValue(value)
							cheat.selected.Text = value
							cheat.value = value
							
							if cheat.dropped then
								cheat.fadelist()
							end
							
							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn("error: ".. e) end
							end
						end

						cheat.selected.Parent = cheat.dropdown
						cheat.dropdown.Parent = cheat.container
						cheat.list.Parent = cheat.container
					elseif string.lower(kind) == "multidropdown" or string.lower(kind) == "multiselect" then
						cheat.value = {}
						
						local options
						if data and data.options then
							options = data.options
						else
							options = {}
						end
						
						cheat.dropped = false
						
						cheat.dropdown = finity:Create("ImageButton", {
							Name = "MultiDropdown",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.dropdown_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})
						
						cheat.selected = finity:Create("TextLabel", {
							Name = "Selected",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0, 0),
							Size = UDim2.new(1, -35, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "None",
							TextColor3 = theme.dropdown_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							RichText = false
						})
						
						-- Text fade gradient effect
						local textFade = finity:Create("UIGradient", {
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(0.85, 0),
								NumberSequenceKeypoint.new(1, 1)
							}),
							Rotation = 0
						})
						textFade.Parent = cheat.selected
						
						cheat.list = finity:Create("ScrollingFrame", {
							Name = "List",
							BackgroundColor3 = theme.dropdown_background,
							BackgroundTransparency = 0.2,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 1, 0),
							Size = UDim2.new(1, 0, 0, 100),
							ZIndex = 3,
							BottomImage = "rbxassetid://967852042",
							MidImage = "rbxassetid://967852042",
							TopImage = "rbxassetid://967852042",
							ScrollBarThickness = 4,
							VerticalScrollBarInset = Enum.ScrollBarInset.None,
							ScrollBarImageColor3 = theme.dropdown_scrollbar_color
						})
						
						local uilistlayout = finity:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 2)
						})
						uilistlayout.Parent = cheat.list
						uilistlayout = nil
						local uipadding = finity:Create("UIPadding", {
							PaddingLeft = UDim.new(0, 2)
						})
						uipadding.Parent = cheat.list
						uipadding = nil
						
						local function updateText()
							if #cheat.value == 0 then
								cheat.selected.Text = "None"
							elseif #cheat.value == 1 then
								cheat.selected.Text = cheat.value[1]
							elseif #cheat.value <= 3 then
								cheat.selected.Text = table.concat(cheat.value, ", ")
							else
								local displayText = table.concat({cheat.value[1], cheat.value[2], cheat.value[3]}, ", ")
								cheat.selected.Text = displayText .. ", ..."
							end
						end
						
						local function refreshOptions()
							local wasOpen = cheat.dropped
							
							-- Don't close dropdown when refreshing options
							for _, child in next, cheat.list:GetChildren() do
								if child:IsA("TextButton") then
									child:Destroy()
								end
							end
							
							for _, value in next, options do
								local isSelected = false
								for _, selected in next, cheat.value do
									if selected == value then
										isSelected = true
										break
									end
								end
								
								local button = finity:Create("TextButton", {
									BackgroundColor3 = theme.dropdown_background,
									BackgroundTransparency = isSelected and 0.2 or 1,
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 0, 20),
									ZIndex = 3,
									Font = Enum.Font.Gotham,
									Text = value,
									TextColor3 = theme.dropdown_text,
									TextSize = 13,
									TextXAlignment = Enum.TextXAlignment.Left
								})
								
								local uipadding = finity:Create("UIPadding", {
									PaddingLeft = UDim.new(0, 5)
								})
								uipadding.Parent = button
								
								button.MouseEnter:Connect(function()
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
									if not isSelected then
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
									end
								end)
								button.MouseLeave:Connect(function()
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
									local currentSelected = false
									for _, selected in next, cheat.value do
										if selected == value then
											currentSelected = true
											break
										end
									end
									if not currentSelected then
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
									else
										-- Use lower transparency (more opaque) for darker selected appearance
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
									end
								end)
								button.MouseButton1Click:Connect(function()
									-- Prevent click from bubbling to dropdown
									
									local found = false
									for i, selected in next, cheat.value do
										if selected == value then
											table.remove(cheat.value, i)
											found = true
											break
										end
									end
									
									if not found then
										table.insert(cheat.value, value)
									end
									
									updateText()
									
									-- Update button visual state without closing dropdown
									local currentSelected = not found
									-- Ensure background color is set correctly
									button.BackgroundColor3 = theme.dropdown_background
									-- Use lower transparency (more opaque) for darker selected appearance
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0.2), {
										BackgroundTransparency = currentSelected and 0.2 or 1
									}):Play()
									
									-- Refresh all buttons to update their states
									for _, btn in next, cheat.list:GetChildren() do
										if btn:IsA("TextButton") and btn ~= button then
											local btnIsSelected = false
											for _, selected in next, cheat.value do
												if selected == btn.Text then
													btnIsSelected = true
													break
												end
											end
											-- Ensure background color is set correctly
											btn.BackgroundColor3 = theme.dropdown_background
											-- Use lower transparency (more opaque) for darker selected appearance
											finity.gs["TweenService"]:Create(btn, TweenInfo.new(0.2), {
												BackgroundTransparency = btnIsSelected and 0.2 or 1
											}):Play()
										end
									end
									
									if callback then
										local s, e = pcall(function()
											callback(cheat.value)
										end)
										if not s then warn("error: ".. e) end
									end
								end)
								
								button.Parent = cheat.list
								
								-- Show button if dropdown is open
								if wasOpen then
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0), {BackgroundTransparency = isSelected and 0.2 or 1}):Play()
								else
									finity.gs["TweenService"]:Create(button, TweenInfo.new(0), {BackgroundTransparency = 1}):Play()
								end
							end
							
							-- Update list size and visibility based on open state
							local listLayout = cheat.list:FindFirstChild("UIListLayout")
							if listLayout then
								if wasOpen then
									finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0), {
										Size = UDim2.new(1, 0, 0, math.clamp(listLayout.AbsoluteContentSize.Y, 0, 150)),
										Position = UDim2.new(0, 0, 1, 0),
										CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y),
										ScrollBarImageTransparency = 0,
										BackgroundTransparency = 0.2
									}):Play()
								else
									finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0), {
										Size = UDim2.new(1, 0, 0, 0),
										Position = UDim2.new(0, 0, 1, 0),
										CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y),
										ScrollBarImageTransparency = 1,
										BackgroundTransparency = 1
									}):Play()
								end
							end
						end
						
						function cheat.fadelist()
							cheat.dropped = not cheat.dropped
							
							if cheat.dropped then
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										-- Ensure background color is correct
										button.BackgroundColor3 = theme.dropdown_background
										local isSelected = false
										for _, selected in next, cheat.value do
											if selected == button.Text then
												isSelected = true
												break
											end
										end
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.2), {
											BackgroundTransparency = isSelected and 0.2 or 1
										}):Play()
									end
								end
								finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.clamp(cheat.list["UIListLayout"].AbsoluteContentSize.Y, 0, 150)), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 0, BackgroundTransparency = 0.2}):Play()
							else
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										finity.gs["TweenService"]:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
									end
								end
								finity.gs["TweenService"]:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
							end
						end
						
						cheat.dropdown.MouseEnter:Connect(function()
							finity.gs["TweenService"]:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
						end)
						cheat.dropdown.MouseLeave:Connect(function()
							finity.gs["TweenService"]:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
						end)
						cheat.dropdown.MouseButton1Click:Connect(function()
							cheat.fadelist()
						end)
						
						-- Click-away detection to close dropdown
						local clickAwayConnection
						clickAwayConnection = finity.gs["UserInputService"].InputBegan:Connect(function(input, gameProcessed)
							if gameProcessed then return end
							if input.UserInputType == Enum.UserInputType.MouseButton1 and cheat.dropped then
								-- Use a small delay to check if click was on dropdown or list
								task.spawn(function()
									task.wait(0.1)
									if not cheat.dropped then return end
									
									local mousePos = Vector2.new(mouse.X, mouse.Y)
									local containerPos = cheat.container.AbsolutePosition
									local containerSize = cheat.container.AbsoluteSize
									local listPos = cheat.list.AbsolutePosition
									local listSize = cheat.list.AbsoluteSize
									
									-- Check if click is outside the dropdown container and list
									local inContainer = mousePos.X >= containerPos.X and mousePos.X <= containerPos.X + containerSize.X and
									                     mousePos.Y >= containerPos.Y and mousePos.Y <= containerPos.Y + containerSize.Y
									local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
									               mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
									
									if not inContainer and not inList then
										cheat.fadelist()
									end
								end)
							end
						end)
						
						refreshOptions()
						updateText()
						
						function cheat:SetValue(value)
							if typeof(value) == "table" then
								cheat.value = value
							else
								cheat.value = {value}
							end
							updateText()
							refreshOptions()
							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)
								if not s then warn("error: ".. e) end
							end
						end
						
						cheat.selected.Parent = cheat.dropdown
						cheat.dropdown.Parent = cheat.container
						cheat.list.Parent = cheat.container
					elseif string.lower(kind) == "textbox" then
						local placeholdertext = data and data.placeholder

						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.textbox_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.textbox = finity:Create("TextBox", {
							Name = "Textbox",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "",
							TextColor3 = theme.textbox_text,
							PlaceholderText = placeholdertext or "Value",
							TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            ClearTextOnFocus = false
						})

						cheat.background.MouseEnter:Connect(function()
							finity.gs["TweenService"]:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text_hover}):Play()
						end)
						cheat.background.MouseLeave:Connect(function()
							finity.gs["TweenService"]:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text}):Play()
						end)
						cheat.textbox.Focused:Connect(function()
							typing = true

							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.textbox_background_hover}):Play()
						end)
						cheat.textbox.FocusLost:Connect(function()
							typing = false

							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.textbox_background}):Play()
							finity.gs["TweenService"]:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text}):Play()

							cheat.value = cheat.textbox.Text

							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn("error: "..e) end
                            end
                        end)
                        function cheat:SetValue(value)
                            cheat.value = tostring(value)
                            cheat.textbox.Text = tostring(value)
                        end

						cheat.background.Parent = cheat.container
						cheat.textbox.Parent = cheat.container
					elseif string.lower(kind) == "slider" then
						cheat.value = 0

						local suffix = data.suffix or ""
						local minimum = data.min or 0
                        local maximum = data.max or 1
                        local default = data.default
                        local precise = data.precise
						
						local moveconnection
						local releaseconnection

						cheat.sliderbar = finity:Create("ImageButton", {
							Name = "Sliderbar",
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 6),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.slider_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02,
						})

						-- Min value label (top left, above slider)
						cheat.minLabel = finity:Create("TextLabel", {
							Name = "MinLabel",
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0.5, -8),
							Size = UDim2.new(0, 50, 0, 10),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = tostring(minimum) .. suffix,
							TextColor3 = theme.slider_text,
							TextSize = 10,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Bottom
						})

						-- Max value label (top right, above slider)
						cheat.maxLabel = finity:Create("TextLabel", {
							Name = "MaxLabel",
							AnchorPoint = Vector2.new(1, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0.5, -8),
							Size = UDim2.new(0, 50, 0, 10),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = tostring(maximum) .. suffix,
							TextColor3 = theme.slider_text,
							TextSize = 10,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextYAlignment = Enum.TextYAlignment.Bottom
						})

						cheat.numbervalue = finity:Create("TextLabel", {
							Name = "Value",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 5, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 13),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							TextXAlignment = Enum.TextXAlignment.Left,
							Text = "",
							TextTransparency = 1,
							TextColor3 = theme.slider_text,
							TextSize = 13,
						})

						cheat.visiframe = finity:Create("ImageLabel", {
							Name = "Frame",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(0.5, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.slider_color,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
                        })

                        if data.default then
                            local size = math.clamp(data.default - cheat.sliderbar.AbsolutePosition.X, 0, 150)
							local percent = size / 150
							local perc = default/maximum
                            cheat.value = math.floor((minimum + (maximum - minimum) * percent) * 100) / 100
                            finity.gs["TweenService"]:Create(cheat.visiframe, TweenInfo.new(0.1), {
								Size = UDim2.new(perc, 0, 1, 0),
                            }):Play()
                            if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn("error: ".. e) end
							end
                        end

                        function cheat:SetValue(value)
                            local size = math.clamp(value - cheat.sliderbar.AbsolutePosition.X, 0, 150)
							local percent = size / 150
							local perc = default/maximum
                            cheat.value = math.floor((minimum + (maximum - minimum) * percent) * 100) / 100
                            finity.gs["TweenService"]:Create(cheat.visiframe, TweenInfo.new(0.1), {
								Size = UDim2.new(perc, 0, 1, 0),
                            }):Play()
                            if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn("error: ".. e) end
							end
                        end

						cheat.sliderbar.MouseButton1Down:Connect(function()
							local size = math.clamp(mouse.X - cheat.sliderbar.AbsolutePosition.X, 0, 150)
							local percent = size / 150

							cheat.value = math.floor((minimum + (maximum - minimum) * percent) * 100) / 100
							if precise then
								cheat.numbervalue.Text = tostring(cheat.value) .. suffix
							else
								cheat.numbervalue.Text = math.ceil(tostring(cheat.value)) .. suffix
							end

							if callback then
								local s, e = pcall(function()
									if data.precise then
										callback(cheat.value)
									else
										callback(math.ceil(cheat.value))
									end
								end)

								if not s then warn("error: ".. e) end
							end

							finity.gs["TweenService"]:Create(cheat.visiframe, TweenInfo.new(0.1), {
								Size = UDim2.new(size / 150, 0, 1, 0),
								ImageColor3 = theme.slider_color_sliding
							}):Play()

							finity.gs["TweenService"]:Create(cheat.numbervalue, TweenInfo.new(0.1), {
								Position = UDim2.new(size / 150, 5, 0.5, 0),
								TextTransparency = 0
							}):Play()

							moveconnection = mouse.Move:Connect(function()
								local size = math.clamp(mouse.X - cheat.sliderbar.AbsolutePosition.X, 0, 150)
								local percent = size / 150

								cheat.value = math.floor((minimum + (maximum - minimum) * percent) * 100) / 100
                                if precise then
                                    cheat.numbervalue.Text = tostring(cheat.value) .. suffix
                                else
                                    cheat.numbervalue.Text = math.ceil(tostring(cheat.value)) .. suffix
                                end

								if callback then
                                    local s, e = pcall(function()
                                        if data.precise then
                                            callback(cheat.value)
                                        else
                                            callback(math.ceil(cheat.value))
                                        end
									end)

									if not s then warn("error: ".. e) end
								end

								finity.gs["TweenService"]:Create(cheat.visiframe, TweenInfo.new(0.1), {
									Size = UDim2.new(size / 150, 0, 1, 0),
								ImageColor3 = theme.slider_color_sliding
                                }):Play()
                                
                                local Position = UDim2.new(size / 150, 5, 0.5, 0);

                                if Position.Width.Scale >= 0.6 then
                                    Position = UDim2.new(1, -cheat.numbervalue.TextBounds.X, 0.5, 10);
                                end

								finity.gs["TweenService"]:Create(cheat.numbervalue, TweenInfo.new(0.1), {
									Position = Position,
									TextTransparency = 0
								}):Play()
							end)

							releaseconnection = finity.gs["UserInputService"].InputEnded:Connect(function(Mouse)
								if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then

									finity.gs["TweenService"]:Create(cheat.visiframe, TweenInfo.new(0.1), {
										ImageColor3 = theme.slider_color
									}):Play()

									finity.gs["TweenService"]:Create(cheat.numbervalue, TweenInfo.new(0.1), {
										TextTransparency = 1
									}):Play()

									moveconnection:Disconnect()
									moveconnection = nil
									releaseconnection:Disconnect()
									releaseconnection = nil
								end
							end)
						end)

						cheat.visiframe.Parent = cheat.sliderbar
						cheat.numbervalue.Parent = cheat.sliderbar
						cheat.minLabel.Parent = cheat.container
						cheat.maxLabel.Parent = cheat.container
						cheat.sliderbar.Parent = cheat.container
					elseif string.lower(kind) == "button" then
						local button_text = data and data.text

						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.button_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.button = finity:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = button_text or "Button",
							TextColor3 = theme.textbox_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Center
						})

						cheat.button.MouseEnter:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
						end)
						cheat.button.MouseLeave:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
						end)
						cheat.button.MouseButton1Down:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
						end)
						cheat.button.MouseButton1Up:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							
							if callback then
								local s, e = pcall(function()
									callback()
								end)

								if not s then warn("error: ".. e) end
							end
                        end)
                        
                        function cheat:Fire()
                            if callback then
								local s, e = pcall(function()
									callback()
								end)

								if not s then warn("error: ".. e) end
							end
                        end

						cheat.background.Parent = cheat.container
						cheat.button.Parent = cheat.container
					
					elseif string.lower(kind) == "keybind" or string.lower(kind) == "bind" then
                        local callback_bind = data and data.bind
						local connection
						cheat.holding = false
						
						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.button_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.button = finity:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "Click to Bind",
							TextColor3 = theme.textbox_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Center
						})

						cheat.button.MouseEnter:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
						end)
						cheat.button.MouseLeave:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
						end)
						cheat.button.MouseButton1Down:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
                        end)
                        cheat.button.MouseButton2Down:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
						end)
						cheat.button.MouseButton1Up:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							cheat.button.Text = "Press key..."
							
							if connection then
								connection:Disconnect()
								connection = nil
							end
							cheat.holding = false

							connection = finity.gs["UserInputService"].InputBegan:Connect(function(Input)
								if Input.UserInputType.Name == "Keyboard" and Input.KeyCode ~= finityData.ToggleKey and Input.KeyCode ~= Enum.KeyCode.Backspace then
									cheat.button.Text = "Bound to " .. tostring(Input.KeyCode.Name)
									
                                    if connection then
                                        connection:Disconnect()
                                        connection = nil
                                    end
									
									delay(0, function()
										callback_bind = Input.KeyCode
										cheat.value = Input.KeyCode

										if callback then
											local s, e = pcall(function()
												callback(Input.KeyCode)
											end)
			
											if not s then warn("error: ".. e) end
										end
									end)
								elseif Input.KeyCode == Enum.KeyCode.Backspace then
									callback_bind = nil
									cheat.button.Text = "Click to Bind"
									cheat.value = nil
									cheat.holding = false
									delay(0, function()
										if callback then
											local s, e = pcall(function()
												callback()
											end)
			
											if not s then warn("error: ".. e) end
										end
									end)

									connection:Disconnect()
									connection = nil
								elseif Input.KeyCode == finityData.ToggleKey then
									cheat.button.Text = "Invalid Key";
									cheat.value = nil
								end
							end)
						end)
						
                        cheat.button.MouseButton2Up:Connect(function()
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							cheat.value = nil
							callback_bind = nil
							cheat.button.Text = "Click to Bind"
							cheat.holding = false

							delay(0, function()
								if callback then
									local s, e = pcall(function()
										callback()
									end)
	
									if not s then warn("error: ".. e) end
								end
							end)
							
                            if connection then
                                connection:Disconnect()
                                connection = nil
                            end
						end)
                        
                        function cheat:SetValue(value)
                            cheat.value = tostring(value)
                            cheat.button.Text = "Bound to " .. tostring(value)
                        end
						
						finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
							if callback_bind and Input.KeyCode == callback_bind and not Process then
								cheat.holding = true
								if callback then
									local s, e = pcall(function()
										callback(Input.KeyCode)
									end)
	
									if not s then warn("error: ".. e) end
								end
							end
						end)
						finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
							if callback_bind and Input.KeyCode == callback_bind and not Process then
								cheat.holding = true
							end
						end)
						
						if callback_bind then
							cheat.button.Text = "Bound to " .. tostring(callback_bind.Name)
						end

						cheat.background.Parent = cheat.container
						cheat.button.Parent = cheat.container
					elseif string.lower(kind) == "keybindbutton" or string.lower(kind) == "keybindbtn" then
						local keybindKey = data and data.key or nil
						local keybindText = data and data.text or "Keybind"
						local keybindConnection = nil
						local waitingForInput = false
						
						cheat.value = keybindKey
						
						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.button_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})
						
						local function updateButtonText()
							if waitingForInput then
								cheat.button.Text = "Waiting for keybind..."
							elseif keybindKey then
								cheat.button.Text = tostring(keybindKey.Name)
							else
								cheat.button.Text = keybindText
							end
						end
						
						cheat.button = finity:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = keybindKey and tostring(keybindKey.Name) or keybindText,
							TextColor3 = theme.textbox_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Center
						})
						
						updateButtonText()
						
						local function setupKeybindListener()
								if keybindConnection then
									if typeof(keybindConnection) == "RBXScriptConnection" then
										keybindConnection:Disconnect()
									elseif keybindConnection == true and finity.gs["ContextActionService"] and keybindKey then
										finity.gs["ContextActionService"]:UnbindAction("FinityKeybindBtn_" .. tostring(keybindKey))
									end
									keybindConnection = nil
								end
							
							if keybindKey then
								local lastPressedTime = 0
								
								-- Use ContextActionService with high priority to override game keybinds
								if finity.gs["ContextActionService"] then
									local actionName = "FinityKeybindBtn_" .. tostring(keybindKey)
									-- Bind with high priority (2000) to override game actions
									finity.gs["ContextActionService"]:BindActionAtPriority(actionName, function(actionName, inputState, inputObject)
										-- Check if chat is open
										local chatBox = finity.gs["UserInputService"]:GetFocusedTextBox()
										if chatBox then return Enum.ContextActionResult.Pass end
										
										if inputState == Enum.UserInputState.Begin then
											local currentTime = tick()
											if currentTime - lastPressedTime > 0.15 then
												lastPressedTime = currentTime
												if callback then
													local s, e = pcall(function()
														callback(keybindKey)
													end)
													if not s then warn("error: ".. e) end
												end
												-- Sink the input to prevent game from processing it
												return Enum.ContextActionResult.Sink
											end
										end
										return Enum.ContextActionResult.Pass
									end, false, Enum.ContextActionPriority.High.Value, keybindKey)
									keybindConnection = true -- Mark as connected
								else
									-- Fallback: Use InputBegan with immediate connection
									keybindConnection = finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
										local chatBox = finity.gs["UserInputService"]:GetFocusedTextBox()
										if chatBox then return end
										
										-- Don't check Process - capture ALL key presses
										if Input.KeyCode == keybindKey then
											local currentTime = tick()
											if currentTime - lastPressedTime > 0.15 then
												lastPressedTime = currentTime
												if callback then
													local s, e = pcall(function()
														callback(keybindKey)
													end)
													if not s then warn("error: ".. e) end
												end
											end
										end
									end)
								end
							end
						end
						
						cheat.button.MouseEnter:Connect(function()
							if not waitingForInput then
								finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
							end
						end)
						cheat.button.MouseLeave:Connect(function()
							if not waitingForInput then
								finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							end
						end)
						cheat.button.MouseButton1Down:Connect(function()
							if not waitingForInput then
								finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
							end
						end)
						cheat.button.MouseButton1Up:Connect(function()
							if waitingForInput then return end
							
							finity.gs["TweenService"]:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							
							-- Start waiting for keybind
							waitingForInput = true
							updateButtonText()
							
							local inputConnection
							inputConnection = finity.gs["UserInputService"].InputBegan:Connect(function(Input, Process)
								if Process then return end
								
								if Input.UserInputType == Enum.UserInputType.Keyboard then
									if Input.KeyCode ~= finityData.ToggleKey and Input.KeyCode ~= Enum.KeyCode.Backspace then
										keybindKey = Input.KeyCode
										cheat.value = keybindKey
										waitingForInput = false
										updateButtonText()
										setupKeybindListener()
										
										if callback then
											local s, e = pcall(function()
												callback(keybindKey)
											end)
											if not s then warn("error: ".. e) end
										end
										
										inputConnection:Disconnect()
										inputConnection = nil
									elseif Input.KeyCode == Enum.KeyCode.Backspace then
										keybindKey = nil
										cheat.value = nil
										waitingForInput = false
										updateButtonText()
										
										if keybindConnection then
											if typeof(keybindConnection) == "RBXScriptConnection" then
												keybindConnection:Disconnect()
											elseif keybindConnection == true and finity.gs["ContextActionService"] and keybindKey then
												finity.gs["ContextActionService"]:UnbindAction("FinityKeybindBtn_" .. tostring(keybindKey))
											end
											keybindConnection = nil
										end
										
										inputConnection:Disconnect()
										inputConnection = nil
									end
								end
							end)
						end)
						
						cheat.button.MouseButton2Up:Connect(function()
							if waitingForInput then return end
							
							-- Right click to clear
							keybindKey = nil
							cheat.value = nil
							updateButtonText()
							
							if keybindConnection then
								if typeof(keybindConnection) == "RBXScriptConnection" then
									keybindConnection:Disconnect()
								elseif keybindConnection == true and finity.gs["ContextActionService"] and keybindKey then
									finity.gs["ContextActionService"]:UnbindAction("FinityKeybindBtn_" .. tostring(keybindKey))
								end
								keybindConnection = nil
							end
						end)
						
						function cheat:SetKey(key)
							cheat.value = key
							keybindKey = key
							waitingForInput = false
							updateButtonText()
							setupKeybindListener()
						end
						
						function cheat:SetText(text)
							keybindText = text
							updateButtonText()
						end
						
						function cheat:Connect(callbackFunc)
							callback = callbackFunc
							setupKeybindListener()
						end
						
						-- Setup initial keybind listener if key exists
						if callback then
							setupKeybindListener()
						end
						
						cheat.background.Parent = cheat.container
						cheat.button.Parent = cheat.container
					end
				end

				cheat.frame.Parent = sector.container
				cheat.label.Parent = cheat.frame
				cheat.container.Parent = cheat.frame

				return cheat
			end

			sector.frame.Parent = category[calculateSector()]
			sector.container.Parent = sector.frame
			sector.title.Parent = sector.frame

			return sector
		end
		
		firstCategory = false
		
		return category
	end

	self:addShadow(self2.container, 0)

	self2.categories.ClipsDescendants = true
	
	if not finity.gs["RunService"]:IsStudio() then
		self2.userinterface.Parent = self.gs["CoreGui"]
	else
		self2.userinterface.Parent = self.gs["Players"].LocalPlayer:WaitForChild("PlayerGui")
	end
	
	self2.container.Parent = self2.userinterface
	self2.categories.Parent = self2.container
	self2.sidebar.Parent = self2.container
	self2.topbar.Parent = self2.container
	self2.tip.Parent = self2.topbar
	topbarDrag.Parent = self2.topbar

	-- Expose config and keybinds
	self2.config = finity.config
	self2.keybinds = finity.keybinds
	
	-- Theme switching function
	self2.SwitchTheme = function(isDark)
		local newTheme = isDark and finity.dark_theme or finity.theme
		theme = newTheme
		
		-- Update main container
		self2.container.BackgroundColor3 = theme.main_container
		
		-- Update separators
		for _, child in next, self2.container:GetChildren() do
			if child.Name == "Separator" then
				child.BackgroundColor3 = theme.separator_color
			end
		end
		
		-- Update topbar tip
		self2.tip.TextColor3 = theme.text_color
		
		-- Update category buttons
		for _, button in next, self2.sidebar:GetChildren() do
			if button:IsA("TextButton") then
				button.BackgroundColor3 = theme.category_button_background
				button.BorderColor3 = theme.category_button_border
				button.TextColor3 = theme.text_color
			end
		end
		
		-- Update all UI elements recursively
		local function updateElement(element)
			for _, child in next, element:GetChildren() do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					if child.Name == "Title" or child.Name == "Selected" then
						child.TextColor3 = theme.text_color
					elseif child.TextColor3 == finity.theme.text_color or child.TextColor3 == finity.dark_theme.text_color then
						child.TextColor3 = theme.text_color
					end
				elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
					if child.ImageColor3 == finity.theme.dropdown_background or child.ImageColor3 == finity.dark_theme.dropdown_background then
						child.ImageColor3 = theme.dropdown_background
					elseif child.ImageColor3 == finity.theme.button_background or child.ImageColor3 == finity.dark_theme.button_background then
						child.ImageColor3 = theme.button_background
					elseif child.ImageColor3 == finity.theme.textbox_background or child.ImageColor3 == finity.dark_theme.textbox_background then
						child.ImageColor3 = theme.textbox_background
					end
				elseif child:IsA("ScrollingFrame") then
					child.BackgroundColor3 = theme.dropdown_background
					child.ScrollBarImageColor3 = theme.dropdown_scrollbar_color
				end
				updateElement(child)
			end
		end
		
		updateElement(self2.container)
	end
	
	-- Load config on initialization
	finity.config:Load()

	return self2, finityData
end

return finity
