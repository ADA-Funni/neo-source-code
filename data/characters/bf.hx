function postCreate():Void {
	if (isPlayer != playerOffsets && __switchAnims) {
		CoolUtil.switchAnimFrames(animation.getByName('singRIGHT-alt'), animation.getByName('singLEFT-alt'));
		switchOffset('singLEFT-alt', 'singRIGHT-alt');
	}
}