local M = {}

function M.distance_review(stamina, data)
	local result = ''
	
	if stamina == 0 then
		data.distance_ok = true
		result = "First Ride in my life was hard :)"
		
		if data.energetic_used then
			result = result .. "\nBut Energetic supply saved me!"
		end
	elseif stamina > 0 then
		data.distance_ok = true
		result = "First Ride in my life was easy for me :)"
		
		if data.energetic_used then
			result = result .. "\nGood that I had some energetic supply!"
		elseif data.have_energetic then
			result = result .. "\nAnd I even don't eny of thouse energetic supplies."
		end
	else
		data.distance_ok = false

		result = result .. "My First Ride was a failure :("
		if not data.have_energetic then
			result = result .. "\nI wish I had some of thouse energetic supplies."
		elseif data.energetic_used then
			result = result .. "\nAnd energetic supplies hadn't helped. I've bet it is working at all :("
		end
	end

	return result
end

function M.night_review(stamina, data)
	local result = ''

	if not data.night_event and data.night_equip then
		return result .. "For what did I had this tent??"
	end

	if not data.night_event then
		return result
	end
	
	if stamina >= 0 then
		data.night_ok = true
		
		result = result .. "I had a good night."
		if data.night_equip then
			result = result .. " Sleeping with tent deffinatelly helped :)"
		else
			result = result .. " Stars looks so beautiful :)"
		end
	else
		data.night_ok = false
		
		result = result .. "Night was terrible :("
		if data.night_equip then
			result = result .. " This tent was useless!"
		else
			result = result .. " I was freezing WITHOUT a tent!"
		end
	end

	return result
end

function M.eat_review(stamina, data)
	local result = ''

	if stamina >= 0 then
		data.eat_ok = true
		
		if data.has_food then
			result = result .. "I had a nice meal."
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
	local result = ''

	if stamina >= 0 then
		data.weight_ok = true

		if data.overweight then
			result = result .. "Bike was heavy, but I deal with it :)"
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
		result = result .. "For such a HUGE price tag!"
	end

	return result
end

function M.finish_review(stamina, data)
	local fun = data.result_fun
	local result = ""
	
	if fun > 90 then
		result = result .. "Best Ride Ever :)"
	elseif fun > 75 then
		result = result .. "It was a good ride."
	elseif fun > 60 then
		result = result .. "I wish it were better :("
	else
		result = result .. "NEVER will go to this bikeservice!"
	end

	return result
end

return M