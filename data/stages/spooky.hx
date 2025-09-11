var crowdYDefault:Float = 0;

function create() {
    crowdYDefault = crowd.y;
}

function postUpdate(elapsed) {
    crowd.y = lerp(crowd.y, crowdYDefault, 0.1);
    crowd.skew.x = lerp(crowd.skew.x, 0, 0.1);
}

function beatHit() {
    if (curBeat % 4 == 0) {
        crowd.y += 35;
        crowd.skew.x = 2;
    }
}