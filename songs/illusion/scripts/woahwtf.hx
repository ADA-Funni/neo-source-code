import funkin.backend.shaders.CustomShader;

var glitch = new CustomShader(("glitch"));

function postCreate() {
	glitch.time = 0;
	glitch.glitchAmount = 0;

	if (FlxG.save.data.glitchy)
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
				var currentBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60));
				strum.setPosition((strumline.startingPos.x
					+ (Note.swagWidth * strumline.strumScale * (strumline.data.strumSpacing != null ? strumline.data.strumSpacing : 1) * i))
					+ 20 * Math.sin((currentBeat + i * 0.25) * Math.PI),
					strumline.startingPos.y
					+ 20 * Math.cos((currentBeat + i * 0.25) * Math.PI));
				strum.angle = 5 * Math.sin((currentBeat + i * 0.25) * Math.PI);
			}
		}
	}
}

function onDadHit(e) {
	if (health > 0.2)
		health -= 0.025 * FlxG.save.data.healthdrain;
}
