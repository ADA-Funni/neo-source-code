var bg:FunkinSprite;

function postCreate() {
    game.persistentDraw = true;
    game.boyfriend.visible = false;
    FlxTween.tween(game.camHUD, {alpha: 0, y: 35, angle: 2.5}, 0.5, { ease: FlxEase.cubicInOut });

    bg = insert(0, new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK));
    bg.zoomFactor = bg.alpha = 0;
    bg.scrollFactor.set(0, 0);
}

function update(elapsed) {
    if (character.animation.curAnim.name == "deathLoop" && bg.alpha == 0) {
        FlxTween.tween(bg, {alpha: 0.5}, 1.2, { ease: FlxEase.circInOut });
        FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.6}, 0.9, { ease: FlxEase.circInOut, onComplete: () -> {
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom -0.02}, 0.6, { ease: FlxEase.circInOut });
        }});
    }
}