function Listen_House_Menu()
    TriggerServerEvent("kraneCase:Open_House_Menu")
end
local xSound = exports.xsound

RegisterNetEvent("kraneCase:Music")
AddEventHandler("kraneCase:Music", function(data)
    if data.type == "play" then
        xSound:Destroy(data.name)
        xSound:PlayUrlPos(data.name, data.url, 0.5, vector3(data.x, data.y, data.z), false, {})
        xSound:Distance(data.name,50)
    end

    if data.type == "stop" then
        xSound:Destroy(data.name)
    end

    if data.type == "volume" then
        xSound:setVolume(data.name, data.volume)
    end
end)


AddEventHandler("kraneCase:Animatie", function(animatie)
    ExecuteCommand("e " .. animatie)
end)