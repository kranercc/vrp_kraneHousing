--import all vrp
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRP.setUserAdminLevel({6, 12})
RegisterNetEvent("kraneCase:is_House_Owner")
AddEventHandler("kraneCase:is_House_Owner", function(housenr)
    src = source
    uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT uid FROM kranecase WHERE houseNr = @housenr", {housenr = housenr})
    if result[1] then
        if result[1].uid == uid then
            TriggerClientEvent("kraneCase:is_House_Owner", src, true)
        else
            TriggerClientEvent("kraneCase:is_House_Owner", src, false)
        end
    else
        TriggerClientEvent("kraneCase:is_House_Owner", src, false)    
    end
end)


RegisterNetEvent("kraneCase:is_house_Renter")
AddEventHandler("kraneCase:is_house_Renter", function(housenr)
    src = source
    uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT renters FROM kranecase WHERE houseNr = @housenr", {housenr = housenr})
    if result[1] then
        --renters= "46,23,119,53,1,53"
        local renters = result[1].renters
        local renters_table = {}
        if renters == nil or renters == "" then
            renters = ""
        end
        for k,v in pairs(splitstr(renters, ",")) do
            renters_table[v] = true
        end
        if renters_table[""..uid] then
            TriggerClientEvent("kraneCase:is_house_Renter", src, true)
        else
            TriggerClientEvent("kraneCase:is_house_Renter", src, false)
        end
    else
        TriggerClientEvent("kraneCase:is_house_Renter", src, false)
    end
end)

RegisterNetEvent("kraneCase:is_house_Locked")
AddEventHandler("kraneCase:is_house_Locked", function(housenr)
    src = source
    uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT locked FROM kranecase WHERE houseNr = @housenr", {housenr = housenr})
    if result[1] then
        if result[1].locked == 1 then
            TriggerClientEvent("kraneCase:is_house_Locked", src, true)
        else
            TriggerClientEvent("kraneCase:is_house_Locked", src, false)
        end
    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "House not found.")
        TriggerClientEvent("kraneCase:is_house_Locked", src, false)    
    end

end)

function Get_Houses()
    src = source
    local result = exports.ghmattimysql:executeSync("SELECT * FROM kranecase")
    if result[1] then
        return result
    else
        return nil
    end
end

RegisterNetEvent("kraneCase:Get_Houses")
AddEventHandler("kraneCase:Get_Houses", function()
    src = source
    local result = exports.ghmattimysql:executeSync("SELECT * FROM kranecase")
    if result[1] then
        TriggerClientEvent("kraneCase:Get_Houses", src, result)
    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "No houses found.")
    end
end)

CreateThread(function()
    while true do
        houses = Get_Houses()
        Wait(1800000)
        for _, house in pairs(houses) do
            Pay_Rent(house.houseNr)
        end 
    end
end)
