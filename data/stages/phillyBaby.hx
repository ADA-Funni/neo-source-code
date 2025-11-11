function postUpdate(elapsed:Float):Void {
	fg.alpha = lerp(fg.alpha, camGame.zoom < 0.75 ? 1 : 0.3, 0.05);
}