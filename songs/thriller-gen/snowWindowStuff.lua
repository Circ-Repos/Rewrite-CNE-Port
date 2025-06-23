-- taken a lot of stuff from trinity for this, but more basic cuz yea no funny window movement here

local canPause = true
local pauseOverride = false

local startSong = false

-- origin point of window
local windowOriginX = 0
local windowOriginY = 0

--points to shake window at
local windowShakeX = 0
local windowShakeY = 0

local windowShaking = false
local shakeLevel = 10

-- JUST IN CASE LOW-END PC'S CAN'T HANDLE SOME PARTS AND STEPS GET SKIPPED
local safetyNet1 = false
local safetyNet2 = false
local safetyNet3 = false

--windowMove
local winSpdX = 3.7
local winSpdY = 2.4

local lastTag = 'bruh'

local brightness = 0.00
local contrast = 1.00
local saturation = 1.00

local stopUpdatingDummy = false
-- so it doesnt keep trying to perform the animation check lmao

local stopZoomingDammit = false

local coolNoteThing = false
local noteHit = { -- the funny window move note press thing
    [0] = function()
        doTweenWindow('windowX', 'x', windowOriginX - 50, 0.001, 'bounceOut',1)
        doTweenWindow('windowX2', 'x', windowOriginX, 0.25, 'quadOut',1)
    end,

    [1] = function()
        doTweenWindow('windowY', 'y', windowOriginY + 50, 0.001, 'bounceOut',1)
        doTweenWindow('windowY2', 'y', windowOriginY, 0.25, 'quadOut',1)
    end,

    [2] = function()
        doTweenWindow('windowY', 'y', windowOriginY - 50, 0.001, 'bounceOut',1)
        doTweenWindow('windowY2', 'y', windowOriginY, 0.25, 'quadOut',1)
    end,

    [3] = function()
        doTweenWindow('windowX', 'x', windowOriginX + 50, 0.001, 'bounceOut',1)
        doTweenWindow('windowX2', 'x', windowOriginX, 0.25, 'quadOut',1)
    end
}

function onStartCountdown()
    if not startSong then -- the 4:3 code wOAAAHHH
        runTimer('loadBuffer', 0.75)

		windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y')

        return Function_Stop;
    else
        return Function_Continue;
    end
end

function onCreate()
    setTextString("botplayTxt", "") -- reminder to remove this line after im done testing shit lol
    setProperty('displayName', 'Thriller Gen (Encore)')
    setProperty('skipCountdown', true) -- go away generic fnf start

	addHaxeLibrary("Lib", "openfl"); -- the usual import for this stuff

    if shadersEnabled then
        initLuaShader("glitch")
        initLuaShader("intenseGlitch")
        initLuaShader('contrast')

        makeLuaSprite("glitchShader")

        setSpriteShader("glitchShader", "intenseGlitch") -- technically the same shader but since it's not a uniform float i can't change it from here, different shader file sadly lol -snow

        -- i tried to make this a uniform shader but i realized that both shaders are used for different cases (intense for camera, regular for opponent) so i will just leave it as is. 
        -- lua is limiting (umm hscript better) so i dont think i can make 2 shader objects using the same shader. -pootis

        makeLuaSprite('contrastShader')
        setSpriteShader('contrastShader', 'contrast')
        setShaderFloat('contrastShader', 'brightness', 0.00)
        setShaderFloat('contrastShader', 'contrast', 1.00)
        setShaderFloat('contrastShader', 'saturation', 1.00)

        makeLuaSprite('brightnessVar')
        setProperty('brightnessVar.x', 0.00)
    
        makeLuaSprite('contrastVar')
        setProperty('contrastVar.x', 1.00)
    
        makeLuaSprite('saturationVar')
        setProperty('saturationVar.x', 1.00)

        runHaxeCode([[
			game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
			game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
		]])
    end

    
    makeLuaSprite('shakeLevelVar')
	setProperty("shakeLevelVar.x", 10)
end

function onCreatePost()
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
	]]); -- this centers the window to the monitor it's on

    setProperty("camGame.alpha", 0.001)
    setProperty("camHUD.alpha", 0.001)
    setProperty("camOther.alpha", 1)

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
    setProperty('camZooming', true)

    --makeAnimatedLuaSprite("SEGA", "menus/title/sega", 230, 0)
    --addAnimationByIndices("SEGA", "SEGA", "sega", "20, 21, 22, 23, 24", 12, true)
    --playAnim("SEGA", "SEGA", true, false, 0)
    makeLuaSprite("SEGA", "spookySega", 230, 0)
    setProperty("SEGA.antialiasing", false)
    scaleObject("SEGA", 3.25, 3.25)
    setObjectCamera("SEGA", 'hud')
    setProperty("SEGA.alpha", 0.001)
    addLuaSprite("SEGA", false)

    makeLuaSprite("red", "", 0, 0)
    makeGraphic('red', 1, 1, 'FF0000') -- making the size tiny cuz' apparently making it too big can cause memory leaks so erm, scaleobject moment
    setBlendMode('red', 'multiply')
    setScrollFactor('red', 0, 0)
    setProperty("red.antialiasing", false)
    scaleObject("red", 1500, 1000)
    setObjectCamera("red", 'game')
    setProperty("red.alpha", 0.001)
    addLuaSprite("red", true)

    makeAnimatedLuaSprite("iAmSonic", "characters/sonicTGE", 250, 50)
    addAnimationByPrefix('iAmSonic', 'iAm', '1iAm', 1, false)
    addAnimationByPrefix('iAmSonic', 'Sonic', '2sonic', 1, false)
    playAnim("iAmSonic", "iAm", true, false, 0)
    setProperty("iAmSonic.antialiasing", false)
    scaleObject("iAmSonic", 3, 3)
    setObjectCamera("iAmSonic", 'other')
    setProperty("iAmSonic.alpha", 0.001)
    addLuaSprite("iAmSonic", false)

    makeLuaSprite("blue", "", 0, 0)
    makeGraphic('blue', 1, 1, '0000FF') -- making the size tiny cuz' apparently making it too big can cause memory leaks so erm, scaleobject moment
    setBlendMode('blue', 'multiply')
    setScrollFactor('blue', 0, 0)
    setProperty("blue.antialiasing", false)
    scaleObject("blue", 1500, 1000)
    setObjectCamera("blue", 'other')
    setProperty("blue.alpha", 0.001)
    addLuaSprite("blue", true)

    makeAnimatedLuaSprite("Outro", "tgeOutro", 230, 0)
    addAnimationByPrefix("Outro", "Outro", "tgo", 15, false)
    setProperty('Outro.alpha', 0.001)
    setProperty('Outro.antialiasing', false)
    setScrollFactor('Outro', 0, 0)
    addLuaSprite("Outro", false)
    scaleObject("Outro", 3.22, 3.22)

    setProperty("cameraSpeed", 999)
end

function onUpdate(elapsed)

    if stopZoomingDammit then
        setProperty("camZooming", false)
    end

    for i=0,3 do
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 0.3)
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 4-7)
    end

    if shadersEnabled then
        setShaderFloat("dad", "iTime", os.clock())

        brightness = getProperty('brightnessVar.x')
        contrast = getProperty('contrastVar.x')
        saturation = getProperty('saturationVar.x')

        setShaderFloat('tgTitle', 'brightness', brightness)
        setShaderFloat('tgTitle', 'contrast', contrast)
        setShaderFloat('tgTitle', 'saturation', saturation)

        setShaderFloat('contrastShader', 'brightness', brightness)
        setShaderFloat('contrastShader', 'contrast', contrast)
        setShaderFloat('contrastShader', 'saturation', saturation)


        setShaderFloat("glitchShader", "iTime", os.clock()*2)
    end

    shakeLevel = getProperty("shakeLevelVar.x")

    if windowFuckery then
        if windowShaking then
            setPropertyFromClass('openfl.Lib','application.window.x', windowShakeX + getRandomFloat(-shakeLevel,shakeLevel))
            setPropertyFromClass('openfl.Lib','application.window.y', windowShakeY + getRandomFloat(-shakeLevel,shakeLevel)) -- could be good for a few scenes, can't do this over video tho, grr
        end
    end

    if getProperty('dad.animation.curAnim.finished') then
        if getProperty('dad.animation.curAnim.name') == 'twitterStinksImLeaving' and not stopUpdatingDummy then
            setProperty('dad.alpha', 0)
            stopUpdatingDummy = true
        end
    end
end


function onSongStart()

    for i = 0,3 do
	    noteTweenX(i..'mid',i+4,screenWidth/2+(110*(i-2)),0.01, 'linear')
	end

    setProperty('dad.alpha', 0)
    setProperty('gf.alpha', 0)

    --setProperty("camHUD.alpha", 1)
    setProperty("camOther.alpha", 1)

    windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
    windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y') -- grabs the origin point of the window after it's centred

    windowShakeX = windowOriginX
    windowShakeY = windowOriginY
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'loadBuffer' then
        doTweenX('camGameX', 'camGame', -230, 0.01, 'quadOut')
        doTweenX('camHUDX', 'camHUD', -230, 0.01, 'quadOut')
        doTweenX('camOtherX', 'camOther', -230, 0.01, 'quadOut')

        playSound("begin", 1)

        makeLuaSprite("tgTitle", "titleCard/thrillerGenPlaceHolder", 230, 0)
        setProperty("tgTitle.antialiasing", false)
        scaleObject("tgTitle", 3.25, 3.25)
        setObjectCamera("tgTitle", 'other')
        setProperty("tgTitle.alpha", 0)
        setSpriteShader('tgTitle', 'contrast')
        addLuaSprite("tgTitle", false)
        doTweenAlpha("tgTitle1", "tgTitle", 1, 0.3, "sineOut")

        setProperty('brightnessVar.x', -2.00)
        setProperty('contrastVar.x', 3.00)
        setProperty('saturationVar.x', 2.00)

        setProperty('blue.alpha', 1)

        doTweenX('brightness', 'brightnessVar', 0, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 1, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.3, 'quadOut')

        doTweenAlpha('blue', 'blue', 0, 0.3, 'quadIn')
        
        runTimer('fadeitOut', 2)
        runTimer('startSong', 3)
    end

    if tag == 'fadeitOut' then
        doTweenAlpha("tgTitle1", "tgTitle", 0, 0.3, "sineOut")

        doTweenX('brightness', 'brightnessVar', -2, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 3, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 2, 0.3, 'quadOut')

        cameraFade("camGame", "000000", 0.01, false, true)

        doTweenAlpha('blue', 'blue', 1, 0.3, 'quadIn')
    end

    if tag == 'startSong' then
        startSong = true
        startCountdown()
    end

    if tag == 'windowDown' then
		doTweenWindow('windowUp', 'y', windowOriginY-120, winSpdY,'sineInOut',1)
		runTimer('windowUp', winSpdY)
	end

	if tag == 'windowUp' then
		doTweenWindow('windowDown', 'y', windowOriginY+120, winSpdY,'sineInOut',1)
		runTimer('windowDown', winSpdY)
	end

	if tag == 'windowRight' then
		doTweenWindow('windowLeft', 'x', windowOriginX-400, winSpdX,'sineInOut',1)
		runTimer('windowLeft', winSpdX)
	end

	if tag == 'windowLeft' then
		doTweenWindow('windowRight', 'x', windowOriginX+400, winSpdX,'sineInOut',1)
		runTimer('windowRight', winSpdX)
	end

    if tag == 'gameCam' then
        setProperty('camGame.visible', true)
    end
end

function onEvent(name, value1, value2)
    if name == "Play Animation" then
        if value1 == "transition" then
            setProperty('gf.x', getProperty('dad.x'))
            setProperty('gf.y', getProperty('dad.y'))
            setProperty('gf.alpha', 1)

            doTweenY('sonicY', 'dad', 300, 0.5, 'quadOut')
            doTweenX('sonicScale', 'dad.scale', 2.7, 0.5, 'quadOut')
            doTweenY('sonicScale2', 'dad.scale', 2.7, 0.5, 'quadOut')

            doTweenY('eyesY', 'gf', 300, 0.5, 'quadOut')
            doTweenX('eyesScale', 'gf.scale', 2.7, 0.5, 'quadOut')
            doTweenY('eyesScale2', 'gf.scale', 2.7, 0.5, 'quadOut')
        end
    end

    if name == "Change Character" and value1 == "bf" and value2 == "bfSCARY" then
        runHaxeCode([[
            game.remove(game.boyfriendGroup);
            game.remove(game.dadGroup);
            game.add(game.boyfriendGroup);
            game.add(game.dadGroup);

            game.boyfriend.x = game.dad.x + 260;
            game.boyfriend.y = game.dad.y + 350;
            game.boyfriend.scale.set(game.dad.scale.x, game.dad.scale.y);
            game.boyfriend.shader = game.dad.shader;

            FlxTween.cancelTweensOf(game.boyfriend);
            game.boyfriend.alpha = game.dad.alpha;
        ]])
    end
end

function onStepHit()
    if curStep == 32 then
        doTweenX('brightness', 'brightnessVar', 0, 0.5, 'quadOut')
        doTweenX('contrast', 'contrastVar', 1, 0.5, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.5, 'quadOut')

        callMethod('camGame.fade', {0x000000, 0.5, true})

        setProperty("camGame.alpha", 1)

        doTweenAlpha('blue', 'blue', 0, 0.6, 'quadIn')
    end

    if curStep == 208 then
        doTweenAlpha("camHUD", "camHUD", 1, 1, "linear")
    end

    --JAPANESE WINDOW LYRICS
    if curStep == 176 then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "マジで")
    end

    if curStep == 184 then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "マジで Dreading?")
    end

    if curStep == 192 then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "それは")
    end
    
    if curStep == 204 then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "それは無駄")
    end

    if curStep == 216 then
        setPropertyFromClass('openfl.Lib', 'application.window.title', "それは無駄だ")
    end
    --

    if curStep == 416 then
        doTweenX('brightness', 'brightnessVar', -0.5, 1.2, 'quadIn')
        doTweenX('contrast', 'contrastVar', 2, 1.2, 'quadIn')
        doTweenX('saturation', 'saturationVar', 2, 1.2, 'quadIn')

        screenFlash()
        triggerEvent('Play Animation', 'miles', 'dad')
    end

    if curStep == 420 then
        screenFlash()
        triggerEvent('Play Animation', 'ekiduna', 'dad')
    end

    if curStep == 424 then
        screenFlash()
        triggerEvent('Play Animation', 'ivo', 'dad')
    end

    if curStep == 428 then
        screenFlash()
        triggerEvent('Play Animation', 'theFunnyBoi', 'dad')
    end

    if flashingLights then
        if curStep == 428 then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 1.00)
        end

        if curStep == 429 then

            setProperty('brightnessVar.x', 1.00)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 2.00)

            setProperty("camGame.visible", false)
            setProperty("camHUD.visible", false)
        end

        if curStep == 430 then
            setProperty("camGame.visible", true)
        end
    end

    if curStep == 431 then
        setProperty("camGame.visible", false)
        setProperty("camHUD.visible", false)
        setProperty("cameraSpeed", 999)

        setProperty('brightnessVar.x', 0.50)
        setProperty('contrastVar.x', 3.00)
        setProperty('saturationVar.x', 4.00)

        setProperty('blue.alpha', 1)
    end

    if curStep == 434 then
        callMethod('camHUD.fade', {0x000000, 0.25, true})
        callMethod('camGame.fade', {0x000000, 0.8, true})
        doTweenAlpha('blue', 'blue', 0, 1.2, 'quadIn')

        setProperty("camGame.visible", true)
        setProperty("camHUD.visible", true)
        setProperty("cameraSpeed", 2)
        setProperty("boyfriend.visible", false)

        setProperty('brightnessVar.x', 0.00)
        setProperty('contrastVar.x', 1.00)
        setProperty('saturationVar.x', 1.00)
    end

    if curStep == 592 then
        doTweenAlpha('hud', 'camHUD', 0, 1, 'quadIn')
    end

    if curStep == 624 then
        --cameraFade("camGame", "000000", 2, false, true)
        doTweenAlpha('floor', 'floor', 0, 2, 'quadOut')
        doTweenAlpha('trees', 'trees', 0, 2, 'quadOut')
        doTweenAlpha('blue', 'blue', 1, 2, 'quadOut')
    end

    if curStep == 646 then
        setProperty("dad.visible", false)
        setProperty("dad.alpha", 0)
        setProperty("boyfriend.visible", false)
        setProperty("camHUD.visible", false)
        setProperty("cameraSpeed", 999)

        setProperty("floor.visible", false)
        setProperty("trees.visible", false)

        -- just in case i skip time
        setProperty("sky.visible", false)
        setProperty("mountains.visible", false)
        setProperty("farLayer.visible", false)
        setProperty("backLayer.visible", false)
        setProperty("frontLayer.visible", false)
    end

    if curStep == 652 then
        playAnim('iAmSonic', 'Sonic', true)
    end

    -- WINDOW MOVEMENT BEGIN

    if curStep >= 656 and not safetyNet1 then
        setProperty('iAmSonic.alpha', 0)
        setProperty("bg.visible", false)
        if shadersEnabled then
            if flashingLights then
                setSpriteShader("dad", "glitch")

                setProperty('brightnessVar.x', 0.50)
                setProperty('contrastVar.x', 2.00)
                setProperty('saturationVar.x', 2.00)
            end

            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader)]);
            ]])
        end

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.3, "linear")

        --scaleObject("dad", 5.0, 5.0)
        setProperty("dad.y", 350)
        setProperty("dad.alpha", 1)
        setProperty("dad.visible", true)

        safetyNet1 = true
    end

    
    if curStep == 659 then
        windowShaking = false

        windowShakeX = windowOriginX + 400
        windowShakeY = windowOriginY - 50
        doTweenWindow('windowX', 'x', windowShakeX, 0.075,'bounceOut',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.075,'quadIn',1)
    end

    if curStep == 660 then
        windowShaking = true

        if flashingLights then
            setProperty('brightnessVar.x', 2.00)
            setProperty('contrastVar.x', 3.00)
            setProperty('saturationVar.x', 3.00)
        end

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.25, "linear")
    end 

    if curStep == 663 then
        windowShaking = false

        windowShakeX = windowOriginX - 200
        windowShakeY = windowOriginY + 75

        doTweenWindow('windowX', 'x', windowShakeX, 0.075,'bounceOut',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.075,'quadOut',1)
    end

    if curStep == 664 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 2.00)
        end

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.25, "linear")
    end 

    if curStep == 667 then
        windowShaking = false

        windowShakeX = windowOriginX + 50
        windowShakeY = windowOriginY - 100

        doTweenWindow('windowX', 'x', windowShakeX, 0.075,'bounceOut',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.075,'quadOut',1)
    end
    
    if curStep == 668 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.50)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 2.00)
        end

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.25, "linear")
    end

    if curStep == 671 then
        windowShaking = false

        windowShakeX = windowOriginX + 500
        windowShakeY = windowOriginY - 200

        doTweenWindow('windowX', 'x', windowShakeX, 0.075,'bounceOut',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.075,'quadOut',1)
    end

    if curStep == 672 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 1.00)
        end

        doTweenWindow('windowX', 'x', windowShakeX - 900, 1.65,'quadInOut',1)
        doTweenWindow('windowY', 'y', windowShakeY + 300, 0.875, 'quadOut',1)
    end  

    if curStep == 680 then

        windowShakeY = windowOriginY - 100

        if flashingLights then
            setProperty('brightnessVar.x', 1.00)
            setProperty('contrastVar.x', 2.50)
            setProperty('saturationVar.x', 0.50)
        end

        doTweenWindow('windowY', 'y', windowShakeY, 0.875, 'quintOut',1)
    end  

    if curStep == 686 then

        if flashingLights then
            setProperty('brightnessVar.x', -1.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 3.00)
        end

        windowShakeX = windowOriginX
        windowShakeY = windowOriginY

        doTweenWindow('windowX', 'x', windowShakeX, 0.10, 'quadIn',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.20, 'quintOut',1)
    end

    if curStep == 688 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 1.00)
        end

        windowShakeX = windowOriginX + 400
        windowShakeY = windowOriginY -100

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.2, "linear")
    end

    if curStep == 692 then

        if flashingLights then
            setProperty('brightnessVar.x', 1.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 3.00)
        end

        windowShakeX = windowOriginX - 400
        windowShakeY = windowOriginY - 100

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.2, "linear")
    end

    if curStep == 696 then

        if flashingLights then
            setProperty('brightnessVar.x', -0.50)
            setProperty('contrastVar.x', 1.50)
            setProperty('saturationVar.x', 1.50)
        end

        windowShakeX = windowOriginX - 400
        windowShakeY = windowOriginY + 100

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.2, "linear")
    end

    if curStep == 700 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 1.00)
        end

        windowShakeX = windowOriginX + 400
        windowShakeY = windowOriginY + 100

        windowShaking = true

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.2, "linear")
    end

    if curStep == 704 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 2.00)
        end

        windowShaking = false

        windowShakeX = windowOriginX
        windowShakeY = windowOriginY

        doTweenWindow('windowX', 'x', windowShakeX, 0.75,'quadInOut',1)
        doTweenWindow('windowY', 'y', windowShakeY, 0.75,'quadInOut',1)
    end

    if curStep == 712 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 2.00)
            setProperty('saturationVar.x', 1.00)
        end
        
        windowShaking = true

        windowShakeX = windowOriginX - 400
        windowShakeY = windowOriginY

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.15, "linear")

        setProperty("camHUD.visible", true)
        doTweenAlpha('camHUD', 'camHUD', 1, 0.5, 'linear')
    end

    if curStep == 716 then

        if flashingLights then
            setProperty('brightnessVar.x', -1.00)
            setProperty('contrastVar.x', 3.00)
            setProperty('saturationVar.x', 2.00)
        end

        windowShaking = true

        windowShakeX = windowOriginX + 400
        windowShakeY = windowOriginY

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 0.15, "linear")
    end

    if curStep == 718 then

        if flashingLights then
            setProperty('brightnessVar.x', 0.00)
            setProperty('contrastVar.x', 1.00)
            setProperty('saturationVar.x', 1.00)
        end

        windowShaking = false

        windowShakeX = windowOriginX
        windowShakeY = windowOriginY
        
        doTweenWindow('windowX', 'x', windowOriginX, 0.25, 'bounceOut',1)
        doTweenWindow('windowY', 'y', windowOriginY, 0.75, 'quintOut',1)
    end

    
    if curStep == 720 then
        doTweenAlpha('trippyBG', 'trippyBG', 0, 0.5, 'quadOut')
        doTweenAlpha('red', 'red', 1, 0.6, 'quadOut')
        triggerEvent("Play Animation", "idle", "dad")
        setProperty("dad.animation.curAnim.frameRate", 8)
        doTweenX('brightness', 'brightnessVar', 1, 1, 'quadOut')
        doTweenX('contrast', 'contrastVar', 3, 1, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1.5, 1, 'quadOut')
    end

    if curStep == 720 or curStep == 752 then
        windowShaking = true

        setProperty("shakeLevelVar.x", 8)
    end

    if curStep == 780 then
        setProperty("SEGA.alpha", 1)

        setProperty('brightnessVar.x', 0.00)
        setProperty('contrastVar.x', 1.00)
        setProperty('saturationVar.x', 1.00)

        setProperty("shakeLevelVar.x", 50)
        doTweenX("shakeLevelVar", "shakeLevelVar", 8, 0.2, "linear")
    end

    if curStep == 784 then
        setProperty("SEGA.alpha", 0)
        setProperty("red.alpha", 0)
        setProperty("trippyBG.alpha", 0.33)
        triggerEvent("Play Animation", "idle", "dad")
        setProperty('brightnessVar.x', 0.00)
        setProperty('contrastVar.x', 1.25)
        setProperty('saturationVar.x', 1.5)
        setProperty("dad.animation.curAnim.frameRate", 18) -- i know its 30 originally but it looks weird that fast

        windowShakeX = windowOriginX
        windowShakeY = windowOriginY

        --windowShaking = false

        --doTweenWindow('windowDown', 'y', windowOriginY+120, winSpdY/2,'quadOut',1)
		--doTweenWindow('windowRight', 'x', windowOriginX+300, winSpdX/2,'sineInOut',1)

        --runTimer('windowDown', winSpdY/2)
		--runTimer('windowRight', winSpdX/2)
    end
    
    if curStep == 847 then
        windowShaking = false
        coolNoteThing = true

        doTweenWindow('windowX', 'x', windowOriginX, 0.1,'quadInOut',1)
        doTweenWindow('windowY', 'y', windowOriginY, 0.1,'quadInOut',1)
    end

    if curStep == 848 then
        doTweenAlpha('trippyBG', 'trippyBG', 0.33, 1, 'quadOut')
        doTweenAlpha('red', 'red', 0, 1, 'quadOut')
    end

    if curStep == 908 then
        windowShaking = true
        coolNoteThing = false

        cancelTimer('windowLeft')
		cancelTimer('windowRight')
		cancelTimer('windowUp')
		cancelTimer('windowDown')
		cancelTween('windowLeft')
		cancelTween('windowRight')
		cancelTween('windowUp')
		cancelTween('windowDown')

        --doTweenWindow('windowX', 'x', windowShakeX, 0.2, 'quadOut',1)
        --doTweenWindow('windowY', 'y', windowShakeY, 0.2, 'quadOut',1)

        setProperty("shakeLevelVar.x", 50)
        doTweenX("shakeLevelVar", "shakeLevelVar", 8, 0.2, "linear")
    end

    if curStep == 912 then
        setProperty("dad.visible", false)
        setProperty("boyfriend.visible", false)
        setProperty("gf.visible", false)

        setProperty("shakeLevelVar.x", 100)
        doTweenX("shakeLevelVar", "shakeLevelVar", 0, 2, "linear")

        cameraFlash('camOther', 'FF0000', 2, true)
        setProperty('camHUD.alpha', 0)
        setProperty("trippyBG.alpha", 0)
    end

    if curStep == 976 then
        stopZoomingDammit = true
        playAnim('Outro', 'Outro', true)
        callMethod('camGame.fade', {0x000000, 1, true})
        setProperty('blue.alpha', 1)
        doTweenAlpha('blue', 'blue', 0, 1, 'quadIn')
        setProperty('Outro.alpha', 1)
    end
end

function onBeatHit()
    if curBeat >= 164 and curBeat <= 228 then
        triggerEvent('Add Camera Zoom', '0.1', '0.05')
    end
end

function goodNoteHit(index, noteDir, noteType, isSustainNote)
    if coolNoteThing then
        noteHit[noteDir]()
    end
end

function screenFlash()
    setProperty('camGame.visible', false)
    runTimer('gameCam', 0.1)
end

function onDestroy()
    setPropertyFromClass('openfl.Lib', 'application.window.title', "VS Sonic")
    setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
    
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
    ]]); -- this centers the window to the monitor it's on
end

function doTweenWindow(tag,var,value,duration,ease,types)
	-- allows the window to be tweened, works with resizing windows too :D

    if windowFuckery then -- dont move the window for this grr
        cancelTween(tag) -- reduces chance of it duplicating and breaking

        runHaxeCode([[
        game.modchartTweens.set(']]..tag..[[',
            FlxTween.tween(Lib.application.window,
                {]]..var..[[: ]]..value..[[},
                ]]..duration..[[,
                {ease: FlxEase.]]..ease..[[,
                type: ]]..types..[[
            })
        );
        ]])
    end
end

function onGameOver()
    cancelTween("shakeLevelVar")
    setProperty("shakeLevelVar.x", 0)
end