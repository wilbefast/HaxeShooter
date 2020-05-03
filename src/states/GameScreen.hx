class GameScreen extends State {

  private static inline var ZOMBIE_PERIOD = 1.0;
  private static inline var ZOMBIE_DISTANCE = 50.0;

  private var avatar : Avatar;
  private var wallNorth : Wall;
  private var wallSouth : Wall;
  private var wallEast : Wall;
  private var wallWest : Wall;
  private var zombieTimer : Float;

  public override function new() {
    super({
      name : "game"
    });
  }

  public override function onEnter(previousState : State) {
    // reset score
    State.score = 0;

    // reset zombie timer
    zombieTimer = ZOMBIE_PERIOD;

    // create background
    var tile = h2d.Tile.fromColor(0xe08d74, 1, 1);
    var bitmap = new h2d.Bitmap(tile, this);
    bitmap.scaleX = State.WIDTH;
    bitmap.scaleY = State.HEIGHT;

    // create walls
    wallNorth = new Wall({
      parent : this,
      x : 0,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : State.HEIGHT
    });
    wallSouth = new Wall({
      parent : this,
      x : 0,
      y : State.HEIGHT,
      width : State.WIDTH,
      height : State.HEIGHT
    });
    wallWest = new Wall({
      parent : this,
      x : -State.WIDTH,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : 3*State.HEIGHT
    });
    wallEast = new Wall({
      parent : this,
      x : State.WIDTH,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : 3*State.HEIGHT
    });

    // create avatar
    avatar = new Avatar({
      parent : this,
      x : State.WIDTH / 2,
      y : State.HEIGHT / 2
    });
    
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
    zombieTimer -= dt;
    if(zombieTimer <= 0) {
      zombieTimer = ZOMBIE_PERIOD;
      var angle = Math.random() * Math.PI * 2;
      var zombie = new Zombie({
        parent : this,
        x : State.WIDTH * (0.5 + Math.cos(angle)),
        y : State.HEIGHT * (0.5 + Math.sin(angle))
      });
    }

    // sort children by y-axis
    ysort(0);
  }
}