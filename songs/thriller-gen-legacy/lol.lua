
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

local noteCheck = false -- puts the notes on the premade camNotes, only do this for the fullscreen segment or this will look horrid

local allowZoom = true

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

    setProperty("skipCountdown", true)

    setProperty('scoreTxt.visible', false)
    setProperty('showRating', false)
    setProperty('showComboNum', false)
    setProperty('showCombo', false)
    setProperty('displayName', 'Thriller Gen')
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
        
        makeLuaSprite("tgTitle", "titleCard/thrillerGenPlaceHolder", 230, 0)
        setProperty("tgTitle.antialiasing", false)
        scaleObject("tgTitle", 3.25, 3.25)
        setObjectCamera("tgTitle", 'other')
        setProperty("tgTitle.alpha", 0)
        addLuaSprite("tgTitle", false)
        doTweenAlpha("tgTitle1", "tgTitle", 1, 0.3, "sineOut")

        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        end

        runTimer('fadeitOut', 2)
        runTimer('startSong', 3)
    end

    if tag == 'fadeitOut' then
        doTweenAlpha("tgTitle", "tgTitle", 0, 0.3, "sineOut")
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

    setScrollFactor('dad', 0.5, 0.8)
end

function onGameOver()
    setProperty("cameraSpeed", 5)
    setProperty('defaultCamZoom', 1.1)
    setProperty("camGame.zoom", 1.1)
    setPropertyFromClass('openfl.Lib', 'application.window.title', "RETRY?")
end

function onGameOverStart()
    setProperty("cameraSpeed", 5)
    setPropertyFromClass('openfl.Lib', 'application.window.title', "RETRY?")
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