import flixel.group.FlxTypedSpriteGroup;

var achievementSprites:FlxTypedSpriteGroup;
var achievementName:FunkinText;
var achievementDesc:FunkinText;
static var achievementsCurSelected:Int = 0;

var arrayBecauseIFuckingHateEverything:Array<String> = [
	"Welcome back!",
	"Gettin freaky tonight!",
	"Bow down to the new king!",
	"Thank you for shopping at walmart.",
    "Remember kids! Don't do drugs!!",
	"Blammit!",
	"Cracked",
	"Take your viargra",
    "The king is watching",
    "locked"
];

function create() {
    achievementName = add(new FunkinText(1600, 30, FlxG.width, "meow", 35));
    achievementName.alignment = "center";
    
	achievementSprites = add(new FlxTypedSpriteGroup(1680, 130));

	for (i => achievement in arrayBecauseIFuckingHateEverything) {
        var col = i % 5;
        var row = Std.int(i / 5);

        var obj = achievementSprites.add(new FunkinSprite(col * 170, row * 170, Paths.image("menus/achievements/achievements/" + (achievements.get(achievement) ? achievement : "locked"))));
        obj.setGraphicSize(150, 150);
        obj.updateHitbox();
	}
}

function update(elapsed) {
    if (controls.LEFT_P) changeSelection(-1);
    if (controls.RIGHT_P) changeSelection(1);

    if (controls.BACK) {
            FlxTween.tween(FlxG.camera.scroll, {x: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: () -> {
                Flags.DISABLE_TRANSITIONS = true;
                FlxG.resetState();
            }});
        }

    for (i => obj in achievementSprites.members) obj.scale.x = obj.scale.y = lerp(obj.scale.x, i == achievementsCurSelected ? 1.2 : 1, 0.35);
}

function changeSelection(amt:Int = 0) {
    CoolUtil.playMenuSFX();
    achievementsCurSelected = FlxMath.wrap(achievementsCurSelected + amt, 0, arrayBecauseIFuckingHateEverything.length - 1);
}