import hxvlc.flixel.FlxVideoSprite;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.framerate.Framerate;
import openfl.display.BlendMode;
import openfl.Lib;
import openfl.system.Capabilities;
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
//Silly Stupid
var sillyZoomBool:Bool = false;
// Window management
var shakeLevelMinVar:FlxSprite; //holy shit this is genius
var shakeLevelMaxVar:FlxSprite; //holy shit this is genius
var shakeLevelMin:Int = 0;
var shakeLevelMax:Int = 0;
//nvm just remembered FlxPoint Exists
var windowOriginX:Int = 0;
var windowOriginY:Int = 0;
var windowShakeX:Float = 0;
var windowShakeY:Float = 0;
var windowShakeStrength:Float = 12;

var maxWidth:Int = 1920;
var maxHeight:Int = 1080;
var windowLock:Bool = true;
//shaders
var glitchShader:CustomShader;
var itime:Float = 0;
var activeTimers:Array<{tag:String, time:Float, callback:Void->Void}> = [];

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
var screen = Capabilities.screenResolutionX;
var screenH = Capabilities.screenResolutionY;
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
var internalOverlay:FlxSprite;
var startSong:Bool = false;
var beat:Int = 0;

// Common flags
var downscroll:Bool = false;
var lowQuality:Bool = false;
var shadersEnabled:Bool = true;

var majinVideo:FlxVideoSprite;
var xVideo:FlxVideoSprite;
var fusionVideo:FlxVideoSprite;
var lxVideo:FlxVideoSprite;
var videoArray:Array<FlxVideoSprite> = [];
var videosToDestroy:Array<FlxVideoSprite> = [];

var texture:String = "NOTE_assets";
var camOther = new FlxCamera();
var camVideo = new FlxCamera();
var camNotes = new HudCamera();
var ogWinX:Int = 1280;
var ogWinY:Int = 720;

//Mod Options
var windowFuckery:Bool = true;


//Holy Var Fuck that list is big
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
var sa2Posing2Shadow:FlxSprite;
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
var iAmGod:FlxSprite;
public var camLock:Bool = false;
function onPostStrumCreation() {
      for (e in strumLines.members[1]) {
            e.camera = camNotes;
      }
    }
function runTimer(tag:String, duration:Float, ?callback:Void->Void) {
	activeTimers.push({
		tag: tag,
		time: duration,
		callback: callback != null ? callback : function() {
			onTimerCompleted(tag);
		}
	});
}
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
        case "camNotes":
            return camNotes;
        default:
            return camGame;
    }
}
function cacheVideos(){
        videoArray = [majinVideo, xVideo, fusionVideo, lxVideo];
    for (i in videoArray)
    {
        i.bitmap.rate = 1;
        i.alpha = 0.001;
        i.autoPause = true;
        i.cameras = [i == majinVideo ? camHUD : camHUD];
        i.screenCenter();
        add(i);
    }
    for (i in videoArray)
    {
        i.play(); // This fixes a visual issue where the video doesnt play until a little bit after it should
        new FlxTimer().start(0.1, function(tmr) {
			i.pause();
            i.bitmap.time = 0;
		});
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
 function create(){
        glitchShader = new CustomShader("glitch");

    PlayState.instance.introLength = 3; //just so shit can precache
    for (i in 0...15) {
        Paths.image("modelSwap/" + i); // Preload image to cache it
    }
}
 function postCreate() {
    glitchIntro = new FlxSprite(0, 0);
    glitchIntro.loadGraphic(Paths.image("modelSwap/0"));
    glitchIntro.antialiasing = false;
    glitchIntro.alpha = 0.001;
    glitchIntro.setGraphicSize(Std.int(glitchIntro.width * 3.22), Std.int(glitchIntro.height * 3.22));
    glitchIntro.updateHitbox();
    glitchIntro.cameras = [camHUD];
    add(glitchIntro);

    shakeLevelMinVar = new FlxSprite();
    shakeLevelMinVar.alpha = 0.01;
    add(shakeLevelMinVar);
    shakeLevelMaxVar = new FlxSprite();
    shakeLevelMaxVar.alpha = 0.01;
    add(shakeLevelMaxVar);
    FlxG.autoPause = true;
    camGame.alpha = 0;
    var winX:Int = 820;
    var winY:Int = 720;
    FlxG.resizeWindow(winX, winY);
    FlxG.resizeGame(winX, winY);
    FlxG.scaleMode.width = winX;
    FlxG.scaleMode.height = winY;
    FlxG.cameras.insert(camOther, FlxG.cameras.list.indexOf(camGame) + 1, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
    camOther.setSize(winX, winY);
    FlxG.cameras.insert(camNotes, FlxG.cameras.list.indexOf(camGame) + 3, false); //+5 to make sure its high enough
    camNotes.bgColor = 0;
    camNotes.alpha = 1;
    camNotes.setSize(winX, winY);
    FlxG.cameras.insert(camVideo, FlxG.cameras.list.indexOf(camNotes) - 1, false);
    camVideo.bgColor = 0;
    camVideo.alpha = 1;
    camGame.setSize(winX, winY);
    camHUD.setSize(winX, winY);
    camHUD.setPosition(0,0);
    camGame.setPosition(0,0);

    Framerate.debugMode = 0;
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


    
    //PlayState.checkpointTime = 135000; // legacy
    //PlayState.checkpointTime = 277500; // rewrite

    Paths.image("noteSkins/internalX_Notes");
    Paths.image("noteSkins/NOTE_assets-FNF");
    Paths.image("noteSkins/NOTE_assets");  
    cacheVideos();
    //RELEASE THE BABIES!!!!
    snowPostCreate(); //seperate function for snow post create cause its shit from his
    //modchart script just convertedd

}
function snowPostCreate(){
    window.fullscreen = false;
    window.resizable = false;
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
    desktopRift.setGraphicSize(desktopRift.width * 2.5);
    add(desktopRift);

    desktopRiftMask = new FlxSprite(-275, -160);
    desktopRiftMask.frames = Paths.getSparrowAtlas("desktopRift");
    desktopRiftMask.animation.addByPrefix("desktopRiftMask", "riftMask", 12, false);
    desktopRiftMask.animation.addByPrefix("temp", "riftMask", 15, false);
    desktopRiftMask.animation.play("temp");
    desktopRiftMask.antialiasing = false;
    desktopRiftMask.alpha = 0.001;
    desktopRiftMask.scrollFactor.set(0, 0);
    desktopRiftMask.setGraphicSize(desktopRiftMask.width * 2.5);
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
    remove(fullScreenIntroBG, true);
    insert(0, fullScreenIntroBG);

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
    remove(fullScreenIntro, true);
    insert(0, fullScreenIntro);

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
    remove(fullScreenRunning, true);
    insert(1, fullScreenRunning);

    sa2Posing = new FlxSprite(-1280, 150);
    sa2Posing.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing.animation.addByPrefix("bf", "bfSA2_", 15, false);
    sa2Posing.animation.play("bf");
    sa2Posing.antialiasing = false;
    sa2Posing.alpha = 1;
    sa2Posing.setGraphicSize(sa2Posing.width * 3.22, sa2Posing.height * 3.22);
    sa2Posing.updateHitbox();
    sa2Posing.camera = camHUD;
    add(sa2Posing);

    sa2Posing2 = new FlxSprite(1280, 150);
    sa2Posing2.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing2.animation.addByPrefix("rewrite", "sonicSA2_", 15, false);
    sa2Posing2.animation.play("rewrite");
    sa2Posing2.antialiasing = false;
    sa2Posing2.alpha = 1;
    sa2Posing2.setGraphicSize(sa2Posing2.width * 3.22, sa2Posing2.height * 3.22);
    sa2Posing2.updateHitbox();
    sa2Posing2.camera = camHUD;
    add(sa2Posing2);

    sa2PosingShadow = new FlxSprite(-1280, 150);
    sa2PosingShadow.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2PosingShadow.animation.addByPrefix("bfShadow", "bfSA2Shadow_", 15, false);
    sa2PosingShadow.animation.play("bfShadow");
    sa2PosingShadow.antialiasing = false;
    sa2PosingShadow.alpha = 0.001;
    sa2PosingShadow.setGraphicSize(sa2PosingShadow.width * 3.22, sa2PosingShadow.height * 3.22);
    sa2PosingShadow.updateHitbox();
    sa2PosingShadow.camera = camHUD;
    add(sa2PosingShadow);

    sa2Posing2Shadow = new FlxSprite(1280, 150);
    sa2Posing2Shadow.frames = Paths.getSparrowAtlas('fullScreenIntroStuff');
    sa2Posing2Shadow.animation.addByPrefix("rewriteShadow", "sonicSA2Shadow_", 15, false);
    sa2Posing2Shadow.animation.play("rewriteShadow");
    sa2Posing2Shadow.antialiasing = false;
    sa2Posing2Shadow.alpha = 0.001;
    sa2Posing2Shadow.setGraphicSize(sa2Posing2Shadow.width * 3.22, sa2Posing2Shadow.height * 3.22);
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
    pillarWipe.setGraphicSize(pillarWipe.width * 3.22, pillarWipe.height * 3.22);
    pillarWipe.updateHitbox();
    pillarWipe.camera = camHUD;
    add(pillarWipe);
    remove(pillarWipe, true);
    insert(2, pillarWipe);

    ring = new FlxSprite(0, 0);
    ring.frames = Paths.getSparrowAtlas('fullScreenIntroStuff-OLD');
    ring.animation.addByPrefix("ring", "ring", 15, false);
    ring.animation.play("ring");
    ring.antialiasing = false;
    ring.alpha = 0.001;
    ring.setGraphicSize(ring.width * 3.22, ring.height * 3.22);
    ring.updateHitbox();
    ring.camera = camHUD;
    add(ring);

    boyfriendRing = new FlxSprite(0, 720);
    boyfriendRing.frames = Paths.getSparrowAtlas('fullScreenIntroStuff-OLD');
    boyfriendRing.animation.addByPrefix("boyfriendRing", "bf", 15, false);
    boyfriendRing.animation.play("boyfriendRing");
    boyfriendRing.antialiasing = false;
    boyfriendRing.alpha = 0.001;
    boyfriendRing.setGraphicSize(boyfriendRing.width * 3.22, boyfriendRing.height * 3.22);
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
    lyricsPlaceholder.setGraphicSize(lyricsPlaceholder.width * 3.0, lyricsPlaceholder.height * 3.0);
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
    windowVessel.setGraphicSize(windowVessel.width * 2.4, windowVessel.height * 2.4);
    windowVessel.updateHitbox();
    insert(members.indexOf(boyfriend) + 4, windowVessel);

    rewriteWindowBox = new FlxSprite(948, 83);
    rewriteWindowBox.frames = Paths.getSparrowAtlas("rewriteWindowBox");
    rewriteWindowBox.animation.addByPrefix("rewriteWindowBox", "0_", 30, false);
    rewriteWindowBox.animation.play("rewriteWindowBox", true);
    rewriteWindowBox.alpha = 0.001;
    rewriteWindowBox.antialiasing = false;
    rewriteWindowBox.scrollFactor.set(0, 0);
    rewriteWindowBox.setGraphicSize(rewriteWindowBox.width * 2.4, rewriteWindowBox.height * 2.4);
    rewriteWindowBox.updateHitbox();
    insert(99, rewriteWindowBox);

    bfMask = new FlxSprite(-290, -215).loadGraphic(Paths.image("bfMask"));
    bfMask.antialiasing = false;
    bfMask.alpha = 0.001;
    bfMask.scrollFactor.set(0, 0);
    bfMask.setGraphicSize(bfMask.width * 2.4, bfMask.height * 2.4);
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

    iAmGod = new FlxSprite(0, 0);
    iAmGod.frames = Paths.getSparrowAtlas('iAmGodTxt');
    iAmGod.animation.addByPrefix("iAmGod", "iamgod", 15, false);
    iAmGod.animation.play("iAmGod");
    iAmGod.alpha = 0.001;
    iAmGod.antialiasing = false;
    iAmGod.scrollFactor.set(0, 0);
    iAmGod.camera = camOther;
    iAmGod.screenCenter(FlxAxes.X);
    iAmGod.setGraphicSize(Std.int(iAmGod.width * 3));
    iAmGod.updateHitbox();
    add(iAmGod);
    iAmGod.y = 535;

}
var wasFocused:Bool = true;
function onCameraMove(event){
    if(camLock){
        event.cancel();
        return;
    }
}
function update(elapsed:Float){
    for (i in 0...activeTimers.length) {
	var timer = activeTimers[i];
	timer.time -= elapsed;
	if (timer.time <= 0) {
		timer.callback();
		activeTimers.remove(timer);
		break;
	}
}
    itime+=elapsed;
    glitchShader.iTime = itime;
}
function postUpdate(){
    camNotes.zoom = camHUD.zoom;
    camNotes.alpha = camHUD.alpha;
    sa2PosingShadow.x = sa2Posing.x;
    sa2Posing2Shadow.x = sa2Posing2.x;

    if (rewriteHeadCorpse.animation.curAnim != null && rewriteHeadCorpse.animation.curAnim.finished) {
        if (rewriteHeadCorpse.animation.curAnim.name == "corpse0" && !stopUpdatingDummy) {
            rewriteHeadCorpse.animation.play("corpseLoop", false, false, 0);
            stopUpdatingDummy = true;
        }
    }

    if (fella1.animation.curAnim != null && fella1.animation.curAnim.finished) {
        if (fella1.animation.curAnim.name == "rise" && !stopUpdatingDummy2) {
            fella1.animation.play("loop", true, false, 0);
            stopUpdatingDummy2 = true;
        }
    }

    if (fella2.animation.curAnim != null && fella2.animation.curAnim.finished) {
        if (fella2.animation.curAnim.name == "rise" && !stopUpdatingDummy3) {
            fella2.animation.play("loop", true, false, 0);
            stopUpdatingDummy3 = true;
        }
    }

    if (fella3.animation.curAnim != null && fella3.animation.curAnim.finished) {
        if (fella3.animation.curAnim.name == "rise" && !stopUpdatingDummy4) {
            fella3.animation.play("loop", true, false, 0);
            stopUpdatingDummy4 = true;
        }
    }
    if (curStep >= 2892 && curStep < 2896) {
        windowLock = false;

        // Set window opacity (if supported)
        if (window != null) {
            window.opacity = 1;
            window.title = "";
            window.x = windowOriginX + FlxG.random.float(-500, 500);
            window.y = windowOriginY + FlxG.random.float(-150, 150);
        }

        FlxG.autoPause = true;
    }

    shakeLevelMin = shakeLevelMinVar.x;
    shakeLevelMax = shakeLevelMaxVar.x;

    if (pillarWipe.animation.curAnim != null && pillarWipe.animation.curAnim.name == "wipe" && pillarWipe.animation.curAnim.curFrame == 3 && !stopUpdatingDummyFFS) {
        fullScreenIntro.kill();
        fullScreenIntro.exists = false;

        FlxTween.color(fullScreenIntroBG, 0.01, fullScreenIntroBG.color, FlxColor.fromString("0xFF100410"), {ease: FlxEase.linear});
        fullScreenRunning.alpha = 0;

        runTimer('removePillar', 0.01);


        FlxTween.tween(sa2Posing, {x: 500}, 0.15, {ease: FlxEase.linear});
        FlxTween.tween(sa2Posing2, {x: 300}, 0.15, {ease: FlxEase.linear});

        stopUpdatingDummyFFS = true;
    }

        for(i in videoArray){
            if(i != null && i.alpha != 1) //IM SO FUCKING DONE WITH THE AUTOPAUSE NOT WORKING
                i.pause();
        }
        if (FlxG.focused != wasFocused) {
        if (FlxG.focused) {
            resumeVideos();
        } else {
            pauseVideos();
        }
        wasFocused = FlxG.focused;
    }
    for (i in videoArray) if (i.alpha == 1) i.screenCenter();

    // safety net bullshit thank you snow for the idea
    if (videosToDestroy.length > 0) for (i in videosToDestroy) if (i != null){
        i.alpha = 0.5;
        i.destroy();
    }
    for(i in 0...playerStrums.length) playerStrums.members[i].noteAngle = 0;

}
function pauseVideos(){
    for (i in videoArray){
        if (i != null) i.pause();

    }
}
function resumeVideos(){
    for (i in videoArray){
        if (i != null && i.alpha == 1) i.resume();
    }
}
function onSubstateOpen() for (i in videoArray) pauseVideos();
function onSubstateClose() for (i in videoArray) resumeVideos();
function onFucusLost() {
    for (i in videoArray) if (i != null) i.pause();
}
function onFocus() {
    if (!FlxG.paused) {
        for (i in videoArray) if (i != null && i.alpha == 1) i.resume();
    }
}
//function onCountdown(event) event.cancel();
function fusionAAA(){
    playVideo(fusionVideo, 25.25, 1); // 25.45
}
function destroy() {
    FlxG.resizeWindow(ogWinX, ogWinY);
    FlxG.resizeGame(ogWinX, ogWinY);
    FlxG.scaleMode.width = ogWinX;
    FlxG.scaleMode.height = ogWinY;
    FlxG.camera.setSize(ogWinX, ogWinY);
    window.fullscreen = false;
    window.resizable = true;
    window.borderless = false;
}

var glitchIntro:FlxSprite;

var glitchIntro:FlxSprite;
var glitchFrame:Int = 1;
function introGlitch(value1:String) {
	if (value1 != "hide") {
		glitchIntro.alpha = 1;
		glitchIntro.visible = true;

		glitchFrame++;
		if (glitchFrame > 12) glitchFrame = 1;

		glitchIntro.loadGraphic(Paths.image("modelSwap/" + glitchFrame));
	} else {

		glitchIntro.visible = false;
        dad.screenCenter();
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
    PlayState.instance.camZooming = theBool;
}
function lordSexVid(){
    camGame.alpha = 1;
    camHUD.alpha = 1;
    playVideo(lxVideo, 18.00, 1);
}
function camAlphaFix(){
    camGame.alpha = 1;
    camHUD.alpha = 1;
    camOther.alpha = 1;
    camVideo.alpha = 1;
}
function hudfadeIn(){
    //        doTweenAlpha("camHUD", "camHUD", 1, 2, "sineOut")
    FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.sineOut, onComplete: function(){
    }});

}
function camisDied(){
    camGame.alpha = 0;
    camHUD.alpha = 0;
    camOther.alpha = 0;
}
function playVideo(vid:FlxVideoSprite, endTime:Float, strumTime:Float)
{
    if(vid == 'lxVideo'){
        camHUD.alpha = 1;
        camGame.alpha = 1;
        camNotes.alpha = 1;
    }
    camZooming = false;
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
        vid.alpha = 0.5;
        if (vid == majinVideo) camGame.alpha = 1;
        videosToDestroy.push(vid);
    });

    if (vid == lxVideo) camVideo.flash(0xFF000000, 1);
    if (vid == majinVideo) camVideo.flash(0xFF000000, 1);
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.play();
}
function onSongStart(){
    FlxG.autoPause = true;
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
        FlxTween.tween(playerStrums.members[i], {angle: 360}, 0.2, {ease: FlxEase.quintOut});
    }
}
var tweenValue:Float = 7;
function slowZoom(amt:Int, time:Int){
    camGame.zoom = defaultCamZoom = FlxTween.num(defaultCamZoom, amt, time, {ease: FlxEase.sineOut}, function(v:Float)
        {
            camGame.zoom = defaultCamZoom = v;
        });
}
function setWindowTitle(windowTitle:String) window.title = windowTitle;
function changeBG(v1:String){
    if(v1 == 'monitor'){
            defaultCamZoom = 1.25;
            camGame.zoom = 1.25;
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
            /*            boyfriend.y += 580;
            dad.y += 220;
            dad.x += 580;
            boyfriend.x += 580;*/
                boyfriend.y += 580;
                dad.y += 220;
                dad.x += 580;
                boyfriend.x += 580;
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
        if(v1 == 'void'){
            boyfriend.y += 600;
            dad.y += 250;
            dad.x += 600;
            boyfriend.x += 600;
            stageskyR.alpha = 0.001;
            stagebackR.alpha = 0.001;
            stagegroundR.alpha = 0.001;
            stageobjR.alpha = 0.001;
            stagestuffR.alpha = 0.001;

        }
        if(v1 == 'lx2'){
            if(lxVideo.alpha != 0) lxVideo.alpha = 0;
            stagebackLX.alpha = 0.001;
            if(FlxG.save.data.flashingLights){
                stagebackLX2.alpha = 1;
            }else{
                stagebackLX2.alpha = 0.25;
            }
        }
        if(v1 == 'internal'){ //this just for the cam mainly and to kill BF
            slowZoom(0.9, 0.1);
            boyfriend.alpha = 0.001; //bf is fucking died
        
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
end*/
function doTweenWindow(tag:String, field:String, value:Float, duration:Float, ease:String, tweenType:Int) {
    if (windowFuckery || allowWinTween) {
        switch (field) {
            case "width":
                FlxTween.num(FlxG.width, value, duration, {
                    ease: FlxEase.byName(ease),
                    type: tweenType
                }, function(v:Float) FlxG.resizeWindow(Std.int(v), FlxG.height));
            case "height":
                FlxTween.num(FlxG.height, value, duration, {
                    ease: FlxEase.byName(ease),
                    type: tweenType
                }, function(v:Float) FlxG.resizeWindow(FlxG.width, Std.int(v)));
            case "x":
                FlxTween.tween(Lib.application.window, {x: value}, duration, {ease: FlxEase.byName(ease), type: tweenType});
            case "y":
                FlxTween.tween(Lib.application.window, {y: value}, duration, {ease: FlxEase.byName(ease), type: tweenType});
        }
    }
}

function doTweenStage(tag:String, field:String, value:Float, duration:Float, ease:String, tweenType:Int) {
    if (windowFuckery || allowWinTween) {
        var target = FlxG.stage;
        switch (field) {
            case "x":
                FlxTween.tween(target, {x: value}, duration, {ease: FlxEase.byName(ease), type: tweenType});
            case "y":
                FlxTween.tween(target, {y: value}, duration, {ease: FlxEase.byName(ease), type: tweenType});
        }
    }
}
var safteyNet2:Bool = false;
var safteyNet4:Bool = false;
var safetyNet3:Bool = false;
function stepHit(step:Int){
    if(curStep == 3790){
        runTimer('glitch1', 0.05); 
    }
    if(curStep == 3837){
        runTimer('rewriteCutsceneTransition', 0.04); // the timing is very precise,,,
    }
    switch (step) {
        case 3924, 3956:
            lyricsPlaceholder.screenCenter(FlxAxes.X);
            lyricsPlaceholder.animation.play("PLAY");

        case 3928, 3960:
            lyricsPlaceholder.animation.play("A");

        case 3932, 3964:
            lyricsPlaceholder.animation.play("GAME");

        case 3936:
            lyricsPlaceholder.animation.play("FOR");

        case 3940:
            lyricsPlaceholder.animation.play("OLD");

        case 3944:
            lyricsPlaceholder.animation.play("TIME");

        case 3948:
            lyricsPlaceholder.animation.play("SAKE");

        case 3952:
            lyricsPlaceholder.animation.play("LETS");

        case 3968:
            lyricsPlaceholder.animation.play("ARE");

        case 3972:
            lyricsPlaceholder.animation.play("YOU");

        case 3976:
            lyricsPlaceholder.animation.play("READY");

        case 3980:
            lyricsPlaceholder.animation.play("READY-glitch1");
            flashbang.visible = true;
            transColour.visible = false;
            camGame.visible = false;
            //aspect.visible = true;
//wtf is aspect
        case 3981:
            lyricsPlaceholder.animation.play("READY-glitch2");
            transColour.visible = false;
            camGame.visible = true;
            //aspect.visible = true;

            flashbang.makeGraphic(2500, 2000, FlxColor.RED);
            flashbang.blend = BlendMode.ADD; // Use 'ADD', 'MULTIPLY', etc. — adjust if needed
            // If you need multiply and it's defined as string, use:
            // flashbang.blend = BlendMode.MULTIPLY;

        case 3982:
            transColour.visible = true;
            transColour.alpha = 1;
            camGame.visible = false;
            //aspect.visible = false;

            flashbang.kill();
            flashbang.exists = false;

            lyricsPlaceholder.animation.play("READY-glitch3");

        case 3983:
            camGame.visible = true;
            lyricsPlaceholder.animation.play("READY-glitch4");

        case 3984:
            lyricsPlaceholder.kill();
            lyricsPlaceholder.exists = false;
    }

    if (curStep == 2800) {
        fakeCrash = new FlxSprite(250, 30);
        fakeCrash.loadGraphic(Paths.image("crashScreen"));
        fakeCrash.scrollFactor.set(0, 0);
        fakeCrash.setGraphicSize(Std.int(fakeCrash.width * 3), Std.int(fakeCrash.height * 3));
        fakeCrash.updateHitbox();
        fakeCrash.antialiasing = false;
        fakeCrash.cameras = [camOther];
        add(fakeCrash, true);

        window.title = "UH OH!";

        dad.visible = true;
    }

    if (curStep == 2860) {
        window.opacity = 0;
        FlxG.autoPause = false;

        camGame.alpha = 0;
        camHUD.alpha = 0;
        camOther.alpha = 0;
    }

    if (curStep == 2877) {
        window.opacity = 1;
        window.setPosition(
            Std.int((screen - winWidth) / 2),
            Std.int((screenH - winHeight) / 2)
        );    
    }

    if (curStep == 2880) {
        boyfriend.alpha = 1;

        if (internalOverlay != null) remove(internalOverlay, false);
        if (internalBG != null) remove(internalBG, false);
        if (internalColour != null) remove(internalColour, true);
        if (internalGradient != null) remove(internalGradient, true);
        if (fakeCrash != null) remove(fakeCrash, true);
        if (illegal != null) remove(illegal, true);
    }


    if(step == 2496){
        stagebackLX2.alpha = 0.001;
        stagebackLX.alpha = 0.001;
    }
    if (step == 3788){
        stageskyR.alpha = 0.001;
        stagebackR.alpha = 0.001;
        stagegroundR.alpha = 0.001;
        stageobjR.alpha = 0.001;
        stagestuffR.alpha = 0.001;

        stars.alpha = 1;
        shapes.alpha = 1;
        floor.alpha = 1;
    }
    if(step == 2779) internalBGBop = false;

    if (curStep == 2784) {
    dad.stunned = true;
    windowLock = true;
    pauseOverride = true;
    canPause = false;

    FlxG.stage.window.opacity = 1;

    camHUD.alpha = 0;
    internalShaderUpdate = false;

    var illegal = new FlxSprite(270, 300);
    illegal.loadGraphic(Paths.image('illegal'));
    illegal.setGraphicSize(Std.int(illegal.width * 3.0), Std.int(illegal.height * 3.0));
    illegal.antialiasing = false;
    illegal.scrollFactor.set(0, 0);
    illegal.cameras = [camOther];
    add(illegal);
    }

    if (curStep == 2796) {
        camGame.alpha = 0;
        internalBG.alpha = 0;
        if (internalOverlay != null) internalOverlay.alpha = 0;
        internalGradient.alpha = 0;
        internalColour.alpha = 0;
        illegal.alpha = 0;
    }


    if(step == 3840){
        stars.alpha = 0.001;
        shapes.alpha = 0.001;
        floor.alpha = 0.001;
    }
    if (step == 4044) {
    //playAnim("windowVessel", "windowVessel", true, false, 0);
    windowBlack.alpha = 1;
    windowVessel.alpha = 1;
    windowVessel.animation.play("windowVessel", true);

    boyfriend.x = 1240;
    boyfriend.y = 495;
    boyfriend.alpha = 1;
    }
    if(step >= 2912 && !safetyNet2){
        camGame.alpha = 1;
        camHUD.alpha = 0;
        camOther.alpha = 1;
        camVideo.alpha = 1;
        PlayState.instance.camZooming = true;
        PlayState.instance.camZoomingInterval = 444; //delays it so it dont zoom during the thigny
        //cameraFlash("camOther", "EDFCD5", 7, true)

        //canPause = true


        
        //runHaxeCode('window.focus();')
        maxCamZoom = 10;
        defaultCamZoom = 7;
        camGame.zoom = 7;
        //doTweenZoom("rewriteTime", "camGame", 1.1, 10, "sineInOut")
        camGame.alpha = 1;
        camOther.alpha = 1;
        camHUD.alpha = 0;
        safetyNet2 = true;
        slowZoom(1.1, 10);
    }
    if (step == 3084){
        iAmGod.screenCenter(FlxAxes.X);
        iAmGod.y = 535; //redo cords since its made before 4:3 is on
        iAmGod.alpha = 1;
        iAmGod.animation.play("iAmGod");
    }

    if (step == 3100 && iAmGod.alpha == 1){
        iAmGod.alpha = 0;
    }
    if (step == 3568) {
        windowLock = false;
        windowShaking = true;

        rewriteStomp.animation.play("animation", true);
        rewriteStomp.alpha = 1;
        rewriteStomp.screenCenter();

        windowShakeX = windowOriginX;
        windowShakeY = windowOriginY;

        shakeLevelMinVar.x = -30;
        shakeLevelMaxVar.x = 30;

        FlxTween.tween(shakeLevelMinVar, {x: 0}, 0.25, {ease: FlxEase.quadOut});
        FlxTween.tween(shakeLevelMaxVar, {x: 0}, 0.25, {ease: FlxEase.quadOut});

        window.borderless = true;
    }

    if (step == 3570) window.borderless = false;
    if (step == 3573) window.borderless = true;
    if (step == 3574) window.borderless = false;

    if (step == 3576) {
        trace("step 3576");
        shakeLevelMinVar.x = -50;
        shakeLevelMaxVar.x = 50;
        FlxTween.tween(shakeLevelMinVar, {x: 0}, 0.25, {ease: FlxEase.quadOut});
        FlxTween.tween(shakeLevelMaxVar, {x: 0}, 0.25, {ease: FlxEase.quadOut});
        window.borderless = true;
    }

    if (step == 3584) {

        trace("step 3584");
        allowWinTween = true;
        lockShakeX = true;

        //FlxTween.tween(window, {width: 1280}, 0.25, {ease: FlxEase.bounceOut});
        //FlxTween.tween(stage, {width: 1280}, 0.25, {ease: FlxEase.bounceOut});
        //FlxTween.tween(window, {x: windowOriginX - 230}, 0.25, {ease: FlxEase.bounceOut});

        FlxTween.tween(camGame, {x: 0}, 0.25, {ease: FlxEase.bounceOut});
        FlxTween.tween(camHUD, {x: 0}, 0.25, {ease: FlxEase.bounceOut});
        FlxTween.tween(camOther, {x: 0}, 0.25, {ease: FlxEase.bounceOut});
        FlxTween.tween(camVideo, {x: 0}, 0.25, {ease: FlxEase.bounceOut});

        shakeLevelMinVar.x = -100;
        shakeLevelMaxVar.x = 100;

        FlxTween.tween(shakeLevelMinVar, {x: 0}, 0.2, {ease: FlxEase.quadOut});
        FlxTween.tween(shakeLevelMaxVar, {x: 0}, 0.2, {ease: FlxEase.quadOut});
    }

    if (step == 3596) {
        trace("step 3596");
        windowShaking = false;
        //doTweenWindow('fullscreen1', 'width', maxWidth+1, 0.4,'quintIn',1);
        //doTweenWindow('fullscreen2', 'height', maxHeight+1, 0.4,'quintIn',1);
        var winX:Int = 1280;
        var winY:Int = 720;
        FlxG.resizeWindow(1920, 1080); //Placeholder for the window size, you can change it to whatever you want
        window.move(0,0);
        FlxG.resizeGame(winX, winY);
        FlxG.scaleMode.width = winX;
        FlxG.scaleMode.height = winY;
        camGame.setSize(winX, winY);
        camHUD.setSize(winX, winY);
        camHUD.setPosition(0,0);
        camGame.setPosition(0,0);
        rewriteStomp.screenCenter();
        doTweenWindow('fullscreen3', 'x', 0, 0.4,'quintIn',1);
        doTweenWindow('fullscreen4', 'y', 0, 0.4,'quintIn',1);
    }

    if (step >= 3600 && !fullscreenLagCheck1) {
        trace("step >= 3600");
        camHUD.alpha = 0;
        fullScreenIntroBG.alpha = 1;
        camOther.visible = false;
        boyfriend.alpha = 0;
        //Main.fpsVar.visible = false;
        //hide FPS Later

        /*healthLabel.x = 20;
        healthValue.x = 150;
        healthLabelShadow.x = 25;
        healthValueShadow.x = 155;
        */
        //havent added the health HUD Yet
        fullscreenLagCheck1 = true;
    }

    if (step >= 3656 && !fullscreenLagCheck2) {
        FlxTween.tween(camHUD, {alpha: 1}, 0.25, {ease: FlxEase.sineInOut});
        fullscreenLagCheck2 = true;
    }

    if (step >= 3660 && !fullscreenLagCheck3) {
        fullScreenIntro.animation.play("loop");
        defaultCamZoom = 0.7;
        camGame.zoom = 0.7;
        remove("rewriteStomp", false);
        fullscreenLagCheck3 = true;
    }

    if (step >= 3664 && !fullscreenLagCheck4) {
        camGame.flash(FlxColor.fromString("0xFFEEFAD5"), 0.25, false);
        FlxTween.color(fullScreenIntroBG, 0.1, fullScreenIntroBG.color, FlxColor.fromString("0xFFEEFAD5"));        
        fullScreenIntro.alpha = 1;
        fullscreenLagCheck4 = true;
    }

    if (step >= 3667 && !fullscreenLagCheck5) {
        FlxTween.tween(fullScreenRunning, {x: 500}, 2, {ease: FlxEase.quadOut});
        fullscreenLagCheck5 = true;
    }

    if (step == 3692) {
        pillarWipe.alpha = 1;
        pillarWipe.animation.play("wipe", true);
    }

    if (step == 3696) {
        pillarWipe.alpha = 0;
        FlxTween.tween(sa2Posing, {x: 600}, 6.75, {ease: FlxEase.linear});
        FlxTween.tween(sa2Posing2, {x: 200}, 6.75, {ease: FlxEase.linear});
    }

    if (step == 3728) {
        FlxTween.color(fullScreenIntroBG, 0.001, fullScreenIntroBG.color, FlxColor.fromString("0xFFEEFAD5"));
        sa2PosingShadow.alpha = 1;
        sa2Posing2Shadow.alpha = 1;
    }

    if (step == 3729) {
        FlxTween.color(fullScreenIntroBG, 1.5, fullScreenIntroBG.color, FlxColor.fromString("0xFF100410"));
        FlxTween.tween(sa2PosingShadow, {alpha: 0}, 1.5, {ease: FlxEase.quadIn});
        FlxTween.tween(sa2Posing2Shadow, {alpha: 0}, 1.5, {ease: FlxEase.quadIn});
    }
    if(curStep >= 4173 && !safetyNet5){
        runTimer('rewriteWindow', 0.04); // the timing is very precise,,,

        //cancelTween("sonicFallUp")
        //cancelTween("sonicFallDown")
        dad.y = dad.y -900;
        safetyNet5 = true;
    }
    if (step == 3768) {
        FlxTween.tween(sa2Posing, {x: 1280}, 0.25, {ease: FlxEase.quadIn});
        FlxTween.tween(sa2Posing2, {x: -1280}, 0.25, {ease: FlxEase.quadIn});
    }
    if (step == 3792){
        defaultCamZoom = 0.9;
        camGame.zoom = 0.9;
        boyfriend.alpha = 0;
        camGame.visible = true;
    }
    if (step == 3852){
        safteyNet3 = true;
        dad.y += 900;
        transColour.makeGraphic(2500, 2000, 0xFF131313);
        camGame.bgColor = 0xFF131313;
        transColour.alpha = 1;
    }
    if (step == 3772) {
    FlxTween.tween(ring, {alpha: 1}, 0.45, {ease: FlxEase.quadInOut});
    
    boyfriendRing.alpha = 1;
    FlxTween.tween(boyfriendRing, {y: 0}, 0.45, {ease: FlxEase.quadInOut});
    }

    if (curStep == 4640) {
        camHUD.alpha = 0;
        camNotes.alpha = 0;

        var screamer = iAmGodScreamer;
        screamer.setGraphicSize(1280, 720);
        screamer.x = 0;
        screamer.alpha = 1;

        FlxTween.color(screamer, 0.001, screamer.color, FlxColor.WHITE, {ease: FlxEase.linear});

        if (FlxG.save.data.flashingLights)
            runTimer("scarySonicColor1", 0.03);
    }


    if (step >= 3785 && step <= 3789) {
        transColour.makeGraphic(2500, 2000, FlxColor.BLACK);
        transColour.alpha = 1;
    }

    if (step == 3790) {
        new FlxTimer().start(0.05, function(tmr:FlxTimer) {
            // Your 'glitch1' logic here
        });
    }

    if (step == 3792) {
        camNotes.y = downscroll ? -720 : 720;

        defaultCamZoom = 0.9;
        camGame.zoom = 0.9;
        boyfriend.alpha = 0;
        camGame.visible = true;

        noteCheck = true;
        slowZoom(0.9, 0.01);
        dad.screenCenter(FlxAxes.X);

    }

    if (step >= 3920 && !safteyNet4){
        
        lyricsPlaceholder.alpha = 1;
        desktopRift.animation.play("desktopRift");
        desktopRiftMask.animation.play("desktopRiftMask");
        desktopRift.screenCenter(FlxAxes.X);
        desktopRift.screenCenter(FlxAxes.Y);
        desktopRiftMask.screenCenter();
        blackMask.alpha = 1;
        desktopRift.alpha = 1;
        desktopRiftMask.alpha = 1;
        redClouds.alpha = 1;

        if (shadersEnabled) {
            desktopRift.shader = glitchShader;
        }
        FlxTween.tween(camNotes, {y: 0}, 1.75, {ease: FlxEase.sineOut});

        FlxTween.tween(dad, {y: 200}, 0.75, {ease: FlxEase.sineOut});
        camLock = true;
        FlxTween.tween(rewriteCutscene, {y: -730}, 0.75, {ease: FlxEase.quadIn});

        safetyNet4 = true;

    }

    if (step == 2527) {
    internalBGBop = true;
    }

    if (step == 2528) {
        internalBG.alpha = 1;
        if (internalOverlay != null) internalOverlay.alpha = 0.7;
        internalGradient.alpha = 1;
    }

    if (internalBGBop && curStep % 2 == 0) {
        internalBGBeat += 1;
        if (internalBGBeat > 7) internalBGBeat = 0;

        internalBG.animation.play(internalBGBeat, true);

        if (internalFlipShiet) {
            internalFlipShiet = false;
            if (internalOverlay != null) internalOverlay.flipX = !internalOverlay.flipX;
        } else {
            internalFlipShiet = true;
            if (internalOverlay != null) internalOverlay.flipY = !internalOverlay.flipY;
        }
    }
    
}
function onTimerCompleted(tag:String, loops:Int = 0, loopsLeft:Int = 0) {
    if(tag == 'rewriteWindow'){
	/*for (i in 0...4) {
		noteTweenX('${i}mid', i + 4, FlxG.width / 3.5 + (140 * (i - 2)), 0.35, 'quadOut');
	}*/

	bfMask.alpha = 1;

	FlxTween.tween(bfMask, {x: -740}, 0.5, {ease: FlxEase.quadOut});
	FlxTween.tween(bfMask, {y: -165}, 0.5, {ease: FlxEase.quadOut});

	FlxTween.tween(windowBlack, {x: 650}, 0.5, {ease: FlxEase.quadOut});
	FlxTween.tween(windowBlack, {y: 200}, 0.5, {ease: FlxEase.quadOut});

	remove(windowVessel, true);
    rewriteWindowBox.animation.play("rewriteWindowBox", true);
	rewriteWindowBox.alpha = 1;

	FlxTween.tween(rewriteWindowBox, {x: 498}, 0.5, {ease: FlxEase.quadOut});
	FlxTween.tween(rewriteWindowBox, {y: 133}, 0.5, {ease: FlxEase.quadOut});
    }
    switch(tag){
        case "scarySonicColor0":
        var screamer = iAmGodScreamer;
        FlxTween.color(screamer, 0.001, screamer.color, FlxColor.WHITE);
        runTimer("scarySonicColor1", 0.03);

    case "scarySonicColor1":
        var screamer = iAmGodScreamer;
        FlxTween.color(screamer, 0.001, screamer.color, 0xFFBCBCBC); // light gray
        runTimer("scarySonicColor2", 0.03);

    case "scarySonicColor2":
        var screamer = iAmGodScreamer;
        FlxTween.color(screamer, 0.001, screamer.color, 0xFF969696); // darker gray
        runTimer("scarySonicColor0", 0.03);

    }
}
