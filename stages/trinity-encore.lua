function onCreate() -- if you think this code is bad you should see what it was like before
	-- MAJIN PHASE 1
	makeLuaSprite('stagebackMajin', 'stagetras', 73, 393);
	setScrollFactor('stagebackMajin', 1, 1);
	scaleObject('stagebackMajin', 3, 3);
	setProperty('stagebackMajin.antialiasing', false);
	
	makeLuaSprite('stagepilarsMajin', 'stagepilars', 60, 400);
	setScrollFactor('stagepilarsMajin', 0.9, 0.9);
	scaleObject('stagepilarsMajin', 2.5, 2.5);
	setProperty('stagepilarsMajin.antialiasing', false);

	makeAnimatedLuaSprite('stagefrontMajin','bgmazin', 60, 420)
	addAnimationByPrefix('stagefrontMajin','bgmazin idle','bgmazin idle',24,true)
	setScrollFactor('stagefrontMajin', 0.85, 0.85)
	scaleObject('stagefrontMajin', 2.5, 2.5);
	setProperty('stagefrontMajin.antialiasing', false);

	addLuaSprite('stagebackMajin', false);
	addLuaSprite('stagefrontMajin', false);
	addLuaSprite('stagepilarsMajin', false);
    -- MAJIN PHASE 1

    -- MAJIN PHASE 2
    makeLuaSprite('stageskyMajinTV', 'bgtv', 0, 0);
	setScrollFactor('stageskyMajinTV', 0, 0);
	scaleObject('stageskyMajinTV', 5, 5);
    setProperty('stageskyMajinTV.antialiasing', false);
    setProperty('stageskyMajinTV.alpha', 0.001);
	
	makeLuaSprite('stagegroundMajinTV', 'floortv', 50, 400);
	setScrollFactor('stagegroundMajinTV', 1, 1);
	scaleObject('stagegroundMajinTV', 3, 3);
    setProperty('stagegroundMajinTV.antialiasing', false);
    setProperty('stagegroundMajinTV.alpha', 0.001);

	makeAnimatedLuaSprite('stagebackMajinTV','faces', 55, 240)
	addAnimationByPrefix('stagebackMajinTV','idle','idle',5,true)
	setScrollFactor('stagebackMajinTV', 0.8, 0.8)
	scaleObject('stagebackMajinTV', 3, 3);
    setProperty('stagebackMajinTV.antialiasing', false);
    setProperty('stagebackMajinTV.alpha', 0.001);

    addLuaSprite('stageskyMajinTV', false) 
	addLuaSprite('stagegroundMajinTV', false)
	addLuaSprite('stagebackMajinTV', false)
    -- MAJIN PHASE 2

    -- X
    makeLuaSprite('stagebackX', 'skybox', -80, 300)
    setScrollFactor('stagebackX', 0.9, 0.9)
    scaleObject('stagebackX', 3, 3)
    setProperty('stagebackX.antialiasing', false);
    setProperty('stagebackX.alpha', 0.001);
    
    makeLuaSprite('stagegroundX', 'scrapbrainground', 10, 390)
    setScrollFactor('stagegroundX', 1, 1)
    scaleObject('stagegroundX', 3, 3)
    setProperty('stagegroundX.antialiasing', false);
    setProperty('stagegroundX.alpha', 0.001);

    addLuaSprite('stagebackX', false)
    addLuaSprite('stagegroundX', false)
    -- X

    -- RODENTRAP
    makeLuaSprite('stagebackRR', 'LegacyStageBackground', 250, 300)
    setScrollFactor('stagebackRR', 0.8, 0.8)
    scaleObject('stagebackRR', 0.6, 0.6)
    setProperty('stagebackRR.alpha', 0.001);

    makeLuaSprite('stagebackRR2', 'LegacyStageCloudsNSea', 200, 300)
    setScrollFactor('stagebackRR2', 0.8, 0.8)
    scaleObject('stagebackRR2', 0.6, 0.6)
    setProperty('stagebackRR2.alpha', 0.001);

    makeLuaSprite('stagebackRR3', 'LegacyStageFoliage', 200, 550)
    setScrollFactor('stagebackRR3', 0.9, 0.9)
    scaleObject('stagebackRR3', 0.6, 0.6)
    setProperty('stagebackRR3.alpha', 0.001);
    
    makeLuaSprite('stagegroundRR', 'LegacyStageFloor', -250, 600)
    setScrollFactor('stagegroundRR', 1, 1)
    scaleObject('stagegroundRR', 1, 1)
    setProperty('stagegroundRR.alpha', 0.001);

    addLuaSprite('stagebackRR', false)
    addLuaSprite('stagebackRR2', false)
    addLuaSprite('stagebackRR3', false)
    addLuaSprite('stagegroundRR', false)
    -- RODENTRAP

    -- LORD X PHASE 1
    makeAnimatedLuaSprite('stagebackLX','skyboxlx', 0, 360)
    addAnimationByPrefix('stagebackLX','idle','idle',5,true)
    setScrollFactor('stagebackLX', 0.6, 0.6)
    scaleObject('stagebackLX', 3.3, 3.3);
    setProperty('stagebackLX.antialiasing', false);
    setProperty('stagebackLX.alpha', 0.001);

    addLuaSprite('stagebackLX', false)
    -- LORD X PHASE 1

    -- LORD X PHASE 2
    makeAnimatedLuaSprite('stagebackLX2', 'poltergeist', 250, 15)
    addAnimationByPrefix('stagebackLX2', 'idle', 'idle', 24, true)
    setScrollFactor('stagebackLX2', 0, 0)
    scaleObject('stagebackLX2', 3, 3)
    setProperty('stagebackLX2.antialiasing', false);
    setProperty('stagebackLX2.alpha', 0.001);

    addLuaSprite('stagebackLX2', false)
    -- LORD X PHASE 2

    -- REWRITE
    makeLuaSprite('stageskyR', 'ghsky', 100, -50);
	setScrollFactor('stageskyR', 0, 0);
	scaleObject('stageskyR', 5, 5);
    setProperty('stageskyR.antialiasing', false);
    setProperty('stageskyR.alpha', 0.001);

	makeLuaSprite('stagebackR', 'ghback', 90, 200);
	setScrollFactor('stagebackR', 0.5, 0.5);
	scaleObject('stagebackR', 3, 3);
    setProperty('stagebackR.antialiasing', false);
    setProperty('stagebackR.alpha', 0.001);
	
	makeLuaSprite('stagegroundR', 'ghstage', 100, 350);
	setScrollFactor('stagegroundR', 0.9, 0.9);
	scaleObject('stagegroundR', 3, 3);
    setProperty('stagegroundR.antialiasing', false);
    setProperty('stagegroundR.alpha', 0.001);

	makeLuaSprite('stageobjR', 'objects', 100, 255);
	setScrollFactor('stageobjR', 0.6, 0.6);
	scaleObject('stageobjR', 3, 3);
    setProperty('stageobjR.antialiasing', false);
    setProperty('stageobjR.alpha', 0.001);

	makeAnimatedLuaSprite('stagestuffR','animals', 80, 300)
	addAnimationByPrefix('stagestuffR','idle','idle',5,true)
	setScrollFactor('stagestuffR', 0.8, 0.8)
	scaleObject('stagestuffR', 3, 3);
    setProperty('stagestuffR.antialiasing', false);
    setProperty('stagestuffR.alpha', 0.001);

    addLuaSprite('stageskyR', false) 
    addLuaSprite('stagebackR', false)
    addLuaSprite('stageobjR', false)
    addLuaSprite('stagegroundR', false)
    addLuaSprite('stagestuffR', false)
    -- REWRITE

    -- REWRITE LYRICS
    makeAnimatedLuaSprite('stars','starsFullscreen', -70, 0)
	addAnimationByPrefix('stars','idle','0_00', 15, true)
	setScrollFactor('stars', 0.0, 0.0)
	scaleObject('stars', 3.7, 3.7);
    setProperty('stars.antialiasing', false);
    setProperty('stars.alpha', 0.001);

    makeAnimatedLuaSprite('shapes','shapesFullscreen', -160, -40)
	addAnimationByPrefix('shapes','idle','0_00', 15, true)
	setScrollFactor('shapes', 0.0, 0.0)
	scaleObject('shapes', 3.7, 3.7);
    setProperty('shapes.antialiasing', false);
    setProperty('shapes.alpha', 0.001);

    makeAnimatedLuaSprite('floor','floorFullscreen', -100, -50)
	addAnimationByPrefix('floor','idle','0_00', 30, true)
	setScrollFactor('floor', 0.0, 0.0)
	scaleObject('floor', 3.7, 3.7);
    setProperty('floor.antialiasing', false);
    setProperty('floor.alpha', 0.001);

    addLuaSprite("floor")
    addLuaSprite("stars")
    addLuaSprite("shapes")
    -- REWRITE LYRICS
end

function onStepHit()
    if curStep == 2496 then
        setProperty('stagebackLX2.alpha', 0.001);
        setProperty('stagebackLX.alpha', 0.001);
    end

    if curStep == 3788 then
        setProperty('stageskyR.alpha', 0.001);
        setProperty('stagebackR.alpha', 0.001);
        setProperty('stagegroundR.alpha', 0.001);
        setProperty('stageobjR.alpha', 0.001);
        setProperty('stagestuffR.alpha', 0.001);

        setProperty('stars.alpha', 1);
        setProperty('shapes.alpha', 1);
        setProperty('floor.alpha', 1);
    end

    if curStep == 3840 then
        setProperty('stars.alpha', 0.001);
        setProperty('shapes.alpha', 0.001);
        setProperty('floor.alpha', 0.001);
    end
end

function onEvent(e, v1, v2, sT)
    if e == "ChangeBG" then
        if v1 == "monitor" then
            setProperty('stageskyMajinTV.alpha', 1);
            setProperty('stagegroundMajinTV.alpha', 1);
            setProperty('stagebackMajinTV.alpha', 1);

            setProperty('stagebackMajin.alpha', 0.001);
            setProperty('stagepilarsMajin.alpha', 0.001);
            setProperty('stagefrontMajin.alpha', 0.001);
        end

        if v1 == "x" then
            setProperty('stageskyMajinTV.alpha', 0.001);
            setProperty('stagegroundMajinTV.alpha', 0.001);
            setProperty('stagebackMajinTV.alpha', 0.001);
    
            setProperty('stagebackX.alpha', 1);
            setProperty('stagegroundX.alpha', 1);
        end

        if v1 == "rodentrap" then
            setProperty('stagebackX.alpha', 0.001);
            setProperty('stagegroundX.alpha', 0.001);
    
            setProperty('stagebackRR.alpha', 1);
            setProperty('stagebackRR2.alpha', 1);
            setProperty('stagebackRR3.alpha', 1);
            setProperty('stagegroundRR.alpha', 1);
        end

        if v1 == "lx" then
            setProperty('stagebackRR.alpha', 0.001);
            setProperty('stagebackRR2.alpha', 0.001);
            setProperty('stagebackRR3.alpha', 0.001);
            setProperty('stagegroundRR.alpha', 0.001);
    
            setProperty('stagebackLX2.alpha', 0.001);
            setProperty('stagebackLX.alpha', 1);
        end

        if v1 == "lx2" then
            setProperty('stagebackLX.alpha', 0.001);
            if flashingLights then
                setProperty('stagebackLX2.alpha', 1);
            else
                setProperty('stagebackLX2.alpha', 0.25);
            end
        end

        if v1 == "rewrite" then
            setProperty('stagebackLX.alpha', 0.001);
    
            setProperty('stageskyR.alpha', 1);
            setProperty('stagebackR.alpha', 1);
            setProperty('stagegroundR.alpha', 1);
            setProperty('stageobjR.alpha', 1);
            setProperty('stagestuffR.alpha', 1);
        end
    end
end