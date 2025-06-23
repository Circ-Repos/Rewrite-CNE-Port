function onCreate()
	makeLuaSprite('sky','tgeBG/sky', 100, -120)
	setScrollFactor('sky', 0.2, 0.2)
	scaleObject('sky', 3, 3);
    setProperty('sky.antialiasing', false);
    setProperty('sky.alpha', 1);

	makeLuaSprite('mountains','tgeBG/mountains', -20, 0)
	setScrollFactor('mountains', 0.5, 0.5)
	scaleObject('mountains', 3.8, 3.8);
    setProperty('mountains.antialiasing', false);
    setProperty('mountains.alpha', 1);
	
	makeLuaSprite('farLayer','tgeBG/farLayer', 100, 270)
	setScrollFactor('farLayer', 0.6, 0.6)
	scaleObject('farLayer', 3.22, 3.22);
    setProperty('farLayer.antialiasing', false);
    setProperty('farLayer.alpha', 1);

	makeLuaSprite('backLayer','tgeBG/backLayer', 65, 350)
	setScrollFactor('backLayer', 0.8, 0.8)
	scaleObject('backLayer', 3.22, 3.22);
    setProperty('backLayer.antialiasing', false);
    setProperty('backLayer.alpha', 1);

	makeLuaSprite('frontLayer','tgeBG/frontLayer', 80, 440)
	setScrollFactor('frontLayer', 1, 1)
	scaleObject('frontLayer', 3.22, 3.22);
    setProperty('frontLayer.antialiasing', false);
    setProperty('frontLayer.alpha', 1);

    addLuaSprite('sky', false)
    addLuaSprite('mountains', false)
    addLuaSprite('farLayer', false)
    addLuaSprite('backLayer', false)
    addLuaSprite('frontLayer', false)

    -- path chooser

    makeLuaSprite('bg','', 0, 0)
    makeGraphic('bg', 1, 1, '070727')
    setScrollFactor('bg', 0, 0)
	scaleObject('bg', 2000, 2000)
    setProperty('bg.antialiasing', false)
    setProperty('bg.alpha', 0.001)
    addLuaSprite('bg', false)

    makeLuaSprite('trees','tgeBG/trees', 250, 440)
    setScrollFactor('trees', 0.8, 0.8)
	scaleObject('trees', 2, 2)
    setProperty('trees.antialiasing', false)
    setProperty('trees.alpha', 0.001)
    addLuaSprite('trees', false)

    makeLuaSprite('floor','tgeBG/floor', 230, 525)
	scaleObject('floor', 2, 2)
    setProperty('floor.antialiasing', false)
    setProperty('floor.alpha', 0.001)
    addLuaSprite('floor', false)

    -- trippy bg from trinity lol
    makeAnimatedLuaSprite("trippyBG", "trippyBG", 0, 0)
    addAnimationByPrefix("trippyBG", "trippyBG", "trippyBG", 15, true)
    setProperty('trippyBG.antialiasing', false)
    setProperty('trippyBG.alpha', 0.001)
    setScrollFactor('trippyBG', 0, 0)
    addLuaSprite('trippyBG', false)
    scaleObject("trippyBG", 6, 6)
    
    if not flashingLights then
        setProperty('trippyBG.visible', false)
    end
end

function onSongStart()
    playAnim('dad', 'idle', false, false, 0)
end

function onStepHit()
    if curStep == 432 then
        setProperty("sky.visible", false)
        setProperty("mountains.visible", false)
        setProperty("farLayer.visible", false)
        setProperty("backLayer.visible", false)
        setProperty("frontLayer.visible", false)

        setProperty('trees.alpha', 1)
        setProperty('floor.alpha', 1)
        setProperty('bg.alpha', 1)
    end

    if curStep == 656 then
        setProperty('trippyBG.alpha', 1)
    end
end