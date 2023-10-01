local broadcast = require "ludobits.m.broadcast"
local to_the_local_river = require "main.model.route.to_the_local_river"

local M = {}

-- TODO: add more routes
M.data = {
	[1] = {
		index = 1,
		name = "To the local River",
		description = "One day casual ride.\nWith light meal or snacks.",
		distance = 40,
		callback = to_the_local_river,
		is_selected = false,
		night = false,
		eat = 1
	},
	[2] = {
		index = 2,
		name = "Race",
		description = "Difficult Ride in Race mode.\nNot for beginners.",
		distance = 200,
		callback = function() end,
		is_selected = false,
		night = false,
		eat = 2
	}
}

M.selected = 0

local function prepare_data(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			if orig_key ~= "callback" then
				copy[prepare_data(orig_key)] = prepare_data(orig_value)
			end
		end
		setmetatable(copy, prepare_data(getmetatable(orig)))
	elseif orig_type == 'function' then
		copy = nil
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function M.select_route(index)
	for i, route in ipairs(M.data) do
		route.is_selected = false
	end

	M.selected = index
	if index > 0 then
		M.data[index].is_selected = true

		local route_data = prepare_data(M.data[index])
		broadcast.send("select_route", { data = route_data })
	end
end

return M