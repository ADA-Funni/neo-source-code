// script by @rodney528

import ColorHelp;

var options = {
	alphaMult: 0.7,
	blendMode: 'add',
	fadeTime: 0.2,
	easeType: 'expoIn'
}

function postCreate():Void
	for (strumLine in strumLines)
		for (character in strumLine.characters)
			character.extra.set('isAfterImage', false);

function causesAfterImagesOnJumps(char:Character):Bool {
	if (char?.extra?.exists('causesAfterImagesOnJumps'))
		return char?.extra?.get('causesAfterImagesOnJumps') == 'true';
	return false;
}
function onNoteHit(event):Void {
	if (event.note.extra.exists('animCancelled'))
		event.animCancelled = event.note.extra.get('animCancelled');

	var trigger:Bool = false;
	for (char in event.characters) {
		var result:Bool = causesAfterImagesOnJumps(char);
		if (result) trigger = true;
	}
	if (trigger && !event.note.isSustainNote) {
		final prevNote:Note = event.note.strumLine.extra.exists('prevNote') ? event.note.strumLine.extra.get('prevNote') : null;
		final noAnim:Bool = event.animCancelled;
		final prevNoAnim:Bool = prevNote != null ? (prevNote.extra.exists('animCancelled') ? prevNote.extra.get('animCancelled') : false) : false;
		if (prevNote != null && ((!noAnim && prevNoAnim) || (noAnim && !prevNoAnim) || (!noAnim && !prevNoAnim))) {
			if (prevNote.strumTime == event.note.strumTime && prevNote.noteData != event.note.noteData) {
				final setNote:Note = getSustainLength(prevNote) > getSustainLength(event.note) ? event.note : prevNote;
				if (setNote == event.note) event.animCancelled = true;
				sustainLoop(setNote, (note:Note) -> note.extra.set('animCancelled', event.animCancelled), true);
				for (char in event.characters) { // character sing
					if (causesAfterImagesOnJumps(char)) {
						if (setNote != event.note && !event.animCancelled) {
							char.playSingAnim(prevNote.noteData, event.animSuffix, 'SING');
							char.lastHit = Conductor.songPosition;
						}
						setupAfterImage(char, setNote, event.animSuffix);
					}
				}
			}
		}
		event.note.strumLine.extra.set('prevNote', event.note);
	}

	var afterImages:Array<Character> = getAfterImagesArray(event.note);
	if (afterImages.length != 0) {
		if (event.note.extra.exists('animCancelled'))
			if (event.note.extra.get('animCancelled'))
				event.animCancelled = false;
		event.characters = afterImages;
	}

	event.note.extra.set('animCancelled', event.animCancelled);
}

function checkAfterImageGroup(char:Character):FlxGroup
	return char.extra.exists('afterImageGroup') ? char.extra.get('afterImageGroup') : new FlxGroup();
function grabAfterImage(char:Character):Character {
	var group:FlxGroup = checkAfterImageGroup(char);
	var image:Character = group.recycle(Character, () -> new Character(char.x, char.y, char.curCharacter, char.isPlayer), true);
	image.extra.set('charParent', char);
	image.extra.set('isAfterImage', true);
	if (!group.members.contains(image))
		group.add(image);

	image.x = char.x;
	image.y = char.y;
	image.flipX = char.flipX;
	image.flipY = char.flipY;
	image.scale.x = char.scale.x;
	image.scale.y = char.scale.y;
	image.alpha = char.alpha * options.alphaMult;
	image.shader = char.shader;
	image.cameras = char.cameras;
	image.danceOnBeat = false;

	// Tell me if there's anything else I should add!
	image.blend = switch (StringTools.trim(options.blendMode.toLowerCase())) {
		case 'add': 0;
		case 'alpha': 1;
		case 'darken': 2;
		case 'difference': 3;
		case 'erase': 4;
		case 'hardlight': 5;
		case 'invert': 6;
		case 'layer': 7;
		case 'lighten': 8;
		case 'multiply': 9;
		default: 10;
		case 'overlay': 11;
		case 'screen': 12;
		case 'shader': 13;
		case 'subtract': 14;
	}

	var imageColor:ColorHelp = new ColorHelp(char.iconColor ?? FlxColor.WHITE);
	imageColor.red = FlxMath.bound(imageColor.red + 50, 0, 255);
	imageColor.green = FlxMath.bound(imageColor.green + 50, 0, 255);
	imageColor.blue = FlxMath.bound(imageColor.blue + 50, 0, 255);
	image.color = imageColor.color;
	return image;
}

function setupAfterImage(mainChar:Character, note:Note, ?animSuffix:String):Character {
	animSuffix ??= '';
	if (mainChar == null || !mainChar.visible || mainChar.alpha < 1 || mainChar.animateAtlas != null) return;

	var imageGroup:FlxGroup = checkAfterImageGroup(mainChar);
	var afterImage:Character = grabAfterImage(mainChar);

	var group = FlxTypedGroup.resolveGroup(mainChar) ?? this;
	group.insert(group.members.indexOf(mainChar), afterImage);

	afterImage.playSingAnim(note.noteData, animSuffix, 'LOCK');
	afterImage.lastHit = Conductor.songPosition;
	sustainLoop(note, (note:Note) -> {
		if (note.extra.exists('afterImages'))
			note.extra.get('afterImages').push(afterImage);
		else
			note.extra.set('afterImages', [afterImage]);
	}, true);

	FlxTween.tween(afterImage, {alpha: 0}, options.fadeTime, {
		// ease: LuaUtils.getTweenEaseByString(options.easeType),
		startDelay: (getSustainLength(note) / 1000) - (options.fadeTime / 2),
		onComplete: (_:FlxTween) -> {
			group.remove(afterImage);
			afterImage.kill();
			new FlxTimer().start(5, () -> afterImage.destroy());
		}
	});
	return afterImage;
}

function getAfterImagesArray(note:Note):Array<Character>
	return note.extra.exists('afterImages') ? note.extra.get('afterImages') : [];
function getSustainLength(note:Note):Float {
	var length:Float = 0;
	sustainLoop(note.nextNote, (sustain:Note) -> length += sustain.sustainLength, true);
	return length;
}
function sustainLoop(note:Note, func:Note->Void, ?noEffectParent:Bool):Void {
	var aNote:Note = note;
	noEffectParent ??= false;
	while (aNote != null) {
		if (noEffectParent ? aNote != note : true)
			func(aNote);
		aNote = aNote.nextSustain;
	}
}