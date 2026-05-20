--// =========================================================
--// ASHLABS UI LIBRARY V2
--// Advanced Roblox GUI Framework
--// Smooth Drag
--// Tween Animations
--// Loading Screen
--// Modern Dark UI
--// =========================================================

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

--// =========================================================
--// THEME
--// =========================================================

local Theme = {
    Background = Color3.fromRGB(14,14,18),
    Topbar = Color3.fromRGB(18,18,24),
    Sidebar = Color3.fromRGB(16,16,22),

    Card = Color3.fromRGB(24,24,32),
    CardHover = Color3.fromRGB(32,32,42),

    Stroke = Color3.fromRGB(40,40,50),

    Accent = Color3.fromRGB(155,85,255),
    AccentDark = Color3.fromRGB(120,60,220),

    Text = Color3.fromRGB(255,255,255),
    SubText = Color3.fromRGB(170,170,180)
}

--// =========================================================
--// UTILS
--// =========================================================

local function Tween(obj, props, speed)
    TweenService:Create(
        obj,
        TweenInfo.new(
            speed or 0.25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    ):Play()
end

local function Create(class, props)
    local obj = Instance.new(class)

    for i,v in pairs(props) do
        obj[i] = v
    end

    return obj
end

local function Ripple(button)

    local Circle = Create("Frame", {
        Parent = button,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.8,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        Size = UDim2.new(0,0,0,0),
        ZIndex = 999
    })

    Create("UICorner", {
        CornerRadius = UDim.new(1,0),
        Parent = Circle
    })

    Tween(Circle, {
        Size = UDim2.new(0,300,0,300),
        BackgroundTransparency = 1
    },0.6)

    game.Debris:AddItem(Circle,0.7)
end

--// =========================================================
--// DRAG
--// =========================================================

local function MakeDraggable(topbar, object)

    local dragging = false
    local dragStart
    local startPos

    topbar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)

        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            Tween(object,{
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            },0.05)
        end
    end)
end

--// =========================================================
--// INIT
--// =========================================================

function Library:Init()

    local ScreenGui = Create("ScreenGui",{
        Name = "AshlabsUI",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    --// LOADING SCREEN

    local LoadingFrame = Create("Frame",{
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.fromScale(1,1),
        BorderSizePixel = 0
    })

    local Logo = Create("TextLabel",{
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(0.5,0.45),
        Size = UDim2.new(0,300,0,50),
        Font = Enum.Font.GothamBold,
        Text = "ASHLABS",
        TextSize = 34,
        TextColor3 = Theme.Text
    })

    local BarBG = Create("Frame",{
        Parent = LoadingFrame,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(0.5,0.55),
        Size = UDim2.new(0,300,0,8),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = BarBG,
        CornerRadius = UDim.new(1,0)
    })

    local Bar = Create("Frame",{
        Parent = BarBG,
        Size = UDim2.new(0,0,1,0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = Bar,
        CornerRadius = UDim.new(1,0)
    })

    Tween(Bar,{
        Size = UDim2.new(1,0,1,0)
    },1.6)

    Tween(Logo,{
        TextTransparency = 0.2
    },1)

    task.wait(1.8)

    Tween(LoadingFrame,{
        BackgroundTransparency = 1
    },0.5)

    Tween(Logo,{
        TextTransparency = 1
    },0.5)

    Tween(BarBG,{
        BackgroundTransparency = 1
    },0.5)

    Tween(Bar,{
        BackgroundTransparency = 1
    },0.5)

    task.wait(0.6)

    LoadingFrame:Destroy()

    Library.ScreenGui = ScreenGui
end

--// =========================================================
--// WINDOW
--// =========================================================

function Library:CreateWindow(cfg)

    cfg = cfg or {}

    local TitleText = cfg.Title or "Ashlabs"

    local Main = Create("Frame",{
        Parent = self.ScreenGui,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(0,760,0,450),
        Position = UDim2.new(0.5,-380,0.5,-225),
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = Main,
        CornerRadius = UDim.new(0,18)
    })

    local Topbar = Create("Frame",{
        Parent = Main,
        BackgroundColor3 = Theme.Topbar,
        Size = UDim2.new(1,0,0,45),
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = Topbar,
        CornerRadius = UDim.new(0,18)
    })

    local Fix = Create("Frame",{
        Parent = Topbar,
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        Position = UDim2.new(0,0,1,-18),
        Size = UDim2.new(1,0,0,18)
    })

    local Title = Create("TextLabel",{
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,18,0,0),
        Size = UDim2.new(1,0,1,0),
        Font = Enum.Font.GothamBold,
        Text = TitleText,
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Sidebar = Create("Frame",{
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(0,10,0,55),
        Size = UDim2.new(0,170,1,-65),
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = Sidebar,
        CornerRadius = UDim.new(0,14)
    })

    local TabsHolder = Create("ScrollingFrame",{
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0)
    })

    local TabsLayout = Create("UIListLayout",{
        Parent = TabsHolder,
        Padding = UDim.new(0,8)
    })

    local Content = Create("Frame",{
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,190,0,55),
        Size = UDim2.new(1,-200,1,-65)
    })

    MakeDraggable(Topbar,Main)

    local Window = {}
    Window.Tabs = {}

    --// =====================================================
    --// TAB
    --// =====================================================

    function Window:CreateTab(name)

        local TabButton = Create("TextButton",{
            Parent = TabsHolder,
            BackgroundColor3 = Theme.Card,
            Size = UDim2.new(1,-10,0,42),
            Text = "   "..name,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Theme.SubText,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })

        Create("UICorner",{
            Parent = TabButton,
            CornerRadius = UDim.new(0,12)
        })

        local TabFrame = Create("ScrollingFrame",{
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            ScrollBarThickness = 0,
            Visible = false,
            CanvasSize = UDim2.new(0,0,0,0)
        })

        local Layout = Create("UIListLayout",{
            Parent = TabFrame,
            Padding = UDim.new(0,12)
        })

        local function Select()

            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            for _,v in pairs(TabsHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v,{
                        BackgroundColor3 = Theme.Card,
                        TextColor3 = Theme.SubText
                    })
                end
            end

            TabFrame.Visible = true

            Tween(TabButton,{
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Color3.new(1,1,1)
            })
        end

        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            Select()
        end)

        if #Window.Tabs == 0 then
            task.wait()
            Select()
        end

        table.insert(Window.Tabs,TabFrame)

        local Tab = {}

        --// =================================================
        --// SECTION
        --// =================================================

        function Tab:CreateSection(sectionName)

            local Section = Create("Frame",{
                Parent = TabFrame,
                BackgroundColor3 = Theme.Card,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1,0,0,50),
                BorderSizePixel = 0
            })

            Create("UICorner",{
                Parent = Section,
                CornerRadius = UDim.new(0,14)
            })

            local Padding = Create("UIPadding",{
                Parent = Section,
                PaddingTop = UDim.new(0,12),
                PaddingBottom = UDim.new(0,12),
                PaddingLeft = UDim.new(0,12),
                PaddingRight = UDim.new(0,12)
            })

            local Title = Create("TextLabel",{
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,20),
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Holder = Create("Frame",{
                Parent = Section,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,0,0,30),
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1,0,0,0)
            })

            local HolderLayout = Create("UIListLayout",{
                Parent = Holder,
                Padding = UDim.new(0,10)
            })

            local Elements = {}

            --// BUTTON

            function Elements:CreateButton(text,callback)

                callback = callback or function() end

                local Button = Create("TextButton",{
                    Parent = Holder,
                    BackgroundColor3 = Theme.CardHover,
                    Size = UDim2.new(1,0,0,38),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    ClipsDescendants = true
                })

                Create("UICorner",{
                    Parent = Button,
                    CornerRadius = UDim.new(0,10)
                })

                Button.MouseEnter:Connect(function()
                    Tween(Button,{
                        BackgroundColor3 = Theme.Accent
                    })
                end)

                Button.MouseLeave:Connect(function()
                    Tween(Button,{
                        BackgroundColor3 = Theme.CardHover
                    })
                end)

                Button.MouseButton1Click:Connect(function()

                    Ripple(Button)

                    Tween(Button,{
                        Size = UDim2.new(1,-4,0,34)
                    },0.07)

                    task.wait(0.07)

                    Tween(Button,{
                        Size = UDim2.new(1,0,0,38)
                    },0.07)

                    callback()
                end)
            end


            --// SLIDER
            
            function Elements:CreateSlider(text,min,max,default,callback)
            
                callback = callback or function() end
            
                local Value = default or min
                local Dragging = false
            
                local Slider = Create("Frame",{
                    Parent = Holder,
                    BackgroundColor3 = Theme.CardHover,
                    Size = UDim2.new(1,0,0,52),
                    BorderSizePixel = 0
                })
            
                Create("UICorner",{
                    Parent = Slider,
                    CornerRadius = UDim.new(0,10)
                })
            
                local Title = Create("TextLabel",{
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0,12,0,0),
                    Size = UDim2.new(1,-60,0,24),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            
                local ValueLabel = Create("TextLabel",{
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1,0),
                    Position = UDim2.new(1,-12,0,0),
                    Size = UDim2.new(0,50,0,24),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(Value),
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
            
                local Bar = Create("Frame",{
                    Parent = Slider,
                    BackgroundColor3 = Theme.Background,
                    Position = UDim2.new(0,12,0,32),
                    Size = UDim2.new(1,-24,0,6),
                    BorderSizePixel = 0
                })
            
                Create("UICorner",{
                    Parent = Bar,
                    CornerRadius = UDim.new(1,0)
                })
            
                local Fill = Create("Frame",{
                    Parent = Bar,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((Value - min)/(max - min),0,1,0),
                    BorderSizePixel = 0
                })
            
                Create("UICorner",{
                    Parent = Fill,
                    CornerRadius = UDim.new(1,0)
                })
            
                local Circle = Create("Frame",{
                    Parent = Fill,
                    AnchorPoint = Vector2.new(1,0.5),
                    Position = UDim2.new(1,0,0.5,0),
                    Size = UDim2.new(0,14,0,14),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0
                })
            
                Create("UICorner",{
                    Parent = Circle,
                    CornerRadius = UDim.new(1,0)
                })
            
                local function Update(input)
            
                    local SizeScale = math.clamp(
                        (input.Position.X - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )
            
                    local NewValue = math.floor(
                        ((max - min) * SizeScale) + min
                    )
            
                    Value = NewValue
            
                    Tween(Fill,{
                        Size = UDim2.new(SizeScale,0,1,0)
                    },0.08)
            
                    ValueLabel.Text = tostring(NewValue)
            
                    callback(NewValue)
                end
            
                Circle.InputBegan:Connect(function(input)
            
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)
            
                UIS.InputEnded:Connect(function(input)
            
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)
            
                UIS.InputChanged:Connect(function(input)
            
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
            
                Bar.InputBegan:Connect(function(input)
            
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
            
                        Ripple(Slider)
            
                        Update(input)
                    end
                end)
            
                callback(Value)
            end

            --// LABEL

            function Elements:CreateLabel(text)

                local Label = Create("TextLabel",{
                    Parent = Holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Theme.SubText,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                return Label
            end

            --// TOGGLE

            function Elements:CreateToggle(text,default,callback)

                callback = callback or function() end

                local Enabled = default or false

                local Toggle = Create("TextButton",{
                    Parent = Holder,
                    BackgroundColor3 = Theme.CardHover,
                    Size = UDim2.new(1,0,0,40),
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })

                Create("UICorner",{
                    Parent = Toggle,
                    CornerRadius = UDim.new(0,10)
                })

                local Label = Create("TextLabel",{
                    Parent = Toggle,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0,12,0,0),
                    Size = UDim2.new(1,-70,1,0),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Switch = Create("Frame",{
                    Parent = Toggle,
                    AnchorPoint = Vector2.new(1,0.5),
                    Position = UDim2.new(1,-12,0.5,0),
                    Size = UDim2.new(0,42,0,22),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Switch,
                    CornerRadius = UDim.new(1,0)
                })

                local Ball = Create("Frame",{
                    Parent = Switch,
                    Size = UDim2.new(0,18,0,18),
                    Position = UDim2.new(0,2,0.5,-9),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Ball,
                    CornerRadius = UDim.new(1,0)
                })

                local function Refresh()

                    if Enabled then

                        Tween(Switch,{
                            BackgroundColor3 = Theme.Accent
                        })

                        Tween(Ball,{
                            Position = UDim2.new(1,-20,0.5,-9)
                        })

                    else

                        Tween(Switch,{
                            BackgroundColor3 = Theme.Background
                        })

                        Tween(Ball,{
                            Position = UDim2.new(0,2,0.5,-9)
                        })
                    end

                    callback(Enabled)
                end

                Refresh()

                Toggle.MouseButton1Click:Connect(function()

                    Ripple(Toggle)

                    Enabled = not Enabled
                    Refresh()
                end)
            end

            --// DROPDOWN

            function Elements:CreateDropdown(text,list,callback)

                callback = callback or function() end

                local Open = false

                local Dropdown = Create("Frame",{
                    Parent = Holder,
                    BackgroundColor3 = Theme.CardHover,
                    Size = UDim2.new(1,0,0,40),
                    ClipsDescendants = true,
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Dropdown,
                    CornerRadius = UDim.new(0,10)
                })

                local MainButton = Create("TextButton",{
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,40),
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BorderSizePixel = 0
                })

                local Holder = Create("Frame",{
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0,0,0,44),
                    Size = UDim2.new(1,0,0,0)
                })

                local Layout = Create("UIListLayout",{
                    Parent = Holder,
                    Padding = UDim.new(0,5)
                })

                local Count = 0

                for _,option in ipairs(list) do

                    Count += 1

                    local Option = Create("TextButton",{
                        Parent = Holder,
                        BackgroundColor3 = Theme.Background,
                        Size = UDim2.new(1,-10,0,32),
                        Position = UDim2.new(0,5,0,0),
                        Text = option,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.SubText,
                        TextSize = 12,
                        BorderSizePixel = 0
                    })

                    Create("UICorner",{
                        Parent = Option,
                        CornerRadius = UDim.new(0,8)
                    })

                    Option.MouseButton1Click:Connect(function()

                        Ripple(Option)

                        MainButton.Text = text.." : "..option

                        callback(option)
                    end)
                end

                MainButton.MouseButton1Click:Connect(function()

                    Ripple(MainButton)

                    Open = not Open

                    if Open then

                        Tween(Dropdown,{
                            Size = UDim2.new(1,0,0,44 + (Count * 37))
                        })

                    else

                        Tween(Dropdown,{
                            Size = UDim2.new(1,0,0,40)
                        })
                    end
                end)
            end

            return Elements
        end

        return Tab
    end

    return Window
end

--// =========================================================
--// RETURN
--// =========================================================

return Library
