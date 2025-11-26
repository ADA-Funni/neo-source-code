import flixel.effects.FlxFlicker;
import funkin.backend.system.Flags;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;

var menuItems:Array<{name:String, pos:Array<Float>, selectOffset:Array<Float>, callback:Void->FlxState, left:Bool}> = [
	{
		name: "story mode",
		pos: [120, 30],
		selectOffset: [-0.85, 7.5],
		callback: () -> FlxG.switchState(new StoryMenuState()),
		left: true
	},
	{
		name: "freeplay",
		pos: [240, 200],
		selectOffset: [-0.85, 7.5],
		callback: () -> FlxG.switchState(new FreeplayState()),
		left: true
	},
	{
		name: "credits",
		pos: [120, 370],
		selectOffset: [-0.85, 7.5],
		callback: () -> FlxG.switchState(new CreditsMain()),
		left: true
	},
	{
		name: "datalogs",
		pos: [50, 540],
		selectOffset: [-0.85, 7.5],
		callback: () -> FlxG.switchState(new ModState("DatalogsState")),
		left: true
	},
	{
		name: "achievements",
		pos: [1145, -5],
		selectOffset: [0, 7.5],
		callback: () -> {
			FlxG.state.openSubState(new ModSubState("AchievementsState"));
			FlxTween.tween(FlxG.camera.scroll, {x: 1650}, 0.5, {ease: FlxEase.quadOut});
		},
		left: false
	},
	{
		name: "options",
		pos: [1130, 575],
		selectOffset: [0, 5],
		callback: () -> FlxG.switchState(new OptionsMenu()),
		left: false
	}
];
var menuObjects:FlxTypedGroup;
var sunset:FunkinSprite;

var canSelect:Bool = true;
var curSelected:Int = 0;

var timerUntilTheEarthEndsAndEverythingDies:FlxTimer = new FlxTimer().start(300, () -> {
	Flags.DISABLE_TRANSITIONS = true;
	FlxG.switchState(new ModState("JellyState"));
});

function create() {
	CoolUtil.playMenuSong();

	var bg = add(new FunkinSprite(0, 0, Paths.image("menus/mainmenu/background_with_grid")));
	bg.scale.x = 1.3;
	bg.updateHitbox();

	var bgRight = add(new FunkinSprite(0, 0, Paths.image("menus/achievements/bg")));
	bgRight.x = bg.width;

	sunset = add(new FunkinSprite(-FlxG.width * 2, FlxG.width * -0.065, Paths.image("menus/mainmenu/sunset")));
	FlxTween.tween(sunset, {x: FlxG.width * -0.42}, 2, {ease: FlxEase.quintOut });
	sunset.addAnim("sunset", "sunset", 12, false);
	new FlxTimer().start(0.62, () -> sunset.playAnim("sunset"));
	sunset.setGraphicSize(sunset.width * 1.05);
	sunset.updateHitbox();

	add(menuObjects = new FlxTypedGroup());

	for (i => item in menuItems) {
		var obj = menuObjects.add(new FunkinSprite(item.left ? -FlxG.width * 2 : FlxG.width * 2, item.pos[1], Paths.image("menus/mainmenu/capsules/" + item.name)));
		FlxTween.tween(obj, {x: item.pos[0]}, 2 + (i * 0.1), {ease: FlxEase.quintOut, startDelay: 0.5 + (i * 0.1)});
		obj.addAnim("idle", item.name + " capsule", 24, true);
		obj.addAnim("select", item.name + " select", 24, false);
		obj.addOffset("select", item.selectOffset[0], item.selectOffset[1]);
		obj.playAnim("idle");
	}

	if (FlxG.random.bool(0.001)) { // 1 in 1000
		var logo:FunkinSprite = new FunkinSprite(FlxG.width * 0.6, FlxG.height * 0.23);
		logo.frames = Paths.getFrames('menus/mainmenu/jellyfish logo');
		logo.addAnim("idle", "Jellyfish logo", 24, true);
		logo.playAnim('idle');
		add(logo);
	} else if (FlxG.random.bool(1)) { // 1 in 100
		var jellyfish:FunkinSprite = new FunkinSprite(FlxG.width * 0.48, FlxG.height * 0.2);
		jellyfish.frames = Paths.getFrames('menus/mainmenu/jellyfish');
		jellyfish.addAnim("idle", "jelly throne", 24, true);
		jellyfish.playAnim('idle');
		jellyfish.flipX = true;
		add(jellyfish);
		giveAchievement('jellyfish');
	}

	var versionText = add(new FunkinText(5, 0, 0, neoVersion + "\n" + Flags.VERSION_MESSAGE, 22));
	versionText.y = FlxG.height - versionText.height - 5;
	versionText.scrollFactor.set();
}

function update(elapsed) {
	if (Options.devMode && controls.DEV_ACCESS && canSelect) {
		openSubState(new EditorPicker());
		persistentUpdate = false;
	}

	if (controls.SWITCHMOD && canSelect) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
	}

	if (controls.UP_P && canSelect) {
		CoolUtil.playMenuSFX();
		timerUntilTheEarthEndsAndEverythingDies.reset(300);
		curSelected = FlxMath.wrap(curSelected - 1, 0, menuObjects.length - 1);
	}

	if (controls.DOWN_P && canSelect){
		CoolUtil.playMenuSFX();
		timerUntilTheEarthEndsAndEverythingDies.reset(300);
		curSelected = FlxMath.wrap(curSelected + 1, 0, menuObjects.length - 1);
	}

	if (controls.BACK && canSelect) {
		FlxG.switchState(new TitleState());
	}

	if (canSelect && (controls.ACCEPT || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(menuObjects.members[curSelected])))) {
		canSelect = Flags.DISABLE_TRANSITIONS = false;

		CoolUtil.playMenuSFX(1);
		FlxG.camera.flash(FlxG.random.bool(50) ? 0xFFFF00FF : 0xFF00FFFF, 0.5);
		FlxFlicker.flicker(menuObjects.members[curSelected]);

		for (i => obj in menuObjects.members)
			FlxTween.tween(obj, {alpha: 0}, 1, {ease: FlxEase.expoInOut});

		FlxTween.tween(sunset, {x: -FlxG.width * 2}, 1, {ease: FlxEase.quintIn});

		new FlxTimer().start(1, () -> menuItems[curSelected].callback());
	}

	for (i => obj in menuObjects.members) {
		if (curSelected != i && FlxG.mouse.overlaps(obj) && canSelect) {
			curSelected = i;
			timerUntilTheEarthEndsAndEverythingDies.reset(300);
			CoolUtil.playMenuSFX();
		}

		var animToPlay:String = i == curSelected ? "select" : "idle";

		if (obj.animation.curAnim.name != animToPlay)
			obj.playAnim(animToPlay);
	}
}