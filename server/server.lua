AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    else 
        if Config.DeleteAfterRestart then
            MySQL.Async.execute('DELETE FROM fakeid;', function() end)
        end
    end
end)

lib.callback.register('tizid:canpay', function(canPay)
    local playerId = source
    local money = exports.ox_inventory:GetItemCount(playerId, Config.PaymentType)

    if money >= Config.Price then
        return true
    else
        return false
    end
end)
RegisterNetEvent('tizid:giveid')
AddEventHandler("tizid:giveid", function(playerID, input)
    local _source = source  
    local xPlayer = ESX.GetPlayerFromId(_source)
    local newnamas = table.concat(input, ' ',1,2)
    local newnamas1 = table.concat(input, ' ',1,1)
    local newnamas2 = table.concat(input, ' ',2,2)
    local dob = table.concat(input, '', 3,3)
    local gender = table.concat(input, '', 4,4)
    local category = table.concat(input, '', 5,5)
    local height = table.concat(input, '', 6)
    MySQL.Async.execute('INSERT INTO fakeid (id, oldname, newname, type, dob, gender, category, height) VALUES (@id, @oldname, @newname, @type, @dob, @gender, @category, @height)', -- (id, oldname, newname, type, dob) -- (@id, @oldname, @newname, @type, @)
    {
        ['id']   = xPlayer.identifier,
        ['oldname']   = xPlayer.getName(),
        ['newname'] = newnamas,
        ['type'] = 'fakeid',
        ['dob'] = dob,
        ['gender'] = gender,
        ['category'] = category,
        ['height'] = height,
    }, function ()
    end)
    if Config.Item then
        local metadata = {
            type = 'ID',
            description = string.format(Config.Language.name..' %s  \n'.. Config.Language.lname..': %s  \n '..Config.Language.dobas..': %s  \n '.. Config.Language.gender..': %s  \n '..Config.Language.category..': %s  \n '..Config.Language.height..': %s',
            newnamas1,
            newnamas2,
            dob, 
            gender, 
            category, 
            height)
        }
        exports.ox_inventory:AddItem(_source, Config.ItemNames.fakeid, 1, metadata)
    end
end)
RegisterNetEvent('tizid:payment')
AddEventHandler("tizid:payment", function(playerID)
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, Config.PaymentType, Config.Price)
end)

RegisterServerEvent('tizid:openserveris')
AddEventHandler('tizid:openserveris', function(ID, targetID, type, mugshotass)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
    local mugshots = mugshotass
	local show       = false
	MySQL.Async.fetchAll('SELECT newname, dob, gender, category, height, type FROM fakeid WHERE id = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) and type ~= nil then
            for i=1, #user, 1 do
                if type == 'fakeid' then
                    show = true
                end
            end
			if show then
				local array = {
					user = user,
				}
				TriggerClientEvent('tizid:openclient', _source, array, type, mugshots)
            end
		end
	end)
end)

RegisterServerEvent('tizid:redeemlicenses')
AddEventHandler('tizid:redeemlicenses', function(type)
    local id = type
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    if type == 'id' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function (user)
            local metadata = {
                type = 'ID',
                description = string.format(Config.Language.name..' %s  \n'.. Config.Language.lname..': %s  \n '..Config.Language.dobas..': %s  \n '.. Config.Language.gender..': %s  \n '..Config.Language.height..': %s',
                user[1],
                user[2],
                user[3], 
                user[4],  
                user[5])
            }
            exports.ox_inventory:AddItem(_source, Config.ItemNames.id, 1, metadata)
        end)
    elseif type == 'drivers' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function (user)
            local category = MySQL.prepare.await('SELECT type FROM user_licenses WHERE `id` = ? AND type = ?', {
                identifier, type
            })
            local metadata = {
                type = 'ID',
                description = string.format(Config.Language.name..' %s  \n'.. Config.Language.lname..': %s  \n '..Config.Language.dobas..': %s  \n '.. Config.Language.gender..': %s  \n '..Config.Language.category..': %s  \n '..Config.Language.height..': %s',
                user[1],
                user[2],
                user[3], 
                user[4], 
                category, 
                user[5])
            }
            exports.ox_inventory:AddItem(_source, Config.ItemNames.drivers, 1, metadata)
        end)
    elseif type == 'medic' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function (user)
            local metadata = {
                type = 'ID',
                description = string.format(Config.Language.name..' %s  \n'.. Config.Language.lname..': %s  \n '..Config.Language.dobas..': %s  \n '.. Config.Language.gender..': %s  \n '..Config.Language.height..': %s',
                user[1],
                user[2],
                user[3], 
                user[4],  
                user[5])
            }
            exports.ox_inventory:AddItem(_source, Config.ItemNames.medic, 1, metadata)
        end)
    elseif type == 'weapon' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function (user)
            local metadata = {
                type = 'ID',
                description = string.format(Config.Language.name..' %s  \n'.. Config.Language.lname..': %s  \n '..Config.Language.dobas..': %s  \n '.. Config.Language.gender..': %s  \n '..Config.Language.height..': %s',
                user[1],
                user[2],
                user[3], 
                user[4],  
                user[5])
            }
            exports.ox_inventory:AddItem(_source, Config.ItemNames.weapon, 1, metadata)
        end)
    end
end)

RegisterServerEvent('tizid:openserver')
AddEventHandler('tizid:openserver', function(ID, targetID, type, mugshotass)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false
	local mugshots = mugshotass
	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						elseif type =='medic' then
							if licenses[i].type == 'mediku_pazyma' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('tizid:openclient', _source, array, type, mugshots)
				else
					TriggerClientEvent('esx:showNotification', _source, Config.Language.nolicense)
				end
			end)
		end
	end)
end)

lib.callback.register('tizid:checklicense', function(hasLicense)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier 
	local hasLicense = MySQL.prepare.await('SELECT `type` FROM `fakeid` WHERE `id` = ?', {
        identifier
    })
	if hasLicense == 'fakeid' then
        return false
    else 
        return true
    end
end)

lib.callback.register('tizid:haslicense', function(license)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    local type = license
	local hasLicense = MySQL.prepare.await('SELECT type FROM user_licenses WHERE `id` = ? AND type = ?', {
        identifier, type
    })
	if hasLicense == type then
        return false
    else 
        return true
    end
end)
Citizen.CreateThread(function()
    if Config.UseableItems  then
        if (Config.ItemNames.fakeid ~= false) then
            ESX.RegisterUsableItem(Config.ItemNames.fakeid, function(source)
                TriggerClientEvent('tizid:openitem', source, 'fakeid')
            end)
        end
        if (Config.ItemNames.drivers ~= false) then
            ESX.RegisterUsableItem(Config.ItemNames.drivers, function(source)
                TriggerClientEvent('tizid:openitem', source, 'drive')
            end)
        end
        if (Config.ItemNames.id ~= false) then
            ESX.RegisterUsableItem(Config.ItemNames.id, function(source)
                TriggerClientEvent('tizid:openitem', source, 'normal')
            end)
        end
        if (Config.ItemNames.medic ~= false) then
            ESX.RegisterUsableItem(Config.ItemNames.medic, function(source)
                TriggerClientEvent('tizid:openitem', source, 'medic')
            end)
        end
        if (Config.ItemNames.weapon ~= false) then
            ESX.RegisterUsableItem(Config.ItemNames.weapon, function(source)
                TriggerClientEvent('tizid:openitem', source, 'weapon')
            end)
        end
    end
end)