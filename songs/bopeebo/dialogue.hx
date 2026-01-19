function pauseMusic():Void
	curMusic?.pause();
function resumeMusic():Void
	curMusic?.resume();

function update(elapsed:Float):Void
	if (controls.ACCEPT && !dialogueBox.dialogueEnded && dialogueLine != null)
		dialogueLine.stop();

var lineInt:Int = 0;
var dialogueLine:FlxSound;
function next(event):Void {
	if (event.cancelled || !canProceed) return;
	lineInt++; trace(lineInt);

	var soundPath = Paths.sound('voicelines/bopeebo/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}

	switch (lineInt) {
		case 7: dialogueLine.onComplete = () -> FlxG.sound.play(Paths.sound('gay'));
		case 18: dialogueLine.onComplete = () -> this.next();
	}
}

function close(event):Void {
	if (event.cancelled) return;
	if (dialogueLine != null) dialogueLine.destroy();
}