--[[
Describe cyclist types.
Select current cyclist.
Get current cyclist.
--]]

local CYCLISTS = {
	[1] = {
		name = "Dave",
		description = "Hello Mr. CyclingCerviceExpertSir :)\nI want to try some cycling\nfor the first time.",
		experience = 0,
		money = 0,
		weight_limit = 0,
		ride_callback = function() end,
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