class GameScreen extends State {

  private static inline var ZOMBIE_INITIAL_PERIOD = 1.5;
  private static inline var ZOMBIE_PERIOD_DECREASE = 0.02;
  private static inline var ZOMBIE_MINIMUM_PERIOD = 0.1;
  private static inline var ZOMBIE_DISTANCE = 50.0;

  private var zombiePeriod : Float;
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
    zombiePeriod = ZOMBIE_INITIAL_PERIOD;
    zombieTimer = zombiePeriod;

    // create backgroundeate background
    var background = new h2d.Object(this);
    var backgroundTile = hxd.Res.concrete.toTile();
    var x = 0.0;
    while(x < State.WIDTH) {
      var y = 0.0;
      while(y < State.HEIGHT) {
        var backgroundBitmap = new h2d.Bitmap(backgroundTile, background);
        backgroundBitmap.setPosition(x, y);
        y += backgroundTile.height;
      }
      x += backgroundTile.width;
    }

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
      zombieTimer = zombiePeriod;
      zombiePeriod = Math.max(ZOMBIE_MINIMUM_PERIOD, zombiePeriod - ZOMBIE_PERIOD_DECREASE);
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