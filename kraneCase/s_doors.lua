

local function buildBuyMenu(player, houseNr)
	local menu = {name = "Buy/Rent",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Buy/Rent"

    ch_Buy = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                local walletMoney = vRP.getMoney({user_id})
                -- local bankMoney = vRP.getBankMoney({user_id})

                local housePrice = Get_House_Price(houseNr)

                if walletMoney >= housePrice then
                    vRP.takeMoney({user_id, housePrice})
                    TriggerClientEvent("chatMessage", player, "[ ^9krane^0Case ]: Ai cumparat casa.")
                    TriggerClientEvent("kraneCase:Enter_House", player, houseNr)
                    setOwner(user_id, houseNr)
                    vRP.closeMenu({player})
                else
                    TriggerClientEvent("chatMessage", player, "[ ^9krane^0Case ]: Nu ai destui bani in portofel.")
                end

            end
                
        end, Get_House_Price(houseNr) .. " $"
    }

    ch_Rent = {
        function() 
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then

                local walletMoney = vRP.getMoney({user_id})

                local housePrice = get_money_based_on_percent(0.25, Get_House_Price(houseNr))

                if walletMoney >= housePrice then
                    vRP.takeMoney({user_id, housePrice})
                    TriggerClientEvent("chatMessage", player, "[ ^9krane^0Case ]: Esti chirias.")
                    TriggerClientEvent("kraneCase:Enter_House", player, houseNr)
                    addRenter(user_id, houseNr)
                    vRP.closeMenu({player})
                else
                    TriggerClientEvent("chatMessage", player, "[ ^9krane^0Case ]: Nu ai destui bani in portofel.")
                end

            end
        end, get_money_based_on_percent(0.25, Get_House_Price(houseNr)) .. " $"
    }

	menu['Buy'] = ch_Buy
	menu['Rent'] = ch_Rent

	vRP.openMenu({player,menu})
end
RegisterNetEvent("kraneCase:Rent_Or_Buy")
AddEventHandler("kraneCase:Rent_Or_Buy", function(houseNr)
    local user_id = vRP.getUserId({source})
    buildBuyMenu(source, houseNr)
end)
