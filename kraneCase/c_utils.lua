function play_door_sound()
    local xSound = exports.xsound
    xSound:Destroy("door_open")
    rsong = "https://www.youtube.com/watch?v=92YfzPu3Ukc"
    xSound:PlayUrl("door_open", rsong, 0.5, false, false)
    xSound:Distance("door_open", 100)
end

function decide_entrance(house)
    if is_House_Owner(house.houseNr) then
        Listen_Enter_House(house.teleport_x, house.teleport_y, house.teleport_z)
        return
    end
    
    if is_House_Renter(house.houseNr) then
        Listen_Enter_House(house.teleport_x, house.teleport_y, house.teleport_z)
        return
    end

    if not is_House_Renter(house.houseNr) and not is_House_Owner(house.houseNr) then
        Listen_Rent_Or_Buy(house.houseNr)
        return
    end

    if not is_House_Locked(house.houseNr) then
        Listen_Enter_House(house.teleport_x, house.teleport_y, house.teleport_z)
        return
    end
end