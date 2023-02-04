

CreateThread(function()
    for k, v in pairs(Config.PedList) do 
        v.npc = nil
        v.loaded = false
    end
    while true do 
        local sleep = 350 
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(Config.PedList) do 
            local distance = #(vec3(v.pos.x, v.pos.y, v.pos.z) - playerCoords)
            if distance <= v.distance and not v.loaded then 
                requestModel(v.model)
                local x, y, z, h = table.unpack(v.pos)
                z = (z - 1.0)
                v.npc = CreatePed(4, GetHashKey(v.model), vec4(x, y, z, h), true, true)
                if v.fade then 
                    SetEntityAlpha(v.npc, 0, false)
                    for i = 0, 255, 51 do 
                        Wait(50)
                        SetEntityAlpha(v.npc, i, false)
                    end
                end
                FreezeEntityPosition(v.npc, true)
                SetEntityInvincible(v.npc, true)
                SetBlockingOfNonTemporaryEvents(v.npc, true)
                v.loaded = true
            end
            if distance > v.distance and v.loaded then 
                if v.fade then 
                    for i = 255, 0, -51 do 
                        Wait(50)
                        SetEntityAlpha(v.npc, i, false)
                    end
                end
                DeletePed(v.npc)
                v.npc = nil
                v.loaded = false  
            end
        end

        Wait(sleep)
    end
end)

function requestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(1)
    end
end