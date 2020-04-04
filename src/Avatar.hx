using hxd.Key;

class Avatar extends Entity {

  private static inline var size = 32;

  private var bitmap : h2d.Bitmap;
  private var direction = new h3d.Vector(0, 0, 0);

  public function new(args : {
    s2d : h2d.Scene
  }) {
    super(args);
    maxSpeed = 10;
    //friction = 0.1;

    var tile = h2d.Tile.fromColor(0xFFFFFF, size, size);
    tile.dx = tile.dy = -size / 2;
    bitmap = new h2d.Bitmap(tile, this);

    var label = new h2d.Text(hxd.res.DefaultFont.get(), bitmap);
    label.text = "hello world";
    label.textAlign = Center;
    label.color = new h3d.Vector(1, 0, 0);
    label.y = -32;
  }

  public override function update(dt : Float) {
    direction.set(0, 0);

    if (Key.isDown(Key.LEFT)) {
      direction.x -= 1;
    }
    if (Key.isDown(Key.RIGHT)) {
      direction.x += 1;
    }
    if (Key.isDown(Key.UP)) {
      direction.y -= 1;
    }
    if (Key.isDown(Key.DOWN)) {
      direction.y += 1;
    }

    direction.normalize();
    direction.scale3(10);
    speed = direction;//.add(direction);

    super.update(dt);
  }
}