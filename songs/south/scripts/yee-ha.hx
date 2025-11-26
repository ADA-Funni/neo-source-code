import funkin.backend.system.BeatType;

// failed trying to make it match a bass in the bg 😭 @KittySleeper you frickin' try doing this
function funnyBops(backItUp):Void {
	var backup:Bool = backItUp == 'true';
	camZoomingOffset = backup ? -1 : 0;
	camZoomingEvery = backup ? BeatType.Step : BeatType.Beat;
	camZoomingInterval = backup ? 3 : 1;
}

var canEnd:Bool = !playCutscenes;

function onSongEnd(event):Void {
	if (!canEnd) event.cancel(); else return;

	// this is why it starts with "post" instead lol
	startCutscene("post-", endCutscene, () -> {
		camGame.visible = camHUD.visible = false;
		var sound = FlxG.sound.play(Paths.sound('Lights_Shut_off'), 0.7);
		sound.onComplete = () -> {
			canEnd = true;
			endSong();
		}
	}, false, false);
}