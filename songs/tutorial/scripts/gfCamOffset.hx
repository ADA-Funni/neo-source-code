function postCreate():Void
	for (character in cpu.characters)
		character.cameraOffset.x += 150;