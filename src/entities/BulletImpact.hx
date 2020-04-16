class BulletImpact extends Entity {
  private static inline var DURATION = 0.2;
  private static inline var RADIUS = 24;

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

    // shake screen
    State.addFreeze(0.1);
    State.addShake(1);

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
      bitmap.setScale(Useful.lerp(RADIUS, RADIUS*4, progress));
      bitmap.alpha = 0.7 * (1 - progress);
    }
  }
}