import flixel.addons.display.FlxBackdrop;
import funkin.menus.StoryMenuState.StoryWeeklist;
import funkin.game.PlayState;

var bgSpr, diffSpr, innerBG, weekTxt;
var weeks = ["week_1", "week_2"];
var diffs = ["easy", "normal", "hard"];
var weekList:StoryWeeklist;
var curSelected, selectedWeek, curDiff = 0;
var diffGraphics:Array<FlxGraphic> = [];
var weekSprite;
var baseDiffX, baseWeekY = 0;
function create(){
    weekList = StoryWeeklist.get(true, false);
    selectedWeek = changeSelection(0, weekList.weeks);
    bgSpr = new FlxSprite(0, 0, Paths.image("menus/storymenu/story_bg"));
    diffSpr = new FlxSprite(0, 300, Paths.image("menus/storymenu/diffs/easy")).screenCenter(0x01);
    baseDiffX = diffSpr.x;
    innerBG = new FlxSprite(0, 0, Paths.image("menus/storymenu/inner")).screenCenter();
    weekName = FunkinText(0, -300, FlxG.width, selectedWeek.name, 48);
    weekTxt = new FunkinText(0, -300, FlxG.width, updateSongNames().join("\n"), 48);
    weekSprite = new FlxSprite(0, 300, Paths.image("menus/storymenu/week_1"));
    baseWeekY = weekSprite.y;
    add();
    FlxTween.tween(weekTxt, {y: 300}, 0.45, { ease: FlxEase.quadOut });
    weekTxt.alignment = "center";  
    for (d in diffs) {
        diffGraphics.push(Paths.image("menus/storymenu/diffs/" + d));
    }
    addAll([bgSpr, innerBG, weekTxt, weekName, weekSprite, diffSpr]);
}
function update(elapsed:Float) {
    if (controls.UP_P) {
        updateWeekText(-1);
    }
    if (controls.DOWN_P) {
        updateWeekText(1);
    }
    if (controls.LEFT_P) {
        changeDiff(-1);
    }
    if (controls.RIGHT_P) {
        changeDiff(1);
    }
    if (controls.ACCEPT) {
        PlayState.loadWeek(weekList.weeks[curSelected], numtoDiff(curDiff));
        new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new PlayState());
		});
    }
    if (controls.BACK) {
        FlxG.switchState(new MainMenuState());
    }
    diffSpr.y = lerp(diffSpr.y, FlxG.height - 125, 0.15);
}

// i love this :3
function addAll(sprites) {
    for (spr in sprites) {
        add(spr);
    }
}

// simpler so i can just call the function
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
    diffSpr.x = baseDiffX + (dir * 100);
    FlxTween.tween(diffSpr, {x: baseDiffX}, 0.6, {ease: FlxEase.circOut});
}

function updateWeekText(dir:Int) {
    CoolUtil.playMenuSFX();
    var oldText = new FunkinText(weekTxt.x, weekTxt.y, weekTxt.width, weekTxt.text, 48);
    oldText.alignment = "center";
    add(oldText);

    if (dir < 0) {
        FlxTween.tween(oldText, { y: oldText.y - 50, alpha: 0 }, 0.15, {
            ease: FlxEase.quadIn,
            onComplete: () -> remove(oldText)
        });
        selectedWeek = changeSelection(dir, weekList.weeks);
        weekTxt.text = updateSongNames().join("\n");
        trace(weekTxt.text);
        weekTxt.alpha = 0;
        weekTxt.y += 50;
        FlxTween.tween(weekTxt, { y: weekTxt.y - 50, alpha: 1 }, 0.25, { ease: FlxEase.quadOut });
    } else {
        FlxTween.tween(oldText, { y: oldText.y + 50, alpha: 0 }, 0.15, {
            ease: FlxEase.quadIn,
            onComplete: () -> remove(oldText)
        });
        selectedWeek = changeSelection(dir, weekList.weeks);
        weekTxt.text = updateSongNames().join("\n");
        weekTxt.alpha = 0;
        weekTxt.y -= 50;
        FlxTween.tween(weekTxt, { y: weekTxt.y + 50, alpha: 1 }, 0.25, { ease: FlxEase.quadOut });
    }
    
    weekSprite.loadGraphic(weeks[selectedWeek]);
    FlxTween.cancelTweensOf(diffSpr);
    weekSprite.y = baseWeekY + (dir * 100);
    FlxTween.tween(weekSprite, {y: baseWeekY}, 0.6, {ease: FlxEase.circOut});
}
function updateSongNames() {
    return [for (s in selectedWeek.songs) s.name];
}

function numtoDiff(num:Int) {
    return diffs[num];
}