-- Setup vehicle data
function setupVehicleData(vehicle, player)
	if not IsValidPlayer(player) then player = nil end
	if (GetVehiclePropertyValue(vehicle, "owner") ~= nil) or (GetVehiclePropertyValue(vehicle, "locked") ~= nil) then return end

	SetVehiclePropertyValue(vehicle, "owner", player, true)
	SetVehiclePropertyValue(vehicle, "locked", true, true)
end

-- Create a specified vehicle
function createVehicle(player, model, nitro)
	if not CheckAdmin(player) then return AddPlayerChat(player, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
	
	if model == nil then
		return AddPlayerChat(player, "Please specify a model (1-12) : /veh 1")
	end

	model = tonumber(model)
	if model < 1 or model > 12 then
		return AddPlayerChat(player, "Vehicle model "..model.." does not exist.")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local vehicle = CreateVehicle(model, x, y, z, h)
	if vehicle == false then
		return AddPlayerChat(player, "Failed to spawn your vehicle")
	end

	SetVehicleLicensePlate(vehicle, "RealisticBase")
	if type(nitro) ~= "bool" then nitro = false end -- Set default value to false
	if nitro then
		AttachVehicleNitro(vehicle, true)
	end

	if model == 8 then
		-- Set Ambulance blue color and license plate text
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-01")
	end

    -- Make player enter
	SetPlayerInVehicle(player, vehicle)
	setupVehicleData(vehicle, player)

	AddPlayerChat(player, "Vehicle spawned !")
end
AddCommand("v", createVehicle)
AddCommand("veh", createVehicle)
AddCommand("vehicle", createVehicle)
AddCommand("vehicule", createVehicle)

-- Repair vehicle system
local function repairVehicle(player)
	if not CheckAdmin(player) then return AddPlayerChat(player, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
	local vehicle = GetPlayerVehicle(player)
	if not IsValidVehicle(vehicle) then return AddPlayerChat(player, "You have to be in a vehicle to do this !") end

	for i=1, 8 do
		SetVehicleDamage(vehicle, i, 0)
	end
	SetVehicleHealth(vehicle, 5000)
	StartVehicleEngine(vehicle)
	AddPlayerChat(player, "Vehicle repaired.")
end
AddCommand("rep", repairVehicle)
AddCommand("repair", repairVehicle)

-- Lock/Unlock system
local function lockSystem(player)
	local vehicle = GetNearestVehicle(player)
	if not IsValidVehicle(vehicle) then return end
	setupVehicleData(vehicle, player)
	
	local value = not GetVehiclePropertyValue(vehicle, "locked")
	SetVehiclePropertyValue(vehicle, "locked", value, true)

	if value then
		AddPlayerChat(player, "Vehicle locked.")
	else
		AddPlayerChat(player, "Vehicle unlocked.")
	end
end
AddRemoteEvent("lockSystemEvent", lockSystem)