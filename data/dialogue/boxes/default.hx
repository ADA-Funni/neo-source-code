var gameChars:Array<Character> = [];

function postCreate():Void {
	var game:PlayState = PlayState.instance; if (game == null) return;
	if (PlayState.isStoryMode ? PlayState.storyWeek.songs[0].name != PlayState.SONG.meta.name : false) return;

	for (strumLine in game.strumLines)
		for (character in strumLine.characters)
			gameChars.push(character);

	for (char in gameChars)
		char.alpha = 0;
}

function destroy():Void {
	for (char in gameChars)
		FlxTween.tween(char, {alpha: 1}, 2, {ease: FlxEase.backOut});
}