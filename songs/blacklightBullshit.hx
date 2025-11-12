import ColorHelp;

function new() {
	if (PlayState.variation != 'blacklight')
		disableScript();
}

function postCreate():Void {
	for (strumLine in strumLines) {
		for (character in strumLine.characters) {
			var colorTint = new ColorHelp(FlxColor.WHITE);
			colorTint.cyan = 0.15;
			character.color = colorTint.color;
		}
	}
}