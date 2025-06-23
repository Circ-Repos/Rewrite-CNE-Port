import flixel.FlxCamera;
import states.PlayState;

function onStepHit()
{
    switch (curStep)
    {
        case 2835:
            FlxG.camera.alpha = 1;
            for (i in ["remixBG", "trippyBG", "remixBGInvert", "trippyBGInvert"]) if (game.getLuaObject(i) != null) game.getLuaObject(i).cameras = [game.camFX];

        case 2800:
            if (game.getLuaObject('bg') != null) game.getLuaObject('bg').cameras = [game.camFX];

        case 2836:
            if (ClientPrefs.data.shaders && game.getLuaObject('fisheyeShader') != null) game.camFX.setFilters([new ShaderFilter(game.getLuaObject('fisheyeShader').shader)]);
    }
}

function onUpdatePost(e) {
    game.camFX.x = FlxG.camera.x;
    game.camFX.y = FlxG.camera.y;
    game.camFX.width = FlxG.camera.width;
    game.camFX.height = FlxG.camera.height;
    game.camFX.zoom = FlxG.camera.zoom;
    game.camFX.angle = FlxG.camera.angle;
    game.camFX.alpha = FlxG.camera.alpha;
}


function onDestroy() {}