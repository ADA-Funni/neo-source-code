import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import hxvlc.flixel.FlxVideoSprite;

var logo;

function create() {
	CoolUtil.playMenuSong();

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
	add(video);

	var line = add(new FunkinSprite(0, 0, Paths.image("menus/titlescreen/neon_line")));
	line.screenCenter();

	var introTextText = add(new FunkinText(0, 0, 0, StringTools.replace(FlxG.random.getObject(CoolUtil.coolTextFile(Paths.txt("titlescreen/introText"))), '[USER]', DiscordUtil.user.globalName) + '  < >  ', 40));

	new FlxTimer().start(0.005, function() { // needs too have a delay, idk why honestly :/
		var introText = add(new FlxBackdrop(introTextText.pixels, FlxAxes.X)); //top 10 kittysleeper janky codes
		introText.y = line.y + (line.height / 2 - introText.height / 2);
		introText.velocity.x = -70;
		introTextText.destroy();
	});

	logo = add(new FunkinSprite(0, FlxG.height * -0.0365, Paths.image("menus/titlescreen/logo")));
	logo.addAnim("bop", "logo", 24, false);
	logo.setGraphicSize(logo.width * 0.82);
	logo.updateHitbox();
	logo.screenCenter(FlxAxes.X);

	var start = add(new FunkinSprite(0, FlxG.height * 0.65, Paths.image("menus/titlescreen/titleEnter")));
	start.addAnim("gay", "Press Enter to Begin", 24, true);
	start.playAnim("gay");
	start.setGraphicSize(start.width * 0.9);
	start.updateHitbox();
	start.screenCenter(FlxAxes.X);
}

var trans:Bool = false;

function update(elapsed) {
	if (controls.ACCEPT) {
		if (!trans) { //no trans???
			trans = true; // nvm yes trans
			CoolUtil.playMenuSFX(1);
			FlxG.camera.flash(FlxG.random.bool(50) ? 0xFFFF00FF : 0xFF00FFFF);
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1.5, {startDelay: 1.3, ease: FlxEase.expoInOut});
			new FlxTimer().start(1.75, () -> FlxG.camera.fade(FlxColor.BLACK, 0.75));
			new FlxTimer().start(2.8, () -> FlxG.switchState(new MainMenuState()));
		} else {
			FlxG.switchState(new MainMenuState());
		}
	}
}

function beatHit() {
	logo.playAnim("bop");
}