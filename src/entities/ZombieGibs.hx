class ZombieGibs extends Entity {
  private static inline var DURATION = 0.7;
  private static inline var RADIUS = 48;

  public function new(zombie : Zombie) {
    super(zombie.parent);
    x = zombie.x;
    y = zombie.y;

    // visuals
    var atlas = hxd.Res.foreground;
    var zombie_gibs = atlas.getAnim("zombie_gibs");
    Useful.assert(zombie_gibs != null, "atlas must contain the 'zombie_gibs'");
    var anim = new h2d.Anim(zombie_gibs, this);
    anim.x = -64;
    anim.y = 64;
    anim.speed = 10;
    anim.loop = false;
    anim.onAnimEnd = function() {
      purge = true;
    }

    // shake screen
    State.addFreeze(0.5);
    State.addShake(2);

    // audio
    hxd.Res.kill.play(false, 0.1);
  }
}