--[[
    Prospext Library
    Exec-style Script Hub Framework

    Structure:
    local Lib = loadstring(HttpGet)()
    local Win = Lib:CreateWindow()
    local Tab = Win:CreateTab("Main")
    Tab:AddButton("Do Thing", function() end)

    UI + Framework: ChatGPT
    Name: Prospext
]]

--// Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer

--// Cleanup
pcall(function()
    Player.PlayerGui:FindFirstChild("ProspextUI"):Destroy()
end)

--// Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

--// ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "ProspextUI"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

--// MAIN LIB TABLE
local Prospext = {}

--// =====================
--// WINDOW
--// =====================
function Prospext:CreateWindow(title)
    title = title or "Prospext"

    local Window = {}

    local Main = Instance.new("Frame", Gui)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.Size = UDim2.fromScale(0.45, 0.55)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ZIndex = 10

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
    Instance.new("UIStroke", Main).Transparency = 0.8

    -- Title
    local Title = Instance.new("TextLabel", Main)
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 28
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1,-20,0,45)
    Title.Position = UDim2.new(0,10,0,10)
    Title.TextXAlignment = Left
    Title.ZIndex = 11

    -- Tab Buttons
    local TabButtons = Instance.new("Frame", Main)
    TabButtons.Position = UDim2.new(0,10,0,65)
    TabButtons.Size = UDim2.new(0,140,1,-75)
    TabButtons.BackgroundTransparency = 1
    TabButtons.ZIndex = 11

    local TabLayout = Instance.new("UIListLayout", TabButtons)
    TabLayout.Padding = UDim.new(0,8)

    -- Pages
    local Pages = Instance.new("Frame", Main)
    Pages.Position = UDim2.new(0,160,0,65)
    Pages.Size = UDim2.new(1,-170,1,-75)
    Pages.BackgroundTransparency = 1
    Pages.ZIndex = 11

    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 16}):Play()

    -- =====================
    --// TAB
    -- =====================
    function Window:CreateTab(name)
        local Tab = {}

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarImageTransparency = 1
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
        end)

        local TabButton = Instance.new("TextButton", TabButtons)
        TabButton.Size = UDim2.new(1,0,0,36)
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 15
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
        TabButton.BackgroundTransparency = 0.2
        TabButton.BorderSizePixel = 0

        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,10)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        if #Pages:GetChildren() == 1 then
            Page.Visible = true
        end

        -- =====================
        --// BUTTON
        -- =====================
        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1,0,0,42)
            Btn.Text = text
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 16
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Btn.BackgroundTransparency = 0.15
            Btn.BorderSizePixel = 0
            Btn.AutoButtonColor = false

            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,12)

            Btn.MouseButton1Click:Connect(function()
                task.spawn(function()
                    pcall(callback)
                end)
            end)
        end

        return Tab
    end

    function Window:Destroy()
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        Gui:Destroy()
    end

    return Window
end

return Prospext
