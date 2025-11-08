function create() {
    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/datalogs/Background_datalog")));
    bg.setGraphicSize(FlxG.width * 1.1, FlxG.height * 1.1);
    bg.screenCenter();
    bg.updateHitbox();

    var pink_box = add(new FunkinSprite(FlxG.width * 0.035, 0, Paths.image("menus/datalogs/pink_box")));
    pink_box.screenCenter(FlxAxes.Y);

    var blue_box = add(new FunkinSprite(FlxG.width * 0.425, 0, Paths.image("menus/datalogs/blue_box")));
    blue_box.setGraphicSize(blue_box.width * 0.9);
    blue_box.updateHitbox();
    blue_box.screenCenter(FlxAxes.Y);
}

function update(elapsed) {
    if (controls.BACK) FlxG.switchState(new MainMenuState());
}