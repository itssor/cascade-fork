--// Cascade: built-in notification/UI sounds (no rebrand; generic names).
--// Use app:PlaySound(name, volume) or sounds.Play(name, volume).

local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local SOUND_REGISTRY: { [string]: string } = {
	["hl2 grab"] = "rbxassetid://81144155428330",
	["tf2 warn"] = "rbxassetid://123366544786241",
	["hl2 ui"] = "rbxassetid://119449453189357",
	["discord"] = "rbxassetid://18501882001",
	["tf2 apples"] = "rbxassetid://18888469782",
	["og roblox"] = "rbxassetid://137171473068941",
	["sl noti"] = "rbxassetid://8486683243",
	["gta"] = "rbxassetid://88243474733896",
	["tf2 menu"] = "rbxassetid://9061754547",
}

local sounds = {}

function sounds.Play(name: string?, volume: number?): boolean
	if not name or name == "" or name == "None" then
		return false
	end
	local assetId = SOUND_REGISTRY[name]
	if not assetId then
		return false
	end
	local ok = pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = assetId
		s.Volume = math.clamp(tonumber(volume) or 1, 0, 1)
		s.Parent = SoundService
		s:Play()
		Debris:AddItem(s, 5)
	end)
	return ok
end

function sounds.GetRegistry(): { [string]: string }
	return SOUND_REGISTRY
end

function sounds.Names(): { string }
	local list = {}
	for k in pairs(SOUND_REGISTRY) do
		table.insert(list, k)
	end
	table.sort(list)
	return list
end

-- Add a custom sound (name -> asset ID, e.g. "rbxassetid://123"). Replaces existing if name exists.
function sounds.AddSound(name: string, assetId: string): ()
	if type(name) == "string" and name ~= "" and type(assetId) == "string" and assetId ~= "" then
		SOUND_REGISTRY[name] = assetId
	end
end

-- Remove a sound by name (built-in or custom).
function sounds.RemoveSound(name: string): ()
	if type(name) == "string" then
		SOUND_REGISTRY[name] = nil
	end
end

return sounds
