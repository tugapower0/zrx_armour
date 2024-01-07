local SetPedArmour = SetPedArmour
local SetPedComponentVariation = SetPedComponentVariation
local TriggerServerEvent = TriggerServerEvent
local DoesEntityExist = DoesEntityExist
local IsPedMale = IsPedMale

UseArmour = function(index, value)
    local data = Config.Armour[index]

    if not data.allowedInVehicles and DoesEntityExist(cache.vehicle) then
        TriggerServerEvent('zrx_armour:server:cancelArmour')
        return CORE.Bridge.notification(Strings.in_vehicle)
    end

    if data.allowedJobs and not data.allowedJobs[CORE.Bridge.getVariables().job.name] then
        TriggerServerEvent('zrx_armour:server:cancelArmour')
        return CORE.Bridge.notification(Strings.not_permitted)
    end

    local response = lib.progressBar({
        duration = data.usetime,
        label = Strings.using,
        useWhileDead = false,
        canCancel = true,
        disable = data.disable,
        anim = {
            dict = data.anim.dict,
            clip = data.anim.lib,
            flag = data.anim.flag
        },
    })

    if not response then
        return
    end

    if IsPedMale(cache.ped) then
        Component = { drawable = data.vest.male.drawable, texture = data.vest.male.texture }
    else
        Component = { drawable = data.vest.female.drawable, texture = data.vest.female.texture }
    end

    SetPedArmour(cache.ped, value)
    SetPedComponentVariation(cache.ped, 9, data.vest.drawable, data.vest.texture, 0)

    CORE.Bridge.notification(Strings.taken)
    TriggerServerEvent('zrx_armour:server:useArmour', index)

    HasArmour = true
end