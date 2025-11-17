import hxvlc.flixel.FlxVideoSprite;

function create() {
    FlxG.sound.music.stop();

    var video = new FlxVideoSprite(0, 0);
    video.antialiasing = true;
    video.bitmap.onEndReached.add(() -> {
        video.destroy();
        FlxG.save.data.neoFirstTime = false;
		FlxG.switchState(new TitleState());
    });
    video.load(Paths.video("welcome"));
    video.play();
    add(video);
}