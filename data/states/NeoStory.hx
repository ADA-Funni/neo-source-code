import ColorHelp;
import flixel.addons.effects.FlxTrail;
import flixel.effects.FlxFlicker;
import funkin.menus.StoryMenuState.StoryWeeklist;
import hxvlc.flixel.FlxVideoSprite;

var weekTxt, dadCharTrail, bfCharTrail, dadChar, bfChar;
var diffs = ["chill", "basic", "neo"];
var weekList:StoryWeeklist;
var curSelected = 0;
var selectedWeek;
var curDiff = 1;
var weekSprite;

function create(){
    CoolUtil.playMenuSong();
    weekList = StoryWeeklist.get(true, false);

    // var bgSpr = new FlxSprite(0, 0, Paths.image("menus/storymenu/story_bg"));
    var video = new FlxVideoSprite(0, 0);
    video.load(Assets.getPath(Paths.video("vaperwave")), [':input-repeat=65535', ':no-audio']);
    video.play();
	video.bitmap.onFormatSetup.add(function():Void
	{
		if (video.bitmap != null && video.bitmap.bitmapData != null)
		{
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
		}
	});

    var innerBG = new FlxSprite(0, 0, Paths.image("menus/storymenu/inner")).screenCenter();
    weekTxt = new FunkinText(0, -300, FlxG.width, "", 48);
    weekTxt.alignment = "center";
    diffSpr = new FlxSprite(0, 300);
    weekSprite = new FlxSprite(0, 100);
    dadChar = new FlxSprite();
    dadCharTrail = new FlxTrail(dadChar, null, 15, 12, 0.3, 0.09);
    dadCharTrail.afterCache = () -> {
        var dadColor:ColorHelp = new ColorHelp(FlxColor.fromString(selectedWeek.xml.get("charColors").split(",")[0]));

        for (obj in dadCharTrail.members)
            obj.setColorTransform(0, 0, 0, obj.alpha, dadColor.red, dadColor.green, dadColor.blue, 1);
    };
    dadCharTrail.maxSize = 20;
    bfChar = new FlxSprite();
    bfCharTrail = new FlxTrail(bfChar, null, 15, 12, 0.3, 0.09);
    bfCharTrail.maxSize = 20;
    bfCharTrail.afterCache = () -> {
        var bfColor:ColorHelp = new ColorHelp(FlxColor.fromString(selectedWeek.xml.get("charColors").split(",")[1]));

        for (obj in bfCharTrail.members)
            obj.setColorTransform(0, 0, 0, obj.alpha, bfColor.red, bfColor.green, bfColor.blue, 1);
    };

    for (spr in [video, innerBG, weekTxt, weekSprite, diffSpr, dadCharTrail, bfCharTrail, dadChar, bfChar])
        add(spr);

    changeDiff(0);
    updateWeekText(0);
}

var trans:Bool = false;

function update(elapsed:Float) {
    if (controls.UP_P) updateWeekText(-1);
    if (controls.DOWN_P) updateWeekText(1);
    if (controls.LEFT_P) changeDiff(-1);
    if (controls.RIGHT_P) changeDiff(1);

    if (controls.ACCEPT) {
        if (trans) {
            FlxG.switchState(new PlayState());
        } else {
            trans = true;
            CoolUtil.playMenuSFX(1);
            FlxG.camera.flash(FlxG.random.bool(50) ? 0xFFFF00FF : 0xFF00FFFF);
            FlxFlicker.flicker(weekTxt, 1);

        PlayState.loadWeek(weekList.weeks[curSelected], diffs[curDiff]);
        new FlxTimer().start(1, () -> FlxG.switchState(new PlayState()));
    }

    if (controls.BACK)  FlxG.switchState(new MainMenuState());

    diffSpr.y = lerp(diffSpr.y, FlxG.height - 125, 0.15);
}

function changeSelection(dir:Int, objects:Array):Int {
    curSelected = FlxMath.wrap(curSelected + dir, 0, objects.length - 1);
    return objects[curSelected];
}

function changeDiff(dir:Int)
{
    CoolUtil.playMenuSFX();
    curDiff = FlxMath.wrap(curDiff + dir, 0, diffs.length - 1);
    diffSpr.loadGraphic(Paths.image("menus/storymenu/diffs/" + diffs[curDiff]));
    FlxTween.cancelTweensOf(diffSpr);
    diffSpr.screenCenter(FlxAxes.X);
    diffSpr.x += dir * 50;
    FlxTween.tween(diffSpr, {x: diffSpr.x - (dir * 50)}, 0.6, {ease: FlxEase.circOut});
}

function updateWeekText(dir:Int) {
    CoolUtil.playMenuSFX();

    var oldText = new FunkinText(weekTxt.x, weekTxt.y, weekTxt.width, weekTxt.text, 48);
    FlxTween.tween(oldText, {y: weekTxt.y + (dir * 200), alpha: 0}, 0.45, {ease: FlxEase.circOut, onComplete: () -> oldText.destroy()});
    oldText.alignment = "center";
    insert(FlxG.state.members.indexOf(weekTxt), oldText);

    selectedWeek = changeSelection(dir, weekList.weeks);

    weekSprite.loadGraphic(Paths.image("menus/storymenu/weekgraphics/" + selectedWeek.sprite));
    weekSprite.screenCenter(FlxAxes.X);

    dadChar.loadGraphic(Paths.image("menus/storymenu/chars/" + selectedWeek.chars[0].name));
    dadCharTrail.resetTrail();
    FlxTween.cancelTweensOf(dadChar);
    dadChar.setPosition(15 - 1200, FlxG.height - dadChar.height);
    FlxTween.tween(dadChar, {x: dadChar.x + 1200}, 0.6, {ease: FlxEase.circOut});

    bfChar.loadGraphic(Paths.image("menus/storymenu/chars/" + selectedWeek.chars[1].name));
    bfCharTrail.resetTrail();
    FlxTween.cancelTweensOf(bfChar);
    bfChar.setPosition(((FlxG.width - bfChar.width) - 15) + 1200, FlxG.height - bfChar.height);
    FlxTween.tween(bfChar, {x: bfChar.x - 1200}, 0.6, {ease: FlxEase.circOut});

    weekTxt.text = [for (s in selectedWeek.songs) s.name].join("\n");
    FlxTween.cancelTweensOf(weekTxt);
    weekTxt.screenCenter();
    weekTxt.y += dir * 50;
    FlxTween.tween(weekTxt, {y: (weekTxt.y - (dir * 50)) + 30}, 0.45, {ease: FlxEase.circOut});
}