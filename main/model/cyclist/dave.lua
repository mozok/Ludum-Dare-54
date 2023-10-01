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

function M.distance_review(stamina)
	local result = ''
	
	if stamina == 0 then
		M.distance_ok = true
		result = "First Ride in my life almost failed :)"
		
		if M.energetic_used then
			result = result .. "\nEnergetic supply saved me!"
		end
	elseif stamina > 0 then
		M.distance_ok = true
		result = "First Ride in my life was easy for me :)"
		
		if M.energetic_used then
			result = result .. "\nGood that I had some energetic supply!"
		elseif M.have_energetic then
			result = result .. "\nAnd I even don't eny of thouse energetic supplies."
		end
	else
		M.distance_ok = false

		result = result .. "My First Ride was a failure :("
		if not M.have_energetic then
			result = result .. "\nI wish I had some of thouse energetic supplies."
		elseif M.energetic_used then
			result = result .. "\nAnd energetic supplies hadn't helped. I've bet it is working at all :("
		end
	end

	return result
end

function M.night_review(stamina)
	local result = ''

	if stamina >= 0 then
		M.night_ok = true
		
		result = result .. "I had a good night."
		if M.night_equip then
			result = result .. " Sleeping with tent deffinatelly helped :)"
		else
			result = result .. " Stars looks so beautiful :)"
		end
	else
		M.night_ok = false
		
		result = result .. "Night was terrible :("
		if M.night_equip then
			result = result .. " This tent was useless!"
		else
			result = result .. " I was freezing WITHOUT a tent!"
		end
	end

	return result
end

function M.eat_review(stamina)
	local result = ''

	if stamina >= 0 then
		M.eat_ok = true
		
		if M.has_food then
			result = result .. "I had a nice meal."
		end
	else
		M.eat_ok = false
		
		if M.has_food then
			result = result .. "I ate but remained hungry :_("
		else
			result = result .. "I was starving WITHOUT a food!"
		end
	end

	return result
end


function M.weight_review(stamina)
	local result = ''

	if stamina >= 0 then
		M.weight_ok = true

		if M.overweight then
			result = result .. "Bike was heavy, but I deal with it :)"
		else
			result = result .. "Bike was light and easy to ride"
		end
	else
		M.weight_ok = false

		if M.overweight then
			result = result .. "This HEAVY bike was killing me!"
		else
			result = result .. "Bike was not too heavy, but it didn't helped."
		end
	end

	return result
end

function M.finish_review(fun)
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