introLength = 1;
function onCountdown(event):Void
	event.cancel();

var hehehaha:FunkinSprite;
function postCreate():Void {
	hehehaha = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
	hehehaha.scrollFactor.set();
	hehehaha.zoomFactor = 0;
	add(hehehaha);
	camHUD.visible = false;
}

function onStartSong():Void
	camHUD.visible = true;

function I_CANT_SEE():Void {
	FlxTween.tween(hehehaha, {alpha: 0}, Conductor.stepCrochet / 1000 * (16 * 2));
}

function oknowicantsee() {
	FlxTween.tween(hehehaha, {alpha: 1}, Conductor.stepCrochet / 1000 * 19);
	FlxTween.tween(camHUD, {alpha: 0}, Conductor.stepCrochet / 1000 * 19);
}