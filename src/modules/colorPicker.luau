--// Cascade: modal color picker (HSV wheel + value bar). Use app:ColorPicker(options).

local services = require("@modules/services")
local creator = require("@modules/creator")

local create = creator.Create
local UserInputService = services.UserInputService

local function resolveColor(themeValue: any): Color3?
	if themeValue == nil then return nil end
	if type(themeValue) == "table" and themeValue[1] and themeValue[1].Value ~= nil then
		return themeValue[1].Value :: Color3
	end
	if typeof(themeValue) == "Color3" then return themeValue end
	return nil
end

local function getPickerColors(app: any)
	local theme = app and app.Theme
	local bg = resolveColor(theme and theme.Controls and theme.Controls.Sidebar) or Color3.fromRGB(18, 18, 18)
	local titleColor = resolveColor(theme and theme.Text and theme.Text.Primary) or Color3.fromRGB(255, 255, 255)
	local accent = resolveColor(theme and theme.Controls and theme.Controls.Selection) or Color3.fromRGB(0, 122, 255)
	local barBg = resolveColor(theme and theme.Controls and theme.Controls.View) or Color3.fromRGB(30, 30, 30)
	return bg, titleColor, accent, barBg
end

local function getGuiParent(): Instance?
	local ok, hui = pcall(function() return gethui() end)
	if ok and hui then return hui end
	local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and cg then return cg end
	local ok3, plr = pcall(function() return game:GetService("Players").LocalPlayer end)
	if ok3 and plr and plr:FindFirstChild("PlayerGui") then return plr.PlayerGui end
	return nil
end

local colorPicker = {}

export type ColorPickerOptions = {
	Title: string?,
	InitialColor: Color3?,
	ValueChanged: ((color: Color3) -> ())?,
}

function colorPicker.Show(app: any, options: ColorPickerOptions?): ()
	options = options or {}
	local title = tostring(options.Title or "Color")
	local initialColor = options.InitialColor or Color3.new(1, 1, 1)
	local onChanged = options.ValueChanged

	local parent = getGuiParent()
	if not parent then return end

	local existing = parent:FindFirstChild("CascadeColorPicker")
	if existing then existing:Destroy() end

	local sg = create("ScreenGui")({
		Name = "CascadeColorPicker",
		DisplayOrder = 10050,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	}).__instance

	local bg, titleColor, accent, barBg = getPickerColors(app)

	local overlay = create("Frame")({
		Name = "Overlay",
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = sg,
	}).__instance
	overlay.Active = true

	local frame = create("Frame")({
		Name = "Frame",
		Size = UDim2.fromOffset(260, 320),
		Position = UDim2.new(0.5, -130, 0.5, -160),
		BackgroundColor3 = bg,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = sg,
		create("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 8) }),
	}).__instance
	frame.Active = true

	local titleLabel = create("TextLabel")({
		Name = "Title",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = titleColor,
		Text = title,
		Position = UDim2.fromOffset(10, 8),
		Size = UDim2.new(1, -20, 0, 20),
		Parent = frame,
		ZIndex = 3,
	}).__instance

	local wheel = create("ImageLabel")({
		Name = "Wheel",
		Size = UDim2.fromOffset(200, 200),
		Position = UDim2.fromOffset(30, 40),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6020299385",
		Parent = frame,
		ZIndex = 2,
	}).__instance

	local valueBar = create("Frame")({
		Name = "ValueBar",
		Size = UDim2.fromOffset(200, 12),
		Position = UDim2.fromOffset(30, 250),
		BackgroundColor3 = barBg,
		BorderSizePixel = 0,
		Parent = frame,
		ZIndex = 2,
	}).__instance

	local valueFill = create("Frame")({
		Name = "ValueFill",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = valueBar,
		ZIndex = 3,
	}).__instance

	local preview = create("Frame")({
		Name = "Preview",
		Size = UDim2.fromOffset(40, 20),
		Position = UDim2.fromOffset(210, 8),
		BackgroundColor3 = initialColor,
		BorderSizePixel = 0,
		Parent = frame,
		create("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 6) }),
		ZIndex = 3,
	}).__instance

	local cross = create("Frame")({
		Name = "Cross",
		Size = UDim2.fromOffset(10, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 1,
		BorderColor3 = accent,
		Parent = wheel,
		ZIndex = 4,
	}).__instance

	local applyBtn = create("TextButton")({
		Name = "Apply",
		Size = UDim2.fromOffset(100, 26),
		Position = UDim2.fromOffset(30, 275),
		Text = "Apply",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = titleColor,
		BackgroundColor3 = Color3.fromRGB(32, 32, 32),
		BorderSizePixel = 0,
		Parent = frame,
		create("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 6) }),
		ZIndex = 3,
	}).__instance

	local closeBtn = create("TextButton")({
		Name = "Close",
		Size = UDim2.fromOffset(100, 26),
		Position = UDim2.fromOffset(130, 275),
		Text = "Close",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		BackgroundColor3 = Color3.fromRGB(24, 24, 24),
		BorderSizePixel = 0,
		Parent = frame,
		create("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 6) }),
		ZIndex = 3,
	}).__instance

	local h, s, v = Color3.toHSV(initialColor)
	local draggingWheel = false
	local draggingValue = false
	local connections = {}

	local function setPreviewColor()
		local c = Color3.fromHSV(h, s, v)
		preview.BackgroundColor3 = c
		valueFill.BackgroundColor3 = Color3.fromHSV(h, s, 1)
		cross.BorderColor3 = accent
		local radius = wheel.AbsoluteSize.X / 2
		local angle = h * 2 * math.pi
		local px = radius + math.cos(angle) * radius * s
		local py = radius + math.sin(angle) * radius * s
		cross.Position = UDim2.new(0, px - 5, 0, py - 5)
	end

	local function pointToHSV(x: number, y: number)
		local cx = wheel.AbsoluteSize.X / 2
		local cy = wheel.AbsoluteSize.Y / 2
		local dx = x - cx
		local dy = y - cy
		local angle = math.atan2(dy, dx)
		local dist = math.sqrt(dx * dx + dy * dy)
		local radius = wheel.AbsoluteSize.X / 2
		h = (angle / (2 * math.pi)) % 1
		s = math.clamp(dist / radius, 0, 1)
		setPreviewColor()
	end

	local function pointToValue(x: number)
		local minX = valueBar.AbsolutePosition.X
		local maxX = minX + valueBar.AbsoluteSize.X
		v = math.clamp((x - minX) / (maxX - minX), 0, 1)
		setPreviewColor()
	end

	local function disconnectAll()
		for _, c in ipairs(connections) do
			pcall(function() c:Disconnect() end)
		end
		table.clear(connections)
	end

	local function close()
		disconnectAll()
		pcall(function() sg:Destroy() end)
	end

	table.insert(connections, wheel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingWheel = true
			local rel = input.Position - wheel.AbsolutePosition
			pointToHSV(rel.X, rel.Y)
		end
	end))
	table.insert(connections, wheel.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingWheel = false
		end
	end))
	table.insert(connections, valueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingValue = true
			pointToValue(input.Position.X)
		end
	end))
	table.insert(connections, valueBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingValue = false
		end
	end))
	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if draggingWheel then
				local rel = input.Position - wheel.AbsolutePosition
				pointToHSV(rel.X, rel.Y)
			elseif draggingValue then
				pointToValue(input.Position.X)
			end
		end
	end))

	applyBtn.MouseButton1Click:Connect(function()
		if onChanged then onChanged(Color3.fromHSV(h, s, v)) end
		close()
	end)
	closeBtn.MouseButton1Click:Connect(close)
	overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			close()
		end
	end)

	setPreviewColor()
end

return colorPicker
