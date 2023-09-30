local broadcast = require "ludobits.m.broadcast"

local used_items = {}

local M = {
	data = {
		[1] = {
			index = 1,
			name = "Rare Rack",
			image = hash("rack"),
			position = "rack-rear",
			description = "",
			price = 20,
			volume = 0,
			callback = function() end,
			is_used = false,
			require_bag = false
		}
	}
}

local function prepare_item_data(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[prepare_item_data(orig_key)] = prepare_item_data(orig_value)
		end
		setmetatable(copy, prepare_item_data(getmetatable(orig)))
	elseif orig_type == 'function' then
		copy = nil
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function M.add_used(index)
	table.insert(used_items, index)
	M.data[index].is_used = true

	local item_data = prepare_item_data(M.data[index])
	broadcast.send("add_item", { data = item_data })
end

function M.remove_used(index)
	for key, value in ipairs(used_items) do
		if value == index then
			M.data[index].is_used = false
			table.remove(used_items, key)

			local item_data = prepare_item_data(M.data[index])
			broadcast.send("remove_item", { data = item_data })
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

function M.get_item(index)
	return M.data[index]
end

return M