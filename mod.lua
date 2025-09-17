-- MOD ITEM

local row_height = 40
local padding = 8

function BLTModItem:init(panel, index, mod)
    self._mod = mod
    self._expanded = false

    self._panel = panel:panel({
        x = 0,
        y = (index - 1) * row_height,
        w = panel:w() - padding * 2,
        h = row_height,
        layer = 10
    })

    -- bg
    self._background = self._panel:rect({
        color = (index%2 == 1 and Color(0.2, 0.2, 0.2) or Color(0.3, 0.3, 0.3)),
        alpha = 0.2,
        layer = -1
    })

    local x = padding

    -- cool arrow
    self._arrow = self._panel:text({
        text = ">",
        font = tweak_data.menu.pd2_medium_font,
        font_size = tweak_data.menu.pd2_medium_font_size,
        color = Color.white,
        x = x,
        y = 0
    })
    local _,_,w,h = self._arrow:text_rect()
    self._arrow:set_size(w,h)
    self._arrow:set_center_y(row_height/2)
    x = x + w + padding

    -- icon
    if mod:HasModImage() then
        self._icon = self._panel:bitmap({
            texture = mod:GetModImage(),
            w = 24,
            h = 24,
            x = x,
            y = (row_height-24)/2
        })
    else
        self._icon = self._panel:rect({
            w = 24,
            h = 24,
            x = x,
            y = (row_height-24)/2,
            color = Color(0.4, 0.4, 0.4)
        })
    end
    x = x + 24 + padding

    -- name
    self._name = self._panel:text({
        text = mod:GetName(),
        font = tweak_data.menu.pd2_medium_font,
        font_size = 22,
        color = Color.white,
        x = x,
        y = 0
    })
    local _,_,nw,nh = self._name:text_rect()
    self._name:set_size(nw,nh)
    self._name:set_center_y(row_height/2)
    x = x + nw + padding

    -- type
    self._type = self._panel:text({
        text = mod:IsLibrary() and "[LIB]" or "[MOD]",
        font = tweak_data.menu.pd2_small_font,
        font_size = 18,
        color = Color(0.7,0.7,0.7),
        x = x,
        y = 0
    })
    local _,_,tw,th = self._type:text_rect()
    self._type:set_size(tw,th)
    self._type:set_center_y(row_height/2)
    x = x + tw + padding * 2
    
    -- version
    self._type = self._panel:text({
        text = "ver: " .. mod:GetVersion(),
        font = tweak_data.menu.pd2_small_font,
        font_size = 18,
        color = Color(0.6,0.6,0.6),
        x = x,
        y = 0
    })
    local _,_,vw,vh = self._type:text_rect()
    self._type:set_size(vw,vh)
    self._type:set_center_y(row_height/2)
    
    -- update
    local shouldBeUpdated = BLT.Downloads:get_pending_downloads_for(mod)
    self._type = self._panel:text({
        text = shouldBeUpdated and "UPDATE AVAILABLE" or "UP TO DATE",
        font = tweak_data.menu.pd2_small_font,
        font_size = 18,
        color = shouldBeUpdated and Color(0.8,0.3,0.3) or Color(0.7,0.7,0.7),
        x = self._panel:w() - 400,
        y = 0
    })
    local _,_,uw,uh = self._type:text_rect()
    self._type:set_size(uw,uh)
    self._type:set_center_y(row_height/2)

    -- on/off indicator
    self._toggle = self._panel:text({
        text = mod:IsEnabled() and "ON" or "OFF",
        font = tweak_data.menu.pd2_medium_font,
        font_size = 20,
        color = mod:IsEnabled() and Color.green or Color.red,
        x = self._panel:w() - 80,
        y = 0
    })
    local _,_,tw2,th2 = self._toggle:text_rect()
    self._toggle:set_size(tw2,th2)
    self._toggle:set_center_y(row_height/2)
end

-- MOD DOWNLOAD MANAGER

---@class AMM_MDM_Button
---@field new fun(self, panel, parameters):AMM_MDM_Button
AMM_MDM_Button = AMM_MDM_Button or blt_class()

padding = 10
local medium_font = tweak_data.menu.pd2_medium_font
local medium_font_size = tweak_data.menu.pd2_medium_font_size

local function make_fine_text(text)
    local x, y, w, h = text:text_rect()
    text:set_size(w, h)
    text:set_position(math.round(text:x()), math.round(text:y()))
end

function AMM_MDM_Button:init(panel, parameters)
    self._parameters = parameters

    -- panel
    self._panel = panel:panel({
        x = parameters.x or 0,
        y = parameters.y or 0,
        w = parameters.w or 200,
        h = parameters.h or 80,
        layer = 10
    })

    -- bg
    self._background = self._panel:rect({
        color = parameters.color or tweak_data.screen_colors.button_stage_3,
        alpha = 0.6,
        blend_mode = "add",
        layer = -1
    })
    BoxGuiObject:new(self._panel, {sides = {1, 1, 1, 1}})

    self._panel:bitmap({
        texture = "guis/textures/test_blur_df",
        w = self._panel:w(),
        h = self._panel:h(),
        render_template = "VertexColorTexturedBlur3D",
        layer = -1,
        halign = "scale",
        valign = "scale"
    })

    -- title
    local title = self._panel:text({
        name = "title",
        font_size = medium_font_size,
        font = medium_font,
        layer = 10,
        blend_mode = "add",
        color = tweak_data.screen_colors.title,
        text = parameters.title or "",
        align = "center",
        vertical = "center"
    })
    make_fine_text(title)
	title:set_w(self._panel:w())
    title:set_center_x(self._panel:w() * 0.5)
    title:set_bottom(self._panel:h() - padding)
end

function AMM_MDM_Button:panel()
    return self._panel
end

function AMM_MDM_Button:title()
    return self._panel:child("title")
end

function AMM_MDM_Button:image()
    return self._panel:child("image")
end

function AMM_MDM_Button:parameters()
    return self._parameters
end

function AMM_MDM_Button:inside(x, y)
    return self._panel:inside(x, y)
end

function AMM_MDM_Button:set_highlight(enabled, no_sound)
    if self._enabled ~= enabled then
        self._enabled = enabled
        self._background:set_color(enabled and tweak_data.screen_colors.button_stage_2 or (self:parameters().color or tweak_data.screen_colors.button_stage_3))
        if enabled and not no_sound then
            managers.menu_component:post_event("highlight")
        end
    end
end

-- MOD MENU

row_height = 40
padding = 8

function BLTModsGui:update_visible_mods(scroll_position, search_list, search_text)
    -- Update the show libraries and mod icons button
	self._libraries_show_button:set_visible(not BLTModsGui.show_libraries)
	self._libraries_hide_button:set_visible(BLTModsGui.show_libraries)

	self._mod_icons_show_button:set_visible(false)
	self._mod_icons_hide_button:set_visible(false)

	-- Save the position of the scroll panel
	BLTModsGui.last_y_position = scroll_position or self._scroll:canvas():y() * -1

	-- Save the last search
	BLTModsGui.last_search = search_text or BLTModsGui.last_search or ""

	-- Clear the scroll panel
	self._scroll:canvas():clear()
	self._scroll:update_canvas_size() -- Ensure the canvas always starts at it's maximum size
	self._buttons = {}

	-- Create download manager button
	local title_text = managers.localization:text("blt_download_manager")
	local downloads_count = table.size(BLT.Downloads:pending_downloads())
	if downloads_count > 0 then
		title_text = title_text .. " (" .. managers.experience:cash_string(downloads_count, "") .. ")"
	end

	local button = AMM_MDM_Button:new(self._scroll:canvas(), {
		x = 0,
		y = 0,
		w = self._scroll:canvas():w() - padding * 2,
		h = row_height,
		title = title_text,
		text = managers.localization:text("blt_download_manager_help"),
		callback = callback(self, self, "clbk_open_download_manager")
	})
	table.insert(self._buttons, button)

	-- Sort mods by library and name
	local mods = table.sorted_copy(BLT.Mods:Mods(), function (mod1, mod2)
		if mod1:GetId() == "base" then
			return true
		elseif mod2:GetId() == "base" then
			return false
		elseif mod1:IsLibrary() ~= mod2:IsLibrary() then
			return mod1:IsLibrary() and true or false
		elseif mod1:GetName():lower() < mod2:GetName():lower() then
			return true
		elseif mod1:GetName():lower() > mod2:GetName():lower() then
			return false
		end
		return mod1:GetId():lower() < mod2:GetId():lower()
	end)

	-- Create mod rows
    local mod_i = 2;
	for _, mod in ipairs(mods) do
        if (BLTModsGui.show_libraries or not mod:IsLibrary()) and mod:GetName():lower():find(BLTModsGui.last_search, 1, true) then
            local item = BLTModItem:new(self._scroll:canvas(), mod_i, mod)
            table.insert(self._buttons, item)
            mod_i = mod_i + 1;
        end
	end

	-- Update scroll size
	self._scroll:update_canvas_size()

	self._scroll:scroll_to(BLTModsGui.last_y_position)
end
