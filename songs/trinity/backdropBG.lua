--ill be real, pootis did this bit mostly, im just putting it in and making it work, thank u pootis :happywuggy: -snow

function onCreatePost()
    makeLuaBackdrop("lalalaBackground", "lalalaBackground", "XY", 0, 0)

    runHaxeCode([[
        game.getLuaObject("lalalaBackground").frames = Paths.getSparrowAtlas("lalalaBackground");
        game.getLuaObject("lalalaBackground").animation.addByPrefix("temp", "0_", 15, true);
        game.getLuaObject("lalalaBackground").animation.addByPrefix("la", "0_", 15, true);
        game.getLuaObject("lalalaBackground").animation.play("temp");

        game.getLuaObject("lalalaBackground").velocity.set(-500, 500);
        game.getLuaObject("lalalaBackground").alpha = 0.001;
    ]])

    scaleObject('lalalaBackground', 2, 2)

    addLuaBackdrop("lalalaBackground", true)


        makeAnimatedLuaSprite("trippyBG", "trippyBG", 0, 0)
        addAnimationByPrefix("trippyBG", "trippyBG", "trippyBG", 15, true)
        setProperty('trippyBG.antialiasing', false)
        setProperty('trippyBG.alpha', 0.001)
        addLuaSprite('trippyBG', false)
        
        if shadersEnabled then
            setProperty('trippyBG.x', 100)
            setProperty('trippyBG.y', 60)
            scaleObject("trippyBG", 4.75, 4.75)
        else
            setProperty('trippyBG.x', -300)
            setProperty('trippyBG.y', -160)
            scaleObject("trippyBG", 8, 8)
        end
end

function onStepHit()
    if curStep == 4688 then
        setObjectOrder('trippyBG', getObjectOrder('redClouds')+1)
        doTweenAlpha('lalaBG', 'lalalaBackground', 1, 1, 'linear')
        if flashingLights then
            doTweenAlpha('trippyBG', 'trippyBG', 0.5, 0.5, 'linear')
        else
            doTweenAlpha('trippyBG', 'trippyBG', 0.25, 0.5, 'linear')           
        end
        runHaxeCode([[game.getLuaObject("lalalaBackground").animation.play("la");]])
    end

    if curStep == 4748 then
        doTweenAlpha('lalaBG', 'lalalaBackground', 0, 0.4, 'linear')
        doTweenAlpha('trippyBG', 'trippyBG', 0, 0.2, 'linear')
    end
end