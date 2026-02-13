var gaveAchievements:Bool = false;

function update(elapsed) {
	if (FlxG.keys.pressed.F10) {
		canDie = canDadDie = false;
		vocals.time = inst.time = inst.length - 1500;
	}
}

function onSongEnd(e) {
	if (gaveAchievements || !PlayState.isStoryMode || PlayState.storyPlaylist.length > 1) return;
	gaveAchievements = true;

	storyAchievements();
}

function storyAchievements()
	for (id => type in achievements.unlockTypes) {
		var typing = type.split(':');
		if (typing[0] == 'WEEK')
			if (PlayState.storyWeek.sprite == typing[1] && PlayState.storyPlaylist.length == 1)
				giveAchievement(id, endSong);
	}