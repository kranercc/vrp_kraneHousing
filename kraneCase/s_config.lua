houses_to_insert = {
    {
        uid = 0,
        houseNr = 2,
        safe = "",
        wardrobe = "",
        locked = 1,
        price = 100000,
        
        x = 1,
        y = 1,
        z = 1.093681335449,

        exit_x = 1.7976074219,
        exit_y = 1.6401367188,
        exit_z = 1.135238647461,

        teleport_x = 1.6394042969,
        teleport_y = 1.4080810547,
        teleport_z = 1.308609008789,

        safe_x = 1.8701171875,
        safe_y = 1.3043212891,
        safe_z = 1.127708435059,

        wardrobe_x = 1.3780517578,
        wardrobe_y = 1.0142822266,
        wardrobe_z = 1.333457946777,

        houseMenu_x = 1.1055908203,
        houseMenu_y = 1.5258789062,
        houseMenu_z = 1.318016052246,
 
        maxWeight = 20,
        renters = "",
        maxRenters = 22,
        money = 0,
    },
    {
        uid = 0,
        houseNr = 1,
        safe = "",
        wardrobe = "",
        locked = 1,
        price = 100000,
        
        x = 1638.6767578125,
        y = 1228.1209716797,
        z = 85.093681335449,

        exit_x = 1649.7976074219,
        exit_y = 1225.6401367188,
        exit_z = 85.135238647461,

        teleport_x = 1646.6394042969,
        teleport_y = 1230.4080810547,
        teleport_z = 85.308609008789,

        safe_x = 1642.8701171875,
        safe_y = 1236.3043212891,
        safe_z = 85.127708435059,

        wardrobe_x = 1649.3780517578,
        wardrobe_y = 1242.0142822266,
        wardrobe_z = 85.333457946777,

        houseMenu_x = 1648.1055908203,
        houseMenu_y = 1237.5258789062,
        houseMenu_z = 85.318016052246,
 
        maxWeight = 20,
        renters = "",
        maxRenters = 2,
        money = 0,
    },
}

--------------------------------------------------------------------------------
CreateThread(function()
    Wait(2000)
    for _, house_data in pairs(houses_to_insert) do

        duplicated = exports.ghmattimysql:executeSync("SELECT * FROM kranecase where houseNr = @houseNr", {['@houseNr'] = house_data.houseNr})
        if not duplicated[1] then
            local result = exports.ghmattimysql:executeSync("INSERT INTO kranecase (uid, houseNr, safe, wardrobe, locked, x, y, z, exit_x, exit_y, exit_z, teleport_x, teleport_y, teleport_z, safe_x, safe_y, safe_z, maxWeight, renters, money, price, wardrobe_x, wardrobe_y, wardrobe_z, maxRenters, houseMenu_x, houseMenu_y, houseMenu_z) VALUES (@uid, @houseNr, @safe, @wardrobe, @locked, @x, @y, @z, @exit_x, @exit_y, @exit_z, @teleport_x, @teleport_y, @teleport_z, @safe_x, @safe_y, @safe_z, @maxWeight, @renters, @money, @price, @wardrobe_x, @wardrobe_y, @wardrobe_z, @maxRenters, @houseMenu_x, @houseMenu_y, @houseMenu_z)", {
                ['@uid'] = house_data.uid,
                ['@houseNr'] = house_data.houseNr,
                ['@safe'] = house_data.safe,
                ['@wardrobe'] = house_data.wardrobe,
                ['@locked'] = house_data.locked,
                ['@x'] = house_data.x,
                ['@y'] = house_data.y,
                ['@z'] = house_data.z-1.0, -- grounde
                ['@exit_x'] = house_data.exit_x,
                ['@exit_y'] = house_data.exit_y,
                ['@exit_z'] = house_data.exit_z - 1.0,
                ['@teleport_x'] = house_data.teleport_x,
                ['@teleport_y'] = house_data.teleport_y,
                ['@teleport_z'] = house_data.teleport_z-1.0,
                ['@safe_x'] = house_data.safe_x,
                ['@safe_y'] = house_data.safe_y,
                ['@safe_z'] = house_data.safe_z-1.0,
                ['@maxWeight'] = house_data.maxWeight,
                ['@renters'] = house_data.renters,
                ['@money'] = house_data.money,
                ['@price'] = house_data.price,
                ['@wardrobe_x'] = house_data.wardrobe_x,
                ['@wardrobe_y'] = house_data.wardrobe_y,
                ['@wardrobe_z'] = house_data.wardrobe_z-1.0,
                ['@maxRenters'] = house_data.maxRenters,
                ['@houseMenu_x'] = house_data.houseMenu_x,
                ['@houseMenu_y'] = house_data.houseMenu_y,
                ['@houseMenu_z'] = house_data.houseMenu_z-1.0,
            })
        end
    end    
end)
