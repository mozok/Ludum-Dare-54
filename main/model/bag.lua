local broadcast = require "ludobits.m.broadcast"

local used_bags = {}

-- TODO: add more bags
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
		[3] = {
			index = 3,
			name = "Stem Bag",
			volume = 2,
			require_item = false,
			price = 60,
			image = hash("feeder"),
			position = "stem",
			is_used = false
		},
		[4] = {
			index = 4,
			name = "Handlebar Roll",
			volume = 5,
			require_item = false,
			price = 100,
			image = hash("handlebarbag"),
			position = "handlebar",
			is_used = false
		},
		[5] = {
			index = 5,
			name = "Seat Pack",
			volume = 5,
			require_item = false,
			price = 120,
			image = hash("sadlebag"),
			position = "seat",
			is_used = false
		},
		[6] = {
			index = 6,
			name = "Framebag Big",
			volume = 6,
			require_item = false,
			price = 150,
			image = hash("framebag1"),
			position = "frame",
			is_used = false
		},
		[7] = {
			index = 7,
			name = "Rear Panniers",
			volume = 60,
			require_item = 1,
			price = 400,
			image = hash("pennybag"),
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

function M.reset()
	for key, value in ipairs(used_bags) do
		M.remove_used(value)
	end
end

return M