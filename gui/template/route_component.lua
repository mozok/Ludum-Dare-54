--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md
--- Require this component in you gui file:
--- local RouteComponent = require("gui.template.route_component")
--- And create this component via:
--- self.route_component = self.druid:new(RouteComponent, template, nodes)

local Event = require("druid.event")
local component = require("druid.component")

---@class route_component: druid.base_component
---@field root node
---@field text_name druid.text
---@field text_distance druid.text
---@field text_description druid.text
---@field druid druid_instance
local RouteComponent = component.create("route_component")

local SCHEME = {
	ROOT = "root",
	PANEL_FRAME = "panel_frame",
	ICON_FRAME = "icon_frame",
	ICON = "icon",
	TEXT_NAME = "text_name",
	TEXT_DISTANCE = "text_distance",
	TEXT_DESCRIPTION = "text_description",
	PANEL_CHECKBOX = "panel_checkbox",
	ICON_CHECKBOX = "icon_checkbox"
}


---@param template string
---@param nodes table<hash, node>
function RouteComponent:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()

	self.root = self:get_node(SCHEME.ROOT)
	self.text_name = self.druid:new_text(SCHEME.TEXT_NAME)
	self.text_distance = self.druid:new_text(SCHEME.TEXT_DISTANCE)
	self.text_description = self.druid:new_text(SCHEME.TEXT_DESCRIPTION)
	self.checkbox = self:get_node(SCHEME.ICON_CHECKBOX)
	self.icon = self:get_node(SCHEME.ICON)

	self.button = self.druid:new_button(self.root, self._on_click)

	self.on_click = Event()
end

function RouteComponent:set_data(data)
	self._data = data

	gui.play_flipbook(self.icon, data.image)

	self.text_name:set_to(data.name)
	self.text_distance:set_to("Distance: " .. data.distance)
	self.text_description:set_to(data.description)

	self:set_checked(self._data.is_selected)
end

function RouteComponent:get_data()
	return self._data
end

function RouteComponent:set_checked(state)
	self._data.is_checked = state
	gui.set_enabled(self.checkbox, state)
end

function RouteComponent:set_click_zone(node)
	self.button:set_click_zone(node)
end

function RouteComponent:on_remove()
	self.on_click:clear()
end

function RouteComponent:_on_click()
	self.on_click:trigger(self)
end

return RouteComponent
