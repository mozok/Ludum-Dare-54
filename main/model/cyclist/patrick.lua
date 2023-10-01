local M = {}

function M.distance_review(stamina, data)
	local result = ""

	if stamina == 0 then
		data.distance_ok = true

		result = result .. "This Ride was neat!"
		if data.energetic_used then
			result = result .. "And Energetic bar hit the right spot!"
		end
	elseif stamina > 0 then
		data.distance_ok = true
		if stamina > data.experience then
			result = result .. "This ride was too easy :("
			data.result_fun = data.result_fun - 20
		else
			result = result .. "Normal Ride..."
		end

		if data.have_energetic and not data.energetic_used then
			data.result_fun = data.result_fun - 5
			result = result .. "\nRemind me why I've bought that Energetic bar?"
		end
	else
		data.distance_ok = false

		result = result .. "I was exhausted"
	end

	return result
end

function M.night_review(stamina, data)
	local result = ""

	if not data.night_event and data.night_equip then
		data.result_fun = data.result_fun - 5
		return result .. "I'm here to ride, not to sleep :)"
	end

	if not data.night_event then
		return result
	end

	if stamina >= 0 then
		data.night_ok = true

		result = result .. "I had a lovely night."
		if data.night_equip then
			result = result .. " I'm here to ride, not to sleep :)"
			data.result_fun = data.result_fun - 5
		else
			result = result .. " Stars looks so beautiful :)"
		end
	else
		data.night_ok = false

		result = result .. "Night was too dark :("
		if data.night_equip then
			result = result .. " This tent was wrong sized!"
		else
			result = result .. " I was freezing WITHOUT a tent!"
		end
	end

	return result
end

function M.eat_review(stamina, data)
	local result = ""

	if stamina >= 0 then
		data.eat_ok = true

		if data.has_food then
			result = result .. "The meal was pretty good."
		end
	else
		data.eat_ok = false

		if data.has_food then
			result = result .. "I ate but remained hungry :_("
		else
			result = result .. "I was starving WITHOUT a food!"
		end
	end

	return result
end

function M.weight_review(stamina, data)
	local result = ""

	if stamina >= 0 then
		data.weight_ok = true

		if data.overweight then
			result = result .. "Bike was heavy, not an issue for a profy like me :)"
		else
			result = result .. "Bike was light and easy to ride"
		end
	else
		data.weight_ok = false

		if data.overweight then
			result = result .. "This HEAVY bike was killing me!"
		else
			result = result .. "Bike was not too heavy, but it didn't helped."
		end
	end

	return result
end

function M.check_ride_cost(cost, data)
	local result = ""

	if cost > data.money then
		result = result .. "I had some money, but this was not cheap!"
	end

	return result
end

function M.finish_review(stamina, data)
	local result = ""

	if data.result_fun > 90 then
		result = result .. "Whould ride again :)"
	elseif data.result_fun > 75 then
		result = result .. "It was a good ride."
	elseif data.result_fun > 60 then
		result = result .. "I wish it were better :("
	else
		result = result .. "I will never do business with you!"
	end
	
	return result
end

return M