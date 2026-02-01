function update(elapsed:Float):Void
	if (controls.ACCEPT && !dialogueBox.dialogueEnded && dialogueLine != null)
		dialogueLine.stop();

var lineInt:Int = 51;
var dialogueLine:FlxSound;
function next(event):Void {
	if (event.cancelled || !canProceed) return;
	lineInt++; trace(lineInt);

	var soundPath = Paths.sound('voicelines/post-blammed/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}

	// switch (lineInt) {}
}

function close(event):Void {
	if (event.cancelled) return;
	if (dialogueLine != null) dialogueLine.destroy();
}