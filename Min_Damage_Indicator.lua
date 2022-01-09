-- Min dmg by Kubca#1337 
-- Suggested by FEJKPEPICEK L9#2587 cause he is not using sigma adaptive what a stupid guy

local Menu = {

    cool_label = ui.new_label('RAGE', 'Aimbot', '☚ MINIMUM DAMAGE INDICATOR ☛'),
    min_dmg_val = ui.reference("RAGE", "Aimbot", "Minimum damage"), -- Getting min dmg to get the value
    hotkey = ui.new_hotkey("RAGE", "Aimbot", "Minimum Damage Indicator"), -- adding a hotkey for our indicator
    color_option = ui.new_combobox('Rage', 'Aimbot', 'Minumum Damage Indicator Color Style', {'Static', 'Rainbow', 'Dynamic'}),
    label = ui.new_label("Rage", "Aimbot", "Minumum Damage Indicator color"), -- Label for color picker
    color_picker = ui.new_color_picker("Rage", "Aimbot", "Minumum Damage Static Color", 255, 255, 255, 255), -- GS Color picker 
    cool_label2 = ui.new_label('RAGE', 'Aimbot', '☚ MINIMUM DAMAGE INDICATOR ☛'),

}

local screen_x, screen_y = client.screen_size() -- Your screen size 
local x, y = screen_x / 2, screen_y / 2 -- Screen size need to be divided by 2 so you get the center of your screen
local drag = false -- dragging false by default

-- [[ FUNCTION ]]

MouseInBounds = function(x, y, w, h) -- mouse function to get your mouse pos in bounds that means if your mouse is on selected x, y, w, h 
    local mouse_pos_x, mouse_pos_y = ui.mouse_position()
    w = w * 2
    h = h * 2
    return mouse_pos_x >= x - w / 2 and mouse_pos_x <= x + w / 2 and mouse_pos_y >= y - h / 2 and mouse_pos_y <= y + h / 2 
end

Damage_Indi = function()

    -- [[ VARS ]] --

    local menu_pos_x, menu_pos_y =  ui.menu_position() -- returning menu pos
    local menu_size_w, menu_size_h = ui.menu_size() -- returning menu size
    local is_menu_open = ui.is_menu_open() -- check if menu is opened
    local mouse_pos_x, mouse_pos_y = ui.mouse_position()

    local min_dmg = ui.get(Menu.min_dmg_val) -- getting the current min dmg value
    local color_r, color_g, color_b, color_a = ui.get(Menu.color_picker) -- get the value from color picker
    local bind = ui.get(Menu.hotkey) -- get your current bind
    local selected_color = ui.get(Menu.color_option) -- check if you toggled it


    local correct_x = 430 -- correct X for menu that means if you have menu opened and its infront of the indicator and you click on it through the menu it wont drag 
    local correct_y = 330 -- correct Y for menu that means if you have menu opened and its infront of the indicator and you click on it through the menu it wont drag 
    local alive = entity.is_alive(entity.get_local_player()) -- local player check if you are alive

    -- [[ COLORS ]] --

    local math_r = math.floor(math.sin(globals.curtime() * 2.0 + 0) * 127 + 128) -- math for rainbow red
    local math_g = math.floor(math.sin(globals.curtime() * 2.0 + 2) * 127 + 128) -- math for rainbow green
    local math_b = math.floor(math.sin(globals.curtime() * 2.0 + 4) * 127 + 128) -- math for rainbow blue

    -- [[ DYNAMIC COLOR ]] --

    local maxx_val = (255/105) -- 105 is max min dmg value here who would play more than that? dmg > 105 color will go to yellow
    local r_ = 255-(min_dmg*maxx_val)
    local g_ = min_dmg*maxx_val
    local b_ = 0
    if g_ > 255 then
        g_ = 255
    end

    -- [[ DRAGGING ]] --

    if is_menu_open and MouseInBounds(x + 20, y-15, 20, 5) and not MouseInBounds(menu_pos_x+correct_x, menu_pos_y+correct_y, menu_size_w/2+2, menu_size_h/2+2) and client.key_state(0x01) then -- check if you are on the min dmg text and when you press M1 you can drag it
        drag = true
    end

    if not client.key_state(0x01) then
        drag = false
    end

    if drag then
        x = mouse_pos_x-15
        y = mouse_pos_y+15
    end

    -- [[ MIN DMG INDI TYPE ]] --

    if selected_color == 'Static' then -- combo box
        r, g, b, a = color_r, color_g, color_b, color_a -- color picker value
    elseif selected_color == 'Rainbow' then
        r, g, b, a = math_r, math_g, math_b, color_a -- our rainbow math value
    elseif selected_color == 'Dynamic' then
        r, g, b, a = r_, g_, b_, color_a -- dynamic color val
    end

    -- [[ INDICATOR ]] --

    if bind and alive then -- checking if you pressed the toggle hotkey and if you alive
        renderer.text(x + 20, y - 20, r, g, b, a, '-', 0, tostring(min_dmg)) -- rendering the min dmg value on your screen 
    end    
end

client.set_event_callback("paint", Damage_Indi) -- callback function


-- BOOOM THAT WAS REALLY HARD to code :(
