class MuzzleFlash extends Entity {
  private static inline var DURATION = 0.07;
  private static inline var RADIUS = 32;

  private var timer : Float;
  private var bitmap : h2d.Bitmap;

  public function new(bullet : Bullet) {
    super(bullet.parent);
    x = bullet.x;
    y = bullet.y;

    // visual
    var tile = h2d.Tile.fromColor(0xFFFF00, 1, 1);
    tile.dx = tile.dy = -0.5;
    bitmap = new h2d.Bitmap(tile, this);
    bitmap.setScale(RADIUS*2);
    bitmap.alpha = 0.7;

    // audio
    hxd.Res.shoot.play(false, 0.1);

    // decay
    timer = DURATION;
  }

  public override function update(dt : Float) {
    // particle effect
    timer -= dt;
    if(timer <= 0) {
      purge = true;
    }
    else {
      var progress = 1 - timer/DURATION;
      bitmap.setScale(Useful.lerp(RADIUS, RADIUS*2, progress));
    }
  }

}