class BulletImpact extends Entity {
  
  private static inline var RADIUS = 64.0;


  public function new(bullet : Bullet) {
    super(cast(bullet.parent, h2d.Layers));
    x = bullet.x;
    y = bullet.y;

    // collisions
    collider = new EntityCollider(this, RADIUS);

    // visuals
    var atlas = hxd.Res.foreground;
    var explosion = atlas.getAnim("explosion");
    Useful.assert(explosion != null, "atlas must contain the 'explosion'");
    var anim = new h2d.Anim(explosion, this);
    anim.x = -64;
    anim.y = 64;
    anim.speed = 15;
    anim.loop = false;
    anim.onAnimEnd = function() {
      purge = true;
    }

    // shake screen
    State.addFreeze(0.1);
    State.addShake(1);

    // audio
    hxd.Res.impact.play(false, 0.15);
  }
}