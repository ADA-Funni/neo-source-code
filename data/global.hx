import funkin.backend.utils.WindowUtils;
import flixel.group.FlxTypedSpriteGroup;

public static var neoVersion:String = "Neo R DEMO";

public static var achievements:Map<String, Bool> = [
	"Welcome back!" => false,
	"Gettin freaky tonight!" => false,
	"Bow down to the new king!" => false,
	"Thank you for shopping at walmart." => false,
	"Remember kids! Don't do drugs!!" => false,
	"Blammit!" => false,
	"Cracked" => false,
	"Take your viargra" => false, 
	"The king is watching" => false
];
public static var achievementDescriptions:Map<String, String> = [
	"Welcome back!" => "Open the game",
	"Gettin freaky tonight!" => "Beat tutorial",
	"Bow down to the new king!" => "Beat week1",
	"Thank you for shopping at walmart." => "Beat week2",
	"Remember kids! Don't do drugs!!" => "Encounter monster",
	"Blammit!" => "Beat week3",
	"Cracked" => "Die",
	"Take your viargra" => "Somehow fail tutorial",
	"The king is watching" => "Find the jellyfish throne easter egg"
];
var achievementsLength:Int = -1;
public static var achievementsTimer:FlxTimer = new FlxTimer();

function new() {
	FlxG.save.data.achievements ??= achievements;
	achievements = FlxG.save.data.achievements;

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

public static function giveAchievement(achievementName:String = "faggot", callback:Void = () -> {}) {
	trace(achievementName);
	if (achievements.get(achievementName)) return;
	achievements.set(achievementName, true);
	FlxG.save.data.achievements = achievements;
	trace(achievements);

	achievementsLength++;

	var epicAchievementGroup = FlxG.state.add(new FlxTypedSpriteGroup(-150, achievementsLength * 180));
	epicAchievementGroup.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
	epicAchievementGroup.alpha = 0.0001;
	FlxTween.tween(epicAchievementGroup, {x: 0, alpha: 1}, 0.5, {ease: FlxEase.expoInOut, onComplete: () -> {
		FlxTween.tween(epicAchievementGroup, {x: -150, alpha: 0}, 0.5, {ease: FlxEase.expoInOut, startDelay: 5});
		achievementsLength--;
	}});

	var timerLeft:Float = achievementsTimer.elapsedTime;

	achievementsTimer.cancel();
	achievementsTimer.start(timerLeft + 6, callback);

	var coolBG = epicAchievementGroup.add(new FunkinSprite(120, 20, Paths.image("menus/achievements/achievment-unlock")));

	var achievementText = epicAchievementGroup.add(new FunkinText(150, 50, coolBG.width, achievementName + "\n" + achievementDescriptions.get(achievementName), 25));

	var epicAchievement = epicAchievementGroup.add(new FunkinSprite(0, 0, Paths.image("menus/achievements/achievements/" + achievementName)));
	epicAchievement.setGraphicSize(150, 150);
	epicAchievement.updateHitbox();

	coolBG.scrollFactor.x = coolBG.scrollFactor.y = epicAchievement.zoomFactor = epicAchievement.scrollFactor.x = epicAchievement.scrollFactor.y = epicAchievement.zoomFactor = 0;
}