import hxvlc.flixel.FlxVideoSprite;
var end;
function create() {
    camera = vidCam = new FlxCamera();
    FlxG.cameras.add(vidCam, false);

    add(end = new FlxVideoSprite(200, 100)).load(Assets.getPath(Paths.video('endshucks')));
    end.bitmap.onEndReached.add(function() {
        end.visible = false;
        end.stop();
        end.destroy();
        end = null;
        FlxG.cameras.remove(vidCam);
        close();
    });
    end.scale.set(1.6,1.6);
    end.play();
}

function update() {
    if (controls.ACCEPT) {
        end.stop();
        end.destroy();
        FlxG.cameras.remove(vidCam);
        close();
    }
}