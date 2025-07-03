import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
var lyricsShadow:FlxText;
var lyrics:FlxText;
var round2Lyrics:FlxSprite;
public var subtitleCam = new HudCamera();


function postCreate() {

	FlxG.cameras.add(subtitleCam = new HudCamera(), false);
    subtitleCam.bgColor = 0;
	// Lyrics Shadow
	lyricsShadow = new FlxText(3, 603, 1280, "");
	lyricsShadow.setFormat(Paths.font("sonic2HUD.ttf"), 6 * 8, 0xFF000000, FlxTextAlign.center);
	lyricsShadow.setBorderStyle(FlxTextBorderStyle.NONE);
	lyricsShadow.antialiasing = false;
	lyricsShadow.scrollFactor.set(0, 0);
	lyricsShadow.cameras = [subtitleCam];
	add(lyricsShadow);

	// Lyrics Main
	lyrics = new FlxText(0, 600, 1280, "");
	lyrics.setFormat(Paths.font("sonic2HUD.ttf"), 6 * 8, FlxColor.WHITE, FlxTextAlign.center);
	lyrics.setBorderStyle(FlxTextBorderStyle.NONE);
	lyrics.antialiasing = false;
	lyrics.scrollFactor.set(0, 0);
	lyrics.cameras = [subtitleCam];
	add(lyrics);

	// Downscroll reposition
	if (FlxG.save.data.downscroll) {
		lyrics.y = 90;
		lyricsShadow.y = 93;
	}

// Alternate positioning per song


// Animated Lyrics for "Trinity"
    round2Lyrics = new FlxSprite(0, 0);
    round2Lyrics.frames = Paths.getSparrowAtlas("round2Lyrics");
    round2Lyrics.animation.addByPrefix("THATS", "1thats", 1, false);
    round2Lyrics.animation.addByPrefix("WHY", "2why", 1, false);
    round2Lyrics.animation.addByPrefix("THIS", "3this", 1, false);
    round2Lyrics.animation.addByPrefix("IS", "4is", 1, false);
    round2Lyrics.animation.addByPrefix("ROUND", "5round", 1, false);
    round2Lyrics.animation.addByPrefix("ROUND2", "6round2", 1, false);
    round2Lyrics.animation.play("THATS");
    round2Lyrics.antialiasing = false;
    round2Lyrics.setGraphicSize(round2Lyrics.width * 3);
    round2Lyrics.updateHitbox();
    round2Lyrics.cameras = [subtitleCam];
    round2Lyrics.visible = false;
    add(round2Lyrics);
}

function onEvent(event)
{
	if(event.event.name != "Lyrics") return;

	var value1 = event.event.params[0];
    var value2 = event.event.params[1];
    if (event.event.name == 'Lyrics')
    {
		trace('HI IM LYRICS ' + value1 + ' V1'); // Debugging
        lyrics.text = lyricsShadow.text = value1;
		//lyrics.screenCenter(FlxAxes.X);
		subtitleCam.x = 0;
		subtitleCam.y = 0;
		subtitleCam.visible = true;
		subtitleCam.alpha = 1;

            if (value2 == '' || value2 == ' ')
                round2Lyrics.visible = false;
            else
            {
                round2Lyrics.visible = true;
                round2Lyrics.animation.play(value2.toUpperCase());
				
				//playAnim("round2Lyrics", value2.toUpperCase(), true, false, 0);
            }

        if (value1 == 's') // special case for "Trinity Legacy" end lyric alignment
        {
            lyrics.y = 370;
            lyricsShadow.y = 373;
        }
    }
}
function update(elapsed:Float) {
	subtitleCam.x = camVideo.x;
	subtitleCam.y = camVideo.y;
	subtitleCam.width = camVideo.width;
	subtitleCam.height = camVideo.height;
	subtitleCam.zoom = camVideo.zoom;
}
function stepHit(step:Int)
{
    if (step == 4432)
    {
        if (FlxG.save.data.downscroll)
        {
            lyrics.text = "";
            lyricsShadow.text = "";
        }
    }
}