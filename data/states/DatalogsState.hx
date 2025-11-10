var chars:Array<String> = ["Boyfriend", "Girlfriend", "Daddy Dearest"];
var curSelected:Int = 0;

var pink_box:FunkinSprite;
var blue_box:FunkinSprite;
var capsule:FunkinSprite;
var charTxt:FunkinText;
var bioTxt:FunkinText;
var charRender:FunkinSprite;

function create() {
    var bg = add(new FunkinSprite(0, 0, Paths.image("menus/datalogs/Background_datalog")));
    bg.setGraphicSize(FlxG.width * 1.05, FlxG.height * 1.05);
    bg.screenCenter();
    bg.updateHitbox();

    pink_box = add(new FunkinSprite(FlxG.width * 0.035, 0, Paths.image("menus/datalogs/pink_box")));
    pink_box.screenCenter(FlxAxes.Y);

    blue_box = add(new FunkinSprite(FlxG.width * 0.425, 0, Paths.image("menus/datalogs/blue_box")));
    blue_box.setGraphicSize(blue_box.width * 0.9);
    blue_box.updateHitbox();
    blue_box.screenCenter(FlxAxes.Y);

    capsule = add(new FunkinSprite(pink_box.x + 5, -15, Paths.image("menus/datalogs/capsule")));
    capsule.addAnim("open", "capsule open", 24, false);
    capsule.addAnim("close", "capsule close", 24, false);
    capsule.playAnim("open");

    charTxt = add(new FunkinText(0, 62, blue_box.width - 145, "", 30));
    charTxt.alignment = "center";

    bioTxt = add(new FunkinText(pink_box.x + 72, pink_box.y + 70, pink_box.width - 170, "", 20));
    bioTxt.alignment = "center";

    charRender = add(new FunkinSprite());

    changeSelection();
}

function update(elapsed) {
    if (controls.LEFT_P) changeSelection(-1);
    if (controls.RIGHT_P) changeSelection(1);
    if (controls.BACK) FlxG.switchState(new MainMenuState());
}

function changeSelection(amt:Int = 0) {
    curSelected = FlxMath.wrap(curSelected + amt, 0, chars.length - 1);
    charRender.loadGraphic(Paths.image("menus/datalogs/characters/" + chars[curSelected].toLowerCase()));
    charRender.setPosition(blue_box.x + ((blue_box.width - charRender.width) / 2), blue_box.y + ((blue_box.height - charRender.height) / 2));
    charTxt.text = chars[curSelected];
    bioTxt.text = Assets.getText(Paths.txt("datalogs/" + chars[curSelected].toLowerCase()));
    bioTxt.y = (blue_box.y + (blue_box.height - bioTxt.height) - 100);
}