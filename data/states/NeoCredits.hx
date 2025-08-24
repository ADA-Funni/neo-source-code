function create() {
    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/credits/bg")));
    bg.screenCenter(FlxAxes.X);

    var cuties = add(new FunkinSprite(0, FlxG.height * 0.45, Paths.image("menus/credits/bf and gf date")));
    cuties.addAnim("loop", "loop", 24, true);
    cuties.playAnim("loop");
}