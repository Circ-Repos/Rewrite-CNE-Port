-- this is a seperate script because my main one is getting reeaaallly fucking full
-- so this is mostly for my sanity, lol -snow

local loadProperlyPls = false

local secondHalf = false

function onCreate()
    if lowQuality then
        close(); -- basically fucking load nothing, lol
    end

    precacheImage("desktopElements")

    initLuaShader("glitch")
end

function onCreatePost()

    --corners
    makeAnimatedLuaSprite("desktopTree1", "desktopElements", -200, 1000)
    addAnimationByPrefix("desktopTree1", "desktopTree", "tree", 15, true)
    setProperty('desktopTree1.antialiasing', false)
    setProperty('desktopTree1.alpha', 0.001)
    setProperty('desktopTree1.angle', 33)
    setScrollFactor("desktopTree1", 0.0, 0.0)
    scaleObject("desktopTree1", 2.5, 2.5)
    addLuaSprite('desktopTree1', true)

    makeAnimatedLuaSprite("desktopTree1b", "desktopElements", -300, 1000)
    addAnimationByPrefix("desktopTree1b", "desktopTree", "tree", 15, true)
    setProperty('desktopTree1b.antialiasing', false)
    setProperty('desktopTree1b.alpha', 0.001)
    setProperty('desktopTree1b.angle', 10)
    setScrollFactor("desktopTree1b", 0.0, 0.0)
    scaleObject("desktopTree1b", 2.5, 2.5)
    addLuaSprite('desktopTree1b', true)

    makeAnimatedLuaSprite("desktopTree2", "desktopElements", 1300, -1000)
    addAnimationByPrefix("desktopTree2", "desktopTree", "tree", 15, true)
    setProperty('desktopTree2.antialiasing', false)
    setProperty('desktopTree2.alpha', 0.001)
    setProperty('desktopTree2.angle', 205)
    setProperty('desktopTree2.flipX', true)
    setScrollFactor("desktopTree2", 0.0, 0.0)
    scaleObject("desktopTree2", 2.5, 2.5)
    addLuaSprite('desktopTree2', true)

    makeAnimatedLuaSprite("desktopPillar1", "desktopElements", -100, -1000)
    addAnimationByPrefix("desktopPillar1", "desktopPillar", "pillar", 15, true)
    setProperty('desktopPillar1.antialiasing', false)
    setProperty('desktopPillar1.alpha', 0.001)
    setProperty('desktopPillar1.angle', 100)
    setScrollFactor("desktopPillar1", 0.0, 0.0)
    scaleObject("desktopPillar1", 2.5, 2.5)
    addLuaSprite('desktopPillar1', true)

    makeAnimatedLuaSprite("desktopPillar2", "desktopElements", 1275, 1000)
    addAnimationByPrefix("desktopPillar2", "desktopPillar", "pillar", 15, true)
    setProperty('desktopPillar2.antialiasing', false)
    setProperty('desktopPillar2.alpha', 0.001)
    setProperty('desktopPillar2.angle', 350)
    setScrollFactor("desktopPillar2", 0.0, 0.0)
    scaleObject("desktopPillar2", 2.5, 2.5)
    addLuaSprite('desktopPillar2', true)

    --eyes
    makeAnimatedLuaSprite("desktopEyes1", "desktopElements", 100, 500)
    addAnimationByPrefix("desktopEyes1", "desktopEye", "eye", 15, false)
    addAnimationByPrefix("desktopEyes1", "desktopEyeClose", "eye", 15, false)
    setProperty('desktopEyes1.antialiasing', false)
    setProperty('desktopEyes1.alpha', 0.001)
    setScrollFactor("desktopEyes1", 0.0, 0.0)
    scaleObject("desktopEyes1", 2.5, 2.5)
    addLuaSprite('desktopEyes1', true)

    makeAnimatedLuaSprite("desktopEyes2", "desktopElements", 300, 700)
    addAnimationByPrefix("desktopEyes2", "desktopEye", "eye", 15, false)
    addAnimationByPrefix("desktopEyes2", "desktopEyeClose", "eye", 15, false)
    setProperty('desktopEyes2.antialiasing', false)
    setProperty('desktopEyes2.alpha', 0.001)
    setScrollFactor("desktopEyes2", 0.0, 0.0)
    scaleObject("desktopEyes2", 2.5, 2.5)
    addLuaSprite('desktopEyes2', true)

    makeAnimatedLuaSprite("desktopEyes3", "desktopElements", 1000, 100)
    addAnimationByPrefix("desktopEyes3", "desktopEye", "eye", 15, false)
    addAnimationByPrefix("desktopEyes3", "desktopEyeClose", "eye", 15, false)
    setProperty('desktopEyes3.antialiasing', false)
    setProperty('desktopEyes3.alpha', 0.001)
    setScrollFactor("desktopEyes3", 0.0, 0.0)
    scaleObject("desktopEyes3", 2.5, 2.5)
    addLuaSprite('desktopEyes3', true)

    setObjectOrder("desktopEyes1", getObjectOrder("dadGroup")+8)
    setObjectOrder("desktopEyes2", getObjectOrder("dadGroup")+8)
    setObjectOrder("desktopEyes3", getObjectOrder("dadGroup")+8)

    -- bird

    makeAnimatedLuaSprite("desktopBird1", "desktopElements", -500, 500)
    addAnimationByPrefix("desktopBird1", "desktopBird", "bird", 15, true)
    setProperty('desktopBird1.antialiasing', false)
    setProperty('desktopBird1.alpha', 1)
    setScrollFactor("desktopBird1", 0.0, 0.0)
    scaleObject("desktopBird1", 2.5, 2.5)
    addLuaSprite('desktopBird1', false)

    makeAnimatedLuaSprite("desktopBird2", "desktopElements", 1700, 0)
    addAnimationByPrefix("desktopBird2", "desktopBird", "bird", 15, true)
    setProperty('desktopBird2.antialiasing', false)
    setProperty('desktopBird2.flipX', true)
    setProperty('desktopBird2.alpha', 1)
    setScrollFactor("desktopBird2", 0.0, 0.0)
    scaleObject("desktopBird2", 2.5, 2.5)
    addLuaSprite('desktopBird2', false)

    makeAnimatedLuaSprite("desktopBird2", "desktopElements", -500, 250)
    addAnimationByPrefix("desktopBird2", "desktopBird", "bird", 15, true)
    setProperty('desktopBird2.antialiasing', false)
    setProperty('desktopBird2.flipX', true)
    setProperty('desktopBird2.alpha', 1)
    setScrollFactor("desktopBird2", 0.0, 0.0)
    scaleObject("desktopBird2", 2.5, 2.5)
    addLuaSprite('desktopBird2', false)

    makeAnimatedLuaSprite("desktopBird3", "desktopElements", -500, 250)
    addAnimationByPrefix("desktopBird3", "desktopBird", "bird", 15, true)
    setProperty('desktopBird3.antialiasing', false)
    setProperty('desktopBird3.alpha', 1)
    setScrollFactor("desktopBird3", 0.0, 0.0)
    scaleObject("desktopBird3", 2.5, 2.5)
    addLuaSprite('desktopBird3', false)

    -- watchers

    makeAnimatedLuaSprite("desktopWatcher1", "desktopElements", 0, 1000)
    addAnimationByPrefix("desktopWatcher1", "desktopWatcher", "watcher", 15, true)
    setProperty('desktopWatcher1.antialiasing', false)
    setProperty('desktopWatcher1.alpha', 1)
    setScrollFactor("desktopWatcher1", 0.0, 0.0)
    scaleObject("desktopWatcher1", 2, 2)
    addLuaSprite('desktopWatcher1', false)

    makeAnimatedLuaSprite("desktopWatcher2", "desktopElements", 900, 1000)
    addAnimationByPrefix("desktopWatcher2", "desktopWatcher", "watcher", 15, true)
    setProperty('desktopWatcher2.antialiasing', false)
    setProperty('desktopWatcher2.alpha', 1)
    setScrollFactor("desktopWatcher2", 0.0, 0.0)
    scaleObject("desktopWatcher2", 2, 2)
    addLuaSprite('desktopWatcher2', false)

    if shadersEnabled then
        setSpriteShader("desktopTree1", "glitch")
        setSpriteShader("desktopTree1b", "glitch")
        setSpriteShader("desktopTree2", "glitch")
        setSpriteShader("desktopPillar1", "glitch")
        setSpriteShader("desktopPillar2", "glitch")
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
        setShaderFloat("desktopTree1", "iTime", os.clock())
        setShaderFloat("desktopTree1b", "iTime", os.clock())
        setShaderFloat("desktopTree2", "iTime", os.clock()*2)
        setShaderFloat("desktopPillar1", "iTime", os.clock()*2.5)
        setShaderFloat("desktopPillar2", "iTime", os.clock()*2.3)
    end
end

function onSongStart()
    setObjectOrder("desktopBird1", getObjectOrder("desktopRiftMask")+2)
    setObjectOrder("desktopBird2", getObjectOrder("desktopRiftMask")+2)
    setObjectOrder("desktopBird3", getObjectOrder("desktopRiftMask")+2)

    setObjectOrder("desktopWatcher1", getObjectOrder("desktopRiftMask")+2)
    setObjectOrder("desktopWatcher2", getObjectOrder("desktopRiftMask")+2)

    --setObjectOrder("desktopTree2", getObjectOrder("windowVessel")-1)
    setObjectOrder("desktopTree2", getObjectOrder("rewriteWindowBox")+1)
    
end

function onStepHit()
    if curStep >= 3920 and not loadProperlyPls then
        setProperty('desktopTree1.alpha', 1)
        doTweenY("desktopTree1", "desktopTree1", 550, 1.0, "sineOut")
        doTweenAngle("desktopTreeAngle1", "desktopTree1", 40, 1.5, "sineOut")

        setProperty('desktopTree1b.alpha', 1)
        doTweenY("desktopTree1b", "desktopTree1b", 550, 1.0, "sineOut")
        doTweenAngle("desktopTreeAngle1b", "desktopTree1b", 20, 1.5, "sineOut")

        setProperty('desktopTree2.alpha', 1)
        doTweenY("desktopTree2-1", "desktopTree2", -300, 1.5, "sineOut")
        doTweenAngle("desktopTree2Angle1", "desktopTree2", 215, 1.5, "sineOut")

        setProperty('desktopPillar1.alpha', 1)
        doTweenY("desktopPillar1", "desktopPillar1", -200, 1.35, "sineOut")
        doTweenAngle("desktopPillarAngle1", "desktopPillar1", 115, 1.5, "sineOut")

        setProperty('desktopPillar2.alpha', 1)
        doTweenY("desktopPillar2-1", "desktopPillar2", 500, 1.2, "sineOut")
        doTweenAngle("desktopPillar2Angle1", "desktopPillar2", 355, 1.5, "sineOut")

        runTimer("eyes1Open",getRandomFloat(1.5, 2))
        runTimer("eyes2Open",getRandomFloat(2, 2.5))
        runTimer("eyes3Open",getRandomFloat(2.5, 3))

        runTimer("bird1",getRandomFloat(1, 2))
        runTimer("bird2",getRandomFloat(2, 4))
        runTimer("bird3",getRandomFloat(4, 6))

        runTimer("watcher1",getRandomFloat(4, 6))
        runTimer("watcher2",getRandomFloat(6, 8))
        loadProperlyPls = true
    end

    if curStep == 4128 then

        cancelTimer("eyes1Open")
        cancelTimer("eyes2Open")
        cancelTimer("eyes3Open")
        cancelTimer("eyes1Close")
        cancelTimer("eyes2Close")
        cancelTimer("eyes3Close")

        if getProperty('desktopEyes1.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes1", "desktopEyeClose", true, true)
        end

        if getProperty('desktopEyes2.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes2", "desktopEyeClose", true, true)
        end

        if getProperty('desktopEyes3.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes3", "desktopEyeClose", true, true)
        end
    end

    if curStep == 4112 then
        cancelTimer("bird2")
    end

    if curStep == 4144 then
        cancelTimer("bird1")
        cancelTimer("bird3")
        cancelTimer("watcher1")
        cancelTimer("watcher2")
    end

    if curStep == 4176 then
        --setObjectOrder("desktopTree2", getObjectOrder("rewriteWindowBox")+1)
    end

    if curStep == 4304 then
        cancelTween("desktopTree1")
        cancelTween("desktopTree2")
        cancelTween("desktopTreeAngle1")
        cancelTween("desktopTreeAngle2")

        cancelTween("desktopTree1b")
        cancelTween("desktopTree2b")
        cancelTween("desktopTreeAngle1b")
        cancelTween("desktopTreeAngle2b")

        cancelTween("desktopTree2-1")
        cancelTween("desktopTree2-2")
        cancelTween("desktopTree2Angle1")
        cancelTween("desktopTree2Angle2")

        cancelTween("desktopPillar1")
        cancelTween("desktopPillar2")
        cancelTween("desktopPillarAngle1")
        cancelTween("desktopPillarAngle2")

        cancelTween("desktopPillar2-1")
        cancelTween("desktopPillar2-2")
        cancelTween("desktopPillar2Angle1")
        cancelTween("desktopPillar2Angle2")

        doTweenX("desktopTree1EndX", "desktopTree1", -500, 0.3, "quadIn")
        doTweenY("desktopTree1EndY", "desktopTree1", 1000, 0.3, "quadIn")

        doTweenX("desktopTree1bEndX", "desktopTree1b", -500, 0.3, "quadIn")
        doTweenY("desktopTree1bEndY", "desktopTree1b", 1000, 0.3, "quadIn")

        doTweenX("desktopTree2EndX", "desktopTree2", 1500, 0.3, "quadIn")
        doTweenY("desktopTree2EndY", "desktopTree2", -1000, 0.3, "quadIn")

        doTweenX("desktopPillar1EndX", "desktopPillar1", -500, 0.3, "quadIn")
        doTweenY("desktopPillar1EndY", "desktopPillar1", -1000, 0.3, "quadIn")

        doTweenX("desktopPillar2EndX", "desktopPillar2", 1500, 0.3, "quadIn")
        doTweenY("desktopPillar2EndY", "desktopPillar2", 1000, 0.3, "quadIn")
    end

    if curStep == 4432 then
        secondHalf = true

        runTimer("eyes1Open",getRandomFloat(0.5, 0.75))
        runTimer("eyes2Open",getRandomFloat(0.6, 0.8))
        runTimer("eyes3Open",getRandomFloat(0.7, 1))
    end

    if curStep == 4508 then
        cancelTimer("eyes1Open")
        cancelTimer("eyes2Open")
        cancelTimer("eyes3Open")
        cancelTimer("eyes1Close")
        cancelTimer("eyes2Close")
        cancelTimer("eyes3Close")

        if getProperty('desktopEyes1.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes1", "desktopEyeClose", true, true)
        end

        if getProperty('desktopEyes2.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes2", "desktopEyeClose", true, true)
        end

        if getProperty('desktopEyes3.animation.curAnim.name') == 'desktopEye' then
            playAnim("desktopEyes3", "desktopEyeClose", true, true)
        end
    end
end


function onTimerCompleted(tag, loops, loopsLeft)

    if tag == "watcher1" then
        setProperty("desktopWatcher1.y", 1000)
        doTweenY("desktopWatcher1", "desktopWatcher1", -1000, 3, "linear")
        runTimer("watcher1",getRandomFloat(8, 10))
    end

    if tag == "watcher2" then
        setProperty("desktopWatcher2.y", 1000)
        doTweenY("desktopWatcher2", "desktopWatcher2", -1000, 3, "linear")
        runTimer("watcher2",getRandomFloat(8, 10))
    end

    if tag == "bird1" then
        cancelTween("bird1Up")
        cancelTween("bird1Down")
        cancelTween("bird1X")

        setProperty("desktopBird1.x", -400)
        setProperty("desktopBird1.y", 500)
        doTweenX("bird1X", "desktopBird1", 1700, 5, "linear")
        doTweenY("bird1Down", "desktopBird1", 550, 0.5, "sineOut")

        runTimer("bird1", getRandomFloat(7, 9))
    end

    if tag == "bird2" then
        cancelTween("bird2Up")
        cancelTween("bird2Down")
        cancelTween("bird2X")

        setProperty("desktopBird2.x", 1700)
        setProperty("desktopBird2.y", 0)
        doTweenX("bird2X", "desktopBird2", -500, 5, "linear")
        doTweenY("bird2Down", "desktopBird2", -50, 0.5, "sineOut")

        runTimer("bird2", getRandomFloat(7, 9))
    end

    if tag == "bird3" then
        cancelTween("bird3Up")
        cancelTween("bird3Down")
        cancelTween("bird3X")

        setProperty("desktopBird3.x", -500)
        setProperty("desktopBird3.y", 0)
        doTweenX("bird3X", "desktopBird3", 1700, 5, "linear")
        doTweenY("bird3Down", "desktopBird3", 300, 0.5, "sineOut")

        runTimer("bird3", getRandomFloat(7, 9))
    end

    if tag == "eyes1Open" then
        setProperty("desktopEyes1.x", getRandomInt(-200, 300))
        setProperty("desktopEyes1.y", getRandomInt(200, 700))
        setProperty("desktopEyes1.alpha", 1)
        playAnim("desktopEyes1", "desktopEye", true, false)
        if not secondHalf then
            runTimer("eyes1Close", getRandomFloat(1.5, 3))
        else
            runTimer("eyes1Close", getRandomFloat(1, 2))
        end
    end

    if tag == "eyes1Close" then
        playAnim("desktopEyes1", "desktopEyeClose", true, true)
        if not secondHalf then
            runTimer("eyes1Open", getRandomFloat(3, 6))
        else
            runTimer("eyes1Open", getRandomFloat(1, 2))
        end
    end

    if tag == "eyes2Open" then
        setProperty("desktopEyes2.x", getRandomInt(-100, 600))
        setProperty("desktopEyes2.y", getRandomInt(500, 900))
        setProperty("desktopEyes2.alpha", 1)
        playAnim("desktopEyes2", "desktopEye", true, false)
        if not secondHalf then
            runTimer("eyes2Close", getRandomFloat(1.5, 3))
        else
            runTimer("eyes2Close", getRandomFloat(1, 2))
        end
    end

    if tag == "eyes2Close" then
        playAnim("desktopEyes2", "desktopEyeClose", true, true)
        if not secondHalf then
            runTimer("eyes2Open", getRandomFloat(3, 6))
        else
            runTimer("eyes2Open", getRandomFloat(1, 2))
        end
    end

    if tag == "eyes3Open" then
        setProperty("desktopEyes3.x", getRandomInt(800, 1250))
        setProperty("desktopEyes3.y", getRandomInt(-200, 400))
        setProperty("desktopEyes3.alpha", 1)
        playAnim("desktopEyes3", "desktopEye", true, false)
        if not secondHalf then
            runTimer("eyes3Close", getRandomFloat(1.5, 3))
        else
            runTimer("eyes3Close", getRandomFloat(1, 2))
        end
    end

    if tag == "eyes3Close" then
        playAnim("desktopEyes3", "desktopEyeClose", true, true)
        if not secondHalf then
            runTimer("eyes3Open", getRandomFloat(3, 6))
        else
            runTimer("eyes3Open", getRandomFloat(1, 2))
        end
    end
end

function onTweenCompleted(tag)

    --birds
        if tag == 'bird1Up' then
            doTweenY("bird1Down", "desktopBird1", 550, 1, "sineInOut")
        end

        if tag == 'bird1Down' then
            doTweenY("bird1Up", "desktopBird1", 450, 1, "sineInOut")
        end

        if tag == 'bird2Up' then
            doTweenY("bird2Down", "desktopBird2", 50, 1, "sineInOut")
        end

        if tag == 'bird2Down' then
            doTweenY("bird2Up", "desktopBird2", -50, 1, "sineInOut")
        end

        if tag == 'bird3Up' then
            doTweenY("bird3Down", "desktopBird3", 300, 1, "sineInOut")
        end

        if tag == 'bird3Down' then
            doTweenY("bird3Up", "desktopBird3", 200, 1, "sineInOut")
        end

    ---trees

        if tag == 'desktopTree1' then
            doTweenY("desktopTree2", "desktopTree1", 570, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTree2' then
            doTweenY("desktopTree1", "desktopTree1", 550, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTreeAngle1' then
            doTweenAngle("desktopTreeAngle2", "desktopTree1", 25, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopTreeAngle2' then
            doTweenAngle("desktopTreeAngle1", "desktopTree1", 40, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopTree1b' then
            doTweenY("desktopTree2b", "desktopTree1b", 570, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTree2b' then
            doTweenY("desktopTree1b", "desktopTree1b", 550, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTreeAngle1b' then
            doTweenAngle("desktopTreeAngle2b", "desktopTree1b", 0, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopTreeAngle2b' then
            doTweenAngle("desktopTreeAngle1b", "desktopTree1b", 20, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopTree2-1' then
            doTweenY("desktopTree2-2", "desktopTree2", -340, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTree2-2' then
            doTweenY("desktopTree2-1", "desktopTree2", -320, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopTree2Angle1' then
            doTweenAngle("desktopTree2Angle2", "desktopTree2", 195, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopTree2Angle2' then
            doTweenAngle("desktopTree2Angle1", "desktopTree2", 207, getRandomFloat(1.75, 2), "sineInOut")
        end

    --- pillars

        if tag == 'desktopPillar1' then
            doTweenY("desktopPillar2", "desktopPillar1", -180, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopPillar2' then
            doTweenY("desktopPillar1", "desktopPillar1", -210, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopPillarAngle1' then
            doTweenAngle("desktopPillarAngle2", "desktopPillar1", 80, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopPillarAngle2' then
            doTweenAngle("desktopPillarAngle1", "desktopPillar1", 115, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopPillar2-1' then
            doTweenY("desktopPillar2-2", "desktopPillar2", 520, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopPillar2-2' then
            doTweenY("desktopPillar2-1", "desktopPillar2", 490, getRandomFloat(1, 1.5), "sineInOut")
        end

        if tag == 'desktopPillar2Angle1' then
            doTweenAngle("desktopPillar2Angle2", "desktopPillar2", 340, getRandomFloat(1.75, 2), "sineInOut")
        end

        if tag == 'desktopPillar2Angle2' then
            doTweenAngle("desktopPillar2Angle1", "desktopPillar2", 355, getRandomFloat(1.75, 2), "sineInOut")
        end
end