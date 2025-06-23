local safetyNetStage = false

function onCreate()	
	makeLuaSprite('bg', '', -500, -500)
	makeGraphic('bg', 1, 1, 'FFFFFF')
	doTweenColor('bg', 'bg', '100410', 0.0001, 'linear')
	scaleObject('bg', 2000, 2000)
	setScrollFactor('bg', 0, 0)
	addLuaSprite('bg',false)

		makeLuaSprite('skullVelocity', nil, -200, 200)

		if shadersEnabled then
			initLuaShader('fisheye')

			makeLuaSprite("fisheyeShader")
			setSpriteShader("fisheyeShader", "fisheye")
		end
end

function onCreatePost()
		makeLuaBackdrop("remixBG", "trinityRemixSkulls", "XY", 0, 0)

		runHaxeCode([[
			game.getLuaObject("remixBG").velocity.set(-200, 200);
			game.getLuaObject("remixBG").alpha = 0.001;
		]])

		scaleObject('remixBG', 1, 1)
		addLuaBackdrop("remixBG", true)

		makeLuaBackdrop("remixBGInvert", "trinityRemixSkullsInvert", "XY", 0, 0)

		runHaxeCode([[
			game.getLuaObject("remixBGInvert").velocity.set(-200, 200);
			game.getLuaObject("remixBGInvert").alpha = 0.001;
		]])

		scaleObject('remixBGInvert', 1, 1)
		setObjectOrder('remixBGInvert', getObjectOrder('remixBG')+1)
		addLuaBackdrop("remixBGInvert", true)

			makeAnimatedLuaSprite("trippyBG", "trippyRemixBG", 100, 60)
			addAnimationByPrefix("trippyBG", "trippyRemixBG", "trippyRemixBG", 15, true)
			setProperty('trippyBG.antialiasing', false)
			setProperty('trippyBG.alpha', 0.001)
			addLuaSprite('trippyBG', false)
			scaleObject("trippyBG", 4.75, 4.75)

			makeAnimatedLuaSprite("trippyBGInvert", "trippyRemixBGInvert", 100, 60)
			addAnimationByPrefix("trippyBGInvert", "trippyRemixBGInvert", "trippyRemixBGInvert", 15, true)
			setProperty('trippyBGInvert.antialiasing', false)
			setProperty('trippyBGInvert.alpha', 0.001)
			addLuaSprite('trippyBGInvert', false)
			setObjectOrder('trippyBGInvert', getObjectOrder('trippyBG')+1)
			scaleObject("trippyBGInvert", 4.75, 4.75)

		if not shadersEnabled then
			setProperty('trippyBG.x', -300)
            setProperty('trippyBG.y', -160)
            scaleObject("trippyBG", 8, 8)

			setProperty('trippyBGInvert.x', -300)
            setProperty('trippyBGInvert.y', -160)
            scaleObject("trippyBGInvert", 8, 8)
		end

	makeLuaSprite("bgDark", '', 0, -500)
    makeGraphic('bgDark', 1, 1, '000000')
	scaleObject('bgDark', 2000, 2000)
    setScrollFactor('bgDark', 0, 0)
    setProperty('bgDark.antialiasing', false)
    addLuaSprite('bgDark',false)
    setProperty('bgDark.alpha', 0.0001)

	makeAnimatedLuaSprite("pixelBG", "legacyPixelBG", 115, -30)
	addAnimationByPrefix("pixelBG", "bg", "bg", 8, false)
	setProperty('pixelBG.antialiasing', false)
	setProperty('pixelBG.alpha', 0.0001)
	setScrollFactor('pixelBG', 0, 0)
	addLuaSprite('pixelBG', false)
	scaleObject("pixelBG", 4, 4)
end

function onUpdate(elapsed)
		runHaxeCode([[
			game.getLuaObject("remixBG").velocity.set(game.getLuaObject('skullVelocity').x, game.getLuaObject('skullVelocity').y);
			game.getLuaObject("remixBGInvert").velocity.set(game.getLuaObject('skullVelocity').x, game.getLuaObject('skullVelocity').y);
		]])
end

function onStepHit()

	if curStep == 2836 then
		doTweenAlpha('trippyBG', 'trippyBG', 0.2, 0.33, 'quadInOut')
	end

	if curStep == 2848 then
		doTweenAlpha('trippyBG', 'trippyBG', 0.4, 0.33, 'quadInOut')
	end
	
	if curStep >= 2864 and not safetyNetStage then
			setProperty("remixBG.alpha", 1)
			setProperty('trippyBG.alpha', 1)
			setProperty('bgDark.alpha', 0.5)
			
			doTweenX('skullsLeft', 'skullVelocity', -400, 1, 'quadInOut')

		safetyNetStage = true
	end

	if songVariation == "remixed" then
		if flashingLights then
			if curStep >= 3208 and curStep <= 3216 then
				if curStep %2 == 0 then
					setProperty('camGame.visible', false)
					runHaxeCode([[FlxG.camera.alpha = 0;]])
				else
					setProperty('camGame.visible', true)
					runHaxeCode([[FlxG.camera.alpha = 1;]])
				end
			end
		else
			if curStep == 3208 then
				setProperty('camGame.visible', false)
				runHaxeCode([[FlxG.camera.alpha = 0;]])
			end
		end
	end

	if curStep == 3248 then
		cancelTween('skullsLeft')
		cancelTween('skullsRight')
		doTweenX('fastSkullsX', 'skullVelocity', -500, 0.001, 'quadInOut')
		doTweenY('fastSkullsY', 'skullVelocity', 500, 0.001, 'quadInOut')

		setProperty('camGame.visible', true)
		runHaxeCode([[FlxG.camera.alpha = 1;]])
	end

	if curStep == 3668 then
        callMethod('camHUD.fade', {0x270727, 0.1, true}) -- cuz cameraFade wants to be a wanker
		setProperty('camHUD.alpha', 0)
        callMethod('camGame.fade', {0x270727, 0.0001, true})
		doTweenAlpha('camHUD', 'camHUD', 1, 1, 'quadInOut')
		setProperty('pixelBG.alpha', 1)
		playAnim('pixelBG', 'bg', true)
    end
end

function onTweenCompleted(tag)
	if tag == 'skullsLeft' then
		doTweenX('skullsRight', 'skullVelocity', -100, 1, 'quadInOut')
	end

	if tag == 'skullsRight' then
		doTweenX('skullsLeft', 'skullVelocity', -300, 1, 'quadInOut')
	end
end

function onBeatHit()
	if curBeat >= 812 and curBeat < 875 then
			if flashingLights then
				if curBeat %2 == 0 then
					setProperty('trippyBGInvert.alpha', 1)
					doTweenAlpha('fade1', 'trippyBGInvert', 0, 0.4, 'quadIn')

					setProperty('remixBGInvert.alpha', 1)
					doTweenAlpha('fade2', 'remixBGInvert', 0, 0.4, 'quadIn')
				end
			end
	end
end