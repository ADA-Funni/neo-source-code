import funkin.backend.system.BeatType;

// failed trying to make it match a bass in the bg 😭 @KittySleeper you frickin' try doing this
function funnyBops(backItUp):Void {
	var backup:Bool = backItUp == 'true';
	camZoomingOffset = backup ? -1 : 0;
	camZoomingEvery = backup ? BeatType.Step : BeatType.Beat;
	camZoomingInterval = backup ? 3 : 1;
}