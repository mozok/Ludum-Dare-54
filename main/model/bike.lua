local default_values = {
	max_volume = 0,
	volume = 0,
	weight = 15,
	cost = 0
}

local M = {}

M.max_volume = 0
M.volume = 0
M.weight = 15
M.cost = 0

function M.reset_default_values()
	for key, value in pairs(default_values) do
		M[key] = value
	end
end

function M.can_add_item(item)
	if item.volume == 0 then
		return true
	end

	if M.volume + item.volume > M.max_volume then
		return false
	end

	return true
end

return M