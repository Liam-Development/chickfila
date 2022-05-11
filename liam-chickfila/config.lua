Config = {}

Config.EnablePlayerManagement     = true
Config.JobName = "chic"
Config.Locale = 'en'

Config.bttarget = false
Config.qtarget = true

-- Blips -- 
Config.EnableBlip = true -- Enable Or Disable The Blip
Config.BlipName = "ChickFilA" -- Name Of The Blip
Config.BlipScale = 0.5 -- Blip Size
Config.BlipSprite = 89 -- Blip ID
Config.BlipColour = 5 -- Blip Color

-- Cooking -- 
Config.CookingTime = 20000
Config.FriesAmount = 1
Config.NuggetsAmount = 1
Config.ComboMealAmount = 1

-- Zones --
Config.Zones = {
  ChickActions = {
    Pos   = { x = -1035.72, y = -1371.03, z = 5.7 },
    Size  = { x = 0.5, y = 0.5, z = 0.25 },
    Color = { r = 255, g = 0, b = 0 },
    Type  = 2,
  },

  CookFries = {
    Pos   = { x = -1030.6, y = -1381.39, z = 5.52 },
    Size  = { x = 0.5, y = 0.5, z = 0.25 },
    Color = { r = 255, g = 0, b = 0 },
    Type  = 2,
  },

  CookOthers = {
    Pos   = { x = -1026.97, y = -1373.73, z = 5.52 },
    Size  = { x = 0.5, y = 0.5, z = 0.25 },
    Color = { r = 255, g = 0, b = 0 },
    Type  = 2,
  },
}