class ColorHelp {
	public var color:FlxColor;

	// rgba
	public var red(get, set):Int;
	public var green(get, set):Int;
	public var blue(get, set):Int;
	public var alpha(get, set):Int;

	public function get_red():Int {
		return (color >> 16) & 0xff;
	}
	public function get_green():Int {
		return (color >> 8) & 0xff;
	}
	public function get_blue():Int {
		return color & 0xff;
	}
	public function get_alpha():Int {
		return (color >> 24) & 0xff;
	}

	public function set_red(value:Int):Int {
		color &= 0xff00ffff;
		color |= boundChannel(value) << 16;
		return get_red();
	}
	public function set_green(value:Int):Int {
		color &= 0xffff00ff;
		color |= boundChannel(value) << 8;
		return get_green();
	}
	public function set_blue(value:Int):Int {
		color &= 0xffffff00;
		color |= boundChannel(value);
		return get_blue();
	}
	public function set_alpha(value:Int):Int {
		color &= 0x00ffffff;
		color |= boundChannel(value) << 24;
		return get_alpha();
	}

	// rgba float
	public var redFloat(get, set):Float;
	public var greenFloat(get, set):Float;
	public var blueFloat(get, set):Float;
	public var alphaFloat(get, set):Float;

	public function get_redFloat():Float
		return get_red() / 255;
	public function get_greenFloat():Float
		return get_green() / 255;
	public function get_blueFloat():Float
		return get_blue() / 255;
	public function get_alphaFloat():Float
		return get_alpha() / 255;

	public function set_redFloat(value:Float):Float
		return set_red(Math.round(value * 255));
	public function set_greenFloat(value:Float):Float
		return set_green(Math.round(value * 255));
	public function set_blueFloat(value:Float):Float
		return set_blue(Math.round(value * 255));
	public function set_alphaFloat(value:Float):Float
		return set_alpha(Math.round(value * 255));

	// cmyk
	public var cyan(get, set):Float;
	public var magenta(get, set):Float;
	public var yellow(get, set):Float;
	public var black(get, set):Float;

	public function get_cyan():Float {
		return (1 - get_redFloat() - get_black()) / get_brightness();
	}
	public function get_magenta():Float {
		return (1 - get_greenFloat() - get_black()) / get_brightness();
	}
	public function get_yellow():Float {
		return (1 - get_blueFloat() - get_black()) / get_brightness();
	}
	public function get_black():Float
		return 1 - get_brightness();

	public function set_cyan(value:Float):Float
	{
		setCMYK(value, get_magenta(), get_yellow(), get_black(), get_alphaFloat());
		return value;
	}
	public function set_magenta(value:Float):Float
	{
		setCMYK(get_cyan(), value, get_yellow(), get_black(), get_alphaFloat());
		return value;
	}
	public function set_yellow(value:Float):Float
	{
		setCMYK(get_cyan(), get_magenta(), value, get_black(), get_alphaFloat());
		return value;
	}
	public function set_black(value:Float):Float
	{
		setCMYK(get_cyan(), get_magenta(), get_yellow(), value, get_alphaFloat());
		return value;
	}

	// hsb/l
	public var hue(get, set):Float;
	public var brightness(get, set):Float;
	public var saturation(get, set):Float;
	public var lightness(get, set):Float;

	public function get_hue():Float {
		var hueRad = Math.atan2(Math.sqrt(3) * (get_greenFloat() - get_blueFloat()), 2 * get_redFloat() - get_greenFloat() - get_blueFloat());
		var hue:Float = 0;
		if (hueRad != 0)
			hue = 180 / Math.PI * hueRad;
		return hue < 0 ? hue + 360 : hue;
	}
	public function get_brightness():Float
		return maxColor();
	public function get_saturation():Float {
		return (maxColor() - minColor()) / get_brightness();
	}
	public function get_lightness():Float {
		return (maxColor() + minColor()) / 2;
	}

	public function set_hue(value:Float):Float
	{
		setHSB(value, get_saturation(), get_brightness(), get_alphaFloat());
		return value;
	}
	public function set_saturation(value:Float):Float
	{
		setHSB(get_hue(), value, get_brightness(), get_alphaFloat());
		return value;
	}
	public function set_brightness(value:Float):Float
	{
		setHSB(get_hue(), get_saturation(), value, get_alphaFloat());
		return value;
	}
	public function set_lightness(value:Float):Float
	{
		setHSL(get_hue(), get_saturation(), value, get_alphaFloat());
		return value;
	}

	public function new(color:FlxColor)
		this.color = color;

	public function setCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, ?Alpha:Float):FlxColor {
		set_redFloat((1 - Cyan) * (1 - Black));
		set_greenFloat((1 - Magenta) * (1 - Black));
		set_blueFloat((1 - Yellow) * (1 - Black));
		set_alphaFloat(Alpha ?? 1);
		return color;
	}
	public function setHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float):FlxColor {
		var chroma = Brightness * Saturation;
		var match = Brightness - chroma;
		return setHueChromaMatch(Hue, chroma, match, Alpha);
	}
	public function setHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float):FlxColor {
		var chroma = (1 - Math.abs(2 * Lightness - 1)) * Saturation;
		var match = Lightness - chroma / 2;
		return setHueChromaMatch(Hue, chroma, match, Alpha);
	}

	public function setRGBFloat(Red:Float, Green:Float, Blue:Float, ?Alpha:Float):FlxColor {
		set_redFloat(Red);
		set_greenFloat(Green);
		set_blueFloat(Blue);
		set_alphaFloat(Alpha ?? 1);
		return this;
	}

	private function setHueChromaMatch(Hue:Float, Chroma:Float, Match:Float, Alpha:Float):FlxColor {
		Hue %= 360;
		var hueD = Hue / 60;
		var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + Match;
		Chroma += Match;

		switch (Std.int(hueD))
		{
			case 0:
				setRGBFloat(Chroma, mid, Match, Alpha);
			case 1:
				setRGBFloat(mid, Chroma, Match, Alpha);
			case 2:
				setRGBFloat(Match, Chroma, mid, Alpha);
			case 3:
				setRGBFloat(Match, mid, Chroma, Alpha);
			case 4:
				setRGBFloat(mid, Match, Chroma, Alpha);
			case 5:
				setRGBFloat(Chroma, Match, mid, Alpha);
		}

		return this;
	}

	private function maxColor():Float
		return Math.max(get_redFloat(), Math.max(get_greenFloat(), get_blueFloat()));

	private function minColor():Float
		return Math.min(get_redFloat(), Math.min(get_greenFloat(), get_blueFloat()));

	private function boundChannel(value:Int):Int
		return value > 0xff ? 0xff : value < 0 ? 0 : value;
}