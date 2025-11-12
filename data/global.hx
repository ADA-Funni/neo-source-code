import funkin.backend.utils.WindowUtils;

public static var neoVersion = "Neo R DEMO";

function new() {
	FlxG.save.data.neoui ??= true;


	FlxG.save.data.kadedev ??= true;
	FlxG.save.data.healthdrain ??= 1;

	FlxG.save.data.glitchy ??= true;
	FlxG.save.data.glitchyvalue ??= 4;
}

function preStateSwitch() {
	WindowUtils.setWindow("Friday Night Funkin' - Neo", "icon");
}