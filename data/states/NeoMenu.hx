import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;

import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;

import funkin.backend.system.Flags;

import flixel.effects.FlxFlicker;

var menuItems:Array<Dynamic> = [
    {
        name: "story mode",
        pos: [120, 30],
        selectOffset: [-0.85, 7.5],
        callback: function() {
            FlxG.switchState(new StoryMenuState());
        },
        left: true
    },
    {
        name: "freeplay",
        pos: [240, 200],
        selectOffset: [-0.85, 7.5],
            callback: function() {
            FlxG.switchState(new FreeplayState());
        },
        left: true
    },
    {
        name: "credits",
        pos: [120, 370],
        selectOffset: [-0.85, 7.5],
        callback: function() {
            FlxG.switchState(new CreditsMain());
        },
        left: true
    },
    {
        name: "datalogs",
        pos: [50, 540],
        selectOffset: [-0.85, 7.5],
        callback: function() {
            FlxG.switchState(new ModState("DatalogsState"));
        },
        left: true
    },
    {
        name: "options",
        pos: [1130, 575],
        selectOffset: [0, 5],
        callback: function() {
            FlxG.switchState(new OptionsMenu());
        },
        left: false
    }
];
var menuObjects:FlxTypedGroup;

var curSelected:Int = 0;
var canSelect:Bool = true;

function create() {
    CoolUtil.playMenuSong();

    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/mainmenu/background_with_grid")));

    var sunset = add(new FunkinSprite(-FlxG.width * 2, FlxG.width * -0.065, Paths.image("menus/mainmenu/sunset")));
    FlxTween.tween(sunset, {x: FlxG.width * -0.42}, 2, {ease: FlxEase.quintOut, onComplete: function() {
        sunset.playAnim("sunset");
    }});
    sunset.addAnim("sunset", "sunset", 12, false);
    sunset.setGraphicSize(sunset.width * 1.05);
    sunset.updateHitbox();

    add(menuObjects = new FlxTypedGroup());

    for (i => item in menuItems) {
        // var objl = add(new FunkinSprite(item.pos[0], item.pos[1], Paths.image("menus/mainmenu/capsules/" + item.name)));
        // objl.addAnim("idle", item.name + " capsule", 24, false);
        // objl.addAnim("select", item.name + " select", 24, false);
        // objl.color = FlxColor.BLACK;
        // objl.playAnim("idle");

        var obj = menuObjects.add(new FunkinSprite(item.left ? -FlxG.width * 2 : FlxG.width * 2, item.pos[1], Paths.image("menus/mainmenu/capsules/" + item.name)));
        FlxTween.tween(obj, {x: item.pos[0]}, 2 + (i * 0.1), {ease: FlxEase.quintOut, startDelay: 0.5 + (i * 0.1)});
        obj.addAnim("idle", item.name + " capsule", 24, false);
        obj.addAnim("select", item.name + " select", 24, false);
        obj.addOffset("select", item.selectOffset[0], item.selectOffset[1]);
        obj.playAnim("idle");
    }

    var versionText = add(new FunkinText(5, 0, 0, neoVersion + "\n" + Flags.VERSION_MESSAGE, 22));
    versionText.y = FlxG.height - versionText.height - 5;
}

function update(elapsed) {
    if (FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = !(persistentDraw = true);
        openSubState(new EditorPicker());
    }

    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = !(persistentDraw = true);
    }

    if (controls.UP_P) {
            CoolUtil.playMenuSFX();
            curSelected = FlxMath.wrap(curSelected - 1, 0, menuObjects.length - 1);
    }
    if (controls.DOWN_P){
        CoolUtil.playMenuSFX();
        curSelected = FlxMath.wrap(curSelected + 1, 0, menuObjects.length - 1);
    }

    if (controls.BACK) {
        FlxG.switchState(new TitleState());
    }
    if ((controls.ACCEPT || FlxG.mouse.justPressed) && canSelect){
        canSelect = false;
        
        CoolUtil.playMenuSFX(1);
        FlxG.camera.flash(FlxG.random.bool(50) ? 0xFFFF00FF : 0xFF00FFFF);
        FlxFlicker.flicker(menuObjects.members[curSelected]);
        for (i => obj in menuObjects.members)   if (i != curSelected) FlxTween.tween(obj, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        new FlxTimer().start(1, function() {
            menuItems[curSelected].callback();
        });
    }

    for (i => obj in menuObjects.members) {
        if (curSelected != i && FlxG.mouse.overlaps(obj) && canSelect) {
            curSelected = i;
            CoolUtil.playMenuSFX();
        }

        var animToPlay:String = i == curSelected ? "select" : "idle";

        if (obj.animation.curAnim.name != animToPlay) {
            obj.playAnim(animToPlay);
        }
    }
}