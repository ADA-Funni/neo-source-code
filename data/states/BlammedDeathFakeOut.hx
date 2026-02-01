var deadTexts:Array<String> = [
	'Sonic on the ground.',
	'Congratulations, you now have more holes!',
	'L Bozo',
	'blammit',
	'u fuking died',
	'He pumped you full of lead.',
	'It was not an empty threat.',
	'You are now a pincushion.',
	'And that\'s how you make swiss cheese!',
	'Imagine dying, couldn\'t be me!',
	'How did you die on dialogue cutscene??',
	'How did you dia on dielogue cutscene??',
	'You\'re not supposed to kiss the floor.',
	'Guess you gotta play the song all over again!',
	'Hey, how does lead taste like?',
	'That\'s *not* how you do it!',
	'That\'s rough buddy.',
	'Remember kids, killing is a crime!',
	'It\'s no use!',
	'Those balls ain\'t saving ya now!',
	'And everyone lived happily ever after without you!',
	'The end.',
	'Guess you\'re not coming home to your mom.',
	'No more head from your girlfriend.',
	'fuck',
	'SonicStrong randomly: When?',
	'That\'s a lot of ketchup...',
	'That\'s one way to touch grass!',
	'"Looks like boyfriend met his boyend (heh, I\'m so tuff and funny aren\'t I guys..)"',
	'Sorry guys! No more v2.'
];

var bgMusic:FlxSound;
var gameOverText:FlxText;
var subText:FlxText;
var deathSprite:FlxSprite;

function create():Void {
	bgMusic = FlxG.sound.load(Paths.music('gameOver'), 0.7);
	cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));

	add(gameOverText = new FlxText(0, 50, FlxG.width, 'GAME OVER', 60));
	gameOverText.color = FlxColor.RED;
	gameOverText.alignment = 'center';
	gameOverText.font = Paths.font('vcr.ttf');

	add(subText = new FlxText(0, 180, FlxG.width, deadTexts[FlxG.random.int(0, deadTexts.length - 1)], 30));
	subText.alignment = 'center';
	subText.font = Paths.font('phantom-muff.ttf');

	add(deathSprite = new FlxSprite(0, 300, Paths.image('dialogue/characters/he ded')));
	deathSprite.antialiasing = true;
	deathSprite.screenCenter(FlxAxes.X);

	var fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	FlxG.sound.play(Paths.sound('uzi rapid fire')).onComplete = () -> {
		bgMusic.play();
		FlxTween.tween(fade, {alpha: 0}, 1, {ease: FlxEase.quadOut});
		giveAchievement('shoot-out');
	}
	add(fade);
}

function update(elapsed:Float):Void {
	if (controls.ACCEPT || controls.BACK) {
		bgMusic.stop();
		close();
	}
}