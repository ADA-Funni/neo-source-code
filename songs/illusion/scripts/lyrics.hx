var lyricTxt;

function postCreate() {
    lyricTxt = add(new FunkinText(FlxG.width * 0.12, FlxG.height * 0.72, 0, "...", 25));
    lyricTxt.camera = FlxG.cameras.add(new FlxCamera(), false);
    lyricTxt.camera.bgColor = 0xFF;
}

function lyric(faggot:String = "My Balls Itch") {
    lyricTxt.text = faggot;
}

function onDadHit(e) {
    lyricTxt.color = FlxColor.RED;
    FlxTween.cancelTweensOf(lyricTxt);
    FlxTween.color(lyricTxt, 1, lyricTxt.color, FlxColor.WHITE, {startDelay: 0.2});

    lyricTxt.camera.shake(0.005, 0.2);
}