import std.Xml;

var creditsTxt:FunkinText;

function create() {
    CoolUtil.playMusic(Paths.music("makeUproud"), false);

    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/credits/bg")));
    bg.screenCenter(FlxAxes.X);

    var cuties = add(new FunkinSprite(0, FlxG.height * 0.45, Paths.image("menus/credits/bf and gf date")));
    cuties.addAnim("loop", "loop", 24, true);
    cuties.playAnim("loop");

    creditsTxt = add(new FunkinText(0, FlxG.height, FlxG.width, "", 20));
    creditsTxt.alignment = "center";
    creditsTxt.alpha = 0.75;

    pushCreditShit("credits");
}

function update(elapsed) {
    if (controls.BACK) FlxG.switchState(new MainMenuState());

    FlxG.camera.zoom = lerp(FlxG.camera.zoom, 1, 0.15);
    FlxG.camera.angle = lerp(FlxG.camera.angle, 0, 0.15);
    creditsTxt.y += (FlxG.mouse.wheel > 0) ? -30 : (FlxG.mouse.wheel < 0 ? 30 : -0.5) * 60 * elapsed;
    if (creditsTxt.y < (creditsTxt.height - FlxG.height) * -3.2) creditsTxt.y = FlxG.height; //should probs softcode this math at some point... oh well!
}

var bleh:Bool = true;

function beatHit() {
    // if (curBeat % 2 == 0) {
    //     bleh = !bleh;
    //     FlxG.camera.zoom += 0.025;
    //     FlxG.camera.angle += bleh ? 0.5 : -0.5;
    // }
}

/**
 * Just Makes The Credits Show Up On The Credits Text, The System Is Really Retarded But... Works
 * @param xmlName What XML The Credits Will Push From
 */
function pushCreditShit(xmlName:String = "credits") {
    var data:Xml = Xml.parse(Assets.getText(Paths.file("data/config/" + xmlName + ".xml"))).firstElement();
    
    for (shit in data.elements()) {
        if (shit.nodeName != "role") return;
        
        creditsTxt.text += "\n\n" + shit.get("name") + ":";

        for (shittiershit in shit.elements())
            creditsTxt.text += "\n" + shittiershit.get("name");
    }
}