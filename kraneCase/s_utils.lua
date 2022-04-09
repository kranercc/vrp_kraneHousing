function splitstr(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function splitstr_substring(inputstr, substring)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..substring.."]+)") do
            table.insert(t, str)
    end
    return t
end

function get_all_json_objects(inputstr)
    local t = {}
    for str in string.gmatch(inputstr, "([^SEPARATOR]+)") do
            table.insert(t, str)
    end
    return t
end


function get_everything_before(str, substr)
    local before = ""
    local after = ""
    local found = false
    local i = 1
    while i <= #str do
        if string.sub(str, i, i+#substr-1) == substr then
            found = true
            before = string.sub(str, 1, i-1)
            break
        end
        i = i + 1
    end
    if found then
        return before
    else
        return str
    end
end

function get_everything_after(str, substr)
    local before = ""
    local after = ""
    local found = false
    local i = 1
    while i <= #str do
        if string.sub(str, i, i+#substr-1) == substr then
            found = true
            after = string.sub(str, i+#substr)
            break
        end
        i = i + 1
    end
    if found then
        return after
    else
        return str
    end
end

function Get_House_Price(houseNr) 
    local result = exports.ghmattimysql:executeSync("SELECT price FROM kranecase where houseNr = @houseNr", {houseNr = houseNr})
    if result[1] then
        return result[1].price
    else
        return 99999999999
    end
end


function get_money_based_on_percent(percent, total)
    calc = percent / 100 * total
    return calc
end

function isHouseOwner(uid)
    local result = exports.ghmattimysql:executeSync("SELECT * FROM kranecase where uid = @uid", {uid = uid})
    if result[1] then
        return true
    else
        return false
    end
end

function get_House_Number_Of_Renter(uid)
    local result = exports.ghmattimysql:executeSync("SELECT renters, houseNr FROM kranecase")
    --[{"houseNr":3,"renters":""},{"houseNr":1,"renters":",2"}]
    if result then
        local renters_table = {}
        local renters_house = 0
        for k,v in pairs(result) do
            if v.renters == nil or v.renters == "" then
                v.renters = ""
            end
            for k2,v2 in pairs(splitstr(v.renters, ",")) do
                renters_table[v2] = true
                renters_house = v.houseNr
            end
        end
        if renters_table[""..uid] then
            return renters_house
        else
            return false
        end
    else
        return false
    end
end

function get_House_Number_of_Owner(uid)
    local result = exports.ghmattimysql:executeSync("SELECT * FROM kranecase where uid = @uid", {uid = uid})
    if result[1] then
        return result[1].houseNr
    else
        return nil
    end
end

function addRenter(uid, houseNr)
    local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET renters = CONCAT(renters, ',', @uid) WHERE houseNr = @houseNr", {uid = uid, houseNr = houseNr})
end          

function evictRenter(uid)
    house = get_House_Number_Of_Renter(uid)
    if house then
        local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET renters = REPLACE(renters, @uid, '') WHERE houseNr = @houseNr", {uid = ","..uid, houseNr = house})
    end
end

RegisterCommand("evict", function(src, x, y)
    TriggerClientEvent("kraneCase:Get_Houses", -1, Get_Houses())
    uid = vRP.getUserId({src})
    evictRenter(uid)
end, false)

function addHouseMoney(house, amount)
    local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET money = money + @amount WHERE houseNr = @houseNr", {amount = amount, houseNr = house})
end

function takeRenterMoney(uid, amount)
    uid = tonumber(uid)
    amount = tonumber(amount)
    house = get_House_Number_Of_Renter(uid)
    src = vRP.getUserSource({uid})
    addHouseMoney(house, amount)
    if not vRP.tryPayment({uid, amount}) then
        evictRenter(uid)
        if src then
            TriggerClientEvent("chatMessage", src, " [ ^9krane^0Case ]: Nu ai avut bani de chirie.")
        end
    end
end

function get_House_Money(houseNr)
    local result = exports.ghmattimysql:executeSync("SELECT money FROM kranecase where houseNr = @houseNr", {houseNr = houseNr})
    if result[1] then
        return result[1].money
    else
        return 0
    end
end

function subtract_House_Money(houseNr, amount)
    local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET money = money - @amount WHERE houseNr = @houseNr", {amount = amount, houseNr = houseNr})
end

function add_House_Money(houseNr, amount)
    local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET money = money + @amount WHERE houseNr = @houseNr", {amount = amount, houseNr = houseNr})
end

function get_House_XYZ(houseNr)
    local result = exports.ghmattimysql:executeSync("SELECT x, y, z FROM kranecase where houseNr = @houseNr", {houseNr = houseNr})
    if result[1] then
        return result[1].x, result[1].y, result[1].z
    else
        return nil
    end
end

function Pay_Rent(houseNr)
    local result = exports.ghmattimysql:executeSync("SELECT renters FROM kranecase WHERE houseNr = @houseNr", {houseNr = houseNr})
    if result[1] then
        local renters = result[1].renters
        local renters_table = {}
        if renters == nil or renters == "" then
            renters = ""
        end
        for k,v in pairs(splitstr(renters, ",")) do
            renters_table[v] = true
        end
        for k,v in pairs(renters_table) do
            takeRenterMoney(k, get_money_based_on_percent(0.25, Get_House_Price(houseNr)))
        end
    end
end

function setOwner(uid, houseNr)
    TriggerClientEvent("kraneCase:Get_Houses", -1, Get_Houses())
    local result = exports.ghmattimysql:executeSync("UPDATE kranecase SET uid = @uid WHERE houseNr = @houseNr", {uid = uid, houseNr = houseNr})
end