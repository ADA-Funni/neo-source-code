import funkin.backend.shaders.CustomShader;

var glitch = new CustomShader(("glitch"));

function postCreate() {
    glitch.time = 0;
    glitch.glitchAmount = 0;
    for (cam in [camGame, camHUD]) cam.addShader(glitch);
}

function update(elapsed) {
    glitch.time += elapsed;
    glitch.glitchAmount = lerp(glitch.glitchAmount, (1 - (health / maxHealth)) * 4, 0.15);

    iconP2.angle = FlxG.random.float(-5, 5);
}

function onDadHit(e) {
    if (health > 0.5) health -= 0.025;
}