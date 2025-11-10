// i might make some notes how this works, this is probs the sloppiest code in the mod
import flixel.math.FlxRect;
import flixel.util.FlxStringUtil;

var thingiebf:FunkinSprite;
var thingiedad:FunkinSprite;

var smoothHealthEpik:Float = 1;
var smoothScoreEpik:Float = 0;

function onPostCountdown(e)
	e?.sprite?.zoomFactor = 0; // It says there's an error in the terminal but is still works

function create() {
    PauseSubState.script = 'data/scripts/pause';
    playCutscenes = true;
    comboGroup.cameras = [camHUD];
    comboGroup.setPosition(FlxG.width / 2 - 50, 200);
}

function postCreate() {
    if (FlxG.save.data.neoui) {
        var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
        var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);

        for (fuckyou in [healthBar, healthBarBG]) fuckyou.visible = false;

        healthBarBG = insert(PlayState.instance.members.indexOf(iconP1), new FunkinSprite(0, FlxG.height * 0.78, Paths.image("game/neoHealthBarBG")));
        healthBarBG.setGraphicSize(healthBarBG.width * 0.68);
        healthBarBG.updateHitbox();
        healthBarBG.screenCenter(FlxAxes.X);
        healthBarBG.camera = camHUD;

        var neoHealthBarBF = insert(PlayState.instance.members.indexOf(healthBarBG), new FunkinSprite(0, 0, Paths.image("game/neoHealthBar")));
        neoHealthBarBF.setGraphicSize(neoHealthBarBF.width * 0.68);
        neoHealthBarBF.setPosition(((healthBarBG.width - neoHealthBarBF.width) / 2) + healthBarBG.x, ((healthBarBG.height * 1.1 - neoHealthBarBF.height) / 2) + healthBarBG.y);
        neoHealthBarBF.color = rightColor;
        neoHealthBarBF.camera = camHUD;

        var neoHealthBarDad = insert(PlayState.instance.members.indexOf(healthBarBG), new FunkinSprite(0, 0, Paths.image("game/neoHealthBar")));
        neoHealthBarDad.setGraphicSize(neoHealthBarDad.width * 0.68);
        neoHealthBarDad.setPosition(((healthBarBG.width - neoHealthBarDad.width) / 2) + healthBarBG.x, ((healthBarBG.height * 1.1 - neoHealthBarDad.height) / 2) + healthBarBG.y);
        neoHealthBarDad.color = leftColor;
        neoHealthBarDad.camera = camHUD;
        neoHealthBarDad.onDraw = function(spr) {
            neoHealthBarDad.clipRect = new FlxRect(0, 0, ((1 - (smoothHealthEpik / 2)) / 1) * neoHealthBarDad.width, healthBarBG.height);
            neoHealthBarDad.draw();
        };

        for (meowmeow in [neoHealthBarBF, neoHealthBarDad])
            if (downscroll)
                meowmeow.y -= 13;

        thingiebf = insert(PlayState.instance.members.indexOf(iconP1), new FunkinSprite(0, 0, Paths.image("game/thingiebf")));
        thingiebf.setGraphicSize(thingiebf.width * 0.68);
        thingiebf.updateHitbox();
        thingiebf.color = rightColor;
        thingiebf.setPosition(((healthBarBG.width * 1.856 - thingiebf.width) / 2) + healthBarBG.x, ((healthBarBG.height - thingiebf.height) / 2) + healthBarBG.y);
        thingiebf.camera = camHUD;

        thingiedad = insert(PlayState.instance.members.indexOf(iconP2), new FunkinSprite(0, 0, Paths.image("game/thingiedad")));
        thingiedad.setGraphicSize(thingiedad.width * 0.68);
        thingiedad.updateHitbox();
        thingiedad.color = leftColor;
        thingiedad.setPosition(((healthBarBG.width * 0.1456 - thingiedad.width) / 2) + healthBarBG.x, ((healthBarBG.height - thingiedad.height) / 2) + healthBarBG.y);
        thingiedad.camera = camHUD;
    }
}

function postUpdate(elapsed) {
    if (FlxG.save.data.neoui) {
        smoothHealthEpik = lerp(smoothHealthEpik, health, 0.25);
        smoothScoreEpik = lerp(smoothScoreEpik, songScore, 0.25);

        scoreTxt.text = "Score:" + FlxStringUtil.formatMoney(smoothScoreEpik == 0 ? 0 : smoothScoreEpik + 1, false);

        iconP1.setPosition(((thingiebf.width - iconP1.width) / 2) + thingiebf.x, ((thingiebf.height - iconP1.height) / 2) + thingiebf.y);
        iconP2.setPosition(((thingiedad.width - iconP2.width) / 2) + thingiedad.x, ((thingiebf.height - iconP2.height) / 2) + thingiedad.y);
    }
}

function onNoteHit(event):Void {
    if (event.note.isSustainNote)
        event.showSplash = true;
    event.ratingScale *= 0.7;
    event.numScale *= 0.7;
}
function onPostNoteHit(event):Void {
    for (item in comboGroup)
        item.cameras = comboGroup.cameras;
}

function onSplashShown(event):Void {
    if (event.splashName == 'default') {
        event.splash.stopAnim();
        FlxTween.cancelTweensOf(event.splash);
        event.splash.scale.set(0.7, 0.7);
        event.splash.angle = event.strum.angle; event.splash.alpha = 1;
        FlxTween.tween(event.splash, {
            alpha: 0,
            'scale.x': event.splash.scale.x * 1.5,
            'scale.y': event.splash.scale.y * 1.5,
            y: event.splash.y - 17
        }, Conductor.stepCrochet / 1000 * 4, {
            ease: FlxEase.smootherStepOut,
            onComplete: () -> event.splash?.animation?.finishCallback(event.splash?.getAnimName())
        });
    }
}