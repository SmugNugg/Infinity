-- Infinity UI Library Example
-- Load the library from GitHub
local Finity = loadstring(game:HttpGet("https://raw.githubusercontent.com/SmugNugg/Infinity/refs/heads/main/source.lua", true))();

-- Create window (false = light theme, true = dark theme)
local FinityWindow = Finity.new(false, "Example Script")

-- Change toggle key (default is Home)
FinityWindow:ChangeToggleKey(Enum.KeyCode.Semicolon)

-- Create categories
local VisualsCategory = FinityWindow:Category("Visuals")
local AimbotCategory = FinityWindow:Category("Aimbot")

-- Visuals Sectors
local VisualsESPSettings = VisualsCategory:Sector("ESP Settings")
local VisualsPlayerESP = VisualsCategory:Sector("Player ESP")
local VisualsItemESP = VisualsCategory:Sector("Item ESP")

-- Aimbot Sectors
local AimbotColors = AimbotCategory:Sector("Aimbot Colors")
local AimbotHotkeys = AimbotCategory:Sector("Aimbot Hotkeys")
local AimbotConfigurations = AimbotCategory:Sector("Aimbot Configurations")

-- Register global keybind
FinityWindow.keybinds:Register(Enum.KeyCode.F, function()
    print("F key pressed globally!")
end, "MyKeybind")

-- ============================================
-- VISUALS - ESP SETTINGS
-- ============================================

-- ESP Enabled Toggle
local espEnabled = VisualsESPSettings:Cheat("checkbox", "ESP Enabled", function(State)
    print("ESP state changed:", State)
    -- Save to config
    FinityWindow.config:Set("espEnabled", State)
end, {
    enabled = FinityWindow.config:Get("espEnabled", false)  -- Load from config
})

-- Render Distance Slider
local renderDistance = VisualsESPSettings:Cheat("slider", "Render Distance", function(Value)
    print("Render distance changed:", Value)
    FinityWindow.config:Set("renderDistance", Value)
end, {
    min = 0,
    max = 1500,
    default = FinityWindow.config:Get("renderDistance", 500),
    suffix = " studs"
})

-- ESP Color Dropdown
local espColor = VisualsESPSettings:Cheat("dropdown", "ESP Color", function(Option)
    print("ESP color changed:", Option)
    FinityWindow.config:Set("espColor", Option)
end, {
    options = {"Red", "White", "Green", "Pink", "Blue"},
    default = FinityWindow.config:Get("espColor", "White")
})

-- ============================================
-- VISUALS - PLAYER ESP
-- ============================================

-- Player ESP Enabled
local playerESPEnabled = VisualsPlayerESP:Cheat("checkbox", "Player ESP Enabled", function(State)
    print("Player ESP state changed:", State)
end)

-- Player Whitelist Textbox
local playerWhitelist = VisualsPlayerESP:Cheat("textbox", "Player To Whitelist", function(Value)
    print("Player whitelist changed:", Value)
end, {
    placeholder = "Player Name"
})

-- Reset Whitelist Button
VisualsPlayerESP:Cheat("button", "Reset Whitelist", function()
    print("Whitelist reset!")
    playerWhitelist:SetValue("")
end)

-- ============================================
-- VISUALS - ITEM ESP
-- ============================================

-- Item ESP Enabled
local itemESPEnabled = VisualsItemESP:Cheat("checkbox", "Item ESP Enabled", function(State)
    print("Item ESP state changed:", State)
end)

-- Multi-Dropdown for Item Selection
local selectedItems = VisualsItemESP:Cheat("multidropdown", "Select Items", function(selected)
    print("Selected items:", selected)
    -- selected is a table: {"Option 1", "Option 2", etc.}
    for _, item in ipairs(selected) do
        print("  -", item)
    end
    FinityWindow.config:Set("selectedItems", selected)
end, {
    options = {"Sword", "Axe", "Bow", "Staff", "Potion", "Gem", "Key"}
})

-- Load saved items
local savedItems = FinityWindow.config:Get("selectedItems", {})
if #savedItems > 0 then
    selectedItems:SetValue(savedItems)
end

-- Item Whitelist Textbox
local itemWhitelist = VisualsItemESP:Cheat("textbox", "Item To Whitelist", function(Value)
    print("Item whitelist changed:", Value)
end, {
    placeholder = "Item Name"
})

-- ============================================
-- AIMBOT - CONFIGURATIONS
-- ============================================

-- Aimbot Enabled
local aimbotEnabled = AimbotConfigurations:Cheat("checkbox", "Aimbot Enabled", function(State)
    print("Aimbot state changed:", State)
    FinityWindow.config:Set("aimbotEnabled", State)
end, {
    enabled = FinityWindow.config:Get("aimbotEnabled", false)
})

-- Aimbot FOV Slider
local aimbotFOV = AimbotConfigurations:Cheat("slider", "Aimbot FOV", function(Value)
    print("Aimbot FOV changed:", Value)
    FinityWindow.config:Set("aimbotFOV", Value)
end, {
    min = 0,
    max = 120,
    default = FinityWindow.config:Get("aimbotFOV", 60),
    suffix = "°"
})

-- Aimbot Mode Dropdown
local aimbotMode = AimbotConfigurations:Cheat("dropdown", "Aimbot Mode", function(Option)
    print("Aimbot mode changed:", Option)
    FinityWindow.config:Set("aimbotMode", Option)
end, {
    options = {"FOV", "Distance", "Visibility"},
    default = FinityWindow.config:Get("aimbotMode", "FOV")
})

-- ============================================
-- AIMBOT - COLORS
-- ============================================

-- BrickColor Input Textbox
local brickColorInput = AimbotColors:Cheat("textbox", "BrickColor Input", function(Value)
    print("BrickColor changed:", Value)
end, {
    placeholder = "BrickColor"
})

-- Reset Color Button
AimbotColors:Cheat("button", "Reset Color", function()
    print("Color reset!")
    brickColorInput:SetValue("")
end)

-- Color Picker Example
local aimbotColor = AimbotColors:Cheat("color", "Aimbot Color", function(color)
    print("Color selected:", color)
    FinityWindow.config:Set("aimbotColor", {color.R, color.G, color.B})
end, {
    color = Color3.fromRGB(255, 0, 0)  -- Default red
})

-- ============================================
-- AIMBOT - HOTKEYS
-- ============================================

-- Quick Toggle Hotkey Textbox
local quickToggleHotkey = AimbotHotkeys:Cheat("textbox", "Quick Toggle Hotkey", function(Value)
    print("Quick toggle hotkey changed:", Value)
end, {
    placeholder = "KeyCode"
})

-- Panic Hotkey Textbox
local panicHotkey = AimbotHotkeys:Cheat("textbox", "Panic Hotkey", function(Value)
    print("Panic hotkey changed:", Value)
end, {
    placeholder = "KeyCode"
})

-- Reset Key Button
AimbotHotkeys:Cheat("button", "Reset Key", function()
    print("Key reset!")
    quickToggleHotkey:SetValue("")
    panicHotkey:SetValue("")
end)

-- Keybind Button Example (displays key and triggers on press)
local teleportKey = AimbotHotkeys:Cheat("keybindbutton", "Teleport Key", function()
    print("Teleport activated!")
end, {
    key = Enum.KeyCode.T,
    text = "Teleport"
})

-- Keybind Input (allows rebinding)
local aimbotKeybind = AimbotHotkeys:Cheat("keybind", "Aimbot Toggle", function(key)
    print("Aimbot toggled with key:", key)
end, {
    bind = Enum.KeyCode.X
})

-- ============================================
-- CREDITS CATEGORY
-- ============================================

local CreditsCategory = FinityWindow:Category("Credits")

local CreditsCreator = CreditsCategory:Sector("Finity Library Creator")
local CreditsSpecialThanks = CreditsCategory:Sector("Special Thanks")
local CreditsTesters = CreditsCategory:Sector("Testers")

-- Note: "Label" type doesn't exist, using TextLabel with textbox style
-- You can use textbox with read-only or button without callback
CreditsCreator:Cheat("textbox", "detourious @ v3rmillion.net", function() end, {
    placeholder = "detourious @ v3rmillion.net"
})
CreditsCreator:Cheat("textbox", "deto#7612 @ discord.gg", function() end, {
    placeholder = "deto#7612 @ discord.gg"
})

CreditsSpecialThanks:Cheat("textbox", "wallythebird - held me hostage", function() end, {
    placeholder = "wallythebird - held me hostage"
})
CreditsSpecialThanks:Cheat("textbox", "Jan - some inspiration from his lib showcase", function() end, {
    placeholder = "Jan - some inspiration from his lib showcase"
})
CreditsSpecialThanks:Cheat("textbox", "& all of you for supporting me <3", function() end, {
    placeholder = "& all of you for supporting me <3"
})

CreditsTesters:Cheat("textbox", "detourious - made the darn thing", function() end, {
    placeholder = "detourious - made the darn thing"
})

-- ============================================
-- ADVANCED FEATURES DEMONSTRATION
-- ============================================

-- Theme Switching Example
-- Create a button to toggle theme
local SettingsCategory = FinityWindow:Category("Settings")
local ThemeSettings = SettingsCategory:Sector("Theme")
local isDarkTheme = false

ThemeSettings:Cheat("button", "Toggle Theme", function()
    isDarkTheme = not isDarkTheme
    FinityWindow:SwitchTheme(isDarkTheme)
    print("Theme switched to:", isDarkTheme and "Dark" or "Light")
end)

-- Config System Example
local ConfigSettings = SettingsCategory:Sector("Config")
ConfigSettings:Cheat("button", "Save All Settings", function()
    FinityWindow.config:Save()
    print("All settings saved!")
end)

ConfigSettings:Cheat("button", "Load All Settings", function()
    FinityWindow.config:Load()
    print("All settings loaded!")
end)

-- ============================================
-- USAGE NOTES
-- ============================================

--[[
    FEATURES USED IN THIS EXAMPLE:
    
    1. Checkbox/Toggle - Enable/disable features
    2. Slider - Numeric values with min/max
    3. Dropdown - Single selection from options
    4. Multi-Dropdown - Multiple selections (shows max 3, then "...")
    5. Textbox - Text input with placeholder
    6. Button - Clickable actions
    7. Keybind - Input binding (click to rebind)
    8. Keybind Button - Display keybind and trigger on press
    9. Color Picker - HSV color selection
    10. Config System - Save/load settings
    11. Global Keybinds - Register keybinds that work globally
    12. Theme Switching - Switch between light/dark themes
    
    MULTI-DROPDOWN FEATURES:
    - Shows up to 3 items: "Item 1, Item 2, Item 3"
    - More than 3: "Item 1, Item 2, Item 3, ..."
    - Selected items have darker background (no checkboxes)
    - Text fades on the right side
    
    CONFIG SYSTEM:
    - Automatically saves when using Set()
    - Uses writefile() if available
    - Falls back to player data storage
    
    THEME SWITCHING:
    - window:SwitchTheme(true) for dark
    - window:SwitchTheme(false) for light
    - Updates all UI elements automatically
]]
