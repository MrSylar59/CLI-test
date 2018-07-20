local str = ""

function love.draw()
    love.graphics.scale(2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 25)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(str)
end

function interpret(cmd)
    -- On vérifie si la commande passée commence par le terme "color"
    if string.find(cmd, "^color") then
        args = cmd:sub(7) -- On saute le mot color : déjà interprété
        local num = "" -- Variable de travail qui va convertir le texte en nombre
        local r, v, b -- Nos variables de couleurs
        -- On va lire caractère après caractère 
        while args ~= "" do
            num = num .. args:sub(1, 1)
            args = args:sub(2)

            -- Si nous rencontrons un espace ou une fin de chaine, alors on a fini d'interpréter 1 argument
            if args:sub(1, 1) == " " or args:sub(1, 1) == "" then
                num = tonumber(num)
                if num ~= nil then -- On vérifie que notre nombre en est bien un
                    -- Puis on remplit nos variables dans l'ordre r -> v -> b
                    if r == nil then 
                        r = num
                    elseif v == nil then 
                        v = num
                    elseif b == nil then 
                        b = num
                    end
                end
                num = ""
            end

            -- Si toutes nos variables ont été défini : on a pas besoin d'interpréter la suite (s'il y en a une)
            if r and v and b then 
                args = ""
            end
        end
        print("Couleur RVB : "..r..", "..v..", "..b)
        if r and v and b then -- Dernière vérification pour éviter de crash (superflux)
            love.graphics.setBackgroundColor(r, v, b)
        else
            print("Impossible de convertir en couleur")
        end
    -- On permet de quitter simplement en écrivant quit : ^ = début de chaine; $ = fin de chaine
    -- On s'assure ainsi de l'intention de l'utilisateur
    elseif string.find(cmd, "^quit$") then
        love.event.quit()
    else
        print("La commande '"..cmd.."' n'est pas reconnue")
    end
end

-- La fonction textinput fonctionne comme un éditeur de texte
function love.textinput(t)
    str = str .. t
end

function love.keypressed(key)
    -- Si on appuies sur la touche retour arrière, il faut effacer le dernier caractère entré
    if key == "backspace" and str ~= "" then 
        -- On autorise l'événement de se répéter (comme un éditeur de texte)
        love.keyboard.setKeyRepeat(true)
        str = str:sub(1, -2)
    end

    -- On peut interpréter notre commande en appuyant sur entrer
    if key == "return" and str ~= "" then
        interpret(str)
        str = ""
    end
end

function love.keyreleased(key) 
    if key == "backspace" then
        -- On empêche les événements de se répéter une fois qu'on a relâché la touche BS
        love.keyboard.setKeyRepeat(false)
    end
end
