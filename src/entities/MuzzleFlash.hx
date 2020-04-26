class MuzzleFlash extends Entity {
  private static inline var DURATION = 0.07;
  private static inline var RADIUS = 32;

  public function new(bullet : Bullet) {
    super(cast(bullet.parent, h2d.Layers));
    x = bullet.x;
    y = bullet.y;

    // visuals
    var atlas = hxd.Res.foreground;
    var muzzle_flash = atlas.getAnim("muzzle_flash");
    Useful.assert(muzzle_flash != null, "atlas must contain the 'muzzle_flash'");
    var anim = new h2d.Anim(muzzle_flash, this);
    for(t in anim.frames) {
      t.dx = t.dy = -48;
    }
    anim.speed = 10;
    anim.loop = false;
    anim.onAnimEnd = function() {
      purge = true;
    }

    // audio
    hxd.Res.shoot.play(false, 0.1);
  }
}