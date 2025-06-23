var lolZoom:Bool = false;

var cameraBopMultiplier:Float = 1.0;

var zoomTween:FlxTween;

var defaultZoom:Float = 0;

function create(){
    defaultZoom = defaultCamZoom;
}

function onNoteHit(event){
    event.enableCamZooming = false;
}

function update(){
    cameraBopMultiplier = lerp(cameraBopMultiplier, 1, camGameZoomLerp);
    var zoomPlusBop = defaultCamZoom * cameraBopMultiplier;
    FlxG.camera.zoom = zoomPlusBop;

    camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, camHUDZoomLerp);
}

function beatHit(){
    if (Options.camZoomOnBeat && curBeat % camZoomingInterval == 0){
        cameraBopMultiplier += 0.015 * camZoomingStrength;
        camHUD.zoom += 0.03 * camZoomingStrength;
    }
}

function onEvent(_) {
    if (_.event.name == 'ZoomCamera') {
        var zoomAmount = _.event.params[0];
        var tweenTime = _.event.params[1];
        var tweenType = _.event.params[2];
        var zoomType = _.event.params[3];
        var durTypes = _.event.params[4];

        switch(zoomType){
            case 'stage': lolZoom = true;
            case 'direct': lolZoom = false;
        }

        targetCameraZoom = zoomAmount * (lolZoom ? defaultZoom : 1);

        if(zoomTween != null) zoomTween.cancel();
        switch(tweenType.toUpperCase()){
            case "CLASSIC": zoomTween = FlxTween.tween(this, {defaultCamZoom: targetCameraZoom}, 2.1, {ease: FlxEase.expoOut});
            case "INSTANT": defaultCamZoom = targetCameraZoom; //using defaultCamZoom until i can rework the camera ig :sob:
            default:
                if(durTypes == null){
                    zoomTween = FlxTween.tween(this, {defaultCamZoom: targetCameraZoom}, (Conductor.stepCrochet / 1000) * tweenTime, {ease: Reflect.field(FlxEase, tweenType)});
                } else {
                    switch(durTypes){
                        case 'seconds': zoomTween = FlxTween.tween(this, {defaultCamZoom: targetCameraZoom}, tweenTime, {ease: Reflect.field(FlxEase, tweenType)});
                        case 'steps': zoomTween = FlxTween.tween(this, {defaultCamZoom: targetCameraZoom}, (Conductor.stepCrochet / 1000) * tweenTime, {ease: Reflect.field(FlxEase, tweenType)});
                    }
                }
        }
    }
}