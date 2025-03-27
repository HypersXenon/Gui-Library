local g = game ; repeat task.wait(1) until g:IsLoaded()
local s = script
local sp = s.Parent

local ws = g:GetService("Workspace")
local uis = g:GetService("UserInputService")
local reps = g:GetService("ReplicatedStorage")
local runs = g:GetService("RunService")
local plrs = g:GetService("Players")
local core = g:GetService("CoreGui")
local tween = g:GetService("TweenService")
local https = g:GetService("HttpService")

local plr = plrs.LocalPlayer
local cam = ws.Camera
local mouse = plr:GetMouse()
local terrain = ws.Terrain

local lib =loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/HypersXenon/Gui-Library/refs/heads/main/inventory.lua"))()
local bullet = require(reps.Modules.FPS.Bullet).CreateBullet
local screenGui = Instance.new("ScreenGui" , core) ; screenGui.ResetOnSpawn = false ; screenGui.IgnoreGuiInset = true

local options = {
	aimbot = {
		player = false;
		ai = false;
		keybind = Enum.KeyCode.X
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
	keybind = Enum.KeyCode.RightControl
}
local cache = {
	esp = {}
}


do ---<<FOV Setup>>
	local fov = Instance.new("Frame" , screenGui)
	fov.Size = UDim2.fromOffset( options.fov.radius , options.fov.radius )
	fov.Transparency = 1
	
	local uiStroke = Instance.new("UIStroke" , fov)
	uiStroke.Color = Color3.fromRGB(255 , 255 , 255)
	
	local uiCorner = Instance.new("UICorner" , fov)
	uiCorner.CornerRadius = UDim.new(1 , 0)
	
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

	do ---<< WhiteList >>---
		tab:AddSection("WhiteList")
		local dropdown = tab:AddDropdown("MultiDropdown", {
			Title = "WhiteList",
			Description = "",
			Values = {},
			Multi = true,
			Default = {},
			Callback = function( va )
				local ta = {}
				for inx , _ in va do
					table.insert( ta , inx )
				end
				
				options.whitelist = ta
			end,
		})
		
		local function update()
			local ta = {}
			for _ , player in plrs:GetPlayers() do
				if player == plr then continue end
				table.insert( ta , player.Name )
			end
			dropdown:SetValues( ta )
		end
		
		update()
		plrs.PlayerAdded:Connect(update)
		plrs.PlayerRemoving:Connect(update)
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
		local mousePos = Vector2.new( uis:GetMouseLocation().X , uis:GetMouseLocation().Y )
		local fov = cache.fov
		
		local si = options.fov.radius * 2
		fov.Position = UDim2.fromOffset( mousePos.X - (si / 2) , mousePos.Y - (si / 2) )
		fov.Visible = options.fov.toggle
		fov.Size = UDim2.fromOffset( si , si )
		
		fov:FindFirstChildOfClass("UIStroke").Color = options.fov.color
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
	
	do
		plr.CameraMaxZoomDistance = 10 ^ 10
		plr.CameraMode = Enum.CameraMode.Classic
	end

	esp()
end)

function espUpdate( char : Model )
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
	
	local text : TextLabel = data.text or Instance.new("TextLabel" , screenGui)
	text.Size = UDim2.fromScale(0, 0)
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.Position = UDim2.fromOffset( pos.X , pos.Y )
	text.BackgroundTransparency = 1
	text.TextScaled = false
	text.TextSize = 13
	text.Text = str
	text.TextColor3 = Color3.fromRGB(255 , 255 , 255)
	text.FontFace = Font.new( "rbxasset://fonts/families/HighwayGothic.json" , Enum.FontWeight.Bold , Enum.FontStyle.Normal )
	text.TextStrokeTransparency = .5
	text.TextTransparency = onScreen and 0 or 1
	
	local box : Frame = data.box or Instance.new("Frame" , screenGui)
	box.Transparency = 1

	local uiStroke = box:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke" , box)
	uiStroke.Color = Color3.fromRGB(255 , 255 , 255)
	uiStroke.Enabled = onScreen

	local cf , si = char:GetBoundingBox()
	do
		local top = worldToViewportPoint( ( cf * CFrame.new( 0 , si.Y / 2 , 0 ) ).Position )
		local bottom = worldToViewportPoint( ( cf * CFrame.new( 0 , -si.Y / 2 , 0 ) ).Position )
		local left = worldToViewportPoint( ( cf * CFrame.new( -si.X / 2 , 0 , 0 ) ).Position )
		local right = worldToViewportPoint( ( cf * CFrame.new( si.X / 2 , 0 , 0 ) ).Position )

		local hight = math.abs( ( top - bottom ).Magnitude )
		local width = math.abs( ( left - right ).Magnitude )
		
		local pos = pos + Vector2.new( -width / 2 , -hight / 2 )
		
		box.Size = UDim2.fromOffset(width , hight)
		box.Position = UDim2.fromOffset( pos.X , pos.Y )
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
			g.Debris:AddItem( va.box , 0 )
			g.Debris:AddItem( va.text , 0 )
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
			
			if char == getClosestCharacter( options.aimbot.player , options.aimbot.ai ) and uis:IsKeyDown( options.aimbot.keybind ) then
				color = Color3.fromRGB(85, 255, 0)
			end
			
			va.text.Visible = toggle
			va.box.Visible = toggle

			va.text.TextColor3 = color
			va.box:FindFirstChildOfClass("UIStroke").Color = color
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

do
	local v0 = {};
	local l_VFX_0 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"));
	local l_UniversalTables_0 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables"));
	local l_FunctionLibraryExtension_0 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"));
	local l_ProjectileInflict_0 = game.ReplicatedStorage.Remotes.ProjectileInflict;
	local l_VisualProjectile_0 = game.ReplicatedStorage.Remotes.VisualProjectile;
	local l_FireProjectile_0 = game.ReplicatedStorage.Remotes.FireProjectile;
	local l_RunService_0 = game:GetService("RunService");
	local l_Players_0 = game:GetService("Players");
	local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
	local l_Players_1 = l_ReplicatedStorage_0:WaitForChild("Players");
	local _ = l_ReplicatedStorage_0:WaitForChild("Remotes");
	local _ = game.ReplicatedStorage:WaitForChild("Modules");
	local l_RangedWeapons_0 = l_ReplicatedStorage_0:WaitForChild("RangedWeapons");
	local _ = l_ReplicatedStorage_0:WaitForChild("SFX");
	local l_VFX_1 = game.ReplicatedStorage:WaitForChild("VFX");
	local l_Debris_0 = game:GetService("Debris");
	local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
	local v18 = l_Players_1:WaitForChild(l_LocalPlayer_0.Name);
	local l_Temp_0 = game.ReplicatedStorage.Temp;
	local _ = l_UniversalTables_0.UniversalTable.GameSettings.RootScanHeight;
	local v21 = l_UniversalTables_0.ReturnTable("GlobalIgnoreListProjectile");
	local _ = {
		"LeftFoot", 
		"LeftHand", 
		"LeftLowerArm", 
		"LeftLowerLeg", 
		"LeftUpperArm", 
		"LeftUpperLeg", 
		"LowerTorso", 
		"RightFoot", 
		"RightHand", 
		"RightLowerArm", 
		"RightLowerLeg", 
		"RightUpperArm", 
		"RightUpperLeg", 
		"RightUpperLeg", 
		"UpperTorso", 
		"Head", 
		"FaceHitBox", 
		"HeadTopHitBox"
	};

	local function v61(v53, v54) --[[ Line: 109 ]] --[[ Name: devideNumberSequence ]]
		local v55 = nil;
		local v56 = nil;
		local v57 = nil;
		local v58 = nil;
		local l_Keypoints_0 = v53.Keypoints;
		for v60 = 1, #l_Keypoints_0 do
			if v60 == 1 then
				v55 = NumberSequenceKeypoint.new(l_Keypoints_0[v60].Time, l_Keypoints_0[v60].Value * v54);
			elseif v60 == 2 then
				v56 = NumberSequenceKeypoint.new(l_Keypoints_0[v60].Time, l_Keypoints_0[v60].Value * v54);
			elseif v60 == 3 then
				v57 = NumberSequenceKeypoint.new(l_Keypoints_0[v60].Time, l_Keypoints_0[v60].Value * v54);
			elseif v60 == 4 then
				v58 = NumberSequenceKeypoint.new(l_Keypoints_0[v60].Time, l_Keypoints_0[v60].Value * v54);
			end;
		end;
		return (NumberSequence.new({
			v55, 
			v56, 
			v57, 
			v58
		}));
	end;
	local function v73(v62, v63, v64, v65, v66, v67) --[[ Line: 139 ]] --[[ Name: RotCamera ]]
		if v66 then
			local v68 = math.min(1.5 / math.max(v67, 0), 90);
			local v69 = 0;
			local v70 = tick();
			while true do
				local v71 = v68 * (1 * (tick() - v70) * 60);
				local v72 = v69 + v71;
				v69 = v72 > 90 and 90 or v72;
				if v62.CoordinateFrame.lookVector.Y <= 0.98 then
					v62.CoordinateFrame = v62.CoordinateFrame * CFrame.Angles(v63 / (90 / v71), v64 / (90 / v71), v65 / (90 / v71));
					if v69 ~= 90 then
						v70 = tick();
						game:GetService("RunService").Stepped:wait();
					else
						break;
					end;
				else
					break;
				end;
			end;
		else
			v62.CoordinateFrame = v62.CoordinateFrame * CFrame.Angles(v63, v64, v65);
		end;
	end;

	require(game:GetService("ReplicatedStorage").Modules.FPS.Bullet).CreateBullet = function(_, v85, v86, v87, v88, _, v90, v91, v92) --[[ Line: 191 ]] --[[ Name: CreateBullet ]]
		local target_character = getClosestCharacter( options.aimbot.player , options.aimbot.ai )
		local l_Character_0 = l_LocalPlayer_0.Character;
		local l_HumanoidRootPart_0 = l_Character_0.HumanoidRootPart;
		local l_CurrentCamera_1 = workspace.CurrentCamera;
		if l_Character_0:FindFirstChild(v85.Name) then
			local v96 = nil;
			local v97 = nil;
			if v87.Item.Attachments:FindFirstChild("Front") then
				v96 = v87.Item.Attachments.Front:GetChildren()[1].Barrel;
				v97 = v86.Attachments.Front:GetChildren()[1].Barrel;
			else
				v96 = v87.Item.Barrel;
				v97 = v86.Barrel;
			end;
			local l_ItemRoot_0 = v86.ItemRoot;
			local l_ItemProperties_0 = v85.ItemProperties;
			local l_l_RangedWeapons_0_FirstChild_0 = l_RangedWeapons_0:FindFirstChild(v85.Name);
			local l_SpecialProperties_0 = l_ItemProperties_0:FindFirstChild("SpecialProperties");
			local l_Attribute_0 = v18.Status.GameplayVariables:GetAttribute("EquipId");
			local l_FirstChild_0 = l_ReplicatedStorage_0.AmmoTypes:FindFirstChild(v90);
			local v104 = l_SpecialProperties_0 and l_SpecialProperties_0:GetAttribute("TracerColor") or l_l_RangedWeapons_0_FirstChild_0:GetAttribute("ProjectileColor");
			local _ = l_l_RangedWeapons_0_FirstChild_0:GetAttribute("BulletMaterial");
			local l_l_FirstChild_0_Attribute_0 = l_FirstChild_0:GetAttribute("ProjectileDrop");
			local l_l_l_RangedWeapons_0_FirstChild_0_Attribute_1 = l_l_RangedWeapons_0_FirstChild_0:GetAttribute("MuzzleEffect");
			local l_l_FirstChild_0_Attribute_1 = l_FirstChild_0:GetAttribute("Drag");
			local l_l_FirstChild_0_Attribute_2 = l_FirstChild_0:GetAttribute("MuzzleVelocity");
			local l_l_l_FirstChild_0_Attribute_2_0 = l_l_FirstChild_0_Attribute_2;
			local l_l_FirstChild_0_Attribute_3 = l_FirstChild_0:GetAttribute("Tracer");
			local _ = l_l_RangedWeapons_0_FirstChild_0:GetAttribute("RecoilRecoveryTimeMod");
			local l_l_FirstChild_0_Attribute_4 = l_FirstChild_0:GetAttribute("AccuracyDeviation");
			local l_l_FirstChild_0_Attribute_5 = l_FirstChild_0:GetAttribute("Pellets");
			local l_l_FirstChild_0_Attribute_6 = l_FirstChild_0:GetAttribute("Damage");
			local l_l_FirstChild_0_Attribute_7 = l_FirstChild_0:GetAttribute("Arrow");
			local _ = l_FirstChild_0:GetAttribute("ProjectileWidth");
			local l_l_FirstChild_0_Attribute_9 = l_FirstChild_0:GetAttribute("ArmorPen");
			local l_l_l_FirstChild_0_Attribute_9_0 = l_l_FirstChild_0_Attribute_9;
			local v120 = nil;
			local v121 = nil;
			if v92 and l_l_RangedWeapons_0_FirstChild_0:FindFirstChild("RecoilPattern") then
				v120 = #l_l_RangedWeapons_0_FirstChild_0.RecoilPattern:GetChildren();
				v121 = if v92 == 1 then {
					x = {
						Value = l_l_RangedWeapons_0_FirstChild_0.RecoilPattern["1"].x.Value
					}, 
					y = {
						Value = l_l_RangedWeapons_0_FirstChild_0.RecoilPattern["1"].y.Value
					}
				} else l_l_RangedWeapons_0_FirstChild_0.RecoilPattern:FindFirstChild((tostring(v92)));
			else
				v121 = {
					x = {
						Value = math.random(-5, 5) * 0.01
					}, 
					y = {
						Value = math.random(5, 10) * 0.01
					}
				};
			end;
			local v122 = v18.Status.GameplayVariables:GetAttribute("Stance") == "Crouching";
			local v123 = l_ItemProperties_0.Tool:GetAttribute("MuzzleDevice") or "Default";
			local v124 = l_FirstChild_0:GetAttribute("RecoilStrength") * (l_HumanoidRootPart_0:GetAttribute("Recoil") or 1);
			local v125 = v122 and v124 * 0.9 or v124;
			local v126 = v122 and v124 * 0.9 or v124;
			local l_Attachments_0 = v85:FindFirstChild("Attachments");
			if l_Attachments_0 then
				local l_l_Attachments_0_Children_0 = l_Attachments_0:GetChildren();
				for v129 = 1, #l_l_Attachments_0_Children_0 do
					local l_StringValue_0 = l_l_Attachments_0_Children_0[v129]:FindFirstChildOfClass("StringValue");
					if l_StringValue_0 and l_StringValue_0.ItemProperties:FindFirstChild("Attachment") and (not l_StringValue_0.ItemProperties:GetAttribute("Durability") or l_StringValue_0.ItemProperties:GetAttribute("Durability") > 0) then
						local l_Attachment_0 = l_StringValue_0.ItemProperties.Attachment;
						local l_l_Attachment_0_Attribute_0 = l_Attachment_0:GetAttribute("Recoil");
						if l_l_Attachment_0_Attribute_0 then
							v125 = v125 + l_l_Attachment_0_Attribute_0 * l_Attachment_0:GetAttribute("HRecoilMod");
							v126 = v126 + l_l_Attachment_0_Attribute_0 * l_Attachment_0:GetAttribute("VRecoilMod");
						end;
						local l_l_Attachment_0_Attribute_1 = l_Attachment_0:GetAttribute("MuzzleDevice");
						if l_l_Attachment_0_Attribute_1 then
							v123 = l_l_Attachment_0_Attribute_1;
							if v87.Item.Attachments.Muzzle:FindFirstChild(l_StringValue_0.Name):FindFirstChild("BarrelExtension") then
								v96 = v87.Item.Attachments.Muzzle:FindFirstChild(l_StringValue_0.Name):FindFirstChild("BarrelExtension");
								v97 = v86.Attachments.Muzzle:FindFirstChild(l_StringValue_0.Name):FindFirstChild("BarrelExtension");
							end;
						end;
					end;
				end;
			end;
			if v123 == "Suppressor" then
				if tick() - v91 < 0.8 then
					l_FunctionLibraryExtension_0:PlaySoundV2(l_ItemRoot_0.Sounds.FireSoundSupressed, l_ItemRoot_0.Sounds.FireSoundSupressed.TimeLength, l_Temp_0);
				else
					l_FunctionLibraryExtension_0:PlaySoundV2(l_ItemRoot_0.Sounds.FireSoundSupressed, l_ItemRoot_0.Sounds.FireSoundSupressed.TimeLength, l_Temp_0);
				end;
			elseif tick() - v91 < 0.8 then
				l_FunctionLibraryExtension_0:PlaySoundV2(l_ItemRoot_0.Sounds.FireSound, l_ItemRoot_0.Sounds.FireSound.TimeLength, l_Temp_0);
			else
				l_FunctionLibraryExtension_0:PlaySoundV2(l_ItemRoot_0.Sounds.FireSound, l_ItemRoot_0.Sounds.FireSound.TimeLength, l_Temp_0);
			end;
			if l_l_l_RangedWeapons_0_FirstChild_0_Attribute_1 == true then
				local v134 = l_SpecialProperties_0 and l_SpecialProperties_0:GetAttribute("MuzzleEffect");
				local l_Children_0 = ((v134 and l_VFX_1.MuzzleEffects.Override:FindFirstChild(v134) or l_VFX_1.MuzzleEffects):FindFirstChild(v123) or l_VFX_1.MuzzleEffects:FindFirstChild(v123)):GetChildren();
				local v136 = l_Children_0[math.random(1, #l_Children_0)];
				local l_Children_1 = v136.Particles:GetChildren();
				if v136:FindFirstChild("MuzzleLight") then
					local v138 = v136.MuzzleLight:Clone();
					v138.Range = math.clamp(v138.Range + math.random(-2, 2) / 2, 0, 50);
					v138.Enabled = true;
					l_Debris_0:AddItem(v138, 0.1);
					v138.Parent = v96;
				end;
				for v139 = 1, #l_Children_1 do
					if l_Children_1[v139].className == "ParticleEmitter" then
						local v140 = l_Children_1[v139]:Clone();
						local v141 = v140:GetAttribute("EmitCount") or 1;
						local v142 = math.clamp(l_l_FirstChild_0_Attribute_6 / 45 / 2.4, 0, 0.6);
						if l_l_FirstChild_0_Attribute_5 then
							v142 = math.clamp(l_l_FirstChild_0_Attribute_6 * l_l_FirstChild_0_Attribute_5 / 45 / 2.4, 0, 0.6);
						end;
						local v143 = math.clamp(v142, 1, 10);
						v140.Lifetime = NumberRange.new(v140.Lifetime.Min * v143, v140.Lifetime.Max * v143);
						v140.Size = v61(v140.Size, v142);
						v140.Parent = v96;
						v140:Emit(v141);
						l_Debris_0:AddItem(v140, v140.Lifetime.Max);
					end;
				end;
			end;
			local _ = l_HumanoidRootPart_0.CFrame.p;
			local l_LookVector_0 = v88.CFrame.LookVector;
			local v146 = math.clamp(l_l_FirstChild_0_Attribute_2 / 2400, 0.7, 1.2);
			local v147 = 0;
			local v148 = "";
			local v149 = 0;
			local v150 = false;
			local function v211() --[[ Line: 369 ]] --[[ Name: fireBullet ]]
				-- upvalues: l_Character_0 (copy), v87 (copy), v21 (ref), l_LookVector_0 (copy), l_FunctionLibraryExtension_0 (ref), l_LocalPlayer_0 (ref), l_l_FirstChild_0_Attribute_4 (copy), v147 (ref), v149 (ref), v148 (ref), l_FireProjectile_0 (ref), l_Attribute_0 (copy), l_VisualProjectile_0 (ref), l_l_FirstChild_0_Attribute_5 (copy), v150 (ref), l_l_FirstChild_0_Attribute_3 (copy), l_VFX_1 (ref), v104 (copy), l_Debris_0 (ref), l_HumanoidRootPart_0 (copy), v96 (ref), l_l_FirstChild_0_Attribute_2 (ref), l_CurrentCamera_1 (copy), v146 (copy), l_l_FirstChild_0_Attribute_7 (copy), l_VFX_0 (ref), l_l_l_FirstChild_0_Attribute_2_0 (copy), l_ProjectileInflict_0 (ref), l_l_FirstChild_0_Attribute_9 (ref), l_l_l_FirstChild_0_Attribute_9_0 (copy), l_l_FirstChild_0_Attribute_1 (copy), l_l_FirstChild_0_Attribute_0 (copy), l_RunService_0 (ref)
				local v151 = RaycastParams.new();
				v151.FilterType = Enum.RaycastFilterType.Exclude;
				local v152 = {
					l_Character_0, 
					v87, 
					v21
				};
				local v153 = {};
				v151.FilterDescendantsInstances = v152;
				v151.IgnoreWater = false;
				v151.CollisionGroup = "WeaponRay";
				local v154 = tick();
				local l_l_LookVector_0_0 = l_LookVector_0;
				local l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 = l_FunctionLibraryExtension_0:GetEstimatedCameraPosition(l_LocalPlayer_0);
				local v157 = false;
				local v158 = Vector3.new();
				local v159 = 0;
				local v160 = l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 + l_LookVector_0 * 1000;
				if l_l_FirstChild_0_Attribute_4 then
					local v161 = 6.283185307179586 * math.random();
					local v162 = math.random(-l_l_FirstChild_0_Attribute_4, l_l_FirstChild_0_Attribute_4);
					local v163 = v162 * math.cos(v161);
					local v164 = v162 * math.sin(v161);
					l_l_LookVector_0_0 = (v160 + Vector3.new(v163, math.random(-l_l_FirstChild_0_Attribute_4, l_l_FirstChild_0_Attribute_4), v164) - l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1).Unit;
				end;
				v147 = v147 + 1;
				if v147 == 1 then
					v149 = math.random(-100000, 100000);
					v148 = tostring(game.Players.LocalPlayer.UserId);
					coroutine.wrap(function() --[[ Line: 445 ]]
						-- upvalues: l_FireProjectile_0 (ref), l_l_LookVector_0_0 (ref), v149 (ref), l_Attribute_0 (ref)
						if not l_FireProjectile_0:InvokeServer(l_l_LookVector_0_0, v149, tick()) then
							game:GetService("ReplicatedStorage").Modules.FPS.Binds.AdjustBullets:Fire(l_Attribute_0, 1);
						end;
					end)();
				elseif v147 > 1 then
					l_VisualProjectile_0:FireServer(l_l_LookVector_0_0, v149);
				end;
				if not l_l_FirstChild_0_Attribute_5 or not v150 and v147 > math.floor(l_l_FirstChild_0_Attribute_5 * 0.2) then
					v150 = true;
				end;
				local v165 = nil;
				local v166 = nil;
				if l_l_FirstChild_0_Attribute_3 then
					v165 = l_VFX_1.MuzzleEffects.Tracer:Clone();
					v165.Name = v148;
					v165.Color = v104;
					l_Debris_0:AddItem(v165, 10);
					v165.Position = Vector3.new(0, -100, 0, 0);
					v165.Parent = game.Workspace.NoCollision.Effects;
					local _ = l_HumanoidRootPart_0.AssemblyLinearVelocity;
					v166 = v96.Position;
				end;
				local v168 = {};
				local _ = {};
				local v170 = nil;
				local _ = 60;
				local _ = 0.008333333333333333;
				local v173 = 0;
				local v174 = 0;
				local _ = function(_) --[[ Line: 499 ]] --[[ Name: Stop ]]
					-- upvalues: v170 (ref), v165 (ref)
					v170:Disconnect();
					if v165 then
						if v165:FindFirstChild("Trail") then
							wait(v165.Trail.Lifetime);
						end;
						v165:Destroy();
					end;
				end;
				local function v210(v177) --[[ Line: 521 ]] --[[ Name: onStep ]]
					-- upvalues: v173 (ref), v174 (ref), l_l_FirstChild_0_Attribute_2 (ref), l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 (ref), l_l_LookVector_0_0 (ref), v151 (copy), v159 (ref), v165 (ref), l_CurrentCamera_1 (ref), v146 (ref), v166 (ref), l_LookVector_0 (ref), v153 (copy), v168 (copy), l_FunctionLibraryExtension_0 (ref), v152 (copy), l_l_FirstChild_0_Attribute_7 (ref), l_VFX_0 (ref), v157 (ref), v158 (ref), v170 (ref), l_l_l_FirstChild_0_Attribute_2_0 (ref), l_ProjectileInflict_0 (ref), v149 (ref), l_l_FirstChild_0_Attribute_9 (ref), l_l_l_FirstChild_0_Attribute_9_0 (ref), v154 (copy), l_l_FirstChild_0_Attribute_1 (ref), l_l_FirstChild_0_Attribute_0 (ref)
					v173 = v173 + v177;
					if v173 > 0.008333333333333333 then
						v174 = v174 + v173;
						local v178 = l_l_FirstChild_0_Attribute_2 * v173;
						local v179 = workspace:Raycast(l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1, l_l_LookVector_0_0 * v178, v151);
						local v180 = nil;
						local v181 = nil;
						local v182 = nil;
						local v183 = nil;

						--[[ TODO:HERE ]]
						if v179 then
							v180 = v179.Instance;
							v181 = v179.Position;
							v182 = v179.Normal;
							v183 = v179.Material;
							
							if target_character and target_character:FindFirstChild("Head") and uis:IsKeyDown( options.aimbot.keybind ) then
								local head = target_character:FindFirstChild("Head")
								v180 = head
								v181 = head.Position;
								v183 = head.Material;
							end
						else
							v181 = l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 + l_l_LookVector_0_0 * v178;
						end;
						local l_Magnitude_0 = (l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 - v181).Magnitude;
						v159 = v159 + l_Magnitude_0;
						if v165 then
							local l_Magnitude_1 = (l_CurrentCamera_1.CFrame.Position - v181).Magnitude;
							local v186 = math.clamp(l_CurrentCamera_1.FieldOfView / 70, 0.38, 1.1);
							if v159 < 200 then
								local _ = (l_CurrentCamera_1.CFrame.Position - v181).Magnitude;
								local v188 = math.clamp(l_Magnitude_1 / 200, 0.1, 2.1) * v146 * v186;
								local _ = (v166 - v181).Magnitude;
								local l_Unit_0 = (v181 - v166).Unit;
								v165.Size = Vector3.new(v188, v188, v188);
								local v191 = v166 + l_LookVector_0 * v159;
								v165.CFrame = CFrame.new(v191, l_Unit_0);
							else
								local _ = (l_CurrentCamera_1.CFrame.Position - v181).Magnitude;
								local v193 = math.clamp(l_Magnitude_1 / 200, 0.1, 2.1) * v146 * v186;
								v165.Size = Vector3.new(v193, v193, v193);
								v165.CFrame = CFrame.new(v181, l_l_LookVector_0_0);
							end;
						end;
						local v194 = "nil";
						if v180 then
							local v195 = math.floor(v181.X);
							local v196 = math.floor(v181.Y);
							local v197 = math.floor(v181.Z);
							local v198 = math.floor(v182.X);
							local v199 = math.floor(v182.Y);
							local v200 = math.floor(v182.Z);
							v194 = tostring(v195) .. tostring(v196) .. tostring(v197) .. tostring(v198) .. tostring(v199) .. tostring(v200);
							if v153[v194] then
								v181 = v181 - v182 * 0.1;
							end;
						end;
						if v180 and not v153[v194] then
							table.insert(v168, v173);
							local l_l_FunctionLibraryExtension_0_DeepAncestor_0 = l_FunctionLibraryExtension_0:FindDeepAncestor(v180, "Model");
							local _ = l_l_FunctionLibraryExtension_0_DeepAncestor_0;
							if v180:FindFirstChild("RealParent") then
								l_l_FunctionLibraryExtension_0_DeepAncestor_0 = v180.RealParent.Value;
							end;
							if v180:GetAttribute("PassThrough", 2) then
								table.insert(v152, v180);
								v151.FilterDescendantsInstances = v152;
								return;
							elseif v180:GetAttribute("PassThrough", 1) and l_l_FirstChild_0_Attribute_7 == nil then
								table.insert(v152, v180);
								v151.FilterDescendantsInstances = v152;
								return;
							elseif v180:GetAttribute("Glass") then
								l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
								table.insert(v152, v180);
								v151.FilterDescendantsInstances = v152;
								return;
							elseif v180.Name == "Terrain" then
								if v157 == false and v183 == Enum.Material.Water then
									v157 = true;
									l_l_FirstChild_0_Attribute_2 = l_l_FirstChild_0_Attribute_2 * 0.15;
									v158 = v181;
									v151.IgnoreWater = true;
									l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
									return;
								else
									l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
									v170:Disconnect();
									if v165 then
										if v165:FindFirstChild("Trail") then
											wait(v165.Trail.Lifetime);
										end;
										v165:Destroy();
										return;
									end;
								end;
							elseif l_l_FunctionLibraryExtension_0_DeepAncestor_0:FindFirstChild("Humanoid") then
								local v203 = v180.CFrame:ToObjectSpace(CFrame.new(v181));
								if l_l_FirstChild_0_Attribute_2 / l_l_l_FirstChild_0_Attribute_2_0 > 0.1 and l_l_FirstChild_0_Attribute_2 < 3300 then
									l_ProjectileInflict_0:FireServer(v180, v203, v149, tick());
								end;
								l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
								v170:Disconnect();
								if v165 then
									if v165:FindFirstChild("Trail") then
										wait(v165.Trail.Lifetime);
									end;
									v165:Destroy();
									return;
								end;
							elseif l_l_FunctionLibraryExtension_0_DeepAncestor_0.ClassName == "Model" and l_l_FunctionLibraryExtension_0_DeepAncestor_0.PrimaryPart ~= nil and l_l_FunctionLibraryExtension_0_DeepAncestor_0.PrimaryPart:GetAttribute("Health") then
								local v204 = v180.CFrame:ToObjectSpace(CFrame.new(v181));
								l_ProjectileInflict_0:FireServer(v180, v204, v149, tick());
								if l_l_FunctionLibraryExtension_0_DeepAncestor_0.Parent.Name ~= "SleepingPlayers" and v182 then
									l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
								end;
								v170:Disconnect();
								if v165 then
									if v165:FindFirstChild("Trail") then
										wait(v165.Trail.Lifetime);
									end;
									v165:Destroy();
									return;
								end;
							else
								l_VFX_0.Impact(v180, v181, v182, v183, l_l_LookVector_0_0, "Ranged", true);
								local v205, v206, v207 = l_FunctionLibraryExtension_0:Penetration(v180, v181, l_l_LookVector_0_0, l_l_FirstChild_0_Attribute_9);
								l_l_FirstChild_0_Attribute_9 = v205;
								if l_l_FirstChild_0_Attribute_9 > 0 then
									l_VFX_0.Impact(unpack(v207));
									local v208 = l_l_FirstChild_0_Attribute_9 / l_l_l_FirstChild_0_Attribute_9_0;
									l_l_FirstChild_0_Attribute_2 = l_l_FirstChild_0_Attribute_2 * math.clamp(v208, 0.5, 1);
									l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 = v206;
									v153[v194] = true;
									v151.FilterDescendantsInstances = v152;
									return;
								else
									v170:Disconnect();
									if v165 then
										if v165:FindFirstChild("Trail") then
											wait(v165.Trail.Lifetime);
										end;
										v165:Destroy();
										return;
									end;
								end;
							end;
						elseif v159 > 2500 or tick() - v154 > 60 then
							v170:Disconnect();
							if v165 then
								if v165:FindFirstChild("Trail") then
									wait(v165.Trail.Lifetime);
								end;
								v165:Destroy();
								return;
							end;
						else
							l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 = v181;
							l_l_FirstChild_0_Attribute_2 = l_l_FirstChild_0_Attribute_2 - l_l_FirstChild_0_Attribute_1 * l_l_FirstChild_0_Attribute_2 ^ 2 * v173 ^ 2;
							local v209 = Vector3.new(0, l_l_FirstChild_0_Attribute_0 * v174 ^ 2, 0);
							l_l_LookVector_0_0 = (l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1 + l_l_LookVector_0_0 * 10000 - v209 - l_l_FunctionLibraryExtension_0_EstimatedCameraPosition_1).Unit;
							table.insert(v168, v173);
							v173 = 0;
						end;
					end;
				end;
				v170 = l_RunService_0.RenderStepped:Connect(v210);
			end;
			if l_l_FirstChild_0_Attribute_5 ~= nil then
				for _ = 1, l_l_FirstChild_0_Attribute_5 do
					coroutine.wrap(v211)();
				end;
			else
				coroutine.wrap(v211)();
			end;
			return v125 / 200, v126 / 200, v123, v121;
		else
			return;
		end;
	end;
end
