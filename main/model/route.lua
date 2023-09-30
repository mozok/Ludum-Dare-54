local M = {}

M.data = {
	[1] = {
		index = 1,
		name = "To the local River",
		description = "",
		distance = 40,
		callback = function() end,
		is_selected = false
	},
	[2] = {
		index = 2,
		name = "Race",
		description = "",
		distance = 200,
		callback = function() end,
		is_selected = false
	}
}

M.selected = 0

function M.select_route(index)
	for i, route in ipairs(M.data) do
		route.is_selected = false
	end

	M.selected = index
	M.data[index].is_selected = true
end

return M