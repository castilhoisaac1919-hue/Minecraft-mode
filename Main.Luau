local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local FONT = Enum.Font.Arcade

local HEART_IMAGES = {
	Full = "rbxassetid://71982775577774",
	Half = "rbxassetid://112532643693600",
	Empty = "rbxassetid://72490262317198",
}

local DAMAGE_SOUND = {
	SoundId = "rbxassetid://139459336979009",
	Volume = 0.3,
	MinDistance = 10,
	MaxDistance = 50,
}

local DAMAGE_HIGHLIGHT = {
	Color = Color3.fromRGB(255, 0, 0),
	FillTransparency = 0.4,
	Duration = 0.15,
}

local IDLE_ANIMATIONS = {
	[Enum.HumanoidRigType.R6] = "rbxassetid://180435571",
	[Enum.HumanoidRigType.R15] = "rbxassetid://507766666",
}

local XP = {
	Height = 8,
	Margin = 3,
	LevelGap = 1,
	LevelTextSize = 16,
	LevelAttribute = "ExperienceLevel",
	ProgressAttribute = "ExperienceProgress",
	Track = Color3.fromRGB(70, 70, 70),
	Fill = Color3.fromRGB(128, 255, 32),
	FillShade = Color3.fromRGB(74, 168, 24),
	Level = Color3.fromRGB(128, 255, 32),
}

local CONFIG = {
	HotbarSlots = 10,
	ExtraSlots = 30,
	ExtraColumns = 10,
	SlotSize = 40,
	SlotGap = 2,
	HeartSize = 16,
	HeartGap = 1,
	HeartsPerRow = 10,
	MaxHearts = 100,
	HealthPerHeart = 10,
	BottomMargin = 8,
	HeartsMargin = XP.Margin + XP.Height + XP.LevelGap + XP.LevelTextSize + 2,
	WindowMargin = 6,
	WindowPadding = 10,
	WindowGap = 24,
	PreviewWidth = 110,
	PreviewHeight = 166,
}

local STYLE = {
	Bevel = 2,
	WindowBevel = 3,
	HotbarFillTransparency = 0.35,
}

local SHIELD = {
	Image = "rbxassetid://133213905902110",
	Attribute = "Shield",
	PerIcon = 10,
	MaxIcons = 10,
	Gap = 2,
}

local SHAKE = {
	LostThreshold = 0.8,
	Amplitude = 2,
	Interval = 0.05,
}

local RECOVERY = {
	Window = 1,
	FastRate = 0.05,
	Duration = 2,
	JumpHeight = 3,
	IdleSteps = 5,
	SoundGrace = 0.25,
}

local DRAG = {
	HoldTime = 0.25,
	GhostTransparency = 0.1,
	GhostZIndex = 100,
	DimTransparency = 0.6,
}

local POPUP = {
	Hold = 1.6,
	Fade = 0.4,
	Gap = 8,
	TextSize = 14,
}

local TOOLTIP = {
	Offset = Vector2.new(14, -6),
	Padding = 6,
	TextSize = 14,
	Fill = Color3.fromRGB(16, 0, 16),
	FillTransparency = 0.06,
	BorderTop = Color3.fromRGB(80, 0, 255),
	BorderBottom = Color3.fromRGB(40, 0, 127),
	BorderThickness = 2,
	ZIndex = 120,
}

local SHADOW = {
	Color = Color3.fromRGB(56, 56, 56),
	Offset = 2,
}

local CROSSHAIR = {
	Size = 18,
	Thickness = 2,
}

local HURT = {
	Roll = 7,
	Duration = 0.4,
}

local HELD = {
	ScreenFraction = 0.42,
	MinSize = 140,
	MaxSize = 360,
	Margin = 1.15,
	FieldOfView = 30,
	BuildDelay = 0.12,
	EquipTime = 0.3,
	EquipDrop = 1.8,
	SwingTime = 0.3,
	SwingPitch = 55,
	SwingYaw = 18,
	BobX = 0.1,
	BobY = 0.12,
	SwayDegrees = 5,
	StepRate = 0.55,
	WalkSpeedReference = 16,
	BlendSpeed = 8,
	BaseRotation = Vector3.new(-8, -50, 0),
}

local DEATH = {
	TipDuration = 0.45,
	GroundWait = 0.75,
	Gravity = 196.2,
	TipDegrees = 90,
	PixelCount = 180,
	PixelMinSize = 0.6,
	PixelMaxSize = 1.4,
	PixelRiseMin = 4,
	PixelRiseMax = 10,
	PixelLifeMin = 0.9,
	PixelLifeMax = 1.8,
	PixelDrift = 3,
	PixelSpread = 1.25,
	ScreenTransparency = 0.45,
	ScreenFade = 0.4,
	PixelColors = {
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(235, 235, 235),
		Color3.fromRGB(205, 205, 205),
		Color3.fromRGB(175, 175, 175),
		Color3.fromRGB(145, 145, 145),
	},
}

local SCALE = {
	Min = 0.45,
	TouchHotbarWidth = 0.5,
	DesktopHotbarWidth = 0.9,
	HotbarHeight = 0.12,
}

local COLORS = {
	SlotFill = Color3.fromRGB(139, 139, 139),
	SlotBorder = Color3.fromRGB(0, 0, 0),
	SlotDark = Color3.fromRGB(55, 55, 55),
	SlotLight = Color3.fromRGB(255, 255, 255),
	Selected = Color3.fromRGB(255, 255, 255),
	Panel = Color3.fromRGB(198, 198, 198),
	PanelDark = Color3.fromRGB(85, 85, 85),
	PanelText = Color3.fromRGB(64, 64, 64),
	Text = Color3.fromRGB(255, 255, 255),
	OverheadFrame = Color3.fromRGB(0, 0, 0),
	DeathOverlay = Color3.fromRGB(120, 0, 0),
	Crosshair = Color3.fromRGB(255, 255, 255),
	ButtonFill = Color3.fromRGB(111, 111, 111),
	ButtonLight = Color3.fromRGB(160, 160, 160),
	ButtonDark = Color3.fromRGB(60, 60, 60),
	ButtonDisabledText = Color3.fromRGB(160, 160, 160),
}

local STROKE = {
	Normal = 2,
	Selected = 3,
}

local KEY_SLOTS = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9,
	[Enum.KeyCode.Zero] = 10,
}

local TARGET_BODY_PARTS = {
	Head = true,
	Torso = true,
	UpperTorso = true,
	LowerTorso = true,
	HumanoidRootPart = true,
}

local STRIP_CLASSES = {
	"BaseScript",
	"JointInstance",
	"WeldConstraint",
	"Constraint",
	"Sound",
	"Attachment",
	"ParticleEmitter",
	"Trail",
	"Beam",
	"Light",
	"Highlight",
	"BillboardGui",
	"ForceField",
	"Humanoid",
	"Tool",
}

local TOTAL_SLOTS = CONFIG.HotbarSlots + CONFIG.ExtraSlots

local slotTools = {}
local slotViews = {}
local hearts = {}
local heartBases = {}
local hudShields = {}
local watched = {}
local trackedTools = setmetatable({}, { __mode = "k" })
local highlightTokens = setmetatable({}, { __mode = "k" })
local healthConnections = {}
local recoverySamples = {}
local currentHumanoid = nil
local syncQueued = false
local deaths = 0
local previewModel = nil
local screenGui = nil
local press = nil
local shaking = false
local animating = false
local animationElapsed = 0
local waveUntil = 0
local waveStep = 0
local visibleHearts = 0
local lastHudHealth = 0
local hurtStart = -1000
local hurtSign = 1
local itemNameToken = 0
local itemNameTween = nil
local deathScreenTween = nil
local hoveredSlot = nil
local respawnToken = 0
local Systems = {}

local function checkAndRemoveTargetGui(instance)
	if screenGui and (instance == screenGui or instance:IsDescendantOf(screenGui)) then
		return
	end
	if instance:IsA("GuiObject") or instance:IsA("LayerCollector") then
		local lowerName = instance.Name:lower()
		if string.find(lowerName, "inventory", 1, true) or string.find(lowerName, "slot", 1, true) then
			instance:Destroy()
		end
	end
end

local function setupTargetGuiListener(instance)
	checkAndRemoveTargetGui(instance)
	if (instance:IsA("GuiObject") or instance:IsA("LayerCollector")) and not (screenGui and instance:IsDescendantOf(screenGui)) then
		instance:GetPropertyChangedSignal("Name"):Connect(function()
			checkAndRemoveTargetGui(instance)
		end)
	end
end

local function checkAndRemoveBillboard(instance)
	if instance:IsA("BillboardGui") and instance.Name ~= "OverheadHearts" then
		local parent = instance.Parent
		local adornee = instance.Adornee
		local isParentTarget = parent and TARGET_BODY_PARTS[parent.Name] and parent.Parent and Players:GetPlayerFromCharacter(parent.Parent)
		local isAdorneeTarget = adornee and TARGET_BODY_PARTS[adornee.Name] and adornee.Parent and Players:GetPlayerFromCharacter(adornee.Parent)
		if isParentTarget or isAdorneeTarget then
			instance:Destroy()
		end
	end
end

Workspace.DescendantAdded:Connect(function(descendant)
	checkAndRemoveBillboard(descendant)
	setupTargetGuiListener(descendant)
	if descendant:IsA("BillboardGui") then
		descendant:GetPropertyChangedSignal("Adornee"):Connect(function()
			checkAndRemoveBillboard(descendant)
		end)
		descendant:GetPropertyChangedSignal("Parent"):Connect(function()
			checkAndRemoveBillboard(descendant)
		end)
	end
end)

for _, descendant in Workspace:GetDescendants() do
	checkAndRemoveBillboard(descendant)
	checkAndRemoveTargetGui(descendant)
end

RunService.RenderStepped:Connect(function()
	pcall(function()
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
		end
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
		end
	end)
end)

local function create(className, properties)
	local instance = Instance.new(className)
	local parent = properties.Parent
	properties.Parent = nil
	for key, value in properties do
		instance[key] = value
	end
	instance.Parent = parent
	return instance
end

local function stripTags(text)
	return (string.gsub(text, "<[^>]*>", ""))
end

local function addTextShadow(label, offset)
	offset = offset or SHADOW.Offset
	local shadow = create("TextLabel", {
		Name = "TextShadow",
		AnchorPoint = label.AnchorPoint,
		Position = label.Position + UDim2.fromOffset(offset, offset),
		Size = label.Size,
		BackgroundTransparency = 1,
		Text = stripTags(label.Text),
		TextColor3 = SHADOW.Color,
		TextSize = label.TextSize,
		TextScaled = label.TextScaled,
		TextWrapped = label.TextWrapped,
		TextTransparency = label.TextTransparency,
		TextStrokeTransparency = 1,
		TextXAlignment = label.TextXAlignment,
		TextYAlignment = label.TextYAlignment,
		Font = label.Font,
		Visible = label.Visible,
		ZIndex = math.max(label.ZIndex - 1, 0),
		Parent = label.Parent,
	})
	label:GetPropertyChangedSignal("Text"):Connect(function()
		shadow.Text = stripTags(label.Text)
	end)
	label:GetPropertyChangedSignal("TextTransparency"):Connect(function()
		shadow.TextTransparency = label.TextTransparency
	end)
	label:GetPropertyChangedSignal("Visible"):Connect(function()
		shadow.Visible = label.Visible
	end)
	label:GetPropertyChangedSignal("Position"):Connect(function()
		shadow.Position = label.Position + UDim2.fromOffset(offset, offset)
	end)
	label:GetPropertyChangedSignal("Size"):Connect(function()
		shadow.Size = label.Size
	end)
	return shadow
end

local function addBevel(parent, thickness, topLeftColor, bottomRightColor, zIndex)
	local function edge(name, position, size, color)
		create("Frame", {
			Name = name,
			Position = position,
			Size = size,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			ZIndex = zIndex,
			Parent = parent,
		})
	end
	edge("BevelTop", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, thickness), topLeftColor)
	edge("BevelLeft", UDim2.fromOffset(0, 0), UDim2.new(0, thickness, 1, 0), topLeftColor)
	edge("BevelBottom", UDim2.new(0, 0, 1, -thickness), UDim2.new(1, 0, 0, thickness), bottomRightColor)
	edge("BevelRight", UDim2.new(1, -thickness, 0, 0), UDim2.new(0, thickness, 1, 0), bottomRightColor)
end

local function shouldStrip(instance)
	for _, className in STRIP_CLASSES do
		if instance:IsA(className) then
			return true
		end
	end
	return false
end

local function getHeartCounts(humanoid)
	local healthPerHeart = CONFIG.HealthPerHeart
	local maxHealth = humanoid and humanoid.MaxHealth or healthPerHeart * CONFIG.HeartsPerRow
	local health = humanoid and humanoid.Health or 0
	maxHealth = math.clamp(maxHealth, 0, CONFIG.MaxHearts * healthPerHeart)
	health = math.clamp(health, 0, maxHealth)
	return math.ceil(maxHealth / healthPerHeart), math.ceil(health / (healthPerHeart / 2))
end

local function getHeartImage(index, halves)
	if halves >= index * 2 then
		return HEART_IMAGES.Full
	elseif halves >= index * 2 - 1 then
		return HEART_IMAGES.Half
	end
	return HEART_IMAGES.Empty
end

local function getShieldIcons(humanoid)
	local character = humanoid.Parent
	if character and character:FindFirstChildOfClass("ForceField") then
		return SHIELD.MaxIcons
	end
	local shield = humanoid:GetAttribute(SHIELD.Attribute)
	if type(shield) ~= "number" or shield <= 0 then
		return 0
	end
	return math.min(math.ceil(shield / SHIELD.PerIcon), SHIELD.MaxIcons)
end

local function isLowHealth(humanoid)
	if not humanoid or humanoid.MaxHealth <= 0 then
		return false
	end
	local lostFraction = (humanoid.MaxHealth - humanoid.Health) / humanoid.MaxHealth
	return lostFraction >= SHAKE.LostThreshold - 0.0001
end

local function isCompactDevice()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function isFirstPerson()
	local camera = Workspace.CurrentCamera
	if not camera then
		return false
	end
	return (camera.Focus.Position - camera.CFrame.Position).Magnitude < 1
end

do
	local BLOCKY = {
		ModelName = "MinecraftBody",
		PixelDivisor = 12,
		GuiDistance = 90,
		ClothDetail = 2,
		RefreshDelay = 0.35,
	}

	local TEMPLATE_RECTS = {
		Torso = {
			Front = { 231, 74, 128, 128 },
			Back = { 427, 74, 128, 128 },
			Right = { 165, 74, 64, 128 },
			Left = { 361, 74, 64, 128 },
			Top = { 231, 8, 128, 64 },
			Bottom = { 231, 204, 128, 64 },
		},
		RightLimb = {
			Front = { 217, 355, 64, 128 },
			Right = { 153, 355, 64, 128 },
			Back = { 89, 355, 64, 128 },
			Left = { 25, 355, 64, 128 },
			Top = { 217, 289, 64, 64 },
			Bottom = { 153, 289, 64, 64 },
		},
		LeftLimb = {
			Front = { 308, 355, 64, 128 },
			Left = { 372, 355, 64, 128 },
			Back = { 436, 355, 64, 128 },
			Right = { 500, 355, 64, 128 },
			Top = { 308, 289, 64, 64 },
			Bottom = { 372, 289, 64, 64 },
		},
	}

	local BLOCK_PARTS = {
		{
			Name = "Head",
			Size = Vector3.new(8, 8, 8),
			Offset = Vector3.new(0, 10, 0),
			Sources = { "Head" },
			Skip = {},
		},
		{
			Name = "Body",
			Size = Vector3.new(8, 12, 4),
			Offset = Vector3.new(0, 0, 0),
			Sources = { "UpperTorso", "Torso" },
			Layout = "Torso",
			Shirt = true,
			Pants = true,
			Skip = { Bottom = true },
		},
		{
			Name = "RightArm",
			Size = Vector3.new(4, 12, 4),
			Offset = Vector3.new(6, 0, 0),
			Sources = { "RightUpperArm", "Right Arm" },
			Layout = "RightLimb",
			Shirt = true,
			Skip = { Bottom = true },
		},
		{
			Name = "LeftArm",
			Size = Vector3.new(4, 12, 4),
			Offset = Vector3.new(-6, 0, 0),
			Sources = { "LeftUpperArm", "Left Arm" },
			Layout = "LeftLimb",
			Shirt = true,
			Skip = { Bottom = true },
		},
		{
			Name = "RightLeg",
			Size = Vector3.new(4, 12, 4),
			Offset = Vector3.new(2, -12, 0),
			Sources = { "RightUpperLeg", "Right Leg" },
			Layout = "RightLimb",
			Pants = true,
			Skip = { Bottom = true, Top = true },
		},
		{
			Name = "LeftLeg",
			Size = Vector3.new(4, 12, 4),
			Offset = Vector3.new(-2, -12, 0),
			Sources = { "LeftUpperLeg", "Left Leg" },
			Layout = "LeftLimb",
			Pants = true,
			Skip = { Bottom = true, Top = true },
		},
	}

	local FACE_LIST = {
		{ Id = Enum.NormalId.Front, Key = "Front" },
		{ Id = Enum.NormalId.Back, Key = "Back" },
		{ Id = Enum.NormalId.Right, Key = "Right" },
		{ Id = Enum.NormalId.Left, Key = "Left" },
		{ Id = Enum.NormalId.Top, Key = "Top" },
		{ Id = Enum.NormalId.Bottom, Key = "Bottom" },
	}

	local poseSnapshots = setmetatable({}, { __mode = "k" })
	local poseLists = setmetatable({}, { __mode = "k" })
	local livePoseCharacters = setmetatable({}, { __mode = "k" })
	local blockRefreshTokens = setmetatable({}, { __mode = "k" })
	local blockBodies = {}

	local function getPoseParts(character)
		local entry = poseLists[character]
		local now = os.clock()
		if not entry or now - entry.Time > 1 then
			local parts = {}
			for _, descendant in character:GetDescendants() do
				if descendant:IsA("BasePart") and not descendant:FindFirstAncestorOfClass("Tool") then
					table.insert(parts, descendant)
				end
			end
			entry = { Time = now, Parts = parts }
			poseLists[character] = entry
		end
		return entry.Parts
	end

	local function capturePose(character)
		local snapshot = poseSnapshots[character]
		if not snapshot then
			snapshot = setmetatable({}, { __mode = "k" })
			poseSnapshots[character] = snapshot
		end
		for _, part in getPoseParts(character) do
			if part.Parent then
				snapshot[part] = part.CFrame
			end
		end
	end

	local function updatePoseSnapshots()
		for character, humanoid in livePoseCharacters do
			if character.Parent and humanoid.Parent and humanoid.Health > 0 then
				capturePose(character)
			end
		end
	end

	local function computeRestPose(character, root)
		local rest = { [root] = CFrame.identity }
		local joints = {}
		for _, descendant in character:GetDescendants() do
			if descendant:IsA("Motor6D") and descendant.Part0 and descendant.Part1 then
				table.insert(joints, descendant)
			end
		end
		local progressed = true
		while progressed do
			progressed = false
			for _, joint in joints do
				local part0 = joint.Part0
				local part1 = joint.Part1
				if rest[part0] and not rest[part1] then
					rest[part1] = rest[part0] * joint.C0 * joint.C1:Inverse()
					progressed = true
				elseif rest[part1] and not rest[part0] then
					rest[part0] = rest[part1] * joint.C1 * joint.C0:Inverse()
					progressed = true
				end
			end
		end
		return rest
	end

	local function findSource(character, names)
		for _, name in names do
			local part = character:FindFirstChild(name)
			if part and part:IsA("BasePart") then
				return part
			end
		end
		return nil
	end

	local function snapToPixels(value, pixel)
		return math.max(math.floor(value / pixel + 0.5), 1) * pixel
	end

	local function getFaceCanvas(size, key)
		if key == "Front" or key == "Back" then
			return Vector2.new(size.X, size.Y)
		elseif key == "Left" or key == "Right" then
			return Vector2.new(size.Z, size.Y)
		end
		return Vector2.new(size.X, size.Z)
	end

	local function getAccessoryTexture(handle)
		if handle:IsA("MeshPart") then
			local appearance = handle:FindFirstChildOfClass("SurfaceAppearance")
			if appearance and appearance.ColorMap ~= "" then
				return appearance.ColorMap
			end
			return handle.TextureID
		end
		local mesh = handle:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			return mesh.TextureId
		end
		return ""
	end

	local function addClothFace(block, faceId, faceKey, canvas, layers, guis)
		if #layers == 0 then
			return
		end
		local gui = create("SurfaceGui", {
			Name = "Cloth" .. faceKey,
			Face = faceId,
			Adornee = block,
			SizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
			CanvasSize = Vector2.new(math.max(math.round(canvas.X), 1), math.max(math.round(canvas.Y), 1)),
			LightInfluence = 1,
			AlwaysOnTop = false,
			Active = false,
			ClipsDescendants = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = block,
		})
		for order, layer in layers do
			local label = create("ImageLabel", {
				Name = layer.Name,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = layer.Image,
				ResamplerMode = Enum.ResamplerMode.Pixelated,
				ScaleType = Enum.ScaleType.Stretch,
				ZIndex = order,
				Parent = gui,
			})
			if layer.Rect then
				label.ImageRectOffset = Vector2.new(layer.Rect[1], layer.Rect[2])
				label.ImageRectSize = Vector2.new(layer.Rect[3], layer.Rect[4])
			end
		end
		table.insert(guis, gui)
	end

	local function buildBlockBody(character)
		local root = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 then
			return
		end

		local existing = blockBodies[character]
		if existing then
			existing.Model:Destroy()
			blockBodies[character] = nil
		end

		local pixel = root.Size.Y / BLOCKY.PixelDivisor
		local rest = computeRestPose(character, root)
		local model = create("Model", { Name = BLOCKY.ModelName, Parent = root })
		local body = {
			Model = model,
			Root = root,
			Blocks = {},
			Originals = {},
		}

		local shirt = character:FindFirstChildOfClass("Shirt")
		local pants = character:FindFirstChildOfClass("Pants")
		local graphic = character:FindFirstChildOfClass("ShirtGraphic")
		local shirtImage = shirt and shirt.ShirtTemplate or ""
		local pantsImage = pants and pants.PantsTemplate or ""
		local graphicImage = graphic and graphic.Graphic or ""

		for _, definition in BLOCK_PARTS do
			local source = findSource(character, definition.Sources)
			local sourceRest = source and rest[source]
			if source and sourceRest then
				local desired = CFrame.new(definition.Offset * pixel)
				local block = create("Part", {
					Name = definition.Name,
					Size = definition.Size * pixel,
					Color = source.Color,
					Material = Enum.Material.SmoothPlastic,
					Massless = true,
					CanCollide = false,
					CanQuery = false,
					CanTouch = false,
					CFrame = root.CFrame * desired,
					Parent = model,
				})
				create("Weld", {
					Name = "BlockWeld",
					Part0 = source,
					Part1 = block,
					C0 = sourceRest:Inverse() * desired,
					Parent = block,
				})

				local guis = {}
				local layout = definition.Layout and TEMPLATE_RECTS[definition.Layout]

				for _, face in FACE_LIST do
					if not definition.Skip[face.Key] then
						local layers = {}
						if layout then
							if definition.Pants and pantsImage ~= "" then
								table.insert(layers, { Name = "Pants", Image = pantsImage, Rect = layout[face.Key] })
							end
							if definition.Shirt and shirtImage ~= "" then
								table.insert(layers, { Name = "Shirt", Image = shirtImage, Rect = layout[face.Key] })
							end
							if definition.Layout == "Torso" and face.Key == "Front" and graphicImage ~= "" then
								table.insert(layers, { Name = "Graphic", Image = graphicImage })
							end
						end
						if definition.Name == "Head" and face.Key == "Front" then
							local decal = source:FindFirstChildOfClass("Decal")
							if decal and decal.Texture ~= "" then
								table.insert(layers, { Name = "Face", Image = decal.Texture })
							end
						end
						if #layers > 0 then
							addClothFace(
								block,
								face.Id,
								face.Key,
								getFaceCanvas(definition.Size, face.Key) * BLOCKY.ClothDetail,
								layers,
								guis
							)
						end
					end
				end

				table.insert(body.Blocks, { Part = block, Source = source, Guis = guis, Shown = true, Forced = false })
			end
		end

		for _, child in character:GetChildren() do
			if child:IsA("Accessory") then
				local handle = child:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					local size = Vector3.new(
						snapToPixels(handle.Size.X, pixel),
						snapToPixels(handle.Size.Y, pixel),
						snapToPixels(handle.Size.Z, pixel)
					)
					local box = create("Part", {
						Name = "Pixel" .. child.Name,
						Size = size,
						Color = handle.Color,
						Material = Enum.Material.SmoothPlastic,
						Massless = true,
						CanCollide = false,
						CanQuery = false,
						CanTouch = false,
						CFrame = handle.CFrame,
						Parent = model,
					})
					create("Weld", {
						Name = "BlockWeld",
						Part0 = handle,
						Part1 = box,
						Parent = box,
					})
					local guis = {}
					local texture = getAccessoryTexture(handle)
					if texture ~= "" then
						for _, face in FACE_LIST do
							addClothFace(
								box,
								face.Id,
								face.Key,
								getFaceCanvas(size / pixel, face.Key),
								{ { Name = "Texture", Image = texture } },
								guis
							)
						end
					end
					table.insert(body.Blocks, { Part = box, Source = handle, Guis = guis, Shown = true, Forced = false })
				end
			end
		end

		for _, descendant in character:GetDescendants() do
			if
				(descendant:IsA("BasePart") or descendant:IsA("Decal"))
				and descendant ~= root
				and not descendant:IsDescendantOf(model)
				and not descendant:FindFirstAncestorOfClass("Tool")
			then
				table.insert(body.Originals, descendant)
			end
		end

		blockBodies[character] = body
	end

	local function scheduleBlockRefresh(character)
		local token = (blockRefreshTokens[character] or 0) + 1
		blockRefreshTokens[character] = token
		task.delay(BLOCKY.RefreshDelay, function()
			if blockRefreshTokens[character] == token and character.Parent then
				buildBlockBody(character)
			end
		end)
	end

	local function isBodyRelevant(child)
		return child:IsA("BasePart")
			or child:IsA("Accessory")
			or child:IsA("Shirt")
			or child:IsA("Pants")
			or child:IsA("ShirtGraphic")
			or child:IsA("BodyColors")
	end

	local function updateBlockBodies()
		local camera = Workspace.CurrentCamera
		local cameraPosition = camera and camera.CFrame.Position or nil
		local firstPerson = isFirstPerson()
		local localCharacter = player.Character
		for character, body in blockBodies do
			if not character.Parent or not body.Model.Parent then
				blockBodies[character] = nil
				continue
			end
			local hideBody = firstPerson and character == localCharacter
			for _, original in body.Originals do
				if original.Parent and original.LocalTransparencyModifier ~= 1 then
					original.LocalTransparencyModifier = 1
				end
			end
			local near = cameraPosition == nil or (body.Root.Position - cameraPosition).Magnitude <= BLOCKY.GuiDistance
			for _, block in body.Blocks do
				local part = block.Part
				local sourceTransparency = block.Source.Transparency
				if part.Transparency ~= sourceTransparency then
					part.Transparency = sourceTransparency
				end
				if hideBody then
					part.LocalTransparencyModifier = 1
					block.Forced = true
				elseif block.Forced then
					part.LocalTransparencyModifier = 0
					block.Forced = false
				end
				local show = near and part.Transparency < 0.99 and part.LocalTransparencyModifier < 0.99
				if block.Shown ~= show then
					block.Shown = show
					for _, gui in block.Guis do
						gui.Enabled = show
					end
				end
			end
		end
	end

	Systems.Body = {
		ModelName = BLOCKY.ModelName,
		Snapshots = poseSnapshots,
		Live = livePoseCharacters,
		capturePose = capturePose,
		isRelevant = isBodyRelevant,
		scheduleRefresh = scheduleBlockRefresh,
		updatePoseSnapshots = updatePoseSnapshots,
		updateBodies = updateBlockBodies,
	}
end

do
	local OVERHEAD = {
		HeartSize = 10,
		HeartGap = 1,
		HeartsPerRow = 10,
		Height = 2.2,
		Distance = 50,
		FadeRange = 10,
		FramePadding = 4,
		FrameGap = 2,
		FrameTransparency = 0.25,
		FrameCorner = 3,
		NameHeight = 14,
		ShakeAmplitude = 1,
		InvisibleCheckInterval = 0.25,
		InvisibleThreshold = 0.9,
	}

	local overheadViews = {}
	local overheadStep = OVERHEAD.HeartSize + OVERHEAD.HeartGap
	local overheadWidth = OVERHEAD.HeartsPerRow * overheadStep - OVERHEAD.HeartGap + OVERHEAD.FramePadding * 2
	local overheadShieldHeight = OVERHEAD.HeartSize + OVERHEAD.FramePadding * 2

	local function isCharacterInvisible(character)
		for _, descendant in character:GetDescendants() do
			if
				descendant:IsA("BasePart")
				and descendant.Name ~= "HumanoidRootPart"
				and descendant.Transparency < OVERHEAD.InvisibleThreshold
				and not descendant:FindFirstAncestorOfClass("Tool")
			then
				return false
			end
		end
		return true
	end

	local function setOverheadOffsets(view, shake)
		local amplitude = OVERHEAD.ShakeAmplitude
		for _, heart in view.Hearts do
			heart.Position = UDim2.fromOffset(0, shake and math.random(-amplitude, amplitude) or 0)
		end
	end

	local function renderOverhead(view)
		local totalHearts, halves = getHeartCounts(view.Humanoid)
		local shieldCount = getShieldIcons(view.Humanoid)
		local rows = math.max(math.ceil(totalHearts / OVERHEAD.HeartsPerRow), 1)
		local heartsHeight = rows * overheadStep - OVERHEAD.HeartGap + OVERHEAD.FramePadding * 2
		local shieldExtra = shieldCount > 0 and overheadShieldHeight + OVERHEAD.FrameGap or 0

		view.HeartsFrame.Size = UDim2.fromOffset(overheadWidth, heartsHeight)
		view.ShieldFrame.Visible = shieldCount > 0
		view.Gui.Size = UDim2.fromOffset(
			overheadWidth,
			OVERHEAD.NameHeight + OVERHEAD.FrameGap + shieldExtra + heartsHeight
		)

		for index = 1, totalHearts do
			local heart = view.Hearts[index]
			if not heart then
				local cell = create("Frame", {
					Name = "Cell" .. index,
					LayoutOrder = index,
					BackgroundTransparency = 1,
					Parent = view.HeartsFrame,
				})
				heart = create("ImageLabel", {
					Name = "Heart" .. index,
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					Parent = cell,
				})
				view.Cells[index] = cell
				view.Hearts[index] = heart
			end
			view.Cells[index].Visible = true
			heart.Image = getHeartImage(index, halves)
			heart.ImageTransparency = 1 - view.Alpha
		end

		for index = totalHearts + 1, #view.Hearts do
			view.Cells[index].Visible = false
		end

		for index = 1, shieldCount do
			local icon = view.Shields[index]
			if not icon then
				icon = create("ImageLabel", {
					Name = "Shield" .. index,
					LayoutOrder = index,
					Size = UDim2.fromOffset(OVERHEAD.HeartSize, OVERHEAD.HeartSize),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					Image = SHIELD.Image,
					Parent = view.ShieldFrame,
				})
				view.Shields[index] = icon
			end
			icon.Visible = true
			icon.ImageTransparency = 1 - view.Alpha
		end

		for index = shieldCount + 1, #view.Shields do
			view.Shields[index].Visible = false
		end

		local wasShaking = view.Shaking
		view.Shaking = isLowHealth(view.Humanoid)
		if wasShaking and not view.Shaking then
			setOverheadOffsets(view, false)
		end
	end

	local function applyOverheadAlpha(view)
		local transparency = 1 - view.Alpha
		local frameTransparency = OVERHEAD.FrameTransparency + (1 - OVERHEAD.FrameTransparency) * transparency
		view.NameFrame.BackgroundTransparency = frameTransparency
		view.ShieldFrame.BackgroundTransparency = frameTransparency
		view.HeartsFrame.BackgroundTransparency = frameTransparency
		view.NameLabel.TextTransparency = transparency
		for _, heart in view.Hearts do
			heart.ImageTransparency = transparency
		end
		for _, icon in view.Shields do
			icon.ImageTransparency = transparency
		end
	end

	local function setOverheadAlpha(view, alpha)
		if view.Alpha == alpha then
			return
		end
		view.Alpha = alpha
		view.Gui.Enabled = alpha > 0
		applyOverheadAlpha(view)
	end

	local function createOverheadFrame(name, parent, order)
		local frame = create("Frame", {
			Name = name,
			BackgroundColor3 = COLORS.OverheadFrame,
			BackgroundTransparency = OVERHEAD.FrameTransparency,
			BorderSizePixel = 0,
			LayoutOrder = order,
			Parent = parent,
		})
		create("UICorner", { CornerRadius = UDim.new(0, OVERHEAD.FrameCorner), Parent = frame })
		return frame
	end

	local function createOverhead(targetPlayer, character, humanoid)
		local head = character:WaitForChild("Head", 10)
		if not head then
			return
		end

		local initialHeartsHeight = OVERHEAD.HeartSize + OVERHEAD.FramePadding * 2

		local gui = create("BillboardGui", {
			Name = "OverheadHearts",
			Adornee = head,
			Active = false,
			Enabled = false,
			AlwaysOnTop = false,
			ClipsDescendants = false,
			LightInfluence = 0,
			MaxDistance = OVERHEAD.Distance + OVERHEAD.FadeRange,
			StudsOffset = Vector3.new(0, OVERHEAD.Height, 0),
			SizeOffset = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(overheadWidth, OVERHEAD.NameHeight + OVERHEAD.FrameGap + initialHeartsHeight),
			Parent = head,
		})

		local container = create("Frame", {
			Name = "Container",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			Parent = gui,
		})

		create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, OVERHEAD.FrameGap),
			Parent = container,
		})

		local nameFrame = createOverheadFrame("NameFrame", container, 1)
		nameFrame.Size = UDim2.fromOffset(overheadWidth, OVERHEAD.NameHeight)

		local nameLabel = create("TextLabel", {
			Name = "PlayerName",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -OVERHEAD.FramePadding * 2, 1, -2),
			BackgroundTransparency = 1,
			Text = targetPlayer.DisplayName,
			TextColor3 = COLORS.Text,
			TextScaled = true,
			Font = FONT,
			Parent = nameFrame,
		})

		create("UITextSizeConstraint", { MaxTextSize = 11, MinTextSize = 5, Parent = nameLabel })

		local overheadShields = createOverheadFrame("ShieldFrame", container, 2)
		overheadShields.Size = UDim2.fromOffset(overheadWidth, overheadShieldHeight)
		overheadShields.Visible = false

		create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, OVERHEAD.HeartGap),
			Parent = overheadShields,
		})

		local overheadHearts = createOverheadFrame("HeartsFrame", container, 3)
		overheadHearts.Size = UDim2.fromOffset(overheadWidth, initialHeartsHeight)

		create("UIPadding", {
			PaddingTop = UDim.new(0, OVERHEAD.FramePadding),
			PaddingBottom = UDim.new(0, OVERHEAD.FramePadding),
			PaddingLeft = UDim.new(0, OVERHEAD.FramePadding),
			PaddingRight = UDim.new(0, OVERHEAD.FramePadding),
			Parent = overheadHearts,
		})

		create("UIGridLayout", {
			CellSize = UDim2.fromOffset(OVERHEAD.HeartSize, OVERHEAD.HeartSize),
			CellPadding = UDim2.fromOffset(OVERHEAD.HeartGap, OVERHEAD.HeartGap),
			FillDirectionMaxCells = OVERHEAD.HeartsPerRow,
			StartCorner = Enum.StartCorner.BottomLeft,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = overheadHearts,
		})

		local view = {
			Gui = gui,
			NameFrame = nameFrame,
			NameLabel = nameLabel,
			ShieldFrame = overheadShields,
			HeartsFrame = overheadHearts,
			Head = head,
			Humanoid = humanoid,
			Cells = {},
			Hearts = {},
			Shields = {},
			Alpha = 0,
			Invisible = false,
			Shaking = false,
			NextCheck = 0,
			NextShake = 0,
		}

		overheadViews[character] = view
		character.Destroying:Once(function()
			overheadViews[character] = nil
		end)

		humanoid.HealthChanged:Connect(function()
			renderOverhead(view)
		end)
		humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
			renderOverhead(view)
		end)
		humanoid:GetAttributeChangedSignal(SHIELD.Attribute):Connect(function()
			renderOverhead(view)
		end)
		character.ChildAdded:Connect(function(child)
			if child:IsA("ForceField") then
				renderOverhead(view)
			end
		end)
		character.ChildRemoved:Connect(function(child)
			if child:IsA("ForceField") then
				renderOverhead(view)
			end
		end)
		targetPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
			nameLabel.Text = targetPlayer.DisplayName
		end)

		renderOverhead(view)
	end

	local function updateOverheads()
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end
		local origin = camera.CFrame.Position
		local now = os.clock()
		for character, view in overheadViews do
			local alpha = 0
			if view.Head.Parent and view.Humanoid.Health > 0 then
				if now >= view.NextCheck then
					view.NextCheck = now + OVERHEAD.InvisibleCheckInterval
					view.Invisible = isCharacterInvisible(character)
				end
				if not view.Invisible then
					local distance = (view.Head.Position - origin).Magnitude
					alpha = math.clamp(1 - (distance - OVERHEAD.Distance) / OVERHEAD.FadeRange, 0, 1)
				end
			end
			setOverheadAlpha(view, alpha)
			if view.Shaking and alpha > 0 and now >= view.NextShake then
				view.NextShake = now + SHAKE.Interval
				setOverheadOffsets(view, true)
			end
		end
	end

	Systems.Overhead = {
		create = createOverhead,
		update = updateOverheads,
	}
end

do
	local function findGroundHeight(origin, ignore)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = ignore
		local result = Workspace:Raycast(origin + Vector3.new(0, 1, 0), Vector3.new(0, -300, 0), params)
		return result and result.Position.Y or origin.Y
	end

	local function hideOriginal(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		for _, descendant in character:GetDescendants() do
			if descendant:IsA("BasePart") or descendant:IsA("Decal") then
				descendant.Transparency = 1
			elseif descendant:IsA("Highlight") or descendant:IsA("ParticleEmitter") then
				descendant.Enabled = false
			elseif descendant:IsA("SurfaceGui") then
				descendant.Enabled = false
			end
		end
	end

	local function createCorpse(character)
		local archivable = character.Archivable
		character.Archivable = true

		local originals = {}
		for _, descendant in character:GetDescendants() do
			if descendant:IsA("BasePart") and not descendant:FindFirstAncestorOfClass("Tool") then
				table.insert(originals, descendant)
				descendant:SetAttribute("CorpseId", #originals)
			end
		end

		local corpse = character:Clone()

		for _, original in originals do
			original:SetAttribute("CorpseId", nil)
		end
		character.Archivable = archivable

		if not corpse then
			return nil
		end

		for _, descendant in corpse:GetDescendants() do
			if descendant:IsA("SurfaceGui") then
				descendant.Enabled = true
			elseif
				(descendant:IsA("BasePart") or descendant:IsA("Decal"))
				and not descendant:FindFirstAncestor(Systems.Body.ModelName)
			then
				descendant.Transparency = 1
			end
		end

		for _, descendant in corpse:GetDescendants() do
			if not descendant:IsA("Humanoid") and not descendant:IsA("Attachment") and shouldStrip(descendant) then
				descendant:Destroy()
			end
		end

		local corpseHumanoid = corpse:FindFirstChildOfClass("Humanoid")
		if corpseHumanoid then
			corpseHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			corpseHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			corpseHumanoid.BreakJointsOnDeath = false
			corpseHumanoid.RequiresNeck = false
			corpseHumanoid.EvaluateStateMachine = false
			corpseHumanoid.Health = math.max(corpseHumanoid.MaxHealth, 1)
			local animator = corpseHumanoid:FindFirstChildOfClass("Animator")
			if animator then
				animator:Destroy()
			end
		end

		local snapshot = Systems.Body.Snapshots[character]
		local entries = {}

		for _, copy in corpse:GetDescendants() do
			if copy:IsA("BasePart") then
				local id = copy:GetAttribute("CorpseId")
				copy:SetAttribute("CorpseId", nil)
				copy.Anchored = true
				copy.CanCollide = false
				copy.CanQuery = false
				copy.CanTouch = false
				local original = id and originals[id]
				if original then
					copy.CFrame = snapshot and snapshot[original] or original.CFrame
				end
				table.insert(entries, { Part = copy, CFrame = copy.CFrame })
			end
		end

		return corpse, entries
	end

	local function spawnDeathPixels(boxCFrame, boxSize)
		local folder = Workspace:FindFirstChild("DeathEffects")
		if not folder then
			folder = create("Folder", { Name = "DeathEffects", Parent = Workspace })
		end
		for _ = 1, DEATH.PixelCount do
			local offset = Vector3.new(
				(math.random() - 0.5) * boxSize.X * DEATH.PixelSpread,
				(math.random() - 0.5) * boxSize.Y * DEATH.PixelSpread,
				(math.random() - 0.5) * boxSize.Z * DEATH.PixelSpread
			)
			local start = boxCFrame:PointToWorldSpace(offset)
			local pixelSize = DEATH.PixelMinSize + math.random() * (DEATH.PixelMaxSize - DEATH.PixelMinSize)
			local life = DEATH.PixelLifeMin + math.random() * (DEATH.PixelLifeMax - DEATH.PixelLifeMin)
			local rise = DEATH.PixelRiseMin + math.random() * (DEATH.PixelRiseMax - DEATH.PixelRiseMin)
			local pixel = create("Part", {
				Name = "DeathPixel",
				Anchored = true,
				CanCollide = false,
				CanQuery = false,
				CanTouch = false,
				CastShadow = false,
				Material = Enum.Material.Neon,
				Color = DEATH.PixelColors[math.random(#DEATH.PixelColors)],
				Size = Vector3.one * pixelSize,
				CFrame = CFrame.new(start) * CFrame.Angles(0, math.rad(math.random(0, 3) * 90), 0),
				Parent = folder,
			})
			local drift = Vector3.new(
				(math.random() - 0.5) * 2 * DEATH.PixelDrift,
				rise,
				(math.random() - 0.5) * 2 * DEATH.PixelDrift
			)
			TweenService:Create(
				pixel,
				TweenInfo.new(life, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Position = start + drift,
					Orientation = Vector3.new(
						math.random(-180, 180),
						math.random(-180, 180),
						math.random(-180, 180)
					),
					Transparency = 1,
					Size = Vector3.one * pixelSize * 0.5,
				}
			):Play()
			Debris:AddItem(pixel, life + 0.1)
		end
	end

	local function playDeathSequence(character)
		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end

		local corpse, entries = createCorpse(character)
		if not corpse then
			return
		end

		hideOriginal(character)

		create("Highlight", {
			Name = "DeathHighlight",
			Adornee = corpse,
			FillColor = DAMAGE_HIGHLIGHT.Color,
			FillTransparency = DAMAGE_HIGHLIGHT.FillTransparency,
			OutlineTransparency = 1,
			DepthMode = Enum.HighlightDepthMode.Occluded,
			Parent = corpse,
		})

		corpse.Parent = Workspace

		local boxCFrame, boxSize = corpse:GetBoundingBox()
		local pivot = boxCFrame:PointToWorldSpace(Vector3.new(-boxSize.X / 2, -boxSize.Y / 2, 0))
		local axis = boxCFrame.ZVector
		local ground = findGroundHeight(pivot, { character, corpse })
		local gap = math.max(pivot.Y - ground, 0)
		local maxAngle = math.rad(DEATH.TipDegrees)

		local elapsed = 0
		local fallSpeed = 0
		local dropped = 0

		while corpse.Parent do
			local deltaTime = RunService.Heartbeat:Wait()
			elapsed += deltaTime
			local progress = math.clamp(elapsed / DEATH.TipDuration, 0, 1)
			local angle = maxAngle * progress * progress
			if dropped < gap then
				fallSpeed += DEATH.Gravity * deltaTime
				dropped = math.min(dropped + fallSpeed * deltaTime, gap)
			end
			local transform = CFrame.new(pivot - Vector3.new(0, dropped, 0))
				* CFrame.fromAxisAngle(axis, angle)
				* CFrame.new(-pivot)
			for _, entry in entries do
				if entry.Part.Parent then
					entry.Part.CFrame = transform * entry.CFrame
				end
			end
			if progress >= 1 and dropped >= gap then
				break
			end
		end

		task.wait(DEATH.GroundWait)

		if not corpse.Parent then
			return
		end

		local finalCFrame, finalSize = corpse:GetBoundingBox()
		corpse:Destroy()
		spawnDeathPixels(finalCFrame, finalSize)
	end

	Systems.Death = {
		play = playDeathSequence,
	}
end

task.spawn(function()
	for _ = 1, 20 do
		local success = pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
		end)
		if success then
			return
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	local sound = create("Sound", { SoundId = DAMAGE_SOUND.SoundId })
	pcall(ContentProvider.PreloadAsync, ContentProvider, {
		sound,
		HEART_IMAGES.Full,
		HEART_IMAGES.Half,
		HEART_IMAGES.Empty,
		SHIELD.Image,
	})
	sound:Destroy()
end)

screenGui = create("ScreenGui", {
	Name = "MinecraftInventory",
	ResetOnSpawn = false,
	ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
	DisplayOrder = 5,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = playerGui,
})

playerGui.DescendantAdded:Connect(function(descendant)
	setupTargetGuiListener(descendant)
end)

for _, descendant in playerGui:GetDescendants() do
	checkAndRemoveTargetGui(descendant)
end

local crosshair = create("Frame", {
	Name = "Crosshair",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(CROSSHAIR.Size, CROSSHAIR.Size),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = screenGui,
})

for _, barSize in { UDim2.new(1, 0, 0, CROSSHAIR.Thickness), UDim2.new(0, CROSSHAIR.Thickness, 1, 0) } do
	local bar = create("Frame", {
		Name = "CrosshairBar",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = barSize,
		BackgroundColor3 = COLORS.Crosshair,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Parent = crosshair,
	})
	create("UIStroke", {
		Color = COLORS.SlotBorder,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = bar,
	})
end

local heldViewport = create("ViewportFrame", {
	Name = "HeldItem",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.fromScale(1, 1),
	Size = UDim2.fromOffset(HELD.MaxSize, HELD.MaxSize),
	BackgroundTransparency = 1,
	Ambient = Color3.fromRGB(190, 190, 190),
	LightColor = Color3.fromRGB(255, 255, 255),
	LightDirection = Vector3.new(-1, -1, -1),
	Visible = false,
	Parent = screenGui,
})

local heldWorld = create("WorldModel", { Parent = heldViewport })
local heldCamera = create("Camera", { FieldOfView = HELD.FieldOfView, Parent = heldViewport })
heldViewport.CurrentCamera = heldCamera

local hotbarWidth = (CONFIG.HotbarSlots + 1) * CONFIG.SlotSize + CONFIG.HotbarSlots * CONFIG.SlotGap
local slotsRowWidth = CONFIG.HotbarSlots * CONFIG.SlotSize + (CONFIG.HotbarSlots - 1) * CONFIG.SlotGap

local holder = create("Frame", {
	Name = "Holder",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, -CONFIG.BottomMargin),
	Size = UDim2.fromOffset(hotbarWidth, CONFIG.SlotSize),
	BackgroundTransparency = 1,
	Parent = screenGui,
})

local holderScale = create("UIScale", { Parent = holder })

do
	local hotbarBackground = create("Frame", {
		Name = "HotbarBackground",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 6, 1, 6),
		BackgroundColor3 = COLORS.SlotBorder,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		Parent = holder,
	})

	create("UIStroke", {
		Color = COLORS.SlotBorder,
		Thickness = 2,
		Transparency = 0.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = hotbarBackground,
	})
end

local hotbar = create("Frame", {
	Name = "Hotbar",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Parent = holder,
})

create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, CONFIG.SlotGap),
	Parent = hotbar,
})

local xpFill

do
	local xpBar = create("Frame", {
		Name = "ExperienceBar",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 0, -XP.Margin),
		Size = UDim2.fromOffset(slotsRowWidth, XP.Height),
		BackgroundColor3 = XP.Track,
		BorderSizePixel = 0,
		Parent = holder,
	})

	create("UIStroke", {
		Color = COLORS.SlotBorder,
		Thickness = 2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = xpBar,
	})

	xpFill = create("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = XP.Fill,
		BorderSizePixel = 0,
		Visible = false,
		Parent = xpBar,
	})

	create("Frame", {
		Name = "FillShade",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromScale(1, 0.4),
		BackgroundColor3 = XP.FillShade,
		BorderSizePixel = 0,
		Parent = xpFill,
	})
end

local xpLevel = create("TextLabel", {
	Name = "ExperienceLevel",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0, slotsRowWidth / 2, 0, -(XP.Margin + XP.Height + XP.LevelGap)),
	Size = UDim2.fromOffset(100, XP.LevelTextSize + 2),
	BackgroundTransparency = 1,
	Text = "0",
	TextColor3 = XP.Level,
	TextSize = XP.LevelTextSize,
	TextStrokeColor3 = COLORS.SlotBorder,
	TextStrokeTransparency = 0,
	Font = FONT,
	Visible = false,
	ZIndex = 5,
	Parent = holder,
})

local heartStep = CONFIG.HeartSize + CONFIG.HeartGap
local heartsRowWidth = CONFIG.HeartsPerRow * CONFIG.HeartSize + (CONFIG.HeartsPerRow - 1) * CONFIG.HeartGap

local heartsFrame = create("Frame", {
	Name = "Hearts",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 0, -CONFIG.HeartsMargin),
	Size = UDim2.fromOffset(heartsRowWidth, CONFIG.HeartSize),
	BackgroundTransparency = 1,
	Parent = holder,
})

local shieldFrame = create("Frame", {
	Name = "Shields",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 0, -(CONFIG.HeartsMargin + CONFIG.HeartSize + SHIELD.Gap)),
	Size = UDim2.fromOffset(heartsRowWidth, CONFIG.HeartSize),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = holder,
})

local itemNameLabel = create("TextLabel", {
	Name = "ItemName",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 0, -(CONFIG.HeartsMargin + CONFIG.HeartSize + POPUP.Gap)),
	Size = UDim2.fromOffset(hotbarWidth, POPUP.TextSize + 4),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = COLORS.Text,
	TextSize = POPUP.TextSize,
	TextStrokeColor3 = COLORS.SlotBorder,
	TextStrokeTransparency = 1,
	Font = FONT,
	Visible = false,
	ZIndex = 5,
	Parent = holder,
})

addTextShadow(itemNameLabel)

local gridWidth = CONFIG.ExtraColumns * CONFIG.SlotSize + (CONFIG.ExtraColumns - 1) * CONFIG.SlotGap
local gridRows = math.ceil(CONFIG.ExtraSlots / CONFIG.ExtraColumns)
local gridHeight = gridRows * CONFIG.SlotSize + (gridRows - 1) * CONFIG.SlotGap
local windowWidth = gridWidth + CONFIG.WindowPadding * 2
local windowHeight = CONFIG.WindowPadding * 2 + CONFIG.PreviewHeight + CONFIG.WindowGap + gridHeight

local window = create("Frame", {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 0, -(CONFIG.HeartsMargin + CONFIG.HeartSize + CONFIG.WindowMargin)),
	Size = UDim2.fromOffset(windowWidth, windowHeight),
	BackgroundColor3 = COLORS.Panel,
	BackgroundTransparency = 0,
	Active = true,
	Visible = false,
	ZIndex = 10,
	Parent = holder,
})

create("UIStroke", {
	Color = COLORS.SlotBorder,
	Thickness = STROKE.Normal,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = window,
})

addBevel(window, STYLE.WindowBevel, COLORS.SlotLight, COLORS.PanelDark, 10)

local armorGap = 8
local previewX = CONFIG.WindowPadding + CONFIG.SlotSize + armorGap

local previewViewport = create("ViewportFrame", {
	Name = "Preview",
	Position = UDim2.fromOffset(previewX, CONFIG.WindowPadding),
	Size = UDim2.fromOffset(CONFIG.PreviewWidth, CONFIG.PreviewHeight),
	BackgroundColor3 = COLORS.SlotFill,
	BackgroundTransparency = 0,
	Ambient = Color3.fromRGB(190, 190, 190),
	LightColor = Color3.fromRGB(255, 255, 255),
	LightDirection = Vector3.new(-1, -1, -1),
	ZIndex = 10,
	Parent = window,
})

addBevel(previewViewport, STYLE.Bevel, COLORS.SlotDark, COLORS.SlotLight, 11)

local previewWorld = create("WorldModel", { Parent = previewViewport })
local previewCamera = create("Camera", { FieldOfView = 30, Parent = previewViewport })
previewViewport.CurrentCamera = previewCamera

create("TextLabel", {
	Name = "Title",
	Position = UDim2.fromOffset(CONFIG.WindowPadding, windowHeight - CONFIG.WindowPadding - gridHeight - 18),
	Size = UDim2.fromOffset(180, 16),
	BackgroundTransparency = 1,
	Text = "Inventory",
	TextColor3 = COLORS.PanelText,
	TextSize = 14,
	Font = FONT,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 10,
	Parent = window,
})

local deathsLabel = create("TextLabel", {
	Name = "Deaths",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -CONFIG.WindowPadding, 0, CONFIG.WindowPadding),
	Size = UDim2.fromOffset(160, 20),
	BackgroundTransparency = 1,
	Text = "Deaths: 0",
	TextColor3 = COLORS.PanelText,
	TextSize = 14,
	Font = FONT,
	TextXAlignment = Enum.TextXAlignment.Right,
	ZIndex = 10,
	Parent = window,
})

do
	local function createDecorSlot(name, position)
		local frame = create("Frame", {
			Name = name,
			Position = position,
			Size = UDim2.fromOffset(CONFIG.SlotSize, CONFIG.SlotSize),
			BackgroundColor3 = COLORS.SlotFill,
			BorderSizePixel = 0,
			ZIndex = 10,
			Parent = window,
		})
		create("UIStroke", {
			Color = COLORS.SlotBorder,
			Thickness = STROKE.Normal,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = frame,
		})
		addBevel(frame, STYLE.Bevel, COLORS.SlotDark, COLORS.SlotLight, 10)
		return frame
	end

	local armorNames = { "ArmorHead", "ArmorChest", "ArmorLegs", "ArmorFeet" }
	local armorStep = (CONFIG.PreviewHeight - CONFIG.SlotSize) / (#armorNames - 1)
	for index, armorName in armorNames do
		createDecorSlot(
			armorName,
			UDim2.fromOffset(CONFIG.WindowPadding, CONFIG.WindowPadding + (index - 1) * armorStep)
		)
	end

	createDecorSlot(
		"OffHand",
		UDim2.fromOffset(
			previewX + CONFIG.PreviewWidth + armorGap,
			CONFIG.WindowPadding + CONFIG.PreviewHeight - CONFIG.SlotSize
		)
	)

	local craftBlock = CONFIG.SlotSize * 2 + CONFIG.SlotGap
	local resultX = windowWidth - CONFIG.WindowPadding - CONFIG.SlotSize - 20
	local arrowX = resultX - 34
	local craftGridX = arrowX - 12 - craftBlock
	local craftTop = CONFIG.WindowPadding + 22

	create("TextLabel", {
		Name = "CraftingTitle",
		Position = UDim2.fromOffset(craftGridX, CONFIG.WindowPadding),
		Size = UDim2.fromOffset(120, 16),
		BackgroundTransparency = 1,
		Text = "Crafting",
		TextColor3 = COLORS.PanelText,
		TextSize = 14,
		Font = FONT,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 10,
		Parent = window,
	})

	for row = 0, 1 do
		for column = 0, 1 do
			createDecorSlot(
				"CraftInput" .. (row * 2 + column + 1),
				UDim2.fromOffset(
					craftGridX + column * (CONFIG.SlotSize + CONFIG.SlotGap),
					craftTop + row * (CONFIG.SlotSize + CONFIG.SlotGap)
				)
			)
		end
	end

	createDecorSlot(
		"CraftResult",
		UDim2.fromOffset(resultX, craftTop + (craftBlock - CONFIG.SlotSize) / 2)
	)

	local craftArrow = create("Frame", {
		Name = "CraftArrow",
		Position = UDim2.fromOffset(arrowX, craftTop + (craftBlock - 20) / 2),
		Size = UDim2.fromOffset(28, 20),
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = window,
	})

	for _, piece in {
		{ Vector2.new(0, 8), Vector2.new(16, 4) },
		{ Vector2.new(16, 4), Vector2.new(4, 12) },
		{ Vector2.new(20, 6), Vector2.new(4, 8) },
		{ Vector2.new(24, 8), Vector2.new(4, 4) },
	} do
		create("Frame", {
			Name = "ArrowPiece",
			Position = UDim2.fromOffset(piece[1].X, piece[1].Y),
			Size = UDim2.fromOffset(piece[2].X, piece[2].Y),
			BackgroundColor3 = COLORS.SlotFill,
			BorderSizePixel = 0,
			ZIndex = 10,
			Parent = craftArrow,
		})
	end
end

local grid = create("Frame", {
	Name = "Grid",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, CONFIG.WindowPadding, 1, -CONFIG.WindowPadding),
	Size = UDim2.fromOffset(gridWidth, gridHeight),
	BackgroundTransparency = 1,
	ZIndex = 10,
	Parent = window,
})

create("UIGridLayout", {
	CellSize = UDim2.fromOffset(CONFIG.SlotSize, CONFIG.SlotSize),
	CellPadding = UDim2.fromOffset(CONFIG.SlotGap, CONFIG.SlotGap),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = grid,
})

local deathScreen = create("Frame", {
	Name = "DeathScreen",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = COLORS.DeathOverlay,
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 60,
	Parent = screenGui,
})

addTextShadow(create("TextLabel", {
	Name = "DeathTitle",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.4),
	Size = UDim2.fromOffset(500, 60),
	BackgroundTransparency = 1,
	Text = "You Died!",
	TextColor3 = COLORS.Text,
	TextSize = 42,
	TextStrokeColor3 = COLORS.SlotBorder,
	TextStrokeTransparency = 1,
	Font = FONT,
	ZIndex = 61,
	Parent = deathScreen,
}), 3)

local deathScore = create("TextLabel", {
	Name = "DeathScore",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(500, 30),
	BackgroundTransparency = 1,
	RichText = true,
	Text = 'Deaths: <font color="#FFFF55">0</font>',
	TextColor3 = COLORS.Text,
	TextSize = 18,
	TextStrokeColor3 = COLORS.SlotBorder,
	TextStrokeTransparency = 1,
	Font = FONT,
	ZIndex = 61,
	Parent = deathScreen,
})

addTextShadow(deathScore)

local respawnLabel

do
	local respawnButton = create("Frame", {
		Name = "RespawnButton",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.62),
		Size = UDim2.fromOffset(320, 40),
		BackgroundColor3 = COLORS.ButtonFill,
		BorderSizePixel = 0,
		ZIndex = 61,
		Parent = deathScreen,
	})

	create("UIStroke", {
		Color = COLORS.SlotBorder,
		Thickness = STROKE.Normal,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = respawnButton,
	})

	addBevel(respawnButton, STYLE.Bevel, COLORS.ButtonLight, COLORS.ButtonDark, 62)

	respawnLabel = create("TextLabel", {
		Name = "RespawnText",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "Respawning...",
		TextColor3 = COLORS.ButtonDisabledText,
		TextSize = 18,
		TextStrokeTransparency = 1,
		Font = FONT,
		ZIndex = 63,
		Parent = respawnButton,
	})

	addTextShadow(respawnLabel)
end

local tooltipFrame = create("Frame", {
	Name = "Tooltip",
	AnchorPoint = Vector2.new(0, 1),
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	BackgroundColor3 = TOOLTIP.Fill,
	BackgroundTransparency = TOOLTIP.FillTransparency,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = TOOLTIP.ZIndex,
	Parent = screenGui,
})

create("UIGradient", {
	Rotation = 90,
	Color = ColorSequence.new(TOOLTIP.BorderTop, TOOLTIP.BorderBottom),
	Parent = create("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = TOOLTIP.BorderThickness,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = tooltipFrame,
	}),
})

create("UIPadding", {
	PaddingTop = UDim.new(0, TOOLTIP.Padding),
	PaddingBottom = UDim.new(0, TOOLTIP.Padding),
	PaddingLeft = UDim.new(0, TOOLTIP.Padding),
	PaddingRight = UDim.new(0, TOOLTIP.Padding),
	Parent = tooltipFrame,
})

local tooltipLabel = create("TextLabel", {
	Name = "TooltipText",
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = COLORS.Text,
	TextSize = TOOLTIP.TextSize,
	TextStrokeColor3 = SHADOW.Color,
	TextStrokeTransparency = 0.4,
	Font = FONT,
	ZIndex = TOOLTIP.ZIndex + 1,
	Parent = tooltipFrame,
})

local function updateTooltip()
	local tool = hoveredSlot and slotTools[hoveredSlot]
	local dragging = press ~= nil and press.Active
	if tool and not dragging and not isCompactDevice() then
		tooltipLabel.Text = tool.Name
		tooltipFrame.Visible = true
	else
		tooltipFrame.Visible = false
	end
end

local function updateTooltipPosition()
	if not tooltipFrame.Visible then
		return
	end
	local pointer = UserInputService:GetMouseLocation()
	local origin = screenGui.AbsolutePosition
	local x = pointer.X - origin.X + TOOLTIP.Offset.X
	local y = pointer.Y - origin.Y + TOOLTIP.Offset.Y
	local width = tooltipFrame.AbsoluteSize.X
	if x + width > screenGui.AbsoluteSize.X then
		x = pointer.X - origin.X - TOOLTIP.Offset.X - width
	end
	tooltipFrame.Position = UDim2.fromOffset(x, y)
end

local function toggleTool(tool)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not tool or not humanoid or humanoid.Health <= 0 then
		return
	end
	if tool.Parent == character then
		humanoid:UnequipTools()
	else
		humanoid:EquipTool(tool)
	end
end

local function createSlotView(index, parent, zIndex, fillTransparency)
	local button = create("TextButton", {
		Name = "Slot" .. index,
		Size = UDim2.fromOffset(CONFIG.SlotSize, CONFIG.SlotSize),
		BackgroundColor3 = COLORS.SlotFill,
		BackgroundTransparency = fillTransparency,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = index,
		ZIndex = zIndex,
		Parent = parent,
	})

	local stroke = create("UIStroke", {
		Color = COLORS.SlotBorder,
		Thickness = STROKE.Normal,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = button,
	})

	addBevel(button, STYLE.Bevel, COLORS.SlotDark, COLORS.SlotLight, zIndex)

	local icon = create("ImageLabel", {
		Name = "Icon",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.72, 0.72),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		Visible = false,
		ZIndex = zIndex,
		Parent = button,
	})

	local nameLabel = create("TextLabel", {
		Name = "ToolName",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -6, 1, -12),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = COLORS.Text,
		TextStrokeTransparency = 0.3,
		TextWrapped = true,
		TextScaled = true,
		Font = FONT,
		ZIndex = zIndex,
		Parent = button,
	})

	create("UITextSizeConstraint", { MaxTextSize = 10, MinTextSize = 6, Parent = nameLabel })

	local selectorOuter = nil

	if index <= CONFIG.HotbarSlots then
		create("TextLabel", {
			Name = "Key",
			Position = UDim2.fromOffset(4, 3),
			Size = UDim2.fromOffset(12, 12),
			BackgroundTransparency = 1,
			Text = tostring(index % 10),
			TextColor3 = COLORS.Text,
			TextStrokeTransparency = 0.2,
			TextSize = 10,
			Font = FONT,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
			ZIndex = zIndex + 1,
			Parent = button,
		})

		selectorOuter = create("Frame", {
			Name = "SelectorOuter",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 6, 1, 6),
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = zIndex + 3,
			Parent = button,
		})

		create("UIStroke", {
			Color = COLORS.SlotBorder,
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = selectorOuter,
		})
	end

	local hover = create("Frame", {
		Name = "HoverHighlight",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = COLORS.Text,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = zIndex + 2,
		Parent = button,
	})

	button.Activated:Connect(function()
		toggleTool(slotTools[index])
	end)

	button.MouseEnter:Connect(function()
		hoveredSlot = index
		hover.Visible = true
		updateTooltip()
	end)

	button.MouseLeave:Connect(function()
		if hoveredSlot == index then
			hoveredSlot = nil
		end
		hover.Visible = false
		updateTooltip()
	end)

	slotViews[index] = {
		Button = button,
		Stroke = stroke,
		Icon = icon,
		NameLabel = nameLabel,
		SelectorOuter = selectorOuter,
		BaseZ = zIndex,
	}
end

for index = 1, CONFIG.HotbarSlots do
	createSlotView(index, hotbar, 1, STYLE.HotbarFillTransparency)
end

for index = CONFIG.HotbarSlots + 1, TOTAL_SLOTS do
	createSlotView(index, grid, 10, 0)
end

local dotsButton = create("TextButton", {
	Name = "More",
	Size = UDim2.fromOffset(CONFIG.SlotSize, CONFIG.SlotSize),
	BackgroundColor3 = COLORS.SlotFill,
	BackgroundTransparency = STYLE.HotbarFillTransparency,
	AutoButtonColor = false,
	Text = "...",
	TextColor3 = COLORS.Text,
	TextSize = 18,
	TextStrokeTransparency = 0.2,
	Font = FONT,
	LayoutOrder = CONFIG.HotbarSlots + 1,
	Parent = hotbar,
})

local dotsStroke = create("UIStroke", {
	Color = COLORS.SlotBorder,
	Thickness = STROKE.Normal,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = dotsButton,
})

addBevel(dotsButton, STYLE.Bevel, COLORS.SlotDark, COLORS.SlotLight, 1)

local function clearPreview()
	if previewModel then
		previewModel:Destroy()
		previewModel = nil
	end
end

local function buildPreview(character)
	local archivable = character.Archivable
	character.Archivable = true
	local clone = character:Clone()
	character.Archivable = archivable
	if not clone then
		return
	end

	for _, descendant in clone:GetDescendants() do
		if
			descendant:IsA("BaseScript")
			or descendant:IsA("Tool")
			or descendant:IsA("Sound")
			or descendant:IsA("BillboardGui")
			or descendant:IsA("Highlight")
			or (descendant:IsA("Model") and descendant.Name == Systems.Body.ModelName)
		then
			descendant:Destroy()
		end
	end

	local cloneHumanoid = clone:FindFirstChildOfClass("Humanoid")
	local root = clone:FindFirstChild("HumanoidRootPart")
	if not cloneHumanoid or not root then
		clone:Destroy()
		return
	end

	clearPreview()

	cloneHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	cloneHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	root.Anchored = true
	clone:PivotTo(CFrame.new(0, 0, 0))
	clone.Parent = previewWorld
	previewModel = clone

	local boxCFrame, boxSize = clone:GetBoundingBox()
	local halfFov = math.rad(previewCamera.FieldOfView / 2)
	local distance = (boxSize.Y / 2) / math.tan(halfFov) * 1.1 + boxSize.Z / 2
	local angle = math.rad(20)
	local center = boxCFrame.Position
	previewCamera.CFrame = CFrame.lookAt(
		center + Vector3.new(math.sin(angle), 0.1, -math.cos(angle)) * distance,
		center
	)

	local animator = cloneHumanoid:FindFirstChildOfClass("Animator") or create("Animator", { Parent = cloneHumanoid })
	local animation = create("Animation", { AnimationId = IDLE_ANIMATIONS[cloneHumanoid.RigType] })
	local track = animator:LoadAnimation(animation)
	track.Looped = true
	track:Play()
end

local function refreshPreview()
	local character = player.Character
	if character and character:FindFirstChildOfClass("Humanoid") then
		buildPreview(character)
	else
		clearPreview()
	end
end

local function setWindowOpen(open)
	window.Visible = open
	dotsStroke.Color = open and COLORS.Selected or COLORS.SlotBorder
	dotsStroke.Thickness = open and STROKE.Selected or STROKE.Normal
	if open then
		refreshPreview()
	else
		clearPreview()
	end
end

dotsButton.Activated:Connect(function()
	setWindowOpen(not window.Visible)
end)

local function updateScale()
	local size = screenGui.AbsoluteSize
	if size.X <= 0 or size.Y <= 0 then
		return
	end
	local widthFraction = isCompactDevice() and SCALE.TouchHotbarWidth or SCALE.DesktopHotbarWidth
	local hotbarScale = math.min(
		size.X * widthFraction / hotbarWidth,
		size.Y * SCALE.HotbarHeight / CONFIG.SlotSize
	)
	holderScale.Scale = math.clamp(hotbarScale, SCALE.Min, 1)
	local heldSize = math.clamp(size.Y * HELD.ScreenFraction, HELD.MinSize, HELD.MaxSize)
	heldViewport.Size = UDim2.fromOffset(heldSize, heldSize)
end

local function updateHudLayout(rows)
	local heartsTop = CONFIG.HeartsMargin + CONFIG.HeartSize + (rows - 1) * heartStep
	local stackTop = heartsTop
	if shieldFrame.Visible then
		shieldFrame.Position = UDim2.new(0, 0, 0, -(heartsTop + SHIELD.Gap))
		stackTop = heartsTop + SHIELD.Gap + CONFIG.HeartSize
	end
	itemNameLabel.Position = UDim2.new(0.5, 0, 0, -(stackTop + POPUP.Gap))
	window.Position = UDim2.new(0.5, 0, 0, -(stackTop + CONFIG.WindowMargin))
end

local function getHeart(index)
	local heart = hearts[index]
	if heart then
		return heart
	end
	local column = (index - 1) % CONFIG.HeartsPerRow
	local row = (index - 1) // CONFIG.HeartsPerRow
	local base = { X = column * heartStep, Y = -row * heartStep }
	heartBases[index] = base
	heart = create("ImageLabel", {
		Name = "Heart" .. index,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, base.X, 1, base.Y),
		Size = UDim2.fromOffset(CONFIG.HeartSize, CONFIG.HeartSize),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		Image = HEART_IMAGES.Empty,
		Parent = heartsFrame,
	})
	hearts[index] = heart
	return heart
end

local function getHudShield(index)
	local icon = hudShields[index]
	if icon then
		return icon
	end
	icon = create("ImageLabel", {
		Name = "Shield" .. index,
		Position = UDim2.fromOffset((index - 1) * heartStep, 0),
		Size = UDim2.fromOffset(CONFIG.HeartSize, CONFIG.HeartSize),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		Image = SHIELD.Image,
		Parent = shieldFrame,
	})
	hudShields[index] = icon
	return icon
end

local function applyHeartOffsets()
	local waving = os.clock() < waveUntil
	local cycle = math.max(visibleHearts, 1) + RECOVERY.IdleSteps
	local jumping = waving and (waveStep % cycle) + 1 or 0
	for index, heart in hearts do
		local base = heartBases[index]
		local offset = 0
		if shaking then
			offset += math.random(-SHAKE.Amplitude, SHAKE.Amplitude)
		end
		if index == jumping then
			offset -= RECOVERY.JumpHeight
		end
		heart.Position = UDim2.new(0, base.X, 1, base.Y + offset)
	end
end

local function updateHeartAnimation(deltaTime)
	local active = shaking or os.clock() < waveUntil
	if not active then
		if animating then
			animating = false
			waveStep = 0
			animationElapsed = 0
			applyHeartOffsets()
		end
		return
	end
	animating = true
	animationElapsed += deltaTime
	if animationElapsed >= SHAKE.Interval then
		animationElapsed = 0
		waveStep += 1
		applyHeartOffsets()
	end
end

local function registerHealing(health)
	local gain = health - lastHudHealth
	lastHudHealth = health
	if gain <= 0 or not currentHumanoid then
		return
	end
	local now = os.clock()
	table.insert(recoverySamples, { Time = now, Amount = gain })
	while recoverySamples[1] and now - recoverySamples[1].Time > RECOVERY.Window do
		table.remove(recoverySamples, 1)
	end
	local total = 0
	for _, sample in recoverySamples do
		total += sample.Amount
	end
	local rate = total / math.max(currentHumanoid.MaxHealth, 1) / RECOVERY.Window
	if rate >= RECOVERY.FastRate then
		waveUntil = now + RECOVERY.Duration
	end
end

local function renderHearts()
	local totalHearts, halves = getHeartCounts(currentHumanoid)

	for index = 1, totalHearts do
		local heart = getHeart(index)
		heart.Visible = true
		heart.Image = getHeartImage(index, halves)
	end

	for index = totalHearts + 1, #hearts do
		hearts[index].Visible = false
	end

	visibleHearts = totalHearts
	shaking = isLowHealth(currentHumanoid)

	return math.max(math.ceil(totalHearts / CONFIG.HeartsPerRow), 1)
end

local function renderShields()
	local count = currentHumanoid and getShieldIcons(currentHumanoid) or 0

	for index = 1, count do
		getHudShield(index).Visible = true
	end

	for index = count + 1, #hudShields do
		hudShields[index].Visible = false
	end

	shieldFrame.Visible = count > 0
end

local function renderHud()
	local rows = renderHearts()
	renderShields()
	updateHudLayout(rows)
end

local function renderExperience()
	local level = player:GetAttribute(XP.LevelAttribute)
	local progress = player:GetAttribute(XP.ProgressAttribute)
	level = type(level) == "number" and math.max(math.floor(level), 0) or 0
	progress = type(progress) == "number" and math.clamp(progress, 0, 1) or 0
	xpFill.Size = UDim2.fromScale(progress, 1)
	xpFill.Visible = progress > 0
	xpLevel.Text = tostring(level)
	xpLevel.Visible = level > 0
end

local function renderSlots()
	local character = player.Character
	for index, view in slotViews do
		local tool = slotTools[index]
		if tool then
			local hasTexture = tool.TextureId ~= ""
			view.Icon.Image = tool.TextureId
			view.Icon.Visible = hasTexture
			view.NameLabel.Text = hasTexture and "" or tool.Name
		else
			view.Icon.Image = ""
			view.Icon.Visible = false
			view.NameLabel.Text = ""
		end
		local dragged = press ~= nil and press.Active and press.Index == index
		local dim = dragged and DRAG.DimTransparency or 0
		view.Icon.ImageTransparency = dim
		view.NameLabel.TextTransparency = dim
		local selected = tool ~= nil and character ~= nil and tool.Parent == character
		view.Stroke.Color = selected and COLORS.Selected or COLORS.SlotBorder
		view.Stroke.Thickness = selected and STROKE.Selected or STROKE.Normal
		view.Button.ZIndex = view.BaseZ + (selected and 5 or 0)
		if view.SelectorOuter then
			view.SelectorOuter.Visible = selected
		end
	end
	updateTooltip()
end

local function getPointer(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(input.Position.X, input.Position.Y) + GuiService:GetGuiInset()
	end
	return UserInputService:GetMouseLocation()
end

local function getSlotAtPoint(point)
	for index, view in slotViews do
		if index <= CONFIG.HotbarSlots or window.Visible then
			local position = view.Button.AbsolutePosition
			local size = view.Button.AbsoluteSize
			if
				point.X >= position.X
				and point.X <= position.X + size.X
				and point.Y >= position.Y
				and point.Y <= position.Y + size.Y
			then
				return index
			end
		end
	end
	return nil
end

local function createGhost(index)
	local source = slotViews[index].Button
	local ghost = source:Clone()
	ghost.Name = "DragGhost"
	ghost.AnchorPoint = Vector2.new(0.5, 0.5)
	ghost.Size = UDim2.fromOffset(source.AbsoluteSize.X, source.AbsoluteSize.Y)
	ghost.BackgroundTransparency = DRAG.GhostTransparency
	ghost.ZIndex = DRAG.GhostZIndex
	ghost.Interactable = false
	ghost.Active = false
	local stroke = ghost:FindFirstChildOfClass("UIStroke")
	if stroke then
		stroke.Color = COLORS.Selected
		stroke.Thickness = STROKE.Selected
	end
	for _, child in ghost:GetChildren() do
		if child.Name == "HoverHighlight" or child.Name == "SelectorOuter" then
			child.Visible = false
		end
	end
	ghost.Parent = screenGui
	return ghost
end

local function updateGhost()
	if not press or not press.Active then
		return
	end
	local pointer = getPointer(press.Input)
	local origin = screenGui.AbsolutePosition
	press.Ghost.Position = UDim2.fromOffset(pointer.X - origin.X, pointer.Y - origin.Y)
end

local function beginDrag(current)
	if not slotTools[current.Index] or current.Input.UserInputState == Enum.UserInputState.End then
		press = nil
		return
	end
	current.Active = true
	current.Ghost = createGhost(current.Index)
	updateGhost()
	renderSlots()
end

local function swapSlots(first, second)
	slotTools[first], slotTools[second] = slotTools[second], slotTools[first]
	renderSlots()
end

local function endDrag()
	local current = press
	press = nil
	if not current or not current.Active then
		return
	end
	local target = getSlotAtPoint(getPointer(current.Input))
	current.Ghost:Destroy()
	if target and target ~= current.Index then
		swapSlots(current.Index, target)
	else
		renderSlots()
	end
end

local function bindSlotDrag(index, button)
	button.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
			return
		end
		if press or not slotTools[index] then
			return
		end
		local current = { Index = index, Input = input, Active = false }
		press = current
		task.delay(DRAG.HoldTime, function()
			if press == current then
				beginDrag(current)
			end
		end)
	end)
end

for index, view in slotViews do
	bindSlotDrag(index, view.Button)
end

local function collectTools()
	local tools = {}
	local function collect(container)
		if not container then
			return
		end
		for _, child in container:GetChildren() do
			if child:IsA("Tool") then
				table.insert(tools, child)
			end
		end
	end
	collect(player:FindFirstChildOfClass("Backpack"))
	collect(player.Character)
	return tools
end

local function assignTool(tool)
	for index = 1, TOTAL_SLOTS do
		if not slotTools[index] then
			slotTools[index] = tool
			break
		end
	end
	if not trackedTools[tool] then
		trackedTools[tool] = true
		tool:GetPropertyChangedSignal("TextureId"):Connect(renderSlots)
		tool:GetPropertyChangedSignal("Name"):Connect(renderSlots)
	end
end

local function syncTools()
	local list = collectTools()
	local owned = {}
	for _, tool in list do
		owned[tool] = true
	end

	local assigned = {}
	for index = 1, TOTAL_SLOTS do
		local tool = slotTools[index]
		if tool then
			if owned[tool] then
				assigned[tool] = true
			else
				slotTools[index] = nil
			end
		end
	end

	for _, tool in list do
		if not assigned[tool] then
			assignTool(tool)
		end
	end
end

local function scheduleSync()
	if syncQueued then
		return
	end
	syncQueued = true
	task.defer(function()
		syncQueued = false
		syncTools()
		renderSlots()
	end)
end

local function watchContainer(container)
	if watched[container] then
		return
	end
	watched[container] = true
	container.ChildAdded:Connect(scheduleSync)
	container.ChildRemoved:Connect(scheduleSync)
end

local function showItemName(name)
	itemNameToken += 1
	local token = itemNameToken
	if itemNameTween then
		itemNameTween:Cancel()
		itemNameTween = nil
	end
	itemNameLabel.Text = name
	itemNameLabel.TextTransparency = 0
	itemNameLabel.TextStrokeTransparency = 1
	itemNameLabel.Visible = true
	task.delay(POPUP.Hold, function()
		if itemNameToken ~= token then
			return
		end
		local tween = TweenService:Create(
			itemNameLabel,
			TweenInfo.new(POPUP.Fade),
			{ TextTransparency = 1, TextStrokeTransparency = 1 }
		)
		itemNameTween = tween
		tween.Completed:Once(function()
			if itemNameToken == token then
				itemNameLabel.Visible = false
			end
		end)
		tween:Play()
	end)
end

local function runRespawnCountdown()
	respawnToken += 1
	local token = respawnToken
	task.spawn(function()
		local remaining = Players.RespawnTime
		while respawnToken == token and remaining > 0 do
			respawnLabel.Text = string.format("Respawning in %d...", math.ceil(remaining))
			task.wait(0.25)
			remaining -= 0.25
		end
		if respawnToken == token then
			respawnLabel.Text = "Respawning..."
		end
	end)
end

local function setDeathScreen(visible)
	if deathScreenTween then
		deathScreenTween:Cancel()
		deathScreenTween = nil
	end
	if visible then
		runRespawnCountdown()
		deathScore.Text = 'Deaths: <font color="#FFFF55">' .. deaths .. "</font>"
		deathScreen.BackgroundTransparency = 1
		deathScreen.Visible = true
		deathScreenTween = TweenService:Create(
			deathScreen,
			TweenInfo.new(DEATH.ScreenFade),
			{ BackgroundTransparency = DEATH.ScreenTransparency }
		)
		deathScreenTween:Play()
	elseif deathScreen.Visible then
		respawnToken += 1
		local tween = TweenService:Create(
			deathScreen,
			TweenInfo.new(DEATH.ScreenFade),
			{ BackgroundTransparency = 1 }
		)
		deathScreenTween = tween
		tween.Completed:Once(function(state)
			if state == Enum.PlaybackState.Completed then
				deathScreen.Visible = false
			end
		end)
		tween:Play()
	end
end

do
	local HELD_BASE = CFrame.Angles(
		math.rad(HELD.BaseRotation.X),
		math.rad(HELD.BaseRotation.Y),
		math.rad(HELD.BaseRotation.Z)
	)

	local heldConnections = {}
	local heldParts = {}
	local heldTool = nil
	local heldModel = nil
	local heldRadius = 1
	local heldEquipStart = 0
	local heldSwingStart = -1000
	local walkTime = 0
	local walkIntensity = 0
	local worldHidden = false

	local function clearHeld()
		for _, connection in heldConnections do
			connection:Disconnect()
		end
		table.clear(heldConnections)
		if heldModel then
			heldModel:Destroy()
			heldModel = nil
		end
		for _, part in heldParts do
			if part.Parent then
				part.LocalTransparencyModifier = 0
			end
		end
		table.clear(heldParts)
		heldTool = nil
		worldHidden = false
		heldViewport.Visible = false
	end

	local function buildHeldModel(tool)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end

		local model = create("Model", { Name = "HeldModel", Parent = heldWorld })
		local rootCFrame = root.CFrame

		for _, descendant in tool:GetDescendants() do
			if descendant:IsA("BasePart") then
				table.insert(heldParts, descendant)
				local copy = descendant:Clone()
				for _, child in copy:GetDescendants() do
					if shouldStrip(child) then
						child:Destroy()
					end
				end
				copy.Anchored = true
				copy.CanCollide = false
				copy.CanQuery = false
				copy.CanTouch = false
				copy.CFrame = rootCFrame:ToObjectSpace(descendant.CFrame)
				copy.Parent = model
			end
		end

		if #model:GetChildren() == 0 then
			model:Destroy()
			return
		end

		local boxCFrame, boxSize = model:GetBoundingBox()
		model:TranslateBy(-boxCFrame.Position)
		model.WorldPivot = CFrame.new()

		local radius = math.max(boxSize.Magnitude / 2, 0.1)
		local distance = radius / math.sin(math.rad(heldCamera.FieldOfView / 2)) * HELD.Margin
		heldCamera.CFrame = CFrame.lookAt(Vector3.new(0, 0, distance), Vector3.zero)

		heldModel = model
		heldRadius = radius
		heldEquipStart = os.clock()
	end

	local function setHeldTool(tool)
		clearHeld()
		heldTool = tool
		heldEquipStart = os.clock()
		table.insert(heldConnections, tool.Activated:Connect(function()
			heldSwingStart = os.clock()
		end))
		task.delay(HELD.BuildDelay, function()
			if heldTool == tool and tool.Parent == player.Character then
				buildHeldModel(tool)
			end
		end)
	end

	local function onToolEquipped(tool)
		setHeldTool(tool)
		showItemName(tool.Name)
	end

	local function updateHeldItem(deltaTime)
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local alive = humanoid ~= nil and root ~= nil and humanoid.Health > 0
		local firstPerson = isFirstPerson()

		crosshair.Visible = alive and firstPerson

		local show = alive
			and firstPerson
			and heldModel ~= nil
			and heldTool ~= nil
			and heldTool.Parent == character

		if heldViewport.Visible ~= show then
			heldViewport.Visible = show
		end

		if show then
			for _, part in heldParts do
				if part.Parent then
					part.LocalTransparencyModifier = 1
				end
			end
			worldHidden = true
		elseif worldHidden then
			worldHidden = false
			for _, part in heldParts do
				if part.Parent then
					part.LocalTransparencyModifier = 0
				end
			end
		end

		if not show then
			return
		end

		local velocity = root.AssemblyLinearVelocity
		local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
		local grounded = humanoid.FloorMaterial ~= Enum.Material.Air
		local target = grounded and math.clamp(speed / HELD.WalkSpeedReference, 0, 1) or 0
		walkIntensity += (target - walkIntensity) * math.min(deltaTime * HELD.BlendSpeed, 1)
		walkTime += deltaTime * speed * HELD.StepRate

		local now = os.clock()
		local radius = heldRadius
		local equip = math.clamp((now - heldEquipStart) / HELD.EquipTime, 0, 1)
		local rise = 1 - (1 - equip) ^ 3
		local swing = math.clamp((now - heldSwingStart) / HELD.SwingTime, 0, 1)
		local swingArc = swing < 1 and math.sin(swing * math.pi) or 0

		local bobX = math.sin(walkTime) * radius * HELD.BobX * walkIntensity
		local bobY = -math.abs(math.cos(walkTime)) * radius * HELD.BobY * walkIntensity
			+ math.sin(now * 1.6) * radius * 0.012
		local sway = math.sin(walkTime) * math.rad(HELD.SwayDegrees) * walkIntensity
		local lift = -(1 - rise) * radius * HELD.EquipDrop + swingArc * radius * 0.15

		heldModel:PivotTo(
			CFrame.new(bobX, bobY + lift, -swingArc * radius * 0.2)
				* HELD_BASE
				* CFrame.Angles(
					-swingArc * math.rad(HELD.SwingPitch),
					-swingArc * math.rad(HELD.SwingYaw),
					sway
				)
		)
	end

	Systems.Held = {
		Clear = clearHeld,
		Set = setHeldTool,
		Equipped = onToolEquipped,
		Update = updateHeldItem,
		Current = function()
			return heldTool
		end,
	}
end

local function applyHurtTilt()
	local elapsed = os.clock() - hurtStart
	if elapsed >= HURT.Duration then
		return
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local alpha = 1 - elapsed / HURT.Duration
	camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.rad(HURT.Roll) * hurtSign * alpha)
end

local function bindHumanoid(humanoid)
	for _, connection in healthConnections do
		connection:Disconnect()
	end
	table.clear(healthConnections)
	table.clear(recoverySamples)
	currentHumanoid = humanoid
	lastHudHealth = humanoid.Health
	waveUntil = 0
	waveStep = 0
	Systems.Held.Clear()
	setDeathScreen(false)
	local character = humanoid.Parent
	table.insert(healthConnections, humanoid.HealthChanged:Connect(function(health)
		registerHealing(health)
		renderHud()
	end))
	table.insert(healthConnections, humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(renderHud))
	table.insert(healthConnections, humanoid:GetAttributeChangedSignal(SHIELD.Attribute):Connect(renderHud))
	table.insert(healthConnections, humanoid.Died:Connect(function()
		deaths += 1
		deathsLabel.Text = "Deaths: " .. deaths
		Systems.Held.Clear()
		setDeathScreen(true)
	end))
	if character then
		table.insert(healthConnections, character.ChildAdded:Connect(function(child)
			if child:IsA("ForceField") then
				renderHud()
			elseif child:IsA("Tool") then
				Systems.Held.Equipped(child)
			end
		end))
		table.insert(healthConnections, character.ChildRemoved:Connect(function(child)
			if child:IsA("ForceField") then
				renderHud()
			elseif child:IsA("Tool") and child == Systems.Held.Current() then
				Systems.Held.Clear()
			end
		end))
		local equipped = character:FindFirstChildOfClass("Tool")
		if equipped then
			Systems.Held.Set(equipped)
		end
	end
	renderHud()
end

local function playDamageSound(character)
	local anchor = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
	if not anchor then
		return
	end
	local sound = create("Sound", {
		Name = "DamageSound",
		SoundId = DAMAGE_SOUND.SoundId,
		Volume = DAMAGE_SOUND.Volume,
		RollOffMode = Enum.RollOffMode.Linear,
		RollOffMinDistance = DAMAGE_SOUND.MinDistance,
		RollOffMaxDistance = DAMAGE_SOUND.MaxDistance,
		Parent = anchor,
	})
	sound.Ended:Once(function()
		sound:Destroy()
	end)
	Debris:AddItem(sound, 10)
	sound:Play()
end

local function showDamageHighlight(character)
	local highlight = character:FindFirstChild("DamageHighlight")
	if not highlight then
		highlight = create("Highlight", {
			Name = "DamageHighlight",
			Adornee = character,
			FillColor = DAMAGE_HIGHLIGHT.Color,
			FillTransparency = DAMAGE_HIGHLIGHT.FillTransparency,
			OutlineTransparency = 1,
			DepthMode = Enum.HighlightDepthMode.Occluded,
			Enabled = false,
			Parent = character,
		})
	end
	highlight.Enabled = true
	local token = (highlightTokens[character] or 0) + 1
	highlightTokens[character] = token
	task.delay(DAMAGE_HIGHLIGHT.Duration, function()
		if highlightTokens[character] == token and highlight.Parent then
			highlight.Enabled = false
		end
	end)
end

local function watchDamage(character, humanoid)
	local lastHealth = humanoid.Health
	local gains = {}
	humanoid.HealthChanged:Connect(function(health)
		local now = os.clock()
		while gains[1] and now - gains[1].Time > RECOVERY.SoundGrace do
			table.remove(gains, 1)
		end
		local delta = health - lastHealth
		lastHealth = health
		if delta > 0 then
			table.insert(gains, { Time = now, Amount = delta })
		elseif delta < 0 then
			local recovered = 0
			for _, gain in gains do
				recovered += gain.Amount
			end
			if -delta > recovered then
				playDamageSound(character)
				showDamageHighlight(character)
				if character == player.Character then
					hurtStart = now
					hurtSign = math.random(0, 1) * 2 - 1
				end
			end
		end
	end)
end

local function setupCharacter(targetPlayer, character)
	for _, descendant in character:GetDescendants() do
		checkAndRemoveBillboard(descendant)
		checkAndRemoveTargetGui(descendant)
	end

	local humanoid = character:WaitForChild("Humanoid", 10)
	if not humanoid then
		return
	end

	humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	watchDamage(character, humanoid)

	Systems.Body.Live[character] = humanoid
	Systems.Body.capturePose(character)

	character.ChildAdded:Connect(function(child)
		if Systems.Body.isRelevant(child) then
			Systems.Body.scheduleRefresh(character)
		end
	end)
	character.ChildRemoved:Connect(function(child)
		if Systems.Body.isRelevant(child) then
			Systems.Body.scheduleRefresh(character)
		end
	end)
	Systems.Body.scheduleRefresh(character)

	humanoid.Died:Once(function()
		task.spawn(Systems.Death.play, character)
	end)

	if targetPlayer == player then
		watchContainer(character)
		bindHumanoid(humanoid)
		scheduleSync()
		if window.Visible then
			task.spawn(function()
				if not player:HasAppearanceLoaded() then
					player.CharacterAppearanceLoaded:Wait()
				end
				if window.Visible then
					refreshPreview()
				end
			end)
		end
	else
		Systems.Overhead.create(targetPlayer, character, humanoid)
	end
end

local function trackPlayer(targetPlayer)
	targetPlayer.CharacterAdded:Connect(function(character)
		setupCharacter(targetPlayer, character)
	end)
	if targetPlayer.Character then
		task.spawn(setupCharacter, targetPlayer, targetPlayer.Character)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	local index = KEY_SLOTS[input.KeyCode]
	if index then
		toggleTool(slotTools[index])
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if press and press.Active and (input.UserInputType == Enum.UserInputType.MouseMovement or input == press.Input) then
		updateGhost()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if not press then
		return
	end
	local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
		and press.Input.UserInputType == Enum.UserInputType.MouseButton1
	if isMouse or input == press.Input then
		endDrag()
	end
end)

player.ChildAdded:Connect(function(child)
	if child:IsA("Backpack") then
		watchContainer(child)
		scheduleSync()
	end
end)

player:GetAttributeChangedSignal(XP.LevelAttribute):Connect(renderExperience)
player:GetAttributeChangedSignal(XP.ProgressAttribute):Connect(renderExperience)

screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)
UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(updateScale)
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(updateScale)
RunService.RenderStepped:Connect(Systems.Overhead.update)
RunService.RenderStepped:Connect(updateHeartAnimation)
RunService.RenderStepped:Connect(updateTooltipPosition)
RunService.Heartbeat:Connect(Systems.Body.updatePoseSnapshots)
RunService:BindToRenderStep("InventoryHurtTilt", Enum.RenderPriority.Camera.Value + 1, applyHurtTilt)
RunService:BindToRenderStep("InventoryHeldItem", Enum.RenderPriority.Camera.Value + 2, Systems.Held.Update)
RunService:BindToRenderStep("InventoryBlockBodies", Enum.RenderPriority.Camera.Value + 3, Systems.Body.updateBodies)

Players.PlayerAdded:Connect(trackPlayer)

local existingBackpack = player:FindFirstChildOfClass("Backpack")
if existingBackpack then
	watchContainer(existingBackpack)
end

updateScale()
renderHud()
renderExperience()
scheduleSync()

for _, otherPlayer in Players:GetPlayers() do
	trackPlayer(otherPlayer)
end
