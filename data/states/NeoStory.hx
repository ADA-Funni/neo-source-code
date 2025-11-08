import flixel.addons.display.FlxBackdrop;
import funkin.menus.StoryMenuState.StoryWeeklist;
import funkin.game.PlayState;

var weekTxt;
var weeks = ["week_1", "week_2", "week_3"];
var diffs = ["chill", "basic", "neo"];
var weekList:StoryWeeklist;
var curSelected, selectedWeek = 0;
var curDiff = 1;
var diffGraphics:Array<FlxGraphic> = [];
var weekGraphics:Array<FlxGraphic> = [];
var weekSprite;

function create(){
    weekList = StoryWeeklist.get(true, false);
    
    var bgSpr = new FlxSprite(0, 0, Paths.image("menus/storymenu/story_bg"));
    var innerBG = new FlxSprite(0, 0, Paths.image("menus/storymenu/inner")).screenCenter();
    weekTxt = new FunkinText(0, -300, FlxG.width, "", 48);
    weekTxt.alignment = "center";
    diffSpr = new FlxSprite(0, 300);
    weekSprite = new FlxSprite(0, 100);

    for (d in diffs) diffGraphics.push(Paths.image("menus/storymenu/diffs/" + d));
    for (d in weeks) weekGraphics.push(Paths.image("menus/storymenu/weekgraphics/" + d));
    changeDiff(0);
    updateWeekText(0);
    addAll([bgSpr, innerBG, weekTxt, weekSprite, diffSpr]);
}

function update(elapsed:Float) {
    if (controls.UP_P) updateWeekText(-1);
    if (controls.DOWN_P) updateWeekText(1);
    if (controls.LEFT_P) changeDiff(-1);
    if (controls.RIGHT_P) changeDiff(1);
    
    if (controls.ACCEPT) {
        PlayState.loadWeek(weekList.weeks[curSelected], numtoDiff(curDiff));
        new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new PlayState());
		});
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
    diffSpr.loadGraphic(diffGraphics[curDiff]);
    FlxTween.cancelTweensOf(diffSpr);
    diffSpr.screenCenter(FlxAxes.X);
    diffSpr.x += dir * 50;
    FlxTween.tween(diffSpr, {x: diffSpr.x - (dir * 50)}, 0.6, {ease: FlxEase.circOut});
}

function updateWeekText(dir:Int) {
    CoolUtil.playMenuSFX();

    // var oldText = new FunkinText(weekTxt.x, weekTxt.y, weekTxt.width, weekTxt.text, 48);
    // FlxTween.tween(oldText, {y: weekTxt.y + (dir * 200), alpha: 0}, 0.45, {ease: FlxEase.circOut});
    // oldText.alignment = "center";
    // add(oldText);

    selectedWeek = changeSelection(dir, weekList.weeks);

    weekSprite.loadGraphic(weekGraphics[selectedWeek]);
    weekSprite.screenCenter(FlxAxes.X);

    weekTxt.text = updateSongNames().join("\n");
    FlxTween.cancelTweensOf(weekTxt);
    weekTxt.screenCenter();
    weekTxt.y += dir * 50;
    FlxTween.tween(weekTxt, {y: weekTxt.y - (dir * 50)}, 0.45, {ease: FlxEase.circOut});
}

function updateSongNames()
    return [for (s in selectedWeek.songs) s.name];

function numtoDiff(num:Int)
    return diffs[num];

// i love this :3
function addAll(sprites)
    for (spr in sprites)
        add(spr);