import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;
import flixel.math.FlxBasePoint;

var botplayTxts:Array<FlxText> = [];
static var curBotplay:Bool = false;
curBotplay = false;

function postCreate() {
	for (strumLine in strumLines) {
		strumLine.extra.set('botplayTxt', new FlxText(0, 0, null, '', 27));
		var botplayTxt:FlxText = strumLine.extra.get('botplayTxt');
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 27, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.visible = curBotplay;
		botplayTxt.borderSize = 1.25;
		botplayTxt.camera = camHUD;
		add(botplayTxt);
	}
}

var leAlpha:Float = 0;
function setBotplayTxtsAlpha(input:Float) {
	for (strumLine in strumLines) {
		strumLine.extra.get('botplayTxt')?.alpha = input;
	}
}

public var botplaySine:Float = 0;
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.F4) curBotplay = !curBotplay;
	for (strumLine in strumLines) {
		var botplayTxt:FlxText = strumLine.extra.get('botplayTxt');
		if (!strumLine.opponentSide) {
			strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
			botplayTxt.visible = curBotplay;
		}
		// stole from cne source lmao
		var pos = new FlxBasePoint();
		var scale = new FlxBasePoint();
		var r = 0;
		for (c in strumLine) {
			if (c == null || !c.visible) continue;
			var cpos = {x: c.getMidpoint().x - 70, y: c.getMidpoint().y - 15};
			var spos = {x: c.scale.x, y: c.scale.y};
			pos.x += cpos.x;
			pos.y += cpos.y;
			scale.x += spos.x;
			scale.y += spos.y;
			r++;
			//cpos.put();
		}
		if (r > 0) {
			pos.x /= r;
			pos.y /= r;
			scale.x /= r;
			scale.y /= r;
			
			botplayTxt.setPosition(pos.x, pos.y);
			botplayTxt.scale.set(scale.x * 1.43, scale.y * 1.43);
		}
		pos.put();
		scale.put();
	}
	if (curBotplay) {
		botplaySine += 180 * elapsed;
		leAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		setBotplayTxtsAlpha(leAlpha);
	}
}