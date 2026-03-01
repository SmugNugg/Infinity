# Infinity UI Library

A powerful and feature-rich Roblox UI library based on Finity, with enhanced functionality including dark theme support, config system, keybind manager, and advanced dropdown features.

## Installation

```lua
local finity = require(path.to.source)
```

## Basic Usage

### Creating a Window

```lua
-- Light theme (default)
local window, data = finity.new(false, "My Project")

-- Dark theme
local window, data = finity.new(true, "My Project")

-- Custom size (thin project)
local window, data = finity.new(true, "My Project", UDim2.new(0, 600, 0, 400))
```

### Creating Categories and Sectors

```lua
local mainCategory = window:Category("Main")
local combatSector = mainCategory:Sector("Combat")
local movementSector = mainCategory:Sector("Movement")
```

## UI Elements

### Checkbox / Toggle

```lua
local toggle = sector:Cheat("checkbox", "Enable ESP", function(value)
    print("ESP:", value)
end, {
    enabled = false  -- Optional: default state
})

-- Get/set value
local currentValue = toggle.value
toggle:SetValue(true)
```

### Button

```lua
local button = sector:Cheat("button", "Click Me", function()
    print("Button clicked!")
end, {
    text = "Click Me"  -- Optional: button text
})

-- Programmatically trigger
button:Fire()
```

### Textbox

```lua
local textbox = sector:Cheat("textbox", "Player Name", function(value)
    print("Player name:", value)
end, {
    placeholder = "Enter name..."  -- Optional: placeholder text
})

-- Set value
textbox:SetValue("Player123")
```

### Slider

```lua
local slider = sector:Cheat("slider", "Walk Speed", function(value)
    print("Walk speed:", value)
end, {
    min = 16,
    max = 100,
    default = 50,
    suffix = " studs",  -- Optional: suffix (e.g., " studs", "%")
    precise = false  -- Optional: if true, allows decimal values
})

-- Set value
slider:SetValue(75)
```

### Dropdown

```lua
local dropdown = sector:Cheat("dropdown", "Select Weapon", function(value)
    print("Selected:", value)
end, {
    options = {"Sword", "Axe", "Bow", "Staff"},
    default = "Sword"  -- Optional: default selection
})

-- Methods
dropdown:AddOption("Dagger")
dropdown:RemoveOption("Bow")
dropdown:SetValue("Axe")
local options = dropdown:GetOption()
dropdown:ClearOption()
```

### Multi-Dropdown (Multiple Selection)

```lua
local multiDropdown = sector:Cheat("multidropdown", "Select Items", function(selected)
    print("Selected items:", selected)  -- selected is a table
end, {
    options = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5"}
})

-- Features:
-- - Shows up to 3 items: "Item 1, Item 2, Item 3"
-- - More than 3: "Item 1, Item 2, Item 3, ..."
-- - Selected items have darker background (no checkboxes)
-- - Text fades on the right side for long selections

-- Set value (array of selected items)
multiDropdown:SetValue({"Item 1", "Item 3"})
```

### Keybind (Input Binding)

```lua
local keybind = sector:Cheat("keybind", "Toggle Menu", function(key)
    print("Key pressed:", key)
end, {
    bind = Enum.KeyCode.F  -- Optional: default keybind
})

-- Set keybind programmatically
keybind:SetValue(Enum.KeyCode.G)
```

### Keybind Button (Display & Trigger)

```lua
local keybindBtn = sector:Cheat("keybindbutton", "Teleport", function(key)
    print("Teleporting...")
end, {
    key = Enum.KeyCode.T,
    text = "Teleport"  -- Optional: button text
})

-- Methods
keybindBtn:SetKey(Enum.KeyCode.R)
keybindBtn:SetText("Quick Teleport")
```

### Color Picker

```lua
local colorPicker = sector:Cheat("color", "ESP Color", function(color)
    print("Color:", color)
end, {
    color = Color3.fromRGB(255, 0, 0)  -- Optional: default color
})

-- Usage:
-- - Left click on HSV bar to change hue
-- - Right click on HSV bar to change brightness
```

## Advanced Features

### Theme Switching

Switch between light and dark themes dynamically:

```lua
-- Switch to dark theme
window:SwitchTheme(true)

-- Switch to light theme
window:SwitchTheme(false)
```

### Config System

Save and load configuration data:

```lua
-- Save a value
window.config:Set("walkSpeed", 50)
window.config:Set("playerName", "Player123")

-- Load a value (with default)
local walkSpeed = window.config:Get("walkSpeed", 16)
local playerName = window.config:Get("playerName", "Unknown")

-- Save all config data
window.config:Save()

-- Load all config data
window.config:Load()
```

**Note:** The config system automatically saves when using `Set()`. It uses `writefile()` if available, otherwise falls back to storing in player data.

### Global Keybind Manager

Register global keybinds that work throughout your script:

```lua
-- Register a keybind
local bindId = window.keybinds:Register(Enum.KeyCode.F, function(input)
    print("F key pressed globally!")
end, "MyGlobalBind")

-- Unregister a keybind
window.keybinds:Unregister("MyGlobalBind")

-- Clear all keybinds
window.keybinds:Clear()
```

### Smooth Dragging

The UI now features smooth dragging:
- Click and hold on the topbar (first 30 pixels) to drag
- Dragging is handled smoothly with UserInputService
- No lag or stuttering

### Window Title

Change the window title:

```lua
finity.settitle("My Custom Title")
```

### Change Toggle Key

Change the key used to toggle the UI visibility:

```lua
window:ChangeToggleKey(Enum.KeyCode.Insert)
```

### Background Image

Set a custom background image:

```lua
window:ChangeBackgroundImage("rbxassetid://123456789", 0.8)  -- Image ID, Transparency
```

## Complete Example

```lua
local finity = require(path.to.source)

-- Create window with dark theme
local window, data = finity.new(true, "My Script")

-- Create category
local main = window:Category("Main")
local combat = main:Sector("Combat")

-- Create UI elements
local espToggle = combat:Cheat("checkbox", "ESP", function(enabled)
    -- ESP logic here
end, { enabled = false })

local walkSpeed = combat:Cheat("slider", "Walk Speed", function(value)
    -- Set walk speed
end, {
    min = 16,
    max = 200,
    default = 50,
    suffix = " studs"
})

local weapon = combat:Cheat("dropdown", "Weapon", function(selected)
    -- Weapon selection logic
end, {
    options = {"Sword", "Axe", "Bow"},
    default = "Sword"
})

local items = combat:Cheat("multidropdown", "Items", function(selected)
    -- Multiple items selected
    for _, item in ipairs(selected) do
        print("Selected:", item)
    end
end, {
    options = {"Item 1", "Item 2", "Item 3", "Item 4"}
})

local teleportKey = combat:Cheat("keybindbutton", "Teleport", function()
    -- Teleport logic
end, {
    key = Enum.KeyCode.T,
    text = "Teleport"
})

-- Save config
window.config:Set("espEnabled", espToggle.value)
window.config:Set("walkSpeed", walkSpeed.value)

-- Register global keybind
window.keybinds:Register(Enum.KeyCode.F, function()
    print("Global F key pressed!")
end, "GlobalFKey")

-- Switch theme
window:SwitchTheme(false)  -- Switch to light theme
```

## Features Summary

✅ **Dark Theme Support** - Full dark theme with proper color application  
✅ **Multi-Dropdown** - Select multiple items with visual feedback  
✅ **Config System** - Built-in save/load functionality  
✅ **Global Keybind Manager** - Register keybinds that work globally  
✅ **Theme Switching** - Dynamically switch between light/dark themes  
✅ **Smooth Dragging** - Enhanced dragging with UserInputService  
✅ **Text Fade Effect** - Text fades on the right side in multi-dropdown  
✅ **Keybind Button** - Display keybinds as buttons with auto-trigger  
✅ **No Outlines** - Clean look without borders on selected items  

## Notes

- The searchable dropdown feature has been removed
- Grouped/Combo dropdown feature has been removed
- Multi-dropdown shows maximum 3 items, then displays "..."
- Selected items in multi-dropdown use darker background instead of checkboxes
- All dropdown backgrounds have improved visibility (0.2 transparency)

## Version

Current Version: Enhanced Finity UI Library
