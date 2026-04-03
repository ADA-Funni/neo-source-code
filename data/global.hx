import funkin.backend.utils.WindowUtils;

function makeMap() {
	var map = ['init' => null];
	map.remove('init');
	return map;
}

static var neoVersion:String = "Neo R DEMO";

static var achievementsJson = Json.parse(Assets.getText(Paths.json('achievements')));
static var achievements = { // will make less stupid some other time
	data: makeMap(),
	names: makeMap(),
	unlockTypes: makeMap(),
	descriptions: makeMap(),
	hidden: makeMap()
}
var achievementsTimer:FlxTimer = new FlxTimer();
var achievementsLength:Int = -1;

function new() {
	// FlxG.save.data.achievements = null;
	FlxG.save.data.achievements ??= achievements.data;
	achievements.data = FlxG.save.data.achievements;
	for (achievement in achievementsJson) {
		if (!(achievements.data.exists(achievement.id) || achievements.data.get(achievement.id) == true)) // jic
			achievements.data.set(achievement.id, false);
		achievements.names.set(achievement.id, achievement.name ?? achievement.id);
		achievements.unlockTypes.set(achievement.id, achievement.unlock ?? 'none');
		achievements.descriptions.set(achievement.id, achievement.description);
		achievements.hidden.set(achievement.id, achievement.hidden ?? false);
	}
	trace(FlxG.save.data.achievements);

	FlxG.save.data.neoui ??= true;
	FlxG.save.data.neoFirstTime ??= true;

	FlxG.save.data.kadedev ??= true;
	FlxG.save.data.healthdrain ??= 1;

	FlxG.save.data.glitchy ??= true;
	FlxG.save.data.glitchyvalue ??= 4;
}

function postGameStart()
	if (FlxG.save.data.neoFirstTime)
		FlxG.switchState(new ModState("IntroState"));

function preStateSwitch() {
	achievementsLength = -1;
	achievementsTimer.cancel();
	WindowUtils.setWindow("Friday Night Funkin' - Neo", "icon");
}

static function giveAchievement(achievementName:String = "faggot", callback:Void = () -> {}) {
	if (!achievements.data.exists(achievementName)) {
		trace('Achievement "' + achievementName + '", doesn\'t exist.');
		return;
	} else if (achievements.data.get(achievementName)) {
		trace('Achievement "' + achievementName + '", is already unlocked.');
		return;
	}
	achievements.data.set(achievementName, true);
	achievements.data = FlxG.save.data.achievements;
	trace('Unlocked "' + achievementName + '"!');

	achievementsLength++;

	var epicAchievementGroup = FlxG.state.add(new FlxSpriteGroup(-150, achievementsLength * 180));
	epicAchievementGroup.camera = FlxG.cameras.add(new FlxCamera(), false);
	epicAchievementGroup.camera.bgColor = FlxColor.TRANSPARENT;
	epicAchievementGroup.alpha = 0.0001;
	FlxTween.tween(epicAchievementGroup, {x: 0, alpha: 1}, 0.5, {ease: FlxEase.expoInOut, onComplete: () -> {
		FlxTween.tween(epicAchievementGroup, {x: -150, alpha: 0}, 0.5, {ease: FlxEase.expoInOut, startDelay: 5});
		achievementsLength--;
	}});

	achievementsTimer.cancel();
	achievementsTimer.start(achievementsTimer.elapsedTime + 6, callback);

	var coolBG = epicAchievementGroup.add(new FunkinSprite(120, 20, Paths.image("menus/achievements/achievment-unlock")));
	var achievementText = epicAchievementGroup.add(new FunkinText(150, 50, coolBG.width, achievements.names.get(achievementName) + "\n" + achievements.descriptions.get(achievementName), 25));
	var epicAchievement = epicAchievementGroup.add(new FunkinSprite(0, 0, Paths.image("menus/achievements/achievements/" + achievementName)));
	epicAchievement.setGraphicSize(150, 150);
	epicAchievement.updateHitbox();
	coolBG.scrollFactor.x = coolBG.scrollFactor.y = epicAchievement.zoomFactor = epicAchievement.scrollFactor.x = epicAchievement.scrollFactor.y = epicAchievement.zoomFactor = 0;
}