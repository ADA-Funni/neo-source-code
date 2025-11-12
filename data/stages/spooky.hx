import utils.ColorHelp;

// I SWEAR TO GOT I WISH I COULD PUT THESE TWO FUNCTIONS BELOW IN A SONG SCRIPT
function onStageNodeParsed(event):Void {
	if (PlayState.variation != 'blacklight') return;
	var hasBlacklightTint:Bool = false;
	if (event.node.attributeMap.exists('blacklightTint'))
		hasBlacklightTint = event.node.attributeMap.get('blacklightTint') == 'true';
	if (event.sprite != null && event.sprite.extra != null)
		event.sprite.extra.set('blacklightTint', hasBlacklightTint);
}
var crowdYDefault:Float = 0;
function postCreate():Void {
	if (PlayState.variation == 'blacklight')
		for (element in stage.stageSprites)
			if (element.extra.get('blacklightTint')) {
				var colorTint = new ColorHelp(FlxColor.WHITE);
				colorTint.magenta = 0.15;
				element.color = colorTint.color;
			}
	if (!Options.lowMemoryMode)
		crowdYDefault = crowd.y;
}

function postUpdate(elapsed:Float):Void {
	if (!Options.lowMemoryMode) {
		crowd.y = lerp(crowd.y, crowdYDefault, 0.12);
		crowd.angle = lerp(crowd.angle, 0, 0.12);
	}
}

var danceLeft:Bool = true;
function beatHit(curBeat:Int):Void {
	if (!Options.lowMemoryMode && curBeat % 4 == 0) {
		danceLeft = !danceLeft;
		crowd.y += 30;
		crowd.angle = danceLeft ? 0.5 : -0.5;
	}
}