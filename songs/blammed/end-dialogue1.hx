var highest:Int = 0;
var preventSkip = false;
function update(elapsed:Float):Void {
	if (!preventSkip && controls.ACCEPT && !dialogueBox.dialogueEnded && dialogueLine != null)
		dialogueLine.stop();
	if (FlxG.keys.justPressed.TAB) {
		// leaving this here because 1) why not 2) it's funny 3) its really neat to spam this and see the results lol
		var chance:Bool = false;
		var tries:Int = 0;
		while (!chance) {
			tries++;
			chance = FlxG.random.bool(5);
		}
		highest = Math.max(highest, tries);
		trace('Tries: ' + tries + ', Highest: ' + highest); // highest on 5% out of 100 is 92 tries lol
	}
}

var lineInt:Int = 0;
var dialogueLine:FlxSound;
function next(event):Void {
	if (event.cancelled || !canProceed) return;
	lineInt++; trace(lineInt);

	var soundPath = Paths.sound('voicelines/post-blammed/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}

	switch (lineInt) {
		case 6 | 9: dialogueLine.onComplete = () -> this.next();
		case 11: dialogueLine.onComplete = () -> FlxG.sound.play(Paths.sound('he-needs-some-milk-vine'), 0.015);
		case 14:
			if (FlxG.random.bool(5)) { // RODNEY HERE, I GOT THIS SHIT FIRST TRY, WTF!??!?!?!?
				trace(':)');
				preventSkip = true;
				new FlxTimer().start(0.01, () -> canProceed = false);
				dialogueLine.onComplete = () -> {
					curMusic?.pause();
					var state = new ModSubState('BlammedDeathFakeOut');
					state.closeCallback = () -> {
						curMusic?.resume();
						canProceed = true;
						preventSkip = false;
						this.next();
					}
					openSubState(state);
				}
			} else dialogueLine.onComplete = () -> FlxG.sound.play(Paths.sound('pew'), 0.015);
	}
}

function close(event):Void {
	if (event.cancelled) return;
	if (dialogueLine != null) dialogueLine.destroy();
}