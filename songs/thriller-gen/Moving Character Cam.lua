local ofs = 25
local followchars = false
local del = 0
local del2 = 0
local curFocus = "dad"
local cutscene = true

function getCharacterPos(character)
    local x = getMidpointX(character) + getProperty(character .. ".cameraPosition[0]")
    local y = getMidpointY(character) + getProperty(character .. ".cameraPosition[1]")
    
    if character == 'dad' then
        x = x + getProperty("opponentCameraOffset[0]")
        y = y + getProperty("opponentCameraOffset[1]")
    elseif character == 'gf' then
        x = x + getProperty("girlfriendCameraOffset[0]")
        y = y + getProperty("girlfriendCameraOffset[1]")
    elseif character == 'boyfriend' then
        x = x + getProperty("boyfriendCameraOffset[0]")
        y = y + getProperty("boyfriendCameraOffset[1]")
    end

    return x, y
end

function onSongStart()
    setProperty('boyfriend.alpha', 0)
end

function onSectionHit()
    if mustHitSection then
        doTweenAlpha('boyfriendAlpha', 'boyfriend', 1, 0.5, 'quadInOut')
    else
        doTweenAlpha('boyfriendAlpha', 'boyfriend', 0, 0.5, 'quadInOut')
    end
end

function onUpdate()
    if del > 0 then
        del = del - 1
    end
    if del2 > 0 then
        del2 = del2 - 1
    end
    
    if followchars == true then
        setProperty('isCameraOnForcedPos', false)
        if mustHitSection == false then
            local dadX, dadY = getCharacterPos('dad')
            if getProperty('dad.animation.curAnim.name'):find('sing') then
                if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos', dadX - ofs, dadY)
                end
                if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos', dadX + ofs, dadY)
                end
                if getProperty('dad.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos', dadX, dadY - ofs)
                end
                if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos', dadX, dadY + ofs)
                end
            else
                triggerEvent('Camera Follow Pos', dadX, dadY)
                
                if getProperty('dad.animation.curAnim.name') == 'benotafraid' then
                    triggerEvent('Camera Follow Pos', dadX- 50, dadY)
                end
            end

            if curFocus ~= "dad" then 
                setProperty('defaultCamZoom', 1.2) 
                curFocus = "dad"
            end
            
            if gfSection == true then
                local gfX, gfY = getCharacterPos('gf')
                if getProperty('gf.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos', gfX - ofs, gfY)
                end
                if getProperty('gf.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos', gfX + ofs, gfY)
                end
                if getProperty('gf.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos', gfX, gfY - ofs)
                end
                if getProperty('gf.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos', gfX, gfY + ofs)
                end
                if getProperty('gf.animation.curAnim.name'):find('alt') or getProperty('gf.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos', gfX, gfY)
                end
            end
        else
            local bfX, bfY = getCharacterPos('boyfriend')
            if getProperty('boyfriend.animation.curAnim.name'):find('sing') then
                if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos', bfX - ofs, bfY)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos', bfX + ofs, bfY)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos', bfX, bfY - ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos', bfX, bfY + ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name'):find('miss') then
                   triggerEvent('Camera Follow Pos', bfX, bfY) 
                end
            else
                triggerEvent('Camera Follow Pos', bfX, bfY)
            end

            if curFocus ~= "boyfriend" then 
                setProperty('defaultCamZoom', 0.95) 
                curFocus = "boyfriend"
            end
        end
    else
        if cutscene then
            setProperty('isCameraOnForcedPos', true)
        else
            triggerEvent('Camera Follow Pos', '755', '722')
        end
    end
end

function onStepHit()
    if curStep == 16 then
        local bfX, bfY = getCharacterPos('boyfriend')
        setProperty('camFollow.x', bfX)
        setProperty('camFollow.y', bfY - 1000)

        setProperty('defaultCamZoom', 1)
    end

    if curStep == 64 then
        local bfX, bfY = getCharacterPos('boyfriend')
        doTweenY('camFollow', 'camFollow', bfY, 4, 'quadInOut')
    end

    if curStep == 112 then
        setProperty('defaultCamZoom', 0.95)
    end

    if curStep == 127 then
        followchars = true
        setProperty('cameraSpeed', 2)
        cutscene = false
    end

    if curStep >= 655 then
        followchars = false
    end
end

function onEvent(e, v1, v2)
    if e == "Set Property" and (v1 == "dad.cameraPosition[0]" or v1 == "dad.cameraPosition[1]") then
        local dadX, dadY = getCharacterPos('dad')
        triggerEvent('Camera Follow Pos', dadX, dadY)
    end
end