local g = game

local ws = g:GetService("Workspace")
local uis = g:GetService("UserInputService")
local plrs = g:GetService("Players")
local reps = g:GetService("ReplicatedStorage")
local runs = g:GetService("RunService")
local tween = g:GetService("TweenService")

local module = {}
module.__index = module

local cam = ws.CurrentCamera
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()

function module.new()
	local self = setmetatable({}, module)
	self.enabled = false

	local rotation = Vector2.new()
	local camPos = cam.CFrame.Position
	local fov = 70
	
	self.inputConn = uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			rotation = rotation + Vector2.new(-input.Delta.y, -input.Delta.x) * 0.005
			rotation = Vector2.new(math.clamp(rotation.X, -math.pi/2, math.pi/2), rotation.Y)
		end
	end)
	
	self.mouseForward = mouse.WheelForward:Connect(function()
		fov -= 5
	end)
	self.mouseBackward = mouse.WheelBackward:Connect(function()
		fov += 5
	end)
	
	self.conn = runs.RenderStepped:Connect(function(dt)
		if self.enabled then
			local velocity = Vector3.zero
			local speed = 50

			if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
				speed = 200
			elseif uis:IsKeyDown(Enum.KeyCode.LeftControl) then
				speed = 25
			end

			speed = speed * dt

			local lookDir = CFrame.fromEulerAnglesYXZ(rotation.X, rotation.Y, 0).LookVector
			local rightDir = CFrame.fromEulerAnglesYXZ(rotation.X, rotation.Y, 0).RightVector

			if uis:IsKeyDown(Enum.KeyCode.W) then
				velocity += lookDir * speed
			end
			if uis:IsKeyDown(Enum.KeyCode.S) then
				velocity -= lookDir * speed
			end
			if uis:IsKeyDown(Enum.KeyCode.A) then
				velocity -= rightDir * speed
			end
			if uis:IsKeyDown(Enum.KeyCode.D) then
				velocity += rightDir * speed
			end
			if uis:IsKeyDown(Enum.KeyCode.E) then
				velocity += Vector3.new(0, speed, 0)
			end
			if uis:IsKeyDown(Enum.KeyCode.Q) then
				velocity -= Vector3.new(0, speed, 0)
			end

			camPos = camPos + velocity
			cam.CFrame = CFrame.new(camPos) * CFrame.fromEulerAnglesYXZ(rotation.X, rotation.Y, 0)
			tween:Create( cam , TweenInfo.new( .05 , Enum.EasingStyle.Sine ) ,{
				FieldOfView = fov
			}):Play()
		else
			local y , x = cam.CFrame.Rotation:ToEulerAngles( Enum.RotationOrder.YXZ )
			camPos = cam.CFrame.Position
			rotation = Vector2.new( y , x )
			fov = 70
		end
	end)

	return self
end

function module:toggle( va )
	if not self then return end
	self.enabled = va
end

return module
