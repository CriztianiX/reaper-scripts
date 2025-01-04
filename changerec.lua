-- Script para alternar el modo de grabación entre las pistas en Reaper

function alternarModoGrabacion()
    local num_tracks = reaper.CountTracks(0) -- Contar el número de pistas en el proyecto
    if num_tracks == 0 then return end -- Salir si no hay pistas

    -- Buscar la pista actualmente en modo grabación
    local current_rec_track = nil
    for i = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local recarm = reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
        if recarm == 1 then
            current_rec_track = i
            break
        end
    end

    -- Desactivar grabación en todas las pistas
    for i = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 0)
    end

    -- Determinar la siguiente pista para poner en grabación
    local next_rec_track
    if current_rec_track == nil then
        -- Si no hay ninguna pista en grabación, activar la primera pista
        next_rec_track = 0
    else
        -- Si hay una pista en grabación, activar la siguiente
        next_rec_track = (current_rec_track + 1) % num_tracks
    end

    -- Activar grabación en la pista seleccionada
    local track_to_rec = reaper.GetTrack(0, next_rec_track)
    reaper.SetMediaTrackInfo_Value(track_to_rec, "I_RECARM", 1)

    -- Actualizar la vista y el estado del proyecto
    reaper.UpdateArrange()

    -- Mostrar mensaje en la consola (opcional)
    -- reaper.ShowConsoleMsg("Modo grabación activado para la pista: " .. (next_rec_track + 1) .. "\n")
end

-- Ejecutar la función
alternarModoGrabacion()
