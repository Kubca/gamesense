-- Self Lethal Indicator by Kubca#1337 
-- Suggested by quido#2080
-- Surface Lib subscribe here! https://gamesense.pub/forums/viewtopic.php?id=18793

-- [[ GS DEPENDENCIES ]]

local surface = require 'gamesense/surface' -- Library for custom font rendering ^^

-- [[ JUST A COOL CONSOLE PRINT ]] -- 
client.exec('clear')
client.color_log(182, 231, 23, '[gamesense] ---------------------------------------------------------------------------- [gamesense]')
client.color_log(3, 255, 255, [[
              _____ ______ _      ______   _      ______ _______ _    _          _      
             / ____|  ____| |    |  ____| | |    |  ____|__   __| |  | |   /\   | |     
            | (___ | |__  | |    | |__    | |    | |__     | |  | |__| |  /  \  | |     
             \___ \|  __| | |    |  __|   | |    |  __|    | |  |  __  | / /\ \ | |     
             ____) | |____| |____| |      | |____| |____   | |  | |  | |/ ____ \| |____ 
            |_____/|______|______|_|      |______|______|  |_|  |_|  |_/_/    \_\______|                                                                                                                                                          
]])
client.color_log(230, 3, 245, [[
            Self Lethal Indicator by Kubca#1337 
            Suggested by quido#2080
            Surface Lib subscribe here! https://gamesense.pub/forums/viewtopic.php?id=18793
]])
client.color_log(182, 231, 23, '[gamesense] ------------------------------------------------------------------------------- [gamesense]')

-- [[ MENU VARS ]] --

local cool_label = ui.new_label('VISUALS', 'Other ESP', '☚ SELF LETHAL INDICATOR ☛')

local lethal_indi = ui.new_checkbox('VISUALS', 'Other ESP', 'Enable Lethal Indicator')
local lethal_indi_hp = ui.new_checkbox('VISUALS', 'Other ESP', 'Show HP')
local color_label = ui.new_label('VISUALS', 'Other ESP', 'Lethal Indicator Color')
local color_picker = ui.new_color_picker('VISUALS', 'Other ESP', 'Lethal Indicator Color', 3, 168, 245, 255)
local alpha_combo = ui.new_combobox('VISUALS', 'Other ESP', 'Lethal Indicator Color Style', {'Static', 'Fade', 'Rainbow', 'Rainbow Fade'})
local case_combo = ui.new_combobox('VISUALS', 'Other ESP', 'Lethal Indicator Letter Options', {'Lowercase', 'Uppercase', 'Normal', 'Skeet Small', 'Custom Text', 'Custom Text Skeet'})
local size_text = ui.new_slider('VISUALS', 'Other ESP', 'Lethal Indicator Font Size', 11, 100, 12, true, '')
local textbox_label = ui.new_label('VISUALS', 'Other ESP', 'Enter Custom Text')
local textbox = ui.new_textbox('VISUALS', 'Other ESP', 'Enter Custom Text')

local cool_label2 = ui.new_label('VISUALS', 'Other ESP', '☚ SELF LETHAL INDICATOR ☛')

-- [[ GLOBALS ]] --

local drag = false
local screen_x, screen_y = client.screen_size()
local real_x = screen_x/2
local real_y = screen_y/2+5

-- [[ FUNCTIONS ]]

MouseInBounds = function(x, y, w, h)
    local mouse_pos_x, mouse_pos_y = ui.mouse_position()
    w = w * 2
    h = h * 2
    return mouse_pos_x >= x - w / 2 and mouse_pos_x <= x + w / 2 and mouse_pos_y >= y - h / 2 and mouse_pos_y <= y + h / 2 
end

Indicator = function()
    -- [[ VARS ]] --
    local menu_pos_x, menu_pos_y =  ui.menu_position()
    local menu_size_w, menu_size_h = ui.menu_size()
    local player_hp = entity.get_prop(entity.get_local_player(), 'm_iHealth')
    local is_menu_open = ui.is_menu_open()
    local mouse_pos_x, mouse_pos_y = ui.mouse_position()

    local font_size = ui.get(size_text)
    local text_input = ui.get(textbox)
    local Indi_Text = ui.get(alpha_combo)
    local Indicator_toggle = ui.get(lethal_indi) 
    local Indicator_HP = ui.get(lethal_indi_hp)
    local ComboBox = ui.get(case_combo)
    local Get_Color = ui.get(color_picker)

    local correct_x = 430
    local correct_y = 330
    local Show_HP = tostring(player_hp)..' HP'
    local font = surface.create_font('Arial', font_size, 50, {0x200})


    -- [[ COLORS ]] --
    local math_r = math.floor(math.sin(globals.curtime() * 2.0) * 127 + 128)
    local math_g = math.floor(math.sin(globals.curtime() * 2.0 + 2) * 127 + 128)
    local math_b = math.floor(math.sin(globals.curtime() * 2.0 + 4) * 127 + 128)
    local math_a = math.floor(math.sin(globals.curtime() * 2.0) * 127 + 128)

    -- [[ DYNAMIC COLOR ]] --
    local maxx_val = (255/100)
    local r_ = 255-(player_hp*maxx_val)
    local g_ = player_hp*maxx_val
    local b_ = 0
    if g_ > 255 then
        g_ = 255
    end

    -- [[ TRASH CODE <3 ]]

    if is_menu_open and MouseInBounds(real_x + 20 + #text_input*8, real_y + 15, font_size + 20 + #text_input*8, font_size - 5) and not MouseInBounds(menu_pos_x+correct_x, menu_pos_y+correct_y, menu_size_w/2+2, menu_size_h/2+2) and client.key_state(0x01) then
        drag = true
    end

    if not client.key_state(0x01) then
        drag = false
    end

    if drag then
        real_x = mouse_pos_x 
        real_y = mouse_pos_y-15
    end
    

    if Indi_Text == 'Static' then
        r, g, b, a = Get_Color
    elseif Indi_Text == 'Fade' then
        r, g, b = Get_Color
        a = math_a
    elseif Indi_Text == 'Rainbow' then
        r, g, b, a = Get_Color
        r, g, b = r - r + math_r, g - g + math_g, b - b + math_b
    elseif Indi_Text == 'Rainbow Fade' then
        r, g, b, a = Get_Color
        r, g, b, a = r - r + math_r, g - g + math_g, b - b + math_b, a - a + math_a
    end

    if Indicator_toggle and player_hp <= 92 or is_menu_open then
        if Indicator_HP then
            if ComboBox == 'Lowercase' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'lethal')
                surface.draw_text(real_x, real_y+15+font_size/2, r_, g_, b_, a, font, Show_HP)
            elseif ComboBox == 'Uppercase' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'LETHAL')
                surface.draw_text(real_x, real_y+15+font_size/2, r_, g_, b_, a, font, Show_HP)
            elseif ComboBox == 'Normal' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'Lethal')
                surface.draw_text(real_x, real_y+15+font_size/2, r_, g_, b_, a, font, Show_HP)
            elseif ComboBox == 'Custom Text' then
                if text_input == '' then
                    surface.draw_text(real_x, real_y, 255, 0, 0, a, font, 'Input a text!')
                else
                    surface.draw_text(real_x, real_y, r, g, b, a, font, text_input)
                end
                surface.draw_text(real_x, real_y+15+font_size/2, r_, g_, b_, a, font, Show_HP)
            elseif ComboBox == 'Custom Text Skeet' then
                if text_input == '' then
                    renderer.text(real_x, real_y, 255, 0, 0, a, '-', 0, string.upper('Input a text!'))
                else
                    renderer.text(real_x, real_y, r, g, b, a, '-', 0, string.upper(text_input))
                end
                renderer.text(real_x, real_y+10, r_, g_, b_, a, '-', 0, Show_HP)
            elseif ComboBox == 'Skeet Small' then
                renderer.text(real_x, real_y, r, g, b, a, '-', 0, 'LETHAL')
                renderer.text(real_x, real_y+10, r_, g_, b_, a, '-', 0, Show_HP)
            end
        else
            if ComboBox == 'Lowercase' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'lethal')
            elseif ComboBox == 'Uppercase' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'LETHAL')
            elseif ComboBox == 'Normal' then
                surface.draw_text(real_x, real_y, r, g, b, a, font, 'Lethal')
            elseif ComboBox == 'Custom Text' then
                if text_input == '' then
                    surface.draw_text(real_x, real_y, 255, 0, 0, a, font, 'Input a text!')
                else
                    surface.draw_text(real_x, real_y, r, g, b, a, font, text_input)
                end
            elseif ComboBox == 'Custom Text Skeet' then
                if text_input == '' then
                    renderer.text(real_x, real_y, 255, 0, 0, a, '-', 0, string.upper('Input a text!'))
                else
                    renderer.text(real_x, real_y, r, g, b, a, '-', 0, string.upper(text_input))
                end
            elseif ComboBox == 'Skeet Small' then
                renderer.text(real_x, real_y, r, g, b, a, '-', 0, 'LETHAL')
            end
        end
    end
end



client.set_event_callback('paint',function()
    local player_hp = entity.get_prop(entity.get_local_player(), 'm_iHealth')
    if player_hp > 0 then
        Indicator()
    end
end)
