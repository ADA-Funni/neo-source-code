import funkin.backend.utils.XMLUtil;
import funkin.savedata.FunkinSave;

var badgeSprite:FunkinSprite;
function postCreate():Void {
	badgeSprite = new FunkinSprite(FlxG.width - 280, -30);
	badgeSprite.frames = Paths.getFrames('menus/freeplay/perfect_badge');
	XMLUtil.addAnimToSprite(badgeSprite, {
		name: 'idle',
		anim: 'Perfect badge',
		fps: 24,
		loop: true
	});
	badgeSprite.scale.set(0.3, 0.3);
	badgeSprite.playAnim('idle', true);
	badgeSprite.scrollFactor.set();
	add(badgeSprite);
}

function postUpdate(elapsed:Float):Void {
	for (i => spr in grpSongs.members) {
		spr.x = lerp(spr.x, FlxG.width * 0.05 + (i * -25) + (curSelected == i ? 120 : 0), 0.05);
		iconArray[i].x = spr.width + spr.x;
	}
}

function getSongScoreData(name:String, difficulty:String, ?variation:String, ?opponentMode:Bool, ?coopMode:Bool):{score:Int, accuracy:Float, misses:Int, hits:Map<String, Int>, date:String} {
	var changes = [];
	if (opponentMode ?? false) changes.push(Type.resolveEnum('funkin.savedata.HighscoreChange').COpponentMode);
	if (coopMode ?? false) changes.push(Type.resolveEnum('funkin.savedata.HighscoreChange').CCoopMode);
	return FunkinSave.getSongHighscore(name, difficulty, variation, changes);
}
function checkBadgeVisibility():Void {
	var score = getSongScoreData(curSong.name, curDifficulties[curDifficulty], curSong.variant, __opponentMode, __coopMode);
	badgeSprite.visible = score.accuracy == 100;
}

function onUpdateOptionsAlpha(event):Void
	checkBadgeVisibility();

function onChangeDiff(event):Void {
	event.cancel();
	var validDifficulties = curDifficulties.length > 0;

	var prevSong = curSong;
	curDifficulty = event.value;
	updateCurSong();
	updateScore();

	#if PRELOAD_ALL
	if (curSong != prevSong) {
		autoplayElapsed = 0;
		songInstPlaying = false;
	}
	#end

	var text = validDifficulties ? curDifficulties[curDifficulty].toUpperCase() : '-';
	diffText.text = curDifficulties.length > 1 ? '< ' + text + ' >' : text;
}