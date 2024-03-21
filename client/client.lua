local menuOpen = false
local qtarget = exports.qtarget
local JobStartLocation = lib.points.new(Config.NPCLocation, 50)
local RedeemLocation = lib.points.new(Config.NPCLicenseLocation, 50)
AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= 'tiz-idsystem') then
        print("Do not change the name of the resource as this may break functionality.")
        return
    else
    end
end)

AddEventHandler('tizid:redeemlicense', function()
	local drivers = lib.callback.await("tizid:haslicense", false, 'driver')
	local weapon = lib.callback.await("tizid:haslicense", false, 'weapon')
	local medic = lib.callback.await("tizid:haslicense", false, 'medic')
	lib.registerContext({
		id = 'redeem',
		title = Config.Language.idtitle,
		options = {
		  {
			title = 'Redeem your ID',
			description = Config.Language.checkdesc,
			icon = 'vcard',
			onSelect = function(data, menu)
				TriggerServerEvent("tizid:redeemlicenses", "id")
			end,
		  },
		  {
			title = 'Redeem your Drivers License',,
			description = Config.Language.checkdesc,
			disabled = drivers
			icon = 'vcard',
			onSelect = function(data, menu)
				TriggerServerEvent("tizid:redeemlicenses", "drivers")
			end,
		  },
		  {
			title = 'Redeem your Weapon license',
			description = Config.Language.checkdesc,
			disabled = weapon
			icon = 'vcard',
			onSelect = function(data, menu)
				TriggerServerEvent("tizid:redeemlicenses", "weapon")
			end,
		  },
		  {
			title = 'Redeem your health license.',
			description = Config.Language.checkdesc,
			disabled = medic
			icon = 'vcard',
			onSelect = function(data, menu)
				TriggerServerEvent("tizid:redeemlicenses", "medic")
			end,
		  },
		}
	})
	lib.showContext('redeem')
end)

RegisterNetEvent('tizid:openmenu')
AddEventHandler("tizid:openmenu", function()
    menuOpen = true
    -- Registers the menu
    lib.registerContext({
        id = 'IDMenu',
        title = Config.Language.menutitle,
        onExit = toggleMenu(),
        options = {
            {
                title = Config.Language.buy,
                description = Config.Language.buydescription,
                icon = 'truck-fast',
                metadata = {{label = Config.Language.pricemeta, value = Config.Price}},
                onSelect = function()
                    DoApplication()
                end,
            }
        }
    }) 

    lib.showContext('IDMenu')   
end)

function DoApplication()
    local input = lib.inputDialog(Config.Language.idmenu, {
        {type = 'input', label = Config.Language.name, description = Config.Language.namedesc, required = true, min = 4, max = 16},
        {type = 'input', label = Config.Language.lname, description = Config.Language.lnamedesc, required = true, min = 4, max = 16},
        {type = 'date', label = Config.Language.dobas, icon = {'far', 'calendar'}, default = true, required = true, format = "DD/MM/YYYY",returnString = true},
        {type = 'select', label = Config.Language.gender, options = {{value = "M", label = Config.Language.male}, {value = "F", label = Config.Language.female}}, icon = {'fas', 'child'}, required = true},
        {type = 'select', label = Config.Language.category, options = {{value = Config.Language.categorya, label = Config.Language.categorya}, {value = Config.Language.categoryb, label = Config.Language.categoryb}, {value = Config.Language.categoryc, label = Config.Language.categoryc}}, icon = {'fas', 'drivers-license'}, required = true},
        {type = 'slider', label = Config.Language.height, icon = {'fas', 'child'}, required = true, min = 120, max = 200, step = 1}
    })
    if not input then return end
    canPay = lib.callback('tizid:canpay', false)
    hasaLicense = lib.callback('tizid:checklicense', false)
    if canPay then
        if hasaLicense then
            local playerID = source
            lib.notify({
                title = Config.Language.notifytitle,
                description = Config.Language.notifysucces,
                type = 'success'
            })
            TriggerServerEvent("tizid:payment", playerID)
            TriggerServerEvent("tizid:giveid", playerID, input)
        else
            lib.notify({
                title = Config.Language.notifytitle,
                description = Config.Language.notifyalready,
                type = 'success'
            })
        end
    else
        lib.notify({
            title = Config.Language.notifytitle,
            description = Config.Language.notifymoney,
            type = 'success'
        })
    end
end
function JobStartLocation:onEnter() -- RedeemLocation
    spawnIDNPC()
    qtarget:AddTargetEntity(createIDNPC, {
        options = {
            {
                name = Config.Language.pedname,
                icon = 'fa fa-vcard',
                label = Config.Language.eyepedname,
                action = function()
                    TriggerEvent('tizid:openmenu')
                end,
                distance = 10
            }
        }
    })
end
function RedeemLocation:onEnter()
    spawnRedeemNPC()
    qtarget:AddTargetEntity(createIDNPCL, {
        options = {
            {
                name = "RLicenses",
                icon = 'fa fa-vcard',
                label = "Redeem Licenses",
                action = function()
                    TriggerEvent('tizid:redeemlicense')
                end,
                distance = 10
            }
        }
    })
end
function spawnIDNPC()
    lib.RequestModel(Config.NPCModel)
    createIDNPC = CreatePed(0, Config.NPCModel, Config.NPCLocation, Config.NPCLocationheading, false, true)
    FreezeEntityPosition(createIDNPC, true)
    SetBlockingOfNonTemporaryEvents(createIDNPC, true)
    SetEntityInvincible(createIDNPC, true)
end
function spawnRedeemNPC()
    lib.RequestModel(Config.NPCLicenseModel)
    createIDNPCL = CreatePed(0, Config.NPCLicenseModel, Config.NPCLicenseLocation, Config.NPCLicenseLocationheading, false, true)
    FreezeEntityPosition(createIDNPCL, true)
    SetBlockingOfNonTemporaryEvents(createIDNPCL, true)
    SetEntityInvincible(createIDNPCL, true)
end
function toggleMenu()
    if menuOpen then
        menuOpen = false
    else
        menuOpen = true
    end
end

local open = false

RegisterNetEvent('tizid:openclient')
AddEventHandler('tizid:openclient', function(data, type , mugshot)
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type,
        mugshot = mugshot
	})
end)

-- Key events
Citizen.CreateThread(function()
    while true do
        Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

if Config.CommandOn then
    RegisterCommand(Config.Command, function()
        if open then
            SendNUIMessage({
                action = "close"
            })
            open = false
        else
            lib.showContext('FakeIDMenu')
            open = true
        end
    end, false)
end
Citizen.CreateThread(function()
	lib.registerContext({
		id = 'Fake',
		title = Config.Language.idtitle,
		options = {
		  {
			title = Config.Language.checktitle,
			description = Config.Language.checkdesc,
			icon = 'vcard',
			onSelect = function(data, menu)
			  local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
			  local mugshotasf = mugshotas.base64
			  TriggerServerEvent('tizid:openserveris', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'fakeid', mugshotasf)
			end,
		  },
		  {
			  title = Config.Language.showtitle,
			  description = Config.Language.showkdesc,
			  icon = 'users',
			  onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				  local player, distance = ESX.Game.GetClosestPlayer()
				  if distance ~= -1 and distance <= 1.5 then
					  TriggerServerEvent('tizid:openserveris', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'fakeid', mugshotasf)
				  else
					  lib.notify({
						  title = Config.Language.titlemenu,
						  description = Config.Language.menudesc,
						  type = 'success'
					  })    
				  end
			  end,
			},
		}
	})
	lib.registerContext({
		id = 'normal',
		title = Config.Language.idtitle,
		options = {
		{
			title = Config.Language.checkid,
			description = Config.Language.checkdesc,
			icon = 'vcard',
			onSelect = function(data, menu)
			  local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
			  local mugshotasf = mugshotas.base64
			  TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), nil, mugshotasf)
			end,
		  },
		  {
			title = Config.Language.showid,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), nil, mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		}
	})
	lib.registerContext({
		id = 'drivers',
		title = Config.Language.idtitle,
		options = {
		{
			title = Config.Language.checkdrivers,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.showdrivers,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		}
	})
	lib.registerContext({
		id = 'weapon',
		title = Config.Language.idtitle,
		options = {
		{
			title = Config.Language.checkweapon,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.showweapon,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		}
	})
	lib.registerContext({
		id = 'medic',
		title = Config.Language.idtitle,
		options = {
			{
			title = Config.Language.checkmedic,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'medic', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.showmedic,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'medic', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		}
	})
end)
RegisterNetEvent('tizid:openitem')
AddEventHandler('tizid:openitem', function(type)
	if type == "fakeid" then
    	lib.showContext('Fake')
	elseif type == "normal" then
		lib.showContext('normal')
	elseif type == "drivers" then
		lib.showContext('drivers')
	elseif type == "weapon" then
		lib.showContext('weapon')
	elseif type == "medic" then
		lib.showContext('medic')
	end
end)
RegisterNetEvent('tizid:openmenu')
AddEventHandler("tizid:openmenu", function()
    menuOpen = true
    lib.registerContext({
        id = 'IDMenu',
        title = Config.Language.menutitle,
        onExit = toggleMenu(),
        options = {
            {
                title = Config.Language.buy,
                description = Config.Language.buydescription,
                icon = 'truck-fast',
                metadata = {{label = Config.Language.pricemeta, value = Config.Price}},
                onSelect = function()
                    DoApplication()
                end,
            }
        }
    }) 

    lib.showContext('IDMenu')   
end)

lib.registerContext({
	id = 'FakeIDMenu',
	title = Config.Language.idtitle,
	options = {
	  {
		title = Config.Language.checktitle,
		description = Config.Language.checkdesc,
		icon = 'vcard',
		onSelect = function(data, menu)
		  local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
		  local mugshotasf = mugshotas.base64
		  TriggerServerEvent('tizid:openserveris', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'fakeid', mugshotasf)
		end,
	  },
	  {
		  title = Config.Language.showtitle,
		  description = Config.Language.showkdesc,
		  icon = 'users',
		  onSelect = function()
			local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
			local mugshotasf = mugshotas.base64
			  local player, distance = ESX.Game.GetClosestPlayer()
			  if distance ~= -1 and distance <= 1.5 then
				  TriggerServerEvent('tizid:openserveris', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'fakeid', mugshotasf)
			  else
				  lib.notify({
					  title = Config.Language.titlemenu,
					  description = Config.Language.menudesc,
					  type = 'success'
				  })    
			  end
		  end,
		},
		{
			title = Config.Language.checkid,
			description = Config.Language.checkdesc,
			icon = 'vcard',
			onSelect = function(data, menu)
			  local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
			  local mugshotasf = mugshotas.base64
			  TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), nil, mugshotasf)
			end,
		  },
		  {
			title = Config.Language.showid,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), nil, mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.checkdrivers,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.showdrivers,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Confing.Language.checkweapon,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Confing.Language.showweapon,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.checkmedic,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'medic', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
		  {
			title = Config.Language.showmedic,
			description = Config.Language.showkdesc,
			icon = 'users',
			onSelect = function()
				local mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
				local mugshotasf = mugshotas.base64
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 1.5 then
					TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'medic', mugshotasf)
				else
					lib.notify({
						title = Config.Language.titlemenu,
						description = Config.Language.menudesc,
						type = 'success'
					})    
				end
			end,
		  },
	}
  })