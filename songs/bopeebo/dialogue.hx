function pauseMusic():Void
	curMusic?.pause();
function resumeMusic():Void
	curMusic?.resume();

function update(elapsed:Float):Void {
	if (dialogueBox.dialogueEnded && curLine?.text == 'I only kneel before my wife.')
		this.next();
}

function next(event):Void {
	if (dialogueLines[1]?.text == 'I only kneel before my wife.' && !dialogueBox.dialogueEnded)
		event.cancelled();
}