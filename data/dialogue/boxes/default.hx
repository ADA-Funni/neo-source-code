var isStart:Bool = true;

function new() {
	var path = cutscene.dialoguePath.split('/');
	if (path[path.length - 1].split('-').length > 1)
		isStart = false;
}

var gameChars:Array<Character> = [];
var game:PlayState = PlayState.instance;

function postCreate():Void {
	if (game == null) return;
	if (isStart) game.camHUD.alpha = 0; else {
		FlxTween.tween(game.camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
		return;
	}
	if (PlayState.isStoryMode ? PlayState.storyWeek.songs[0].name != PlayState.SONG.meta.name : false) return;

	for (strumLine in game.strumLines)
		for (character in strumLine.characters)
			gameChars.push(character);

	for (char in gameChars)
		char.alpha = 0;
}

function destroy():Void {
	if (!isStart) return;
	if (game != null) FlxTween.tween(game.camHUD, {alpha: 1}, 2, {ease: FlxEase.backOut});
	for (char in gameChars)
		FlxTween.tween(char, {alpha: 1}, 2, {ease: FlxEase.backOut});
}