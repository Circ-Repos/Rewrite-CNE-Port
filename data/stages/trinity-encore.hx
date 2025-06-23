import hxvlc.flixel.FlxVideoSprite;
import flixel.addons.display.FlxBackdrop;
import cpp.Lib; //mmmmmmmm lib why arent you imported by default
// previously the video playing script was stolen from a silly billy port. THAT CHANGES NOW.
// NO MORE RANDOM CRASHES. IT'S TIME.
// :happyhuggy:

// This script also handles checkpoints and noteskin swaps
// God bless happy wappy.
// -pootis

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import openfl.Lib;
import funkin.Conductor;
import flixel.util.FlxMath;

// Window management
var windowOriginX:Int = 0;
var windowOriginY:Int = 0;
var windowShakeX:Float = 0;
var windowShakeY:Float = 0;
var windowShakeStrength:Float = 12;

var maxWidth:Int = 1920;
var maxHeight:Int = 1080;
var windowLock:Bool = true;

// Safeties
var safetyNet1:Bool = false;
var safetyNet2:Bool = false;
var safetyNet3:Bool = false;
var safetyNet4:Bool = false;
var safetyNet5:Bool = false;
var safetyNet6:Bool = false;
var noteSafety1:Bool = false;
var noteSafety2:Bool = false;
var safetyNetIDKANYMORE:Bool = false;
var safetyHEAD:Bool = false;
var safetyHEAD2:Bool = false;
var safetyTrans:Bool = false;
var fullscreenLagCheck1:Bool = false;
var fullscreenLagCheck2:Bool = false;
var fullscreenLagCheck3:Bool = false;
var fullscreenLagCheck4:Bool = false;
var fullscreenLagCheck5:Bool = false;
var finalLagCheck:Bool = false;
var noteCheck:Bool = false;
var allowNoteSway:Bool = false;
var fpsVisible:Bool = false;

// State flags
var stopUpdatingDummy:Bool = false;
var stopUpdatingDummy2:Bool = false;
var stopUpdatingDummy3:Bool = false;
var stopUpdatingDummy4:Bool = false;
var stopUpdatingDummyFFS:Bool = false;
var noMoreDeath:Bool = false;
var allowWinTween:Bool = false;

// Visual tuning
var brightness:Float = 0.00;
var contrast:Float = 1.00;
var saturation:Float = 1.00;

// Internal control
var internalBG:FlxSprite;
var internalBGBeat:Int = -1;
var internalBGBop:Bool = false;
var internalGradient:FlxSprite;
var internalShaderUpdate:Bool = true;
var internalFlipShiet:Bool = false;

var startSong:Bool = false;
var beat:Int = 0;

// Common flags
var downscroll:Bool = false;
var lowQuality:Bool = false;
var shadersEnabled:Bool = false;

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
function getCamera(camName:String):FlxCamera {
    switch (camName) {
        case "camGame":
            return FlxG.camera;
        case "camHUD":
            return camHUD;
        case "camOther":
            return camOther;
        case "camVideo":
            return camVideo;
        default:
            return camGame;
    }
}
function setProperty(vsvar:String, prop:String){
    vsvar = prop;
}
function setObjectOrder(obj:String, position:Int, ?group:String = null){
    var leObj = obj;
    remove(obj, true);
    insert(obj, position);
}

/**
 * /Lua_helper.add_callback(lua, "setObjectOrder", function(obj:String, position:Int, ?group:String = null) {
			var leObj:FlxBasic = LuaUtils.getObjectDirectly(obj);
			if(leObj != null)
			{
				if(group != null)
				{
					var groupOrArray:Dynamic = Reflect.getProperty(LuaUtils.getTargetInstance(), group);
					if(groupOrArray != null)
					{
						switch(Type.typeof(groupOrArray))
						{
							case TClass(Array): //Is Array
								groupOrArray.remove(leObj);
								groupOrArray.insert(position, leObj);
							default: //Is Group
								groupOrArray.remove(leObj, true);
								groupOrArray.insert(position, leObj);
						}
					}
					else luaTrace('setObjectOrder: Group $group doesn\'t exist!', false, false, FlxColor.RED);
				}
				else
				{
					var groupOrArray:Dynamic = CustomSubstate.instance != null ? CustomSubstate.instance : LuaUtils.getTargetInstance();
					groupOrArray.remove(leObj, true);
					groupOrArray.insert(position, leObj);
				}
				return;
			}
			luaTrace('setObjectOrder: Object $obj doesn\'t exist!', false, false, FlxColor.RED);
		});
 */
function create() {
    PlayState.instance.introLength = 0;
    var winX:Int = 820;
    var winY:Int = 720;
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
    if (videosToDestroy.length > 0) for (i in videosToDestroy) if (i != null){
        i.alpha = 0;
        i.destroy();
    }
    for (i in videoArray) if (i.alpha == 1){ 
        i.scale.set(1.3,1.3);
        i.screenCenter();
    }
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
    //RELEASE THE BABIES!!!!
    snowPostCreate(); //seperate function for snow post create cause its shit from his
    //modchart script just convertedd

}
var transColour:FlxSprite;
var blackMask:FlxSprite;
var redClouds:FlxBackdrop;
var fleshBG:FlxSprite;
var desktopRift:FlxSprite;
var desktopRiftMask:FlxSprite;
var rewriteCutscene:FlxSprite;
var rewriteStomp:FlxSprite;
var rewriteCutsceneTransition:FlxSprite;
var fusionCutsceneFade:FlxSprite;
var welcomeBack:FlxSprite;
var welcomeBackText:FlxSprite;
var lordXJumpscares:FlxSprite;
var internalColour:FlxSprite;
var fullScreenIntroBG:FlxSprite;
var fullScreenIntro:FlxSprite;
var fullScreenRunning:FlxSprite;
var sa2Posing:FlxSprite;
var sa2Posing2:FlxSprite;
var sa2PosingShadow:FlxSprite;
var sa2PosingShadow:FlxSprite;
var pillarWipe:FlxSprite;
var ring:FlxSprite;
var boyfriendRing:FlxSprite;
var flashbang:FlxSprite;
var lyricsPlaceholder:FlxSprite;
var rewriteHead:FlxSprite;
var bfMask:FlxSprite;
var rewriteWindowBox:FlxSprite;
var windowVessel:FlxSprite;
var windowBlack:FlxSprite;

function snowPostCreate(){
    transColour = new FlxSprite(-500, -500);
    transColour.makeGraphic(2500, 2000, 0xFF131313);
    transColour.scrollFactor.set(0, 0);
    transColour.alpha = 0;
    add(transColour);

    if (shadersEnabled) {
        blackMask = new FlxSprite(-100, -100);
        blackMask.makeGraphic(1300, 1000, 0xFF000000);
    } else {
        blackMask = new FlxSprite(-500, -250);
        blackMask.makeGraphic(2500, 1300, 0xFF000000);
    }
    blackMask.scrollFactor.set(0, 0);
    blackMask.alpha = 0.001;
    add(blackMask);

    redClouds = new FlxBackdrop(Paths.image("redClouds"), FlxAxes.X);
    redClouds.antialiasing = false;
    redClouds.alpha = 0.001;
    if (shadersEnabled) {
        redClouds.setGraphicSize(Std.int(redClouds.width * 2.0));
        redClouds.velocity.set(-750, 0);
    } else {
        redClouds.y = -400;
        redClouds.setGraphicSize(Std.int(redClouds.width * 5.0));
        redClouds.velocity.set(-1000, 0);
    }
    add(redClouds);

    fleshBG = new FlxSprite(0, 0);
    fleshBG.frames = Paths.getSparrowAtlas("fleshBG");
    fleshBG.animation.addByPrefix("fleshBG", "bgflesh", 20, true);
    fleshBG.animation.play("fleshBG");
    fleshBG.antialiasing = false;
    fleshBG.alpha = 0.001;
    if (shadersEnabled) {
        fleshBG.setPosition(100, 50);
        fleshBG.setGraphicSize(Std.int(fleshBG.width * 2.7));
    } else {
        fleshBG.setPosition(-300, -160);
        fleshBG.setGraphicSize(Std.int(fleshBG.width * 5));
    }
    add(fleshBG);

    desktopRift = new FlxSprite(-275, -160);
    desktopRift.frames = Paths.getSparrowAtlas("desktopRift");
    desktopRift.animation.addByPrefix("desktopRift", "rift0", 12, false);
    desktopRift.animation.addByPrefix("temp", "rift0", 15, false);
    desktopRift.animation.play("temp");
    desktopRift.antialiasing = false;
    desktopRift.alpha = 0.001;
    desktopRift.scrollFactor.set(0, 0);
    desktopRift.setGraphicSize(Std.int(desktopRift.width * 2.5));
    add(desktopRift);

    desktopRiftMask = new FlxSprite(-275, -160);
    desktopRiftMask.frames = Paths.getSparrowAtlas("desktopRift");
    desktopRiftMask.animation.addByPrefix("desktopRiftMask", "riftMask", 12, false);
    desktopRiftMask.animation.addByPrefix("temp", "riftMask", 15, false);
    desktopRiftMask.animation.play("temp");
    desktopRiftMask.antialiasing = false;
    desktopRiftMask.alpha = 0.001;
    desktopRiftMask.scrollFactor.set(0, 0);
    desktopRiftMask.setGraphicSize(Std.int(desktopRiftMask.width * 2.5));
    add(desktopRiftMask);

    rewriteCutscene = new FlxSprite(0, 0);
    rewriteCutscene.frames = Paths.getSparrowAtlas("rewriteCutscene");
    rewriteCutscene.animation.addByPrefix("rewriteCutscene", "0_", 15, false);
    rewriteCutscene.animation.addByPrefix("temp", "0_", 15, false);
    rewriteCutscene.animation.play("temp");
    rewriteCutscene.antialiasing = false;
    rewriteCutscene.alpha = 0.001;
    rewriteCutscene.scrollFactor.set(0, 0);
    rewriteCutscene.setGraphicSize(Std.int(rewriteCutscene.width * 3.22));
    rewriteCutscene.cameras = [camOther];
    add(rewriteCutscene);

    rewriteStomp = new FlxSprite(0, 0);
    rewriteStomp.frames = Paths.getSparrowAtlas("Stomp");
    rewriteStomp.animation.addByPrefix("animation", "anim", 30, false);
    rewriteStomp.alpha = 0.001;
    rewriteStomp.antialiasing = false;
    rewriteStomp.scrollFactor.set(0, 0);
    rewriteStomp.setGraphicSize(Std.int(rewriteStomp.width * 3.22));
    rewriteStomp.cameras = [camOther];
    add(rewriteStomp);

    rewriteCutsceneTransition = new FlxSprite(0, 0);
    rewriteCutsceneTransition.frames = Paths.getSparrowAtlas("rewriteCutsceneTransition");
    rewriteCutsceneTransition.animation.addByPrefix("rewriteCutsceneTransition", "0_", 15, false);
    rewriteCutsceneTransition.animation.addByPrefix("temp", "0_", 15, false);
    rewriteCutsceneTransition.animation.play("temp");
    rewriteCutsceneTransition.antialiasing = false;
    rewriteCutsceneTransition.alpha = 0.001;
    rewriteCutsceneTransition.scrollFactor.set(0, 0);
    rewriteCutsceneTransition.setGraphicSize(Std.int(rewriteCutsceneTransition.width * 3.22));
    rewriteCutsceneTransition.cameras = [camOther];
    add(rewriteCutsceneTransition);

    fusionCutsceneFade = new FlxSprite(0, 0);
    fusionCutsceneFade.makeGraphic(1280, 720, 0xFFEDFCD5);
    fusionCutsceneFade.alpha = 0.001;
    fusionCutsceneFade.scrollFactor.set(0, 0);
    fusionCutsceneFade.cameras = [camOther];
    add(fusionCutsceneFade);

    welcomeBack = new FlxSprite(230, 0);
    welcomeBack.frames = Paths.getSparrowAtlas("welcomeBack");
    welcomeBack.animation.addByPrefix("blank", "blank", 15, false);
    welcomeBack.animation.addByPrefix("fade", "fade", 25, false);
    welcomeBack.animation.addByPrefix("glitch", "glitch", 30, true);
    welcomeBack.animation.play("blank");
    welcomeBack.antialiasing = false;
    welcomeBack.alpha = 0.001;
    welcomeBack.scrollFactor.set(0, 0);
    welcomeBack.setGraphicSize(Std.int(welcomeBack.width * 2));
    welcomeBack.cameras = [camOther];
    add(welcomeBack);

    welcomeBackText = new FlxSprite(230, 0);
    welcomeBackText.frames = Paths.getSparrowAtlas("welcomeBack");
    welcomeBackText.animation.addByPrefix("WELCOME", "1welcome", 15, false);
    welcomeBackText.animation.addByPrefix("BACK", "2back", 30, true);
    welcomeBackText.animation.play("WELCOME");
    welcomeBackText.antialiasing = false;
    welcomeBackText.alpha = 0.001;
    welcomeBackText.scrollFactor.set(0, 0);
    welcomeBackText.setGraphicSize(Std.int(welcomeBackText.width * 2));
    welcomeBackText.cameras = [camOther];
    add(welcomeBackText);

    lordXJumpscares = new FlxSprite(230, 0);
    lordXJumpscares.frames = Paths.getSparrowAtlas(shadersEnabled ? "lordXJumpscaresCrack" : "lordXJumpscares");
    lordXJumpscares.animation.addByPrefix("1", "jumpscare1", 1, false);
    lordXJumpscares.animation.addByPrefix("2", "jumpscare2", 1, false);
    lordXJumpscares.animation.addByPrefix("3", "jumpscare3", 1, false);
    lordXJumpscares.animation.play("1");
    lordXJumpscares.antialiasing = false;
    lordXJumpscares.alpha = 0.001;
    lordXJumpscares.scrollFactor.set(0, 0);
    lordXJumpscares.setGraphicSize(Std.int(lordXJumpscares.width * 3.22));
    lordXJumpscares.cameras = [camGame];
    add(lordXJumpscares);

    internalColour = new FlxSprite(-500, -500);
    internalColour.makeGraphic(20, 20, 0xFF070727);
    internalColour.scrollFactor.set(0, 0);
    internalColour.setGraphicSize(2000, 2000);
    internalColour.alpha = 0.001;
    internalColour.cameras = [camOther];
    add(internalColour);

    internalBG = new FlxSprite(300, 0);
    internalBG.frames = Paths.getSparrowAtlas("internalXBG");
    for (i in 0...8) {
        internalBG.animation.addByPrefix(i + "", "scary" + i, 1, true);
    }
    internalBG.setGraphicSize(Std.int(internalBG.width * 3.32));
    internalBG.scrollFactor.set(0.925, 0.925);
    internalBG.alpha = 0.001;
    internalBG.antialiasing = false;
    internalBG.cameras = [camOther];
    add(internalBG);

    internalGradient = new FlxSprite(0, 645).loadGraphic(Paths.image('internalGradient'));
    internalGradient.antialiasing = false;
    internalGradient.alpha = 0.001;
    internalGradient.setGraphicSize(Std.int(internalGradient.width * 17), Std.int(internalGradient.height * 2));
    internalGradient.updateHitbox();
    add(internalGradient);

    fullScreenIntroBG = new FlxSprite(1281, 721, 0xFFFFFFFF);
    fullScreenIntroBG.setPosition(0, 0);
    fullScreenIntroBG.antialiasing = false;
    fullScreenIntroBG.scrollFactor.set(0, 0);
    fullScreenIntroBG.setGraphicSize(Std.int(fullScreenIntroBG.width * 3.22), Std.int(fullScreenIntroBG.height * 3.22));
    fullScreenIntroBG.updateHitbox();
    fullScreenIntroBG.color = 0xFF100410;
    add(fullScreenIntroBG);

    fullScreenIntro = new FlxSprite(0, 0);
    fullScreenIntro.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    fullScreenIntro.animation.addByPrefix("loop", "fullScreenBGLoop", 15, true);
    fullScreenIntro.antialiasing = false;
    fullScreenIntro.alpha = 0.001;
    fullScreenIntro.camera = camHUD;
    fullScreenIntro.setGraphicSize(Std.int(fullScreenIntro.width * 3.22), Std.int(fullScreenIntro.height * 3.22));
    fullScreenIntro.updateHitbox();
    fullScreenIntro.animation.play("loop");
    add(fullScreenIntro);

    fullScreenRunning = new FlxSprite(1280, 335);
    fullScreenRunning.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    fullScreenRunning.animation.addByPrefix("running", "running", 15, true);
    fullScreenRunning.antialiasing = false;
    fullScreenRunning.alpha = 1;
    fullScreenRunning.setGraphicSize(Std.int(fullScreenRunning.width * 3.22), Std.int(fullScreenRunning.height * 3.22));
    fullScreenRunning.updateHitbox();
    fullScreenRunning.camera = camHUD;
    fullScreenRunning.animation.play("running");
    add(fullScreenRunning);

    sa2Posing = new FlxSprite(-1280, 150);
    sa2Posing.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing.animation.addByPrefix("bf", "bfSA2_", 15, false);
    sa2Posing.animation.play("bf");
    sa2Posing.antialiasing = false;
    sa2Posing.alpha = 1;
    sa2Posing.setGraphicSize(Std.int(sa2Posing.width * 3.22), Std.int(sa2Posing.height * 3.22));
    sa2Posing.updateHitbox();
    sa2Posing.camera = camHUD;
    add(sa2Posing);

    sa2Posing2 = new FlxSprite(1280, 150);
    sa2Posing2.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing2.animation.addByPrefix("rewrite", "sonicSA2_", 15, false);
    sa2Posing2.animation.play("rewrite");
    sa2Posing2.antialiasing = false;
    sa2Posing2.alpha = 1;
    sa2Posing2.setGraphicSize(Std.int(sa2Posing2.width * 3.22), Std.int(sa2Posing2.height * 3.22));
    sa2Posing2.updateHitbox();
    sa2Posing2.camera = camHUD;
    add(sa2Posing2);

    sa2PosingShadow = new FlxSprite(-1280, 150);
    sa2PosingShadow.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2PosingShadow.animation.addByPrefix("bfShadow", "bfSA2Shadow_", 15, false);
    sa2PosingShadow.animation.play("bfShadow");
    sa2PosingShadow.antialiasing = false;
    sa2PosingShadow.alpha = 0.001;
    sa2PosingShadow.setGraphicSize(Std.int(sa2PosingShadow.width * 3.22), Std.int(sa2PosingShadow.height * 3.22));
    sa2PosingShadow.updateHitbox();
    sa2PosingShadow.camera = camHUD;
    add(sa2PosingShadow);

    sa2Posing2Shadow = new FlxSprite(1280, 150);
    sa2Posing2Shadow.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing2Shadow.animation.addByPrefix("rewriteShadow", "sonicSA2Shadow_", 15, false);
    sa2Posing2Shadow.animation.play("rewriteShadow");
    sa2Posing2Shadow.antialiasing = false;
    sa2Posing2Shadow.alpha = 0.001;
    sa2Posing2Shadow.setGraphicSize(Std.int(sa2Posing2Shadow.width * 3.22), Std.int(sa2Posing2Shadow.height * 3.22));
    sa2Posing2Shadow.updateHitbox();
    sa2Posing2Shadow.camera = camHUD;
    add(sa2Posing2Shadow);

    pillarWipe = new FlxSprite(0, 0);
    pillarWipe.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    pillarWipe.animation.addByPrefix("wipe", "pillarWipe", 15, false);
    pillarWipe.animation.addByPrefix("temp", "pillarWipe", 15, false);
    pillarWipe.animation.play("temp");
    pillarWipe.antialiasing = false;
    pillarWipe.alpha = 0.001;
    pillarWipe.setGraphicSize(Std.int(pillarWipe.width * 3.22), Std.int(pillarWipe.height * 3.22));
    pillarWipe.updateHitbox();
    pillarWipe.camera = camHUD;
    add(pillarWipe);

    ring = new FlxSprite(0, 0);
    ring.frames = Paths.getSparrowAtlas('fullScreenIntroStuff-OLD');
    ring.animation.addByPrefix("ring", "ring", 15, false);
    ring.animation.play("ring");
    ring.antialiasing = false;
    ring.alpha = 0.001;
    ring.setGraphicSize(Std.int(ring.width * 3.22), Std.int(ring.height * 3.22));
    ring.updateHitbox();
    ring.camera = camHUD;
    add(ring);

    boyfriendRing = new FlxSprite(0, 720);
    boyfriendRing.frames = Paths.getSparrowAtlas('fullScreenIntroStuff-OLD');
    boyfriendRing.animation.addByPrefix("boyfriendRing", "bf", 15, false);
    boyfriendRing.animation.play("boyfriendRing");
    boyfriendRing.antialiasing = false;
    boyfriendRing.alpha = 0.001;
    boyfriendRing.setGraphicSize(Std.int(boyfriendRing.width * 3.22), Std.int(boyfriendRing.height * 3.22));
    boyfriendRing.updateHitbox();
    boyfriendRing.camera = camHUD;
    add(boyfriendRing);

    flashbang = new FlxSprite(2000, 2000, 0xFFFFFFFF);
    flashbang.setPosition(-500, -500);
    flashbang.alpha = 0.001;
    flashbang.scrollFactor.set(0, 0);
    flashbang.camera = camOther;
    add(flashbang);

    lyricsPlaceholder = new FlxSprite(0, 0);
    lyricsPlaceholder.frames = Paths.getSparrowAtlas("lyricsPlaceholder");
    lyricsPlaceholder.animation.addByPrefix("LETS", "1lets", 1, false);
    lyricsPlaceholder.animation.addByPrefix("PLAY", "2play", 1, false);
    lyricsPlaceholder.animation.addByPrefix("A", "3a", 1, false);
    lyricsPlaceholder.animation.addByPrefix("GAME", "4game", 1, false);
    lyricsPlaceholder.animation.addByPrefix("FOR", "5for", 1, false);
    lyricsPlaceholder.animation.addByPrefix("OLD", "6old", 1, false);
    lyricsPlaceholder.animation.addByPrefix("TIME", "7time", 1, false);
    lyricsPlaceholder.animation.addByPrefix("SAKE", "8sake", 1, false);
    lyricsPlaceholder.animation.addByPrefix("ARE", "9are", 1, false);
    lyricsPlaceholder.animation.addByPrefix("YOU", "10you", 1, false);
    lyricsPlaceholder.animation.addByPrefix("READY", "11ready", 1, false);
    lyricsPlaceholder.animation.addByPrefix("READY-glitch1", "12ready", 1, false);
    lyricsPlaceholder.animation.addByPrefix("READY-glitch2", "13ready", 1, false);
    lyricsPlaceholder.animation.addByPrefix("READY-glitch3", "14ready", 1, false);
    lyricsPlaceholder.animation.addByPrefix("READY-glitch4", "15ready", 1, false);
    lyricsPlaceholder.animation.play("LETS", true);
    lyricsPlaceholder.antialiasing = false;
    lyricsPlaceholder.alpha = 0.001;
    lyricsPlaceholder.camera = camOther;
    lyricsPlaceholder.setGraphicSize(Std.int(lyricsPlaceholder.width * 3.0), Std.int(lyricsPlaceholder.height * 3.0));
    lyricsPlaceholder.updateHitbox();
    add(lyricsPlaceholder);

    windowBlack = new FlxSprite(1150, 150).makeGraphic(300, 320, FlxColor.fromString("0xFF000000"));
    windowBlack.alpha = 0.001;
    windowBlack.scrollFactor.set(0, 0);
    insert(members.indexOf(desktopRiftMask) + 3, windowBlack);

    windowVessel = new FlxSprite(948, 83);
    windowVessel.frames = Paths.getSparrowAtlas("windowVessel");
    windowVessel.animation.addByPrefix("windowVessel", "windowVessel", 15, false);
    windowVessel.animation.play("windowVessel", true);
    windowVessel.alpha = 0.001;
    windowVessel.antialiasing = false;
    windowVessel.scrollFactor.set(0, 0);
    windowVessel.setGraphicSize(Std.int(windowVessel.width * 2.4), Std.int(windowVessel.height * 2.4));
    windowVessel.updateHitbox();
    insert(members.indexOf(boyfriend) + 4, windowVessel);

    rewriteWindowBox = new FlxSprite(948, 83);
    rewriteWindowBox.frames = Paths.getSparrowAtlas("rewriteWindowBox");
    rewriteWindowBox.animation.addByPrefix("rewriteWindowBox", "0_", 30, false);
    rewriteWindowBox.animation.play("rewriteWindowBox", true);
    rewriteWindowBox.alpha = 0.001;
    rewriteWindowBox.antialiasing = false;
    rewriteWindowBox.scrollFactor.set(0, 0);
    rewriteWindowBox.setGraphicSize(Std.int(rewriteWindowBox.width * 2.4), Std.int(rewriteWindowBox.height * 2.4));
    rewriteWindowBox.updateHitbox();
    insert(members.indexOf(boyfriend) + 7, rewriteWindowBox);

    bfMask = new FlxSprite(-290, -215).loadGraphic(Paths.image("bfMask"));
    bfMask.antialiasing = false;
    bfMask.alpha = 0.001;
    bfMask.scrollFactor.set(0, 0);
    bfMask.setGraphicSize(Std.int(bfMask.width * 2.4), Std.int(bfMask.height * 2.4));
    bfMask.updateHitbox();
    insert(members.indexOf(boyfriend) + 1, bfMask);

    rewriteHead = new FlxSprite(498, 133).loadGraphic(Paths.image("rewriteHead"));
    rewriteHead.alpha = 0.001;
    rewriteHead.antialiasing = false;
    rewriteHead.scrollFactor.set(0, 0);
    rewriteHead.setGraphicSize(Std.int(rewriteHead.width * 2.4), Std.int(rewriteHead.height * 2.4));
    rewriteHead.updateHitbox();
    add(rewriteHead);

    firewall = new FlxSprite(-360, -160 + 720);
    firewall.frames = Paths.getSparrowAtlas("firewall");
    firewall.animation.addByPrefix("firewall", "firewall", 15, true);
    firewall.animation.play("firewall");
    firewall.alpha = 0.001;
    firewall.antialiasing = false;
    firewall.scrollFactor.set(0, 0);
    firewall.setGraphicSize(Std.int(firewall.width * 5), Std.int(firewall.height * 5));
    firewall.updateHitbox();
    add(firewall);

    rewriteHeadCorpse = new FlxSprite(-360, -160);
    rewriteHeadCorpse.frames = Paths.getSparrowAtlas("rewriteEyes");
    rewriteHeadCorpse.animation.addByPrefix("temp", "corpseLoop", 15, false);
    rewriteHeadCorpse.animation.addByPrefix("corpse0", "corpse0", 15, false);
    rewriteHeadCorpse.animation.addByPrefix("corpseLoop", "corpseLoop", 12, true);
    rewriteHeadCorpse.animation.addByPrefix("corpseGlitch", "glitchCorpse", 24, true);
    rewriteHeadCorpse.animation.play("temp");
    rewriteHeadCorpse.antialiasing = false;
    rewriteHeadCorpse.alpha = 0.001;
    rewriteHeadCorpse.scrollFactor.set(0, 0);
    rewriteHeadCorpse.setGraphicSize(Std.int(rewriteHeadCorpse.width * 5), Std.int(rewriteHeadCorpse.height * 5));
    rewriteHeadCorpse.updateHitbox();
    add(rewriteHeadCorpse);
    setObjectOrder("rewriteHeadCorpse", dad + 1);

    rewriteHeadMask = new FlxSprite(-360, -160);
    rewriteHeadMask.frames = Paths.getSparrowAtlas("rewriteEyes");
    rewriteHeadMask.animation.addByPrefix("mask", "introMask", 15, false);
    rewriteHeadMask.animation.play("mask");
    rewriteHeadMask.antialiasing = false;
    rewriteHeadMask.alpha = 0.001;
    rewriteHeadMask.scrollFactor.set(0, 0);
    rewriteHeadMask.setGraphicSize(Std.int(rewriteHeadMask.width * 5), Std.int(rewriteHeadMask.height * 5));
    rewriteHeadMask.updateHitbox();
    add(rewriteHeadMask);
    setObjectOrder("rewriteHeadMask", dad + 2);

    errorBox4 = new FlxSprite(200, 300).loadGraphic(Paths.image("errorBox2"));
    errorBox4.alpha = 0.001;
    errorBox4.antialiasing = false;
    errorBox4.scrollFactor.set(0, 0);
    add(errorBox4);
    errorBox4.setGraphicSize(Std.int(errorBox4.width * 1), Std.int(errorBox4.height * 1));
    errorBox4.updateHitbox();

    errorBox3 = new FlxSprite(600, 100).loadGraphic(Paths.image("errorBox1"));
    errorBox3.alpha = 0.001;
    errorBox3.antialiasing = false;
    errorBox3.scrollFactor.set(0, 0);
    add(errorBox3);
    errorBox3.setGraphicSize(Std.int(errorBox3.width * 1), Std.int(errorBox3.height * 1));
    errorBox3.updateHitbox();

    errorBox2 = new FlxSprite(400, 500).loadGraphic(Paths.image("errorBox2"));
    errorBox2.alpha = 0.001;
    errorBox2.antialiasing = false;
    errorBox2.scrollFactor.set(0, 0);
    add(errorBox2);
    errorBox2.setGraphicSize(Std.int(errorBox2.width * 1), Std.int(errorBox2.height * 1));
    errorBox2.updateHitbox();

    errorBox1 = new FlxSprite(300, 400).loadGraphic(Paths.image("errorBox1"));
    errorBox1.alpha = 0.001;
    errorBox1.antialiasing = false;
    errorBox1.scrollFactor.set(0, 0);
    add(errorBox1);
    errorBox1.setGraphicSize(Std.int(errorBox1.width * 1), Std.int(errorBox1.height * 1));
    errorBox1.updateHitbox();

    setObjectOrder("errorBox1", dad + 3);
    setObjectOrder("errorBox2", dad + 4);
    setObjectOrder("errorBox3", dad + 5);
    setObjectOrder("errorBox4", dad + 6);

    jumpscare = new FlxSprite(0, 0).makeGraphic(320, 180, FlxColor.WHITE);
    jumpscare.loadGraphic(Paths.image("jumpscarePlaceholder"));
    jumpscare.alpha = 0.001;
    jumpscare.antialiasing = false;
    jumpscare.scrollFactor.set(0, 0);
    jumpscare.camera = camHUD;
    jumpscare.setGraphicSize(Std.int(jumpscare.width * 4), Std.int(jumpscare.height * 4));
    jumpscare.updateHitbox();
    add(jumpscare);

    fella1 = new FlxSprite(-50, 300);
    fella1.frames = Paths.getSparrowAtlas("fella");
    fella1.animation.addByPrefix("temp", "loop", 30, false);
    fella1.animation.addByPrefix("rise", "0_", 30, false);
    fella1.animation.addByPrefix("loop", "loop", 30, true);
    fella1.animation.play("temp");
    fella1.alpha = 0.001;
    fella1.angle = 90;
    fella1.antialiasing = false;
    fella1.scrollFactor.set(0, 0);
    fella1.camera = camOther;
    fella1.setGraphicSize(Std.int(fella1.width * 3), Std.int(fella1.height * 3));
    fella1.updateHitbox();
    add(fella1);

    fella2 = new FlxSprite(940, 150);
    fella2.frames = Paths.getSparrowAtlas("fella");
    fella2.animation.addByPrefix("temp", "loop", 30, false);
    fella2.animation.addByPrefix("rise", "0_", 30, false);
    fella2.animation.addByPrefix("loop", "loop", 30, true);
    fella2.animation.play("temp");
    fella2.alpha = 0.001;
    fella2.angle = 270;
    fella2.antialiasing = false;
    fella2.scrollFactor.set(0, 0);
    fella2.camera = camOther;
    fella2.setGraphicSize(Std.int(fella2.width * 3), Std.int(fella2.height * 3));
    fella2.updateHitbox();
    add(fella2);

    fella3 = new FlxSprite(200, 0);
    fella3.frames = Paths.getSparrowAtlas("fella");
    fella3.animation.addByPrefix("temp", "loop", 30, false);
    fella3.animation.addByPrefix("rise", "0_", 30, false);
    fella3.animation.addByPrefix("loop", "loop", 30, true);
    fella3.animation.play("temp");
    fella3.alpha = 0.001;
    fella3.angle = 180;
    fella3.antialiasing = false;
    fella3.scrollFactor.set(0, 0);
    fella3.camera = camOther;
    fella3.setGraphicSize(Std.int(fella3.width * 3), Std.int(fella3.height * 3));
    fella3.updateHitbox();
    add(fella3);

    iAmGodScreamer = new FlxSprite().loadGraphic(Paths.image("iAmGodKyokai"));
    iAmGodScreamer.antialiasing = false;
    iAmGodScreamer.camera = getCamera("video");
    iAmGodScreamer.setGraphicSize(1280, 720);
    iAmGodScreamer.screenCenter();
    iAmGodScreamer.alpha = 0;
    add(iAmGodScreamer);
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
    if(vid == 'lxVideo'){
        camHUD.alpha = 1;
        FlxG.camera.alpha = 1;
    }
    camZooming = false;
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.play();
    vid.offset.x -= 0;

    vid.scale.set(1,1);
    if(vid == fusionVideo){
        remove(vid, true);
        insert(0, vid);
    }
    //commento ut the thingy soi  can play
    if (vid == xVideo){
        xVideo.camera = camHUD;
    }
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

    if (vid == lxVideo) camVideo.flash(0xFF000000, 1);
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