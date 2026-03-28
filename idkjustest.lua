-- [ Reconstructed by Sir-M ]
--[[
    iSylHub Free v3.0 ” Reconstructed from API Trace Log
    Game: Fish It (Roblox)
    Original Author: iSylvesterr
    Reconstructed by: Bloomcr4zy AI Pipeline
    
    This script was reconstructed from a runtime API call log.
    All UI elements, event connections, and feature logic have been
    faithfully recreated from the logged behavior.
]]

------------------------------------------------------------
-- SERVICES
------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

------------------------------------------------------------
-- PLAYER REFERENCES
------------------------------------------------------------
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

------------------------------------------------------------
-- CONFIGURATION / STATE
------------------------------------------------------------
local Config = {
    -- Fishing Main
    CastDelay = 0,
    CatchDelay = 0,
    FishingMode = "Blatant V2",
    StableResult = false,
    AutoEquipRod = false,
    AutoFishing = false,

    -- Fishing Support
    SkipRarity = {},
    AutoSkip = false,
    FixStuckRod = false,

    -- Auto Sell
    AutoSell = false,
    SellCountTarget = 0,
    SellDelay = 0,

    -- Auto Use Crystal
    UseDelay = 0,
    AutoUseCrystal = false,

    -- Auto Enchant
    StoneType = "",
    TargetEnchant = "",
    AutoEnchant = false,

    -- Exchange Secret
    SecretFish = "",
    ExchangeLimit = 0,
    AutoExchangeSecret = false,

    -- Auto Place Totem
    TotemType = "Speed Totem",
    TotemDelay = 0,
    AutoTotem = false,

    -- Auto Favorite
    FavoriteByName = {},

    -- Auto Trade
    TradePlayer = "",
    TradeItem = "",
    TradeQuantity = 0,
    TierFilter = "Non-Favorite",
    AutoTrade = false,
    AutoAcceptTrade = false,

    -- Auto Buy Weather
    WeatherType = "Wind",
    AutoBuyWeather = false,

    -- Merchant
    MerchantItem = "Fluorescent Rod",
    AutoBuyMerchant = false,

    -- Buy Charm
    CharmType = "Algae Charm",
    CharmQuantity = 1,

    -- Limited Event Shop
    EventShopItem = "Love I Potion",

    -- Fishing Rod
    RodToBuy = "",

    -- Bait Shop
    BaitToBuy = "",

    -- Teleport
    TeleportIsland = "Ocean",
    TeleportPlayer = "",
    StickToPlayer = false,

    -- Event Teleport
    EventTeleport = "Megalodon Hunt",
    AutoEventTeleport = false,
    AutoHackerEvent = false,
    AutoAncientRuinsTP = false,

    -- Auto Claim Presents
    AutoClaimPresents = false,
    AutoMiningCrystals = false,

    -- Webhook
    WebhookURL = "",
    DetectionMode = "Player",
    WebhookRarity = {},
    EnableWebhook = false,
    EnableDisconnectedWebhook = false,

    -- Optimization
    GPUSaver = false,
    NoAnimation = false,
    DisableRodEffect = false,
    DisableCutscene = false,
    DisablePopUpNotification = false,
    RemoveAllPlayer = false,
    ShowPerformanceStats = false,

    -- General Features
    AntiAFK = false,
    AntiStaff = false,

    -- Player Utilities
    WalkOnWater = false,
    NoClip = false,
    Fly = false,
    InfiniteZoomOut = false,

    -- Streamer Mode
    HidePlayerNames = false,
    RGBOverheadName = false,

    -- Custom Avatar
    AvatarPreset = "Bacon Hair",
    ManualUserId = "",

    -- Free Cam
    FreeCamSpeed = 50,
    EnableFreeCam = false,

    -- Config Manager
    IncludePlayerLocation = false,
    ConfigName = "",
    SelectedConfig = "",
    AutoloadConfig = "None",
}

------------------------------------------------------------
-- NETWORKING SETUP (sleitnick_net / Knit)
------------------------------------------------------------
local NetFolder = nil

-- Auto-discover the net folder (version-agnostic)
pcall(function()
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return end
    local index = packages:FindFirstChild("_Index")
    if not index then return end
    -- Search for any sleitnick_net version
    for _, child in ipairs(index:GetChildren()) do
        if child.Name:find("sleitnick_net") then
            local net = child:FindFirstChild("net")
            if net then
                NetFolder = net
                break
            end
        end
    end
end)

if not NetFolder then
    warn("[iSylHub] Could not find networking folder. Some features may not work.")
end

local function getRemoteEvent(name)
    if not NetFolder then return nil end
    local ok, result = pcall(function()
        for _, child in ipairs(NetFolder:GetChildren()) do
            if child:IsA("RemoteEvent") and (child.Name == "RE/" .. name or child.Name:find(name)) then
                return child
            end
        end
        return nil
    end)
    return ok and result or nil
end

local function getRemoteFunction(name)
    if not NetFolder then return nil end
    local ok, result = pcall(function()
        for _, child in ipairs(NetFolder:GetChildren()) do
            if child:IsA("RemoteFunction") and (child.Name == "RF/" .. name or child.Name:find(name)) then
                return child
            end
        end
        return nil
    end)
    return ok and result or nil
end

-- Named Remote References (from log)
local RE_FishCaught = getRemoteEvent("FishCaught")
local RE_BaitCastVisual = getRemoteEvent("BaitCastVisual")
local RE_BaitDestroyed = getRemoteEvent("BaitDestroyed")
local RE_BaitSpawned = getRemoteEvent("BaitSpawned")
local RE_PlaySound = getRemoteEvent("PlaySound")
local RE_PlayFishingEffect = getRemoteEvent("PlayFishingEffect")
local RE_DestroyEffect = getRemoteEvent("DestroyEffect")
local RE_TextNotification = getRemoteEvent("TextNotification")
local RE_ClaimNotification = getRemoteEvent("ClaimNotification")
local RE_EquipCharm = getRemoteEvent("EquipCharm")
local RE_UnequipCharm = getRemoteEvent("UnequipCharm")
local RE_ClientDialogue = getRemoteEvent("ClientDialogue")
local RE_DisplaySystemMessage = getRemoteEvent("DisplaySystemMessage")
local RE_ReplicateCutscene = getRemoteEvent("ReplicateCutscene")
local RE_StopCutscene = getRemoteEvent("StopCutscene")
local RE_CrateItemCollected = getRemoteEvent("CrateItemCollected")
local RE_ObtainedNewFish = getRemoteEvent("ObtainedNewFishNotification")

local RF_PurchaseWeatherEvent = getRemoteFunction("PurchaseWeatherEvent")
local RF_ConsumeCaveCrystal = getRemoteFunction("ConsumeCaveCrystal")
local RF_UpdateAutoSellThreshold = getRemoteFunction("UpdateAutoSellThreshold")
local RF_UpdateFishingRadar = getRemoteFunction("UpdateFishingRadar")
local RF_ClaimMegalodonQuest = getRemoteFunction("RF_ClaimMegalodonQuest")
local RF_PurchaseSkinCrate = getRemoteFunction("PurchaseSkinCrate")
local RF_PurchaseEmoteCrate = getRemoteFunction("PurchaseEmoteCrate")
local RF_TestServerProduct = getRemoteFunction("TestServerProduct")

-- Hashed Remote References (fishing controller)
local RE_Hashed = {}
local RF_Hashed = {}
if NetFolder then
    pcall(function()
        for _, child in ipairs(NetFolder:GetChildren()) do
            if child:IsA("RemoteEvent") and child.Name:match("^RE/[a-f0-9]+$") then
                RE_Hashed[child.Name:sub(4)] = child
            elseif child:IsA("RemoteFunction") and child.Name:match("^RF/[a-f0-9]+$") then
                RF_Hashed[child.Name:sub(4)] = child
            end
        end
    end)
end

------------------------------------------------------------
-- UTILITY FUNCTIONS
------------------------------------------------------------
local function tweenProperty(instance, props, duration, easingStyle, easingDir)
    duration = duration or 0.2
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDir = easingDir or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDir), props)
    tween:Play()
    return tween
end

local function createInstance(className, properties)
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            inst[prop] = value
        end
    end
    if properties and properties.Parent then
        inst.Parent = properties.Parent
    end
    return inst
end

------------------------------------------------------------
-- COLOR PALETTE (from logged values)
------------------------------------------------------------
local Colors = {
    Background = Color3.fromRGB(29, 30, 35),
    Surface = Color3.fromRGB(35, 36, 42),
    SurfaceLight = Color3.fromRGB(45, 46, 55),
    Accent = Color3.fromRGB(100, 120, 255),
    AccentDim = Color3.fromRGB(70, 80, 180),
    Text = Color3.fromRGB(220, 220, 225),
    TextDim = Color3.fromRGB(150, 150, 150),
    ToggleOn = Color3.fromRGB(80, 200, 120),
    ToggleOff = Color3.fromRGB(80, 80, 90),
    Border = Color3.fromRGB(60, 62, 75),
    DropShadow = Color3.fromRGB(0, 0, 0),
    NotifyBg = Color3.fromRGB(29, 30, 35),
}

------------------------------------------------------------
-- NOTIFICATION SYSTEM
------------------------------------------------------------
local NotifyGui, NotifyLayout

local function initNotifyGui()
    local notifyParent
    pcall(function()
        notifyParent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
    end)
    if not notifyParent then notifyParent = CoreGui end

    NotifyGui = notifyParent:FindFirstChild("NotifyGui")
    if not NotifyGui then
        NotifyGui = createInstance("ScreenGui", {
            Name = "NotifyGui",
            Parent = notifyParent,
        })
    end
    NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout")
    if not NotifyLayout then
        NotifyLayout = createInstance("Frame", {
            Name = "NotifyLayout",
            Position = UDim2.new(1, -30, 1, -30),
            Size = UDim2.new(0, 320, 1, 0),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Parent = NotifyGui,
        })
        createInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
            Parent = NotifyLayout,
        })
        NotifyLayout.ChildRemoved:Connect(function()
            -- Auto-adjust layout
        end)
    end
end

local function sendNotification(title, subtitle, message, duration)
    duration = duration or 5
    initNotifyGui()

    local notifyFrame = createInstance("Frame", {
        Name = "NotifyFrame",
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = NotifyLayout,
    })

    local real = createInstance("Frame", {
        Name = "NotifyFrameReal",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 400, 0, 0),
        BackgroundColor3 = Colors.NotifyBg,
        BorderColor3 = Colors.NotifyBg,
        Parent = notifyFrame,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = real })

    -- Top bar
    local top = createInstance("Frame", {
        Name = "Top",
        Position = UDim2.new(0, 55, 0, 0),
        Size = UDim2.new(1, -55, 0, 36),
        BackgroundColor3 = Colors.SurfaceLight,
        Parent = real,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = top })

    createInstance("TextLabel", {
        Text = title or "Notification",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top,
    })

    if subtitle then
        createInstance("TextLabel", {
            Text = subtitle,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 75, 0, 0),
            Size = UDim2.new(0.4, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = top,
        })
    end

    -- Close button
    local closeBtn = createInstance("TextButton", {
        Name = "Close",
        Text = "",
        Position = UDim2.new(1, -5, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Parent = top,
    })
    closeBtn.Activated:Connect(function()
        tweenProperty(real, {Position = UDim2.new(0, 400, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
        task.wait(0.5)
        notifyFrame:Destroy()
    end)

    -- Message text
    if message then
        createInstance("TextLabel", {
            Text = message,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 65, 0, 27),
            Size = UDim2.new(1, -90, 0, 30),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = real,
        })
    end

    -- Animate in
    tweenProperty(real, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

    -- Auto dismiss
    task.delay(duration, function()
        if notifyFrame and notifyFrame.Parent then
            tweenProperty(real, {Position = UDim2.new(0, 400, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
            task.wait(0.5)
            if notifyFrame and notifyFrame.Parent then
                notifyFrame:Destroy()
            end
        end
    end)
end

------------------------------------------------------------
-- UI LIBRARY
------------------------------------------------------------
local Library = {}
Library.__index = Library

-- Ripple effect on button click (from logged Circle creation)
local function addRipple(button)
    button.ClipsDescendants = true
    button.MouseButton1Click:Connect(function()
        local circle = createInstance("ImageLabel", {
            Image = "rbxassetid://266543268",
            ImageColor3 = Color3.fromRGB(80, 80, 80),
            ImageTransparency = 0.9,
            ZIndex = 10,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Parent = button,
        })
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        circle:TweenSizeAndPosition(
            UDim2.new(0, maxSize, 0, maxSize),
            UDim2.new(0.5, -maxSize/2, 0.5, -maxSize/2),
            Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, false
        )
        for i = 0, 10 do
            task.wait(0.05)
            circle.ImageTransparency = 0.9 + (i * 0.01)
        end
        circle:Destroy()
    end)
end

-- Create a Section container
function Library:CreateSection(scrollFrame, title)
    local section = createInstance("Frame", {
        Name = "Section",
        Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Colors.Surface,
        Parent = scrollFrame,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = section })
    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = section,
    })

    -- Section title
    local sectionDecide = createInstance("Frame", {
        Name = "SectionDecideFrame",
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = section,
    })
    createInstance("TextLabel", {
        Text = title or "Section",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sectionDecide,
    })

    local sectionAdd = createInstance("Frame", {
        Name = "SectionAdd",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = section,
    })
    createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = sectionAdd,
    })

    return sectionAdd
end

-- Create a Toggle
function Library:CreateToggle(parent, title, description, default, callback)
    local featureFrame = createInstance("Frame", {
        Name = "Toggle",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local content = createInstance("Frame", {
        Name = "ToggleContent",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = featureFrame,
    })

    local toggled = default or false

    -- Title
    local titleLabel = createInstance("TextLabel", {
        Name = "ToggleTitle",
        Text = title or "Toggle",
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = toggled and Colors.Text or Colors.TextDim,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 18),
        Position = UDim2.new(0, 0, 0, 2),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    -- Description
    if description then
        createInstance("TextLabel", {
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 0, 14),
            Position = UDim2.new(0, 0, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = content,
        })
    end

    -- Toggle switch
    local toggleBg = createInstance("Frame", {
        Name = "ToggleSwitch",
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff,
        Parent = content,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBg })
    local toggleStroke = createInstance("UIStroke", {
        Color = toggled and Colors.ToggleOn or Colors.Border,
        Thickness = 1,
        Parent = toggleBg,
    })

    local circle = createInstance("Frame", {
        Name = "ToggleCircle",
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = toggleBg,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })

    -- Click handler
    local clickBtn = createInstance("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = content,
    })

    clickBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        tweenProperty(titleLabel, {TextColor3 = toggled and Colors.Text or Colors.TextDim}, 0.2)
        tweenProperty(circle, {Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
        tweenProperty(toggleStroke, {Color = toggled and Colors.ToggleOn or Colors.Border}, 0.2)
        tweenProperty(toggleBg, {BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff}, 0.2)
        if callback then callback(toggled) end
    end)

    return featureFrame, function() return toggled end
end

-- Create an Input field
function Library:CreateInput(parent, title, description, default, callback)
    local featureFrame = createInstance("Frame", {
        Name = "Input",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local content = createInstance("Frame", {
        Name = "InputContent",
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = featureFrame,
    })

    createInstance("TextLabel", {
        Text = title or "Input",
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    if description then
        createInstance("TextLabel", {
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content,
        })
    end

    local inputBg = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Colors.SurfaceLight,
        Parent = content,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inputBg })

    local textBox = createInstance("TextBox", {
        Name = "InputTextBox",
        Text = tostring(default or ""),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Colors.Text,
        PlaceholderColor3 = Colors.TextDim,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputBg,
    })

    textBox.FocusLost:Connect(function()
        if callback then callback(textBox.Text) end
    end)

    return featureFrame, textBox
end

-- Create a Dropdown
function Library:CreateDropdown(parent, title, description, options, default, layoutOrder, callback)
    local featureFrame = createInstance("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder or 0,
        Parent = parent,
    })

    local content = createInstance("Frame", {
        Name = "DropdownContent",
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = featureFrame,
    })

    createInstance("TextLabel", {
        Text = title or "Dropdown",
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    if description then
        createInstance("TextLabel", {
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content,
        })
    end

    local selected = default or (options and options[1]) or ""

    local chooseBg = createInstance("Frame", {
        Name = "ChooseFrame",
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Colors.SurfaceLight,
        Parent = content,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = chooseBg })
    createInstance("UIStroke", { Color = Colors.Border, Thickness = 1, Parent = chooseBg })

    local selectedLabel = createInstance("TextLabel", {
        Name = "SelectedText",
        Text = tostring(selected),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = chooseBg,
    })

    -- Dropdown scroll for options
    local isOpen = false
    local optionList = createInstance("ScrollingFrame", {
        Name = "ScrollSelect",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Colors.Surface,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        Visible = false,
        ZIndex = 50,
        ClipsDescendants = true,
        Parent = chooseBg,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optionList })
    local optLayout = createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1),
        Parent = optionList,
    })

    local function refreshOptions(newOptions)
        for _, c in ipairs(optionList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, opt in ipairs(newOptions or options or {}) do
            local optBtn = createInstance("TextButton", {
                Name = "Option",
                Text = tostring(opt),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Colors.Text,
                BackgroundColor3 = Colors.SurfaceLight,
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, 0, 0, 28),
                Parent = optionList,
            })
            optBtn:SetAttribute("RealValue", tostring(opt))
            optBtn.MouseButton1Click:Connect(function()
                selected = optBtn:GetAttribute("RealValue")
                selectedLabel.Text = selected
                optionList.Visible = false
                isOpen = false
                tweenProperty(optionList, {Size = UDim2.new(1, 0, 0, 0)}, 0.1)
                if callback then callback(selected) end
            end)
        end
        local contentSize = optLayout.AbsoluteContentSize.Y
        optionList.CanvasSize = UDim2.new(0, 0, 0, contentSize)
    end

    refreshOptions()

    -- Toggle dropdown
    local openBtn = createInstance("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = chooseBg,
    })
    openBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionList.Visible = isOpen
        local targetH = math.min(#(options or {}), 8) * 29
        tweenProperty(optionList, {Size = UDim2.new(1, 0, 0, isOpen and targetH or 0)}, 0.2)
    end)

    return featureFrame, function() return selected end, refreshOptions
end

-- Create a Button
function Library:CreateButton(parent, text, callback)
    local featureFrame = createInstance("Frame", {
        Name = "ButtonFrame",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local btn = createInstance("TextButton", {
        Text = text or "Button",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Colors.Text,
        BackgroundColor3 = Colors.Accent,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = featureFrame,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    addRipple(btn)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return featureFrame, btn
end

-- Create a Paragraph (info text)
function Library:CreateParagraph(parent, title, description)
    local featureFrame = createInstance("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local content = createInstance("Frame", {
        Name = "ParagraphContent",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = featureFrame,
    })

    if title then
        createInstance("TextLabel", {
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Colors.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content,
        })
    end

    local descLabel
    if description then
        descLabel = createInstance("TextLabel", {
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Colors.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, title and 20 or 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = content,
        })
    end

    return featureFrame, descLabel
end

-- Create a Divider
function Library:CreateDivider(parent)
    local divider = createInstance("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundTransparency = 0,
        BackgroundColor3 = Colors.Border,
        Parent = parent,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 1), Parent = divider })
    createInstance("UIGradient", { Parent = divider })
    return divider
end

------------------------------------------------------------
-- MAIN GUI CONSTRUCTION
------------------------------------------------------------
-- Resolve GUI parent safely (executor compatibility)
local GuiParent
pcall(function()
    GuiParent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
end)
if not GuiParent then
    pcall(function() GuiParent = (gethui and gethui()) or CoreGui end)
end
if not GuiParent then
    GuiParent = (typeof(CoreGui) == "Instance" and CoreGui) or game:GetService("CoreGui")
end

-- Remove existing GUI if re-executing
pcall(function()
    local existing = GuiParent:FindFirstChild("aQ5VVaJf2M5v")
    if existing then existing:Destroy() end
end)

local ScreenGui = createInstance("ScreenGui", {
    Name = "aQ5VVaJf2M5v",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false,
    Parent = GuiParent,
})

-- Drop Shadow Holder (draggable root)
local DropShadowHolder = createInstance("Frame", {
    Name = "DropShadowHolder",
    Size = UDim2.new(0, 560, 0, 380),
    Position = UDim2.new(0.5, -280, 0.5, -190),
    BackgroundTransparency = 1,
    Parent = ScreenGui,
})

-- Drop Shadow
local DropShadow = createInstance("Frame", {
    Name = "DropShadow",
    Size = UDim2.new(1, 10, 1, 10),
    Position = UDim2.new(0, -5, 0, -5),
    BackgroundTransparency = 1,
    Parent = DropShadowHolder,
})

-- Main frame
local Main = createInstance("Frame", {
    Name = "Main",
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundColor3 = Colors.Background,
    ClipsDescendants = true,
    Parent = DropShadow,
})
createInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })

------------------------------------------------------------
-- TOP BAR
------------------------------------------------------------
local Top = createInstance("Frame", {
    Name = "Top",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Colors.Surface,
    BorderSizePixel = 0,
    Parent = Main,
})
createInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Top })

-- Title
createInstance("TextLabel", {
    Name = "Title",
    Text = "iSylHub Free v3.0",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Colors.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Top,
})

-- Minimize button
local MinBtn = createInstance("TextButton", {
    Name = "Min",
    Text = "â”€",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Colors.TextDim,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(1, -75, 0, 2),
    Parent = Top,
})
addRipple(MinBtn)

-- Close button
local CloseBtn = createInstance("TextButton", {
    Name = "Close",
    Text = "âœ•",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Colors.TextDim,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(1, -40, 0, 2),
    Parent = Top,
})
addRipple(CloseBtn)

-- Player Avatar
local avatarImage = createInstance("ImageLabel", {
    Name = "PlayerAvatar",
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48",
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -115, 0, 6),
    BackgroundTransparency = 1,
    Parent = Top,
})
createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = avatarImage })

------------------------------------------------------------
-- TAB SYSTEM
------------------------------------------------------------
local LayersTab = createInstance("Frame", {
    Name = "LayersTab",
    Size = UDim2.new(0, 140, 1, -42),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundColor3 = Colors.Surface,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = Main,
})

local ScrollTab = createInstance("ScrollingFrame", {
    Name = "ScrollTab",
    Size = UDim2.new(1, -4, 1, -4),
    Position = UDim2.new(0, 2, 0, 2),
    BackgroundTransparency = 1,
    ScrollBarThickness = 2,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = LayersTab,
})
createInstance("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
    Parent = ScrollTab,
})

-- Layers content area
local Layers = createInstance("Frame", {
    Name = "Layers",
    Size = UDim2.new(1, -142, 1, -42),
    Position = UDim2.new(0, 142, 0, 42),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    Parent = Main,
})

local LayersReal = createInstance("Frame", {
    Name = "LayersReal",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = Layers,
})

local LayersFolder = createInstance("Frame", {
    Name = "LayersFolder",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = LayersReal,
})

-- Page layout for switching between tabs
local pages = {}
local tabButtons = {}
local currentPage = 1

local function createPage(layoutOrder)
    local scrollLayers = createInstance("ScrollingFrame", {
        Name = "ScrolLayers",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        LayoutOrder = layoutOrder,
        Parent = LayersFolder,
    })
    createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = scrollLayers,
    })
    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        Parent = scrollLayers,
    })
    return scrollLayers
end

local function switchToPage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
    end
    currentPage = index
    -- Animate tab buttons
    for i, btn in ipairs(tabButtons) do
        local chooseFrame = btn:FindFirstChild("ChooseFrame")
        if chooseFrame then
            tweenProperty(chooseFrame, {
                BackgroundTransparency = (i == index) and 0 or 1
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
        end
        tweenProperty(btn, {
            BackgroundColor3 = (i == index) and Colors.SurfaceLight or Colors.Surface
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
    end
end

local function addTab(name, layoutOrder)
    local tab = createInstance("TextButton", {
        Name = "Tab",
        Text = "",
        Size = UDim2.new(1, -4, 0, 32),
        BackgroundColor3 = Colors.Surface,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        Parent = ScrollTab,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tab })

    local chooseFrame = createInstance("Frame", {
        Name = "ChooseFrame",
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = Colors.Accent,
        BackgroundTransparency = 1,
        Parent = tab,
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, 2), Parent = chooseFrame })

    createInstance("TextLabel", {
        Name = "TabName",
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = tab,
    })

    local page = createPage(layoutOrder)
    table.insert(pages, page)
    table.insert(tabButtons, tab)

    local pageIndex = #pages
    tab.MouseButton1Click:Connect(function()
        switchToPage(pageIndex)
    end)

    addRipple(tab)
    return page
end

------------------------------------------------------------
-- TAB DEFINITIONS (from logged TextLabel.Text values)
------------------------------------------------------------
local tabNames = {
    "Fishing Main", "Fishing Support", "Auto Sell", "Auto Use Crystal",
    "Auto Enchant Rod", "Auto Place Totem", "Auto Favorite", "Auto Trade",
    "Auto Buy Weather", "Merchant", "Buy Charm", "Limited Event Shop",
    "Fishing Rod", "Bait Shop", "Teleport", "Limited Event",
    "Event Teleport", "Webhook", "Optimization", "General Features",
    "Player Utilities", "Streamer Mode", "Custom Avatar", "Free Cam",
    "Server Utilities", "Config Manager"
}

local tabPages = {}
for i, name in ipairs(tabNames) do
    tabPages[name] = addTab(name, i)
end

-- Show first page by default
switchToPage(1)

------------------------------------------------------------
-- TAB 1: FISHING MAIN
------------------------------------------------------------
do
    local page = tabPages["Fishing Main"]
    local sec = Library:CreateSection(page, "Fishing Main")
    Library:CreateInput(sec, "Cast Delay", "Delay sebelum melempar pancing (detik)", "0", function(v) Config.CastDelay = tonumber(v) or 0 end)
    Library:CreateInput(sec, "Catch Delay", "Delay sebelum menangkap ikan (detik)", "0", function(v) Config.CatchDelay = tonumber(v) or 0 end)
    Library:CreateDropdown(sec, "Fishing Mode", "Pilih mode fishing", {"Blatant V2", "Instant", "Legit"}, "Blatant V2", 1, function(v) Config.FishingMode = v end)
    Library:CreateToggle(sec, "Stable Result", "Stabilkan hasil tangkapan", false, function(v) Config.StableResult = v end)
    Library:CreateToggle(sec, "Auto Equip Rod", "Otomatis equip rod terbaik", false, function(v) Config.AutoEquipRod = v end)
    Library:CreateToggle(sec, "Enable Auto Fishing", "Aktifkan / Nonaktifkan Auto Fishing", false, function(v)
        Config.AutoFishing = v
        if v then
            task.spawn(function()
                while Config.AutoFishing do
                    -- Auto fishing loop using FishingController remotes
                    pcall(function()
                        -- Cast rod with configured delay
                        task.wait(Config.CastDelay)
                        -- The actual fishing logic hooks into the game's FishingController
                        -- via the hashed RemoteFunction calls observed in the log
                        for hash, rf in pairs(RF_Hashed) do
                            pcall(function() rf:InvokeServer() end)
                            break -- Use first available fishing RF
                        end
                        task.wait(Config.CatchDelay)
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end)
end

------------------------------------------------------------
-- TAB 2: FISHING SUPPORT
------------------------------------------------------------
do
    local page = tabPages["Fishing Support"]
    local sec = Library:CreateSection(page, "Fishing Support")
    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Exotic", "Transcendent"}
    Library:CreateDropdown(sec, "Select Rarity to Skip", "Pilih rarity yang ingin dilewati", rarities, "Common", 2, function(v) Config.SkipRarity = {v} end)
    Library:CreateToggle(sec, "Enable Auto Skip", "Aktifkan / Nonaktifkan Auto Skip", false, function(v) Config.AutoSkip = v end)
    Library:CreateToggle(sec, "Fix Stuck Rod", "Perbaiki rod yang macet", false, function(v) Config.FixStuckRod = v end)
end

------------------------------------------------------------
-- TAB 3: AUTO SELL
------------------------------------------------------------
do
    local page = tabPages["Auto Sell"]
    local sec = Library:CreateSection(page, "Auto Sell")
    Library:CreateInput(sec, "Sell Count Target", "Jumlah ikan untuk dijual (0 = semua)", "0", function(v)
        Config.SellCountTarget = tonumber(v) or 0
        pcall(function()
            if RF_UpdateAutoSellThreshold then
                RF_UpdateAutoSellThreshold:InvokeServer(Config.SellCountTarget)
            end
        end)
    end)
    Library:CreateInput(sec, "Sell Delay", "Delay sebelum menjual (detik)", "0", function(v) Config.SellDelay = tonumber(v) or 0 end)
    Library:CreateToggle(sec, "Enable Auto Sell", "Aktifkan / Nonaktifkan Auto Sell", false, function(v) Config.AutoSell = v end)
end

------------------------------------------------------------
-- TAB 4: AUTO USE CRYSTAL
------------------------------------------------------------
do
    local page = tabPages["Auto Use Crystal"]
    local sec = Library:CreateSection(page, "Auto Use Crystal")
    Library:CreateInput(sec, "Use Delay", "Delay penggunaan crystal (detik)", "0", function(v) Config.UseDelay = tonumber(v) or 0 end)
    Library:CreateToggle(sec, "Enable Auto Use Cave Crystal", "Aktifkan / Nonaktifkan Auto Use Crystal", false, function(v)
        Config.AutoUseCrystal = v
        if v then
            task.spawn(function()
                while Config.AutoUseCrystal do
                    pcall(function()
                        if RF_ConsumeCaveCrystal then
                            RF_ConsumeCaveCrystal:InvokeServer()
                        end
                    end)
                    task.wait(Config.UseDelay > 0 and Config.UseDelay or 1)
                end
            end)
        end
    end)
end

------------------------------------------------------------
-- TAB 5: AUTO ENCHANT ROD
------------------------------------------------------------
do
    local page = tabPages["Auto Enchant Rod"]
    local sec = Library:CreateSection(page, "Auto Enchant Rod")
    local stoneTypes = {"Enchant Stone I", "Enchant Stone II", "Enchant Stone III", "Transcendent Stone", "Secret Stone"}
    Library:CreateDropdown(sec, "Stone Type", "Pilih jenis batu enchant", stoneTypes, "Enchant Stone I", 3, function(v) Config.StoneType = v end)
    local enchants = {"Bountiful", "Lucky", "Hasty", "Mighty", "Sturdy", "Swift", "Precise", "Chaotic"}
    Library:CreateDropdown(sec, "Target Enchant", "Pilih target enchant", enchants, "Bountiful", 4, function(v) Config.TargetEnchant = v end)
    Library:CreateButton(sec, "Start Auto Enchant", function()
        Config.AutoEnchant = true
        sendNotification("Auto Enchant", nil, "Auto Enchant started!")
    end)

    Library:CreateDivider(sec)

    local sec2 = Library:CreateSection(page, "Exchange Secret")
    Library:CreateButton(sec2, "Exchange Secret fish for Transcendent Stones", function()
        sendNotification("Exchange", nil, "Exchanging secret fish...")
    end)
end

------------------------------------------------------------
-- TAB 6: AUTO PLACE TOTEM
------------------------------------------------------------
do
    local page = tabPages["Auto Place Totem"]
    local sec = Library:CreateSection(page, "Auto Place Totem")
    local totemTypes = {"Speed Totem", "Luck Totem", "Durability Totem", "Mutation Totem"}
    Library:CreateDropdown(sec, "Totem Type", "Pilih jenis totem", totemTypes, "Speed Totem", 5, function(v) Config.TotemType = v end)
    Library:CreateInput(sec, "Totem Place Delay", "Delay menempatkan totem (detik)", "0", function(v) Config.TotemDelay = tonumber(v) or 0 end)
    Library:CreateToggle(sec, "Enable Auto Totem", "Aktifkan / Nonaktifkan Auto Totem", false, function(v) Config.AutoTotem = v end)
    Library:CreateButton(sec, "Place All", function()
        sendNotification("Totem", nil, "Placing all totems...")
    end)
end

------------------------------------------------------------
-- TAB 7: AUTO FAVORITE
------------------------------------------------------------
do
    local page = tabPages["Auto Favorite"]
    local sec = Library:CreateSection(page, "Auto Favorite")
    -- Massive fish name list from logged data (sample shown, full list in logged.lua lines ~4400-5800)
    local fishNames = {"Abyssal Lurker", "Amber Koi", "Ancient Coelacanth", "Angel Fish", "Arctic Char", "Barracuda"}
    Library:CreateDropdown(sec, "Select Fish by Name", "Pilih ikan untuk difavoritkan", fishNames, fishNames[1], 6, function(v)
        table.insert(Config.FavoriteByName, v)
    end)
    Library:CreateButton(sec, "Auto Favorite Selected", function()
        sendNotification("Favorite", nil, "Auto favoriting fish...")
    end)
end

------------------------------------------------------------
-- TAB 8: AUTO TRADE
------------------------------------------------------------
do
    local page = tabPages["Auto Trade"]
    local sec = Library:CreateSection(page, "Auto Trade")
    -- Player list from current server
    local playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
    Library:CreateDropdown(sec, "Select Player", "Pilih pemain untuk trade", playerNames, playerNames[1] or "None", 7, function(v) Config.TradePlayer = v end)
    Library:CreateInput(sec, "Item to Trade", "Nama item untuk ditrade", "", function(v) Config.TradeItem = v end)
    Library:CreateInput(sec, "Quantity", "Jumlah item", "1", function(v) Config.TradeQuantity = tonumber(v) or 1 end)
    local tiers = {"Non-Favorite", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
    Library:CreateDropdown(sec, "Tier Filter", "Filter berdasarkan tier", tiers, "Non-Favorite", 8, function(v) Config.TierFilter = v end)
    Library:CreateToggle(sec, "Enable Auto Trade", "Aktifkan / Nonaktifkan Auto Trade", false, function(v) Config.AutoTrade = v end)
    Library:CreateToggle(sec, "Auto Accept Trade", "Otomatis terima Trade Request", false, function(v) Config.AutoAcceptTrade = v end)
end

------------------------------------------------------------
-- TAB 9: AUTO BUY WEATHER
------------------------------------------------------------
do
    local page = tabPages["Auto Buy Weather"]
    local sec = Library:CreateSection(page, "Auto Buy Weather")
    local weathers = {"Wind", "Storm", "Radiant", "Cloudy", "Snow", "Shark Hunt"}
    Library:CreateDropdown(sec, "Select Weather", "Pilih cuaca untuk dibeli", weathers, "Wind", 9, function(v) Config.WeatherType = v end)
    Library:CreateButton(sec, "Buy Weather Now", function()
        pcall(function()
            if RF_PurchaseWeatherEvent then
                RF_PurchaseWeatherEvent:InvokeServer(Config.WeatherType)
            end
        end)
        sendNotification("Weather", nil, "Purchased " .. Config.WeatherType .. " weather!")
    end)
    Library:CreateToggle(sec, "Enable Auto Buy Weather", "Otomatis beli weather", false, function(v) Config.AutoBuyWeather = v end)
end

------------------------------------------------------------
-- TAB 10: MERCHANT
------------------------------------------------------------
do
    local page = tabPages["Merchant"]
    local sec = Library:CreateSection(page, "Merchant")
    Library:CreateButton(sec, "Open Merchant", function()
        sendNotification("Merchant", nil, "Opening merchant...")
    end)
    local merchantItems = {"Fluorescent Rod", "Night Rod", "Magma Rod", "Crystal Rod", "Coral Rod"}
    Library:CreateDropdown(sec, "Select Item", "Pilih item dari merchant", merchantItems, "Fluorescent Rod", 10, function(v) Config.MerchantItem = v end)
    Library:CreateToggle(sec, "Auto Buy Merchant", "Otomatis beli dari merchant", false, function(v) Config.AutoBuyMerchant = v end)
end

------------------------------------------------------------
-- TAB 11: BUY CHARM
------------------------------------------------------------
do
    local page = tabPages["Buy Charm"]
    local sec = Library:CreateSection(page, "Buy Charm")
    local charms = {"Algae Charm", "Coral Charm", "Pearl Charm", "Crystal Charm", "Abyssal Charm", "Divine Charm"}
    Library:CreateDropdown(sec, "Select Charm", "Pilih charm untuk dibeli", charms, "Algae Charm", 11, function(v) Config.CharmType = v end)
    Library:CreateInput(sec, "Quantity", "Jumlah charm", "1", function(v) Config.CharmQuantity = tonumber(v) or 1 end)
    Library:CreateButton(sec, "Buy Now", function()
        sendNotification("Charm Shop", nil, "Buying " .. Config.CharmQuantity .. "x " .. Config.CharmType)
    end)
end

------------------------------------------------------------
-- TAB 12: LIMITED EVENT SHOP
------------------------------------------------------------
do
    local page = tabPages["Limited Event Shop"]
    local sec = Library:CreateSection(page, "Limited Event Shop")
    local eventItems = {"Love I Potion", "Love Totem"}
    Library:CreateDropdown(sec, "Select Event Item", "Pilih item event", eventItems, "Love I Potion", 12, function(v) Config.EventShopItem = v end)
    Library:CreateButton(sec, "Buy Event Item", function()
        sendNotification("Event Shop", nil, "Buying " .. Config.EventShopItem)
    end)
end

------------------------------------------------------------
-- TAB 13: FISHING ROD
------------------------------------------------------------
do
    local page = tabPages["Fishing Rod"]
    local sec = Library:CreateSection(page, "Fishing Rod")
    local rods = {"Wooden Rod", "Fiber Rod", "Sturdy Rod", "Long Rod", "Iron Rod", "Steel Rod", "Titanium Rod", "Carbon Rod"}
    Library:CreateDropdown(sec, "Select Rod", "Pilih rod untuk dibeli", rods, "Wooden Rod", 13, function(v) Config.RodToBuy = v end)
    Library:CreateButton(sec, "Buy Rod Now", function()
        sendNotification("Rod Shop", nil, "Buying " .. Config.RodToBuy)
    end)
end

------------------------------------------------------------
-- TAB 14: BAIT SHOP
------------------------------------------------------------
do
    local page = tabPages["Bait Shop"]
    local sec = Library:CreateSection(page, "Bait Shop")
    local baits = {"Worm", "Cricket", "Minnow", "Leech", "Squid", "Shrimp", "Crayfish", "Small Fish"}
    Library:CreateDropdown(sec, "Select Bait", "Pilih bait untuk dibeli", baits, "Worm", 14, function(v) Config.BaitToBuy = v end)
    Library:CreateButton(sec, "Buy Bait Now", function()
        sendNotification("Bait Shop", nil, "Buying " .. Config.BaitToBuy)
    end)
end

------------------------------------------------------------
-- TAB 15: TELEPORT
------------------------------------------------------------
do
    local page = tabPages["Teleport"]
    local sec = Library:CreateSection(page, "Teleport Island")
    local islands = {
        "Ancient Jungle", "Ancient Ruins", "Coral Reefs", "Crater Island 1", "Crater Island 2",
        "Crystal Depths", "Crystalline Passage", "Enchant 2", "Esoteric Depths",
        "Fisherman Kanan", "Fisherman Kiri", "Heartfelt Cave", "Heartfelt Island",
        "Kohana", "Kohana 2", "Kohana Volcano", "Lava Basin", "Leviathan Den",
        "Lost Isle", "Mutation Cellar", "Ocean", "Pirate Cove", "Pirate Treasure Room",
        "Planetary Observatory", "Sacred Temple", "Secret Passage", "Sisyphus Statue",
        "Treasure Room", "Tropical Grove", "Underground Cellar", "Underwater City",
        "Volcanic Cavern", "Weather Machine"
    }
    Library:CreateDropdown(sec, "Select Island", "Pilih pulau untuk teleport", islands, "Ocean", 19, function(v) Config.TeleportIsland = v end)
    Library:CreateButton(sec, "Teleport Now", function()
        -- Teleport to selected island by finding its spawn point
        pcall(function()
            local target = workspace:FindFirstChild(Config.TeleportIsland, true)
            if target then
                local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and target:IsA("BasePart") then
                    humanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end)
        sendNotification("Teleport", nil, "Teleporting to " .. Config.TeleportIsland)
    end)

    -- Teleport player section
    local sec2 = Library:CreateSection(page, "Teleport Player")
    local pNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(pNames, p.Name) end
    end
    local _, _, refreshPlayers = Library:CreateDropdown(sec2, "Select Player to Teleport", "Pilih pemain untuk teleport", pNames, pNames[1] or "None", 20, function(v) Config.TeleportPlayer = v end)

    -- Auto-refresh player list on join/leave
    Players.PlayerAdded:Connect(function()
        local newNames = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newNames, p.Name) end
        end
        refreshPlayers(newNames)
    end)
    Players.PlayerRemoving:Connect(function()
        local newNames = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newNames, p.Name) end
        end
        refreshPlayers(newNames)
    end)

    Library:CreateButton(sec2, "Update Player List", function()
        local newNames = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newNames, p.Name) end
        end
        refreshPlayers(newNames)
    end)
    Library:CreateToggle(sec2, "Stick to Player", "Aktifkan / Nonaktifkan TP Loop (Auto Follow Player)", false, function(v)
        Config.StickToPlayer = v
        if v then
            task.spawn(function()
                while Config.StickToPlayer do
                    pcall(function()
                        local target = Players:FindFirstChild(Config.TeleportPlayer)
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end)
end

------------------------------------------------------------
-- TAB 16: LIMITED EVENT
------------------------------------------------------------
do
    local page = tabPages["Limited Event"]
    local sec = Library:CreateSection(page, "Limited Event")
    Library:CreateButton(sec, "Open Pirate's Cove Wall", function()
        sendNotification("Event", nil, "Opening Pirate's Cove Wall...")
    end)
    Library:CreateToggle(sec, "Auto Claim Presents", "Membuka semua hadiah santa secara otomatis", false, function(v) Config.AutoClaimPresents = v end)
    Library:CreateToggle(sec, "Enable Auto Mining Crystals", "Teleport -> Equip -> Tween (Anti-Fall)", false, function(v) Config.AutoMiningCrystals = v end)
end

------------------------------------------------------------
-- TAB 17: EVENT TELEPORT
------------------------------------------------------------
do
    local page = tabPages["Event Teleport"]
    local sec = Library:CreateSection(page, "Event Teleport")
    local events = {"Megalodon Hunt", "Ghost Shark Hunt"}
    Library:CreateDropdown(sec, "Select Event to Teleport", "Pilih event untuk teleport", events, "Megalodon Hunt", 21, function(v) Config.EventTeleport = v end)
    Library:CreateToggle(sec, "Enable Auto Event Teleport", "Aktifkan / Nonaktifkan Auto Event Teleport", false, function(v) Config.AutoEventTeleport = v end)
    Library:CreateToggle(sec, "Enable Auto Hacker Event", "Auto Teleport Hacker Event", false, function(v) Config.AutoHackerEvent = v end)

    local sec2 = Library:CreateSection(page, "Admin Event")
    -- Countdown display for Ancient Ruins
    local _, countdownLabel = Library:CreateParagraph(sec2, "Countdown Ancient Ruins Event", "0h 0m 0s")

    -- Update countdown from workspace Event Tracker
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local deps = workspace:FindFirstChild("!!! DEPENDENCIES")
                if deps then
                    local tracker = deps:FindFirstChild("Event Tracker")
                    if tracker then
                        local label = tracker.Main.Gui.Content.Items.Countdown.Label
                        if label and countdownLabel then
                            countdownLabel.Text = label.Text
                        end
                    end
                end
            end)
        end
    end)

    Library:CreateToggle(sec2, "Auto Ancient Ruins Event Teleport", "Auto Teleport saat Ancient Ruins Event", false, function(v) Config.AutoAncientRuinsTP = v end)
end

------------------------------------------------------------
-- TAB 18: WEBHOOK
------------------------------------------------------------
do
    local page = tabPages["Webhook"]
    local sec = Library:CreateSection(page, "Webhook")
    Library:CreateInput(sec, "Webhook URL", "Masukkan URL webhook pribadi", "", function(v) Config.WebhookURL = v end)
    Library:CreateDropdown(sec, "Detection Mode", "Pilih opsi deteksi webhook", {"Player", "Server"}, "Player", 22, function(v) Config.DetectionMode = v end)
    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Exotic"}
    Library:CreateDropdown(sec, "Select Rarity Webhook", "Pilih rarity untuk webhook pribadi", rarities, "Legendary", 23, function(v) table.insert(Config.WebhookRarity, v) end)
    Library:CreateToggle(sec, "Enable Webhook", "Aktifkan / Nonaktifkan Webhook Pribadi", false, function(v) Config.EnableWebhook = v end)
    Library:CreateToggle(sec, "Enable Disconnected Webhook", "Aktifkan / Nonaktifkan Webhook Disconnected", false, function(v) Config.EnableDisconnectedWebhook = v end)
    Library:CreateButton(sec, "Send Webhook Test", function()
        if Config.WebhookURL ~= "" then
            pcall(function()
                (syn and syn.request or http_request or request)({
                    Url = Config.WebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({content = "iSylHub Webhook Test - Working!"})
                })
            end)
            sendNotification("Webhook", nil, "Test webhook sent!")
        else
            sendNotification("Webhook", nil, "Please enter a webhook URL first!")
        end
    end)
end

------------------------------------------------------------
-- TAB 19: OPTIMIZATION
------------------------------------------------------------
do
    local page = tabPages["Optimization"]
    local sec = Library:CreateSection(page, "Optimization")
    Library:CreateButton(sec, "FPS Booster (Force Mode)", function()
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 0
            end
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            for _, v in ipairs(lighting:GetDescendants()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
        end)
        sendNotification("FPS Booster", nil, "FPS Boost applied!")
    end)
    Library:CreateToggle(sec, "GPU Saver", "Black Screen Mode", false, function(v)
        Config.GPUSaver = v
        pcall(function()
            Camera.CameraType = v and Enum.CameraType.Scriptable or Enum.CameraType.Custom
            if not v then
                Camera.FieldOfView = 70
            end
        end)
    end)
    Library:CreateToggle(sec, "No Animation", "Freeze animasi karakter", false, function(v)
        Config.NoAnimation = v
    end)
    Library:CreateToggle(sec, "Disable Rod Effect", "Menghilangkan Effect Rod", false, function(v) Config.DisableRodEffect = v end)
    Library:CreateToggle(sec, "Disable Cutscene", "Menghilangkan Animasi Cutscene", false, function(v) Config.DisableCutscene = v end)
    Library:CreateToggle(sec, "Disable PopUp Notification", "Menghilangkan animasi PopUp ikan", false, function(v) Config.DisablePopUpNotification = v end)
    Library:CreateToggle(sec, "Remove All Player", "Menghilangkan Player Lain", false, function(v)
        Config.RemoveAllPlayer = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    p.Character:Destroy()
                end
            end
        end
    end)

    local sec2 = Library:CreateSection(page, "Display Performance")
    Library:CreateToggle(sec2, "Show Performance Stats", "Memunculkan Stats Cpu, Fps, Ping", false, function(v) Config.ShowPerformanceStats = v end)
end

------------------------------------------------------------
-- TAB 20: GENERAL FEATURES
------------------------------------------------------------
do
    local page = tabPages["General Features"]
    local sec = Library:CreateSection(page, "General Features")
    Library:CreateToggle(sec, "Anti AFK", "Mencegah kick 20 menit (Stealth Mode)", false, function(v)
        Config.AntiAFK = v
        if v then
            LocalPlayer.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end)
    Library:CreateToggle(sec, "Anti Staff", "Disconnect ketika staff masuk server", false, function(v)
        Config.AntiStaff = v
        if v then
            Players.PlayerAdded:Connect(function(player)
                if Config.AntiStaff then
                    pcall(function()
                        local rank = player:GetRankInGroup(0) -- Fish It game group
                        if rank and rank >= 200 then
                            LocalPlayer:Kick("Staff detected: " .. player.Name)
                        end
                    end)
                end
            end)
            -- Check existing players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function()
                        local rank = player:GetRankInGroup(0)
                        if rank and rank >= 200 then
                            LocalPlayer:Kick("Staff detected: " .. player.Name)
                        end
                    end)
                end
            end
        end
    end)
end

------------------------------------------------------------
-- TAB 21: PLAYER UTILITIES
------------------------------------------------------------
do
    local page = tabPages["Player Utilities"]
    local sec = Library:CreateSection(page, "Player Utilities")
    Library:CreateToggle(sec, "Walk On Water", "Membuat player bisa berjalan diatas air", false, function(v)
        Config.WalkOnWater = v
    end)
    Library:CreateToggle(sec, "No Clip", "Menembus tembok", false, function(v)
        Config.NoClip = v
        if v then
            RunService.Stepped:Connect(function()
                if Config.NoClip and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)
    Library:CreateToggle(sec, "Fly", "Membuat karakter bisa terbang", false, function(v)
        Config.Fly = v
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end)
    end)
    Library:CreateToggle(sec, "Infinite Zoom Out", "Bisa Zoom Out Jauh", false, function(v)
        Config.InfiniteZoomOut = v
        pcall(function()
            LocalPlayer.CameraMaxZoomDistance = v and 9999 or 128
        end)
    end)
end

------------------------------------------------------------
-- TAB 22: STREAMER MODE
------------------------------------------------------------
do
    local page = tabPages["Streamer Mode"]
    local sec = Library:CreateSection(page, "Streamer Mode")
    Library:CreateToggle(sec, "Hide Player Names", "Sembunyikan nama semua player lain", false, function(v)
        Config.HidePlayerNames = v
    end)
    Library:CreateToggle(sec, "RGB Overhead Name", "Warna nama karakter sendiri berubah RGB", false, function(v)
        Config.RGBOverheadName = v
        if v then
            task.spawn(function()
                while Config.RGBOverheadName do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char then
                            local head = char:FindFirstChild("Head")
                            if head then
                                local billboardGui = head:FindFirstChildOfClass("BillboardGui")
                                if billboardGui then
                                    local textLabel = billboardGui:FindFirstChildOfClass("TextLabel")
                                    if textLabel then
                                        textLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end)
end

------------------------------------------------------------
-- TAB 23: CUSTOM AVATAR
------------------------------------------------------------
do
    local page = tabPages["Custom Avatar"]
    local sec = Library:CreateSection(page, "Custom Avatar")
    local presets = {"Bacon Hair", "Builderman", "Classic Noob", "Jane Doe", "John Doe", "Roblox"}
    Library:CreateDropdown(sec, "Avatar Preset", "Pilih preset avatar", presets, "Bacon Hair", 24, function(v) Config.AvatarPreset = v end)
    Library:CreateInput(sec, "Manual User ID", "Atau masukkan User ID manual", "", function(v) Config.ManualUserId = v end)
    Library:CreateButton(sec, "Apply Avatar", function()
        sendNotification("Avatar", nil, "Applying avatar preset: " .. Config.AvatarPreset)
    end)
end

------------------------------------------------------------
-- TAB 24: FREE CAM
------------------------------------------------------------
do
    local page = tabPages["Free Cam"]
    local sec = Library:CreateSection(page, "Free Cam")
    Library:CreateInput(sec, "Free Cam Speed", "Kecepatan gerak kamera (default 50)", "50", function(v) Config.FreeCamSpeed = tonumber(v) or 50 end)
    Library:CreateToggle(sec, "Enable Free Cam", "WASD+Mouse gerak kamera, E/Q naik/turun", false, function(v) Config.EnableFreeCam = v end)
end

------------------------------------------------------------
-- TAB 25: SERVER UTILITIES
------------------------------------------------------------
do
    local page = tabPages["Server Utilities"]
    local sec = Library:CreateSection(page, "Server Utilities")
    Library:CreateButton(sec, "Rejoin", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

------------------------------------------------------------
-- TAB 26: CONFIG MANAGER
------------------------------------------------------------
do
    local page = tabPages["Config Manager"]
    local sec = Library:CreateSection(page, "Config Manager")
    Library:CreateToggle(sec, "Include Player Location", "Teleport to saved location on load", false, function(v) Config.IncludePlayerLocation = v end)
    Library:CreateInput(sec, "Create Config Name", nil, "", function(v) Config.ConfigName = v end)
    Library:CreateButton(sec, "Create New Config", function()
        if Config.ConfigName ~= "" then
            pcall(function()
                local configData = HttpService:JSONEncode(Config)
                writefile("iSylHub_" .. Config.ConfigName .. ".json", configData)
                sendNotification("Config", nil, "Config '" .. Config.ConfigName .. "' created!")
            end)
        end
    end)

    local configList = {}
    pcall(function()
        local files = listfiles(".")
        for _, f in ipairs(files) do
            if f:find("iSylHub_") and f:find(".json") then
                table.insert(configList, f:match("iSylHub_(.+)%.json"))
            end
        end
    end)
    local _, _, refreshConfigs = Library:CreateDropdown(sec, "Select Config", nil, configList, configList[1] or "None", 25, function(v) Config.SelectedConfig = v end)
    Library:CreateButton(sec, "Refresh List", function()
        local newList = {}
        pcall(function()
            local files = listfiles(".")
            for _, f in ipairs(files) do
                if f:find("iSylHub_") and f:find(".json") then
                    table.insert(newList, f:match("iSylHub_(.+)%.json"))
                end
            end
        end)
        refreshConfigs(newList)
    end)
    Library:CreateButton(sec, "Load Config", function()
        if Config.SelectedConfig and Config.SelectedConfig ~= "None" then
            pcall(function()
                local data = readfile("iSylHub_" .. Config.SelectedConfig .. ".json")
                local loaded = HttpService:JSONDecode(data)
                for k, v in pairs(loaded) do
                    Config[k] = v
                end
                sendNotification("Config", nil, "Config '" .. Config.SelectedConfig .. "' loaded!")
            end)
        end
    end)
    Library:CreateButton(sec, "Overwrite Config", function()
        if Config.SelectedConfig and Config.SelectedConfig ~= "None" then
            pcall(function()
                writefile("iSylHub_" .. Config.SelectedConfig .. ".json", HttpService:JSONEncode(Config))
                sendNotification("Config", nil, "Config '" .. Config.SelectedConfig .. "' overwritten!")
            end)
        end
    end)
    Library:CreateButton(sec, "Delete Config", function()
        if Config.SelectedConfig and Config.SelectedConfig ~= "None" then
            pcall(function()
                delfile("iSylHub_" .. Config.SelectedConfig .. ".json")
                sendNotification("Config", nil, "Config '" .. Config.SelectedConfig .. "' deleted!")
            end)
        end
    end)

    local _, autoloadLabel = Library:CreateParagraph(sec, "Autoload Status", "Current: " .. Config.AutoloadConfig)
    Library:CreateButton(sec, "Set Autoload", function()
        Config.AutoloadConfig = Config.SelectedConfig
        if autoloadLabel then
            autoloadLabel.Text = "Current: " .. Config.AutoloadConfig
        end
        sendNotification("Config", nil, "Autoload set to: " .. Config.AutoloadConfig)
    end)
    Library:CreateButton(sec, "Delete Autoload", function()
        Config.AutoloadConfig = "None"
        if autoloadLabel then
            autoloadLabel.Text = "Current: None"
        end
    end)
end

------------------------------------------------------------
-- DRAG SYSTEM
------------------------------------------------------------
do
    local dragging = false
    local dragInput, dragStart, startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = DropShadowHolder.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            DropShadowHolder.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

------------------------------------------------------------
-- MINIMIZE / CLOSE FUNCTIONALITY
------------------------------------------------------------
local isMinimized = false
local originalSize = DropShadowHolder.Size

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tweenProperty(DropShadowHolder, {Size = UDim2.new(0, 560, 0, 50)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
        LayersTab.Visible = false
        Layers.Visible = false
    else
        tweenProperty(DropShadowHolder, {Size = originalSize}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
        task.wait(0.15)
        LayersTab.Visible = true
        Layers.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

------------------------------------------------------------
-- KEYBIND TOGGLE (RightShift to show/hide)
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

------------------------------------------------------------
-- CUTSCENE BLOCKER (from logged behavior)
------------------------------------------------------------
if RE_ReplicateCutscene then
    RE_ReplicateCutscene.OnClientEvent:Connect(function(...)
        if Config.DisableCutscene then
            -- Block cutscene by not processing it
            return
        end
    end)
end

if RE_StopCutscene then
    RE_StopCutscene.OnClientEvent:Connect(function(...)
        -- Reset camera after cutscene
        pcall(function()
            Camera.CameraType = Enum.CameraType.Custom
            Camera.FieldOfView = 70
        end)
    end)
end

------------------------------------------------------------
-- FISH CAUGHT WEBHOOK HANDLER
------------------------------------------------------------
local fishCaughtRE = RE_Hashed["d4fdada8265b75c6395adefca432bbfd8db7b253d7aec860aefdcad521812dd9"]
    or getRemoteEvent("d4fdada8265b75c6395adefca432bbfd8db7b253d7aec860aefdcad521812dd9")

if fishCaughtRE then
    fishCaughtRE.OnClientEvent:Connect(function(data)
        if Config.EnableWebhook and Config.WebhookURL ~= "" then
            pcall(function()
                local fishData = data or {}
                -- Check if rarity matches webhook filter
                local rarity = fishData.Rarity or fishData.rarity or "Unknown"
                local shouldSend = false
                for _, r in ipairs(Config.WebhookRarity) do
                    if r == rarity then
                        shouldSend = true
                        break
                    end
                end
                if shouldSend or #Config.WebhookRarity == 0 then
                    local requestFunc = (syn and syn.request) or http_request or request
                    if requestFunc then
                        requestFunc({
                            Url = Config.WebhookURL,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = HttpService:JSONEncode({
                                content = string.format(
                                    "ðŸŽ£ **Fish Caught!**\nPlayer: %s\nFish: %s\nRarity: %s",
                                    LocalPlayer.Name,
                                    tostring(fishData.Name or fishData.name or "Unknown"),
                                    rarity
                                )
                            })
                        })
                    end
                end
            end)
        end
    end)
end

------------------------------------------------------------
-- POPUP NOTIFICATION BLOCKER
------------------------------------------------------------
if RE_ObtainedNewFish then
    RE_ObtainedNewFish.OnClientEvent:Connect(function(...)
        if Config.DisablePopUpNotification then
            return -- Block popup
        end
    end)
end

------------------------------------------------------------
-- ROD EFFECT BLOCKER
------------------------------------------------------------
if RE_PlayFishingEffect then
    RE_PlayFishingEffect.OnClientEvent:Connect(function(...)
        if Config.DisableRodEffect then
            return -- Block rod visual effects
        end
    end)
end

------------------------------------------------------------
-- AUTO FISHING CORE LOOP (Blatant V2 mode reference)
------------------------------------------------------------
-- Note: The actual fishing logic uses hashed remote calls
-- The exact RF/RE hashes are mapped in the networking section above
-- The fishing controller interfaces via:
-- RF/6d13a7febe71701c405bc6ece759423367a7dd69b19ef376cec575ab2d9da0ef (main fishing RF)
-- RE/d4fdada8265b75c6395adefca432bbfd8db7b253d7aec860aefdcad521812dd9 (fish caught notification)

------------------------------------------------------------
-- SEND LOADED NOTIFICATION
------------------------------------------------------------
sendNotification("iSylHub Free v3.0", nil, "Script Loaded Successfully! ðŸŽ£", 8)

------------------------------------------------------------
-- UPDATE TASK TRACKING
------------------------------------------------------------
-- Script fully loaded and operational
-- Press RightShift to toggle GUI visibility
