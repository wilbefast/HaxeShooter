class GameScreen extends State {

  private static inline var ZOMBIE_PERIOD = 1.0;
  private static inline var ZOMBIE_DISTANCE = 50.0;

  private var avatar : Avatar;
  private var zombie_timer : Float = ZOMBIE_PERIOD;

  public override function new() {
    super({
      name : "game"
    });
  }

  public override function onEnter(previousState : State) {
    // reset score
    State.score = 0;

    // create background
    var tile = h2d.Tile.fromColor(0x101010, 1, 1);
    var bitmap = new h2d.Bitmap(tile, this);
    bitmap.scaleX = State.WIDTH;
    bitmap.scaleY = State.HEIGHT;

    // create avatar
    avatar = new Avatar({
      parent : this
    });
    avatar.x = State.WIDTH / 2;
    avatar.y = State.HEIGHT / 2;
  }

  public override function onLeave(newState : State) {
    State.score = avatar.score;
    Entity.clear();
    removeChildren();
  }

  public override function onUpdate(dt : Float, mouseX : Float, mouseY : Float) {
    // read the mouse position
    avatar.setTarget(mouseX, mouseY);

    // tick the simulation
    Entity.updateAll(dt);
    EntityCollider.generateCollisions(dt);

    // spawn zombies periodically
    zombie_timer -= dt;
    if(zombie_timer <= 0) {
      zombie_timer = ZOMBIE_PERIOD;
      var zombie = new Zombie({
        parent : this
      });
      var angle = Math.random() * Math.PI * 2;
      zombie.x = State.WIDTH * (0.5 + Math.cos(angle));
      zombie.y = State.HEIGHT * (0.5 + Math.sin(angle));
    }
  }
}