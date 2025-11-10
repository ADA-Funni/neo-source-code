// script by @rodney528

import ColorHelp;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import objects.Particle;

public var lightsActive:Bool = false;

// color stuff
var colorTagList:Array<String> = ['lime', 'yellow', 'red', 'cyan', 'magenta'];
var neonColors:Array<ColorHelp> = [new ColorHelp(FlxColor.LIME), new ColorHelp(FlxColor.YELLOW), new ColorHelp(FlxColor.RED), new ColorHelp(FlxColor.CYAN), new ColorHelp(FlxColor.MAGENTA)];
var curLight:Null<ColorHelp> = null;

// object and shiz
var gradient:FlxBackdrop;
var originalY, originalHeight = 0;
var particles:FlxGroup;

function create():Void {
	gradient = new FlxBackdrop(FlxGradient.createGradientBitmapData(5, originalHeight = 700, [FlxColor.TRANSPARENT, FlxColor.WHITE]), FlxAxes.X);
	gradient.scrollFactor.set(0, 1);
	var layer = stage.getSprite('gradient_layer');
	originalY = gradient.y = (layer == null ? gf.y : layer.y) - gradient.height;
	insert(members.indexOf(layer == null ? gf : layer), gradient);
	gradient.visible = false;

	particles = new FlxGroup();
	particles.add(new Particle());
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
		gradient.alpha = 1;
		gradient.setGraphicSize(5, newHeight);
		gradient.updateHitbox();
		gradient.y = originalY + (originalHeight - gradient.height);
	} else gradient.alpha = 0;

	particles.forEachAlive((particle) -> {
		if (particle.alpha <= 0) {
			particle.kill();
			if (members.contains(particle))
				remove(particle);
		}
	});
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
				trace(curLight.toString());

				gradient.setGraphicSize(5, originalHeight);
				gradient.updateHitbox();
				gradient.y = originalY;
				gradient.alpha = 1;

				var charColor:ColorHelp = new ColorHelp(curLight.color);
				charColor.saturation *= 0.5;
				for (strumLine in strumLines)
					for (character in strumLine.characters)
						character.color = charColor.color;
				gradient.color = curLight.color;

				for (i in members) {
					if (i is Particle) {
						if (members.contains(i)) {
							i.kill();
							remove(i);
						}
					}
				}
				var particlesNum:Int = FlxG.random.int(12, 30);
				var width:Float = (2000 / particlesNum);
				var total:Int = 0;
				for (j in 0...3) {
					for (i in 0...particlesNum) {
						total++;
						if (total > 40) break;
						var particle:Particle = particles.recycle(Particle, () -> new Particle());
						particle.setPosition(
							FlxG.random.float(camera.scroll.x * camera.zoom, camera.width / camera.zoom),
							FlxG.random.float(camera.scroll.y * camera.zoom, camera.height / camera.zoom)
						);
						if (!particles.members.contains(particle))
							particles.add(particle);
						if (!members.contains(particle))
							insert(FlxG.random.int(0, members.length - 1), particle);
						particle.start();
						particle.color = curLight.color;
					}
				}
				if (!prevActive) {
					doFlash();
					if (Options.camZoomOnBeat) {
						FlxG.camera.zoom += 0.5;
						camHUD.zoom += 0.1;
					}
				}
			} else {
				for (strumLine in strumLines)
					for (character in strumLine.characters)
						character.color = FlxColor.WHITE;
				if (prevActive) {
					for (i in members) {
						if (i.lifeTime != null) {
							if (members.contains(i)) {
								i.kill();
								remove(i);
							}
						}
					}
					doFlash();
					if (Options.camZoomOnBeat) {
						FlxG.camera.zoom += 0.5;
						camHUD.zoom += 0.1;
					}
				}
			}
			particles.visible = gradient.visible = lightsActive;
			trace('Activated: ' + lightsActive);
	}
}

function doFlash():Void {
	var color:FlxColor = FlxColor.WHITE;
	// if (!ClientPrefs.data.flashing) color.alphaFloat = 0.5;
	FlxG.camera.flash(color, 0.15, null, true);
}