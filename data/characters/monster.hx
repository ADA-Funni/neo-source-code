function onNoteHit(event) {
	if (event.characters.contains(this) && event.note.strumLine.cpu && PlayState.instance.health > 0.2)
		event.healthGain = 0.025 * FlxG.save.data.healthdrain;
}