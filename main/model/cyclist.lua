local dave_callback = require "main.model.cyclist.dave"

-- TODO: add more cyclists
local CYCLISTS = {
	[1] = {
		name = "Dave",
		description = "Hello Mr. CyclingCerviceExpertSir :)\nI want to try some cycling\nfor the first time.\nPlease help me =)",
		experience = 0,
		money = 150,
		weight_limit = 20,
		callback = dave_callback,
		fun = 100,
		stamina = 30
	},
}

local cyclist_index = 1

local M = {}

---@return table
function M.get_cyclist()
	return CYCLISTS[cyclist_index]
end

---@return boolean
function M.next_cyclist()
	if cyclist_index + 1 > #CYCLISTS then
		return false
	end
	
	cyclist_index = cyclist_index + 1
	return true
end

return M