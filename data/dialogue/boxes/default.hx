import flixel.util.FlxGradient;

var isStart:Bool = true;

function new() {
	var path = cutscene.dialoguePath.split('/');
	if (path[path.length - 1].split('-').length > 1)
		isStart = false;
}

var game:PlayState = PlayState.instance;
var bg:FunkinSprite;

function postCreate():Void {
	leftColor = game.dad != null && game.dad.iconColor != null && Options.colorHealthBar ? game.dad.iconColor : (game.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	rightColor = game.boyfriend != null && game.boyfriend.iconColor != null && Options.colorHealthBar ? game.boyfriend.iconColor : (game.opponentMode ? 0xFFFF0000 : 0xFF66FF33);

	if (game == null) return;
	if (isStart) game.camHUD.alpha = 0; else {
		FlxTween.tween(game.camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
		return;
	}
	if (PlayState.isStoryMode ? PlayState.storyWeek.songs[0].name != PlayState.SONG.meta.name : false) return;

	// bg = game.add(new FunkinSprite(0, 0, FlxGradient.createGradientBitmapData(FlxG.width, FlxG.height, [leftColor, rightColor])));
	// bg.scrollFactor.x = bg.scrollFactor.y = bg.zoomFactor = 0;
	// bg.alpha = 0.25;
}

var epicTimer:FlxTimer;

function destroy():Void {
	if (!isStart) return;
	// FlxTween.tween(bg, {alpha: 0}, 2, {ease: FlxEase.backOut});
	if (game != null) FlxTween.tween(game.camHUD, {alpha: 1}, 2, {ease: FlxEase.backOut});
}