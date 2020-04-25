class Resources {
  
  public var avatar : {
    up : h2d.Anim,
    down : h2d.Anim,
    left : h2d.Anim,
    right : h2d.Anim
  };

  public static function load() {

    var atlas = hxd.Res.foreground;

    var tiles = atlas.getAnim("player_down");
    Useful.assert(tiles != null, "atlas must contain the specified animation");
    Resources.avatar.up = new h2d.Anim(tiles, this);

    
  }
}