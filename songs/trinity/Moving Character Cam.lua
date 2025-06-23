local ofs = 25
local followchars = true
local del = 0
local del2 = 0

local isFullscreen = false

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

function onStepHit()
    if not isFullscreen then
        if curStep >= 2520 and curStep <= 2848 then
            ofs = 12
        else
            ofs = 25
        end
    else
        ofs = 0
    end

    if curStep >= 3568 then
        isFullscreen = true
        followchars = false
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
        if mustHitSection == false then
            local dadX, dadY = getCharacterPos('dad')
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
            if getProperty('dad.animation.curAnim.name'):find('alt') or getProperty('dad.animation.curAnim.name') == 'idle' or getProperty('dad.animation.curAnim.name') == 'danceLeft' then
                triggerEvent('Camera Follow Pos', dadX, dadY)
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
        end
    else
        triggerEvent('Camera Follow Pos', '756.9', '722.2') -- fullscreen part
    end
end
