--// Cascade: corner/side watermark (title + body text). Use app:Watermark(options).
--// Returns { Destroy, SetBody, SetVisible, SetPosition } so the app can update FPS/ping etc.

local creator = require("@modules/creator")
local create = creator.Create

local function resolveColor(themeValue: any): Color3?
	if themeValue == nil then return nil end
	if type(themeValue) == "table" and themeValue[1] and themeValue[1].Value ~= nil then
		return themeValue[1].Value :: Color3
	end
	if typeof(themeValue) == "Color3" then return themeValue end
	return nil
end

local function getWatermarkColors(app: any)
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

local function positionToAnchorAndUDim2(position: string): (Vector2, UDim2)
	local pad = 16
	if position == "TopRight" then
		return Vector2.new(1, 0), UDim2.new(1, -pad, 0, pad)
	elseif position == "BottomLeft" then
		return Vector2.new(0, 1), UDim2.new(0, pad, 1, -pad)
	elseif position == "BottomRight" then
		return Vector2.new(1, 1), UDim2.new(1, -pad, 1, -pad)
	end
	return Vector2.new(0, 0), UDim2.new(0, pad, 0, pad)
end

local watermark = {}

export type WatermarkOptions = {
	Title: string?,
	Body: string?,
	Position: ("TopLeft" | "TopRight" | "BottomLeft" | "BottomRight")?,
	Enabled: boolean?,
}

export type WatermarkHandle = {
	Destroy: () -> (),
	SetBody: (text: string) -> (),
	SetVisible: (visible: boolean) -> (),
	SetPosition: (position: "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight") -> (),
}

function watermark.Show(app: any, options: WatermarkOptions?): WatermarkHandle?
	options = options or {}
	local titleText = tostring(options.Title or "Cascade")
	local bodyText = tostring(options.Body or "")
	local position = options.Position or "TopLeft"
	local enabled = if options.Enabled == nil then true else options.Enabled

	local parent = getGuiParent()
	if not parent then return nil end

	local bg, titleColor, bodyColor = getWatermarkColors(app)
	local anchor, pos = positionToAnchorAndUDim2(position)

	local sg = create("ScreenGui")({
		Name = "CascadeWatermark",
		DisplayOrder = 9998,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	}).__instance

	local frame = create("Frame")({
		Name = "Frame",
		AnchorPoint = anchor,
		Position = pos,
		Size = UDim2.fromOffset(340, 50),
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
		Text = titleText,
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
		TextWrapped = false,
		Text = bodyText,
		Position = UDim2.fromOffset(10, 26),
		Size = UDim2.new(1, -20, 1, -34),
		Parent = frame,
	}).__instance

	if not enabled then
		sg.Enabled = false
	end

	local handle: WatermarkHandle = {
		Destroy = function()
			pcall(function() sg:Destroy() end)
		end,
		SetBody = function(text: string)
			if bodyLabel and bodyLabel.Parent then
				bodyLabel.Text = tostring(text)
			end
		end,
		SetVisible = function(visible: boolean)
			sg.Enabled = visible
		end,
		SetPosition = function(newPos: string)
			position = newPos
			anchor, pos = positionToAnchorAndUDim2(position)
			frame.AnchorPoint = anchor
			frame.Position = pos
		end,
	}
	return handle
end

return watermark
