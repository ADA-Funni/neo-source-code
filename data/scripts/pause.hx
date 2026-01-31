// script by @rodney528

var PARSE_ERROR:String = '[Parse Error --- Field Empty]';

function getCharterText():String {
	var general = PlayState.SONG?.meta?.customValues?.charter ?? PARSE_ERROR;
	var difficulty = Reflect.getProperty(PlayState.SONG?.meta?.customValues, 'charter_' + PlayState.difficulty);
	return 'Charter: ' + (difficulty ?? general);
}

function postCreate():Void {
	var composerText = new FunkinText(20, 15, 0, 'Composer: ' + (PlayState.SONG?.meta?.customValues?.composer ?? PARSE_ERROR), 32, false);
	if (composerText.text == PARSE_ERROR) composerText.visible = false;
	var charterText = new FunkinText(20, 15, 0, getCharterText(), 32, false);
	if (charterText.text == PARSE_ERROR) charterText.visible = false;
	for(k => label in [composerText, charterText]) {
		if (label == null) continue;
		add(label); if (!label.visible) continue;
		label.scrollFactor.set();
		label.alpha = 0;
		label.x = FlxG.width - (label.width + 20);
		label.y = 15 + (32 * (k + 4.3));
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k + 1)});
	}
	deathCounter.text = 'Deaths: ' + PlayState.deathCounter;
	deathCounter.x = FlxG.width - (deathCounter.width + 20);
}