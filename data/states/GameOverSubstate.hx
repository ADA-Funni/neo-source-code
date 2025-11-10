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
        // Step 1: Fade in the background slightly
        FlxTween.tween(bg, {alpha: 0.50}, 1.2, { ease: FlxEase.circInOut });

        // Step 2: Zoom in the camera
        FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.9, { 
            ease: FlxEase.circInOut, 
            onComplete: () -> {

                // Step 3: Zoom back out slightly
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.02}, 0.6, { 
                    ease: FlxEase.circInOut, 
                    onComplete: () -> {

                        // Step 4: Slowly darken the background more after zoom-out
                        FlxTween.tween(bg, {alpha: 1}, 50.5, { ease: FlxEase.linear  });
                    }
                });
            }
        });
    }
}
