-- graphics/countdown_display.lua

local countdown_display = {}

local start_time = nil
local duration = 60 -- duração em segundos
local countdown_active = false

-- Cores
local color_red = color.new(255, 0, 0, 255)
local color_white = color.new(255, 255, 255, 255)
local color_green = color.new(0, 255, 0, 255)
local color_yellow = color.new(255, 255, 0, 255)
local color_blue = color.new(0, 0, 255, 255)

function countdown_display.start_countdown()
    start_time = os.clock()
    countdown_active = true
end

function countdown_display.is_active()
    return countdown_active
end

function countdown_display.update_and_draw()
    if not countdown_active then return end

    local current_time = os.clock()
    local elapsed_time = current_time - start_time
    local remaining_time = duration - elapsed_time

    if remaining_time <= 0 then
        countdown_active = false
        start_time = nil
        return true -- Indica que a contagem regressiva terminou
    end

    local screen_width = get_screen_width()
    local screen_height = get_screen_height()
    local position = vec2.new(screen_width / 2, screen_height / 4)

    graphics.text_2d("Teleporte em:", position, 30, color_white)
    
    position.y = position.y + 40
    graphics.text_2d(string.format("%.1f segundos", remaining_time), position, 40, color_red)

    return false -- Indica que a contagem regressiva ainda está em andamento
end

-- Função on_render para renderização gráfica
on_render(function()
    -- Verifica se o jogador local existe
    local local_player = get_local_player()
    if not local_player then
        return
    end

    -- Obtém a posição atual do jogador
    local player_position = local_player:get_position()

    -- Posições para o texto na tela
    local txt_top_left = vec2.new(0, 15)
    local txt_top_left2 = vec2.new(0, 30)

    if countdown_active then
        -- Exibe informações na tela
        graphics.text_2d("[COUNTDOWN] Tempo restante: " .. string.format("%.1f", duration - (os.clock() - start_time)), txt_top_left, 13, color_white)
        graphics.text_2d("[COUNTDOWN] Posição do jogador: " .. tostring(player_position), txt_top_left2, 13, color_white)

        -- Chama a função de atualização e desenho da contagem regressiva
        countdown_display.update_and_draw()
    end
end)

return countdown_display