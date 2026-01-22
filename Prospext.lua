--[[
    ProspextLib - Orion-style Neon/Glass UI Executor Hub
    Version: 1.0

    Features:
    • Neon/Glass UI
    • Smooth open/close + hover animations
    • Tabs & pages
    • Buttons, Toggles, Sliders
    • Executor/GitHub ready
    • Modular & FishLib-style API

    Credits:
    UI & Framework: ChatGPT
]]

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer

--// Cleanup old UI
pcall(function()
    Player.PlayerGui:FindFirstChild("ProspextUI"):Destroy()
end)

--// Blur Effect
local Blur = Instance.new("BlurEffect")
Blur.Size = 18
Blur.Parent = Lighting

--// ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "ProspextUI"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

--// MAIN LIB TABLE
local Prospext = {}

-- Helper function for neon border
local function createNeon(frame)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0,255,255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

-- Helper function for hover tween
local function hoverTween(obj, hover)
    TweenService:Create(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        BackgroundTransparency = hover and 0.05 or 0.2
    }):Play()
end

-- =========================
--// WINDOW CREATION
-- =========================
function Prospext:CreateWindow(title)
    title = title or "Prospext"

    local Window = {}

    -- Main Frame
    local Main = Instance.new("Frame", Gui)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.Size = UDim2.fromScale(0,0)
    Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Main.BackgroundTransparency = 0.12
    Main.BorderSizePixel = 0
    Main.ZIndex = 10
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)
    createNeon(Main)

    -- Tween open
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Size = UDim2.fromScale(0.45,0.55)
    }):Play()

    -- Title
    local TitleLbl = Instance.new("TextLabel", Main)
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 28
    TitleLbl.TextColor3 = Color3.fromRGB(255,255,255)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1,-20,0,45)
    TitleLbl.Position = UDim2.new(0,10,0,10)
    TitleLbl.TextXAlignment = Left
    TitleLbl.ZIndex = 11

    -- Tab Buttons Frame
    local TabButtons = Instance.new("Frame", Main)
    TabButtons.Position = UDim2.new(0,10,0,65)
    TabButtons.Size = UDim2.new(0,150,1,-75)
    TabButtons.BackgroundTransparency = 1
    TabButtons.ZIndex = 11
    local TabLayout = Instance.new("UIListLayout", TabButtons)
    TabLayout.Padding = UDim.new(0,8)

    -- Pages Frame
    local Pages = Instance.new("Frame", Main)
    Pages.Position = UDim2.new(0,170,0,65)
    Pages.Size = UDim2.new(1,-180,1,-75)
    Pages.BackgroundTransparency = 1
    Pages.ZIndex = 11

    -- =========================
    --// TAB CREATION
    -- =========================
    function Window:CreateTab(name)
        local Tab = {}

        -- Page
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarImageTransparency = 1
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ZIndex = 11

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
        end)

        -- Tab Button
        local TabBtn = Instance.new("TextButton", TabButtons)
        TabBtn.Size = UDim2.new(1,0,0,36)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 15
        TabBtn.TextColor3 = Color3.fromRGB(255,255,255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        TabBtn.BackgroundTransparency = 0.2
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,10)
        createNeon(TabBtn)

        TabBtn.MouseEnter:Connect(function() hoverTween(TabBtn,true) end)
        TabBtn.MouseLeave:Connect(function() hoverTween(TabBtn,false) end)
        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible=false end
            end
            Page.Visible = true
        end)

        if #Pages:GetChildren() == 1 then
            Page.Visible = true
        end

        -- =========================
        --// ADD BUTTON
        -- =========================
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
            createNeon(Btn)

            Btn.MouseEnter:Connect(function() hoverTween(Btn,true) end)
            Btn.MouseLeave:Connect(function() hoverTween(Btn,false) end)

            Btn.MouseButton1Click:Connect(function()
                task.spawn(function()
                    pcall(callback)
                end)
            end)
        end

        -- =========================
        --// ADD TOGGLE
        -- =========================
        function Tab:AddToggle(text, default, callback)
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1,0,0,42)
            Tgl.Text = text.." : "..(default and "ON" or "OFF")
            Tgl.Font = Enum.Font.GothamMedium
            Tgl.TextSize = 16
            Tgl.TextColor3 = Color3.fromRGB(255,255,255)
            Tgl.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Tgl.BackgroundTransparency = 0.15
            Tgl.BorderSizePixel = 0
            Tgl.AutoButtonColor = false
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0,12)
            createNeon(Tgl)

            local state = default

            Tgl.MouseEnter:Connect(function() hoverTween(Tgl,true) end)
            Tgl.MouseLeave:Connect(function() hoverTween(Tgl,false) end)

            Tgl.MouseButton1Click:Connect(function()
                state = not state
                Tgl.Text = text.." : "..(state and "ON" or "OFF")
                task.spawn(function()
                    pcall(callback,state)
                end)
            end)
        end

        -- =========================
        --// ADD SLIDER
        -- =========================
        function Tab:AddSlider(text,min,max,default,callback)
            local SliderFrame = Instance.new("Frame",Page)
            SliderFrame.Size = UDim2.new(1,0,0,50)
            SliderFrame.BackgroundTransparency = 0.2
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,12)
            createNeon(SliderFrame)

            local Label = Instance.new("TextLabel",SliderFrame)
            Label.Text = text.." : "..tostring(default)
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 15
            Label.TextColor3 = Color3.fromRGB(255,255,255)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0,8,0,0)
            Label.Size = UDim2.new(1,-16,0,20)

            local Slider = Instance.new("Frame",SliderFrame)
            Slider.Size = UDim2.new(0.8,0,0,6)
            Slider.Position = UDim2.new(0.1,0,0,30)
            Slider.BackgroundColor3 = Color3.fromRGB(0,255,255)
            Slider.BorderSizePixel = 0
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0,3)

            -- Simple click-drag slider
            local sliding = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    sliding=true
                end
            end)
            SliderFrame.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    sliding=false
                end
            end)
            SliderFrame.InputChanged:Connect(function(input)
                if sliding and input.UserInputType==Enum.UserInputType.MouseMovement then
                    local mouseX = math.clamp(input.Position.X-SliderFrame.AbsolutePosition.X,0,SliderFrame.AbsoluteSize.X)
                    local percent = mouseX/SliderFrame.AbsoluteSize.X
                    local value = math.floor(min + (max-min)*percent)
                    Slider.Size = UDim2.new(percent,0,0,6)
                    Label.Text = text.." : "..value
                    task.spawn(function()
                        pcall(callback,value)
                    end)
                end
            end)
        end

        return Tab
    end

    -- Destroy function
    function Window:Destroy()
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size=0}):Play()
        Gui:Destroy()
    end

    return Window
end

return Prospext
