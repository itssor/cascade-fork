--// Cascade: toast notifications. Use app:Notify(title, text, options?).

local utility = require("@modules/utility")
local services = require("@modules/services")
local creator = require("@modules/creator")

local create = creator.Create
local TweenService = services.TweenService

local function resolveColor(themeValue: any): Color3?
	if themeValue == nil then return nil end
	if type(themeValue) == "table" and themeValue[1] and themeValue[1].Value ~= nil then
		return themeValue[1].Value :: Color3
	end
	if typeof(themeValue) == "Color3" then return themeValue end
	return nil
end

local function getNotifyColors(app: any)
	local theme = app and app.Theme
	local bg = resolveColor(theme and theme.Controls and theme.Controls.Sidebar) or Color3.fromRGB(18, 18, 18)
	local titleColor = resolveColor(theme and theme.Text and theme.Text.Primary) or Color3.fromRGB(255, 255, 255)
	local bodyColor = resolveColor(theme and theme.Text and theme.Text.Secondary) or Color3.fromRGB(220, 220, 220)
	return bg, titleColor, bodyColor
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

local notify = {}

export type NotifyOptions = {
	Duration: number?,
	Position: string?,
	Animate: boolean?,
	Sound: string?,
	SoundVolume: number?,
}

function notify.Show(app: any, title: string?, text: string?, options: NotifyOptions?): ()
	title = tostring(title or "")
	text = tostring(text or "")
	options = options or {}
	local duration = math.clamp(tonumber(options.Duration) or 3, 0.25, 30)
	local position = options.Position or "TopRight"
	local animate = if options.Animate == nil then true else options.Animate
	local paddingX, paddingY = 20, 20

	if options.Sound and options.Sound ~= "None" then
		local soundsModule = require("@modules/sounds")
		soundsModule.Play(options.Sound, options.SoundVolume or 1)
	end

	local anchor, pos
	if position == "TopLeft" then
		anchor, pos = Vector2.new(0, 0), UDim2.new(0, paddingX, 0, paddingY)
	elseif position == "TopRight" then
		anchor, pos = Vector2.new(1, 0), UDim2.new(1, -paddingX, 0, paddingY)
	elseif position == "BottomLeft" then
		anchor, pos = Vector2.new(0, 1), UDim2.new(0, paddingX, 1, -paddingY)
	elseif position == "BottomRight" then
		anchor, pos = Vector2.new(1, 1), UDim2.new(1, -paddingX, 1, -paddingY)
	else
		anchor, pos = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
	end

	local parent = getGuiParent()
	if not parent then return end

	local sg = create("ScreenGui")({
		Name = "CascadeNotify",
		DisplayOrder = 9999,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	}).__instance

	local bg, titleColor, bodyColor = getNotifyColors(app)

	local frame = create("Frame")({
		Name = "Frame",
		AnchorPoint = anchor,
		Position = pos,
		Size = UDim2.fromOffset(300, 60),
		BackgroundColor3 = bg,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Parent = sg,

		create("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 8) }),
	}).__instance

	local titleLabel = create("TextLabel")({
		Name = "Title",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = titleColor,
		Text = title,
		Position = UDim2.fromOffset(10, 6),
		Size = UDim2.new(1, -20, 0, 20),
		Parent = frame,
	}).__instance

	local bodyLabel = create("TextLabel")({
		Name = "Body",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = bodyColor,
		TextWrapped = true,
		Text = text,
		Position = UDim2.fromOffset(10, 28),
		Size = UDim2.new(1, -20, 1, -34),
		Parent = frame,
	}).__instance

	if animate then
		frame.BackgroundTransparency = 1
		titleLabel.TextTransparency = 1
		bodyLabel.TextTransparency = 1
		TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0.1 }):Play()
		TweenService:Create(titleLabel, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
		TweenService:Create(bodyLabel, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	end

	local function cleanup()
		if animate then
			TweenService:Create(frame, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(titleLabel, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			TweenService:Create(bodyLabel, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			task.delay(0.3, function()
				if sg and sg.Parent then pcall(function() sg:Destroy() end) end
			end)
		else
			pcall(function() sg:Destroy() end)
		end
	end

	task.delay(duration, cleanup)
end

return notify
