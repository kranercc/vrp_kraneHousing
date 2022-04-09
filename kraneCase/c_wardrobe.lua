-- local function create_camera_behind_ped()
--     ped = PlayerPedId()
--     local heading = GetEntityHeading(ped)
--     local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
--     local x,y,z = table.unpack(utility.Get_Pos_In_Front(PlayerPedId(), 2.0))
--      -- returns {x,y,z}
--     SetCamCoord(cam, x,y,z+1.0)
--     SetCamRot(cam, 0.0, 0.0, utility.Get_Reverse_Heading(PlayerPedId()))
--     SetCamActive(cam, true)
--     RenderScriptCams(true, false, 0, true, true)    
    
--     return cam
-- end

local function Get_Current_Outfit()
    local ped = PlayerPedId()
    local clothes = {}
    clothes.hat = {model = GetPedPropIndex(ped, 0), texture = GetPedPropTextureIndex(ped, 0), pos = 0 }
    clothes.jacket = {model = GetPedDrawableVariation(ped, 11), texture = GetPedTextureVariation(ped, 11), pos = 11 }
    clothes.undershirt = {model = GetPedDrawableVariation(ped, 8), texture = GetPedTextureVariation(ped, 8), pos = 8 }
    clothes.armsgloves = {model = GetPedDrawableVariation(ped, 3), texture = GetPedTextureVariation(ped, 3), pos = 3 }
    clothes.pants = {model = GetPedDrawableVariation(ped, 4), texture = GetPedTextureVariation(ped, 4), pos = 4 }
    clothes.shoes = {model = GetPedDrawableVariation(ped, 6), texture = GetPedTextureVariation(ped, 6), pos = 6 }
    clothes.mask = {model = GetPedDrawableVariation(ped, 1), texture = GetPedTextureVariation(ped, 1), pos = 1 }

    return json.encode(clothes)
end


function Listen_Wardrobe()
    TriggerServerEvent("kraneCase:Show_Wardrobe", Get_Current_Outfit()) 
end

RegisterNetEvent("kraneCase:Equip_Outfit")
AddEventHandler("kraneCase:Equip_Outfit", function(data)
    outfit = data
    hat_id = 0
    jacket_id = 11
    undershirt_id = 8
    armsgloves_id = 3
    pants_id = 4
    shoes_id = 6
    mask_id = 1

    ped = PlayerPedId()
    SetPedPropIndex(ped, 0, outfit.hat.model, outfit.hat.texture, false)
    SetPedComponentVariation(ped, 11, outfit.jacket.model, outfit.jacket.texture, 0)
    SetPedComponentVariation(ped, 8, outfit.undershirt.model, outfit.undershirt.texture, 0)
    SetPedComponentVariation(ped, 3, outfit.armsgloves.model, outfit.armsgloves.texture, 0)
    SetPedComponentVariation(ped, 4, outfit.pants.model, outfit.pants.texture, 0)
    SetPedComponentVariation(ped, 6, outfit.shoes.model, outfit.shoes.texture, 0)
    SetPedComponentVariation(ped, 1, outfit.mask.model, outfit.mask.texture, 0)
end)