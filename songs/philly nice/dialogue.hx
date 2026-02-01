import hxvlc.flixel.FlxVideoSprite;

var preventSkip = false;
var video:FlxVideoSprite;
function postCreate():Void {
	video = new FlxVideoSprite();
	video.autoPause = false;
	video.load(Paths.video('wait a minute'));
	video.bitmap.onFormatSetup.add(() -> if (video.bitmap != null && video.bitmap.bitmapData != null) {
		var width = video.bitmap.bitmapData.width; var height = video.bitmap.bitmapData.height;
		var scale:Float = Math.min(FlxG.width / width, FlxG.height / height);
		video.setGraphicSize(Std.int(width * scale), Std.int(height * scale));
		video.updateHitbox();
		video.screenCenter();
	});
	video.bitmap.onEndReached.add(() -> {
		video.visible = false;
		curMusic?.resume();
		canProceed = true;
		this.next();
		preventSkip = false;
	});
	video.play();
	video.pause();
	video.antialiasing = true;
	add(video);
}

function pauseMusic():Void
	curMusic?.pause();
function resumeMusic():Void
	curMusic?.resume();

function update(elapsed:Float):Void
	if (!preventSkip && controls.ACCEPT && !dialogueBox.dialogueEnded && dialogueLine != null)
		dialogueLine.stop();

var lineInt:Int = 0;
var dialogueLine:FlxSound;
function next(event):Void {
	if (event.cancelled || !canProceed) return;
	lineInt++; trace(lineInt);

	var soundPath = Paths.sound('voicelines/philly-nice/' + lineInt);
	if (Assets.exists(soundPath)) {
		dialogueLine = FlxG.sound.play(soundPath);
		dialogueLine.autoDestroy = false;
	}

	switch (lineInt) {
		case 4:
			preventSkip = true;
			new FlxTimer().start(0.01, () -> canProceed = false);
			dialogueLine.onComplete = () -> {
				if (FlxG.autoPause) {
					FlxG.signals.focusGained.add(video.resume);
					FlxG.signals.focusLost.add(video.pause);
				}
				curMusic?.pause();
				video.resume();
			}
	}
}

function close(event):Void {
	if (event.cancelled) return;
	if (dialogueLine != null) dialogueLine.destroy();
}