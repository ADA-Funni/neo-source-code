var darkBoyfriend:Character;
function postCreate():Void {
	darkBoyfriend = player.characters[1];
	darkBoyfriend.x = boyfriend.x;
	darkBoyfriend.visible = false;
}

function blackOut(activate:String):Void {
	var ye:Bool = activate == 'true';
	darkBoyfriend.visible = ye;
	boyfriend.visible = cpu.visible = hideHUD(!ye);
	var color = ye ? 0xff151515 : FlxColor.WHITE;
	for (element in stage.stageSprites)
		element.color = color;
	dad.color = gf.color = color;
}

function moveStrumLine(center):Void {
	if (center == 'true')
		for (i in player)
			i.x -= (FlxG.width / 4);
	else
		for (i in player)
			i.x += (FlxG.width / 4);
}

function onNoteHit(event):Void
	if (event.characters.contains(darkBoyfriend))
		darkBoyfriend.color = [FlxColor.MAGENTA, 0xFFF170F8, 0xFF3D5A9E, FlxColor.CYAN][event.direction];