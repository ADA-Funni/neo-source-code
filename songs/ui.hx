// i might make some notes how this works, this is probs the sloppiest code in the mod
import flixel.math.FlxRect;
import flixel.util.FlxStringUtil;

import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

var thingiebf:FunkinSprite;
var thingiedad:FunkinSprite;
var neoHealthBarBF:FunkinSprite;
var neoHealthBarDad:FunkinSprite;

var songTimeTxt:FunkinText;

public function hideHUD(visible:Bool):Bool {
    for (icon in iconArray)
        icon.visible = visible;
    accuracyTxt.visible = missesTxt.visible = scoreTxt.visible = healthBarBG.visible = visible;
    if (FlxG.save.data.neoui)
        songTimeTxt.visible = thingiebf.visible = thingiedad.visible = neoHealthBarBF.visible = neoHealthBarDad.visible = visible;
    else healthBar.visible = visible;
    return visible;
}

var smoothHealthEpik:Float = 1;
var smoothScoreEpik:Float = 0;

var leftColor:Int;
var rightColor:Int;

function onPostCountdown(e)
    e?.sprite?.zoomFactor = 0;

function create() {
    PauseSubState.script = 'data/scripts/pause';
    playCutscenes = true;
    comboGroup.cameras = [camHUD];
    comboGroup.setPosition(FlxG.width / 2 - 50, 200);
}

function postCreate() {
    if (FlxG.save.data.neoui) {
        leftColor = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
        rightColor = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);

        for (fuckyou in [healthBar, healthBarBG]) fuckyou.visible = false;

        remove(healthBarBG);
        healthBarBG.destroy();
        healthBarBG = insert(members.indexOf(iconP1), new FunkinSprite(0, FlxG.height * 0.75, Paths.image("game/neoHealthBarBG")));
        healthBarBG.setGraphicSize(healthBarBG.width * 0.68);
        healthBarBG.updateHitbox();
        healthBarBG.screenCenter(FlxAxes.X);
        healthBarBG.cameras = [camHUD];
        healthBarBG.flipY = downscroll;

        neoHealthBarBF = insert(members.indexOf(healthBarBG), new FunkinSprite(0, 0, Paths.image("game/neoHealthBar")));
        neoHealthBarBF.setGraphicSize(neoHealthBarBF.width * 0.68);
        neoHealthBarBF.setPosition(((healthBarBG.width - neoHealthBarBF.width) / 2) + healthBarBG.x, ((healthBarBG.height * 1.1 - neoHealthBarBF.height) / 2) + healthBarBG.y);
        neoHealthBarBF.color = rightColor;
        neoHealthBarBF.cameras = [camHUD];
        neoHealthBarBF.flipY = downscroll;

        neoHealthBarDad = insert(members.indexOf(healthBarBG), new FunkinSprite(0, 0, Paths.image("game/neoHealthBar")));
        neoHealthBarDad.setGraphicSize(neoHealthBarDad.width * 0.68);
        neoHealthBarDad.setPosition(((healthBarBG.width - neoHealthBarDad.width) / 2) + healthBarBG.x, ((healthBarBG.height * 1.1 - neoHealthBarDad.height) / 2) + healthBarBG.y);
        neoHealthBarDad.color = leftColor;
        neoHealthBarDad.cameras = [camHUD];
        neoHealthBarDad.flipY = downscroll;
        neoHealthBarDad.onDraw = (spr) -> {
            neoHealthBarDad.clipRect = new FlxRect(0, 0, ((1 - (smoothHealthEpik / 2)) / 1) * neoHealthBarDad.width, healthBarBG.height);
            neoHealthBarDad.draw();
        }

        thingiebf = insert(members.indexOf(iconP1), new FunkinSprite(0, 0, Paths.image("game/thingiebf")));
        thingiebf.setGraphicSize(thingiebf.width * 0.68);
        thingiebf.updateHitbox();
        thingiebf.color = rightColor;
        thingiebf.setPosition(((healthBarBG.width * 1.856 - thingiebf.width) / 2) + healthBarBG.x, ((healthBarBG.height - thingiebf.height) / 2) + healthBarBG.y);
        thingiebf.cameras = [camHUD];
        thingiebf.flipY = downscroll;

        thingiedad = insert(members.indexOf(iconP2), new FunkinSprite(0, 0, Paths.image("game/thingiedad")));
        thingiedad.setGraphicSize(thingiedad.width * 0.68);
        thingiedad.updateHitbox();
        thingiedad.color = leftColor;
        thingiedad.setPosition(((healthBarBG.width * 0.1456 - thingiedad.width) / 2) + healthBarBG.x, ((healthBarBG.height - thingiedad.height) / 2) + healthBarBG.y);
        thingiedad.cameras = [camHUD];
        thingiedad.flipY = downscroll;

        songTimeTxt = insert(members.indexOf(healthBarBG), new FunkinText(0, FlxG.height * 0.05, FlxG.width, "Ligma Balls\n0:00", 21));
        songTimeTxt.alignment = 'center';
        songTimeTxt.cameras = [camHUD];
        songTimeTxt.color = leftColor;

        updateIconPositions = () -> {
            for (icon in iconArray) {
                var thingy = icon.isPlayer ? thingiebf : thingiedad;
                icon.setPosition(((thingy.width - icon.width) / 2) + thingy.x, ((thingy.height - icon.height) / 2) + thingy.y);
            }
        }
    }
}

function postUpdate(elapsed) {
    if (FlxG.save.data.neoui) {
        songTimeTxt.text = SONG.meta.displayName + "\n" + FlxStringUtil.formatTime(inst.time / 1000) + " - " + FlxStringUtil.formatTime(inst.length / 1000);

        smoothHealthEpik = lerp(smoothHealthEpik, health, 0.25);
        smoothScoreEpik = lerp(smoothScoreEpik, songScore, 0.25);

        scoreTxt.text = "Score:" + FlxStringUtil.formatMoney(smoothScoreEpik == 0 ? 0 : smoothScoreEpik + 1, false);
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