function create():Void {
	startDialogue(
		Paths.file('songs/blammed/end-dialogue1.xml'),
		() -> {
			var cam:FlxCamera = new FlxCamera();
			cam.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.add(cam, false);

			var bgSpr = new FlxSprite(0, -cam.height).makeGraphic(1, 1, FlxColor.BLACK); add(bgSpr).cameras = [cam];
			bgSpr.scale.set(cam.width, cam.height);
			bgSpr.updateHitbox();

			var spr:FunkinSprite = new FunkinSprite(0, 0, Paths.image('menus/transitionSpr')); add(spr).cameras = [cam];
			spr.setGraphicSize(cam.width, cam.height);
			spr.updateHitbox();
			cam.scroll.y = cam.height;
			FlxTween.tween(cam.scroll, {y: -cam.height}, 2 / 3, {
				ease: FlxEase.sineOut,
				onComplete: () ->
					new FlxTimer().start(FlxG.random.float(0.3, 0.7), () -> startDialogue(Paths.file('songs/blammed/end-dialogue2.xml'), () -> close()))
			});

		}
	);
}