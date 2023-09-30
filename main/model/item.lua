local used_items = {}

local M = {
	data = {
		[1] = {
			index = 1,
			name = "rack",
			cost = 20,
			callback = function() end,
			is_used = false
		}
	}
}

function M.add_used(index)
	table.insert(used_items, index)
	M.data[index].is_used = false
end

function M.remove_used(index)
	for key, value in ipairs(used_items) do
		if value == index then
			M.data[index].is_used = false
			table.remove(used_items, key)
		end
	end
end

function M.get_used()
	local result = {}

	for _, index in ipairs(used_items) do
		table.insert(result, M.data[index])
	end

	return result
end


return M