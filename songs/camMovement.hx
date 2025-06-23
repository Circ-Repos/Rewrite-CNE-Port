var camMove:Bool = true;

var rate = 25;

import flixel.camera.FlxCameraFollowStyle;

var timeAmount:Float = 0.35;
var lockOnSpeed:Float = 0.07;

var returnTimer = new FlxTimer();

function onNoteHit(_) {
    if(camMove){
        if(_.player){
            if(curCameraTarget != 0) {
                if(returnTimer != null) returnTimer.cancel();
                returnTimer = new FlxTimer().start(timeAmount, function(timer) FlxG.camera.targetOffset.set(0, 0));
                moveCameraOnNotes(_.direction);
            }
        }
        if(!_.player){
            if(curCameraTarget == 0) {
                if(returnTimer != null) returnTimer.cancel();
                returnTimer = new FlxTimer().start(timeAmount, function(timer) FlxG.camera.targetOffset.set(0, 0));
                moveCameraOnNotes(_.direction);
            }
        }
    }

}

function moveCameraOnNotes(noteDirection) {
    switch(noteDirection){
        case 0: FlxG.camera.targetOffset.set(0 - rate, 0);
        case 1: FlxG.camera.targetOffset.set(0, 0 + rate);
        case 2: FlxG.camera.targetOffset.set(0, 0 - rate);
        case 3: FlxG.camera.targetOffset.set(0 + rate, 0);
    }
}
function postUpdate(elapsed:Float) {
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.06);
}