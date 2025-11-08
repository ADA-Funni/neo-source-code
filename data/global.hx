import funkin.backend.utils.WindowUtils;

public static var neoVersion = "Neo R DEMO";

function new() {
    if (FlxG.save.data.neoui == null) FlxG.save.data.neoui = true;

    if (FlxG.save.data.kadedev == null) FlxG.save.data.kadedev = true;
    if (FlxG.save.data.healthdrain == null) FlxG.save.data.healthdrain = 1;

    if (FlxG.save.data.glitchy == null) FlxG.save.data.glitchy = true;
    if (FlxG.save.data.glitchyvalue == null) FlxG.save.data.glitchyvalue = 4;
}

function preStateSwitch() {
    WindowUtils.setWindow("Friday Night Funkin' - Neo", "icon");
}