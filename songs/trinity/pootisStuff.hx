import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxCamera;
import backend.Conductor;
import Main;

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

var defaultColors:Array = ClientPrefs.data.arrowRGB;

var fnfColors:Array = [
    [0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
    [0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
    [0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
    [0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
];

var internalColors:Array = [
    [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF],
    [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF],
    [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF],
    [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF]
];

function onCreate()
{
	FlxG.autoPause = false;

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
        i.bitmap.rate = game.playbackRate;
        i.alpha = 0.001;
        i.cameras = [i == majinVideo ? game.camOther : game.camVideo];
        game.add(i);
    }

    //PlayState.checkpointTime = 135000; // legacy
    //PlayState.checkpointTime = 277500; // rewrite

    Paths.image("noteSkins/internalX_Notes");
    Paths.image("noteSkins/NOTE_assets-FNF");
    Paths.image("noteSkins/NOTE_assets");

    Main.fpsVar.defaultColor = 0xFFFFFFFF;
}

function onCreatePost()
{
    for (i in videoArray)
    {
        i.play(); // This fixes a visual issue where the video doesnt play until a little bit after it should
		new FlxTimer().start(0.0001, function(tmr) {
			i.pause();
            i.bitmap.time = 0;
		});
    }

    FlxG.autoPause = true;
}

function swapNoteskin(tex)
{
    if (ClientPrefs.data.lowQuality) return;

    for (i in game.strumLineNotes) i.texture = "noteSkins/" + tex;
    texture = tex;

    switch (tex)
    {
        case "NOTE_assets":
            for (i in game.strumLineNotes) {
                i.rgbShader.r = defaultColors[i.noteData][0];
                i.rgbShader.g = defaultColors[i.noteData][1];
                i.rgbShader.b = defaultColors[i.noteData][2];
            }

        case "internalX_Notes":
            for (i in game.strumLineNotes) {
                i.rgbShader.r = internalColors[i.noteData][0];
                i.rgbShader.g = internalColors[i.noteData][1];
                i.rgbShader.b = internalColors[i.noteData][2];
            }
    }
}

function onSpawnNote(n) {
    if (texture != "NOTE_assets" && !ClientPrefs.data.lowQuality) {
        n.texture = "noteSkins/" + texture;

        switch (texture)
        {
            case "NOTE_assets-FNF":
                n.rgbShader.r = fnfColors[n.noteData][0];
                n.rgbShader.g = fnfColors[n.noteData][1];
                n.rgbShader.b = fnfColors[n.noteData][2];

            case "internalX_Notes":
                n.rgbShader.r = internalColors[n.noteData][0];
                n.rgbShader.g = internalColors[n.noteData][1];
                n.rgbShader.b = internalColors[n.noteData][2];

            default: // do nothing
        }
    }
}

function onSongStart() {
    game.getLuaObject("transColour").cameras = [game.camFX];
    game.getLuaObject("transColour").scale.set(2000, 2000);
}

function onStepHit()
{
    switch (curStep)
    {
        case 208:
            if (majinVideo != null) majinVideo.destroy(); //majins video is very inconsistent, sometimes it ends properly, sometimes it cuts away early, im fucking sick of it, lol
            FlxG.camera.alpha = 1;

        case 2507, 3920: if (ClientPrefs.data.shaders) game.camFX.setFilters([new ShaderFilter(game.getLuaObject('fisheyeShader').shader)]);

        case 2912: Main.fpsVar.defaultColor = 0xFF000000;
        case 3568: Main.fpsVar.defaultColor = 0xFFFFFFFF;

        case 3919:
            for (i in ["redClouds", "blackMask", "transColour", "fleshBG", "trippyBG", "lalalaBackground"])
                if (game.getLuaObject(i) != null) game.getLuaObject(i).cameras = [game.camFX];
    }
}

function onPause() {
    for (i in videoArray)
        if (i != null && i.alpha == 1) i.pause();
}

function onResume() {
    for (i in videoArray)
        if (i != null && i.alpha == 1) i.resume();
}

function onFocusLost() {
    for (i in videoArray)
        if (i != null && i.alpha == 1) i.pause();
}

function onFocus() {
    if (!game.paused) {
        for (i in videoArray)
            if (i != null && i.alpha == 1) i.resume();
    }
}

function onUpdatePost(e) { // snow was having issues with the videos not centering
    for (i in videoArray) if (i.alpha == 1) i.screenCenter();

    game.camFX.x = FlxG.camera.x;
    game.camFX.y = FlxG.camera.y;
    game.camFX.width = FlxG.camera.width;
    game.camFX.height = FlxG.camera.height;
    game.camFX.zoom = FlxG.camera.zoom;
    game.camFX.angle = FlxG.camera.angle;

    // safety net bullshit thank you snow for the idea
    if (videosToDestroy.length > 0) for (i in videosToDestroy) if (i != null) i.destroy();
}

function onEvent(e, v1, v2, sT) 
{
    switch (e)
    {
        case "majin": playVideo(majinVideo, 20.00, sT); //20.00

        case "xscene": playVideo(xVideo, 18.05, sT); //18.05

        case "fusion": playVideo(fusionVideo, 25.45, sT); // 25.45

        case "lxscene": playVideo(lxVideo, 18.00, sT); // 18.00

        case "setNoteskin": swapNoteskin(v1);
    }
}

function playVideo(vid:FlxVideoSprite, endTime:Float, strumTime:Float)
{
    if (strumTime < PlayState.checkpointTime) return;

    vid.screenCenter();
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.resume();
    vid.offset.x = -230;

    if (vid == majinVideo) {
        new FlxTimer().start(0.1 / game.playbackRate, function(tmr) {
            game.camHUD.alpha = 1;
        });
    }

    new FlxTimer().start(endTime / game.playbackRate, function(tmr) {
        vid.alpha = 0.001;
        if (vid == majinVideo) FlxG.camera.alpha = 1;
        videosToDestroy.push(vid);
    });

    if (vid == lxVideo) game.camVideo.flash(0xFF000000, 1);
}

function onGameOver() {
    Main.fpsVar.defaultColor = 0xFFFFFFFF;
    return;
}

function onDestroy() {
    for (i in videoArray) if (i != null) i.destroy();
    Main.fpsVar.defaultColor = 0xFFFFFFFF;
}