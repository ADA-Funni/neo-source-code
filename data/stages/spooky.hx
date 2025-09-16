var crowdYDefault:Float = 0;

function create() {
    crowdYDefault = crowd.y;
}

function postUpdate(elapsed) {
    crowd.y = lerp(crowd.y, crowdYDefault, 0.12);
    crowd.angle = lerp(crowd.angle, 0, 0.12);
}

var danceLeft:Bool = true;

function beatHit() {
    if (curBeat % 4 == 0) {
        danceLeft = !danceLeft;

        crowd.y += 30;
        crowd.angle = danceLeft ? 0.5 : -0.5;
    }
}