var lyricTxt;

function postCreate() {
    lyricTxt = add(new FunkinText(FlxG.width * 0.12, FlxG.height * 0.72, 0, "My Balls Itch", 25));
    lyricTxt.camera = camHUD;
}

function lyric(faggot:String = "My Balls Itch") {
    lyricTxt.text = faggot;
}