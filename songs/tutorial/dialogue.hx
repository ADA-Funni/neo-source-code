function pauseMusic():Void
	curMusic?.pause();
function resumeMusic():Void
	curMusic?.resume();

var lineInt:Int = 0;
var dialogueLine:FlxSound;
function next(event):Void {
	lineInt++;
	trace(lineInt);
	if (dialogueLine != null) dialogueLine.stop();
	if (event.cancelled || !canProceed) return;

	var soundPath = Paths.sound('dialogue-lines/tutorial/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}
}