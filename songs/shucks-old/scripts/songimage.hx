import flixel.math.FlxMath;
import flixel.util.FlxAxes;
var image:FlxSprite;
var songstart:Bool = false;
var songsend:Bool = false;
playCutscenes = true;

function onCountdown(e) {
    e.cancel();
}
function postCreate() {
    image = new FlxSprite(-999, -50).loadGraphic(Paths.image('songimage/' + PlayState.SONG.meta.name));
    image.cameras = [camHUD];
    image.scale.x = 0.6;
    image.scale.y = 0.6;
    insert(members.indexOf(iconP1), image);

}

function stepHit(curStep:Int){
    switch(curStep){
        case 768:
            FlxTween.tween(image , {x: -100}, 2, {ease: FlxEase.expoOut});
            new FlxTimer().start(3, function(tmr:FlxTimer)
                {
                    FlxTween.tween(image , {x: 1700}, 3, {ease: FlxEase.backInOut});
                });
    }
}
