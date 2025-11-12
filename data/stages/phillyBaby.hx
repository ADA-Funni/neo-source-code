// I SWEAR TO GOT I WISH I COULD PUT THESE TWO FUNCTIONS BELOW IN A SONG SCRIPT
function onStageNodeParsed(event):Void {
	var isPhillyLightAsset:Bool = false;
	if (event.node.attributeMap.exists('phillyLightAsset'))
		isPhillyLightAsset = event.node.attributeMap.get('phillyLightAsset') == 'true';
	if (event.sprite != null && event.sprite.extra != null)
		event.sprite.extra.set('phillyLightAsset', isPhillyLightAsset);
}
function postCreate():Void {
	for (element in stage.stageSprites)
		if (element.extra.get('phillyLightAsset'))
			element.visible = false;
}

function postUpdate(elapsed:Float):Void {
	if (!Options.lowMemoryMode)
		fg_light.alpha = fg.alpha = lerp(fg.alpha, camGame.zoom < 0.75 ? 1 : 0.3, 0.05);
}