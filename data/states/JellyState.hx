import hxvlc.flixel.FlxVideoSprite;

function create() {
    FlxG.sound.music.stop();
    
    var video = new FlxVideoSprite(0, 0);
    video.antialiasing = true;
    video.bitmap.onEndReached.add(() -> {
        video.destroy();
		FlxG.switchState(new MainMenuState());
    });
    video.load(Paths.video("jelly"));
    video.play();
    add(video);
}