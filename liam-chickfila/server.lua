ESX                = nil
local PlayersHarvesting = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'chic', Config.MaxInService)
end
-- Repas 1

local function Harvest(source, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    
            TriggerClientEvent('resto:cuir' , source)
            Citizen.Wait(Config.CookingTime)
            xPlayer.addInventoryItem("chicfries", Config.FriesAmount)
  end

RegisterServerEvent('liam_chickfila:startHarvest')
AddEventHandler('liam_chickfila:startHarvest', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
    
    PlayersHarvesting[_source]=true
    TriggerClientEvent('resto:cuir' , source)
    Harvest(_source,zone)
end)

-- Repas 2

local function Harvest2(source, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    
            TriggerClientEvent('resto:cuir' , source)
            Citizen.Wait(Config.CookingTime)
            xPlayer.addInventoryItem('chicnuggets', Config.NuggetsAmount)
  end

RegisterServerEvent('liam_chickfila:startHarvest2')
AddEventHandler('liam_chickfila:startHarvest2', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
    
    PlayersHarvesting[_source]=true
    TriggerClientEvent('resto:cuir' , source)
    Harvest2(_source,zone)
end)

local function Harvest3(source, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('resto:cuir' , source)
    Citizen.Wait(Config.CookingTime)
    xPlayer.addInventoryItem('chiccombo', Config.ComboMealAmount)
end

RegisterServerEvent('liam_chickfila:startHarvest3')
AddEventHandler('liam_chickfila:startHarvest3', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
    
    PlayersHarvesting[_source]=true
    TriggerClientEvent('resto:cuir' , source)
    Harvest2(_source,zone)
end)

RegisterServerEvent('liam_chickfila:stopHarvest')
AddEventHandler('liam_chickfila:stopHarvest', function()
  local _source = source
  PlayersHarvesting[_source] = false
end)