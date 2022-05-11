local PlayerData              = {}
local GUI                     = {}
ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function OpenChickActionsMenu()

  local elements = {
    {label = _U('boss_actions'), value = 'boss_actions'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'chick_actions',
    {
      title    = _U('chickfila'),
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', Config.JobName, function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'chick_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

RegisterNetEvent('liam_chickfila:animation')
AddEventHandler('liam_chickfila:animation', function()
  local ped = GetPlayerPed(-1)
  FreezeEntityPosition(ped,true)
  TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
  Citizen.Wait(Config.CookingTime) -- Time progress , in ms, 1 second = 1000 ms , the value is 10000 so , its 10 seconds
  FreezeEntityPosition(ped,false)
  ClearPedTasksImmediately(PlayerPedId()) -- Function to stop the animation
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    PlayerData["job"] = response
end)

if Config.EnableBlip then
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(Config.Zones.ChickActions.Pos.x, Config.Zones.ChickActions.Pos.y, Config.Zones.ChickActions.Pos.z)
  SetBlipSprite (blip, Config.BlipSprite)
  SetBlipScale  (blip, Config.BlipScale)
  SetBlipColour (blip, Config.BlipColour)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(Config.BlipName)
  EndTextCommandSetBlipName(blip)
end)
end

Citizen.CreateThread(function()
  if Config.bttarget == true then
  exports['bt-target']:AddBoxZone("CookFries", vector3(Config.Zones.CookFries.Pos.x, Config.Zones.CookFries.Pos.y, Config.Zones.CookFries.Pos.z), 2, 2, {
    name="CookFries",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:cookfries",
          icon = "fas fa-sign-in-alt",
          label = "Cook Fries",
      },          
    },
    job = {Config.JobName},
    distance = 1.0
  })
elseif Config.qtarget == true then
  exports.qtarget:AddBoxZone("CookFries", vector3(Config.Zones.CookFries.Pos.x, Config.Zones.CookFries.Pos.y, Config.Zones.CookFries.Pos.z), 2, 2, {
    name="CookFries",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:cookfries",
          icon = "fas fa-sign-in-alt",
          label = "Cook Fries",
        },
      },
      job = {Config.JobName},
      distance = 1.0
  })
end
end)

Citizen.CreateThread(function()
  if Config.bttarget == true then
  exports['bt-target']:AddBoxZone("CookComboOrBurger", vector3(Config.Zones.CookOthers.Pos.x, Config.Zones.CookOthers.Pos.y, Config.Zones.CookOthers.Pos.z), 2, 2, {
    name="CookComboOrBurger",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:cookothers",
          icon = "fas fa-sign-in-alt",
          label = "Cook Other Foods",
      },          
    },
    job = {Config.JobName},
    distance = 1.0
  })
elseif Config.qtarget == true then
  exports.qtarget:AddBoxZone("CookComboOrBurger", vector3(Config.Zones.CookOthers.Pos.x, Config.Zones.CookOthers.Pos.y, Config.Zones.CookOthers.Pos.z), 2, 2, {
    name="CookComboOrBurger",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:cookothers",
          icon = "fas fa-sign-in-alt",
          label = "Cook Other Foods",
        },
      },
      job = {Config.JobName},
      distance = 1.0
  })
end
end)

Citizen.CreateThread(function()
  if Config.bttarget == true then
  exports['bt-target']:AddBoxZone("ActionsMenu", vector3(Config.Zones.ChickActions.Pos.x, Config.Zones.ChickActions.Pos.y, Config.Zones.ChickActions.Pos.z), 2, 2, {
    name="ActionsMenu",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:chick_actions_menu",
          icon = "fas fa-sign-in-alt",
          label = "Boss Menu",
      },          
    },
    job = {Config.JobName},
    distance = 1.0
  })
elseif Config.qtarget == true then
  exports.qtarget:AddBoxZone("ActionsMenu", vector3(Config.Zones.ChickActions.Pos.x, Config.Zones.ChickActions.Pos.y, Config.Zones.ChickActions.Pos.z), 2, 2, {
    name="ActionsMenu",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:chick_actions_menu",
          icon = "fas fa-sign-in-alt",
          label = "Boss Menu",
        },
      },
      job = {Config.JobName},
      distance = 1.0
  })
end
end)

RegisterNetEvent('liam_chickfila:chick_actions_menu')
AddEventHandler('liam_chickfila:chick_actions_menu', function(job)
  if Config.EnablePlayerManagement and PlayerData["job"].name == Config.JobName and PlayerData.job.grade_name == 'boss' then
    OpenChickActionsMenu()
  else
    ESX.ShowNotification("You Dont Have Permission To Access The Boss Menu")
  end
end)

RegisterNetEvent('liam_chickfila:harvestfries')
AddEventHandler('liam_chickfila:harvestfries', function(job)
  TriggerServerEvent('liam_chickfila:startHarvest')
  exports.rprogress:Custom({
    Duration = Config.CookingTime,
    Label = "You're Cooking Some Fries...",
    DisableControls = {
        Mouse = false,
        Player = true,
        Vehicle = true
    },
})
end)

RegisterNetEvent('liam_chickfila:harvestothers')
AddEventHandler('liam_chickfila:harvestothers', function(job)
  TriggerServerEvent('liam_chickfila:startHarvest3')
  exports.rprogress:Custom({
    Duration = Config.CookingTime,
    Label = "You're Cooking Some Chicken Nuggets",
    DisableControls = {
        Mouse = false,
        Player = true,
        Vehicle = true
    },
})
end)

RegisterNetEvent('liam_chickfila:harvestothers1')
AddEventHandler('liam_chickfila:harvestothers1', function(job)
  TriggerServerEvent('liam_chickfila:startHarvest2')
  exports.rprogress:Custom({
    Duration = Config.CookingTime,
    Label = "You're Cooking a Combo Meal",
    DisableControls = {
        Mouse = false,
        Player = true,
        Vehicle = true
    },
})
end)

RegisterNetEvent('liam_chickfila:cookfries',function()
  if PlayerData["job"].name == 'chic' then
      TriggerEvent('nh-context:sendMenu', {
          {
              id = 1,
              header = "Cook Fries",
              txt = "Cook some delicious fries",
              params = {
                  event = "liam_chickfila:harvestfries",
              }
          },
      })
    else
      ESX.ShowNotification("You Dont Have Permission To Cook Here")
  end
end)

RegisterNetEvent('liam_chickfila:cookothers',function()
  if PlayerData["job"].name == 'chic' then
      TriggerEvent('nh-context:sendMenu', {
          {
              id = 2,
              header = "Cook Chicken Nuggets",
              txt = "Cook some delicious chicken nuggets",
              params = {
                  event = "liam_chickfila:harvestothers",
              }
          },
          {
            id = 3,
            header = "Cook Combo Meal",
            txt = "Cook a delicious combo meal",
            params = {
                event = "liam_chickfila:harvestothers1",
            }
        },
      })
    else
      ESX.ShowNotification("You Dont Have Permission To Cook Here")
  end
end)