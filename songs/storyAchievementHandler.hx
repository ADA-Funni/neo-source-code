var gaveAchievements:Bool = false;

var weekAchievements:Map<String, String> = [
	"tutorial" => "Gettin freaky tonight!",
	"week_1" => "Bow down to the new king!",
	"week_2" => "Remember kids! Don't do drugs!!",
	"week_3" => "Blammit!"
];

function update(elapsed) {
	if (FlxG.keys.pressed.F4) {
		set_maxHealth(9000000);
		health = 9000000;
		vocals.time = inst.time = inst.length - 1500;
	}
}

function onSongEnd(e) {
	if (gaveAchievements || !PlayState.isStoryMode || PlayState.storyPlaylist.length > 1) return;
	gaveAchievements = true;

	e.cancel();
	storyAchievements();
}

function storyAchievements() {
	for (weekName in weekAchievements.keys())
		if (PlayState.storyWeek.sprite == weekName && PlayState.storyPlaylist.length == 1) giveAchievement(weekAchievements.get(weekName), endSong);
}