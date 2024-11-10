-- Solicitar al usuario el valor de volumen en dB
retval, user_input = reaper.GetUserInputs("Establecer Volumen", 1, "Ingrese el volumen en dB:", "-4")

-- Si el usuario presiona "Cancelar", terminamos el script
if not retval then return end

-- Convertir el valor ingresado a número
volume_db = tonumber(user_input)

-- Validar que el valor ingresado es un número
if not volume_db then
    reaper.ShowMessageBox("El valor ingresado no es un número válido.", "Error", 0)
    return
end

-- Función para convertir dB a un valor de volumen en Reaper
function dBToVolume(dB)
    return 10 ^ (dB / 20)
end

-- Obtener el número total de pistas en el proyecto
num_tracks = reaper.CountTracks(0)

-- Recorrer cada pista
for i = 0, num_tracks - 1 do
    track = reaper.GetTrack(0, i) -- Obtener la pista
    folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

    -- Si la pista es una carpeta (folder_depth es 1)
    if folder_depth == 1 then
        reaper.SetMediaTrackInfo_Value(track, "D_VOL", dBToVolume(volume_db)) -- Asignar volumen a carpeta
    elseif folder_depth == 0 then
        reaper.SetMediaTrackInfo_Value(track, "D_VOL", dBToVolume(volume_db)) -- Asignar volumen a pista normal
    end
end

-- Mostrar mensaje en la consola
reaper.ShowConsoleMsg("El volumen de todas las pistas y carpetas se ha establecido a " .. volume_db .. " dB.\n")

