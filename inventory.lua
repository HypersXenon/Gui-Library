local g = game
local s = script
local sp = s.Parent

local ws = g:GetService("Workspace")
local uis = g:GetService("UserInputService")
local reps = g:GetService("ReplicatedStorage")
local runs = g:GetService("RunService")
local plrs = g:GetService("Players")
local core = g:GetService("CoreGui")
local https = g:GetService("HttpService")
local tween = g:GetService("TweenService")

local function ins( class : string , property : {} )
	local ins = Instance.new(class)
	for inx , va in property or {} do
		ins[ inx ] = va
	end
	return ins
end

local module = {}
module.__index = module

local plr = plrs.LocalPlayer

function module.new()
	local screen : ScreenGui = ins("ScreenGui" , {
		["Archivable"] = true,
		["AutoLocalize"] = true,
		["ClipToDeviceSafeArea"] = true,
		["DisplayOrder"] = 0,
		["Enabled"] = true,
		["IgnoreGuiInset"] = false,
		["Localize"] = true,
		["Name"] = https:GenerateGUID( false ),
		["Parent"] = core,
		["ResetOnSpawn"] = false,
		["SafeAreaCompatibility"] = Enum.SafeAreaCompatibility.FullscreenExtension,
		["ScreenInsets"] = Enum.ScreenInsets.CoreUISafeInsets,
		["SelectionGroup"] = false,
		["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	})
	local bg : Frame = ins("Frame" , {
		["Active"] = false,
		["Archivable"] = true,
		["AutoLocalize"] = true,
		["AutomaticSize"] = Enum.AutomaticSize.XY,
		["BackgroundColor3"] = Color3.fromRGB(39, 39, 39),
		["BackgroundTransparency"] = 0.4,
		["BorderSizePixel"] = 1,
		["ClipsDescendants"] = true,
		["Draggable"] = false,
		["Interactable"] = true,
		["LayoutOrder"] = 0,
		["Localize"] = true,
		["Name"] = "bg",
		["Parent"] = screen,
		["Position"] = UDim2.fromOffset(10, 10),
		["Rotation"] = 0,
		["Selectable"] = false,
		["SelectionGroup"] = false,
		["SelectionOrder"] = 0,
		["Size"] = UDim2.fromOffset(0, 50),
		["SizeConstraint"] = Enum.SizeConstraint.RelativeXY,
		["Visible"] = true,
		["ZIndex"] = 1
	})
	
	do
		ins("UICorner" , {
			["CornerRadius"] = UDim.new(0, 2),
			["Parent"] = bg,
			["Name"] = "_",
		})
		ins("UIListLayout" , {
			["Padding"] = UDim.new(0, 4),
			["FillDirection"] = Enum.FillDirection.Vertical,
			["SortOrder"] = Enum.SortOrder.LayoutOrder,
			["HorizontalAlignment"] = Enum.HorizontalAlignment.Left,
			["VerticalAlignment"] = Enum.VerticalAlignment.Top,
			["Parent"] = bg,
			["Name"] = "_",
		})
		ins("UIPadding" , {
			["PaddingBottom"] = UDim.new(0, 8),
			["PaddingLeft"] = UDim.new(0, 8),
			["PaddingRight"] = UDim.new(0, 8),
			["PaddingTop"] = UDim.new(0, 8),
			["Parent"] = bg,
			["Name"] = "_",
		})
		ins("UIStroke" , {
			["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
			["Color"] = Color3.fromRGB(91, 91, 91),
			["LineJoinMode"] = Enum.LineJoinMode.Round,
			["Thickness"] = 1,
			["Parent"] = bg,
			["Name"] = "_",
		})
	end
	
	local title : TextLabel = ins("TextLabel" , {
		["Name"] = "title",
		["AutomaticSize"] = Enum.AutomaticSize.X,
		["BackgroundTransparency"] = 1,
		["TextScaled"] = false,
		["Size"] = UDim2.fromOffset(5, 5),
		["FontFace"] = Font.new( "rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal ),
		["TextSize"] = 13;
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Text"] = `DugdigDev ( HP 100% ) ( 300m )`,
		["Parent"] = bg,
	})
	
	return setmetatable({
		screen = screen
	} , module)
end

function module:setText( text )
	if not self then return end

	local screen = self.screen
	local bg = screen.bg
	
	local textlabel : TextLabel = bg.title
	textlabel.Text = text
end

function module:createImage()
	if not self then return end
	
	local id = https:GenerateGUID( false )
	local screen = self.screen
	local bg = screen.bg
	
	local bg : Frame = ins("Frame" , {
		["Active"] = false,
		["Archivable"] = true,
		["AutoLocalize"] = true,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		["BackgroundColor3"] = Color3.fromRGB(39, 39, 39),
		["BorderSizePixel"] = 1,
		["ClipsDescendants"] = true,
		["Draggable"] = false,
		["Interactable"] = true,
		["LayoutOrder"] = #bg:GetChildren(),
		["Localize"] = true,
		["Name"] = id,
		["Parent"] = bg,
		["Transparency"] = 1,
		["Position"] = UDim2.fromOffset(0 , 0),
		["Rotation"] = 0,
		["Selectable"] = false,
		["Size"] = UDim2.fromOffset(250, 25),
		["SizeConstraint"] = Enum.SizeConstraint.RelativeXY,
		["Visible"] = true,
		["ZIndex"] = 1,
	})
	do
		ins("UIListLayout" , {
			["Padding"] = UDim.new(0, 0),
			["FillDirection"] = Enum.FillDirection.Horizontal,
			["SortOrder"] = Enum.SortOrder.Name,
			["HorizontalAlignment"] = Enum.HorizontalAlignment.Left,
			["VerticalAlignment"] = Enum.VerticalAlignment.Top,
			["Parent"] = bg,
			["Name"] = "_",
		})
	end
	
	
	local method = {}
	function method:update( config : { name : number | string })
		for name , id in config do
			local icon : ImageButton = bg:FindFirstChild(name)
			local id : string = `rbxassetid://{ string.gsub( id , "%D" , "" ) }`
			
			if not icon then
				icon = ins("ImageButton" , {
					["BackgroundTransparency"] = 1,
					["BorderSizePixel"] = 0,
					["Size"] = UDim2.fromOffset(25, 25),
					["Image"] = id,
					["Parent"] = bg,
					["Name"] = name
				})
				icon.MouseEnter:Connect(function()
					tween:Create( icon , TweenInfo.new( .1 , Enum.EasingStyle.Sine ) , {
						Size = UDim2.fromOffset(50 , 50)
					}):Play()
				end)
				icon.MouseLeave:Connect(function()
					tween:Create( icon , TweenInfo.new( .1 , Enum.EasingStyle.Sine ) , {
						Size = UDim2.fromOffset(25 , 25)
					}):Play()
				end)
			end
		end
		
		for _ , va in bg:GetChildren() do
			if va:IsA("ImageButton") then
				if not config[va.Name] then
					va:Destroy()
				end
			end
		end
	end
	return method
end

return module
