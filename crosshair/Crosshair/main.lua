local enabled2 = false
local crosshair = {reticle = true, size = 100, url = ''}
local enabled = false
local toggled = true

RegisterCommand('hud', function()
    toggled = not toggled enabled = toggled SendNUIMessage({ type = 'hud', enabled = toggled })
end)

CreateThread(function()
	while (true) do
		Citizen.Wait(4)
        if toggled then
            enabled = true
            SendNUIMessage({
            type = 'hud',
            enabled = true
          })
            if enabled then
                SendNUIMessage({discord = true})
                SendNUIMessage({
                type = 'hud',
                health = GetEntityHealth(PlayerPedId()) - 100,
                armor = GetPedArmour(PlayerPedId())
            })
        end
			Citizen.Wait(4)
			SendNUIMessage({
				display = true,
				id = GetPlayerServerId(PlayerId()) 
			})
            Citizen.Wait(750) 
		end
	end
end)

RegisterCommand("crosshair", function(source, args, rawCommand)
    enabled2 = not enabled2
    SetNuiFocus(enabled, enabled)
    SendNUIMessage({
        type = 'crosshair',
        enabled = enabled2
    })
end)

RegisterNUICallback('closeMenu', function(data, cb)
    enabled2 = false
    SetNuiFocus(false, false)
    SendNUIMessage({ 
        type = 'crosshair',
        enabled2 = false
    })
    cb('ok')
end)

RegisterNUICallback('updateCrosshair', function(data, cb)
    enabled2 = false
    SetNuiFocus(false, false)
    SendNUIMessage({ 
        type = 'crosshair',
        enabled2 = false
    })
    crosshair = data
    SetResourceKvp("crosshair", json.encode(crosshair))
    cb('ok')
end)

CreateThread(function()
   TriggerEvent('crosshair:initialized')
end)

AddEventHandler('crosshair:initialized', function()
    local kvp = GetResourceKvpString("crosshair")
    if kvp then
        kvp = json.decode(kvp)
        if type(kvp) == 'table' then
            crosshair.reticle = kvp.reticle == true and true or false
            crosshair.size = tonumber(kvp.size) or 100
            crosshair.url = kvp.url or ''
            SendNUIMessage({type = 'crosshair', crosshair = crosshair})
        end
    end
end)

CreateThread(function()
    while (true) do
        local sleep = 1000
        if not crosshair.reticle and IsPedArmed(PlayerPedId(), 4) then
            sleep = 4
            HideHudComponentThisFrame(14)
        end
		Citizen.Wait(sleep)
    end
end)