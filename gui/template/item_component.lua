--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md
--- Require this component in you gui file:
--- local ItemComponent = require("gui.template.item_component")
--- And create this component via:
--- self.item_component = self.druid:new(ItemComponent, template, nodes)

local Event = require("druid.event")
local component = require("druid.component")

---@class item_component: druid.base_component
---@field root node
---@field text_name druid.text
---@field text_volume druid.text
---@field text_price druid.text
---@field text_require druid.text
---@field text_description druid.text
---@field druid druid_instance
local ItemComponent = component.create("item_component")

local SCHEME = {
	ROOT = "root",
	PANEL_FRAME = "panel_frame",
	ICON_FRAME = "icon_frame",
	ICON = "icon",
	TEXT_NAME = "text_name",
	TEXT_VOLUME = "text_volume",
	TEXT_PRICE = "text_price",
	TEXT_REQUIRE = "text_require",
	TEXT_DESCRIPTION = "text_description",
	PANEL_CHECKBOX = "panel_checkbox",
	ICON_CHECKBOX = "icon_checkbox",
	PANEL_MESSAGE = "panel_message",
	TEXT_MESSAGE = "text_message"
}


---@param template string
---@param nodes table<hash, node>
function ItemComponent:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()

	self.root = self:get_node(SCHEME.ROOT)
	self.text_name = self.druid:new_text(SCHEME.TEXT_NAME)
	self.text_volume = self.druid:new_text(SCHEME.TEXT_VOLUME)
	self.text_price = self.druid:new_text(SCHEME.TEXT_PRICE)
	self.text_require = self.druid:new_text(SCHEME.TEXT_REQUIRE)
	self.text_description = self.druid:new_text(SCHEME.TEXT_DESCRIPTION)
	self.checkbox = self:get_node(SCHEME.ICON_CHECKBOX)
	self.icon = self:get_node(SCHEME.ICON)
	self.panel_message = self:get_node(SCHEME.PANEL_MESSAGE)
	self.text_message = self:get_node(SCHEME.TEXT_MESSAGE)

	gui.set_enabled(self.panel_message, false)

	self.button = self.druid:new_button(self.root, self._on_click)
	
	self.on_click = Event()
end

function ItemComponent:set_data(data)
	self._data = data

	gui.play_flipbook(self.icon, data.image)

	self.text_name:set_to(data.name)
	self.text_price:set_to("Price: " .. data.price)
	self.text_volume:set_to("Volume: " .. data.volume)
	self.text_description:set_to(data.description)
	if data.require_bag then
		self.text_require:set_to("Require: " .. data.require_bag_name)
		if not data.buy_enabled then
			gui.play_flipbook(self:get_node(SCHEME.PANEL_CHECKBOX), hash("checkmark_red"))
		else
			gui.play_flipbook(self:get_node(SCHEME.PANEL_CHECKBOX), hash("button_frame_green"))
		end
	else
		gui.set_enabled(self:get_node(SCHEME.TEXT_REQUIRE), false)
	end


	self:set_checked(self._data.is_used)
end

function ItemComponent:get_data()
	return self._data
end

function ItemComponent:set_checked(state)
	self._data.is_checked = state
	gui.set_enabled(self.checkbox, state)
end

function ItemComponent:set_click_zone(node)
	self.button:set_click_zone(node)
end

function ItemComponent:on_remove()
	self.on_click:clear()
end

function ItemComponent:_on_click()
	msg.post(msg.url("bike", "/bike", "bike_controller"), hash("play_checkbox"))
	self.on_click:trigger(self)
end

function ItemComponent:set_message(text)
	gui.set_text(self.text_message, text)

	local color = gui.get_color(self.panel_message)
	color.w = 1
	gui.set_color(self.panel_message, color)
	gui.set_enabled(self.panel_message, true)

	gui.animate(self.panel_message, "color.w", 0, gui.EASING_INSINE, 2, 0, function()
		gui.set_enabled(self.panel_message, false)
	end)
end

return ItemComponent
