var isPlayer:Bool = true;
var iconP3:HealthIcon;

function postCreate(){    
    iconP3 = new HealthIcon(gf != null && gf.icon!=null?gf.icon:gf.curCharacter, isPlayer);
    iconP3.cameras = [camHUD];
    add(iconP3);
    iconP3.alpha = 0;
    iconP3.setPosition(iconP1.x + 70, iconP2.y - (!downscroll ? 35 : -15));
    iconP3.scale.set(0.8, 0.8);

}

function update(elapsed:Float){

    if (curStep < 2306){
        iconP3.x = iconP1.x + 200;
    }
    if (curStep < 2816){
        iconP3.health = isPlayer? iconP1.health : iconP2.health;
    }
}

function beatHit(){
        iconP3.scale.set(1, 1);
        FlxTween.tween(iconP3.scale, {x: 0.8, y: 0.8}, (0.5 * (1 / (Conductor.bpm / 60))), {ease: FlxEase.circOut});

}

function stepHit(curStep) {
    switch (curStep) {
        case 2306:
            FlxTween.tween(iconP3, {alpha: 1}, 1, {ease: FlxEase.quartOut});
            FlxTween.tween(iconP3, {x: iconP1.x + 70}, 0.5, {ease: FlxEase.quartOut});
        case 2816:
            iconP3.health = 0.1;
            FlxTween.tween(iconP3, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            FlxTween.tween(iconP3, {y: 700}, 2, {ease: FlxEase.cubeInOut});
            FlxTween.tween(iconP3, {angle: 360}, 10, {ease: FlxEase.quartOut});
    }
}