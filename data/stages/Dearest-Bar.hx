import utils.ColorHelp;

// I SWEAR TO GOT I WISH I COULD PUT THESE TWO FUNCTIONS BELOW IN A SONG SCRIPT
function onStageNodeParsed(event):Void {
	if (PlayState.variation != 'blacklight') return;
	var hasBlacklightTint:Bool = false;
	if (event.node.attributeMap.exists('blacklightTint'))
		hasBlacklightTint = event.node.attributeMap.get('blacklightTint') == 'true';
	if (event.sprite.extra != null)
		event.sprite.extra.set('blacklightTint', hasBlacklightTint);
}
function postCreate():Void {
	if (PlayState.variation == 'blacklight')
		for (element in stage.stageSprites)
			if (element.extra.get('blacklightTint')) {
				var colorTint = new ColorHelp(FlxColor.WHITE);
				colorTint.magenta = 0.15;
				element.color = colorTint.color;
			}
	Crowd.visible = SONG.meta.name == "dadbattle";
}