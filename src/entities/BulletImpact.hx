class BulletImpact extends Entity {

  public function new(bullet : Bullet) {
    super(cast(bullet.parent, h2d.Layers));
    x = bullet.x;
    y = bullet.y;

    // visuals
    var atlas = hxd.Res.foreground;
    var impact = atlas.getAnim("impact");
    Useful.assert(impact != null, "atlas must contain the 'impact'");
    var anim = new h2d.Anim(impact, this);
    anim.x = -32;
    anim.y = 32;
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