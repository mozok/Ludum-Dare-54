--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md
--- Require this component in you gui file:
--- local Bag = require("gui.template.bag")
--- And create this component via:
--- self.bag = self.druid:new(Bag, template, nodes)

local component = require("druid.component")

---@class bag: druid.base_component
---@field root node
---@field text_name druid.text
---@field text_price druid.text
---@field text_require druid.text
---@field druid druid_instance
local Bag = component.create("bag")

local SCHEME = {
	ROOT = "root",
	PANEL_FRAME = "panel_frame",
	ICON_FRAME = "icon_frame",
	ICON = "icon",
	TEXT_NAME = "text_name",
	TEXT_PRICE = "text_price",
	TEXT_REQUIRE = "text_require",
	PANEL_CHECKBOX = "panel_checkbox",
	ICON_CHECKBOX = "icon_checkbox"
}


---@param template string
---@param nodes table<hash, node>
function Bag:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()

	self.root = self:get_node(SCHEME.ROOT)
	self.text_name = self.druid:new_text(SCHEME.TEXT_NAME)
	self.text_price = self.druid:new_text(SCHEME.TEXT_PRICE)
	self.text_require = self.druid:new_text(SCHEME.TEXT_REQUIRE)
	self.checkbox = self:get_node(SCHEME.ICON_CHECKBOX)

	self.button = self.druid:new_button(self.root, self._on_click)

	self.on_click = Event()
end

function ButtonComponent:set_data(data)
	self._data = data
	self.text:set_to("Element: " .. data.value)
	self:set_checked(self._data.is_checked)
end

function ButtonComponent:get_data()
	return self._data
end


function ButtonComponent:set_checked(state)
	self._data.is_checked = state
	gui.set_enabled(self.checkbox, state)
end

function ButtonComponent:set_click_zone(node)
	self.button:set_click_zone(node)
end

function ButtonComponent:on_remove()
	self.on_click:clear()
end

function ButtonComponent:_on_click()
	self.on_click:trigger(self)
end

return Bag
