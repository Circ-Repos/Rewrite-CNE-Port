
-- origin point of window
local windowOriginX = 0
local windowOriginY = 0

--points to shake window at
local windowShakeX = 0
local windowShakeY = 0

-- just putting my screen resolution in there for now lol, game should pull the values onCreate anyway
local maxWidth = 1920
local maxHeight = 1080

local windowLock = true -- bit of a trick, but essentally if this is true, the window will always be centered, helps with some resize transitions, but toggbleable if i need to tween it to other places :D

local ableToPause = true
local pauseOverride = false

local startSong = false

local shakeLevelMin = -30
local shakeLevelMax = 30 -- for shaking tweens

local lockShakeX = false

local allowZoom = true

-- JUST IN CASE LOW-END PC'S CAN'T HANDLE SOME PARTS AND STEPS GET SKIPPED
local safetyNet1 = false
local safetyNet2 = false
local safetyNet3 = false
local safetyNet4 = false
local safetyNet5 = false
local safetyNet6 = false
local safetyNet7 = false
local safetyNet8 = false

local noteCheck = false -- puts the notes on the premade camNotes, only do this for the fullscreen segment or this will look horrid

local final = false

local rewriteGameOver = false

local endFutureSpin = false

local loadPixelGameOver = false
local loadFirstPersonGameOver = false

local noFlashingBadNaughty = false

local lockEnd = false
--

function onStartCountdown()
    if not startSong then -- the 4:3 code wOAAAHHH
        runTimer('loadBuffer', 0.5)

		windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y')

        setVar('windowOriginXPublic', windowOriginX) -- for that one majin custom event
        setVar('windowOriginYPublic', windowOriginY)

        --setPropertyFromClass('openfl.Lib', 'application.window.borderless', true) -- depends if springless actually wants this...
        return Function_Stop;
    else
        return Function_Continue;
    end
end

function onCreate()
    addHaxeLibrary("Lib", "openfl"); -- the usual import for this stuff
    setTextString("botplayTxt", "") -- reminder to remove this line after im done testing shit lol
    setProperty('displayName', 'Trinity')
    setProperty("skipCountdown", true)

    precacheImage("characters/bf")
    precacheImage("characters/bf-dead")
    precacheImage("characters/bfyeah")
    precacheImage("characters/god")
    precacheImage("characters/Lordx-legacy")
    precacheImage("characters/Lordxi")
    precacheImage("characters/Majin-legacy")
    precacheImage("characters/majinexe")
    precacheImage("characters/rewrite")
    precacheImage("characters/rewritego")
    precacheImage("characters/rewriteomen")
    precacheImage("characters/rewritespr")
    precacheImage("characters/Sonicexe")
    precacheImage("Red") 

    makeAnimatedLuaSprite("intro", "trinityLegacyIntro", 230, 0)
    addAnimationByPrefix("intro", "intro", "legacyintro", 15, false)
    playAnim("intro", "intro", false, false, 0)
    scaleObject('intro', 3.22, 3.22)
    setObjectCamera("intro", "other")
    setProperty("intro.antialiasing", false)
    setProperty("intro.alpha", 0.0001)
    addLuaSprite("intro", false)

    --not 100% sure the precaching is needed but doing so anyway
end

function onCreatePost()

    setProperty('scoreTxt.visible', false)
    setProperty('showRating', false)
    setProperty('showComboNum', false)
    setProperty('showCombo', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('healthBar.alpha', 0)
    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    setProperty("camGame.alpha", 0.001)
    setProperty("camHUD.alpha", 0.001)

    makeAnimatedLuaSprite("lxJump", "lxJump", 0, 0)
    addAnimationByPrefix("lxJump", "dark", "dark", 1, true)
    addAnimationByPrefix("lxJump", "scary", "scary", 1, true)
    playAnim("lxJump", "dark")
    scaleObject('lxJump', 3.22, 3.22)
    screenCenter("lxJump")
    setObjectCamera("lxJump", "other")
    setProperty("lxJump.alpha", 0.001)
    setProperty("lxJump.antialiasing", false)
    addLuaSprite("lxJump", true)

    if songVariation == "remixed" then
        makeAnimatedLuaSprite("future", "future", 0, 720)
        addAnimationByPrefix('future', 'future', 'future', 1, false)
        addAnimationByPrefix('future', 'spin', 'spin', 30, true)
        playAnim("future", "spin", true, false, 0)
        setProperty("future.antialiasing", false)
        scaleObject("future", 8, 8)
        setObjectCamera("future", 'hud')
        addLuaSprite("future", false)
        screenCenter("future", 'X')
    end

        makeAnimatedLuaSprite("SEGA", "trinityRemixSEGA", 0, 0)
        addAnimationByPrefix('SEGA', 'flash', 'flash', 30, false)
        addAnimationByPrefix('SEGA', 'SEGAChant', 'sega', 5, false)
        addAnimationByPrefix('SEGA', 'glitch', 'glitch', 24, true)
        addAnimationByPrefix('SEGA', 'fadeOut', 'fadeOut', 10, false)
        addAnimationByPrefix('SEGA', 'temp', 'sega', 15, false)
        playAnim("SEGA", "temp", false, false, 0)
        setProperty("SEGA.antialiasing", false)
        setProperty('SEGA.alpha', 0.001)
        scaleObject("SEGA", 3.22, 3.22)
        setObjectCamera("SEGA", 'other')
        screenCenter("SEGA", 'XY')
        addLuaSprite("SEGA", false)


    runHaxeCode([[
        FlxG.scaleMode = PlayState.getRatioScaleMode();
        FlxG.resizeGame(820, 720);
        FlxG.resizeWindow(820, 720);
    ]]);
    
    runHaxeCode([[
		FlxG.game.setFilters([]);

		var stage = Lib.current.stage;
		var resolutionX = 0;
		var resolutionY = 0;

		if (stage.window != null)
		{
			var display = stage.window.display;

			if (display != null)
			{
				resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
				resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
			}
		}

		if(resolutionX <= 0){
			resolutionX = stage.stageWidth;
			resolutionY = stage.stageHeight;
		}

	Lib.application.window.x = (resolutionX - Lib.application.window.width)/2;
	Lib.application.window.y = (resolutionY - Lib.application.window.height)/2;

    Lib.application.window.title = "VS Rewrite";
	]]); -- this centers the window to the monitor it's on
end

function onSongStart()
	for i = 0,3 do
	    noteTweenX(i..'mid',i+4,screenWidth/2+(110*(i-2)+175),0.01, 'linear')
	end

    for i=0,3 do
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 0.3)
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 4-7)
    end

    windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
    windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y') -- grabs the origin point of the window after it's centred

    runTimer('lolecksdee', 0.01)
    playAnim("intro", "intro", true, false, 0)
    setProperty("intro.alpha", 1)
end

function onEvent(e, v1, v2)
    if e == "Change Character" and v2 == "rewritespr" then
        setPropertyFromClass("substates.GameOverSubstate", "characterName", "nobody")
        setPropertyFromClass("substates.GameOverSubstate", "deathSoundName", "silence")
        setPropertyFromClass("substates.GameOverSubstate", "loopSoundName", "silence")
        setPropertyFromClass("substates.GameOverSubstate", "endSoundName", "silence")

        loadFirstPersonGameOver = false
        loadPixelGameOver = true
    end

    if e == "Change Character" and v2 == "god" then
        loadFirstPersonGameOver = true
    end
end

function noteMiss(index, noteDir, noteType, isSustainNote)
    if noteType == 'No Animation' then
        triggerEvent('Play Animation', 'singUPmiss', 'bf')
    end
end

function onTimerCompleted(tag, loops, loopsLeft)

    if tag == 'lolecksdee' then
        setProperty("camGame.alpha", 1)
        setProperty("camHUD.alpha", 1)
    end

    if tag == 'loadBuffer' then --not really needed anymore cuz of the new window code, but more of a precaution to avoid weird loading issues
        doTweenX('camGameX', 'camGame', -230, 0.01, 'quadOut')
        doTweenX('camHUDX', 'camHUD', -230, 0.01, 'quadOut')
        doTweenX('camOtherX', 'camOther', -230, 0.01, 'quadOut')
        doTweenX('camVideoX', 'camVideo', -230, 0.01, 'bounceOut')

        setProperty('defaultCamZoom', 0.75)
        setProperty("camGame.zoom", 0.75)
        setProperty("cameraSpeed", 1)
        -- I KNOW WHAT YOU'RE THINKING, PLEASE DONT CHANGE THE ACTUAL STAGE JSON, THE GAMEOVER SUBSTATE DEPENDS ON IT SO I HAD TO DO THIS JANK SHIT OOF -snow

        playSound("begin", 1)
        
        makeLuaSprite("trinityTitle", "titleCard/trinityPlaceHolder", 230, 0)
        setProperty("trinityTitle.antialiasing", false)
        scaleObject("trinityTitle", 3.25, 3.25)
        setObjectCamera("trinityTitle", 'other')
        setProperty("trinityTitle.alpha", 0)
        addLuaSprite("trinityTitle", false)
        doTweenAlpha("trinityTitle", "trinityTitle", 1, 0.3, "sineOut")

        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        end

        runTimer('fadeitOut', 2)
        runTimer('startSong', 3)

        runHaxeCode([[
            FlxG.game.setFilters([]);
    
            var stage = Lib.current.stage;
            var resolutionX = 0;
            var resolutionY = 0;
    
            if (stage.window != null)
            {
                var display = stage.window.display;
    
                if (display != null)
                {
                    resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
                    resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
                }
            }
    
            if(resolutionX <= 0){
                resolutionX = stage.stageWidth;
                resolutionY = stage.stageHeight;
            }
    
        Lib.application.window.x = (resolutionX - Lib.application.window.width)/2;
        Lib.application.window.y = (resolutionY - Lib.application.window.height)/2;

        Lib.application.window.title = "VS Rewrite";
        ]]); -- because sometimes it's not centering??? so essentially forcing it here
    end

    if tag == 'fadeitOut' then
        doTweenAlpha("trinityTitle", "trinityTitle", 0, 0.3, "sineOut")
    end

    if tag == 'startSong' then
        startSong = true
        startCountdown()
    end
end

function onUpdate(elapsed)
    if not allowZoom then
        setProperty("camZooming", false)
    end

    if curStep < 2776 and not final then
        setScrollFactor('dad', 0.5, 0.8)
    elseif curStep >= 2776 and not final then
        setScrollFactor('dad', 0.8, 1.0)
    end

    if final then
        setScrollFactor('dad', 1.0, 1.0)
    end

    if getProperty('future.animation.curAnim.curFrame') == 0 then
        if getProperty('future.animation.curAnim.name') == 'spin' and endFutureSpin then
            playAnim("future", "future", true, false, 0)
        end
    end

    if getProperty('intro.animation.curAnim.curFrame') == 130 then
        if not flashingLights and not noFlashingBadNaughty then
            runHaxeCode('game.getLuaObject("intro").animation.stop();')
            noFlashingBadNaughty = true
        end
    end
end

function onStepHit()
    if curStep == 96 then
        if flashingLights then
            cameraFlash("camOther", "EDFCD5", 1.5, true)
        end
        removeLuaSprite('intro')
    end

    if curStep == 383 then
        setProperty("cameraSpeed", 5)
    end

    if curStep == 374 then
        if songVariation == "remixed" then
            doTweenY("future", "future", 200, 0.4, "quadOut")
        end
    end

    if curStep == 378 then
        if songVariation == "remixed" then
            doTweenY("future", "future", 330, 0.2, "quadIn")
        end
    end

    if curStep == 379 then
        if songVariation == "remixed" then
            endFutureSpin = true
        end
    end

    if curStep == 384 then
        allowZoom = false
        if flashingLights then
            cameraFlash("camHUD", "FF0000", 0.25, true)
        end
        if songVariation == "remixed" then
            setProperty("future.visible", false)
        end
        setProperty('camGame.zoom', 1.2)
        doTweenZoom("camGame", "camGame", 0.85, 0.75, "quadOut")
        triggerEvent('Camera Follow Pos', getMidpointX('dad')+getProperty('dad.cameraPosition[0]') - 75, getMidpointY('dad')+getProperty('dad.cameraPosition[1]') - 50);
    end

    if curStep == 394 then
        doTweenZoom("camGame", "camGame", 1, 0.25, "quadOut")
        triggerEvent('Camera Follow Pos', getMidpointX('boyfriend')+getProperty('boyfriend.cameraPosition[0]') - 1500, getMidpointY('boyfriend')+ getProperty('boyfriend.cameraPosition[1]'));
    end

    if curStep == 400 then
        triggerEvent('Camera Follow Pos', nil, nil)
        doTweenZoom("camGame", "camGame", 0.75, 0.5, "quadOut")
    end

    if curStep == 404 then
        setProperty("cameraSpeed", 1)
        allowZoom = true
    end

    if curStep == 377 then
        setProperty("cameraSpeed", 5)
    end

    if curStep == 768 then
        if flashingLights then
            cameraFlash("camGame", "FF0000", 0.5, true)
        end

        allowZoom = false
        setProperty('camGame.zoom', 1.2)
        doTweenZoom("camGame", "camGame", 0.8, 6, "quadInOut")

        triggerEvent('Camera Follow Pos', getMidpointX('dad')+getProperty('dad.cameraPosition[0]') - 150, getMidpointY('dad')+getProperty('dad.cameraPosition[1]') - 50);
    end

    if curStep == 831 then
        setProperty("cameraSpeed", 1)
    end

    if curStep == 832 then
        allowZoom = true
        triggerEvent('Camera Follow Pos', nil, nil)
    end

    if curStep == 1024 then
        cameraFade("camHUD", "100410", 0.001, true)
    end

    if curStep == 1056 then
        callMethod('camHUD.fade', {0x100410, 3, true}) -- cuz cameraFade wants to be a wanker
    end

    if curStep == 1561 then
        setProperty("lxJump.alpha", 1)
    end

    if curStep == 1564 then
        setProperty("FlxG.camera.alpha", 0.001)
        playAnim("lxJump", "scary", true)
    end

    if curStep == 1568 then
        setProperty("lxJump.alpha", 0.001)
        setProperty("FlxG.camera.alpha", 1)
        if flashingLights then
            cameraFlash("camGame", "490D49", 0.5, true)
        end
    end

    if curStep == 1888 then
        if flashingLights then
            cameraFlash("camGame", "FF0000", 0.5, true)
        end
    end

    if curStep == 1920 then
        if flashingLights then
            cameraFlash("camGame", "FF0000", 0.5, true)
        end
    end

    if curStep == 2192 then
        if flashingLights then
            cameraFlash("camGame", "000000", 0.5, true)
        end
    end

    if curStep == 2768 then
        setProperty("cameraSpeed", 3)
    end

    if curStep == 2798 then
        setProperty('defaultCamZoom', 0.9)
        setProperty('camGame.zoom', 0.9)

        final = true
    end

    if curStep >= 2864 then
        rewriteGameOver = true
    end

    if curStep == 3502 then
        playAnim("SEGA", "flash", true, false, 0)
        setProperty('SEGA.alpha', 1)
    end

    if curStep == 3506 then
        playAnim("SEGA", "SEGAChant", true, false, 0)
    end

    if curStep >= 3528 and not safetyNet1 then
        if flashingLights then
            playAnim("SEGA", "glitch", true, false, 0)
        end
        safetyNet1 = true
    end

    if curStep >= 3534 and not safetyNet2 then
        playAnim("SEGA", "fadeOut", true, false, 0)
        cameraFade("camOther", "270727", 0.25, true)
        cameraFade("camHUD", "270727", 0.25, true)
        cameraFade("camGame", "270727", 0.25, true)
        safetyNet2 = true
    end

    if curStep >= 3538 and not safetyNet3 then
        setProperty('SEGA.alpha', 0)

        setProperty("remixBG.alpha", 0)
		setProperty('trippyBG.alpha', 0)
        callMethod('camOther.fade', {0x270727, 0.0001, true})
        setProperty('cameraSpeed', 999)
        safetyNet3 = true
    end

    if curStep == 3667 then
        setProperty('isCameraOnForcedPos', true)
        setProperty('camFollow.x', 750)
        setProperty('camFollow.y', 950)

        scaleObject('dad', 12, 12)
        setProperty('dad.y', 1500)
        triggerEvent('Play Animation', 'jump', 'dad')
    end

    if curStep == 3680 then
        doTweenX("dadScale1", "dad.scale", 4, 1.5, "linear")
        doTweenY("dadScale2", "dad.scale", 4, 1.5, "linear")
        doTweenY("dadY", "dad", 500, 0.75, "quadOut")
    end

    if curStep == 3688 then
        cancelTween('dadY')
        doTweenY("dadY2", "dad", 800, 0.75, "quadIn")
    end

    if curStep >= 3976 and not safetyNet4 then
        setProperty("dad.visible", false)
        setProperty("camHUD.visible", false)
        setProperty('pixelBG.alpha', 0)
        safetyNet4 = true
    end
end

function onBeatHit()
    if curBeat >= 700 and curBeat < 716 then
        triggerEvent("Add Camera Zoom", '0.015', '0.03')
    end

        if curBeat >= 812 and curBeat < 875 then
            triggerEvent("Add Camera Zoom", '0.015', '0.03')
        end
end

function onGameOver()
    if not loadPixelGameOver or not loadFirstPersonGameOver then
        setProperty('defaultCamZoom', 1.1)
        setProperty("camGame.zoom", 1.1)
        setPropertyFromClass('openfl.Lib', 'application.window.title', "RETRY?")
    end
        
    if loadFirstPersonGameOver then
        lockEnd = true
        setVar('lockEnd', lockEnd)
        addLuaScript('scripts/gameOvers/legacyFirstPerson', false)
        return Function_Stop
    end
    
    if loadPixelGameOver then
        addLuaScript('scripts/gameOvers/legacyPixel', false)
    end
end

function onGameOverStart()
    if not loadPixelGameOver then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "RETRY?")
    end
end

function onDestroy()

    setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
    setPropertyFromClass('openfl.Lib', 'application.window.opacity', 1)

    runHaxeCode([[
        FlxG.scaleMode = PlayState.getStageSizeScaleMode();
        FlxG.resizeGame(1280, 720);
        FlxG.resizeWindow(1280, 720);
    ]]);


    runHaxeCode([[
		FlxG.game.setFilters([]);

		var stage = Lib.current.stage;
		var resolutionX = 0;
		var resolutionY = 0;

		if (stage.window != null)
		{
			var display = stage.window.display;

			if (display != null)
			{
				resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
				resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
			}
		}

		if(resolutionX <= 0){
			resolutionX = stage.stageWidth;
			resolutionY = stage.stageHeight;
		}

	Lib.application.window.x = (resolutionX - Lib.application.window.width)/2;
	Lib.application.window.y = (resolutionY - Lib.application.window.height)/2;

    Lib.application.window.title = "VS Sonic";
	]]); -- this centers the window to the monitor it's on
end

function onEndSong()
    if lockEnd then
        return Function_Stop
    end
end