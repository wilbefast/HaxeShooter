import h3d.Vector;

class BulletTrail extends Entity {

  public function new(bullet : Bullet) {
    super(cast(bullet.parent, h2d.Layers));
    x = bullet.x;
    y = bullet.y;

    // visuals
    var atlas = hxd.Res.foreground;
    var trail = atlas.getAnim("trail");
    Useful.assert(trail != null, "atlas must contain the 'trail'");
    var anim = new h2d.Anim(trail, this);
    for(t in anim.frames) {
      t.dx = t.dy = -16;
    }
    anim.speed = 15 + 4*Math.random();
    anim.loop = false;
    anim.onAnimEnd = function() {
      purge = true;
    }

    // push away
    speed.load(bullet.speed);
    speed.scale3(-0.5);
    speed.x += (Math.random() - 0.5)*100;
    speed.y += (Math.random() - 0.5)*100;
    friction = 100;
  }
}