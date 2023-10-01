local route_service = require "main.model.route"
local bike_service = require "main.model.bike"
local item_service = require "main.model.item"
local cyclist_service = require "main.model.cyclist"

local M = {
	data = {},
	results = {}
}

local function check_type(items, type)
	for _, item in pairs(items) do
		if item.type == type then
			return true
		end
	end

	return false
end

local function check_energetic(items)
	return check_type(items, "energetic")
end

local function check_night(items)
	-- TODO: check night equipment set
	return check_type(items, "sleep")
end

local function check_food(items)
	-- TODO: check food based on eat times
	return check_type(items, "food")
end

function M.execute()
	M.data = {
		base_stamina = 0,
		money = 0,

		result_fun = 0,
		review = "",

		distance_ok = true,
		night_ok = true,
		eat_ok = true,
		weight_ok = true,
		events_ok = true,

		energetic_used = false,
		have_energetic = false,

		night_event = false,
		night_equip = false,

		food_event = false,
		has_food = false,

		overweight = false
	}

	local cyclist = cyclist_service.get_cyclist()
	local stamina = cyclist.stamina
	M.data.result_fun = cyclist.fun
	M.data.base_stamina = stamina
	M.data.money = cyclist.money
	M.data.experience = cyclist.experience

	local route = route_service.data[route_service.selected]

	local items = item_service.get_used()

	-- check route distance
	stamina = stamina - route.distance
	local is_energetic = check_energetic(items)
	M.data.have_energetic = is_energetic
	if stamina < 0 then
		if is_energetic then
			M.data.energetic_used = true
			stamina = stamina + 10
		end
	end
	if stamina < 0 then
		M.data.result_fun = M.data.result_fun + stamina
	end
	M.data.review = M.data.review .. cyclist.callback.distance_review(stamina, M.data)

	-- check route sleepping
	M.data.night_equip = check_night(items)
	if route.night then
		M.data.night_event = true
		
		if M.data.night_equip then
			stamina = stamina + 10 -- TODO: add dinamic rest
			M.data.night_equip = true
		else
			stamina = stamina - 20
			M.data.result_fun = M.data.result_fun - 20
			M.data.night_equip = false
		end
	end
	M.data.review = M.data.review .. "\n" .. cyclist.callback.night_review(stamina, M.data)

	-- check route eating
	if route.eat > 0 then
		M.data.food_event = true

		if check_food(items) then
			stamina = stamina + 10 -- TODO: add dinamic value
			M.data.has_food = true
		else
			stamina = stamina - 20
			M.data.result_fun = M.data.result_fun - 20
			M.data.has_food = false
		end
	end
	M.data.review = M.data.review .. "\n" .. cyclist.callback.eat_review(stamina, M.data)

	-- check ride weight
	if bike_service.weight > cyclist.weight_limit then
		M.data.overweight = true
		
		stamina = stamina - (bike_service.weight - cyclist.weight_limit)
		M.data.result_fun = M.data.result_fun - (bike_service.weight - cyclist.weight_limit)
	end
	M.data.review = M.data.review .. "\n" .. cyclist.callback.weight_review(stamina, M.data)

	-- TODO: add route random event

	-- TODO: check ride cost
	if bike_service.cost > cyclist.money then
		M.data.result_fun = M.data.result_fun - 10
	end
	M.data.review = M.data.review .. "\n" .. cyclist.callback.check_ride_cost(bike_service.cost, M.data)

	-- epilogue
	M.data.review = M.data.review .. "\n" .. cyclist.callback.finish_review(stamina, M.data)

	local result = { fun = M.data.result_fun, review = M.data.review, cyclist = { image = cyclist.image } }
	table.insert(M.results, result)
	
	return result
end

return M