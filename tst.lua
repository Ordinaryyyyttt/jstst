-- █▀▀ █▀█ ▄▀█ █▀▀ █▄▀ █▀▀ █▀▄   █▄▄ █▄█   █▀▀ █ █▀█ ▄▀█ █▀▄▀█
-- █▄▄ █▀▄ █▀█ █▄▄ █░█ ██▄\u200b █▄▀   █▄█ ░█░\u200b   ▄██ █\u200b █▀▄ █▀█ █░█░█
-- Mode: Cleaned, Bypassed & Rebranded // Cracked by Sir-M
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Colors = {
    BG_VOID = Color3.fromRGB(5, 5, 12),
    BG_PANEL = Color3.fromRGB(12, 14, 26),
    BG_CARD = Color3.fromRGB(16, 19, 34),
    BG_INPUT = Color3.fromRGB(8, 10, 20),
    BORDER_DIM = Color3.fromRGB(30, 35, 55),
    NEON_GREEN = Color3.fromRGB(0, 255, 140),
    NEON_LIME = Color3.fromRGB(120, 255, 68),
    NEON_RED = Color3.fromRGB(255, 50, 80),
    NEON_AMBER = Color3.fromRGB(255, 180, 0),
    NEON_BLUE = Color3.fromRGB(0, 170, 255),
    NEON_WHITE = Color3.fromRGB(200, 220, 210),
    TEXT_BRIGHT = Color3.fromRGB(210, 230, 220),
    TEXT_MID = Color3.fromRGB(120, 140, 130),
    TEXT_DIM = Color3.fromRGB(55, 70, 65),
    TEXT_MONO = Color3.fromRGB(0, 200, 110),
    SUCCESS = Color3.fromRGB(0, 255, 140),
    ERROR = Color3.fromRGB(255, 50, 80)
}

local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then pcall(function() inst[k] = v end) end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function addCorner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 6), Parent = parent})
end

local function addStroke(parent, color, thickness, transparency)
    return create("UIStroke", {Color = color or Colors.BORDER_DIM, Thickness = thickness or 1, Transparency = transparency or 0, Parent = parent})
end

local function typewriter(label, text, delay, color)
    label.Text = ""
    if color then label.TextColor3 = color end
    for i = 1, #text do
        if not label or not label.Parent then return end
        label.Text = text:sub(1, i)
        task.wait(delay or 0.02)
    end
end

local function genHex()
    local chars = "0123456789ABCDEF"
    local res = ""
    for i = 1, 8 do
        local r = math.random(1, #chars)
        res = res .. chars:sub(r, r)
    end
    return res
end

-- Cleanup UI Lama (Sekarang mencari nama baru agar tidak konflik)
pcall(function() if game:GetService("CoreGui"):FindFirstChild("SirMKeySystem") then game:GetService("CoreGui").SirMKeySystem:Destroy() end end)
pcall(function() if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("SirMKeySystem") then LocalPlayer.PlayerGui.SirMKeySystem:Destroy() end end)

local screenGui = create("ScreenGui", {Name = "SirMKeySystem", DisplayOrder = 999, IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
if not pcall(function() screenGui.Parent = game:GetService("CoreGui") end) then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local backdrop = create("Frame", {Name = "Backdrop", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Colors.BG_VOID, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 1, Parent = screenGui})
local scanBeam = create("Frame", {Name = "ScanBeam", Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(0, 0, -0.1, 0), BackgroundColor3 = Colors.NEON_GREEN, BackgroundTransparency = 0.95, BorderSizePixel = 0, ZIndex = 2, Parent = backdrop})

task.spawn(function()
    while screenGui and screenGui.Parent do
        scanBeam.Position = UDim2.new(0, 0, -0.1, 0)
        tween(scanBeam, {Position = UDim2.new(0, 0, 1.1, 0)}, 4, Enum.EasingStyle.Linear)
        task.wait(5)
    end
end)

local window = create("Frame", {Name = "Window", Size = UDim2.new(0, 400, 0, 480), Position = UDim2.new(0.5, -200, 0.5, -240), BackgroundColor3 = Colors.BG_PANEL, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 10, Parent = screenGui})
addCorner(window, 6)
local windowStroke = addStroke(window, Colors.NEON_GREEN, 1, 0.5)

local titleBar = create("Frame", {Name = "TitleBar", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(8, 10, 18), BorderSizePixel = 0, ZIndex = 20, Parent = window})
addCorner(titleBar, 6)
create("Frame", {Name = "TitleBarFix", Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Color3.fromRGB(8, 10, 18), BorderSizePixel = 0, ZIndex = 20, Parent = titleBar})
create("Frame", {Name = "BottomLine", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Colors.NEON_GREEN, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 21, Parent = titleBar})

local dots = {Colors.NEON_RED, Colors.NEON_AMBER, Colors.NEON_GREEN}
for i, col in ipairs(dots) do
    addCorner(create("Frame", {Name = "Dot" .. i, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 12 + ((i - 1) * 20), 0.5, -6), BackgroundColor3 = col, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 22, Parent = titleBar}), 6)
end

-- [PERUBAHAN] Mengubah teks Nexus menjadi Cracked by Sir-M
create("TextLabel", {Name = "TitleText", Size = UDim2.new(1, -140, 1, 0), Position = UDim2.new(0, 80, 0, 0), BackgroundTransparency = 1, Text = "⚡ Cracked by Sir-M // BYPASSED", TextSize = 12, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22, Parent = titleBar})

local closeBtn = create("TextButton", {Name = "CloseBtn", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -38, 0.5, -15), BackgroundColor3 = Colors.NEON_RED, BackgroundTransparency = 0.8, Text = "×", TextColor3 = Colors.NEON_RED, TextSize = 20, Font = Enum.Font.Code, AutoButtonColor = false, ZIndex = 22, Parent = titleBar})
addCorner(closeBtn, 4)

closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundTransparency = 0.8, TextColor3 = Colors.NEON_RED}, 0.15) end)
closeBtn.MouseButton1Click:Connect(function()
    tween(window, {Size = UDim2.new(0, 400, 0, 10)}, 0.3, Enum.EasingStyle.Quint)
    tween(backdrop, {BackgroundTransparency = 1}, 0.3)
    task.wait(0.35)
    screenGui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local content = create("Frame", {Name = "Content", Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Colors.BG_PANEL, ClipsDescendants = true, ZIndex = 11, Parent = window})
local p1 = create("Frame", {Name = "P1", Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, ZIndex = 12, Parent = content})

local termLog = create("Frame", {Name = "TermLog", Size = UDim2.new(1, 0, 0, 95), BackgroundColor3 = Colors.BG_INPUT, ZIndex = 13, Parent = p1})
addCorner(termLog, 4)
addStroke(termLog, Colors.BORDER_DIM, 1, 0)

local innerLog = create("Frame", {Name = "Inner", Size = UDim2.new(1, -20, 1, -16), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, ZIndex = 14, Parent = termLog})
create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = innerLog})

local function addLog(text, color, order)
    return create("TextLabel", {Name = "Log" .. (order or 0), Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = text or "", TextSize = 11, Font = Enum.Font.Code, TextColor3 = color or Colors.TEXT_MONO, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = order or 0, ZIndex = 15, Parent = innerLog})
end

local statusRow = create("Frame", {Name = "StatusRow", Size = UDim2.new(1, 0, 0, 55), Position = UDim2.new(0, 0, 0, 103), BackgroundTransparency = 1, ZIndex = 13, Parent = p1})
local statusPanel = create("Frame", {Name = "StatusPanel", Size = UDim2.new(0.48, 0, 1, 0), BackgroundColor3 = Colors.BG_INPUT, ZIndex = 14, Parent = statusRow})
addCorner(statusPanel, 4); addStroke(statusPanel, Colors.BORDER_DIM, 1, 0)
local statusLabel = create("TextLabel", {Name = "Label", Size = UDim2.new(1, -14, 1, -10), Position = UDim2.new(0, 7, 0, 5), BackgroundTransparency = 1, Text = "STATUS\n─────────\nREADY", TextSize = 10, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 15, Parent = statusPanel})

local sessionPanel = create("Frame", {Name = "SessionPanel", Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundColor3 = Colors.BG_INPUT, ZIndex = 14, Parent = statusRow})
addCorner(sessionPanel, 4); addStroke(sessionPanel, Colors.BORDER_DIM, 1, 0)
create("TextLabel", {Name = "Label", Size = UDim2.new(1, -14, 1, -10), Position = UDim2.new(0, 7, 0, 5), BackgroundTransparency = 1, Text = "SESSION\n─────────\n" .. genHex(), TextSize = 10, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_DIM, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 15, Parent = sessionPanel})

create("TextLabel", {Name = "Divider", Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 168), BackgroundTransparency = 1, Text = "── PRESS LOAD TO CONTINUE ──", TextSize = 10, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_DIM, ZIndex = 13, Parent = p1})

local inputWrap = create("Frame", {Name = "InputWrap", Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0, 192), BackgroundColor3 = Colors.BG_INPUT, ZIndex = 13, Parent = p1})
addCorner(inputWrap, 4)
local inputStroke = addStroke(inputWrap, Colors.BORDER_DIM, 1, 0.2)
create("TextLabel", {Name = "Prefix", Size = UDim2.new(0, 28, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = ">>", TextSize = 14, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14, Parent = inputWrap})
create("TextBox", {Name = "KeyInput", Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 38, 0, 0), BackgroundTransparency = 1, Text = "BYPASSED", TextEditable = false, TextColor3 = Colors.NEON_GREEN, TextSize = 14, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14, Parent = inputWrap})

local statusMsg = create("TextLabel", {Name = "StatusMsg", Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 240), BackgroundTransparency = 1, Text = "", TextSize = 11, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_MID, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 13, Parent = p1})

local function showStatusMsg(text, color, delayTime)
    tween(statusMsg, {TextTransparency = 0}, 0.15)
    statusMsg.Text = text
    statusMsg.TextColor3 = color or Colors.TEXT_MID
    if delayTime then task.delay(delayTime, function() if statusMsg and statusMsg.Parent then tween(statusMsg, {TextTransparency = 1}, 0.5) end end) end
end

local btnRow = create("Frame", {Name = "BtnRow", Size = UDim2.new(1, 0, 0, 44), Position = UDim2.new(0, 0, 0, 266), BackgroundTransparency = 1, ZIndex = 13, Parent = p1})
local submitBtn = create("TextButton", {Name = "SubmitBtn", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 40, 22), Text = "[ LOAD SCRIPT ]", TextSize = 14, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, AutoButtonColor = false, ZIndex = 14, Parent = btnRow})
addCorner(submitBtn, 4)
local submitStroke = addStroke(submitBtn, Colors.NEON_GREEN, 1, 0.3)

submitBtn.MouseEnter:Connect(function() tween(submitBtn, {BackgroundColor3 = Color3.fromRGB(0, 60, 35)}, 0.15); tween(submitStroke, {Transparency = 0}, 0.15) end)
submitBtn.MouseLeave:Connect(function() tween(submitBtn, {BackgroundColor3 = Color3.fromRGB(0, 40, 22)}, 0.15); tween(submitStroke, {Transparency = 0.3}, 0.15) end)

local progressWrap = create("Frame", {Name = "ProgressWrap", Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 320), BackgroundColor3 = Colors.BORDER_DIM, Visible = false, ZIndex = 13, Parent = p1})
addCorner(progressWrap, 3)
local fill = create("Frame", {Name = "Fill", Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Colors.NEON_GREEN, ZIndex = 14, Parent = progressWrap})
addCorner(fill, 3)

-- [PERUBAHAN] Mengubah Footer Nexus v2.0 menjadi Cracked by Sir-M v2.0
local footer = create("TextLabel", {Name = "Footer", Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -20), BackgroundTransparency = 1, Text = "Cracked by Sir-M v2.0 | SECURE", TextSize = 9, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_DIM, ZIndex = 13, Parent = p1})
task.spawn(function()
    while screenGui and screenGui.Parent do
        if footer and footer.Parent then footer.Text = "Cracked by Sir-M v2.0 | " .. os.date("%H:%M:%S") .. " | BYPASSED" end
        task.wait(1)
    end
end)

local p3 = create("Frame", {Name = "P3", Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 1.2, 0), BackgroundTransparency = 1, ZIndex = 12, Visible = false, Parent = content})
local art = create("TextLabel", {Name = "Art", Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Text = "+-----------------------+\n|  ACCESS  GRANTED    |\n|   ==================  |\n+-----------------------+", TextSize = 13, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, ZIndex = 13, Parent = p3})
local msg = create("TextLabel", {Name = "Msg", Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 110), BackgroundTransparency = 1, Text = "", TextSize = 12, Font = Enum.Font.Code, TextColor3 = Colors.NEON_GREEN, ZIndex = 13, Parent = p3})
local detail = create("TextLabel", {Name = "Detail", Size = UDim2.new(1, 0, 0, 70), Position = UDim2.new(0, 0, 0, 140), BackgroundTransparency = 1, Text = "", TextSize = 10, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_DIM, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13, Parent = p3})
local bar = create("Frame", {Name = "Bar", Size = UDim2.new(0.8, 0, 0, 4), Position = UDim2.new(0.1, 0, 0, 230), BackgroundColor3 = Colors.BORDER_DIM, ZIndex = 13, Parent = p3})
addCorner(bar, 2)
local barFill = create("Frame", {Name = "Fill", Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Colors.NEON_GREEN, ZIndex = 14, Parent = bar})
addCorner(barFill, 2)
local barLabel = create("TextLabel", {Name = "BarLabel", Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 240), BackgroundTransparency = 1, Text = "INITIALIZING PAYLOAD...", TextSize = 9, Font = Enum.Font.Code, TextColor3 = Colors.TEXT_DIM, ZIndex = 13, Parent = p3})

submitBtn.MouseButton1Click:Connect(function()
    showStatusMsg("[...] Loading Script - please wait", Colors.NEON_AMBER)
    progressWrap.Visible = true
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Colors.NEON_GREEN
    tween(fill, {Size = UDim2.new(0.7, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quad)
    
    statusLabel.Text = "STATUS\n---------\nLOADING..."
    statusLabel.TextColor3 = Colors.NEON_AMBER
    
    task.wait(1.5)
    
    tween(windowStroke, {Color = Colors.SUCCESS, Transparency = 0.2}, 0.5)
    tween(fill, {Size = UDim2.new(1, 0, 1, 0)}, 0.3)
    fill.BackgroundColor3 = Colors.SUCCESS
    showStatusMsg("[OK] Access granted", Colors.SUCCESS)
    
    task.wait(0.5)
    
    statusLabel.Text = "STATUS\n---------\n+ VERIFIED"
    statusLabel.TextColor3 = Colors.SUCCESS
    tween(inputStroke, {Color = Colors.SUCCESS}, 0.2)
    
    local infoText = "Key:     BYPASSED\nUser:    " .. LocalPlayer.Name .. "\nTime:    " .. os.date("%Y-%m-%d %H:%M:%S") .. "\nSession: " .. genHex()
    
    task.wait(0.5)
    p3.Visible = true
    tween(p3, {Position = UDim2.new(0, 20, 0, 20)}, 0.35, Enum.EasingStyle.Quint)
    tween(p1, {Position = UDim2.new(-1.2, 0, 0, 20)}, 0.35, Enum.EasingStyle.Quint)
    task.delay(0.4, function() p1.Visible = false end)
    task.wait(0.4)
    
    typewriter(msg, "Authorization complete. Welcome.", 0.03, Colors.NEON_GREEN)
    task.wait(1)
    typewriter(detail, infoText, 0.015, Colors.TEXT_DIM)
    task.wait(0.3)
    
    tween(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 2.5, Enum.EasingStyle.Quad)
    
    local stages = {"INITIALIZING PAYLOAD...", "LOADING MODULES...", "INJECTING...", "COMPLETE"}
    for i, stage in ipairs(stages) do
        task.wait(0.6)
        if barLabel and barLabel.Parent then
            barLabel.Text = stage
            if i == #stages then barLabel.TextColor3 = Colors.SUCCESS end
        end
    end
    
    task.wait(1)
    tween(window, {Size = UDim2.new(0, 400, 0, 10)}, 0.35, Enum.EasingStyle.Quint)
    tween(backdrop, {BackgroundTransparency = 1}, 0.35)
    task.wait(0.4)
    screenGui:Destroy()

    -- ==========================================================
    -- TEMPELKAN LOGIC SCRIPT UTAMA ANDA DI BAWAH GARIS INI
    -- (Kode yang akan berjalan setelah proses loading UI selesai)
    -- ==========================================================
    print("Script Utama Dieksekusi!")

end)

task.spawn(function()
    window.BackgroundTransparency = 1
    window.Size = UDim2.new(0, 400, 0, 400)
    window.Position = UDim2.new(0.5, -200, 0.5, -3)
    task.wait(0.1)
    tween(window, {Size = UDim2.new(0, 400, 0, 480), Position = UDim2.new(0.5, -200, 0.5, -240)}, 0.5, Enum.EasingStyle.Quint)
    task.wait(0.5)
    
    local logs = {
        {text = "[SYS] Establishing secure connection...", color = Colors.TEXT_DIM},
        {text = "[SYS] Protocol: AES-256-GCM (BYPASSED)", color = Colors.TEXT_DIM},
        {text = "[SYS] Connected to auth.sir-m.io", color = Colors.NEON_GREEN},
        {text = "[>>>] Ready to load...", color = Colors.NEON_AMBER}
    }
    for i, logItem in ipairs(logs) do
        local lbl = addLog("", logItem.color, i)
        typewriter(lbl, logItem.text, 0.02, logItem.color)
        task.wait(0.15)
    end
end)

task.spawn(function()
    while screenGui and screenGui.Parent do
        tween(windowStroke, {Transparency = 0.7}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
        tween(windowStroke, {Transparency = 0.3}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
    end
end)

-- [PERUBAHAN] Mengubah teks Print di Konsol
print("[Cracked by Sir-M] v2.0 Key system loaded | CoreGui | DisplayOrder 999 | BYPASSED")
