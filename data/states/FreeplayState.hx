function postUpdate(elapsed) {
    for (i => spr in grpSongs.members) {
        spr.x = lerp(spr.x, FlxG.width * 0.05 + (i * -25) + (curSelected == i ? 120 : 0), 0.05);
        iconArray[i].x = spr.width + spr.x;
    }
}