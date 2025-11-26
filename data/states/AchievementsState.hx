import funkin.backend.system.Flags;

var achievementSprites:FlxSpriteGroup;
var achievementName:FunkinText;
var achievementDesc:FunkinText;
static var achievementsCurSelected:Int = 0;
var achievementsList:Array<String> = [for (achievement in achievementsJson) achievement.id];

function create() {
	achievementName = add(new FunkinText(1600, 30, FlxG.width, "meow", 35));
	achievementName.alignment = "center";

	achievementSprites = add(new FlxSpriteGroup(1680, 130));

	achievementsList.push('locked'); // :trollface:
	var curI:Int = 0;
	for (i => achievement in achievementsList) {
		if (!achievements.data.get(achievement) && achievements.hidden.get(achievement)) continue;
		var col = curI % 5;
		var row = Std.int(curI / 5);

		var obj = achievementSprites.add(new FunkinSprite(col * 170, row * 170, Paths.image("menus/achievements/achievements/" + (achievements.data.get(achievement) ? achievement : "locked"))));
		obj.setGraphicSize(150, 150);
		obj.updateHitbox();
		curI++;
	}
	achievementName.text = achievements.names.get(achievementsList[achievementsCurSelected]);
	// achievementDesc.text = achievements.descriptions.get(achievementsList[achievementsCurSelected]);
}

function update(elapsed) {
	if (controls.LEFT_P) changeSelection(-1);
	if (controls.RIGHT_P) changeSelection(1);
	if (controls.UP_P) changeSelection(-5);
	if (controls.DOWN_P) changeSelection(5);

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
	achievementsCurSelected = FlxMath.wrap(achievementsCurSelected + amt, 0, achievementsList.length - 1);
	achievementName.text = achievements.names.get(achievementsList[achievementsCurSelected]);
	// achievementDesc.text = achievements.descriptions.get(achievementsList[achievementsCurSelected]);
}