-- INSERT INTO `kranecase`(`uid`, `houseNr`, `safe`, `wardrobe`, `locked`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `teleport_x`, `teleport_y`, `teleport_z`, `safe_x`, `safe_y`, `safe_z`) VALUES (2, 1, "", "", 0, 1978, 1619, 73, 1984, 1616, 73, 1978, 1619, 75, 1976, 1611, 73)
utility = module(Classes_Config.resource_name, "classes/c_kraneUtility")
kranePed = module(Classes_Config.resource_name, "classes/c_kranePED")
kraneVeh = module(Classes_Config.resource_name, "classes/c_kraneVehicle")
kraneObject = module(Classes_Config.resource_name, "classes/c_kraneObject")

RegisterNetEvent("kraneCase:Animatie")

ped = kranePed.new()
ped.ped = PlayerPedId()

RegisterNetEvent("kraneCase:Get_Houses")
AddEventHandler("kraneCase:Get_Houses", function(data)
    houses = data
    for _, house in pairs(houses) do
        house.x = house.x + 0.0
        house.y = house.y + 0.0
        house.z = house.z + 0.0
        house.exit_x = house.exit_x + 0.0
        house.exit_y = house.exit_y + 0.0
        house.exit_z = house.exit_z + 0.0
        house.teleport_x = house.teleport_x + 0.0
        house.teleport_y = house.teleport_y + 0.0
        house.teleport_z = house.teleport_z + 0.0
        house.safe_x = house.safe_x + 0.0
        house.safe_y = house.safe_y + 0.0
        house.safe_z = house.safe_z + 0.0
        house.wardrobe_x = house.wardrobe_x + 0.0
        house.wardrobe_y = house.wardrobe_y + 0.0
        house.wardrobe_z = house.wardrobe_z + 0.0

        house.houseMenu_x = house.houseMenu_x + 0.0
        house.houseMenu_y = house.houseMenu_y + 0.0
        house.houseMenu_z = house.houseMenu_z + 0.0
        
        if house.displayBlip == 1 then
            house.blip = AddBlipForCoord(house.x, house.y, house.z)
            SetBlipSprite(house.blip, 473)
            SetBlipDisplay(house.blip, 4)
            SetBlipScale(house.blip, 0.8)
            SetBlipColour(house.blip, 36)
            SetBlipAsShortRange(house.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("House " .. house.houseNr .. "Owner: " .. house.uid)
            EndTextCommandSetBlipName(house.blip)
        end
    end
    CreateThread(function()
        while true do
            Wait(0)
            Draw_Houses()
        end
    end)
end)
TriggerServerEvent("kraneCase:Get_Houses")

function Draw_Houses()


    x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    for _, house in pairs(houses) do
        local entrace_distance = Vdist(x,y,z, house.x,house.y,house.z) 
        if entrace_distance < 15.0 then
            utility.Generic_Marker(house.x,house.y,house.z, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) --rgb optional
            utility.DrawText3D(house.x,house.y,house.z+2.0, "Owner: ~w~" .. house.uid, 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 
            utility.DrawText3D(house.x,house.y,house.z+2.0-0.1, "House Nr: ~w~" .. house.houseNr, 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 
            utility.DrawText3D(house.x,house.y,house.z+2.0-0.2, "Locked: ~w~" .. tostring(house.locked), 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 
            
            if entrace_distance < 5.0 then
                if IsControlJustPressed(1, 51) then
                    decide_entrance(house)
                end
            end
        end

        local safe_distance = Vdist(x,y,z, house.safe_x, house.safe_y, house.safe_z)
        if safe_distance < 5.0 then
            utility.Generic_Marker(house.safe_x, house.safe_y, house.safe_z, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) --rgb optional
            utility.DrawText3D(house.safe_x, house.safe_y, house.safe_z+1.5, "Seif", 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 

            if safe_distance < 2.0 then
                if IsControlJustPressed(1, 51) then
                    if is_House_Owner(house.houseNr) then
                        Listen_Safe()
                    end
                end
                
            end
        end


        local exit_distance = Vdist(x,y,z, house.exit_x, house.exit_y, house.exit_z)
        if exit_distance < 5.0 then
            utility.Generic_Marker(house.exit_x, house.exit_y, house.exit_z, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) --rgb optional
            utility.DrawText3D(house.exit_x, house.exit_y, house.exit_z+1.5, "~r~Exit", 3.0) 

            if exit_distance < 2.0 then
                if IsControlJustPressed(1, 51) then
                    Listen_Enter_House(house.x, house.y, house.z)
                end
            end
        end

        local wardrobe_distance = Vdist(x,y,z, house.wardrobe_x, house.wardrobe_y, house.wardrobe_z)
        if wardrobe_distance < 5.0 then
            utility.Generic_Marker(house.wardrobe_x, house.wardrobe_y, house.wardrobe_z, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) --rgb optional
            utility.DrawText3D(house.wardrobe_x, house.wardrobe_y, house.wardrobe_z+1.5, "Wardrobe", 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 

            if wardrobe_distance < 2.0 then
                if IsControlJustPressed(1, 51) then
                    if is_House_Owner(house.houseNr) then
                        Listen_Wardrobe()
                    end
                end
            end
        end

        local houseMenu_distance = Vdist(x,y,z, house.houseMenu_x, house.houseMenu_y, house.houseMenu_z)
        if houseMenu_distance < 5.0 then
            utility.Generic_Marker(house.houseMenu_x, house.houseMenu_y, house.houseMenu_z, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) --rgb optional
            utility.DrawText3D(house.houseMenu_x, house.houseMenu_y, house.houseMenu_z+1.5, "Menu", 3.0, utility.rgb_rainbow.r, utility.rgb_rainbow.g, utility.rgb_rainbow.b) 

            if houseMenu_distance < 2.0 then
                if IsControlJustPressed(1, 51) then
                    if is_House_Owner(house.houseNr) then
                        Listen_House_Menu()
                    end
                end
            end
        end
    end
end

CreateThread(function()
    Wait(5000)
    TriggerServerEvent("kraneCase:Get_Houses")

end)



function is_House_Owner(houseNr)
    is_house_owner = nil
    RegisterNetEvent("kraneCase:is_House_Owner")
    AddEventHandler("kraneCase:is_House_Owner", function(isIt)
        is_house_owner = isIt
    end)
    TriggerServerEvent("kraneCase:is_House_Owner", houseNr)
    while is_house_owner == nil do Wait(0) end
    return is_house_owner
end

function is_House_Renter(houseNr)
    is_house_Renter = nil
    RegisterNetEvent("kraneCase:is_house_Renter")
    AddEventHandler("kraneCase:is_house_Renter", function(isIt)
        is_house_Renter = isIt
    end)
    TriggerServerEvent("kraneCase:is_house_Renter", houseNr)
    while is_house_Renter == nil do Wait(0) end
    return is_house_Renter
end


exports('isHomeless', function()
    for _, house in pairs(houses) do
        if is_House_Owner(house.houseNr) or is_House_Renter(house.houseNr) then
            return false
        end
    end
    return true
end)

exports("isHouseOwner", function(houseNr)
    for _, house in pairs(houses) do
        if house.houseNr == houseNr then
            return is_House_Owner(house.houseNr)
        end
    end
    return false
end)

exports("isHouseRenter", function(houseNr)
    for _, house in pairs(houses) do
        if house.houseNr == houseNr then
            return is_House_Renter(house.houseNr)
        end
    end
    return false
end)

function is_House_Locked(houseNr)
    is_house_Locked = nil
    RegisterNetEvent("kraneCase:is_house_Locked")
    AddEventHandler("kraneCase:is_house_Locked", function(isIt)
        is_house_Locked = isIt
    end)
    TriggerServerEvent("kraneCase:is_house_Locked", houseNr)
    while is_house_Locked == nil do Wait(0) end
    return is_house_Locked
end





