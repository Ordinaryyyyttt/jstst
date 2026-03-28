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
-- LOAD OFFICIAL UI LIBRARY
------------------------------------------------------------
local iSylHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/iSylvesterr/iSylHub/main/iSylHubUi.lua"))()

------------------------------------------------------------
-- CREATE WINDOW
------------------------------------------------------------
local Window = iSylHub:Window({
    Title = "iSylHub",
    Footer = "Free v3.0",
    Color = Color3.fromRGB(185, 28, 48),
    Version = 1,
    Image = "127299394628001"
})

------------------------------------------------------------
-- TAB 1: FISHING MAIN
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Fishing Main", Icon = "fish" })
    local Sec = Tab:AddSection("Fishing Main")

    Sec:AddSlider({
        Title = "Cast Delay",
        Content = "Delay sebelum melempar pancing (detik)",
        Min = 0, Max = 10, Default = 0, Increment = 0.1,
        Callback = function(v) Config.CastDelay = v end
    })

    Sec:AddSlider({
        Title = "Catch Delay",
        Content = "Delay sebelum menangkap ikan (detik)",
        Min = 0, Max = 10, Default = 0, Increment = 0.1,
        Callback = function(v) Config.CatchDelay = v end
    })

    Sec:AddDropdown({
        Title = "Fishing Mode",
        Content = "Pilih mode fishing",
        Options = {"Blatant V2", "Instant", "Legit"},
        Default = "Blatant V2",
        Callback = function(v) Config.FishingMode = v end
    })

    Sec:AddToggle({
        Title = "Stable Result",
        Content = "Stabilkan hasil tangkapan",
        Default = false,
        Callback = function(v) Config.StableResult = v end
    })

    Sec:AddToggle({
        Title = "Auto Equip Rod",
        Content = "Otomatis equip rod terbaik",
        Default = false,
        Callback = function(v) Config.AutoEquipRod = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Fishing",
        Content = "Aktifkan / Nonaktifkan Auto Fishing",
        Default = false,
        Callback = function(v)
            Config.AutoFishing = v
            if v then
                task.spawn(function()
                    while Config.AutoFishing do
                        pcall(function()
                            task.wait(Config.CastDelay)
                            for hash, rf in pairs(RF_Hashed) do
                                pcall(function() rf:InvokeServer() end)
                                break
                            end
                            task.wait(Config.CatchDelay)
                        end)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
end

------------------------------------------------------------
-- TAB 2: FISHING SUPPORT
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Fishing Support", Icon = "settings" })
    local Sec = Tab:AddSection("Fishing Support")

    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Exotic", "Transcendent"}
    Sec:AddDropdown({
        Title = "Select Rarity to Skip",
        Content = "Pilih rarity yang ingin dilewati",
        Multi = true,
        Options = rarities,
        Default = {},
        Callback = function(v) Config.SkipRarity = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Skip",
        Content = "Aktifkan / Nonaktifkan Auto Skip",
        Default = false,
        Callback = function(v) Config.AutoSkip = v end
    })

    Sec:AddToggle({
        Title = "Fix Stuck Rod",
        Content = "Perbaiki rod yang macet",
        Default = false,
        Callback = function(v) Config.FixStuckRod = v end
    })
end

------------------------------------------------------------
-- TAB 3: AUTO SELL
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Sell", Icon = "dollar-sign" })
    local Sec = Tab:AddSection("Auto Sell")

    Sec:AddSlider({
        Title = "Sell Count Target",
        Content = "Jumlah ikan untuk dijual (0 = semua)",
        Min = 0, Max = 100, Default = 0, Increment = 1,
        Callback = function(v)
            Config.SellCountTarget = v
            pcall(function()
                if RF_UpdateAutoSellThreshold then
                    RF_UpdateAutoSellThreshold:InvokeServer(v)
                end
            end)
        end
    })

    Sec:AddSlider({
        Title = "Sell Delay",
        Content = "Delay sebelum menjual (detik)",
        Min = 0, Max = 10, Default = 0, Increment = 0.1,
        Callback = function(v) Config.SellDelay = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Sell",
        Content = "Aktifkan / Nonaktifkan Auto Sell",
        Default = false,
        Callback = function(v) Config.AutoSell = v end
    })
end

------------------------------------------------------------
-- TAB 4: AUTO USE CRYSTAL
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Use Crystal", Icon = "zap" })
    local Sec = Tab:AddSection("Auto Use Crystal")

    Sec:AddSlider({
        Title = "Use Delay",
        Content = "Delay penggunaan crystal (detik)",
        Min = 0, Max = 10, Default = 0, Increment = 0.1,
        Callback = function(v) Config.UseDelay = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Use Cave Crystal",
        Content = "Aktifkan / Nonaktifkan Auto Use Crystal",
        Default = false,
        Callback = function(v)
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
        end
    })
end

------------------------------------------------------------
-- TAB 5: AUTO ENCHANT ROD
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Enchant Rod", Icon = "star" })
    local Sec = Tab:AddSection("Auto Enchant Rod")

    local stoneTypes = {"Enchant Stone I", "Enchant Stone II", "Enchant Stone III", "Transcendent Stone", "Secret Stone"}
    Sec:AddDropdown({
        Title = "Stone Type",
        Content = "Pilih jenis batu enchant",
        Options = stoneTypes,
        Default = "Enchant Stone I",
        Callback = function(v) Config.StoneType = v end
    })

    local enchants = {"Bountiful", "Lucky", "Hasty", "Mighty", "Sturdy", "Swift", "Precise", "Chaotic"}
    Sec:AddDropdown({
        Title = "Target Enchant",
        Content = "Pilih target enchant",
        Options = enchants,
        Default = "Bountiful",
        Callback = function(v) Config.TargetEnchant = v end
    })

    Sec:AddButton({
        Title = "Start Auto Enchant",
        Callback = function()
            Config.AutoEnchant = true
        end
    })

    Sec:AddDivider()

    local Sec2 = Tab:AddSection("Exchange Secret")
    Sec2:AddButton({
        Title = "Exchange Secret Fish",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 6: AUTO PLACE TOTEM
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Place Totem", Icon = "box" })
    local Sec = Tab:AddSection("Auto Place Totem")

    local totemTypes = {"Speed Totem", "Luck Totem", "Durability Totem", "Mutation Totem"}
    Sec:AddDropdown({
        Title = "Totem Type",
        Content = "Pilih jenis totem",
        Options = totemTypes,
        Default = "Speed Totem",
        Callback = function(v) Config.TotemType = v end
    })

    Sec:AddSlider({
        Title = "Totem Place Delay",
        Content = "Delay menempatkan totem (detik)",
        Min = 0, Max = 30, Default = 0, Increment = 1,
        Callback = function(v) Config.TotemDelay = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Totem",
        Content = "Aktifkan / Nonaktifkan Auto Totem",
        Default = false,
        Callback = function(v) Config.AutoTotem = v end
    })

    Sec:AddButton({
        Title = "Place All",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 7: AUTO FAVORITE
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Favorite", Icon = "heart" })
    local Sec = Tab:AddSection("Auto Favorite")

    local fishNames = {"Abyssal Lurker", "Amber Koi", "Ancient Coelacanth", "Angel Fish", "Arctic Char", "Barracuda"}
    Sec:AddDropdown({
        Title = "Select Fish by Name",
        Content = "Pilih ikan untuk difavoritkan",
        Multi = true,
        Options = fishNames,
        Default = {},
        Callback = function(v) Config.FavoriteByName = v end
    })

    Sec:AddButton({
        Title = "Auto Favorite Selected",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 8: AUTO TRADE
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Trade", Icon = "repeat" })
    local Sec = Tab:AddSection("Auto Trade")

    local playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end

    local playerDropdown = Sec:AddDropdown({
        Title = "Select Player",
        Content = "Pilih pemain untuk trade",
        Options = playerNames,
        Default = playerNames[1] or nil,
        Callback = function(v) Config.TradePlayer = v end
    })

    Sec:AddInput({
        Title = "Item to Trade",
        Content = "Nama item untuk ditrade",
        Default = "",
        Callback = function(v) Config.TradeItem = v end
    })

    Sec:AddSlider({
        Title = "Quantity",
        Content = "Jumlah item",
        Min = 1, Max = 100, Default = 1, Increment = 1,
        Callback = function(v) Config.TradeQuantity = v end
    })

    local tiers = {"Non-Favorite", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
    Sec:AddDropdown({
        Title = "Tier Filter",
        Content = "Filter berdasarkan tier",
        Options = tiers,
        Default = "Non-Favorite",
        Callback = function(v) Config.TierFilter = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Trade",
        Content = "Aktifkan / Nonaktifkan Auto Trade",
        Default = false,
        Callback = function(v) Config.AutoTrade = v end
    })

    Sec:AddToggle({
        Title = "Auto Accept Trade",
        Content = "Otomatis terima Trade Request",
        Default = false,
        Callback = function(v) Config.AutoAcceptTrade = v end
    })

    -- Auto-refresh player list
    local function refreshPlayerList()
        local newNames = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newNames, p.Name) end
        end
        if playerDropdown and playerDropdown.SetValues then
            playerDropdown:SetValues(newNames)
        end
    end
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)
end

------------------------------------------------------------
-- TAB 9: AUTO BUY WEATHER
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Auto Buy Weather", Icon = "cloud" })
    local Sec = Tab:AddSection("Auto Buy Weather")

    local weathers = {"Wind", "Storm", "Radiant", "Cloudy", "Snow", "Shark Hunt"}
    Sec:AddDropdown({
        Title = "Select Weather",
        Content = "Pilih cuaca untuk dibeli",
        Options = weathers,
        Default = "Wind",
        Callback = function(v) Config.WeatherType = v end
    })

    Sec:AddButton({
        Title = "Buy Weather Now",
        Callback = function()
            pcall(function()
                if RF_PurchaseWeatherEvent then
                    RF_PurchaseWeatherEvent:InvokeServer(Config.WeatherType)
                end
            end)
        end
    })

    Sec:AddToggle({
        Title = "Enable Auto Buy Weather",
        Content = "Otomatis beli weather",
        Default = false,
        Callback = function(v) Config.AutoBuyWeather = v end
    })
end

------------------------------------------------------------
-- TAB 10: MERCHANT
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Merchant", Icon = "shopping-bag" })
    local Sec = Tab:AddSection("Merchant")

    Sec:AddButton({
        Title = "Open Merchant",
        Callback = function() end
    })

    local merchantItems = {"Fluorescent Rod", "Night Rod", "Magma Rod", "Crystal Rod", "Coral Rod"}
    Sec:AddDropdown({
        Title = "Select Item",
        Content = "Pilih item dari merchant",
        Options = merchantItems,
        Default = "Fluorescent Rod",
        Callback = function(v) Config.MerchantItem = v end
    })

    Sec:AddToggle({
        Title = "Auto Buy Merchant",
        Content = "Otomatis beli dari merchant",
        Default = false,
        Callback = function(v) Config.AutoBuyMerchant = v end
    })
end

------------------------------------------------------------
-- TAB 11: BUY CHARM
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Buy Charm", Icon = "shield" })
    local Sec = Tab:AddSection("Buy Charm")

    local charms = {"Algae Charm", "Coral Charm", "Pearl Charm", "Crystal Charm", "Abyssal Charm", "Divine Charm"}
    Sec:AddDropdown({
        Title = "Select Charm",
        Content = "Pilih charm untuk dibeli",
        Options = charms,
        Default = "Algae Charm",
        Callback = function(v) Config.CharmType = v end
    })

    Sec:AddSlider({
        Title = "Quantity",
        Content = "Jumlah charm",
        Min = 1, Max = 50, Default = 1, Increment = 1,
        Callback = function(v) Config.CharmQuantity = v end
    })

    Sec:AddButton({
        Title = "Buy Now",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 12: LIMITED EVENT SHOP
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Limited Event Shop", Icon = "gift" })
    local Sec = Tab:AddSection("Limited Event Shop")

    local eventItems = {"Love I Potion", "Love Totem"}
    Sec:AddDropdown({
        Title = "Select Event Item",
        Content = "Pilih item event",
        Options = eventItems,
        Default = "Love I Potion",
        Callback = function(v) Config.EventShopItem = v end
    })

    Sec:AddButton({
        Title = "Buy Event Item",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 13: FISHING ROD
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Fishing Rod", Icon = "tool" })
    local Sec = Tab:AddSection("Fishing Rod")

    local rods = {"Wooden Rod", "Fiber Rod", "Sturdy Rod", "Long Rod", "Iron Rod", "Steel Rod", "Titanium Rod", "Carbon Rod"}
    Sec:AddDropdown({
        Title = "Select Rod",
        Content = "Pilih rod untuk dibeli",
        Options = rods,
        Default = "Wooden Rod",
        Callback = function(v) Config.RodToBuy = v end
    })

    Sec:AddButton({
        Title = "Buy Rod Now",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 14: BAIT SHOP
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Bait Shop", Icon = "anchor" })
    local Sec = Tab:AddSection("Bait Shop")

    local baits = {"Worm", "Cricket", "Minnow", "Leech", "Squid", "Shrimp", "Crayfish", "Small Fish"}
    Sec:AddDropdown({
        Title = "Select Bait",
        Content = "Pilih bait untuk dibeli",
        Options = baits,
        Default = "Worm",
        Callback = function(v) Config.BaitToBuy = v end
    })

    Sec:AddButton({
        Title = "Buy Bait Now",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 15: TELEPORT
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Teleport", Icon = "map-pin" })
    local Sec = Tab:AddSection("Teleport Island")

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

    Sec:AddDropdown({
        Title = "Select Island",
        Content = "Pilih pulau untuk teleport",
        Options = islands,
        Default = "Ocean",
        Callback = function(v) Config.TeleportIsland = v end
    })

    Sec:AddButton({
        Title = "Teleport Now",
        Callback = function()
            pcall(function()
                local target = workspace:FindFirstChild(Config.TeleportIsland, true)
                if target then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and target:IsA("BasePart") then
                        hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end)
        end
    })

    local Sec2 = Tab:AddSection("Teleport Player")
    local pNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(pNames, p.Name) end
    end

    local tpPlayerDropdown = Sec2:AddDropdown({
        Title = "Select Player",
        Content = "Pilih pemain untuk teleport",
        Options = pNames,
        Default = pNames[1] or nil,
        Callback = function(v) Config.TeleportPlayer = v end
    })

    Sec2:AddButton({
        Title = "Update Player List",
        Callback = function()
            local newNames = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(newNames, p.Name) end
            end
            if tpPlayerDropdown and tpPlayerDropdown.SetValues then
                tpPlayerDropdown:SetValues(newNames)
            end
        end
    })

    Sec2:AddToggle({
        Title = "Stick to Player",
        Content = "Auto Follow Player",
        Default = false,
        Callback = function(v)
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
        end
    })

    -- Auto-refresh
    local function refreshTPPlayers()
        local newNames = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newNames, p.Name) end
        end
        if tpPlayerDropdown and tpPlayerDropdown.SetValues then
            tpPlayerDropdown:SetValues(newNames)
        end
    end
    Players.PlayerAdded:Connect(refreshTPPlayers)
    Players.PlayerRemoving:Connect(refreshTPPlayers)
end

------------------------------------------------------------
-- TAB 16: LIMITED EVENT
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Limited Event", Icon = "calendar" })
    local Sec = Tab:AddSection("Limited Event")

    Sec:AddButton({
        Title = "Open Pirate's Cove Wall",
        Callback = function() end
    })

    Sec:AddToggle({
        Title = "Auto Claim Presents",
        Content = "Membuka semua hadiah santa secara otomatis",
        Default = false,
        Callback = function(v) Config.AutoClaimPresents = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Mining Crystals",
        Content = "Teleport -> Equip -> Tween (Anti-Fall)",
        Default = false,
        Callback = function(v) Config.AutoMiningCrystals = v end
    })
end

------------------------------------------------------------
-- TAB 17: EVENT TELEPORT
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Event Teleport", Icon = "navigation" })
    local Sec = Tab:AddSection("Event Teleport")

    local events = {"Megalodon Hunt", "Ghost Shark Hunt"}
    Sec:AddDropdown({
        Title = "Select Event",
        Content = "Pilih event untuk teleport",
        Options = events,
        Default = "Megalodon Hunt",
        Callback = function(v) Config.EventTeleport = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Event Teleport",
        Content = "Aktifkan / Nonaktifkan Auto Event Teleport",
        Default = false,
        Callback = function(v) Config.AutoEventTeleport = v end
    })

    Sec:AddToggle({
        Title = "Enable Auto Hacker Event",
        Content = "Auto Teleport Hacker Event",
        Default = false,
        Callback = function(v) Config.AutoHackerEvent = v end
    })

    local Sec2 = Tab:AddSection("Admin Event")

    local countdownParagraph = Sec2:AddParagraph({
        Title = "Countdown Ancient Ruins Event",
        Content = "0h 0m 0s"
    })

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local deps = workspace:FindFirstChild("!!! DEPENDENCIES")
                if deps then
                    local tracker = deps:FindFirstChild("Event Tracker")
                    if tracker then
                        local label = tracker.Main.Gui.Content.Items.Countdown.Label
                        if label and countdownParagraph and countdownParagraph.SetContent then
                            countdownParagraph:SetContent(label.Text)
                        end
                    end
                end
            end)
        end
    end)

    Sec2:AddToggle({
        Title = "Auto Ancient Ruins Event Teleport",
        Content = "Auto Teleport saat Ancient Ruins Event",
        Default = false,
        Callback = function(v) Config.AutoAncientRuinsTP = v end
    })
end

------------------------------------------------------------
-- TAB 18: WEBHOOK
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Webhook", Icon = "bell" })
    local Sec = Tab:AddSection("Webhook")

    Sec:AddInput({
        Title = "Webhook URL",
        Content = "Masukkan URL webhook pribadi",
        Default = "",
        Callback = function(v) Config.WebhookURL = v end
    })

    Sec:AddDropdown({
        Title = "Detection Mode",
        Content = "Pilih opsi deteksi webhook",
        Options = {"Player", "Server"},
        Default = "Player",
        Callback = function(v) Config.DetectionMode = v end
    })

    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Exotic"}
    Sec:AddDropdown({
        Title = "Select Rarity Webhook",
        Content = "Pilih rarity untuk webhook pribadi",
        Multi = true,
        Options = rarities,
        Default = {},
        Callback = function(v) Config.WebhookRarity = v end
    })

    Sec:AddToggle({
        Title = "Enable Webhook",
        Content = "Aktifkan / Nonaktifkan Webhook Pribadi",
        Default = false,
        Callback = function(v) Config.EnableWebhook = v end
    })

    Sec:AddToggle({
        Title = "Enable Disconnected Webhook",
        Content = "Aktifkan / Nonaktifkan Webhook Disconnected",
        Default = false,
        Callback = function(v) Config.EnableDisconnectedWebhook = v end
    })

    Sec:AddButton({
        Title = "Send Webhook Test",
        Callback = function()
            if Config.WebhookURL ~= "" then
                pcall(function()
                    local requestFunc = (syn and syn.request) or http_request or request
                    if requestFunc then
                        requestFunc({
                            Url = Config.WebhookURL,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = HttpService:JSONEncode({content = "iSylHub Webhook Test - Working!"})
                        })
                    end
                end)
            end
        end
    })
end

------------------------------------------------------------
-- TAB 19: OPTIMIZATION
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Optimization", Icon = "cpu" })
    local Sec = Tab:AddSection("Optimization")

    Sec:AddButton({
        Title = "FPS Booster (Force Mode)",
        Callback = function()
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
        end
    })

    Sec:AddToggle({
        Title = "GPU Saver",
        Content = "Black Screen Mode",
        Default = false,
        Callback = function(v)
            Config.GPUSaver = v
            pcall(function()
                Camera.CameraType = v and Enum.CameraType.Scriptable or Enum.CameraType.Custom
                if not v then Camera.FieldOfView = 70 end
            end)
        end
    })

    Sec:AddToggle({
        Title = "No Animation",
        Content = "Freeze animasi karakter",
        Default = false,
        Callback = function(v) Config.NoAnimation = v end
    })

    Sec:AddToggle({
        Title = "Disable Rod Effect",
        Content = "Menghilangkan Effect Rod",
        Default = false,
        Callback = function(v) Config.DisableRodEffect = v end
    })

    Sec:AddToggle({
        Title = "Disable Cutscene",
        Content = "Menghilangkan Animasi Cutscene",
        Default = false,
        Callback = function(v) Config.DisableCutscene = v end
    })

    Sec:AddToggle({
        Title = "Disable PopUp Notification",
        Content = "Menghilangkan animasi PopUp ikan",
        Default = false,
        Callback = function(v) Config.DisablePopUpNotification = v end
    })

    Sec:AddToggle({
        Title = "Remove All Player",
        Content = "Menghilangkan Player Lain",
        Default = false,
        Callback = function(v)
            Config.RemoveAllPlayer = v
            if v then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        p.Character:Destroy()
                    end
                end
            end
        end
    })

    local Sec2 = Tab:AddSection("Display Performance")
    Sec2:AddToggle({
        Title = "Show Performance Stats",
        Content = "Memunculkan Stats CPU, FPS, Ping",
        Default = false,
        Callback = function(v) Config.ShowPerformanceStats = v end
    })
end

------------------------------------------------------------
-- TAB 20: GENERAL FEATURES
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "General Features", Icon = "sliders" })
    local Sec = Tab:AddSection("General Features")

    Sec:AddToggle({
        Title = "Anti AFK",
        Content = "Mencegah kick 20 menit (Stealth Mode)",
        Default = false,
        Callback = function(v)
            Config.AntiAFK = v
            if v then
                LocalPlayer.Idled:Connect(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end
        end
    })

    Sec:AddToggle({
        Title = "Anti Staff",
        Content = "Disconnect ketika staff masuk server",
        Default = false,
        Callback = function(v)
            Config.AntiStaff = v
            if v then
                Players.PlayerAdded:Connect(function(player)
                    if Config.AntiStaff then
                        pcall(function()
                            local rank = player:GetRankInGroup(0)
                            if rank and rank >= 200 then
                                LocalPlayer:Kick("Staff detected: " .. player.Name)
                            end
                        end)
                    end
                end)
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
        end
    })
end

------------------------------------------------------------
-- TAB 21: PLAYER UTILITIES
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Player Utilities", Icon = "user" })
    local Sec = Tab:AddSection("Player Utilities")

    Sec:AddToggle({
        Title = "Walk On Water",
        Content = "Membuat player bisa berjalan diatas air",
        Default = false,
        Callback = function(v) Config.WalkOnWater = v end
    })

    Sec:AddToggle({
        Title = "No Clip",
        Content = "Menembus tembok",
        Default = false,
        Callback = function(v)
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
        end
    })

    Sec:AddToggle({
        Title = "Fly",
        Content = "Membuat karakter bisa terbang",
        Default = false,
        Callback = function(v)
            Config.Fly = v
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.PlatformStand = false end
            end)
        end
    })

    Sec:AddToggle({
        Title = "Infinite Zoom Out",
        Content = "Bisa Zoom Out Jauh",
        Default = false,
        Callback = function(v)
            Config.InfiniteZoomOut = v
            pcall(function()
                LocalPlayer.CameraMaxZoomDistance = v and 9999 or 128
            end)
        end
    })
end

------------------------------------------------------------
-- TAB 22: STREAMER MODE
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Streamer Mode", Icon = "eye-off" })
    local Sec = Tab:AddSection("Streamer Mode")

    Sec:AddToggle({
        Title = "Hide Player Names",
        Content = "Sembunyikan nama semua player lain",
        Default = false,
        Callback = function(v) Config.HidePlayerNames = v end
    })

    Sec:AddToggle({
        Title = "RGB Overhead Name",
        Content = "Warna nama karakter sendiri berubah RGB",
        Default = false,
        Callback = function(v)
            Config.RGBOverheadName = v
            if v then
                task.spawn(function()
                    while Config.RGBOverheadName do
                        pcall(function()
                            local char = LocalPlayer.Character
                            if char then
                                local head = char:FindFirstChild("Head")
                                if head then
                                    local bg = head:FindFirstChildOfClass("BillboardGui")
                                    if bg then
                                        local tl = bg:FindFirstChildOfClass("TextLabel")
                                        if tl then
                                            tl.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait(0.05)
                    end
                end)
            end
        end
    })
end

------------------------------------------------------------
-- TAB 23: CUSTOM AVATAR
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Custom Avatar", Icon = "image" })
    local Sec = Tab:AddSection("Custom Avatar")

    local presets = {"Bacon Hair", "Builderman", "Classic Noob", "Jane Doe", "John Doe", "Roblox"}
    Sec:AddDropdown({
        Title = "Avatar Preset",
        Content = "Pilih preset avatar",
        Options = presets,
        Default = "Bacon Hair",
        Callback = function(v) Config.AvatarPreset = v end
    })

    Sec:AddInput({
        Title = "Manual User ID",
        Content = "Atau masukkan User ID manual",
        Default = "",
        Callback = function(v) Config.ManualUserId = v end
    })

    Sec:AddButton({
        Title = "Apply Avatar",
        Callback = function() end
    })
end

------------------------------------------------------------
-- TAB 24: FREE CAM
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Free Cam", Icon = "video" })
    local Sec = Tab:AddSection("Free Cam")

    Sec:AddSlider({
        Title = "Free Cam Speed",
        Content = "Kecepatan gerak kamera (default 50)",
        Min = 1, Max = 200, Default = 50, Increment = 1,
        Callback = function(v) Config.FreeCamSpeed = v end
    })

    Sec:AddToggle({
        Title = "Enable Free Cam",
        Content = "WASD+Mouse gerak kamera, E/Q naik/turun",
        Default = false,
        Callback = function(v) Config.EnableFreeCam = v end
    })
end

------------------------------------------------------------
-- TAB 25: SERVER UTILITIES
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Server Utilities", Icon = "server" })
    local Sec = Tab:AddSection("Server Utilities")

    Sec:AddButton({
        Title = "Rejoin",
        Callback = function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    })

    Sec:AddButton({
        Title = "Server Hop",
        Callback = function()
            pcall(function()
                local servers = HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                ))
                if servers and servers.data then
                    for _, server in ipairs(servers.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                            break
                        end
                    end
                end
            end)
        end
    })

    Sec:AddParagraph({
        Title = "Server Info",
        Content = "Job ID: " .. game.JobId
    })
end

------------------------------------------------------------
-- TAB 26: CONFIG MANAGER
------------------------------------------------------------
do
    local Tab = Window:AddTab({ Name = "Config Manager", Icon = "save" })
    local Sec = Tab:AddSection("Config Manager")

    Sec:AddToggle({
        Title = "Include Player Location",
        Content = "Teleport to saved location on load",
        Default = false,
        Callback = function(v) Config.IncludePlayerLocation = v end
    })

    Sec:AddInput({
        Title = "Create Config Name",
        Content = "",
        Default = "",
        Callback = function(v) Config.ConfigName = v end
    })

    Sec:AddButton({
        Title = "Create New Config",
        Callback = function()
            if Config.ConfigName ~= "" then
                pcall(function()
                    local configData = HttpService:JSONEncode(Config)
                    writefile("iSylHub_" .. Config.ConfigName .. ".json", configData)
                end)
            end
        end
    })

    -- Config list dropdown
    local configList = {}
    pcall(function()
        local files = listfiles(".")
        for _, f in ipairs(files) do
            if f:find("iSylHub_") and f:find(".json") then
                table.insert(configList, f:match("iSylHub_(.+)%.json"))
            end
        end
    end)

    local configDropdown = Sec:AddDropdown({
        Title = "Select Config",
        Content = "Pilih config untuk diload",
        Options = configList,
        Default = configList[1] or nil,
        Callback = function(v) Config.SelectedConfig = v end
    })

    Sec:AddButton({
        Title = "Refresh List",
        Callback = function()
            local newList = {}
            pcall(function()
                local files = listfiles(".")
                for _, f in ipairs(files) do
                    if f:find("iSylHub_") and f:find(".json") then
                        table.insert(newList, f:match("iSylHub_(.+)%.json"))
                    end
                end
            end)
            if configDropdown and configDropdown.SetValues then
                configDropdown:SetValues(newList)
            end
        end
    })

    Sec:AddButton({
        Title = "Load Config",
        Callback = function()
            if Config.SelectedConfig and Config.SelectedConfig ~= "" then
                pcall(function()
                    local data = readfile("iSylHub_" .. Config.SelectedConfig .. ".json")
                    local loaded = HttpService:JSONDecode(data)
                    for k, v in pairs(loaded) do
                        Config[k] = v
                    end
                end)
            end
        end
    })

    Sec:AddButton({
        Title = "Overwrite Config",
        Callback = function()
            if Config.SelectedConfig and Config.SelectedConfig ~= "" then
                pcall(function()
                    writefile("iSylHub_" .. Config.SelectedConfig .. ".json", HttpService:JSONEncode(Config))
                end)
            end
        end
    })

    Sec:AddButton({
        Title = "Delete Config",
        Callback = function()
            if Config.SelectedConfig and Config.SelectedConfig ~= "" then
                pcall(function()
                    delfile("iSylHub_" .. Config.SelectedConfig .. ".json")
                end)
            end
        end
    })

    local autoloadParagraph = Sec:AddParagraph({
        Title = "Autoload Status",
        Content = "Current: " .. Config.AutoloadConfig
    })

    Sec:AddButton({
        Title = "Set Autoload",
        Callback = function()
            Config.AutoloadConfig = Config.SelectedConfig or "None"
            if autoloadParagraph and autoloadParagraph.SetContent then
                autoloadParagraph:SetContent("Current: " .. Config.AutoloadConfig)
            end
        end
    })

    Sec:AddButton({
        Title = "Delete Autoload",
        Callback = function()
            Config.AutoloadConfig = "None"
            if autoloadParagraph and autoloadParagraph.SetContent then
                autoloadParagraph:SetContent("Current: None")
            end
        end
    })
end

------------------------------------------------------------
-- EVENT HANDLERS (CUTSCENE/EFFECT BLOCKERS)
------------------------------------------------------------
if RE_ReplicateCutscene then
    RE_ReplicateCutscene.OnClientEvent:Connect(function(...)
        if Config.DisableCutscene then return end
    end)
end

if RE_StopCutscene then
    RE_StopCutscene.OnClientEvent:Connect(function(...)
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
                local rarity = fishData.Rarity or fishData.rarity or "Unknown"
                local shouldSend = false
                for _, r in ipairs(Config.WebhookRarity) do
                    if r == rarity then shouldSend = true; break end
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
                                    "🎣 **Fish Caught!**\nPlayer: %s\nFish: %s\nRarity: %s",
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
-- POPUP / EFFECT BLOCKERS
------------------------------------------------------------
if RE_ObtainedNewFish then
    RE_ObtainedNewFish.OnClientEvent:Connect(function(...)
        if Config.DisablePopUpNotification then return end
    end)
end

if RE_PlayFishingEffect then
    RE_PlayFishingEffect.OnClientEvent:Connect(function(...)
        if Config.DisableRodEffect then return end
    end)
end

------------------------------------------------------------
-- SCRIPT LOADED
------------------------------------------------------------
print("[iSylHub] Free v3.0 loaded successfully!")
