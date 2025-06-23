-- hi guys, funny snow fox guy is here!!!
-- this is gonna be the main file i do my silly stuff in, yeye
-- gonna be all about modcharting and window manupulation n' stuffs
-- thank u springless for letting me do this :D

-- im in the rewrite too! -dapootisbird

-- update: 10th feb 2025, lmao this is messy now
-- oh well, if it works ig -snow

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

local pauseOverride = false

local secondHalfStart = false

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

local noteSafety1 = false
local noteSafety2 = false

local safetyNetIDKANYMORE = false

local safetyHEAD = false
local safetyHEAD2 = false

local safetyTrans = false

local fullscreenLagCheck1 = false
local fullscreenLagCheck2 = false
local fullscreenLagCheck3 = false
local fullscreenLagCheck4 = false
local fullscreenLagCheck5 = false

local finalLagCheck = false

local noteCheck = false -- puts the notes on the premade camNotes, only do this for the fullscreen segment or this will look horrid

local noteYOrigin = 0 -- because fuck this
local allowNoteSway =  false -- CANCELLING THE TWEEN ISNT FUCKING WORKING GONNA CRASH OUT

local fpsVisible = false

local stopUpdatingDummy = false
local stopUpdatingDummy2 = false
local stopUpdatingDummy3 = false
local stopUpdatingDummy4 = false
local stopUpdatingDummyFFS = false

local noMoreDeath = false

local allowWinTween = false

local brightness = 0.00
local contrast = 1.00
local saturation = 1.00

local internalBGBeat = -1
local internalBGBop = false
local internalShaderUpdate = true
local internalFlipShiet = false

--

function onStartCountdown()
    if not startSong then -- the 4:3 code wOAAAHHH
        runTimer('loadBuffer', 0.75)

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
    setTextString("botplayTxt", "") -- reminder to remove this line after im done testing shit lol
    setProperty('displayName', 'Trinity (Encore)')
    setProperty('skipCountdown', true) -- go away generic fnf start
    setProperty('canPause', false)

	addHaxeLibrary("Lib", "openfl"); -- the usual import for this stuff

	maxWidth = getPropertyFromClass('openfl.Lib','application.window.stage.fullScreenWidth')
	maxHeight = getPropertyFromClass('openfl.Lib','application.window.stage.fullScreenHeight') -- grabs the resolution of the monitor the game is running at

    makeLuaSprite('shakeLevelMinVar')
	setProperty("shakeLevelMinVar.x", -15)

	makeLuaSprite('shakeLevelMaxVar')
	setProperty("shakeLevelMaxVar.x", 15) -- value for shaking

    precacheImage("noteSkins/internalX_Notes")
    precacheImage("Stomp")
    precacheImage("redClouds")
    precacheImage("flash")
    precacheImage("red-flash")
    precacheImage("blue-flash")
    precacheImage("fullscreenIntroStuff")
    precacheImage("welcomeBack")
    precacheImage("bfMask")
    precacheImage("lordXJumpscares")
    precacheImage("internalXBG")
    --precaching these cuz idk when they get used and i don't feel like translating them to cameraFlash() lol sorry

    if shadersEnabled then
        initLuaShader("glitch")
        initLuaShader("contrast")
        initLuaShader("fisheye")
        initLuaShader("verticalWave")
        initLuaShader("wiggle")

        makeLuaSprite("glitchShader")
        setSpriteShader("glitchShader", "glitch")

        makeLuaSprite("fisheyeShader")
        setSpriteShader("fisheyeShader", "fisheye")

        makeLuaSprite("contrastShader")
        setSpriteShader("contrastShader", "contrast")
        
        setShaderFloat("contrastShader", "brightness", 0.0)
        setShaderFloat("contrastShader", "contrast", 1.0)
        setShaderFloat("contrastShader", "saturation", 1.0)

        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
        ]])
    end

    makeLuaSprite('brightnessVar')
    setProperty('brightnessVar.x', 0.00)

    makeLuaSprite('contrastVar')
    setProperty('contrastVar.x', 1.00)

    makeLuaSprite('saturationVar')
    setProperty('saturationVar.x', 1.00)

    fpsVisible = getPropertyFromClass('Main', 'fpsVar.visible')

    makeLuaSprite("blue", "", 0, 0)
    makeGraphic('blue', 1, 1, '0000FF') -- making the size tiny cuz' apparently making it too big can cause memory leaks so erm, scaleobject moment
    setBlendMode('blue', 'multiply')
    setScrollFactor('blue', 0, 0)
    setProperty("blue.antialiasing", false)
    scaleObject("blue", 1500, 1000)
    setObjectCamera("blue", 'other')
    setProperty("blue.alpha", 0.001)
    addLuaSprite("blue", true)
end

createInstance('camNotes', 'flixel.FlxCamera', {})
setProperty('camNotes.bgColor', 0x00)
createInstance('camLyrics', 'flixel.FlxCamera', {})
setProperty('camLyrics.bgColor', 0x00)
callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camOther'), false})
callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camHUD'), false})
callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camHUD'), false})
callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camLyrics'), false})
callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camNotes'), false})
callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg('camOther'), false})
--CAMERAS EVERYWHERE OH GOD AAAAAAAAAAAAAAAA

function onCreatePost()

    setProperty("camNotes.alpha", 0.001);
    setProperty("gf.alpha", 0.001);

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

    
    for i = 4,7 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
    end

    setProperty('healthLabel.alpha', 0)
    setProperty('healthValue.alpha', 0)
    setProperty('healthLabelShadow.alpha', 0)
    setProperty('healthValueShadow.alpha', 0)
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

    makeLuaSprite('transColour', '', -500, -500)
    makeGraphic('transColour', 2500, 2000, '131313')
    setProperty('transColour.alpha', 0)
    setScrollFactor('transColour', 0, 0)
    setObjectOrder("transColour", 0)
    addLuaSprite("transColour")

    if shadersEnabled then
        makeLuaSprite('blackMask', '', -100, -100)
        makeGraphic('blackMask', 1300, 1000, '000000')
    else
        makeLuaSprite('blackMask', '', -500, -250)
        makeGraphic('blackMask', 2500, 1300, '000000')
    end
    setProperty('blackMask.alpha', 0.001)
    setScrollFactor('blackMask', 0, 0)
    addLuaSprite("blackMask", false)

    makeLuaBackdrop("redClouds", "redClouds", "X", 0, 0)
    setProperty('redClouds.antialiasing', false)
    setProperty('redClouds.alpha', 0.001)
    addLuaBackdrop("redClouds")
    if shadersEnabled then
        scaleObject("redClouds", 2.0, 2.0)
        setProperty('redClouds.velocity.x', -750)
    else
        setProperty('redClouds.y', -400)
        scaleObject("redClouds", 5.0, 5.0)
        setProperty('redClouds.velocity.x', -1000)
    end
    
    makeAnimatedLuaSprite("fleshBG", "fleshBG", 0, 0)
    addAnimationByPrefix("fleshBG", "fleshBG", "bgflesh", 20, true)
    setProperty('fleshBG.antialiasing', false)
    setProperty('fleshBG.alpha', 0.001)
    addLuaSprite('fleshBG', false)
    scaleObject("fleshBG", 2.7, 2.7)

    if shadersEnabled then
        setProperty('fleshBG.x', 100)
        setProperty('fleshBG.y', 50)
        scaleObject("fleshBG", 2.7, 2.7)
    else
        setProperty('fleshBG.x', -300)
        setProperty('fleshBG.y', -160)
        scaleObject("fleshBG", 5, 5)
     end

    makeAnimatedLuaSprite("desktopRift", "desktopRift", -275, -160)
    addAnimationByPrefix("desktopRift", "desktopRift", "rift0", 12, false)
    addAnimationByPrefix("desktopRift", "temp", "rift0", 15, false)
    playAnim("desktopRift", "temp")
    setProperty('desktopRift.antialiasing', false)
    setProperty('desktopRift.alpha', 0.001)
    addLuaSprite('desktopRift', false)
    setScrollFactor("desktopRift", 0.0, 0.0)
    scaleObject("desktopRift", 2.5, 2.5)

    makeAnimatedLuaSprite("desktopRiftMask", "desktopRift", -275, -160)
    addAnimationByPrefix("desktopRiftMask", "desktopRiftMask", "riftMask", 12, false)
    addAnimationByPrefix("desktopRiftMask", "temp", "riftMask", 15, false)
    playAnim("desktopRiftMask", "temp")
    setProperty('desktopRiftMask.antialiasing', false)
    setProperty('desktopRiftMask.alpha', 0.001)
    addLuaSprite('desktopRiftMask', false)
    setScrollFactor("desktopRiftMask", 0.0, 0.0)
    scaleObject("desktopRiftMask", 2.5, 2.5)

    makeAnimatedLuaSprite("rewriteCutscene", "rewriteCutscene", 0, 0)
    addAnimationByPrefix("rewriteCutscene", "rewriteCutscene", "0_", 15, false)
    addAnimationByPrefix("rewriteCutscene", "temp", "0_", 15, false)
    playAnim("rewriteCutscene", "temp")
    setProperty('rewriteCutscene.antialiasing', false)
    setProperty('rewriteCutscene.alpha', 0.001)
    addLuaSprite('rewriteCutscene', false)
    setObjectCamera("rewriteCutscene", 'other')
    scaleObject("rewriteCutscene", 3.22, 3.22)

    makeAnimatedLuaSprite('rewriteStomp', "Stomp", 0, 0)
    addAnimationByPrefix('rewriteStomp', 'animation', 'anim', 30, false)
    scaleObject('rewriteStomp', 3.22, 3.22)
    addLuaSprite('rewriteStomp', false)
    setObjectCamera('rewriteStomp', 'other')
    setProperty('rewriteStomp.alpha', 0.001)
    setProperty('rewriteStomp.antialiasing', false)

    makeAnimatedLuaSprite("rewriteCutsceneTransition", "rewriteCutsceneTransition", 0, 0)
    addAnimationByPrefix("rewriteCutsceneTransition", "rewriteCutsceneTransition", "0_", 15, false)
    addAnimationByPrefix("rewriteCutsceneTransition", "temp", "0_", 15, false)
    playAnim("rewriteCutsceneTransition", "temp")
    setProperty('rewriteCutsceneTransition.antialiasing', false)
    setProperty('rewriteCutsceneTransition.alpha', 0.001)
    addLuaSprite('rewriteCutsceneTransition', false)
    setObjectCamera("rewriteCutsceneTransition", 'other')
    scaleObject("rewriteCutsceneTransition", 3.22, 3.22)

    makeLuaSprite('fusionCutsceneFade', '', 0, 0)
    makeGraphic('fusionCutsceneFade', 1280, 720, 'EDFCD5')
    setProperty('fusionCutsceneFade.alpha', 0)
    setScrollFactor('fusionCutsceneFade', 0, 0)
    setObjectCamera("fusionCutsceneFade", "other")
    setProperty("fusionCutsceneFade.alpha", 0.001)
    addLuaSprite("fusionCutsceneFade")
    -- for some reason the video isn't ending correctly anymore, so im doing this instead, ffs

    makeAnimatedLuaSprite("welcomeBack", "welcomeBack", 230, 0)
    addAnimationByPrefix("welcomeBack", "blank", "blank", 15, false)
    addAnimationByPrefix("welcomeBack", "fade", "fade", 25, false)
    addAnimationByPrefix("welcomeBack", "glitch", "glitch", 30, true)
    playAnim("welcomeBack", "blank")
    setProperty('welcomeBack.antialiasing', false)
    setProperty('welcomeBack.alpha', 0.001)
    addLuaSprite('welcomeBack', false)
    setObjectCamera("welcomeBack", 'other')
    scaleObject("welcomeBack", 2, 2)

    makeAnimatedLuaSprite("welcomeBackText", "welcomeBack", 230, 0)
    addAnimationByPrefix("welcomeBackText", "WELCOME", "1welcome", 15, false)
    addAnimationByPrefix("welcomeBackText", "BACK", "2back", 30, true)
    playAnim("welcomeBackText", "WELCOME")
    setProperty('welcomeBackText.antialiasing', false)
    setProperty('welcomeBackText.alpha', 0.001)
    addLuaSprite('welcomeBackText', false)
    setObjectCamera("welcomeBackText", 'other')
    scaleObject("welcomeBackText", 2, 2)

    if shadersEnabled then
        makeAnimatedLuaSprite("lordXJumpscares", "lordXJumpscaresCrack", 230, 0)
    else
        makeAnimatedLuaSprite("lordXJumpscares", "lordXJumpscares", 230, 0)
    end
    addAnimationByPrefix("lordXJumpscares", "1", "jumpscare1", 1, false)
    addAnimationByPrefix("lordXJumpscares", "2", "jumpscare2", 1, false)
    addAnimationByPrefix("lordXJumpscares", "3", "jumpscare3", 1, false)
    playAnim("lordXJumpscares", "1")
    setProperty('lordXJumpscares.antialiasing', false)
    setProperty('lordXJumpscares.alpha', 0.001)
    addLuaSprite('lordXJumpscares', false)
    setObjectCamera("lordXJumpscares", 'game')
    setScrollFactor('lordXJumpscares', 0, 0)
    scaleObject("lordXJumpscares", 3.22, 3.22)

    makeLuaSprite('internalColour', '', -500, -500)
    makeGraphic('internalColour', 20, 20, '070727')
    scaleObject("internalColour", 100, 100)
    setScrollFactor('internalColour', 0, 0)
    addLuaSprite("internalColour")
    setObjectOrder("internalColour", 6)
    setProperty("internalColour.alpha", 0.001)
    setObjectCamera('internalColour', 'fx')

    makeAnimatedLuaSprite("internalBG", "internalXBG", 0, 0)
    addAnimationByPrefix("internalBG", "0", "scary0", 1, true)
    addAnimationByPrefix("internalBG", "1", "scary1", 1, true)
    addAnimationByPrefix("internalBG", "2", "scary2", 1, true)
    addAnimationByPrefix("internalBG", "3", "scary3", 1, true)
    addAnimationByPrefix("internalBG", "4", "scary4", 1, true)
    addAnimationByPrefix("internalBG", "5", "scary5", 1, true)
    addAnimationByPrefix("internalBG", "6", "scary6", 1, true)
    addAnimationByPrefix("internalBG", "7", "scary7", 1, true)
    setObjectOrder("internalBG", 7)
    setScrollFactor("internalBG", 0.925, 0.925)
    setProperty("internalBG.alpha", 0.001)
    scaleObject("internalBG", 3.32, 3.32)
    setProperty("internalBG.antialiasing", false)
    setProperty('internalBG.x', 300)
    setProperty('internalBG.y', 0)
    setObjectCamera('internalBG', 'fx')
    addLuaSprite("internalBG")

    if not shadersEnabled then
        setProperty('internalBG.x', 250)
        setProperty('internalBG.y', 0)
    end

    makeLuaSprite("internalOverlay", "internalOverlay")
    setProperty("internalOverlay.antialiasing", false)
    setProperty("internalOverlay.alpha", 0.001)
    screenCenter("internalOverlay")
    setProperty("internalOverlay.x", 200)
    scaleObject("internalOverlay", 2.5, 2.5)
    setObjectCamera("internalOverlay", 'fx')
    setScrollFactor("internalOverlay", 0.925, 0.925)
    setBlendMode("internalOverlay", "multiply")
    addLuaSprite("internalOverlay")
    if shadersEnabled then 
        setSpriteShader("internalOverlay", "wiggle") 
        setSpriteShader("internalBG", "wiggle")
        setShaderInt("internalOverlay", "effectType", 4)
        setShaderFloat("internalOverlay", "uSpeed", 7.9)
        setShaderFloat("internalOverlay", "uFrequency", 6.4)
        setShaderFloat("internalOverlay", "uWaveAmplitude", 0.018)
        runTimer('internalShaderShiet', 0.027, 0)

        runHaxeCode([[
            game.getLuaObject("internalBG").shader = game.getLuaObject("internalOverlay").shader;
        ]])
    else
        setProperty("internalOverlay.y", -100)
    end

    makeLuaSprite("internalGradient", "internalGradient", 0, 645)
    setProperty("internalGradient.antialiasing", false)
    setProperty("internalGradient.alpha", 0.001)
    scaleObject("internalGradient", 17, 2)
    addLuaSprite("internalGradient", false)

    makeLuaSprite("fullScreenIntroBG", "", 0, 0)
    makeGraphic('fullScreenIntroBG', 1281, 721, 'FFFFFF')
    doTweenColor('fullScreenIntroBG', 'fullScreenIntroBG', '100410', 0.01, 'linear')
    setProperty('fullScreenIntroBG.antialiasing', false)
    addLuaSprite('fullScreenIntroBG', true)
    setScrollFactor('fullScreenIntroBG', 0, 0)
    --setObjectCamera("fullScreenIntroBG", 'hud')
    scaleObject("fullScreenIntroBG", 3.22, 3.22)

    makeAnimatedLuaSprite("fullScreenIntro", "fullScreenIntroStuff", 0, 0)
    addAnimationByPrefix("fullScreenIntro", "loop", "fullScreenBGLoop", 15, true)
    setProperty('fullScreenIntro.antialiasing', false)
    setProperty('fullScreenIntro.alpha', 0.001)
    addLuaSprite('fullScreenIntro', false)
    setObjectCamera("fullScreenIntro", 'hud')
    scaleObject("fullScreenIntro", 3.22, 3.22)

    makeAnimatedLuaSprite("fullScreenRunning", "fullScreenIntroStuff", 1280, 335)
    addAnimationByPrefix("fullScreenRunning", "running", "running", 15, true)
    setProperty('fullScreenRunning.antialiasing', false)
    setProperty('fullScreenRunning.alpha', 1)
    addLuaSprite('fullScreenRunning', false)
    setObjectCamera("fullScreenRunning", 'hud')
    scaleObject("fullScreenRunning", 3.22, 3.22)

    makeAnimatedLuaSprite("sa2Posing", "fullScreenIntroStuff", -1280, 150)
    addAnimationByPrefix("sa2Posing", "bf", "bfSA2_", 15, false)
    playAnim("sa2Posing", "bf")
    setProperty('sa2Posing.antialiasing', false)
    setProperty('sa2Posing.alpha', 1)
    addLuaSprite('sa2Posing', false)
    setObjectCamera("sa2Posing", 'hud')
    scaleObject("sa2Posing", 3.22, 3.22)
    
    makeAnimatedLuaSprite("sa2Posing2", "fullScreenIntroStuff", 1280, 150)
    addAnimationByPrefix("sa2Posing2", "rewrite", "sonicSA2_", 15, false)
    playAnim("sa2Posing2", "rewrite")
    setProperty('sa2Posing2.antialiasing', false)
    setProperty('sa2Posing2.alpha', 1)
    addLuaSprite('sa2Posing2', false)
    setObjectCamera("sa2Posing2", 'hud')
    scaleObject("sa2Posing2", 3.22, 3.22)

    makeAnimatedLuaSprite("sa2PosingShadow", "fullScreenIntroStuff", -1280, 150)
    addAnimationByPrefix("sa2PosingShadow", "bfShadow", "bfSA2Shadow_", 15, false)
    playAnim("sa2PosingShadow", "bfShadow")
    setProperty('sa2PosingShadow.antialiasing', false)
    setProperty('sa2PosingShadow.alpha', 0.001)
    addLuaSprite('sa2PosingShadow', false)
    setObjectCamera("sa2PosingShadow", 'hud')
    scaleObject("sa2PosingShadow", 3.22, 3.22)
    
    makeAnimatedLuaSprite("sa2Posing2Shadow", "fullScreenIntroStuff", 1280, 150)
    addAnimationByPrefix("sa2Posing2Shadow", "rewriteShadow", "sonicSA2Shadow_", 15, false)
    playAnim("sa2Posing2Shadow", "rewriteShadow")
    setProperty('sa2Posing2Shadow.antialiasing', false)
    setProperty('sa2Posing2Shadow.alpha', 0.001)
    addLuaSprite('sa2Posing2Shadow', false)
    setObjectCamera("sa2Posing2Shadow", 'hud')
    scaleObject("sa2Posing2Shadow", 3.22, 3.22)

    makeAnimatedLuaSprite("pillarWipe", "fullScreenIntroStuff", 0, 0)
    addAnimationByPrefix("pillarWipe", "wipe", "pillarWipe", 15, false)
    addAnimationByPrefix("pillarWipe", "temp", "pillarWipe", 15, false)
    playAnim('pillarWipe', 'temp')
    setProperty('pillarWipe.antialiasing', false)
    setProperty('pillarWipe.alpha', 0.001)
    addLuaSprite('pillarWipe', false)
    setObjectCamera("pillarWipe", 'hud')
    scaleObject("pillarWipe", 3.22, 3.22)

    makeAnimatedLuaSprite("ring", "fullScreenIntroStuff-OLD", 0, 0)
    addAnimationByPrefix("ring", "ring", "ring", 15, false)
    playAnim("ring", "ring")
    setProperty('ring.antialiasing', false)
    setProperty('ring.alpha', 0.001)
    addLuaSprite('ring', false)
    setObjectCamera("ring", 'hud')
    scaleObject("ring", 3.22, 3.22)

    makeAnimatedLuaSprite("boyfriendRing", "fullScreenIntroStuff-OLD", 0, 720)
    addAnimationByPrefix("boyfriendRing", "boyfriendRing", "bf", 15, false)
    playAnim("boyfriendRing", "boyfriendRing")
    setProperty('boyfriendRing.antialiasing', false)
    setProperty('boyfriendRing.alpha', 0.001)
    addLuaSprite('boyfriendRing', false)
    setObjectCamera("boyfriendRing", 'hud')
    scaleObject("boyfriendRing", 3.22, 3.22)

    makeLuaSprite('flashbang', '', -500, -500)
    makeGraphic('flashbang', 2000, 2000, 'FFFFFF')
    setProperty("flashbang.alpha", 0.001)
    setScrollFactor('flashbang', 0, 0)
    addLuaSprite("flashbang")
    setObjectCamera("flashbang", 'other')

    makeAnimatedLuaSprite("lyricsPlaceholder", "lyricsPlaceholder", 0, 0) -- lmao animated lyrics moment
    addAnimationByPrefix('lyricsPlaceholder', 'LETS', '1lets', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'PLAY', '2play', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'A', '3a', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'GAME', '4game', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'FOR', '5for', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'OLD', '6old', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'TIME', '7time', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'SAKE', '8sake', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'ARE', '9are', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'YOU', '10you', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'READY', '11ready', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'READY-glitch1', '12ready', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'READY-glitch2', '13ready', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'READY-glitch3', '14ready', 1, false)
    addAnimationByPrefix('lyricsPlaceholder', 'READY-glitch4', '15ready', 1, false)
    playAnim("lyricsPlaceholder", "LETS", true, false, 0)
    setProperty('lyricsPlaceholder.antialiasing', false)
    addLuaSprite('lyricsPlaceholder', false)
    scaleObject("lyricsPlaceholder", 3.0, 3.0)
    setObjectCamera("lyricsPlaceholder", 'other')
    setProperty("lyricsPlaceholder.alpha", 0.001)

    makeLuaSprite('windowBlack', '', 1150, 150)
    makeGraphic('windowBlack', 300, 320, '000000')
    setProperty('windowBlack.alpha', 0.001)
    setScrollFactor('windowBlack', 0, 0)
    setObjectOrder("windowBlack", getObjectOrder("desktopRiftMask")+3)
    addLuaSprite("windowBlack", false)

    makeAnimatedLuaSprite('windowVessel', 'windowVessel', 948, 83)
    addAnimationByPrefix("windowVessel", "windowVessel", "windowVessel", 15, false)
    playAnim("windowVessel", "windowVessel", true, false, 0)
    setProperty('windowVessel.alpha', 0.001)
    setProperty('windowVessel.antialiasing', false)
    setScrollFactor('windowVessel', 0, 0)
    addLuaSprite("windowVessel", true)
    setObjectOrder("windowVessel", getObjectOrder("boyfriendGroup")+4)
    scaleObject("windowVessel", 2.4, 2.4)

    makeAnimatedLuaSprite('rewriteWindowBox', 'rewriteWindowBox', 948, 83)
    addAnimationByPrefix("rewriteWindowBox", "rewriteWindowBox", "0_", 30, false)
    playAnim("rewriteWindowBox", "rewriteWindowBox", true, false, 0)
    setProperty('rewriteWindowBox.alpha', 0.001)
    setProperty('rewriteWindowBox.antialiasing', false)
    setScrollFactor('rewriteWindowBox', 0, 0)
    addLuaSprite("rewriteWindowBox", true)
    setObjectOrder("rewriteWindowBox", getObjectOrder("boyfriendGroup")+7)
    scaleObject("rewriteWindowBox", 2.4, 2.4)

    makeLuaSprite("bfMask", "bfMask", -290, -215)
    setProperty('bfMask.antialiasing', false)
    setProperty('bfMask.alpha', 0.001)
    setScrollFactor("bfMask", 0.0, 0.0)
    addLuaSprite('bfMask', false)
    setObjectOrder("bfMask", getObjectOrder("boyfriendGroup")+1)
    scaleObject("bfMask", 2.4, 2.4)

    makeLuaSprite('rewriteHead', 'rewriteHead', 498, 133) --presetting the pos lol
    setProperty('rewriteHead.alpha', 0.001)
    setProperty('rewriteHead.antialiasing', false)
    setScrollFactor('rewriteHead', 0, 0)
    addLuaSprite("rewriteHead", true)
    scaleObject("rewriteHead", 2.4, 2.4)

    makeAnimatedLuaSprite("firewall", "firewall", -360, -160 + 720)
    addAnimationByPrefix("firewall", "firewall", "firewall", 15, true)
    setProperty('firewall.alpha', 0.001)
    setProperty('firewall.antialiasing', false)
    setScrollFactor('firewall', 0, 0)
    addLuaSprite("firewall", false)
    scaleObject("firewall", 5, 5)

    makeAnimatedLuaSprite("rewriteHeadCorpse", "rewriteEyes", -360, -160)
    addAnimationByPrefix("rewriteHeadCorpse", "temp", "corpseLoop", 15, false)
    addAnimationByPrefix("rewriteHeadCorpse", "corpse0", "corpse0", 15, false)
    addAnimationByPrefix("rewriteHeadCorpse", "corpseLoop", "corpseLoop", 12, true)
    addAnimationByPrefix("rewriteHeadCorpse", "corpseGlitch", "glitchCorpse", 24, true)
    playAnim("rewriteHeadCorpse", "temp")
    setProperty('rewriteHeadCorpse.antialiasing', false)
    setProperty('rewriteHeadCorpse.alpha', 0.001)
    addLuaSprite('rewriteHeadCorpse', false)
    setScrollFactor("rewriteHeadCorpse", 0.0, 0.0)
    setObjectOrder("rewriteHeadCorpse", getObjectOrder("dadGroup")+1)
    scaleObject("rewriteHeadCorpse", 5, 5)

    makeAnimatedLuaSprite("rewriteHeadMask", "rewriteEyes", -360, -160)
    addAnimationByPrefix("rewriteHeadMask", "mask", "introMask", 15, false)
    playAnim("rewriteHeadMask", "mask")
    setProperty('rewriteHeadMask.antialiasing', false)
    setProperty('rewriteHeadMask.alpha', 0.001)
    addLuaSprite('rewriteHeadMask', false)
    setScrollFactor("rewriteHeadMask", 0.0, 0.0)
    setObjectOrder("rewriteHeadMask", getObjectOrder("dadGroup")+2)
    scaleObject("rewriteHeadMask", 5, 5)

    makeLuaSprite('errorBox4', 'errorBox2', 200, 300)
    setProperty('errorBox4.alpha', 0.001)
    setProperty('errorBox4.antialiasing', false)
    setScrollFactor('errorBox4', 0, 0)
    addLuaSprite("errorBox4", false)
    scaleObject("errorBox4", 1, 1)

    makeLuaSprite('errorBox3', 'errorBox1', 600, 100)
    setProperty('errorBox3.alpha', 0.001)
    setProperty('errorBox3.antialiasing', false)
    setScrollFactor('errorBox3', 0, 0)
    addLuaSprite("errorBox3", false)
    scaleObject("errorBox3", 1, 1)

    makeLuaSprite('errorBox2', 'errorBox2', 400, 500)
    setProperty('errorBox2.alpha', 0.001)
    setProperty('errorBox2.antialiasing', false)
    setScrollFactor('errorBox2', 0, 0)
    addLuaSprite("errorBox2", false)
    scaleObject("errorBox2", 1, 1)

    makeLuaSprite('errorBox1', 'errorBox1', 300, 400)
    setProperty('errorBox1.alpha', 0.001)
    setProperty('errorBox1.antialiasing', false)
    setScrollFactor('errorBox1', 0, 0)
    addLuaSprite("errorBox1", false)
    scaleObject("errorBox1", 1, 1)

    setObjectOrder("errorBox1", getObjectOrder("dadGroup")+3)
    setObjectOrder("errorBox2", getObjectOrder("dadGroup")+4)
    setObjectOrder("errorBox3", getObjectOrder("dadGroup")+5)
    setObjectOrder("errorBox4", getObjectOrder("dadGroup")+6)

    makeLuaSprite('jumpscare', 'jumpscarePlaceholder', 0, 0)
    makeGraphic('jumpscare', '320', '180', 'FFFFFF')
    setProperty('jumpscare.alpha', 0.001)
    setProperty('jumpscare.antialiasing', false)
    setScrollFactor('jumpscare', 0, 0)
    setObjectCamera("jumpscare", "hud")
    addLuaSprite("jumpscare", true)
    scaleObject("jumpscare", 4, 4)

    makeAnimatedLuaSprite('fella1', 'fella', -50, 300)
    addAnimationByPrefix("fella1", "temp", "loop", 30, false)
    addAnimationByPrefix("fella1", "rise", "0_", 30, false)
    addAnimationByPrefix("fella1", "loop", "loop", 30, true)
    playAnim('fella1', 'temp')
    setProperty('fella1.alpha', 0.001)
    setProperty('fella1.angle', 90)
    setProperty('fella1.antialiasing', false)
    setScrollFactor('fella1', 0, 0)
    setObjectCamera("fella1", "other")
    addLuaSprite("fella1", false)
    scaleObject("fella1", 3, 3)

    makeAnimatedLuaSprite('fella2', 'fella', 940, 150)
    addAnimationByPrefix("fella2", "temp", "loop", 30, false)
    addAnimationByPrefix("fella2", "rise", "0_", 30, false)
    addAnimationByPrefix("fella2", "loop", "loop", 30, true)
    playAnim('fella2', 'temp')
    setProperty('fella2.alpha', 0.001)
    setProperty('fella2.angle', 270)
    setProperty('fella2.antialiasing', false)
    setScrollFactor('fella2', 0, 0)
    setObjectCamera("fella2", "other")
    addLuaSprite("fella2", false)
    scaleObject("fella2", 3, 3)

    makeAnimatedLuaSprite('fella3', 'fella', 200, 0)
    addAnimationByPrefix("fella3", "temp", "loop", 30, false)
    addAnimationByPrefix("fella3", "rise", "0_", 30, false)
    addAnimationByPrefix("fella3", "loop", "loop", 30, true)
    playAnim('fella3', 'temp')
    setProperty('fella3.alpha', 0.001)
    setProperty('fella3.angle', 180)
    setProperty('fella3.antialiasing', false)
    setScrollFactor('fella3', 0, 0)
    setObjectCamera("fella3", "other")
    addLuaSprite("fella3", false)
    scaleObject("fella3", 3, 3)

    makeLuaSprite("iAmGodScreamer", "iAmGodKyokai")
    setProperty("iAmGodScreamer.antialiasing", false)
    setObjectCamera('iAmGodScreamer', 'video')
    setGraphicSize('iAmGodScreamer', 1280, 720)
    screenCenter('iAmGodScreamer')
    setProperty("iAmGodScreamer.alpha", 0)
    addLuaSprite('iAmGodScreamer', false)

    makeAnimatedLuaSprite('fellaJumpscare', 'fellaJumpscare', 0, 0)
    addAnimationByPrefix("fellaJumpscare", "temp", "rise", 30, false)
    addAnimationByPrefix("fellaJumpscare", "rise", "rise", 30, false)
    addAnimationByPrefix("fellaJumpscare", "loop", "loop", 30, true)
    playAnim('fellaJumpscare', 'temp')
    setProperty('fellaJumpscare.alpha', 0.001)
    setProperty('fellaJumpscare.antialiasing', false)
    setScrollFactor('fellaJumpscare', 0, 0)
    setObjectCamera("fellaJumpscare", "other")
    addLuaSprite("fellaJumpscare", true)
    scaleObject("fellaJumpscare", 3.22, 3.22)

    makeAnimatedLuaSprite('rewriteHeadStare', 'rewriteHeadStare', 0, 550)
    addAnimationByPrefix("rewriteHeadStare", "rewriteHeadStare", "0_", 20, true)
    setProperty('rewriteHeadStare.alpha', 1)
    setScrollFactor('rewriteHeadStare', 0, 0)
    setProperty('rewriteHeadStare.antialiasing', false)
    setObjectCamera("rewriteHeadStare", 'other')
    scaleObject("rewriteHeadStare", 4, 4)
    screenCenter("rewriteHeadStare", 'X')
    setProperty("rewriteHeadStare.offset.x", -600)
    addLuaSprite("rewriteHeadStare", false)

    makeLuaSprite('transColourFinal', '', -500, -500)
    makeGraphic('transColourFinal', 2500, 2000, '131313')
    setProperty('transColourFinal.alpha', 0.001)
    setScrollFactor('transColourFinal', 0, 0)
    setObjectOrder("transColourFinal", getObjectOrder("dadGroup")-1)
    addLuaSprite("transColourFinal")

    makeAnimatedLuaSprite('rewriteKYSHead', 'characters/sonicWurugashikai', 0, 0)
    addAnimationByPrefix("rewriteKYSHead", "rewriteKYSHead", "shootHead", 1, false)
    setProperty('rewriteKYSHead.alpha', 0.001)
    setScrollFactor('rewriteKYSHead', 1, 1)
    setProperty('rewriteKYSHead.antialiasing', false)
    scaleObject("rewriteKYSHead", 3, 3)
    addLuaSprite("rewriteKYSHead", true)

    makeAnimatedLuaSprite('sparkles', 'menus/title/sparkles', 0, 0)
    addAnimationByPrefix("sparkles", "sparkles", "sparkles idle", 60, true)
    setProperty('sparkles.alpha', 0.001)
    setProperty('sparkles.antialiasing', false)
    setScrollFactor('sparkles', 0, 0)
    setObjectCamera("sparkles", 'other')
    scaleObject("sparkles", 2.5, 2.5)
    screenCenter("sparkles", 'XY')
    setProperty("sparkles.offset.x", -550)
    addLuaSprite("sparkles", true)

    makeAnimatedLuaSprite('iAmGod', 'iAmGodTxt', 0, 0)
    addAnimationByPrefix("iAmGod", "iAmGod", "iamgod", 15, false)
    setProperty('iAmGod.alpha', 0.001)
    setProperty('iAmGod.antialiasing', false)
    setObjectCamera("iAmGod", "other")
    addLuaSprite("iAmGod", false)
    screenCenter("iAmGod", 'X')
    scaleObject("iAmGod", 3, 3)

    if downscroll then
        setProperty('iAmGod.y', 0)
    else
        setProperty('iAmGod.y', 535) 
    end 
end

function onSongStart()

    setProperty('fullScreenIntroBG.alpha', 0.001) -- because graphic colours are annoying

    setProperty("camOther.alpha", 1)
    setProperty("camNotes.x", -230)
    setProperty("camLyrics.x", -230)
    setProperty("camLyrics.zoom", 1.0)
    setProperty('canPause', true)

	for i = 0,3 do
	    noteTweenX(i..'mid',i+4,screenWidth/2+(110*(i-2)),0.01, 'linear')
	end
    windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
    windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y') -- grabs the origin point of the window after it's centred

    noteYOrigin = getPropertyFromGroup('playerStrums', 0, 'y')

    triggerEvent("majin", nil, 'hud') -- getting reports of the video starting early, gonna try it like this in case it's activating early on the chart
end

function onSpawnNote()
    if noteCheck then
        runHaxeCode('game.notes.members[0].camera = getVar("camNotes");')
    end
end

function goodNoteHit()
    if noteCheck then
        for i = 0,getProperty('grpNoteSplashes.length')-1 do
            runHaxeCode('game.grpNoteSplashes.members['..i..'].camera = getVar("camNotes");')
        end
    end
end

function onUpdate(elapsed)

    if getProperty('pillarWipe.animation.curAnim.curFrame') == 3 then
        if getProperty('pillarWipe.animation.curAnim.name') == 'wipe' and not stopUpdatingDummyFFS then
            removeLuaSprite("fullScreenIntro")
            doTweenColor('fullScreenIntroBG', 'fullScreenIntroBG', '100410', 0.01, 'linear')
            setProperty('fullScreenRunning.alpha', 0)
            runTimer('removePillar', 0.01)
            doTweenX("sa2Posing", "sa2Posing", 500, 0.15, "linear")
            doTweenX("sa2Posing2", "sa2Posing2", 300, 0.15, "linear")
            stopUpdatingDummyFFS = true
        end
    end

    setProperty('sa2PosingShadow.x', getProperty('sa2Posing.x'))
    setProperty('sa2Posing2Shadow.x', getProperty('sa2Posing2.x'))
    if secondHalfStart then
        setProperty("gf.x", getProperty("dad.x"))
        setProperty("gf.y", getProperty("dad.y"))
        setObjectOrder("gfGroup", getObjectOrder("dadGroup")+1)
        --playAnim('gf', getProperty('dad.animation.curAnim.name'), true)
    end

    if getProperty('rewriteHeadCorpse.animation.curAnim.finished') then
        if getProperty('rewriteHeadCorpse.animation.curAnim.name') == 'corpse0' and not stopUpdatingDummy then
            playAnim("rewriteHeadCorpse", "corpseLoop", false, false, 0)
            stopUpdatingDummy = true
        end
    end

    if getProperty('fella1.animation.curAnim.finished') then
        if getProperty('fella1.animation.curAnim.name') == 'rise' and not stopUpdatingDummy2 then
            playAnim("fella1", "loop", true, false, 0)
            stopUpdatingDummy2 = true
        end
    end

    if getProperty('fella2.animation.curAnim.finished') then
        if getProperty('fella2.animation.curAnim.name') == 'rise' and not stopUpdatingDummy3 then
            playAnim("fella2", "loop", true, false, 0)
            stopUpdatingDummy3 = true
        end
    end

    if getProperty('fella3.animation.curAnim.finished') then
        if getProperty('fella3.animation.curAnim.name') == 'rise' and not stopUpdatingDummy4 then
            playAnim("fella3", "loop", true, false, 0)
            stopUpdatingDummy4 = true
        end
    end

    if noteCheck == true then
        setProperty("camNotes.x", getProperty("camHUD.x"))
    end

    if shadersEnabled then
        setShaderFloat("desktopRift", "iTime", os.clock())
        if getProperty("internalOverlay.alpha") > 0.001 and internalShaderUpdate then setShaderFloat("internalOverlay", "iTime", os.clock()) end

        brightness = getProperty('brightnessVar.x')
        contrast = getProperty('contrastVar.x')
        saturation = getProperty('saturationVar.x')

        setShaderFloat('trinityTitle', 'brightness', brightness)
        setShaderFloat('trinityTitle', 'contrast', contrast)
        setShaderFloat('trinityTitle', 'saturation', saturation)

        setShaderFloat('contrastShader', 'brightness', brightness)
        setShaderFloat('contrastShader', 'contrast', contrast)
        setShaderFloat('contrastShader', 'saturation', saturation)
    end

    if curStep >= 3919 and curStep < 4304 then
        setProperty('defaultCamZoom', 0.7)
        setProperty('camGame.zoom', 0.7)
        setProperty('camHUD.zoom', 1)

        allowZoom = false
    end

    if curStep == 2738 and curStep < 2740 then
        if shadersEnabled then
            setShaderFloat("glitchShader", "iTime", os.clock())
        end
    end

    if curStep >= 2892 and curStep < 2896 then
        windowLock = false
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 1)

        setPropertyFromClass('openfl.Lib', 'application.window.title', "")

        runHaxeCode("FlxG.autoPause = true;")

        setPropertyFromClass('openfl.Lib','application.window.x', windowOriginX + getRandomFloat(-500, 500))
        setPropertyFromClass('openfl.Lib','application.window.y', windowOriginY + getRandomFloat(-150, 150))
    end

    if not allowZoom then
        setProperty("camZooming", false)
    end

    shakeLevelMin = getProperty("shakeLevelMinVar.x")
	shakeLevelMax = getProperty("shakeLevelMaxVar.x")

    if windowLock then
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

    if windowFuckery then
        if windowShaking == true then
            if not lockShakeX then
                setPropertyFromClass('openfl.Lib','application.window.x', windowShakeX + getRandomFloat(shakeLevelMin,shakeLevelMax))
            end
            setPropertyFromClass('openfl.Lib','application.window.y', windowShakeY + getRandomFloat(shakeLevelMin,shakeLevelMax)) -- could be good for a few scenes, can't do this over video tho, grr
        end
    else
        if allowWinTween then
            if windowShaking == true then
                if not lockShakeX then
                    setPropertyFromClass('openfl.Lib','application.window.x', windowShakeX + getRandomFloat(shakeLevelMin,shakeLevelMax))
                end
                setPropertyFromClass('openfl.Lib','application.window.y', windowShakeY + getRandomFloat(shakeLevelMin,shakeLevelMax)) -- could be good for a few scenes, can't do this over video tho, grr
            end
        end
    end

    if not pauseOverride then -- basically, if window isn't in the proper aspect ratio, don't allow pausing, people moving to options/ending the song while in a transition can rlly fuck up the game and would need a restart,,,
        if getPropertyFromClass("openfl.Lib", "application.window.width") ~= 820 then
            setProperty('canPause', false)
        else
            setProperty('canPause', true)
        end
    end

    for i=0,3 do
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 0.3)
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 4-7)
    end
end

function onGameOver()
    if noMoreDeath then
        return Function_Stop;
    end
end

function onGameOverStart()
    if noMoreDeath then
        return Function_Stop;
    end
end
-- just have both of these here to be safe

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if secondHalfStart then
        --playAnim('dad', getProperty('singAnimations')[noteData+1], true)
        --playAnim('gf', getProperty('singAnimations')[noteData+1], true)
    end
end

function doTweenWindow(tag,var,value,duration,ease,types)
	-- allows the window to be tweened, works with resizing windows too :D

    if windowFuckery then
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
    else
        if allowWinTween then
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
end

function doTweenStage(tag,var,value,duration,ease,types)
	-- ran with doTweenWindow sometimes, seperate for when you want to enlarge the game window scale but it bugs out. this is mostly used to make aspect ratio changes work properly, may bug out tho, it's not foolproof
    if windowFuckery then
        cancelTween(tag) -- reduces chance of it duplicating and breaking

        runHaxeCode([[
        game.modchartTweens.set(']]..tag..[[',
            FlxTween.tween(Lib.current.stage,
                {]]..var..[[: ]]..value..[[},
                ]]..duration..[[,
                {ease: FlxEase.]]..ease..[[,
                type: ]]..types..[[
            })
        );
        ]])
    else
        if allowWinTween then
            cancelTween(tag) -- reduces chance of it duplicating and breaking

            runHaxeCode([[
                game.modchartTweens.set(']]..tag..[[',
                    FlxTween.tween(Lib.current.stage,
                        {]]..var..[[: ]]..value..[[},
                        ]]..duration..[[,
                        {ease: FlxEase.]]..ease..[[,
                        type: ]]..types..[[
                    })
                );
            ]])
        end
    end
end

--function onPause()
	-- may need to lock pausing during sections so the game doesn't explode
	--if not ableToPause then
		--return Function_Stop
	--end
--end

function onDestroy()
    setPropertyFromClass('Main', 'fpsVar.visible', fpsVisible)

    runHaxeCode([[
    if (FlxG.save.data.seenCreditsRoll) {

            Lib.application.window.borderless = false;
            Lib.application.window.opacity = 1;

            FlxG.scaleMode = PlayState.getStageSizeScaleMode();
            FlxG.resizeGame(1280, 720);
            FlxG.resizeWindow(1280, 720);

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
    }
    ]]);
end

function onStepHit() -- STEP EVENTS
    if curStep == 208 then
        setProperty("camGame.alpha", 1)
    end

    if curStep == 216 or curStep == 352 or curStep == 480 or curStep == 608 then
        noteSpinLeft()
    end

    if curStep == 220 or curStep == 356 or curStep == 484 or curStep == 612 then
        noteSpinRight()
    end

    if curStep == 720 then
        windowLock = false
    end

    if curStep == 736 then
        windowLock = true

        setProperty("camHUD.alpha", 0)
    end

    if curStep == 928 then
        if flashingLights then
            cameraFlash("camOther", "FF0000", 1, true)
        end
        setProperty("camHUD.alpha", 1)
    end

    if curStep == 1176 then
        setProperty("camHUD.alpha", 0)
    end

    if curStep == 1230 then
        doTweenAlpha("camHUD", "camHUD", 1, 1.3, "linear")
    end

    if curStep == 1438 then
        doTweenAlpha("camHUD", "camHUD", 0, 0.2, "linear")

        doTweenAlpha("camHUD", "camHUD", 0, 0.2, "linear")
        doTweenAlpha("fusionCutsceneFade", "fusionCutsceneFade", 1, 0.2, "linear")
    end

    if curStep == 1440 then
        setProperty("camHUD.alpha", 0)
    end

    if curStep >= 1447 and not safetyNet6 then
        removeLuaSprite("fusionCutsceneFade")
        cameraFlash("camOther", "EDFCD5", 1.5, true)
        setProperty('healthLabel.alpha', 1)
        setProperty('healthValue.alpha', 1)
        setProperty('healthLabelShadow.alpha', 1)
        setProperty('healthValueShadow.alpha', 1)
        setProperty("camGame.alpha", 1)
        setProperty("camHUD.alpha", 1)
        safetyNet6 = true
    end

    if curStep == 1824 then

        doTweenAlpha("camHUD", "camHUD", 0, 1.5, "linear")

        cameraFade("camGame", "000000", 1.5, false, true)
    end

    if curStep == 2048 then
        callMethod('camGame.fade', {0x000000, 3, true}) -- cuz cameraFade wants to be a wanker
    end

    if curStep == 2080 then
        doTweenZoom("xZoom", "camGame", 1.3, 2.4, "linear")
    end

    if curStep == 2104 then
        setProperty('welcomeBack.alpha', 1)
        setProperty('welcomeBackText.alpha', 1)
    end

    if curStep == 2106 then
        playAnim("welcomeBack", "fade")
    end

    if curStep == 2108 then
        playAnim("welcomeBackText", "BACK")
    end

    if curStep == 2110 then
        removeLuaSprite("welcomeBackText")
        playAnim("welcomeBack", "glitch")
    end

    if curStep == 2112 then
        removeLuaSprite("welcomeBack")
        setProperty("camHUD.alpha", 1)
    end

    if curStep == 2240 then
        cameraFlash("camGame", "EEFAD5", 0.5, true)

        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            ]])
        end

        setProperty('brightnessVar.x', 0.00)
        setProperty('contrastVar.x', 3)
        setProperty('saturationVar.x', 1.50)

        windowShakeX = windowOriginX
		windowShakeY = windowOriginY

        windowLock = false
        windowShaking = true

        setProperty("shakeLevelMinVar.x", -100)
		setProperty("shakeLevelMaxVar.x", 100)

		doTweenX("shakeLevel1", "shakeLevelMinVar", -5, 0.33, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 5, 0.33, "quadOut")
    end

    if curStep == 2368 then
        setProperty("dad.visible", false)
        setProperty("boyfriend.visible", false)
        setProperty('lordXJumpscares.alpha', 1)

        doTweenX("shakeLevel1", "shakeLevelMinVar", 0, 0.2, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 0, 0.2, "quadOut")
    end

    if curStep == 2376 then
        setProperty("dad.visible", false)
        setProperty("boyfriend.visible", false)
        setProperty("lordXJumpscares.visible", true)
        playAnim("lordXJumpscares", "3")

        setProperty("shakeLevelMinVar.x", -100)
		setProperty("shakeLevelMaxVar.x", 100)

		doTweenX("shakeLevel1", "shakeLevelMinVar", -5, 0.9, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 5, 0.9, "quadOut")
    end

    if curStep == 2384 then
        setProperty("dad.visible", true)
        setProperty("boyfriend.visible", true)
        setProperty("lordXJumpscares.visible", false)
        cameraFlash("camGame", "EEFAD5", 0.5, true)

        windowShaking = false
        windowLock = true
    end

    if curStep == 2432 then
        setProperty('brightnessVar.x', 0.00)
        setProperty('contrastVar.x', 1.00)
        setProperty('saturationVar.x', 1.00)

        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            ]])
        end
    end

    if curStep >= 2444 and curStep < 2448 then
        windowLock = false

        if windowFuckery then
            setPropertyFromClass('openfl.Lib','application.window.x', windowOriginX + getRandomFloat(-50, 50))
            setPropertyFromClass('openfl.Lib','application.window.y', windowOriginY + getRandomFloat(-50, 50))
        end
    end

    if curStep == 2448 then
        windowLock = true
    end

    if curStep == 2464 then
        doTweenAlpha("camHUD", "camHUD", 0, 2.25, "linear")
    end

    if curStep == 2496 then
        setProperty("internalColour.alpha", 1)

        setProperty("dad.alpha", 0)
        setProperty("boyfriend.alpha", 0)

        setProperty("cameraSpeed", 999)
    end

    if curStep >= 2520 and not safetyNet1 then
        setProperty("dad.alpha", 1)
        setProperty("cameraSpeed", 2)

        doTweenAlpha("camHUD", "camHUD", 1, 0.5, "sineOut")
        safetyNet1 = true
    end

    if curStep == 2527 then internalBGBop = true end
    if curStep == 2528 then 
        setProperty("internalBG.alpha", 1) 
        setProperty("internalOverlay.alpha", 0.7)
        setProperty("internalGradient.alpha", 1)
    end

    if internalBGBop then
        if curStep % 2 == 0 then
            internalBGBeat = internalBGBeat + 1
            if internalBGBeat > 7 then internalBGBeat = 0 end
            
            playAnim("internalBG", tostring(internalBGBeat), true)

            if internalFlipShiet then
                internalFlipShiet = false
                if getProperty("internalOverlay.flipX") then
                    setProperty("internalOverlay.flipX", false)
                else 
                    setProperty("internalOverlay.flipX", true)
                end
            else 
                internalFlipShiet = true
                if getProperty("internalOverlay.flipY") then
                    setProperty("internalOverlay.flipY", false)
                else 
                    setProperty("internalOverlay.flipY", true)
                end
            end
        end
    end

    if curStep == 2738 and curStep < 2740 then
        windowLock = false
        if shadersEnabled then
            setShaderFloat("glitchShader", "iTime", os.clock())

            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader)]);
            ]])
        end
    end

    if curStep == 2740 then
        windowLock = true
        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            ]])
        end
    end

    if curStep == 2779 then internalBGBop = false end

    if curStep >= 2780 and curStep < 2784 then
        windowLock = false

        if windowFuckery then
            setPropertyFromClass('openfl.Lib','application.window.x', windowOriginX + getRandomFloat(-500, 500))
            setPropertyFromClass('openfl.Lib','application.window.y', windowOriginY + getRandomFloat(-150, 150))
        end

        --setPropertyFromClass('openfl.Lib', 'application.window.opacity', getRandomFloat(0.1, 1)) -- said to take this out, keeping it here in case it's needed again
        --setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0.25)

        if shadersEnabled then
            setShaderFloat("glitchShader", "iTime", os.clock())

            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader)]);
                game.camFX.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader), new ShaderFilter(game.getLuaObject('fisheyeShader'))]);
            ]])
        end
    end

    if curStep == 2780 then
        setProperty('dad.skipDance', true)
    end

    if curStep == 2783 then
        setProperty('camZooming', false)
    end

    --[[

    if curStep == 2781 then
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0.15)
    end

    if curStep == 2782 then
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0.5)
    end

    if curStep == 2783 then
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0.85)
    end
    ]]

    if curStep == 2784 then
        setProperty('dad.skipDance', true)
        windowLock = true
        pauseOverride = true
        setProperty('canPause', false)

        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 1)

        setProperty("camHUD.alpha", 0)
        cancelTimer('internalShaderShiet')
        internalShaderUpdate = false

        makeLuaSprite('illegal', 'illegal', 270, 300)
        scaleObject("illegal", 3.0, 3.0)
        setScrollFactor("illegal", 0.0, 0.0)
        setObjectCamera("illegal", 'other')
        setProperty("illegal.antialiasing", false)
        addLuaSprite("illegal", false)
    end

    if curStep == 2796 then
        setProperty("camGame.alpha", 0)
        setProperty("internalBG.alpha", 0)
        setProperty("internalOverlay.alpha", 0)
        setProperty("internalGradient.alpha", 0)
        setProperty("internalColour.alpha", 0)
        setProperty("illegal.alpha", 0)
    end

    if curStep == 2800 then
        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader), new ShaderFilter(game.getLuaObject('glitchShader').shader)]);
            ]])
        end

        makeLuaSprite('fakeCrash', 'crashScreen', 250, 30)
        scaleObject("fakeCrash", 1, 1)
        setScrollFactor("fakeCrash", 0.0, 0.0)
        setObjectCamera("fakeCrash", 'other')
        scaleObject("fakeCrash", 3, 3)
        setProperty("fakeCrash.antialiasing", false)
        addLuaSprite("fakeCrash", true)

        setPropertyFromClass('openfl.Lib', 'application.window.title', "UH OH!")

        setProperty("dad.visible", true)
    end

    if curStep == 2860 then        
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0)

        runHaxeCode("FlxG.autoPause = false;") -- just so people dont fuck up and click off
        
        setProperty("camGame.alpha", 0)
        setProperty("camHUD.alpha", 0)
        setProperty("camOther.alpha", 0)
    end

    if curStep == 2877 then
        setProperty("cameraSpeed", 999) --instant transition
    end

    if curStep == 2880 then
        setProperty("boyfriend.alpha", 1)
        removeLuaSprite("internalOverlay", false)
        removeLuaSprite("internalBG", false)
        removeLuaSprite("internalColour", true)
        removeLuaSprite("internalGradient", true)
        removeLuaSprite("fakeCrash", true)
        removeLuaSprite("illegal", true)
    end

    if curStep == 2881 then
        setProperty("cameraSpeed", 2) -- reset back to normal
    end

    if curStep >= 2896 and curStep < 3568 then
        windowLock = true -- because if the game is off focus they'll skip these steps
    end

    if curStep >= 2912 and not safetyNet2 then
        allowZoom = false
        pauseOverride = false
        
        cameraFlash("camOther", "EDFCD5", 7, true)

        setProperty('canPause', true)

        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            ]])
        end
        runHaxeCode('Lib.application.window.focus();')
        setProperty("camGame.zoom", 7)
        doTweenZoom("rewriteTime", "camGame", 1.1, 10, "sineInOut")

        setProperty("camGame.alpha", 1)
        setProperty("camOther.alpha", 1)
        
        safetyNet2 = true
    end

    if curStep == 3024 then
        allowZoom = true
    end

    if curStep == 3039 then
        setProperty('camZooming', true)
    end

    if curStep == 3040 then
        doTweenAlpha("camHUD", "camHUD", 1, 2, "sineOut")
    end

    if curStep == 3084 then
        setProperty('iAmGod.alpha', 1)
        playAnim('iAmGod', 'iAmGod', true, false, 0)
    end

    if curStep == 3100 then
        setProperty('iAmGod.alpha', 0)
    end

    if curStep == 3568 then --fullscreen rewrite part
        windowLock = false
        windowShaking = true

        playAnim('rewriteStomp', 'animation', true)
        setProperty("rewriteStomp.alpha", 1)

        windowShakeX = windowOriginX
		windowShakeY = windowOriginY

        setProperty("shakeLevelMinVar.x", -30)
		setProperty("shakeLevelMaxVar.x", 30)

		doTweenX("shakeLevel1", "shakeLevelMinVar", 0, 0.25, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 0, 0.25, "quadOut")
    
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
    end

    if curStep == 3570 then
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
    end

    if curStep == 3573 then
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
    end

    if curStep == 3574 then
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
    end

    if curStep == 3576 then
        setProperty("shakeLevelMinVar.x", -50)
		setProperty("shakeLevelMaxVar.x", 50)

		doTweenX("shakeLevel1", "shakeLevelMinVar", 0, 0.25, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 0, 0.25, "quadOut")
        
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
    end

    if curStep == 3584 then

        allowWinTween = true

        lockShakeX = true

        doTweenWindow('16:9', 'width', 1280, 0.25,'bounceOut',1)
        doTweenStage('16:9 (2)', 'stageWidth', 1280, 0.25,'bounceOut',1)
        doTweenWindow('16:9 (3)', 'x', windowOriginX -230, 0.25,'bounceOut',1)

        doTweenX('camGameX', 'camGame', 0, 0.25, 'bounceOut')
        doTweenX('camHUDX', 'camHUD', 0, 0.25, 'bounceOut')
        doTweenX('camOtherX', 'camOther', 0, 0.25, 'bounceOut')
        doTweenX('camVideoX', 'camVideo', 0, 0.25, 'bounceOut')

        setProperty("shakeLevelMinVar.x", -100)
		setProperty("shakeLevelMaxVar.x", 100)

		doTweenX("shakeLevel1", "shakeLevelMinVar", 0, 0.2, "quadOut")
		doTweenX("shakeLevel2", "shakeLevelMaxVar", 0, 0.2, "quadOut")
    end

    if curStep == 3592 then

        lockShakeX = false

        windowShakeX = windowOriginX -- - 230

        runHaxeCode([[
            FlxG.resizeGame(1280, 720);
            FlxG.resizeWindow(1280, 720);
        ]]);

        doTweenX('camGameX', 'camGame', -230, 0.01, 'bounceOut')
        doTweenX('camHUDX', 'camHUD', -230, 0.01, 'bounceOut')
        doTweenX('camOtherX', 'camOther', -230, 0.01, 'bounceOut')
        doTweenX('camVideoX', 'camVideo', -230, 0.01, 'bounceOut')
        -- idk why the fuck the camera gets pushed to the right when trying to repair it back to NORMAL but ok whatever really easy fix so idc

        setProperty("shakeLevelMinVar.x", -150)
		setProperty("shakeLevelMaxVar.x", 150)

		doTweenX("windowFull1", "shakeLevelMinVar", 0, 0.2, "quadOut")
		doTweenX("windowFull2", "shakeLevelMaxVar", 0, 0.2, "quadOut") 
    end

    if curStep == 3596 then

        --allowZoom = false

        windowShaking = false
    
        doTweenWindow('fullscreen1', 'width', maxWidth+1, 0.4,'quintIn',1)
        doTweenWindow('fullscreen2', 'height', maxHeight+1, 0.4,'quintIn',1)

        doTweenWindow('fullscreen3', 'x', 0, 0.4,'quintIn',1)
        doTweenWindow('fullscreen4', 'y', 0, 0.4,'quintIn',1)
    end

    if curStep >= 3600 and not fullscreenLagCheck1 then
        --setProperty("camGame.visible", false)

        setProperty("camHUD.alpha", 0)

        setProperty('fullScreenIntroBG.alpha', 1)
        setProperty("camOther.visible", false)
        setProperty("boyfriend.alpha", 0)

        setPropertyFromClass('Main', 'fpsVar.visible', false)

        --doTweenZoom("camHUD", "camHUD", 0.75, 0.001, "sineInOut") -- potentially zooming out the hud camera to make it more readable(?)

        setProperty('healthLabel.x', 250 - 230)
        setProperty('healthValue.x', 380 - 230)
        setProperty('healthLabelShadow.x', 255 - 230)
        setProperty('healthValueShadow.x', 385 - 230)

        fullscreenLagCheck1 = true
    end

    if curStep >= 3656 and not fullscreenLagCheck2 then
        doTweenAlpha("camHUD", "camHUD", 1, 0.25, "sineInOut")

        fullscreenLagCheck2 = true
    end

    if curStep >= 3660 and not fullscreenLagCheck3 then
        playAnim("fullScreenIntro", "loop")
        removeLuaSprite("rewriteStomp")

        fullscreenLagCheck3 = true
    end

    if curStep >= 3664 and not fullscreenLagCheck4 then
        cameraFlash("camHUD", "EEFAD5", 0.25, false)
        doTweenColor('fullScreenIntroBG', 'fullScreenIntroBG', 'EEFAD5', 0.1, 'linear')

        setProperty('fullScreenIntro.alpha', 1)

        fullscreenLagCheck4 = true
    end

    if curStep >= 3667 and not fullscreenLagCheck5 then
        doTweenX('fullScreenRunning', 'fullScreenRunning', 500, 2, 'quadOut')
        
        fullscreenLagCheck5 = true
    end

    if curStep == 3692 then
        setProperty('pillarWipe.alpha', 1)
        playAnim("pillarWipe", "wipe", true, false, 0)
    end

    if curStep == 3696 then
        setProperty('pillarWipe.alpha', 0)
        doTweenX("sa2Posing", "sa2Posing", 600, 6.75, "linear")
        doTweenX("sa2Posing2", "sa2Posing2", 200, 6.75, "linear")
    end

    if curStep == 3728 then
        doTweenColor('fullScreenIntroBG', 'fullScreenIntroBG', 'EEFAD5', 0.001, 'linear')
        setProperty('sa2PosingShadow.alpha', 1)
        setProperty('sa2Posing2Shadow.alpha', 1)
    end

    if curStep == 3729 then
        doTweenColor('fullScreenIntroBG', 'fullScreenIntroBG', '100410', 1.5, 'quadIn')
        doTweenAlpha('sa2PosingShadow', 'sa2PosingShadow', 0, 1.5, 'quadIn')
        doTweenAlpha('sa2Posing2Shadow', 'sa2Posing2Shadow', 0, 1.5, 'quadIn')
    end

    if curStep == 3768 then
        doTweenX("sa2Posing", "sa2Posing", 1280, 0.25, "quadIn")
        doTweenX("sa2Posing2", "sa2Posing2", -1280, 0.25, "quadIn")
    end

    if curStep == 3772 then
        doTweenAlpha("ring", "ring", 1, 0.45, "quadInOut") 

        setProperty('boyfriendRing.alpha', 1)
        doTweenY("boyfriendRing", "boyfriendRing", 0, 0.45, "quadInOut") 
    end

    if curStep == 3776 then
        removeLuaSprite("boyfriendRing")
        removeLuaSprite("ring")
        removeLuaSprite("fullScreenIntroBG")
    end

    if curStep >= 3785 and curStep <= 3789 then
        makeGraphic('transColour', 2500, 2000, '000000')
        setProperty('transColour.alpha', 1)
    end

    if curStep == 3790 then
        runTimer('glitch1', 0.05) -- EVEN THO THIS IS REDUNDANT DON'T REMOVE IT CUZ THE GAME'S KINDA FUCKED UP WITHOUT IT IDK WHAT I DID WRONG OH WELL
    end

    if curStep == 3792 then
        if not downscroll then
            setProperty("camHUD.y", 720)
        else
            setProperty("camHUD.y", -720)
        end
        setProperty('defaultCamZoom', 0.9)
        setProperty('camGame.zoom', 0.9)
        setProperty("boyfriend.alpha", 0)
        setProperty("camGame.visible", true)

        
        noteCheck = true

        for i = 0,7 do
            runHaxeCode('game.strumLineNotes.members['..i..'].camera = getVar("camNotes");') -- JUST TO FUCKING MAKE SURE THIS SHIT WORKS
        end

        setProperty("camNotes.zoom", 0.75)
        setProperty("camNotes.alpha", 0)
    end

    if curStep == 3837 then
        runTimer('rewriteCutsceneTransition', 0.04) -- the timing is very precise,,,
    end

    if curStep == 3840 then
        --cameraFlash("camOther", "FFFFFF", 0.25, true)
        setProperty("rewriteCutscene.alpha", 1)
        playAnim("rewriteCutscene", "rewriteCutscene", false, false, 0)
        
        makeGraphic('transColour', 2500, 2000, '000034')

        setProperty('defaultCamZoom', 0.7)
        setProperty('camGame.zoom', 0.7)
    end

    if curStep >= 3852 and not safetyNet3 then
        setProperty("dad.y", getProperty("dad.y")+900)
        safetyNet3 = true
    end

    if curStep == 3888 then
        makeGraphic('transColour', 2500, 2000, '131313')
    end

    if curStep >= 3920 and not safetyNet4 then

        setProperty("lyricsPlaceholder.alpha", 1)

        playAnim("desktopRift", "desktopRift")
        playAnim("desktopRiftMask", "desktopRiftMask")
        setProperty('blackMask.alpha', 1)
        setProperty('desktopRift.alpha', 1)
        setProperty('desktopRiftMask.alpha', 1)

        setProperty("redClouds.alpha", 1)

        if shadersEnabked then
            setSpriteShader("desktopRift", "glitch")
        end

        doTweenY("hiSonic", "dad", 200, 0.75, "sineOut")

        doTweenY("oops", "rewriteCutscene", -730, 0.75, "quadIn")

        safetyNet4 = true
    end

    if curStep == 3924 or curStep == 3956 then
        if curStep == 3956 then
            playAnim("lyricsPlaceholder", "PLAY", true, false, 0)
        else
            playAnim("lyricsPlaceholder", "PLAY", true, false, 0)
        end
    end

    if curStep == 3928 or curStep == 3960 then
        playAnim("lyricsPlaceholder", "A", true, false, 0)
    end

    if curStep == 3932 or curStep == 3964 then
        playAnim("lyricsPlaceholder", "GAME", true, false, 0)
    end

    if curStep == 3936 then
        playAnim("lyricsPlaceholder", "FOR", true, false, 0)
    end

    if curStep == 3940 then
        playAnim("lyricsPlaceholder", "OLD", true, false, 0)
    end

    if curStep == 3944 then
        playAnim("lyricsPlaceholder", "TIME", true, false, 0)
    end

    if curStep == 3948 then
        playAnim("lyricsPlaceholder", "SAKE", true, false, 0)
    end

    if curStep == 3952 then
        playAnim("lyricsPlaceholder", "LETS", true, false, 0)
    end

    if curStep == 3968 then
        playAnim("lyricsPlaceholder", "ARE", true, false, 0)
    end

    if curStep == 3972 then
        playAnim("lyricsPlaceholder", "YOU", true, false, 0)
    end

    if curStep == 3976 then
        playAnim("lyricsPlaceholder", "READY", true, false, 0)
    end

    if curStep == 3980 then
        playAnim("lyricsPlaceholder", "READY-glitch1", true, false, 0)

        setProperty("flashbang.visible", true)
        setProperty("transColour.visible", false)
        setProperty("camGame.visible", false)
        setProperty("aspect.visible", true)
    end

    if curStep == 3981 then
        playAnim("lyricsPlaceholder", "READY-glitch2", true, false, 0)

        setProperty("transColour.visible", false)
        setProperty("camGame.visible", true)
        setProperty("aspect.visible", true)

        makeGraphic('flashbang', 2500, 2000, 'FF0000')
        setBlendMode("flashbang", 'multiply')
    end

    if curStep == 3982 then
        setProperty("transColour.visible", true)
        setProperty("camGame.visible", false)
        setProperty("aspect.visible", false)    

        removeLuaSprite("flashbang")

        playAnim("lyricsPlaceholder", "READY-glitch3", true, false, 0)
    end

    if curStep == 3983 then
        setProperty("camGame.visible", true)
        playAnim("lyricsPlaceholder", "READY-glitch4", true, false, 0)
    end

    if curStep == 3984 then
        removeLuaSprite("lyricsPlaceholder")
    end

    if curStep == 4032 then

        if not downscroll then
            for i = 0, getProperty('playerStrums.length') do
                setPropertyFromGroup('playerStrums', i, 'y', 850);
            end
        else
            for i = 0, getProperty('playerStrums.length') do
                setPropertyFromGroup('playerStrums', i, 'y', -300);
            end
        end

        setPropertyFromGroup("strumLineNotes", 4, "x", 330)
        setPropertyFromGroup("strumLineNotes", 5, "x", 500)
        setPropertyFromGroup("strumLineNotes", 6, "x", 670)
        setPropertyFromGroup("strumLineNotes", 7, "x", 840)

        allowNoteSway = true
        noteTweenX("random1", 4, 330+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        noteTweenX("random2", 5, 500+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        noteTweenX("random3", 6, 670+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        noteTweenX("random4", 7, 840+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")

        if not downscroll then
            noteTweenY("leftNoteSet", 4, 50, 0.25, "sineOut")
        else
            noteTweenY("leftNoteSet", 4, 600, 0.25, "sineOut")
        end    
        
        doTweenY('camHUD', 'camHUD', 0, 0.5, 'sineOut')
        setProperty("camNotes.alpha", 1)
    end

    if curStep == 4036 then
        if not downscroll then
            noteTweenY("downNoteSet", 5, -100, 0.25, "sineOut")
        else
            noteTweenY("downNoteSet", 5, 650, 0.25, "sineOut")
        end
    end

    if curStep == 4040 then
        if not downscroll then
            noteTweenY("upNoteSet", 6, -100, 0.25, "sineOut")
        else
            noteTweenY("upNoteSet", 6, 650, 0.25, "sineOut")
        end
    end

    if curStep == 4044 then
        if not downscroll then
            noteTweenY("rightNoteSet", 7, 50, 0.25, "sineOut")
        else
            noteTweenY("rightNoteSet", 7, 600, 0.25, "sineOut")
        end
        
        playAnim("windowVessel", "windowVessel", true, false, 0)

        setProperty('windowBlack.alpha', 1)
        setProperty('windowVessel.alpha', 1)

        setProperty("boyfriend.x", 1240)
        setProperty("boyfriend.y", 495)
        setProperty("boyfriend.alpha", 1)
    end

    if curStep >= 4170 and not noteSafety1 then
        allowNoteSway = false
        cancelTween("random1")
        cancelTween("random2")
        cancelTween("random3")
        cancelTween("random4")
        noteSafety1 = true
    end

    if curStep >= 4172 and not noteSafety2 then

        cancelTween("random1")
        cancelTween("random2")
        cancelTween("random3")
        cancelTween("random4")

        cancelTween("leftUp")
        cancelTween("leftDown")

        cancelTween("downUp")
        cancelTween("downDown")

        cancelTween("upUp")
        cancelTween("upDown")

        cancelTween("rightUp")
        cancelTween("rightDown")

        playAnim("desktopRift", "desktopRift", true, true, 0)
        playAnim("desktopRiftMask", "desktopRiftMask", true, true, 0)

        if not downscroll then
            for i = 0,3 do
                noteTweenX(i..'mid',i+4,screenWidth/2+(140*(i-2)),0.35, 'quadOut')
                noteTweenY(i..'originY', i+4, noteYOrigin - 125, 0.35, "quadOut")
            end
        else
            for i = 0,3 do
                noteTweenX(i..'mid',i+4,screenWidth/2+(140*(i-2)),0.35, 'quadOut')
                noteTweenY(i..'originY', i+4, noteYOrigin + 125, 0.35, "quadOut")
            end
        end

        doTweenAlpha("dad", "dad", 0, 0.3, "quadOut") -- TEMPORARY!!!

        noteSpinLeft()
        noteSafety2 = true
    end

    if curStep >= 4173 and not safetyNet5 then
        runTimer('rewriteWindow', 0.04) -- the timing is very precise,,,

        cancelTween("sonicFallUp")
        cancelTween("sonicFallDown")
        setProperty("dad.y", getProperty("dad.y")-900)
        safetyNet5 = true
    end

    if curStep >= 4176 and not safetyNetIDKANYMORE then
        setProperty("desktopRift.alpha", 0)
        setProperty("desktopRiftMask.alpha", 0)
        setProperty("blackMask.alpha", 0)

        setProperty("redClouds.alpha", 0)

        safetyNetIDKANYMORE = true
    end

    if curStep == 4182 then
        setProperty("boyfriend.alpha", 0)
        removeLuaSprite("bfMask")
        removeLuaSprite("windowBlack")
    end

    if curStep >= 4232 and not safetyHEAD then
        setProperty("rewriteHead.alpha", 1)
        doTweenX("rewriteHeadX", "rewriteHead", 498 - 250, 0.75, "linear")
        doTweenY("rewriteHeadY", "rewriteHead", 133 - 100 , 0.3, "quadOut")
        doTweenAngle("rewriteHeadAngle", "rewriteHead", -160, 0.75, "linear")

        safetyHEAD = true
    end

    if curStep == 4236 then
        doTweenY("rewriteHeadY", "rewriteHead", 133 + 720 , 0.3, "quadIn")
    end

    if curStep == 4242 then
        setProperty("rewriteWindowBox.visible", false) -- DO NOT REMOVE THESE SPRITES, I SET THEM TO NON-VISIBLE TO STOP THE GAME FROM CRASHING, it's likely due to the sprites being removed too early while the tween exists, that's my guess
        setProperty("rewriteHead.visible", false)
    end

    if curStep >= 4240 and not safetyHEAD2 then

        for i = 0,3 do
            noteTweenX(i..'midScroll',i+4,screenWidth/2+(140*(i-2)), 0.35, 'quadOut')
        end

        doTweenY("fireeee", "firewall", -160, 4, "quadInOut")

        setProperty("rewriteHeadMask.alpha", 1)
        setProperty("rewriteHeadCorpse.alpha", 1)
        setProperty('firewall.alpha', 1)

        playAnim("rewriteHeadMask", "mask", true, false, 0)
        playAnim("rewriteHeadCorpse", "corpse0", true, false, 0)

        setProperty("blackMask.alpha", 1)

        setProperty("redClouds.alpha", 1)

        safetyHEAD2 = true

        -- something on this step is random chance crashing the game due to a null reference, what the fuck.
        -- idk if it's psych freaking or if it's my fault, just be cautious ig
        -- update: think i found the issue, hopefully
    end

    if curStep == 4300 then
        setProperty("desktopRift.alpha", 0)
        setProperty("desktopRiftMask.alpha", 0)

        removeSpriteShader("dad")
        setProperty('firewall.animation.curAnim.paused', true)
        playAnim("rewriteHeadCorpse", "corpseGlitch", true, false, 0)

        setProperty("redClouds.alpha", 1)
        setProperty('redClouds.velocity.x', 0)

        setProperty("errorBox1.alpha", 1)
    end

    if curStep == 4301 then
        setProperty("blackMask.alpha", 1)
        setProperty("errorBox2.alpha", 1)
    end

    if curStep == 4302 then
        setProperty("errorBox3.alpha", 1)
    end

    if curStep == 4303 then
        setProperty("errorBox4.alpha", 1)
    end

    if curStep >= 4304 and not safetyTrans then

        secondHalfStart = true

        runHaxeCode('game.getLuaObject("mindLyrics").camera = getVar("camLyrics");')
        runHaxeCode('game.getLuaObject("ogLyrics").camera = getVar("camLyrics");')

        setProperty("redClouds.visible", true)

        setProperty("errorBox1.alpha", 0)
        setProperty("errorBox2.alpha", 0)
        setProperty("errorBox3.alpha", 0)
        setProperty("errorBox4.alpha", 0)

        setProperty("dad.alpha", 1)

        doTweenY("hiSonic", "dad", 225, 0.5, "sineOut")

        doTweenY("byeCorpses", "rewriteHeadCorpse", 1000, 0.3, "quadIn")
        doTweenY("fireeee", "firewall", 900, 0.3, "quadIn")

        doTweenX("transition1", "rewriteHeadMask.scale", 12, 0.4, "quadInOut")
        doTweenY("transition2", "rewriteHeadMask.scale", 12, 0.4, "quadInOut")

        if shadersEnabled then
            setProperty('redClouds.velocity.x', -2000)
        else
            setProperty('redClouds.velocity.x', -3000)
        end
        safetyTrans = true
    end

    if curStep == 4312 then
        runHaxeCode('Lib.application.window.warpMouse(FlxG.mouse.x + 1, FlxG.mouse.y);')
    end

    if curStep == 4438 then
        doTweenAlpha("redClouds1Alpha", "redClouds", 0.75, 0.25, "linear")
        setProperty('fleshBG.alpha', 0.001)
    end

    if curStep == 4406 then
        doTweenAlpha("redClouds1Alpha", "redClouds", 0.5, 0.25, "linear")
        setProperty('fleshBG.alpha', 0.001)
    end

    if curStep == 4414 then
        doTweenAlpha("redClouds1Alpha", "redClouds", 0.25, 0.25, "linear")
        setProperty('fleshBG.alpha', 0.001)
    end

    if curStep == 4422 then
        doTweenAlpha("redClouds1Alpha", "redClouds", 0, 0.25, "linear")
        setProperty('fleshBG.alpha', 0.001)
    end

    if curStep == 4430 then
        cancelTween("sonicFallDown")
        cancelTween("sonicFallUp")
        doTweenY("center", "dad", 500, 0.3, "quadIn")
        doTweenX("dadScaleX", "dad.scale", 4, 0.001, "quadIn")
        doTweenY("dadScaleY", "dad.scale", 4, 0.001, "quadIn")
    end

    if curStep == 4432 then
        cameraFlash("camGame", "FF0000", 0.33, true)
        setProperty("gf.alpha", 1)
        doTweenAlpha("darkFade", "gf", 0, 1, "quadIn")
    end

    if curStep >= 4432 and curStep < 4512 then
        setProperty('fleshBG.colorTransform.redOffset', -50)
        setProperty('fleshBG.colorTransform.blueOffset', -50)
        setProperty('fleshBG.colorTransform.greenOffset', -50)

        setProperty('fleshBG.alpha', 1) --its randomly disappearing???
    end

    if curStep == 4494 then
        playAnim('fella1', 'rise', true, false, 0)
        setProperty('fella1.alpha', 1)
    end

    if curStep == 4498 then
        playAnim('fella2', 'rise', true, false, 0)
        setProperty('fella2.alpha', 1)
    end

    if curStep == 4502 then
        playAnim('fella3', 'rise', true, false, 0)
        setProperty('fella3.alpha', 1)
    end

    if curStep == 4506 then
        playAnim('fellaJumpscare', 'rise', true, false, 0)
        setProperty('fellaJumpscare.alpha', 1)
    end

    if curStep == 4512 then
        setProperty('fella1.alpha', 0)
        setProperty('fella2.alpha', 0)
        setProperty('fella3.alpha', 0)
        setProperty("camNotes.alpha", 0)
        playAnim('fellaJumpscare', 'loop', true, false, 0)
    end

    if curStep >= 4512 and curStep < 4528 then
        setProperty('jumpscare.alpha', 1)
        setProperty('fleshBG.alpha', 0)
        setProperty("redClouds.alpha", 1)

        if flashingLights then
            if curStep %2 == 0 then
                doTweenColor('jumpscareColor', 'jumpscare', 'DAE099', 0.001, 'linear') --tweens becuase setProperty wasn't acting correctly and displayed incorrect colours :P
                -- reminder for me, less saturated color in case it's too much: '949468'
            else
                doTweenColor('jumpscareColor', 'jumpscare', '696A95', 0.001, 'linear')
            end
        else
            doTweenColor('jumpscareColor', 'jumpscare', '696A95', 0.001, 'linear') -- no flashing just the solid blue, cuz drev will want to kill me
        end
    end

    if curStep == 4528 then
        setProperty("camHUD.alpha", 0)
        setProperty('fellaJumpscare.alpha', 0)
        doTweenX("dadScaleX", "dad.scale", 3, 0.001, "quadIn")
        doTweenY("dadScaleY", "dad.scale", 3, 0.001, "quadIn")
        doTweenY("hiSonic", "dad", 225, 0.001, "sineOut")
        setProperty('jumpscare.alpha', 0)
    end

    if curStep == 4552 then
        doTweenAlpha("camNotes", "camNotes", 1, 0.25, "quadInOut")
        doTweenAlpha("camHUD", "camHUD", 1, 0.25, "quadInOut")
    end

    if curStep == 4556 then
        if not downscroll then
            for i = 0,3 do
                noteTweenY(i..'originY', i+4, noteYOrigin - 175, 0.2, "quadOut")
            end
        else
            for i = 0,3 do
                noteTweenY(i..'originY', i+4, noteYOrigin + 175, 0.2, "quadOut")
            end
        end
    end

    if curStep == 4558 then
        if not downscroll then
            for i = 0,3 do
                noteTweenY(i..'originY', i+4, noteYOrigin - 65, 0.2, "quadInOut")
            end
        else
            for i = 0,3 do
                noteTweenY(i..'originY', i+4, noteYOrigin + 50, 0.2, "quadInOut")
            end
        end
    end

    if curStep == 4528 then
        noMoreDeath = true
    end 

    if curStep == 4640 then
        setProperty('camHUD.alpha', 0)
        setProperty('camNotes.alpha', 0)
        setGraphicSize('iAmGodScreamer', 1280, 720)
        setProperty('iAmGodScreamer.x', 0)
        setProperty('iAmGodScreamer.alpha', 1)
        doTweenColor('scaryScreamerColor', 'iAmGodScreamer', 'FFFFFF', 0.001, 'linear')
        if flashingLights then
            runTimer('scarySonicColor1', 0.03)
        end
    end

    if curStep == 4648 then
        doTweenAlpha("camHUD", "camHUD", 1, 0.5, "quadOut")
        doTweenAlpha("camNotes", "camNotes", 1, 0.5, "quadOut")
    end

    if curStep == 4656 then
        removeLuaSprite('iAmGodScreamer', false)
    end

    if curStep == 4668 then
        runHaxeCode('game.getLuaObject("rewriteHeadStare").camera = getVar("camLyrics");')
        setProperty('rewriteHeadStare.alpha', 1)
        doTweenY("rewriteHeadStare", "rewriteHeadStare", 0, 1, 'quadInOut')
        setObjectOrder('rewriteHeadStare', getObjectOrder('ogLyrics')-1)
    end

    if curStep == 4684 then
        doTweenY("rewriteHeadStare", "rewriteHeadStare", 550, 0.33, 'quadIn')
    end

    if curStep == 4672 then
        doTweenAlpha('redCloudFade', 'redClouds', 0, 1.2, 'linear')
    end

    
    if curStep == 4688 then --commented in in case i can make this look nice another time perhaps
        if shadersEnabled then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('contrastShader').shader)]);
            ]])
        end

        --[[
        doTweenX('brightness', 'brightnessVar', 0, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 2, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.3, 'quadOut')
        --]]
    end

    if curStep == 4752 then
        --[[
        doTweenX('brightness', 'brightnessVar', 0, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 1, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.3, 'quadOut')
        --]]
    end


    if curStep == 4768 then
        --setProperty("camGame.visible", false)

        setProperty("transColour.visible", true)
        makeGraphic('transColour', 2500, 2000, '000000')
        setProperty("dad.visible", false)

        cancelTween("sonicFallUp")
        cancelTween("sonicFallDown")
        setProperty("dad.y", 225)

        cancelTween("camGameZoom")
        cancelTween("camHUDZoom")
        cancelTween("camNotesZoom")

        setProperty('camGame.zoom', 0.7)
        setProperty('camHUD.zoom', 1)
        setProperty('camNotes.zoom', 0.75)
    end

    if curStep >= 4780 and curStep <= 4784 then
        if curStep %2 == 0 then
            setProperty("dad.visible", true)
        else
            setProperty("dad.visible", false)
        end
    end

    if curStep == 4784 then
        setProperty("transColour.visible", false)

        setProperty('camHUD.alpha', 0)

        setProperty("redClouds.alpha", 1)

        setProperty("camGame.visible", true)
        setProperty("dad.visible", true)
    end

    if curStep >= 4816 and not finalLagCheck then
        setProperty("redClouds.visible", false)

        setProperty('camNotes.alpha', 0)
        setProperty('transColourFinal.alpha', 1) -- because the actual one's acting weird and not showing up, using a new object in case i fucked something up, bad for RAM but oh fucking well i dont care it's being stupid

        setProperty('rewriteKYSHead.x', getProperty('dad.x'))
        setProperty('rewriteKYSHead.y', getProperty('dad.y'))
        setProperty('rewriteKYSHead.alpha', 1)
        doTweenX('headGoBye1', 'rewriteKYSHead', -650, 0.33, 'linear')
        doTweenY('headGoBye2', 'rewriteKYSHead', 100, 0.33, 'quadOut')
        doTweenAngle('headGoBye3', 'rewriteKYSHead', -60, 0.33, 'quadInOut')

        finalLagCheck = true
    end

    if curStep == 4832 then
        setProperty("dad.visible", false)
        setProperty('sparkles.alpha', 1)
    end

    if curStep == 4858 then
        setProperty('transColourFinal.alpha', 0)
        setProperty('sparkles.alpha', 0)
    end
end

function onBeatHit()
    if cameraZoomOnBeat then
        if curBeat >= 948 and curBeat < 972 then
            allowZoom = false

            cancelTween("camGameZoom")
            cancelTween("camOtherZoom")

            setProperty('camGame.zoom', 0.95)
            setProperty('camOther.zoom', 1.05)

            doTweenZoom("camGameZoom", "camGame", 0.9, 0.4, "quadInOut")
            doTweenZoom("camOtherZoom", "camOther", 1, 0.4, "quadInOut")
        end

        if curBeat >= 1076 and curBeat < 1107 then
            allowZoom = false

            cancelTween("camGameZoom")
            cancelTween("camHUDZoom")
            cancelTween("camNotesZoom")

            setProperty('camGame.zoom', 0.75)
            setProperty('camHUD.zoom', 1.05)
            setProperty('camNotes.zoom', 0.8)

            doTweenZoom("camGameZoom", "camGame", 0.7, 0.4, "quadInOut")
            doTweenZoom("camHUDZoom", "camHUD", 1.0, 0.4, "quadInOut")
            doTweenZoom("camNotesZoom", "camNotes", 0.75, 0.4, "quadInOut")
        end

        if curBeat >= 1108 and curBeat < 1160 then
            allowZoom = false

            cancelTween("camGameZoom")
            cancelTween("camHUDZoom")
            cancelTween("camNotesZoom")

            if curBeat %4 == 0 then
                setProperty('camGame.zoom', 0.85)
                setProperty('camHUD.zoom', 1.1)
                setProperty('camNotes.zoom', 0.85)

                doTweenZoom("camGameZoom", "camGame", 0.7, 0.4, "quadInOut")
                doTweenZoom("camHUDZoom", "camHUD", 1.0, 0.4, "quadInOut")
                doTweenZoom("camNotesZoom", "camNotes", 0.75, 0.4, "quadInOut")
            else
                setProperty('camGame.zoom', 0.75)
                setProperty('camHUD.zoom', 1.05)
                setProperty('camNotes.zoom', 0.8)
            
                doTweenZoom("camGameZoom", "camGame", 0.7, 0.4, "quadInOut")
                doTweenZoom("camHUDZoom", "camHUD", 1.0, 0.4, "quadInOut")
                doTweenZoom("camNotesZoom", "camNotes", 0.75, 0.4, "quadInOut")
            end
        end

        if curBeat >= 1164 and curBeat < 1192 then
            allowZoom = false

            cancelTween("camGameZoom")
            cancelTween("camHUDZoom")
            cancelTween("camNotesZoom")

            if curBeat %4 == 0 then
                setProperty('camGame.zoom', 0.85)
                setProperty('camHUD.zoom', 1.1)
                setProperty('camNotes.zoom', 0.85)

                doTweenZoom("camGameZoom", "camGame", 0.7, 0.4, "quadInOut")
                doTweenZoom("camHUDZoom", "camHUD", 1.0, 0.4, "quadInOut")
                doTweenZoom("camNotesZoom", "camNotes", 0.75, 0.4, "quadInOut")
            else
                setProperty('camGame.zoom', 0.75)
                setProperty('camHUD.zoom', 1.05)
                setProperty('camNotes.zoom', 0.8)
            
                doTweenZoom("camGameZoom", "camGame", 0.7, 0.4, "quadInOut")
                doTweenZoom("camHUDZoom", "camHUD", 1.0, 0.4, "quadInOut")
                doTweenZoom("camNotesZoom", "camNotes", 0.75, 0.4, "quadInOut")
            end
        end
    end

    if flashingLights then
        if curBeat >= 1140 and curBeat < 1160 then
            if curBeat %2 == 0 then
                if flashingLights then
                    setProperty('blackMask.colorTransform.redOffset', 255)
                    setProperty('blackMask.colorTransform.blueOffset', 255)
                    setProperty('blackMask.colorTransform.greenOffset', 255)

                    startTween('backtonormal', 'blackMask.colorTransform', {redOffset = 0, blueOffset = 0, greenOffset = 0}, 0.6, {ease = 'quadIn'});

                    setProperty('redClouds.colorTransform.redOffset', -127)
                    setProperty('redClouds.colorTransform.blueOffset', -127)
                    setProperty('redClouds.colorTransform.greenOffset', -127)

                    startTween('backtonormal2', 'redClouds.colorTransform', {redOffset = 0, blueOffset = 0, greenOffset = 0}, 0.6, {ease = 'quadIn'});

                    setProperty("gf.alpha", 1)
                    doTweenAlpha("darkFade", "gf", 0, 0.6, "quadIn")
                end
            end
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'hiSonic' or tag == 'sonicFallUp' then
        doTweenY("sonicFallDown", "dad", getProperty("dad.y")+75, 0.5, "sineInOut")
    end

    if tag == 'sonicFallDown' then
        doTweenY("sonicFallUp", "dad", getProperty("dad.y")-75, 0.5, "sineInOut")
    end

    -- this is scuffed but idc idk modcharting well nowadays lol!!

    if tag == "random1" then
        if allowNoteSway then
            noteTweenX("random1", 4, 330+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        end
    end

    if tag == "random2" then
        if allowNoteSway then
            noteTweenX("random2", 5, 500+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        end
    end

    if tag == "random3" then
        if allowNoteSway then
            noteTweenX("random3", 6, 670+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        end
    end

    if tag == "random4" then
        if allowNoteSway then
            noteTweenX("random4", 7, 840+(getRandomFloat(-10, 10)), getRandomFloat(0.1, 0.3), "sineInOut")
        end
    end

    if tag == "leftUp" then
        if not downscroll then
            noteTweenY("leftDown", 4, 50, 0.4, "sineInOut")
        else
            noteTweenY("leftDown", 4, 600, 0.4, "sineInOut")
        end
    end

    if tag == "leftNoteSet" or tag == "leftDown" then
        if not downscroll then
            noteTweenY("leftUp", 4, 0, 0.45, "sineInOut")
        else
            noteTweenY("leftUp", 4, 550, 0.45, "sineInOut")
        end
    end

    if tag == "downUp" then
        if not downscroll then
            noteTweenY("downDown", 5, -50, 0.35, "sineInOut")
        else
            noteTweenY("downDown", 5, 650, 0.35, "sineInOut")
        end
    end

    if tag == "downNoteSet" or tag == "downDown" then
        if not downscroll then
            noteTweenY("downUp", 5, -100, 0.42, "sineInOut")
        else
            noteTweenY("downUp", 5, 600, 0.42, "sineInOut")
        end
    end

    if tag == "upUp" then
        if not downscroll then
            noteTweenY("upDown", 6, -50, 0.3, "sineInOut")
        else
            noteTweenY("upDown", 6, 650, 0.3, "sineInOut")
        end
    end

    if tag == "upNoteSet" or tag == "upDown" then
        if not downscroll then
            noteTweenY("upUp", 6, -100, 0.3, "sineInOut")
        else
            noteTweenY("upUp", 6, 600, 0.3, "sineInOut")
        end
    end

    if tag == "rightUp" then
        if not downscroll then
            noteTweenY("rightDown", 7, 50, 0.4, "sineInOut")
        else
            noteTweenY("rightDown", 7, 600, 0.4, "sineInOut")
        end
    end

    if tag == "rightNoteSet" or tag == "rightDown" then
        if not downscroll then
            noteTweenY("rightUp", 7, 0, 0.4, "sineInOut")
        else
            noteTweenY("rightUp", 7, 550, 0.4, "sineInOut")
        end
    end
end

function noteSpinRight()
    for i = 4,7 do
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
        noteTweenAngle("spin"..i, i, 360, 0.2, "quadOut")
    end
end

function noteSpinLeft()
    for i = 4,7 do
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
        noteTweenAngle("spin"..i, i, -360, 0.2, "quadOut")
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if shadersEnabled then
        if tag == 'internalShaderShiet' then -- snow if theres a better way to do this in lua let me know haha
            if internalShaderUpdate == true then
                internalShaderUpdate = false
            else 
                internalShaderUpdate = true
            end
        end
    end

    if tag == 'winOpacityFade' then
        setPropertyFromClass('openfl.Lib', 'application.window.opacity', getPropertyFromClass('openfl.Lib', 'application.window.opacity') + 0.1)
    end

    if tag == 'loadBuffer' then --not really needed anymore cuz of the new window code, but more of a precaution to avoid weird loading issues
        doTweenX('camGameX', 'camGame', -230, 0.01, 'quadOut')
        doTweenX('camHUDX', 'camHUD', -230, 0.01, 'quadOut')
        doTweenX('camOtherX', 'camOther', -230, 0.01, 'quadOut')
        doTweenX('camVideoX', 'camVideo', -230, 0.01, 'bounceOut')

        playSound("begin", 1)
        
        makeLuaSprite("trinityTitle", "titleCard/trinityPlaceHolder", 230, 0)
        setProperty("trinityTitle.antialiasing", false)
        scaleObject("trinityTitle", 3.25, 3.25)
        setObjectCamera("trinityTitle", 'other')
        setProperty("trinityTitle.alpha", 0)
        setSpriteShader('trinityTitle', 'contrast')
        addLuaSprite("trinityTitle", false)
        doTweenAlpha("trinityTitle", "trinityTitle", 1, 0.3, "sineOut")

        setProperty('brightnessVar.x', -2.00)
        setProperty('contrastVar.x', 3.00)
        setProperty('saturationVar.x', 2.00)

        setProperty('blue.alpha', 1)

        doTweenX('brightness', 'brightnessVar', 0, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 1, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.3, 'quadOut')

        doTweenAlpha('blue', 'blue', 0, 0.3, 'quadIn')

        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        end

        runTimer('fadeitOut', 2)
        runTimer('startSong', 3)
    end

    if tag == 'fadeitOut' then
        doTweenAlpha("trinityTitle", "trinityTitle", 0, 0.3, "sineOut")

        doTweenX('brightness', 'brightnessVar', -2, 0.3, 'quadOut')
        doTweenX('contrast', 'contrastVar', 3, 0.3, 'quadOut')
        doTweenX('saturation', 'saturationVar', 2, 0.3, 'quadOut')

        doTweenAlpha('blue', 'blue', 1, 0.3, 'quadOut')
    end

    if tag == 'startSong' then
        doTweenX('brightness', 'brightnessVar', 0, 0.5, 'quadOut')
        doTweenX('contrast', 'contrastVar', 1, 0.5, 'quadOut')
        doTweenX('saturation', 'saturationVar', 1, 0.5, 'quadOut')

        doTweenAlpha('blue', 'blue', 0, 0.6, 'quadIn')

        setProperty('blue.alpha', 0)

        startSong = true
        startCountdown()
    end

    if tag == 'fullscreen' then
        doTweenWindow('windowFull1', 'x', 0, 0.01,'quadOut',1)
        doTweenWindow('windowFull2', 'y', 0, 0.01,'quadOut',1)

        doTweenWindow('fullscreen1', 'width', maxWidth+1, 0.01,'linear',1)
        doTweenWindow('fullscreen2', 'height', maxHeight+1, 0.01,'linear',1)
    end

    if tag == 'glitch1' then
        setProperty("transColour.visible", false)
        setProperty("camOther.visible", true)

        runTimer('glitch2', 0.05)
    end

    if tag == "scarySonicColor0" then
        doTweenColor('scaryScreamerColor', 'iAmGodScreamer', 'FFFFFF', 0.001, 'linear')
        runTimer("scarySonicColor1", 0.03)
    end

    if tag == 'scarySonicColor1' then
        doTweenColor('scaryScreamerColor', 'iAmGodScreamer', 'BCBCBC', 0.001, 'linear')
        runTimer("scarySonicColor2", 0.03)
    end

    if tag == "scarySonicColor2" then
        doTweenColor('scaryScreamerColor', 'iAmGodScreamer', '969696', 0.001, 'linear')
        runTimer("scarySonicColor0", 0.03)
    end

    if tag == 'glitch2' then
        setProperty("transColour.visible", true)
        setProperty("camGame.visible", false)
        setProperty("aspect.visible", false)

        runTimer('glitch3', 0.05)
    end

    if tag == 'glitch3' then
        setProperty("transColour.visible", true)
        setProperty("camGame.visible", true)
    end

    if tag == 'rewriteWindow' then
        for i = 0,3 do
            noteTweenX(i..'mid',i+4,screenWidth/3.5+(140*(i-2)),0.35, 'quadOut')
        end

        setProperty('bfMask.alpha', 1)

        doTweenX("bfMaskX", "bfMask", -290 - 450, 0.5, "quadOut")
        doTweenY("bfMaskY", "bfMask", -215 + 50, 0.5, "quadOut")

        doTweenX("windowBlackX", "windowBlack", 1100 - 450, 0.5, "quadOut")
        doTweenY("windowBlackY", "windowBlack", 150 + 50, 0.5, "quadOut")  

        removeLuaSprite("windowVessel")
        playAnim("rewriteWindowBox", "rewriteWindowBox", true, false, 0)
        setProperty('rewriteWindowBox.alpha', 1)

        doTweenX("rewriteWindowBoxX", "rewriteWindowBox", 948 - 450, 0.5, "quadOut")
        doTweenY("rewriteWindowBoxY", "rewriteWindowBox", 83 + 50, 0.5, "quadOut") 
    end

    if tag == "rewriteCutsceneTransition" then
        setProperty("rewriteCutsceneTransition.alpha", 1)
        playAnim("rewriteCutsceneTransition", "rewriteCutsceneTransition", false, false, 0)
    end

    if tag == "frameCheck" then
        setProperty('gf.animation.curAnim.curFrame', getProperty('dad.animation.curAnim.curFrame')) -- trying to force it to sync
    end

    if tag == 'removePillar' then
        setProperty('pillarWipe.alpha', 0)
    end
end

--[[
function onEndSong() --TEMPORARY!!! REMOVE THIS LATER!!!
        doTweenWindow('windowFull1', 'x', 0, 0.01,'quadOut',1)
        doTweenWindow('windowFull2', 'y', 0, 0.01,'quadOut',1)

        doTweenWindow('fullscreen1', 'width', maxWidth+1, 0.01,'linear',1)
        doTweenWindow('fullscreen2', 'height', maxHeight+1, 0.01,'linear',1)

        setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
end
--]] --commented in case i need to test it again