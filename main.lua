-- ══════════════════════════════════════════
--  VOID.WTF — LOADSTRING LOADER
--  Replace the URL with your raw GitHub URL
-- ══════════════════════════════════════════
--[[
loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE", true))()
]]

-- ══════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local localPlayer      = Players.LocalPlayer
local camera           = workspace.CurrentCamera
local mouse            = localPlayer:GetMouse()

-- ══════════════════════════════════════════
--  STREAMPROOF
-- ══════════════════════════════════════════

local function makeStreamproof(gui)
    local success = false
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = game.CoreGui
            success = true
        end
    end)
    if not success then
        pcall(function()
            if gethui then
                gui.Parent = gethui()
                success = true
            end
        end)
    end
    if not success then
        pcall(function()
            gui.Parent = game.CoreGui
        end)
        if not gui.Parent or gui.Parent ~= game.CoreGui then
            gui.Parent = localPlayer:WaitForChild("PlayerGui")
        end
    end
end

-- ══════════════════════════════════════════
--  KEY SYSTEM
-- ══════════════════════════════════════════

local VALID_KEYS  = { ["999"] = true }
local keyVerified = false

local keyGui             = Instance.new("ScreenGui")
keyGui.Name              = "VoidKeySystem"
keyGui.ResetOnSpawn      = false
keyGui.IgnoreGuiInset    = true
makeStreamproof(keyGui)

local keyFrame                  = Instance.new("Frame", keyGui)
keyFrame.Size                   = UDim2.new(0, 380, 0, 210)
keyFrame.Position               = UDim2.new(0.5, -190, 0.5, -105)
keyFrame.BackgroundColor3       = Color3.fromRGB(10, 5, 20)
keyFrame.BorderSizePixel        = 0
keyFrame.Active                 = true
keyFrame.Draggable              = true
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)

local grad        = Instance.new("UIGradient", keyFrame)
grad.Color        = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 10, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 4, 18)),
})
grad.Rotation = 90

local stroke          = Instance.new("UIStroke", keyFrame)
stroke.Color          = Color3.fromRGB(130, 60, 220)
stroke.Thickness      = 1.5

local keyTitle                       = Instance.new("TextLabel", keyFrame)
keyTitle.Size                        = UDim2.new(1, 0, 0, 40)
keyTitle.Position                    = UDim2.new(0, 0, 0, 10)
keyTitle.BackgroundTransparency      = 1
keyTitle.Text                        = "void.wtf — Key System"
keyTitle.TextColor3                  = Color3.fromRGB(210, 180, 255)
keyTitle.Font                        = Enum.Font.GothamBold
keyTitle.TextSize                    = 16

local keySubtitle                    = Instance.new("TextLabel", keyFrame)
keySubtitle.Size                     = UDim2.new(1, -40, 0, 20)
keySubtitle.Position                 = UDim2.new(0, 20, 0, 50)
keySubtitle.BackgroundTransparency   = 1
keySubtitle.Text                     = "Enter your key to continue"
keySubtitle.TextColor3               = Color3.fromRGB(170, 140, 210)
keySubtitle.Font                     = Enum.Font.Gotham
keySubtitle.TextSize                 = 13

local keyBox                 = Instance.new("TextBox", keyFrame)
keyBox.Size                  = UDim2.new(1, -40, 0, 38)
keyBox.Position              = UDim2.new(0, 20, 0, 82)
keyBox.BackgroundColor3      = Color3.fromRGB(20, 10, 40)
keyBox.TextColor3            = Color3.fromRGB(240, 220, 255)
keyBox.PlaceholderText       = "Paste key here..."
keyBox.PlaceholderColor3     = Color3.fromRGB(100, 80, 140)
keyBox.Font                  = Enum.Font.Gotham
keyBox.TextSize              = 14
keyBox.ClearTextOnFocus      = false
keyBox.BorderSizePixel       = 0
Instance.new("UICorner", keyBox).CornerRadius  = UDim.new(0, 8)
Instance.new("UIStroke", keyBox).Color         = Color3.fromRGB(130, 60, 220)

local keyStatus                      = Instance.new("TextLabel", keyFrame)
keyStatus.Size                       = UDim2.new(1, -40, 0, 20)
keyStatus.Position                   = UDim2.new(0, 20, 0, 128)
keyStatus.BackgroundTransparency     = 1
keyStatus.Text                       = ""
keyStatus.TextColor3                 = Color3.fromRGB(255, 80, 80)
keyStatus.Font                       = Enum.Font.Gotham
keyStatus.TextSize                   = 12

local keyBtn                 = Instance.new("TextButton", keyFrame)
keyBtn.Size                  = UDim2.new(1, -40, 0, 38)
keyBtn.Position              = UDim2.new(0, 20, 0, 155)
keyBtn.BackgroundColor3      = Color3.fromRGB(110, 40, 200)
keyBtn.TextColor3            = Color3.fromRGB(240, 220, 255)
keyBtn.Text                  = "Verify Key"
keyBtn.Font                  = Enum.Font.GothamBold
keyBtn.TextSize              = 14
keyBtn.BorderSizePixel       = 0
keyBtn.AutoButtonColor       = true
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)

-- ══════════════════════════════════════════
--  PROFILE SYSTEM
-- ══════════════════════════════════════════

local PROFILE_DIR  = "VoidWTF/"
local PROFILE_FILE = PROFILE_DIR .. "profiles.json"

local profileSystem            = {}
profileSystem.profiles         = {}
profileSystem.activeProfile    = "Default"

local function ensureDir()
    pcall(function()
        if not isfolder(PROFILE_DIR) then
            makefolder(PROFILE_DIR)
        end
    end)
end

local function saveProfiles()
    ensureDir()
    pcall(function()
        writefile(PROFILE_FILE, HttpService:JSONEncode(profileSystem.profiles))
    end)
end

local function loadProfiles()
    ensureDir()
    pcall(function()
        if isfile(PROFILE_FILE) then
            local data = readfile(PROFILE_FILE)
            profileSystem.profiles = HttpService:JSONDecode(data)
        end
    end)
    if not profileSystem.profiles["Default"] then
        profileSystem.profiles["Default"] = { settings = {}, keybinds = {} }
        saveProfiles()
    end
end

loadProfiles()

function profileSystem:SaveSetting(key, value)
    local p = self.profiles[self.activeProfile]
    if not p then return end
    p.settings[key] = value
    saveProfiles()
end

function profileSystem:LoadSetting(key, default)
    local p = self.profiles[self.activeProfile]
    if not p then return default end
    local v = p.settings[key]
    return v ~= nil and v or default
end

function profileSystem:SaveKeybind(action, keyCode)
    local p = self.profiles[self.activeProfile]
    if not p then return end
    p.keybinds[action] = keyCode
    saveProfiles()
end

function profileSystem:LoadKeybind(action, default)
    local p = self.profiles[self.activeProfile]
    if not p then return default end
    return p.keybinds[action] or default
end

function profileSystem:CreateProfile(name)
    if not self.profiles[name] then
        self.profiles[name] = { settings = {}, keybinds = {} }
        saveProfiles()
    end
end

function profileSystem:DeleteProfile(name)
    if name == "Default" then return end
    self.profiles[name] = nil
    if self.activeProfile == name then
        self.activeProfile = "Default"
    end
    saveProfiles()
end

function profileSystem:GetProfileNames()
    local names = {}
    for k, _ in pairs(self.profiles) do
        table.insert(names, k)
    end
    return names
end

-- ══════════════════════════════════════════
--  GAME DETECTION
-- ══════════════════════════════════════════

local DA_HOOD_IDS = {
    [2788229376] = true,
    [6472838823] = true,
    [7784997096] = true,
    [5335562696] = true,
}

local function isDaHood()
    if DA_HOOD_IDS[game.PlaceId] then return true end
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        local name = string.lower(info.Name)
        if string.find(name, "da hood") or string.find(name, "dahood") then
            return true
        end
    end
    return false
end

local IS_DA_HOOD = false
pcall(function() IS_DA_HOOD = isDaHood() end)

-- ══════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════

local espEnabled       = profileSystem:LoadSetting("espEnabled",       false)
local aimbotEnabled    = profileSystem:LoadSetting("aimbotEnabled",    false)
local speedEnabled     = profileSystem:LoadSetting("speedEnabled",     false)
local silentAimEnabled = profileSystem:LoadSetting("silentAimEnabled", false)
local espColor         = Color3.fromRGB(160, 80, 255)
local npcColor         = Color3.fromRGB(255, 80, 80)
local speedValue       = profileSystem:LoadSetting("speedValue", 16)
local espBoxes         = {}

local aimbotConfig = {
    mode       = profileSystem:LoadSetting("aimbotMode",      "Legit"),
    fov        = profileSystem:LoadSetting("aimbotFov",        120),
    smoothness = profileSystem:LoadSetting("aimbotSmooth",     5),
    targetBone = profileSystem:LoadSetting("aimbotBone",       "Head"),
    wallCheck  = profileSystem:LoadSetting("aimbotWallCheck",  true),
    teamCheck  = profileSystem:LoadSetting("aimbotTeamCheck",  false),
    visibleOnly= profileSystem:LoadSetting("aimbotVisOnly",    false),
}

local fovCircle         = Drawing.new("Circle")
fovCircle.Visible       = false
fovCircle.Color         = Color3.fromRGB(210, 180, 255)
fovCircle.Thickness     = 1
fovCircle.Filled        = false
fovCircle.NumSides      = 64
fovCircle.Radius        = aimbotConfig.fov

-- ══════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════

local function isLocalChar(model)
    return localPlayer.Character == model
end

local function getHumanoid(model)
    return model:FindFirstChildOfClass("Humanoid")
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
end

local function isAlive(model)
    local hum = getHumanoid(model)
    return hum and hum.Health > 0
end

local function getBone(model, boneName)
    return model:FindFirstChild(boneName)
        or model:FindFirstChild("HumanoidRootPart")
end

local function hasLineOfSight(part)
    if not aimbotConfig.wallCheck then return true end
    local origin = camera.CFrame.Position
    local dir    = (part.Position - origin)
    local ray    = Ray.new(origin, dir)
    local hit    = workspace:FindPartOnRayWithIgnoreList(ray, {
        localPlayer.Character, camera
    })
    if not hit then return true end
    return hit:IsDescendantOf(part.Parent)
end

local function isSameTeam(model)
    if not aimbotConfig.teamCheck then return false end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character == model then
            return p.Team == localPlayer.Team
        end
    end
    return false
end

local function getPlayerChars()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            t[p.Character] = p.Name
        end
    end
    return t
end

local function getNPCModels()
    local playerChars = getPlayerChars()
    local t = {}
    for _, model in ipairs(workspace:GetDescendants()) do
        if  model:IsA("Model")
        and not playerChars[model]
        and not isLocalChar(model)
        and getHumanoid(model)
        and getRoot(model)
        then
            t[model] = model.Name
        end
    end
    return t
end

local function getAllTargets()
    local t = {}
    for model, name in pairs(getPlayerChars()) do
        if not isSameTeam(model) then
            t[model] = { name = name, isNPC = false }
        end
    end
    for model, name in pairs(getNPCModels()) do
        t[model] = { name = name, isNPC = true }
    end
    return t
end

-- ══════════════════════════════════════════
--  ESP
-- ══════════════════════════════════════════

local function makeDrawing(model, isNPC)
    if espBoxes[model] then return end
    local col = isNPC and npcColor or espColor

    local box        = Drawing.new("Box")
    box.Visible      = false
    box.Color        = col
    box.Thickness    = 1.5
    box.Filled       = false
    box.Transparency = 1

    local label      = Drawing.new("Text")
    label.Visible    = false
    label.Color      = col
    label.Size       = 13
    label.Outline    = true
    label.Center     = true

    local healthBar      = Drawing.new("Line")
    healthBar.Visible    = false
    healthBar.Color      = Color3.fromRGB(80, 255, 100)
    healthBar.Thickness  = 2

    espBoxes[model] = { box = box, label = label, healthBar = healthBar, isNPC = isNPC }
end

local function removeDrawing(model)
    if espBoxes[model] then
        espBoxes[model].box:Remove()
        espBoxes[model].label:Remove()
        espBoxes[model].healthBar:Remove()
        espBoxes[model] = nil
    end
end

local function updateESPColor()
    for model, data in pairs(espBoxes) do
        local col = data.isNPC and npcColor or espColor
        data.box.Color   = col
        data.label.Color = col
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= localPlayer and p.Character then
        makeDrawing(p.Character, false)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        makeDrawing(char, false)
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if p.Character then removeDrawing(p.Character) end
end)

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    if obj:IsA("Model") and getHumanoid(obj) and getRoot(obj) and not isLocalChar(obj) then
        if not getPlayerChars()[obj] then
            makeDrawing(obj, true)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if espBoxes[obj] then removeDrawing(obj) end
end)

for model, _ in pairs(getNPCModels()) do
    makeDrawing(model, true)
end

-- ══════════════════════════════════════════
--  SILENT AIM (Da Hood)
-- ══════════════════════════════════════════

local function getSilentAimTarget()
    local closestDist = math.huge
    local closestPart = nil
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for model, _ in pairs(getAllTargets()) do
        if not isAlive(model) then continue end
        local bone = getBone(model, aimbotConfig.targetBone)
        if not bone then continue end
        local screenPos, onScreen = camera:WorldToViewportPoint(bone.Position)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPart = bone
            end
        end
    end
    return closestPart
end

if IS_DA_HOOD then
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if silentAimEnabled then
                if key == "Hit" then
                    local target = getSilentAimTarget()
                    if target then return CFrame.new(target.Position) end
                end
                if key == "UnitRay" then
                    local target = getSilentAimTarget()
                    if target then
                        local origin = camera.CFrame.Position
                        local dir    = (target.Position - origin).Unit
                        return Ray.new(origin, dir)
                    end
                end
            end
            return oldIndex(self, key)
        end)
    end)
end

-- ══════════════════════════════════════════
--  AIMBOT
-- ══════════════════════════════════════════

local function getNearestTarget()
    local closestDist = aimbotConfig.fov
    local closestPart = nil
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for model, _ in pairs(getAllTargets()) do
        if not isAlive(model) then continue end
        local bone = getBone(model, aimbotConfig.targetBone)
        if not bone then continue end
        if aimbotConfig.visibleOnly and not hasLineOfSight(bone) then continue end
        local screenPos, onScreen = camera:WorldToViewportPoint(bone.Position)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPart = bone
            end
        end
    end
    return closestPart
end

-- ══════════════════════════════════════════
--  RENDER LOOP
-- ══════════════════════════════════════════

RunService.RenderStepped:Connect(function()

    for model, data in pairs(espBoxes) do
        if not model or not model.Parent then
            data.box:Remove()
            data.label:Remove()
            data.healthBar:Remove()
            espBoxes[model] = nil
        end
    end

    for model, data in pairs(espBoxes) do
        local box       = data.box
        local label     = data.label
        local healthBar = data.healthBar
        local root      = getRoot(model)
        local hum       = getHumanoid(model)

        if not espEnabled or not root or not hum or hum.Health <= 0 then
            box.Visible       = false
            label.Visible     = false
            healthBar.Visible = false
            continue
        end

        local topPos,    topVis    = camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local bottomPos, bottomVis = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))

        if not topVis or not bottomVis then
            box.Visible       = false
            label.Visible     = false
            healthBar.Visible = false
            continue
        end

        local height = math.abs(topPos.Y - bottomPos.Y)
        local width  = height * 0.5
        local x      = topPos.X - width / 2
        local y      = topPos.Y

        box.Size     = Vector2.new(width, height)
        box.Position = Vector2.new(x, y)
        box.Visible  = true

        local hpRatio       = hum.Health / hum.MaxHealth
        local barHeight     = height * hpRatio
        healthBar.From      = Vector2.new(x - 5, y + height)
        healthBar.To        = Vector2.new(x - 5, y + height - barHeight)
        healthBar.Color     = Color3.fromRGB(
            math.floor(255 * (1 - hpRatio)),
            math.floor(255 * hpRatio),
            50
        )
        healthBar.Visible   = true

        local tag      = data.isNPC and "[NPC]" or "[PLR]"
        label.Text     = tag .. " " .. model.Name .. " [" .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "]"
        label.Position = Vector2.new(topPos.X, y - 16)
        label.Visible  = true
    end

    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Position = center
    fovCircle.Radius   = aimbotConfig.fov
    fovCircle.Visible  = aimbotEnabled

    if aimbotEnabled then
        local pressing = false
        pcall(function()
            pressing = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end)
        if pressing then
            local target = getNearestTarget()
            if target then
                if aimbotConfig.mode == "Legit" then
                    local currentCF = camera.CFrame
                    local direction = (target.Position - currentCF.Position).Unit
                    local targetCF  = CFrame.new(currentCF.Position, currentCF.Position + direction)
                    camera.CFrame   = currentCF:Lerp(targetCF, aimbotConfig.smoothness / 10)
                else
                    local dir     = (target.Position - camera.CFrame.Position).Unit
                    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + dir)
                end
            end
        end
    end

end)

-- ══════════════════════════════════════════
--  SPEED
-- ══════════════════════════════════════════

local function applySpeed()
    local char = localPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speedEnabled and speedValue or 16
        end
    end
end

localPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    applySpeed()
end)

-- ══════════════════════════════════════════
--  BUILD MAIN UI
-- ══════════════════════════════════════════

local function buildUI()

    local AequorUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/hnwiie/AequorUI/refs/heads/main/main.lua", true
    ))()

    AequorUI.ThemeManager.Themes["Void"] = {
        MainColor            = Color3.fromRGB(10, 5, 20),
        SelectionColor       = Color3.fromRGB(130, 60, 220),
        GlowColor            = Color3.fromRGB(160, 80, 255),
        BoundaryColor        = Color3.fromRGB(180, 100, 255),
        BoundaryTransparency = 0.75,
        Transparency         = 0.15,
        GradientStart        = Color3.fromRGB(25, 10, 50),
        GradientEnd          = Color3.fromRGB(8, 4, 18),
        TextColor            = Color3.fromRGB(240, 220, 255),
        DescTextColor        = Color3.fromRGB(170, 140, 210),
        ClipboardIcon        = "rbxassetid://106330002535278",
        CustomDecorations    = {},
    }

    local screenGui = AequorUI.GeneralUI:CreateMain(Enum.KeyCode.L, "Void")
    makeStreamproof(screenGui)

    local mainFrame = screenGui:WaitForChild("MainFrame")
    local divider   = mainFrame:WaitForChild("Divider")
    local myTabs    = AequorUI.TabManager:Init(mainFrame)

    local tab1, container1 = myTabs:CreateTab("Home",    "Home",   1)
    local tab2, container2 = myTabs:CreateTab("Profile", "Human",  2)
    local tab3, container3
    if IS_DA_HOOD then
        tab3, container3 = myTabs:CreateTab("Da Hood", "Target", 3)
    end

    AequorUI.ThemeManager:SetTheme("Void", mainFrame)
    AequorUI.ThemeManager:SetTransparency(0.15, mainFrame)
    AequorUI.ThemeManager:SetComponentColor("Selection", Color3.fromRGB(130, 60, 220), { myTabs.SelectionBar })
    AequorUI.ThemeManager:SetComponentColor("Boundary",  Color3.fromRGB(180, 100, 255), { myTabs.BoundaryLine, divider })

    local glows = { tab1:WaitForChild("Glow"), tab2:WaitForChild("Glow") }
    local icons = { tab1:WaitForChild("Icon"), tab2:WaitForChild("Icon") }
    if tab3 then
        table.insert(glows, tab3:WaitForChild("Glow"))
        table.insert(icons, tab3:WaitForChild("Icon"))
    end

    AequorUI.ThemeManager:SetComponentColor("Glow", Color3.fromRGB(160, 80, 255), glows)
    AequorUI.ThemeManager:SetComponentTransparency("Boundary", 0.75, { myTabs.BoundaryLine, divider })
    AequorUI.IconManager:SetIconColor(Color3.fromRGB(210, 180, 255), icons)

    -- ──────────────────────────────────────
    --  HOME TAB
    -- ──────────────────────────────────────

    AequorUI.ElementManager:CreateParagraph(container1,
        "Welcome to void.wtf",
        "The cleanest universal script hub."
    )

    local espToggle = AequorUI.ElementManager:CreateToggle(container1,
        "ESP", "Show players & NPCs through walls.",
        function(state)
            espEnabled = state
            profileSystem:SaveSetting("espEnabled", state)
        end,
        { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
    )
    espToggle:SetValue(espEnabled)

    AequorUI.ElementManager:CreateColorPicker(container1,
        "Player ESP Color", "Color for real players.",
        Color3.fromRGB(160, 80, 255),
        function(color) espColor = color updateESPColor() end
    )

    AequorUI.ElementManager:CreateColorPicker(container1,
        "NPC ESP Color", "Color for bots and NPCs.",
        Color3.fromRGB(255, 80, 80),
        function(color) npcColor = color updateESPColor() end
    )

    local aimbotToggle = AequorUI.ElementManager:CreateToggle(container1,
        "Aimbot", "Hold RMB to lock onto nearest target.",
        function(state)
            aimbotEnabled = state
            profileSystem:SaveSetting("aimbotEnabled", state)
        end,
        { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
    )
    aimbotToggle:SetValue(aimbotEnabled)

    AequorUI.ElementManager:CreateDropdown(container1,
        "Aimbot Mode", "Legit = smooth. Blatant = instant snap.",
        { "Legit", "Blatant" },
        aimbotConfig.mode,
        function(sel)
            aimbotConfig.mode = sel
            profileSystem:SaveSetting("aimbotMode", sel)
        end
    )

    AequorUI.ElementManager:CreateDropdown(container1,
        "Target Bone", "Which part to aim at.",
        { "Head", "HumanoidRootPart", "Torso", "UpperTorso" },
        aimbotConfig.targetBone,
        function(sel)
            aimbotConfig.targetBone = sel
            profileSystem:SaveSetting("aimbotBone", sel)
        end
    )

    AequorUI.ElementManager:CreateSlider(container1,
        "Aimbot FOV", "How wide the aim circle is.",
        10, 500, aimbotConfig.fov,
        function(val)
            aimbotConfig.fov = val
            fovCircle.Radius = val
            profileSystem:SaveSetting("aimbotFov", val)
        end,
        { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
    )

    AequorUI.ElementManager:CreateSlider(container1,
        "Aimbot Smoothness", "Higher = smoother (legit only).",
        1, 20, aimbotConfig.smoothness,
        function(val)
            aimbotConfig.smoothness = val
            profileSystem:SaveSetting("aimbotSmooth", val)
        end,
        { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
    )

    local visToggle = AequorUI.ElementManager:CreateToggle(container1,
        "Visible Only", "Only target players you can see.",
        function(state)
            aimbotConfig.visibleOnly = state
            profileSystem:SaveSetting("aimbotVisOnly", state)
        end,
        { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
    )
    visToggle:SetValue(aimbotConfig.visibleOnly)

    local teamToggle = AequorUI.ElementManager:CreateToggle(container1,
        "Team Check", "Skip teammates.",
        function(state)
            aimbotConfig.teamCheck = state
            profileSystem:SaveSetting("aimbotTeamCheck", state)
        end,
        { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
    )
    teamToggle:SetValue(aimbotConfig.teamCheck)

    local speedToggle = AequorUI.ElementManager:CreateToggle(container1,
        "Speed Hack", "Enable custom walk speed.",
        function(state)
            speedEnabled = state
            profileSystem:SaveSetting("speedEnabled", state)
            applySpeed()
        end,
        { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
    )
    speedToggle:SetValue(speedEnabled)

    AequorUI.ElementManager:CreateSlider(container1,
        "Walk Speed", "Set your speed value.",
        16, 250, speedValue,
        function(val)
            speedValue = val
            profileSystem:SaveSetting("speedValue", val)
            applySpeed()
        end,
        { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
    )

    -- ──────────────────────────────────────
    --  DA HOOD TAB
    -- ──────────────────────────────────────

    if IS_DA_HOOD and container3 then

        AequorUI.ElementManager:CreateParagraph(container3,
            "Da Hood Config",
            "Auto-detected Da Hood (real + fake variants)."
        )

        local saToggle = AequorUI.ElementManager:CreateToggle(container3,
            "Silent Aim", "Bullets snap to target without moving camera.",
            function(state)
                silentAimEnabled = state
                profileSystem:SaveSetting("silentAimEnabled", state)
            end,
            { OnColor = Color3.fromRGB(110,40,200), OffColor = Color3.fromRGB(30,20,50), DotColor = Color3.fromRGB(230,200,255) }
        )
        saToggle:SetValue(silentAimEnabled)

        AequorUI.ElementManager:CreateParagraph(container3, "Legit Aimbot", "Slow, human-like aim.")

        AequorUI.ElementManager:CreateSlider(container3,
            "Legit Smoothness", "Higher = more human-like.",
            1, 20, aimbotConfig.smoothness,
            function(val)
                aimbotConfig.smoothness = val
                profileSystem:SaveSetting("aimbotSmooth", val)
            end,
            { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
        )

        AequorUI.ElementManager:CreateSlider(container3,
            "Legit FOV", "Smaller = tighter legit cone.",
            10, 200, 80,
            function(val)
                if aimbotConfig.mode == "Legit" then
                    aimbotConfig.fov = val
                    fovCircle.Radius = val
                    profileSystem:SaveSetting("aimbotFov", val)
                end
            end,
            { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
        )

        AequorUI.ElementManager:CreateParagraph(container3, "Blatant Aimbot", "Instant lock. Max FOV.")

        AequorUI.ElementManager:CreateSlider(container3,
            "Blatant FOV", "How wide blatant mode locks.",
            100, 500, 300,
            function(val)
                if aimbotConfig.mode == "Blatant" then
                    aimbotConfig.fov = val
                    fovCircle.Radius = val
                    profileSystem:SaveSetting("aimbotFov", val)
                end
            end,
            { TrackColor = Color3.fromRGB(20,10,40), FillColor = Color3.fromRGB(130,60,220), DotColor = Color3.fromRGB(210,180,255) }
        )

        AequorUI.ElementManager:CreateButton(container3,
            "Set Blatant Mode", "Switch aimbot to blatant instantly.",
            function()
                aimbotConfig.mode = "Blatant"
                profileSystem:SaveSetting("aimbotMode", "Blatant")
            end,
            { GlowColor = Color3.fromRGB(200,40,40), IconColor = Color3.fromRGB(255,180,180) }
        )

        AequorUI.ElementManager:CreateButton(container3,
            "Set Legit Mode", "Switch aimbot to legit instantly.",
            function()
                aimbotConfig.mode = "Legit"
                profileSystem:SaveSetting("aimbotMode", "Legit")
            end,
            { GlowColor = Color3.fromRGB(80,180,80), IconColor = Color3.fromRGB(180,255,180) }
        )
    end

    -- ──────────────────────────────────────
    --  PROFILE TAB
    -- ──────────────────────────────────────

    AequorUI.ElementManager:CreateParagraph(container2,
        "Profile System",
        "Active: " .. profileSystem.activeProfile
    )

    AequorUI.ElementManager:CreateDropdown(container2,
        "Active Profile", "Switch between saved profiles.",
        profileSystem:GetProfileNames(),
        profileSystem.activeProfile,
        function(sel)
            profileSystem.activeProfile = sel
            saveProfiles()
        end
    )

    AequorUI.ElementManager:CreateButton(container2,
        "Create New Profile",
        "Creates a new numbered profile.",
        function()
            local name = "Profile_" .. tostring(#profileSystem:GetProfileNames() + 1)
            profileSystem:CreateProfile(name)
            print("void.wtf — created: " .. name)
        end,
        { GlowColor = Color3.fromRGB(80,180,80), IconColor = Color3.fromRGB(180,255,180) }
    )

    AequorUI.ElementManager:CreateButton(container2,
        "Delete Active Profile",
        "Deletes current profile (not Default).",
        function()
            profileSystem:DeleteProfile(profileSystem.activeProfile)
        end,
        { GlowColor = Color3.fromRGB(200,40,40), IconColor = Color3.fromRGB(255,180,180) }
    )

    AequorUI.ElementManager:CreateParagraph(container2,
        "Keybinds",
        "Aimbot: RMB (Hold)\nUI Toggle: L"
    )

    AequorUI.ElementManager:CreateButton(container2,
        "Logout", "Sign out of your account.",
        function() print("Logout!") end,
        { GlowColor = Color3.fromRGB(180,40,40), IconColor = Color3.fromRGB(255,180,180) }
    )

    print("void.wtf loaded | profile: " .. profileSystem.activeProfile)
end

-- ══════════════════════════════════════════
--  KEY VERIFY
-- ══════════════════════════════════════════

local function verifyKey()
    local input = keyBox.Text:gsub("%s+", "")
    if VALID_KEYS[input] then
        keyVerified = true
        keyStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
        keyStatus.Text       = "✓ Key verified! Loading..."
        task.wait(0.8)
        keyGui:Destroy()
        buildUI()
    else
        keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        keyStatus.Text       = "✗ Invalid key. Try again."
        local orig = keyFrame.Position
        for i = 1, 6 do
            keyFrame.Position = orig + UDim2.new(0, i % 2 == 0 and 6 or -6, 0, 0)
            task.wait(0.04)
        end
        keyFrame.Position = orig
    end
end

keyBtn.MouseButton1Click:Connect(verifyKey)
keyBtn.MouseButton1Up:Connect(verifyKey)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then verifyKey() end
end)

print("void.wtf — key system ready")
