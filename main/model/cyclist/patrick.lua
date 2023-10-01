local M = {
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

function M.set_base_stamina(value)
	M.base_stamina = value
end

function M.set_money_limit(amount)
	M.money = amount
end

function M.distance_review(stamina, data)
	local result = ""

	if stamina == 0 then
	elseif stamina > 0 then
	else
	end

	return result
end

function M.night_review(stamina)
end

function M.eat_review(stamina)
end

function M.weight_review(stamina)
end

function M.check_ride_cost(cost)
end

function M.finish_review(stamina, fun)
end

return M