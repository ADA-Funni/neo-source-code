var glitch = new CustomShader("glitch");

function postCreate() {
	glitch.time = 0;
	glitch.glitchAmount = 0;

	if (FlxG.save.data.glitchy && Options.gameplayShaders)
		for (cam in [camGame, camHUD])
			cam.addShader(glitch);
}

function update(elapsed) {
	glitch.time += elapsed;
	glitch.glitchAmount = lerp(glitch.glitchAmount, (1 - (health / maxHealth)) * FlxG.save.data.glitchyvalue, 0.15);

	iconP2.angle = FlxG.random.float(-glitch.glitchAmount * 3.5, glitch.glitchAmount * 3.5);

	if (FlxG.save.data.kadedev) {
		for (strumline in strumLines.members) { // Kade Strum Movement  Very Poorly Ported Too CNE
			for (i => strum in strumline.members) {
				strum.setPosition(
					(strumline.startingPos.x + (Note.swagWidth * strumline.strumScale * (strumline.data.strumSpacing != null ? strumline.data.strumSpacing : 1) * i)) + strum.getScrollSpeed() * 8 * Math.sin((Conductor.curBeatFloat + i * 0.25) * Math.PI),
					strumline.startingPos.y + strum.getScrollSpeed() * 8 * Math.cos((Conductor.curBeatFloat + i * 0.25) * Math.PI)
				);
				strum.angle = strum.getScrollSpeed() * 2 * Math.sin((Conductor.curBeatFloat + i * 0.25) * Math.PI);
			}
		}
	}
}