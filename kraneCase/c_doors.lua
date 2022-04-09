function Listen_Enter_House(x,y,z)
    DoScreenFadeOut(2000)
    Wait(500)
    play_door_sound()
    Wait(2000)
    SetEntityCoords(PlayerPedId(), x,y,z, 0,0,0, false)
    DoScreenFadeIn(2000)
end
    

function Listen_Rent_Or_Buy(houseNr)
    TriggerServerEvent("kraneCase:Rent_Or_Buy", houseNr)
end

-- TriggerClientEvent("kraneCase:Enter_House", player, houseNr)

RegisterNetEvent("kraneCase:Enter_House")
AddEventHandler("kraneCase:Enter_House", function(houseNr)
    for _, house in pairs(houses) do
        if house.houseNr == houseNr then
            DoScreenFadeOut(2000)
            Wait(500)
            play_door_sound()
            Wait(2000)
            SetEntityCoords(PlayerPedId(), house.x,house.y,house.z, 0,0,0, false)
            DoScreenFadeIn(2000)
        end
    end
end)