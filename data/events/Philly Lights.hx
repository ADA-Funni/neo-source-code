// script by @rodney528

import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import objects.Particle;
import utils.ColorHelp;

public var lightsActive:Bool = false;

// color stuff
var colorTagList:Array<String> = ['lime', 'magenta', 'pink', 'blue', 'cyan'];
var neonColors:Array<ColorHelp> = [new ColorHelp(FlxColor.LIME), new ColorHelp(FlxColor.MAGENTA), new ColorHelp(0xFFF170F8), new ColorHelp(0xFF3D5A9E), new ColorHelp(FlxColor.CYAN)];
var curLight:Null<ColorHelp> = null;

// object and shiz
var gradient:FlxBackdrop;
var originalY:Float, originalHeight:Float = 0;
var particles:FlxGroup;

var darkCharacters:Array<Character> = [];

function create():Void {
	// camera.alpha = 0.5;
	gradient = new FlxBackdrop(FlxGradient.createGradientBitmapData(5, originalHeight = stage.extra.exists('phillyLights_gradientHeight') ? stage.extra.get('phillyLights_gradientHeight') : 500, [FlxColor.TRANSPARENT, FlxColor.WHITE]), FlxAxes.X);
	gradient.scrollFactor.set(0, 1);
	var layer = stage.extra.exists('phillyLights_gradientLayerAsset') ? stage.getSprite(stage.extra.get('phillyLights_gradientLayerAsset')) : gf;
	originalY = gradient.y = (stage.extra.exists('phillyLights_bottomY') ? Std.parseFloat(stage.extra.get('phillyLights_bottomY')) : gf.y) - (layer == gf ? gf.height : originalHeight);
	insert(members.indexOf(layer), gradient);
	gradient.visible = false;

	particles = new FlxGroup();
	if (!Options.lowMemoryMode) particles.add(new Particle());
	if (stage.extra.exists('phillyLights_particleLayerAsset'))
		insert(members.indexOf(stage.getSprite(stage.extra.get('phillyLights_particleLayerAsset'))), particles);
	else add(particles);

	for (strumline in strumLines.members) {
		var chars = strumline.characters.copy();
		for (char in chars) {
			char.extra.set('isDarkChar', false);
			var darkChar = new Character(char.x, char.y, char.curCharacter + "-dark", char.isPlayer);
			darkChar.extra.set('isDarkChar', true);
			if (darkChar.curCharacter == 'bf' && char.curCharacter != 'bf') {
				darkChar.destroy();
				char.extra.set('hasDarkLoaded', false);
				continue;
			}
			char.extra.set('hasDarkLoaded', true);
			darkChar.cameraOffset.set(char.cameraOffset.x, char.cameraOffset.y);
			darkChar.visible = false;
			darkCharacters.push(darkChar);
			strumline.characters.push(darkChar);
			insert(members.indexOf(char) + 1, darkChar);
		}
	}
}

function beatHit(curBeat:Int):Void {
	if (lightsActive && curBeat % 4 == 0) {
		executeEvent({
			name: 'Philly Lights',
			params: [
				true,
				'Random'
			],
			time: Conductor.songPosition
		});
	}
}

function postUpdate(elapsed:Float):Void {
	var newHeight = Math.round(gradient.height - 1000 * elapsed);
	if (newHeight > 0) {
		gradient.alpha = Options.flashingMenu ? 1 : 0.7;
		gradient.setGraphicSize(5, newHeight);
		gradient.updateHitbox();
		gradient.y = originalY + (originalHeight - gradient.height);
	} else gradient.alpha = 0;

	particles.forEachAlive((particle) ->
		if (particle.alpha <= 0)
			particle.kill()
	);
}

function onEvent(event):Void {
	switch (event.event.name) {
		case 'Philly Lights':
			var prevActive = lightsActive;
			if (lightsActive = event.event.params[0]) {
				switch (event.event.params[1]) {
					case 'Random':
						curLight = neonColors[FlxG.random.int(0, neonColors.length - 1, neonColors.indexOf(neonColors))];
					case 'Manual':
						curLight = neonColors[colorTagList.indexOf(event.event.params[2])];
					default:
				}

				gradient.setGraphicSize(5, originalHeight);
				gradient.updateHitbox();
				gradient.y = originalY;
				gradient.alpha = 1;

				var charColor:ColorHelp = new ColorHelp(curLight.color);
				charColor.saturation *= Options.flashingMenu ? 0.75 : 0.5;
				for (strumLine in strumLines)
					for (character in strumLine.characters)
						character.color = charColor.color;
				gradient.color = curLight.color;

				if (!Options.lowMemoryMode) {
					var particlesNum:Int = FlxG.random.int(12, 30);
					var width:Float = (2000 / particlesNum);
					var total:Int = 0;
					for (j in 0...3) {
						for (i in 0...particlesNum) {
							total++;
							if (total > 40) break;
							var particle:Particle = particles.recycle(Particle, () -> return new Particle());
							particle.setPosition(
								FlxG.random.float(camera.scroll.x * camera.zoom, camera.width / camera.zoom),
								FlxG.random.float(camera.scroll.y * camera.zoom, camera.height / camera.zoom)
							);
							if (!particles.members.contains(particle))
								particles.add(particle);
							particle.start();
							particle.color = curLight.color;
						}
					}
				}
				if (!prevActive) {
					if (Options.camZoomOnBeat) {
						FlxG.camera.zoom += 0.5;
						camHUD.zoom += 0.1;
					}
					if (!gradient.visible)
						doFlash();
					else if (!Options.flashingMenu) {
						var lowerColor = new ColorHelp(curLight.color);
						lowerColor.alphaFloat = 0.25;
						FlxG.camera.flash(lowerColor.color, 0.5, null, true);
					}
				}
			} else {
				for (strumLine in strumLines)
					for (character in strumLine.characters) {
						var colorTint = new ColorHelp(FlxColor.WHITE);
						if (PlayState.variation == 'blacklight') colorTint.cyan = 0.15;
						character.color = colorTint.color;
					}
				if (prevActive) {
					doFlash();
					if (Options.camZoomOnBeat) {
						FlxG.camera.zoom += 0.5;
						camHUD.zoom += 0.1;
					}
				}
			}

			particles.visible = gradient.visible = lightsActive;

			for (spriteName => stageSpr in stage.stageSprites) {
				stageSpr.color = curLight.color;
				if (stageSpr.extra.get('phillyLightAsset'))
					stageSpr.visible = lightsActive;
				else {
					var accountedColor:ColorHelp = new ColorHelp(curLight.color);
					accountedColor.black = 0.8;
					stageSpr.color = lightsActive ? accountedColor.color : FlxColor.WHITE;
				}
			}

			for (strumline in strumLines.members)
				for (char in strumline.characters) {
					char.visible = !(char.extra.get('hasDarkLoaded') && lightsActive);
					if (char.extra.get('isDarkChar'))
						char.iconColor = curLight.color;
				}

			for (char in darkCharacters)
				char.visible = lightsActive;
	}
}

function doFlash():Void {
	var color:ColorHelp = new ColorHelp(FlxColor.WHITE);
	if (!Options.flashingMenu) color.alphaFloat = 0.5;
	FlxG.camera.flash(color.color, 0.15, null, true);
}