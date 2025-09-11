var menuItems:Array<Dynamic> = [
    {
        name: "story mode",
        pos: [120, 30],
        offsets: [],
        left: true
    },
    {
        name: "freeplay",
        pos: [240, 200],
        left: true
    },
    {
        name: "credits",
        pos: [120, 370],
        left: true
    },
    {
        name: "datalogs",
        pos: [50, 540],
        left: true
    },
    {
        name: "options",
        pos: [1130, 575],
        left: false
    }
];
var menuObjects:FlxTypedGroup;

var curSelected:Int = 0;

function create() {
    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/mainmenu/background_with_grid")));

    var sunset = add(new FunkinSprite(-FlxG.width * 2, FlxG.width * -0.065, Paths.image("menus/mainmenu/sunset")));
    FlxTween.tween(sunset, {x: FlxG.width * -0.42}, 2, {ease: FlxEase.quintOut});
    sunset.addAnim("sunset", "sunset", 12, false);
    sunset.setGraphicSize(sunset.width * 1.05);
    sunset.updateHitbox();

    add(menuObjects = new FlxTypedGroup());

    for (i => item in menuItems) {
        var obj = menuObjects.add(new FunkinSprite(item.left ? -FlxG.width * 2 : FlxG.width * 2, item.pos[1], Paths.image("menus/mainmenu/capsules/" + item.name)));
        FlxTween.tween(obj, {x: item.pos[0]}, 2 + (i * 0.1), {ease: FlxEase.quintOut, startDelay: 0.5 + (i * 0.1)});
        obj.addAnim("idle", item.name + " capsule", 24, false);
        obj.addAnim("select", item.name + " select", 24, false);
        obj.playAnim("idle");
    }
}

function update(elapsed) {
    if (controls.UP_P) curSelected = FlxMath.wrap(curSelected - 1, 0, menuObjects.length - 1);
    if (controls.DOWN_P) curSelected = FlxMath.wrap(curSelected + 1, 0, menuObjects.length - 1);

    for (i => obj in menuObjects.members) {
        var animToPlay:String = i == curSelected ? "select" : "idle";

        if (obj.animation.curAnim.name != animToPlay) {
            obj.playAnim(animToPlay);
        }
    }
}