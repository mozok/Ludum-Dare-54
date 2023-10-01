local route_service = require "main.model.route"
local bike_service = require "main.model.bike"
local item_service = require "main.model.item"
local cyclist_service = require "main.model.cyclist"

local M = {
	result_fun = 0
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
	M.result_fun = 0
	M.review = ""

	local cyclist = cyclist_service.get_cyclist()
	local stamina = cyclist.stamina
	M.result_fun = cyclist.fun
	cyclist.callback.set_base_stamina(stamina)
	cyclist.callback.set_money_limit(cyclist.money)

	local route = route_service.data[route_service.selected]

	local items = item_service.get_used()

	-- check route distance
	stamina = stamina - route.distance
	local is_energetic = check_energetic(items)
	cyclist.callback.have_energetic = is_energetic
	if stamina < 0 then
		if is_energetic then
			cyclist.callback.energetic_used = true
			stamina = stamina + 10
		end
	end
	if stamina < 0 then
		M.result_fun = M.result_fun + stamina
	end
	M.review = M.review .. cyclist.callback.distance_review(stamina)

	-- check route sleepping
	if route.night then
		cyclist.callback.night_event = true
		
		if check_night(items) then
			stamina = stamina + 10 -- TODO: add dinamic rest
			cyclist.callback.night_equip = true
		else
			stamina = stamina - 20
			M.result_fun = M.result_fun - 20
			cyclist.callback.night_equip = false
		end

		M.review = M.review .. "\n" .. cyclist.callback.night_review(stamina)
	end

	-- check route eating
	if route.eat > 0 then
		cyclist.callback.food_event = true

		if check_food(items) then
			stamina = stamina + 10 -- TODO: add dinamic value
			cyclist.callback.has_food = true
		else
			stamina = stamina - 20
			M.result_fun = M.result_fun - 20
			cyclist.callback.has_food = false
		end

		M.review = M.review .. "\n" .. cyclist.callback.eat_review(stamina)
	end

	-- check ride weight
	if bike_service.weight > cyclist.weight_limit then
		cyclist.callback.overweight = true
		
		stamina = stamina - (bike_service.weight - cyclist.weight_limit)
		M.result_fun = M.result_fun - (bike_service.weight - cyclist.weight_limit)
	end
	M.review = M.review .. "\n" .. cyclist.callback.weight_review(stamina)

	-- TODO: add route random event

	-- TODO: check ride cost
	if bike_service.cost > cyclist.money then
		M.result_fun = M.result_fun - 10
	end
	M.review = M.review .. "\n" .. cyclist.callback.check_ride_cost(bike_service.cost)

	-- epilogue
	M.review = M.review .. "\n" .. cyclist.callback.finish_review(stamina, M.result_fun)

	return { fun = M.result_fun, review = M.review }
end

return M