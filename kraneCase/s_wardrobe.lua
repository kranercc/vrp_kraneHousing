local function Append_Outfit(player, current_outfitjson, outfit_name)
    src = player
    uid = vRP.getUserId({src})

    unpacked_obj = json.decode(current_outfitjson)
    unpacked_obj.outfit_name = outfit_name
    packed_obj = json.encode(unpacked_obj)
    current_outfitjson = packed_obj

    house_nr = get_House_Number_of_Owner(uid)
    if house_nr then
        local result = exports.ghmattimysql:executeSync("UPDATE kraneCase SET wardrobe = CONCAT(wardrobe, @jsonobj) WHERE houseNr = @houseNr", {jsonobj = "SEPARATOR"..current_outfitjson, houseNr = house_nr})
        vRP.closeMenu({src})
    end
end

local function Update_Outfits(player, outfit_data)
    src = player
    uid = vRP.getUserId({src})

    house_nr = get_House_Number_of_Owner(uid)
    if house_nr then
        local result = exports.ghmattimysql:executeSync("UPDATE kraneCase SET wardrobe = @jsonobj WHERE houseNr = @houseNr", {jsonobj = outfit_data, houseNr = house_nr})
        vRP.closeMenu({src})
    end
end

local function Get_Outfits(player)
    src = player
    uid = vRP.getUserId({src})

    house_nr = get_House_Number_of_Owner(uid)
    if house_nr then
        -- get all outfits from the wardrobe column like so "wardrobe = wardrobe + ,name=outfit_name>current_outfitjson"
        local result = exports.ghmattimysql:executeSync("SELECT wardrobe FROM kranecase WHERE houseNr = @house_nr", {house_nr = house_nr})
        if result[1] then
            return result[1].wardrobe
        else
            return nil
        end
    else
        return nil
    end
end

local function Match_Name_Outfit(player)
    src = player
    uid = vRP.getUserId({src})
    outfits = Get_Outfits(player)
    
    all_objs = get_all_json_objects(outfits)

    matched = {}

    for k, v in pairs(all_objs) do
        v_data = json.decode(v)
        matched[v_data.outfit_name] = v_data
    end    

    return matched
end

local function Show_Outfits(player)
    local menu = {name = "Outfits",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Outfits"

    src = player
    uid = vRP.getUserId({src})
    outfits = Match_Name_Outfit(player)
    for outfit_name, outfit_data in pairs(outfits) do
        if not src then src = vRP.getUserSource({uid}) end
        
        menu[outfit_name] = {function()
            if not src then src = vRP.getUserSource({uid}) end
            TriggerClientEvent("kraneCase:Equip_Outfit", src, outfit_data)
            vRP.closeMenu({src})
        end, "Outfit: "..outfit_name}
    end
    vRP.openMenu({src, menu})
end

local function Delete_Outfits(player)
    local menu = {name = "Delete_Outfits",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Delete_Outfits"

    src = player
    uid = vRP.getUserId({src})
    outfits = Match_Name_Outfit(player)
    for outfit_name, outfit_data in pairs(outfits) do
        if not src then src = vRP.getUserSource({uid}) end
        menu[outfit_name] = {function()
            if not player then player = vRP.getUserSource({uid}) end
            for k, v in pairs(outfits) do
                if v.outfit_name == outfit_name then
                    outfits[k] = nil
                end
            end
            wardrobe = ""
            for k, v in pairs(outfits) do
                wardrobe = "SEPARATOR"..json.encode(v)
            end
            Update_Outfits(player, wardrobe)
        end, "Outfit: "..outfit_name}
        vRP.closeMenu({src})

    end

    vRP.openMenu({src, menu})
end

local function buildWardrobeMenu(player, current_outfitjson)
	local menu = {name = "Wardrobe",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
	menu.name = "Wardrobe"


    ch_equip = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                Show_Outfits(player)
            end
        end, ""
    }

    ch_save = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                -- prompt for outfit name
                vRP.prompt({player, "Outfit name: ", "", function(player, outfit_name)
                    if outfit_name ~= nil and outfit_name ~= "" then
                        Append_Outfit(player, current_outfitjson, outfit_name)
                    end
                end})
            end
        end, ""
    }

    ch_delete = {
        function()
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                Delete_Outfits(player)
            end
        end
    }

    uid = vRP.getUserId({player})
	menu['Equip'] = ch_equip
    menu['Save'] = ch_save
    menu['Delete'] = ch_delete

    vRP.openMenu({player,menu})
end

RegisterServerEvent("kraneCase:Show_Wardrobe")
AddEventHandler("kraneCase:Show_Wardrobe", function(current_outfitjson)
	local user_id = vRP.getUserId({source})
    buildWardrobeMenu(source, current_outfitjson)
end)