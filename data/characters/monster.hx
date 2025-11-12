function onNoteHit(event) {
	// works with opponent play ig
	if (PlayState.instance != null && event.note.strumLine.cpu && event.characters.contains(this)) {
		var healthBar:Float = PlayState.instance.healthBar;
		var healthPercent:Float = healthBar.percent;
		if (!event.note.strumLine.opponentSide)
			healthPercent = (healthPercent - 100) * -1;

		if (healthPercent > 10 * FlxG.save.data.healthdrain)
			event.healthGain = 0.025 * FlxG.save.data.healthdrain;
	}
}