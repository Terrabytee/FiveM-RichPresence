local WaitTime = 2500 -- How often do you want to update the status (In MS)

local DiscordAppId = tonumber(GetConvar("RichAppId", "382624125287399424"))
local DiscordAppAsset = GetConvar("RichAssetId", "fivem_large")
local UseKMH = GetConvar("RichUseKMH", false)
	
Citizen.CreateThread(function()
	SetDiscordAppId(DiscordAppId)
	SetDiscordRichPresenceAsset(DiscordAppAsset)
	while true do
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		Citizen.Wait(WaitTime)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence("Sprintet auf der "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence("Rennt auf der "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence("Geht die "..StreetName.." runter")
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence("Steht auf der "..StreetName)
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local VehSpeed = GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId()))
				local CurSpeed = UseKMH and math.ceil(VehSpeed * 3.6) or math.ceil(VehSpeed * 2.236936)
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				if CurSpeed > 50 then
					SetRichPresence("Rast über die "..StreetName.." in einem "..VehName)
				elseif CurSpeed <= 50 and CurSpeed > 0 then
					SetRichPresence("Fährt über die "..StreetName.." in einem "..VehName)
				elseif CurSpeed == 0 then
					SetRichPresence("Parkt auf der "..StreetName.." in einem "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetRichPresence("Fliegt über die "..StreetName.." in einem "..VehName)
				else
					SetRichPresence("Landet auf der "..StreetName.." in einem "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence("Schwimmt rum")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				SetRichPresence("Segelt in einem "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("In einem U-Boot")
			end
		end
	end
end)
