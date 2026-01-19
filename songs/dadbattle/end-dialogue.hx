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

	var soundPath = Paths.sound('voicelines/post-dadbattle/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}
}

function close(event):Void {
	if (event.cancelled) return;
	if (dialogueLine != null) dialogueLine.destroy();
}