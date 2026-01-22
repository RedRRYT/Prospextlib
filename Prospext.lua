--[[
    Prospext Script Hub
    Version: 1.1 (All-in-One)

    • Loadstring ready
    • Glassmorphism UI
    • Built-in blocks
    • Easy to edit
    • For YOUR game only

    Credits:
    UI Framework: ChatGPT
    Hub: Prospext
]]

--// Services
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

--// Remove old UI
pcall(function()
    game.CoreGui:FindFirstChild("ProspextUI"):Destroy()
end)

--// Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "ProspextUI"
Gui.ResetOnSpawn = false
Gui.Parent = game.CoreGui

--// Main
local Main = Instance.new("Frame", Gui)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromScale(0, 0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Transparency = 0.8

--// Title
local Title = Instance.new("TextLabel", Main)
Title.Text = "Prospext"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 30
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,16,0,12)
Title.Size = UDim2.new(1,-32,0,40)
Title.TextXAlignment = Left

--// Holder
local Holder = Instance.new("ScrollingFrame", Main)
Holder.Position = UDim2.new(0,16,0,70)
Holder.Size = UDim2.new(1,-32,1,-110)
Holder.ScrollBarImageTransparency = 1
Holder.BackgroundTransparency = 1
Holder.CanvasSize = UDim2.new(0,0,0,0)

local Layout = Instance.new("UIListLayout", Holder)
Layout.Padding = UDim.new(0,12)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Holder.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 12)
end)

--// Credits
local Credits = Instance.new("TextLabel", Main)
Credits.Text = "Prospext Hub • UI by ChatGPT"
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 12
Credits.TextColor3 = Color3.fromRGB(160,160,160)
Credits.BackgroundTransparency = 1
Credits.Position = UDim2.new(0,16,1,-26)
Credits.Size = UDim2.new(1,-32,0,20)
Credits.TextXAlignment = Left

--// Open Animation
TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
	Size = UDim2.fromScale(0.42, 0.52)
}):Play()

TweenService:Create(Blur, TweenInfo.new(0.45), {
	Size = 18
}):Play()

--// ======================
--// BLOCK CREATOR
--// ======================
local function AddBlock(text, callback)
	local Button = Instance.new("TextButton", Holder)
	Button.Size = UDim2.new(1,0,0,48)
	Button.Text = text
	Button.Font = Enum.Font.GothamMedium
	Button.TextSize = 17
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Button.BackgroundTransparency = 0.15
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,14)

	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.05
		}):Play()
	end)

	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.15
		}):Play()
	end)

	Button.MouseButton1Click:Connect(function()
		task.spawn(function()
			pcall(callback)
		end)
	end)
end

--// ======================
--// YOUR SCRIPTS GO HERE
--// ======================

AddBlock("Example Script", function()
	print("Prospext: Example script executed")
end)

AddBlock("Another Script", function()
	print("Put your own code here")
end)

AddBlock("Close Hub", function()
	TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
		Size = UDim2.fromScale(0,0)
	}):Play()

	TweenService:Create(Blur, TweenInfo.new(0.35), {
		Size = 0
	}):Play()

	task.wait(0.4)
	Gui:Destroy()
	Blur:Destroy()
end)
