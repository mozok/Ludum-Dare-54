local broadcast = require "ludobits.m.broadcast"

local used_bags = {}

local M = {
	data = {
		[1] = {
			index = 1,
			name = "Framebag Small",
			volume = 4,
			require_item = false,
			price = 100,
			image = hash("framebag2"),
			position = "frame",
			is_used = false
		},
		[2] = {
			index = 2,
			name = "Rear Mini-Panniers",
			volume = 30,
			require_item = 1,
			price = 200,
			image = hash("rackbag"),
			position = "rear-rack",
			is_used = false
		},
	}
}

function M.add_used(index)
	table.insert(used_bags, index)
	M.data[index].is_used = true

	broadcast.send("add_bag", { data = M.data[index] })
end

function M.remove_used(index)
	for key, value in ipairs(used_bags) do
		if value == index then
			M.data[index].is_used = false
			table.remove(used_bags, key)
			broadcast.send("remove_bag", { data = M.data[index] })
		end
	end
end

function M.get_used()
	local result = {}
	
	for _, index in ipairs(used_bags) do
		table.insert(result, M.data[index])
	end

	return result
end

function M.get_item(index)
	return M.data[index]
end

return M