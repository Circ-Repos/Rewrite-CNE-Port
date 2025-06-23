import funkin.backend.system.Logs;

// script name (without extension)
var __name__ = __script__.fileName.substring(0, __script__.fileName.lastIndexOf('.'));

function onNoteCreation(e) {
	if (e.noteType != __name__) return;
	e.noteSprite = 'game/notes/' + __name__;
	e.noteScale = 0.73;
	e.mustHit = true;
	e.note.updateHitbox();
}

var st:FlxSprite;
var ringSound:FlxSound;
var hitStaticSound:FlxSound;
var shake = false;

function postCreate() {
	st = new FlxSprite();
	st.frames = Paths.getFrames('game/hitStatic');
	st.camera = camHUD;
	st.animation.addByPrefix('idle', 'staticANIMATION', 24, false);
	st.animation.play('idle');
	st.visible = false;
	add(st);

	ringSound = new FlxSound().loadEmbedded(Paths.sound('ring'));
	ringSound.volume = .7;
	FlxG.sound.list.add(ringSound);

	hitStaticSound = new FlxSound().loadEmbedded(Paths.sound('hitStatic'));
	FlxG.sound.list.add(hitStaticSound);
}

function onPlayerMiss(event) {
	if (event.noteType == __name__) {
		if (curSong != 'black-sun')
			health -= .3;

		Logs.trace('lol you missed the static note!', 0, 13);

		ringSound.play();
		hitStaticSound.play();

		shake = true;
		new FlxTimer().start(0.8, tmr -> shake = false);

		st.visible = true;
		st.animation.play('idle');
		new FlxTimer().start(.38, tmr -> st.visible = false);
	}
}

function postUpdate(elapsed:Float) {
	if (shake)
		FlxG.camera.shake(0.0025, 0.1);
}

function stepHit(curStep) {
	// idk it was in source
	if (curStep == 791 && PlayState.SONG.meta.name == 'Too Slow (Legacy)' && dad.curCharacter == 'v1_sonicexe')
		shake = false;
}