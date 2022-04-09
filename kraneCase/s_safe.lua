max_weight = 500 -- kg

function Get_Safe_Weight(source)
    cw = 0
    for k, v in pairs(Get_Safe_Items(source)) do
        kw = vRP.getItemWeight({k})*v
        cw = cw + kw
    end
    return cw
end

function Get_Max_Weight(houseNr)
    local result = exports.ghmattimysql:executeSync("SELECT maxWeight FROM kranecase WHERE houseNr = @houseNr", {houseNr = houseNr})
    if result[1] then
        return tonumber(result[1].maxWeight)
    else
        return 0
    end
end

function Add_To_Safe(source, name, amount)
    local src = source
    Remove_Empty_Items(src)
    local uid = vRP.getUserId({src})

    if Get_Safe_Weight(src) + vRP.getItemWeight({name})*amount >= Get_Max_Weight(get_House_Number_of_Owner(uid)) then
        TriggerClientEvent("chatMessage", src, "[ ^9krane^0Case ]: Seiful a atins capacitatea maxima")
        vRP.closeMenu({src})
        return false
    end

    local result = exports.ghmattimysql:executeSync("SELECT safe FROM kranecase where uid = @uid", {uid = uid})
    if result[1] then
        local safe = result[1].safe
        -- safe: "battery:1", "light:13"
        local safe_table = {}
        for k,v in pairs(splitstr(safe, ",")) do
            local item = splitstr(v, ":")
            safe_table[item[1]] = item[2]
        end
        if not safe_table[name] then
            safe_table[name] = 0
        end
        safe_table[name] = safe_table[name] + amount
        local new_safe = ""
        for k,v in pairs(safe_table) do
            new_safe = new_safe .. k .. ":" .. v .. ","
        end
        new_safe = string.sub(new_safe, 1, string.len(new_safe) - 1)
        exports.ghmattimysql:execute("UPDATE kranecase SET safe = @safe WHERE uid = @uid", {safe = new_safe, uid = uid})
        return true
    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "House not found.")
        return false
    end
    return false
end

function Get_Safe_Items(source)
    Remove_Empty_Items(source)
    local src = source
    local uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT safe FROM kranecase where uid = @uid", {uid = uid})

    if result[1] then
        local safe = result[1].safe
        -- safe: "battery:1", "light:13"
        local safe_table = {}
        for k,v in pairs(splitstr(safe, ",")) do
            local item = splitstr(v, ":")
            safe_table[item[1]] = item[2]
        end
        return safe_table
    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "House not found.")
    end
end

function Remove_Empty_Items(source)
    local src = source
    local uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT safe FROM kranecase where uid = @uid", {uid = uid})

    if result[1] then
        local safe = result[1].safe
        -- safe: "battery:1", "light:13"
        local safe_table = {}
        for k,v in pairs(splitstr(safe, ",")) do
            local item = splitstr(v, ":")
            safe_table[item[1]] = item[2]
        end
        new_tbl = {}
        for k,v in pairs(safe_table) do
            if tonumber(v) > 0 then
                table.insert(new_tbl, k .. ":" .. v)
            end
        end
        local new_safe = ""
        for k,v in pairs(new_tbl) do
            new_safe = new_safe .. v .. ","
        end
        new_safe = string.sub(new_safe, 1, string.len(new_safe) - 1)
        exports.ghmattimysql:execute("UPDATE kranecase SET safe = @safe WHERE uid = @uid", {safe = new_safe, uid = uid})

    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "House not found.")
    end
end

function Remove_From_Safe(source, name, amount)
    Remove_Empty_Items(source)
    local src = source
    local uid = vRP.getUserId({src})
    local result = exports.ghmattimysql:executeSync("SELECT safe FROM kranecase where uid = @uid", {uid = uid})

    if result[1] then
        local safe = result[1].safe
        -- safe: "battery:1", "light:13"
        local safe_table = {}
        for k,v in pairs(splitstr(safe, ",")) do
            local item = splitstr(v, ":")
            safe_table[item[1]] = item[2]
        end
        if not safe_table[name] then
            safe_table[name] = 0
        end
        safe_table[name] = safe_table[name] - amount
        if safe_table[name] < 0 then
            safe_table[name] = 0
        end
        local new_safe = ""
        for k,v in pairs(safe_table) do
            new_safe = new_safe .. k .. ":" .. v .. ","
        end
        new_safe = string.sub(new_safe, 1, string.len(new_safe) - 1)
        exports.ghmattimysql:execute("UPDATE kranecase SET safe = @safe WHERE uid = @uid", {safe = new_safe, uid = uid})
    else
        TriggerClientEvent("chatMessage", src, "SYSTEM", {255, 0, 0}, "House not found.")
    end
end

local function show_inventory_items(user_id)
    user_id = tonumber(user_id)
    src = vRP.getUserSource({user_id})

    local menu = {name = "Inventory",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Inventory"

    local inventory = vRP.getInventory({user_id}) 

    for k, v in pairs(inventory) do
        item_name = vRP.getItemName({k})
        menu[item_name] = {function()
            uid = user_id
            if not src then
                src = vRP.getUserSource({user_id})
            end
            vRP.prompt({src, "Amount:", "", function(player, amount)
                if not player or not amount or not k then print("x") return end
                amount = parseInt(amount)
                if amount >= 0 and amount <= v.amount then
                    if Add_To_Safe(player, k, amount) then
                        vRP.tryGetInventoryItem({user_id, k, amount})
                    end
                else
                    TriggerClientEvent("chatMessage", -1, "[ ^9krane^0Case ]: Userul - " .. GetPlayerName(player) .. "(id:" .. user_id .. ") a incercat ceva ilegal la seif.")
                    -- DropPlayer(src, "tentativa bug seif case")
                end
                vRP.closeMenu({player})
            end})

        end, "Amount: " .. v.amount}
    end

    vRP.closeMenu({src})

    vRP.openMenu({src, menu})
end

function show_safe_items(user_id)
    user_id = tonumber(user_id)
    src = vRP.getUserSource({user_id})
    local menu = {name = "Safe",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Safe"

    local inventory = vRP.getInventory({user_id}) 
    for k, v in pairs(Get_Safe_Items(src)) do
        item_name = vRP.getItemName({k})
        menu[item_name] = {function()
            if not src then
                src = vRP.getUserSource({user_id})
            end
            vRP.prompt({src, "Amount:", "", function(player, amount)
                amount = parseInt(amount)
                if amount >= 0 and amount <= tonumber(v) then
                    Remove_From_Safe(player, k, amount)
                    vRP.giveInventoryItem({user_id, k, amount})
                else
                    TriggerClientEvent("chatMessage", -1, "[ ^9krane^0Case ]: Userul - " .. GetPlayerName(player) .. "(id:" .. user_id .. ") a incercat ceva ilegal la seif.")
                    -- DropPlayer(src, "tentativa bug seif case")
                end
                vRP.closeMenu({player})

            end})

        end, "Amount: " .. v}
    end
    vRP.closeMenu({src})

    vRP.openMenu({src, menu})
end

local function buildSafeMenu(player)
    Remove_Empty_Items(player)
	local menu = {name = "Safe",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Safe"

	local function ch_take(player,choice) 
    	local user_id = vRP.getUserId({player})
		if user_id ~= nil then
            show_safe_items(user_id)
        end
    end

    local function ch_put(player,choice) 
    	local user_id = vRP.getUserId({player})
		if user_id ~= nil then
            show_inventory_items(user_id)
        end
    end
    uid = vRP.getUserId({player})
	menu['Take'] = {ch_take,""}
	menu['Put'] = {ch_put,"Greutate Seif: " .. Get_Safe_Weight(player) .. "/" .. Get_Max_Weight(get_House_Number_of_Owner(uid))}

	vRP.openMenu({player,menu})
end

RegisterServerEvent("kraneCase:Show_Safe_Contents")
AddEventHandler("kraneCase:Show_Safe_Contents", function(name)
	local user_id = vRP.getUserId({source})
    buildSafeMenu(source)
end)