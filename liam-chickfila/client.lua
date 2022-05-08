local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local TargetCoords            = nil
local Blips                   = {}
local NPCOnJob                = false
local NPCTargetTowable         = nil
local NPCTargetTowableZone     = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false

ESX                           = nil
GUI.Time                      = 0

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
        TriggerEvent('esx_society:openBossMenu', 'chic', function(data, menu)
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

function OpenChickCookMenu()

    local elements = {
      {label = _U('fries'), value = 'CookFries'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'chick_harvest',
      {
        title    = _U('harvest'),
        elements = elements
      },
      function(data, menu)
        if data.current.value == 'CookFries' then
          menu.close()
          TriggerServerEvent('liam_chickfila:startHarvest')
          exports.rprogress:Custom({
            Duration = Config.CookingTime,
            Label = "You're Cooking Fries...",
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            },
        onComplete = function()
          TriggerEvent('chic:fried')
        end
        })
      end
    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'chick_harvest_menu2'
      CurrentActionMsg  = _U('harvest_menu')
      CurrentActionData = {}
    end
  )
end
-- Repas 2

function OpenChickCookMenu2()

    local elements = {
      {label = _U('nuggets'), value = 'CookOthers'},
      {label = _U('combomeal'), value = 'cookcombomeal'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'chick_harvest',
      {
        title    = _U('harvest'),
        elements = elements
      },
      function(data, menu)

        if data.current.value == 'CookOthers' then
          menu.close()
          TriggerServerEvent('liam_chickfila:startHarvest2')
          exports.rprogress:Custom({
            Duration = Config.CookingTime,
            Label = "You're Cooking Some Nuggets...",
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            },
        onComplete = function()
          TriggerEvent('chic:getitemburger')
        end
        })
        end

        if data.current.value == 'cookcombomeal' then
          menu.close()
          TriggerServerEvent('liam_chickfila:startHarvest3')
          exports.rprogress:Custom({
            Duration = Config.CookingTime,
            Label = "You're Cooking a Combo Meal...",
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            },
        onComplete = function()
          TriggerEvent('chic:pizza')
        end
        })
        end

      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'chick_harvest_menu2'
        CurrentActionData = {}
      end
    )
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('liam_chickfila:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].name, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('liam_chickfila:getStockItem', itemName, count)
              TriggerEvent('chic:removeallanim')
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

ESX.TriggerServerCallback('liam_chickfila:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('liam_chickfila:putStockItems', itemName, count)
              TriggerEvent('chic:removeallanim')
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function KeyboardInput1(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

RegisterNetEvent('liam_chickfila:menubills')
AddEventHandler('liam_chickfila:menubills', function()
	OuvrirMenuFacture()
end)
function OuvrirMenuFacture() -- A FINIR LES FACTURE 
	local nombre = KeyboardInput1("Chic", "Facture :", "", 8)

		if nombre ~= nil then
			nombre = tonumber(nombre)
			
			if type(nombre) == 'number' then
				local amount = tonumber(nombre)
				local player, distance = ESX.Game.GetClosestPlayer()
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					TriggerServerEvent('PersonneProximite')
				else

				local playerPed        = GetPlayerPed(-1)
			
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
				Citizen.Wait(8000)
				ClearPedTasks(playerPed)
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_chic', 'chic', amount)
				ESX.ShowNotification('Facture envoyer')
			end
		end
	end
end


RegisterNetEvent('chic:removeallanim')
AddEventHandler('chic:removeallanim', function()
  ExecuteCommand("e c")
end)

-------------------------------- FRIED --------------------------------

RegisterNetEvent('chic:removeitemfried')
AddEventHandler('chic:removeitemfried', function()
    DetachEntity(fried, 1, 1)
    DeleteObject(fried)
    DetachEntity(fried2, 1, 1)
    DeleteObject(fried2)
    DetachEntity(fried3, 1, 1)
    DeleteObject(fried3)
    DetachEntity(fried4, 1, 1)
    DeleteObject(fried4)
    maitem = false
    ClearPedSecondaryTask(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('chic:fried')
AddEventHandler('chic:fried', function()
    local speed = math.random(1)
    local speed2 = math.random(1)
    local speed3 = math.random(1)
    local speed4 = math.random(1)
    if speed == 1 then
      bagModel = 'prop_food_bs_chips'
        fried = CreateObject(GetHashKey(bagModel), -1030.44, -1382.14, 5.35,  true,  true, true)
        Citizen.Wait(1000)
    end
    if speed2 == 1 then
      bagModel = 'prop_food_bs_chips'
        fried2 = CreateObject(GetHashKey(bagModel), -1030.41, -1382.36, 5.35,  true,  true, true)
        Citizen.Wait(3000)
    end
    if speed3 == 1 then
      bagModel = 'prop_food_bs_chips'
        fried3 = CreateObject(GetHashKey(bagModel), -1030.84, -1382.08, 5.35,  true,  true, true)
        Citizen.Wait(5000)
    end
    if speed4 == 1 then
      bagModel = 'prop_food_bs_chips'
        fried4 = CreateObject(GetHashKey(bagModel), -1030.9, -1382.21, 5.35,  true,  true, true)
        Citizen.Wait(8000)
    end
end)

-------------------------------- PIZZA --------------------------------

RegisterNetEvent('chic:removeitempizza')
AddEventHandler('chic:removeitempizza', function()
    DetachEntity(pizza, 1, 1)
    DeleteObject(pizza)
    DetachEntity(pizza2, 1, 1)
    DeleteObject(pizza2)
    maitem = false
    ClearPedSecondaryTask(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('chic:pizza')
AddEventHandler('chic:pizza', function()
    local food = math.random(1)
    local food2 = math.random(1)
    if food == 1 then
      bagModel = 'prop_food_bs_burg3'
        pizza = CreateObject(GetHashKey(bagModel), -1026.58, -1374.35, 5.52,  true,  true, true)
        Citizen.Wait(10000)
    end
    if food2 == 1 then
      bagModel = 'prop_food_bs_burg3'
        pizza2 = CreateObject(GetHashKey(bagModel), -1026.29, -1374.41, 5.52,  true,  true, true)
        Citizen.Wait(5000)
    end
end)

-------------------------------- BURGER --------------------------------

RegisterNetEvent('chic:removeitemburger')
AddEventHandler('chic:removeitemburger', function()
    DetachEntity(burger, 1, 1)
    DeleteObject(burger)
    DetachEntity(burger2, 1, 1)
    DeleteObject(burger2)
    DetachEntity(burger3, 1, 1)
    DeleteObject(burger3)
    DetachEntity(burger4, 1, 1)
    DeleteObject(burger4)
    maitem = false
    ClearPedSecondaryTask(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('chic:getitemburger')
AddEventHandler('chic:getitemburger', function()
    local chic = math.random(1)
    local chic2 = math.random(1)
    local chic3 = math.random(1)
    local chic4 = math.random(1)
    if chic == 1 then
      bagModel = 'prop_food_cb_nugets'
        burger = CreateObject(GetHashKey(bagModel), -1026.22, -1373.35, 5.52,  true,  true, true)
        Citizen.Wait(1000)
    end
    if chic2 == 1 then
      bagModel = 'prop_food_cb_nugets'
        burger2 = CreateObject(GetHashKey(bagModel), -1025.92, -1373.4, 5.52,  true,  true, true)
        Citizen.Wait(3000)
    end
    if chic3 == 1 then
      bagModel = 'prop_food_cb_nugets'
        burger3 = CreateObject(GetHashKey(bagModel), -1026.49, -1373.67, 5.52,  true,  true, true)
        Citizen.Wait(5000)
    end
    if chic4 == 1 then
      bagModel = 'prop_food_cb_nugets'
        burger4 = CreateObject(GetHashKey(bagModel), -1026.06, -1373.77, 5.52,  true,  true, true)
        Citizen.Wait(8000)
    end
end)

RegisterNetEvent('resto:cuir')
AddEventHandler('resto:cuir', function()
  local ped = GetPlayerPed(-1)
  FreezeEntityPosition(ped,true)
  TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
  Citizen.Wait(Config.CookingTime) -- Time progress , in ms, 1 second = 1000 ms , the value is 10000 so , its 10 seconds
  FreezeEntityPosition(ped,false)
  ClearPedTasksImmediately(PlayerPedId()) -- Function to stop the animation
end)

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('liam_chickfila:hasEnteredMarker', function(zone)

  if zone == 'CookFries' then
    CurrentAction     = 'chick_harvest_menu1'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end

  if zone == 'CookOthers' then
    CurrentAction     = 'chick_harvest_menu2'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end

  if zone == 'ChickActions' then
    CurrentAction     = 'chick_actions_menu'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end
end)

AddEventHandler('liam_chickfila:hasExitedMarker', function(zone)

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()
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
          event = "liam_chickfila:openharvestmenu1",
          icon = "fas fa-sign-in-alt",
          label = "Cook Fries",
      },          
    },
    job = {"chic"},
    distance = 1.0
  })
elseif Config.qtarget == true then
  exports.qtarget:AddBoxZone("CookFries", vector3(Config.Zones.CookFries.Pos.x, Config.Zones.CookFries.Pos.y, Config.Zones.CookFries.Pos.z), 2, 2, {
    name="CookFries",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:openharvestmenu1",
          icon = "fas fa-sign-in-alt",
          label = "Cook Fries",
        },
      },
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
          event = "liam_chickfila:openharvestmenu2",
          icon = "fas fa-sign-in-alt",
          label = "Cook Other Foods",
      },          
    },
    job = {"chic"},
    distance = 1.0
  })
elseif Config.qtarget == true then
  exports.qtarget:AddBoxZone("CookComboOrBurger", vector3(Config.Zones.CookOthers.Pos.x, Config.Zones.CookOthers.Pos.y, Config.Zones.CookOthers.Pos.z), 2, 2, {
    name="CookFries",
    heading=0,
    }, {
      options = {
        {
          event = "liam_chickfila:openharvestmenu2",
          icon = "fas fa-sign-in-alt",
          label = "Cook Other Foods",
        },
      },
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
    job = {"chic"},
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
      distance = 1.0
  })
end
end)

RegisterNetEvent('liam_chickfila:openharvestmenu1')
AddEventHandler('liam_chickfila:openharvestmenu1', function(job)
  if PlayerData.job == "chic" then
    OpenChickCookMenu()
  else
    ESX.ShowNotification("You Dont Have Permission To Cook Here")
  end
end)

RegisterNetEvent('liam_chickfila:openharvestmenu2')
AddEventHandler('liam_chickfila:openharvestmenu2', function(job)
  if PlayerData.job == "chic" then
    OpenChickCookMenu2()
  else
    ESX.ShowNotification("You Dont Have Permission To Cook Here")
  end
end)

RegisterNetEvent('liam_chickfila:chick_actions_menu')
AddEventHandler('liam_chickfila:chick_actions_menu', function(job)
  if Config.EnablePlayerManagement and PlayerData.job == "chic" and PlayerData.job.grade_name == "boss" then
    OpenChickActionsMenu()
  else
    ESX.ShowNotification("You Dont Have Permission To Access The Boss Menu")
  end
end)