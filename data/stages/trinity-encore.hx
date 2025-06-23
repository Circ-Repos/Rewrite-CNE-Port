import hxvlc.flixel.FlxVideoSprite;


var majin:Bool = true;
var phasenum:Int = 1; //for tracking people with multiple phases, doesnt go like 1,2,3,4,5,6,7,8 instead 0,1,2 then back to 0
//me lazy

// previously the video playing script was stolen from a silly billy port. THAT CHANGES NOW.
// NO MORE RANDOM CRASHES. IT'S TIME.
// :happyhuggy:

// This script also handles checkpoints and noteskin swaps
// God bless happy wappy.
// -pootis

var majinVideo:FlxVideoSprite;
var xVideo:FlxVideoSprite;
var fusionVideo:FlxVideoSprite;
var lxVideo:FlxVideoSprite;
var videoArray:Array<FlxVideoSprite> = [];
var videosToDestroy:Array<FlxVideoSprite> = [];

var texture:String = "NOTE_assets";
var camOther = new FlxCamera();
var camVideo = new FlxCamera();
var ogWinX:Int = 1280;
var ogWinY:Int = 720;

function setProperty(vsvar:String, prop:String){
    vsvar = prop;
}
function create() {
    PlayState.instance.introLength = 0;
    var winX:Int = 1025;
    var winY:Int = 900;
    FlxG.resizeWindow(winX, winY);
    FlxG.resizeGame(winX, winY);
    FlxG.scaleMode.width = winX;
    FlxG.scaleMode.height = winY;
    FlxG.camera.setSize(winX, winY);
    camHUD.setSize(winX, winY);
    camHUD.setPosition(0,0);
    FlxG.camera.setPosition(0,0);
    FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
    FlxG.cameras.add(camVideo, false);
    camVideo.bgColor = 0;
    camVideo.alpha = 1;
    camOther.setSize(winX, winY);

}
function postUpdate(elapsed:Float) {
    // safety net bullshit thank you snow for the idea
    /*if (videosToDestroy.length > 0) for (i in videosToDestroy) if (i != null) i.alpha = 0;
    for (i in videoArray) if (i.alpha == 1){ 
        i.scale.set(1.3,1.3);
        i.screenCenter();
    }*/
    for(i in 0...playerStrums.length) playerStrums.members[i].noteAngle = 0;

}

function fusionAAA(){
    playVideo(fusionVideo, 25.25, 1); // 25.45
}
function destroy() {
    FlxG.resizeWindow(ogWinX, ogWinY);
    FlxG.resizeGame(ogWinX, ogWinY);
    FlxG.scaleMode.width = ogWinX;
    FlxG.scaleMode.height = ogWinY;
    FlxG.camera.setSize(ogWinX, ogWinY);
}
function postCreate() {
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP2.alpha = 0;
    iconP1.alpha = 0;
    scoreTxt.alpha = 0;
    //acctxt thing
    missesTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    //video stuff here circ (me) plsssssss 
    //ok me i will do this later me
    //no the fuck you arent we know this
    //yea fuck you me
    //bet
    //what
    majinVideo = new FlxVideoSprite();
    majinVideo.load(Paths.video('majincutscene'));

    xVideo = new FlxVideoSprite();
    xVideo.load(Paths.video('xcutscenealt'));

    fusionVideo = new FlxVideoSprite();
    fusionVideo.load(Paths.video('fusioncutscene'));

    lxVideo = new FlxVideoSprite();
    lxVideo.load(Paths.video('lordxcutscene'));

    videoArray = [majinVideo, xVideo, fusionVideo, lxVideo];
    for (i in videoArray)
    {
        i.bitmap.rate = 1;
        i.alpha = 0.001;
        i.cameras = [i == majinVideo ? camHUD : camHUD];
        add(i);
    }

    //PlayState.checkpointTime = 135000; // legacy
    //PlayState.checkpointTime = 277500; // rewrite

    Paths.image("noteSkins/internalX_Notes");
    Paths.image("noteSkins/NOTE_assets-FNF");
    Paths.image("noteSkins/NOTE_assets");
    for (i in videoArray)
    {
        i.play(); // This fixes a visual issue where the video doesnt play until a little bit after it should
		new FlxTimer().start(0.0001, function(tmr) {
			i.pause();
            i.bitmap.time = 0;
		});
    }    
}
function ohImXingIt(){
    playVideo(xVideo, 18.05, 1); //idk why but hscript func call dont wanna work
}
//lala bg idk what to do with it rn
/*        lalalaBackground.frames = Paths.getSparrowAtlas("lalalaBackground");
        lalalaBackground.animation.addByPrefix("temp", "0_", 15, true);
        lalalaBackground.animation.addByPrefix("la", "0_", 15, true);
        lalalaBackground.animation.play("temp");

        lalalaBackground.velocity.set(-500, 500);
        lalalaBackground.alpha = 0.001;*/
function camZoomable(theBool:Bool){
    camZooming = theBool;
}
function lordSexVid(){
    camGame.alpha = 1;
    camHUD.alpha = 1;
    playVideo(lxVideo, 18.00, 1);
}
function playVideo(vid:FlxVideoSprite, endTime:Float, strumTime:Float)
{
    /*if(vid == 'lxVideo'){
        camHUD.alpha = 1;
        FlxG.camera.alpha = 1;
    }
    camZooming = false;
    //vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.play();
    vid.offset.x -= 230;

    vid.scale.set(1,1);
    if(vid == fusionVideo){
        remove(vid, true);
        insert(0, vid);
    }
    //commento ut the thingy soi  can play

    if (vid == majinVideo) {
        new FlxTimer().start(0.1 / 1, function(tmr) {
            camHUD.alpha = 1;
        });
    }

    new FlxTimer().start(endTime / 1, function(tmr) {
        vid.alpha = 0.001;
        if (vid == majinVideo) FlxG.camera.alpha = 1;
        videosToDestroy.push(vid);
    });

    if (vid == lxVideo) camVideo.flash(0xFF000000, 1);*/
}
function onSongStart(){
    playVideo(majinVideo, 19.00, 1);
}
/*    if e == "ChangeBG" then
        if v1 == "monitor" then

        end



        if v1 == "lx" then
            stagebackRR.alpha = 0.001;
            stagebackRR2.alpha = 0.001;
            stagebackRR3.alpha = 0.001;
            stagegroundRR.alpha = 0.001;
    
            stagebackLX2.alpha = 0.001;
            stagebackLX.alpha = 1;
        end

        if v1 == "lx2" then
            stagebackLX.alpha = 0.001;
            if flashingLights then
                stagebackLX2.alpha = 1;
            else
                stagebackLX2.alpha = 0.25);
            end
        end

        if v1 == "rewrite" then
            stagebackLX.alpha = 0.001;
    
            stageskyR.alpha = 1;
            stagebackR.alpha = 1;
            stagegroundR.alpha = 1;
            stageobjR.alpha = 1;
            stagestuffR.alpha = 1;
        end
    end*/
function spinStrums(){ ///hi revisited code im kidnapping you
    for(i in 0...playerStrums.length) {
        playerStrums.members[i].angle = 0;
        FlxTween.tween(playerStrums.members[i], {angle: 360}, 0.2, {ease: FlxEase.quintOut, onComplete: function(){
        }});
    }
}
function setWindowTitle(windowTitle:String) window.title = windowTitle;
function changeBG(v1:String){
    if(v1 == 'monitor'){
            defaultCamZoom = 1.25;
            FlxG.camera.zoom = 1.25;
            boyfriend.y -= 100;
            stageskyMajinTV.alpha = 1;
            stagegroundMajinTV.alpha = 1;
            stagebackMajinTV.alpha = 1;

            stagebackMajin.alpha = 0.001;
            stagepilarsMajin.alpha = 0.001;
            stagefrontMajin.alpha = 0.001;
            remove(boyfriend, true);
            insert(99, boyfriend);
            videosToDestroy.push(majinVideo);

        }
        if(v1 == "x"){
            if(majinVideo.alpha != 0) majinVideo.alpha = 0;
            setWindowTitle('');
            boyfriend.y += 100;
            stageskyMajinTV.alpha = 0.001;
            stagegroundMajinTV.alpha = 0.001;
            stagebackMajinTV.alpha = 0.001;

            stagebackX.alpha = 1;
            stagegroundX.alpha = 1;

        }

        if(v1 == "rodentrap"){
            setWindowTitle('Friday Night Funkin\': Rodentrap');
            videosToDestroy.push(xVideo);
            if(xVideo.alpha != 0) xVideo.alpha = 0;
            videosToDestroy.push(fusionVideo);
            if(fusionVideo.alpha != 0) fusionVideo.alpha = 0;

            boyfriend.y += 240;
            dad.y += 240;
            dad.x += 420;
            boyfriend.x += 350;
            stagebackX.alpha = 0.001;
            stagegroundX.alpha = 0.001;
    
            stagebackRR.alpha = 1;
            stagebackRR2.alpha = 1;
            stagebackRR3.alpha = 1;
            stagegroundRR.alpha = 1;
        }
        if(v1 == 'lx'){
            videosToDestroy.push(lxVideo);
            if(lxVideo.alpha != 0) lxVideo.alpha = 0;

            boyfriend.y -= 580;
            dad.y -= 240;
            dad.x -= 420;
            boyfriend.x -= 420;
            remove(boyfriend, true);
            insert(99, boyfriend);
            stagebackRR.alpha = 0.001;
            stagebackRR2.alpha = 0.001;
            stagebackRR3.alpha = 0.001;
            stagegroundRR.alpha = 0.001;

            stagebackLX2.alpha = 0.001;
            stagebackLX.alpha = 1;
        }
        if(v1 == 'rewrite'){
                boyfriend.y += 580;
                dad.y += 240;
                dad.x += 500;
                boyfriend.x += 500;
                videosToDestroy.push(lxVideo);
                if(lxVideo.alpha != 0) lxVideo.alpha = 0;

            	stagebackLX.alpha = 0.001;

                boyfriend.x -= 600;
                boyfriend.y -= 250;
                dad.x -= 600;
                dad.y -= 250;
				stageskyR.alpha = 1;
				stagebackR.alpha = 1;
				stagegroundR.alpha = 1;
				stageobjR.alpha = 1;
				stagestuffR.alpha = 1;
        }
}
/*function onEvent(e:String, v1:String, v2:String)
{
	if (e == "ChangeBG")
	{
		switch (v1)
		{
			case "monitor":
				stageskyMajinTV.alpha = 1;
				stagegroundMajinTV.alpha = 1;
				stagebackMajinTV.alpha = 1;

				stagebackMajin.alpha = 0.001;
				stagepilarsMajin.alpha = 0.001;
				stagefrontMajin.alpha = 0.001;

			case "x":
				stageskyMajinTV.alpha = 0.001;
				stagegroundMajinTV.alpha = 0.001;
				stagebackMajinTV.alpha = 0.001;

				stagebackX.alpha = 1;
				stagegroundX.alpha = 1;

			case "rodentrap":
				stagebackX.alpha = 0.001;
				stagegroundX.alpha = 0.001;

				stagebackRR.alpha = 1;
				stagebackRR2.alpha = 1;
				stagebackRR3.alpha = 1;
				stagegroundRR.alpha = 1;

			case "lx":
				stagebackRR.alpha = 0.001;
				stagebackRR2.alpha = 0.001;
				stagebackRR3.alpha = 0.001;
				stagegroundRR.alpha = 0.001;

				stagebackLX2.alpha = 0.001;
				stagebackLX.alpha = 1;

			case "lx2":
				stagebackLX.alpha = 0.001;
				stagebackLX2.alpha = FlxG.save.data.flashingLights ? 1 : 0.25;

			case "rewrite":
				stagebackLX.alpha = 0.001;

				stageskyR.alpha = 1;
				stagebackR.alpha = 1;
				stagegroundR.alpha = 1;
				stageobjR.alpha = 1;
				stagestuffR.alpha = 1;
		}
	}
}*/
function welcomeBack(){
    //inside modchart thingy
}
/*    videoArray = [majinVideo, xVideo, fusionVideo, lxVideo];
    for (i in videoArray)
    {
        i.bitmap.rate = 1;
        i.alpha = 0.001;
        i.cameras = [i == majinVideo ? camHUD : camHUD];
        add(i);
    }

    //PlayState.checkpointTime = 135000; // legacy
    //PlayState.checkpointTime = 277500; // rewrite

    Paths.image("noteSkins/internalX_Notes");
    Paths.image("noteSkins/NOTE_assets-FNF");
    Paths.image("noteSkins/NOTE_assets");
    for (i in videoArray)
    {*/
function camAlphaTween(alpGoal:Int, timetoTween:Int){
    var camArray = [camGame, camHUD];
    for (i in camArray){
        i.alpha = alpGoal;
        //FlxTween.tween(i, {alpha: alpGoal}, timetoTween, {ease: FlxEase.linear});
    }
}
/*function onCreate() -- if you think this code is bad you should see what it was like before
    -- LORD X PHASE 1
    makeAnimatedLuaSprite('stagebackLX','skyboxlx', 0, 360)
    addAnimationByPrefix('stagebackLX','idle','idle',5,true)
    setScrollFactor('stagebackLX', 0.6, 0.6)
    scaleObject('stagebackLX', 3.3, 3.3);
    stagebackLX.antialiasing', false);
    stagebackLX.alpha = 0.001;

    addLuaSprite('stagebackLX', false)
    -- LORD X PHASE 1

    -- LORD X PHASE 2
    makeAnimatedLuaSprite('stagebackLX2', 'poltergeist', 250, 15)
    addAnimationByPrefix('stagebackLX2', 'idle', 'idle', 24, true)
    setScrollFactor('stagebackLX2', 0, 0)
    scaleObject('stagebackLX2', 3, 3)
    stagebackLX2.antialiasing', false);
    stagebackLX2.alpha = 0.001;

    addLuaSprite('stagebackLX2', false)
    -- LORD X PHASE 2

    -- REWRITE
    makeLuaSprite('stageskyR', 'ghsky', 100, -50);
	setScrollFactor('stageskyR', 0, 0);
	scaleObject('stageskyR', 5, 5);
    stageskyR.antialiasing', false);
    stageskyR.alpha = 0.001;

	makeLuaSprite('stagebackR', 'ghback', 90, 200);
	setScrollFactor('stagebackR', 0.5, 0.5);
	scaleObject('stagebackR', 3, 3);
    stagebackR.antialiasing', false);
    stagebackR.alpha = 0.001;
	
	makeLuaSprite('stagegroundR', 'ghstage', 100, 350);
	setScrollFactor('stagegroundR', 0.9, 0.9);
	scaleObject('stagegroundR', 3, 3);
    stagegroundR.antialiasing', false);
    stagegroundR.alpha = 0.001;

	makeLuaSprite('stageobjR', 'objects', 100, 255);
	setScrollFactor('stageobjR', 0.6, 0.6);
	scaleObject('stageobjR', 3, 3);
    stageobjR.antialiasing', false);
    stageobjR.alpha = 0.001;

	makeAnimatedLuaSprite('stagestuffR','animals', 80, 300)
	addAnimationByPrefix('stagestuffR','idle','idle',5,true)
	setScrollFactor('stagestuffR', 0.8, 0.8)
	scaleObject('stagestuffR', 3, 3);
    stagestuffR.antialiasing', false);
    stagestuffR.alpha = 0.001;

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
    stars.antialiasing', false);
    stars.alpha = 0.001;

    makeAnimatedLuaSprite('shapes','shapesFullscreen', -160, -40)
	addAnimationByPrefix('shapes','idle','0_00', 15, true)
	setScrollFactor('shapes', 0.0, 0.0)
	scaleObject('shapes', 3.7, 3.7);
    shapes.antialiasing', false);
    shapes.alpha = 0.001;

    makeAnimatedLuaSprite('floor','floorFullscreen', -100, -50)
	addAnimationByPrefix('floor','idle','0_00', 30, true)
	setScrollFactor('floor', 0.0, 0.0)
	scaleObject('floor', 3.7, 3.7);
    floor.antialiasing', false);
    floor.alpha = 0.001;

    addLuaSprite("floor")
    addLuaSprite("stars")
    addLuaSprite("shapes")
    -- REWRITE LYRICS
end

function onStepHit()
    if curStep == 2496 then
        stagebackLX2.alpha = 0.001;
        stagebackLX.alpha = 0.001;
    end

    if curStep == 3788 then
        stageskyR.alpha = 0.001;
        stagebackR.alpha = 0.001;
        stagegroundR.alpha = 0.001;
        stageobjR.alpha = 0.001;
        stagestuffR.alpha = 0.001;

        stars.alpha = 1;
        shapes.alpha = 1;
        floor.alpha = 1;
    end

    if curStep == 3840 then
        stars.alpha = 0.001;
        shapes.alpha = 0.001;
        floor.alpha = 0.001;
    end
end

function onEvent(e, v1, v2, sT)

end*/