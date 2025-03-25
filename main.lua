local g = game ; repeat task.wait(1) until g:IsLoaded()
local s = script
local sp = s.Parent

local ws = g:GetService("Workspace")
local uis = g:GetService("UserInputService")
local reps = g:GetService("ReplicatedStorage")
local runs = g:GetService("RunService")
local plrs = g:GetService("Players")
local tween = g:GetService("TweenService")
local https = g:GetService("HttpService")

local plr = plrs.LocalPlayer
local cam = ws.Camera
local mouse = plr:GetMouse()
local terrain = ws.Terrain

local lib =loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/HypersXenon/Gui-Library/refs/heads/main/inventory.lua"))()


local options = {
	aimbot = {
		player = false;
		ai = false;
		keybind = Enum.KeyCode.C
	};
	fov = {
		toggle = false;
		radius = 250;
		color = Color3.fromRGB(85, 85, 255)
	};
	esp = {
		player = {
			toggle = false;
			color = Color3.fromRGB(255 , 255 , 255)
		};
		ai = {
			toggle = false;
			color = Color3.fromRGB(255 , 255 , 255)
		};
	};
	whitelist = {};
	keybind = Enum.KeyCode.RightAlt
}
local cache = {
	esp = {}
}


do ---<<FOV Setup>>
	local fov = Drawing.new("Circle")
	fov.Filled = false
	fov.Radius = options.fov.radius
	fov.Color = options.fov.color
	cache.fov = fov
end

local win = lib:CreateWindow({
	Title = `Project Delta`;
	SubTitle = `dugdig`;
	TabWidth = 160;
	Size = UDim2.fromOffset(580, 460);
	Acrylic = false;
	Theme = "Amethyst";
	MinimizeKey = options.keybind
})
local win2 = lib2.new()

local tabs = {
	main = win:AddTab({ Title = "Main", Icon = "home" }),
	esp = win:AddTab({ Title = "Esp", Icon = "eye" }),
	settings = win:AddTab({ Title = "Settings", Icon = "settings" })
}
local methods = {
	["Clothing"] = win2:createImage();
	["Inventory"] = win2:createImage();
}

do ---<< main >>---
	local tab = tabs.main
	do ---<< Aimbot >>---
		tab:AddSection("Aimbot")
		tab:AddToggle("Toggle", {Title = "Aimbot Player", Default = options.aimbot.player , Callback = function(va)
			options.aimbot.player = va
		end})
		tab:AddToggle("Toggle", {Title = "Aimbot Ai", Default = options.aimbot.ai , Callback = function(va)
			options.aimbot.ai = va
		end})

		tab:AddKeybind("Keybind", {
			Title = "Aimbot Keybind",
			Mode = "Toggle",
			Default = options.aimbot.keybind.Name,
			ChangedCallback = function( va )
				options.aimbot.keybind = va
			end
		})
	end

	do ---<< FOV >>---
		tab:AddSection("FOV")
		tab:AddToggle("Toggle", {Title = "Show FOV", Default = options.fov.toggle , Callback = function(va)
			options.fov.toggle = va
		end})

		tab:AddSlider("Slider", {
			Title = "Radius",
			Description = "",
			Default = options.fov.radius,
			Min = 100,
			Max = 1000,
			Rounding = 0,
			Callback = function( va )
				options.fov.radius = va
			end
		})
		tab:AddColorpicker("Colorpicker", {
			Title = "Color",
			Default = options.fov.color,
			Callback = function( va )
				options.fov.color = va
			end,
		})
	end

	do ---<< Mic >>---
		tab:AddSection("Mic")
		tab:AddButton({
			Title = "Remove Glass",
			Description = "your game has lag 1-5s.",
			Callback = function()
				local s , res = pcall(function()
					local config = {
						size = 2048;
					}
					local pos = plr.Character:FindFirstChild("HumanoidRootPart").Position
					local si = Vector3.new( config.size , 250 , config.size )
					local region = Region3.new(
						pos - si/2,
						pos + si/2
					)
					terrain:ReplaceMaterial(region, 4,  Enum.Material.Grass, Enum.Material.LeafyGrass)
				end)
				if s then
					lib:Notify({
						Title = "Notification",
						Content = "Remove Glass",
						SubContent = "FINISH!!!",
						Duration = 5
					})
				else
					lib:Notify({
						Title = "Notification",
						Content = "Remove Glass",
						SubContent = "FAIL!!!",
						Duration = 5
					})
				end
			end
		})
	end
end
do ---<< esp >>---
	local tab = tabs.esp
	tab:AddSection("Player")

	tab:AddToggle("Toggle", {Title = "Enabled", Default = options.esp.player.toggle , Callback = function(va)
		options.esp.player.toggle = va
	end})
	tab:AddColorpicker("Colorpicker", {
		Title = "Color",
		Default = options.esp.player.color,
		Callback = function( va )
			options.esp.player.color = va
		end,
	})

	tab:AddSection("Ai")
	tab:AddToggle("Toggle", {Title = "Enabled", Default = options.esp.ai.toggle , Callback = function(va)
		options.esp.ai.toggle = va
	end})
	tab:AddColorpicker("Colorpicker", {
		Title = "Color",
		Default = options.esp.ai.color,
		Callback = function( va )
			options.esp.ai.color = va
		end,
	})
end

do ---<< settings >>---
	local tab = tabs.settings

	do  ---<< Interface >>---
		tab:AddSection("Interface")
		tab:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "makes the interface transparent",
			Default = lib.Transparency,
			Callback = function( va )
				lib:ToggleTransparency( va )
			end
		})

		lib.MinimizeKeybind = tab:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = options.keybind.Name })
	end

	do  ---<< Theme >>---
		tab:AddSection("Theme")
		tab:AddDropdown("Theme", {
			Title = "Theme",
			Description = "changes the interface theme",
			Values = lib.Themes,
			Default = lib.Theme,
			Callback = function( va )
				lib:SetTheme( va )
			end
		})
	end
end

task.defer(function() ---<< remove tree >>---
	ws:WaitForChild("SpawnerZones" , math.huge)
	ws.SpawnerZones:WaitForChild("Foliage" , math.huge)

	local folder : Folder = ws.SpawnerZones.Foliage
	while true do
		for _ , va in folder:GetDescendants() do
			if va:IsA("BasePart") then
				if not va.CanCollide then va:Destroy() end
			end
		end
		task.wait(1)
	end
end)

uis.InputBegan:Connect(function( input , x )
	if x then return end
	if input.KeyCode == Enum.KeyCode.C then
		tween:Create( cam , TweenInfo.new( .1 , Enum.EasingStyle.Sine ) , { FieldOfView = 10} ):Play()
	end
end)
uis.InputEnded:Connect(function( input , x )
	if input.KeyCode == Enum.KeyCode.C then
		tween:Create( cam , TweenInfo.new( .1 , Enum.EasingStyle.Sine ) , { FieldOfView = 70} ):Play()
	end
end)

runs.RenderStepped:Connect(function()
	do
		local character : Model = getClosestCharacter( options.aimbot.player , options.aimbot.ai )
		plr.CameraMaxZoomDistance = 10 ^ 3
		plr.CameraMode = Enum.CameraMode.Classic

		if ( options.aimbot.player or options.aimbot.ai ) and uis:IsKeyDown( options.aimbot.keybind ) and character and character:FindFirstChild("Head") then
			local head : BasePart = character:FindFirstChild("Head")

			local cf = CFrame.new( cam.CFrame.Position , head.Position )
			cam.CFrame = cf

			uis.MouseDeltaSensitivity = 0
		else
			uis.MouseDeltaSensitivity = 1
		end
	end

	do
		local mousePos = Vector2.new( uis:GetMouseLocation().X , uis:GetMouseLocation().Y )
		local fov = cache.fov

		fov.Position = mousePos
		fov.Transparency = options.fov.toggle and 1 or 0
		fov.Radius = options.fov.radius
		fov.Color = options.fov.color
	end

	do
		local character : Model = getClosestCharacter( options.aimbot.player )
		if character and reps.Players:FindFirstChild( character.Name ) and character:FindFirstChildOfClass("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
			local hum : Humanoid = character:FindFirstChildOfClass("Humanoid")
			local humroot : BasePart = character:FindFirstChild("HumanoidRootPart")
			local data = reps.Players:FindFirstChild( character.Name )

			win2:setText( `{character.Name} ( HP {math.round( ( hum.Health / hum.MaxHealth ) * 100 ) }% ) ( { math.round( plr:DistanceFromCharacter( humroot.Position ) ) }m )` )
			for name , method in methods do
				local icons = {}

				for _ , va in data:FindFirstChild( name ):GetChildren() do
					local props = va:FindFirstChild("ItemProperties")
					if props then
						local icon = props.ItemIcon.Image
						icons[ icon ] = icon
					end
				end

				method:update( icons )
			end
		else
			win2:setText( "None" )
			for name , method in methods do
				method:update( {} )
			end
		end
	end

	esp()
end)


local function espUpdate( char : Model )
	if not char then return end
	local humroot = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not humroot then return end
	if not hum then return end

	local pos , onScreen = worldToViewportPoint( humroot.Position )

	cache.esp[ char ] = cache.esp[ char ] or {}
	local data = cache.esp[ char ]

	local distance = plr:DistanceFromCharacter( humroot.Position )

	local str = `{ char.Name } | { math.round( distance ) }`
	local text : TextLabel = data.text or Drawing.new("Text")
	text.Position = pos + Vector2.new( -string.len( str ) * 2.8 , 0 )
	text.Size = 13
	text.Text = str
	text.Color = Color3.fromRGB(255 , 255 , 255)
	text.Font = 12
	text.Transparency = onScreen and 1 or 0

	local box = data.box or Drawing.new("Square")
	box.Transparency = onScreen and 1 or 0
	box.Filled = false
	box.Color = Color3.fromRGB(255 , 255 , 255)

	local cf , si = char:GetBoundingBox()
	do
		local top = worldToViewportPoint( ( cf * CFrame.new( 0 , si.Y / 2 , 0 ) ).Position )
		local bottom = worldToViewportPoint( ( cf * CFrame.new( 0 , -si.Y / 2 , 0 ) ).Position )
		local left = worldToViewportPoint( ( cf * CFrame.new( -si.X / 2 , 0 , 0 ) ).Position )
		local right = worldToViewportPoint( ( cf * CFrame.new( si.X / 2 , 0 , 0 ) ).Position )

		local hight = math.abs( ( top - bottom ).Magnitude )
		local width = math.abs( ( left - right ).Magnitude )
		box.Size = Vector2.new( width , hight )
		box.Position = pos + Vector2.new( -width / 2 , -hight / 2 )
	end

	data.text = text
	data.box = box
end

function esp()
	for _ , player in plrs:GetPlayers() do
		if player == plr then continue end
		espUpdate( player.Character )
	end

	if ws:FindFirstChild("AiZones") then
		for _ , zone : Folder in ws.AiZones:GetChildren() do
			for _ , char in zone:GetChildren() do
				espUpdate( char )
			end
		end
	end

	for char : Model , va : {} in cache.esp do
		if not char or not char:IsDescendantOf( ws ) or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then
			va.text:Remove()
			va.box:Remove()
			cache.esp[ char ] = nil
		else
			local isPlayer = plrs:GetPlayerFromCharacter( char )
			local toggle = false
			local color = Color3.fromRGB(255 , 255 , 255)

			if isPlayer then
				toggle = options.esp.player.toggle
				color = options.esp.player.color
			else
				toggle = options.esp.ai.toggle
				color = options.esp.ai.color
			end

			va.text.Visible = toggle
			va.box.Visible = toggle

			va.text.Color = color
			va.box.Color = color
		end
	end
end

function worldToViewportPoint( pos : Vector3 ) : Vector2
	local pos , onScreen = cam:WorldToViewportPoint( pos )

	return Vector2.new( pos.X , pos.Y ) , onScreen
end

function getClosestCharacter( isPlayer , isAi )
	local character : Model , distance : number = nil , options.fov.radius
	local originPos = Vector2.new( uis:GetMouseLocation().X , uis:GetMouseLocation().Y )
	
	if isAi then
		if ws:FindFirstChild("AiZones") then
			for _ , zone : Folder in ws.AiZones:GetChildren() do
				for _ , char in zone:GetChildren() do
					local humroot = char:FindFirstChild("HumanoidRootPart")
					local head = char:FindFirstChild("Head")
					if not humroot then continue end
					if not head then continue end

					local pos , onScreen = cam:WorldToViewportPoint( humroot.Position )
					pos = Vector2.new( math.round( pos.X ) , math.round( pos.Y ) )
					if onScreen then
						local dist = ( pos - originPos ).Magnitude
						if dist < distance then
							distance = dist
							character = char
						end
					end
				end
			end
		end
	end
	
	if isPlayer then
		for _ , player in plrs:GetPlayers() do
			if table.find( options.whitelist , player.Name ) then continue end
			if player == plr then continue end
			local char = player.Character

			if not char then continue end
			local humroot = char:FindFirstChild("HumanoidRootPart")
			local head = char:FindFirstChild("Head")
			if not humroot then continue end
			if not head then continue end

			local pos , onScreen = cam:WorldToViewportPoint( humroot.Position )
			pos = Vector2.new( math.round( pos.X ) , math.round( pos.Y ) )
			if onScreen then
				local dist = ( pos - originPos ).Magnitude
				if dist < distance then
					distance = dist
					character = char
				end
			end
		end
	end

	return character
end
