var PARSE_ERROR:String = '[Parse Error --- Field Empty]';

function getCharterText():String {
	var general = PlayState.SONG?.meta?.customValues?.charter;
	var difficulty = Reflect.getProperty(PlayState.SONG?.meta?.customValues, 'charter_' + PlayState.difficulty);
	if (difficulty != null) return 'Charter (' + PlayState.difficulty + '): ' + difficulty;
	return 'Charter: ' + (general ?? PARSE_ERROR);
}

function postCreate():Void {
	var composerText = new FunkinText(20, 15, 0, 'Composer: ' + (PlayState.SONG?.meta?.customValues?.composer ?? PARSE_ERROR), 32, false);
	var charterText = new FunkinText(20, 15, 0, getCharterText(), 32, false);
	for(k => label in [composerText, charterText]) {
		if (label == null) continue;
		label.scrollFactor.set();
		label.alpha = 0;
		label.x = FlxG.width - (label.width + 20);
		label.y = 15 + (32 * (k + 4.3));
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k + 1)});
		add(label);
	}
}