import format.gif.Data.Frame;
import h2d.Scene;

class State extends h2d.Object {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  public static inline var WIDTH : Int = 1600;
  public static inline var HEIGHT : Int = 900;

  // ------------------------------------------------------------
  // STATIC VARIABLES
  // ------------------------------------------------------------

  // state management
  private static var current : State;
  private static var all : Map<String, State>;
  private static var scene : h2d.Scene;
  
  // view
  private static var viewScale : Float = 1.0;
  
  // juice
  private static var freeze = 0.0;
  private static var shake = 0.0;
  private static var root : h2d.Object;

  // game logic
  private static var score : Int = 0;

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  public static function init(args : {
    scene : h2d.Scene,
    states : Array<State>
  }) {
    // don't initialise twice
    Useful.assert(all == null, 'State has already been initialised');

    // save the scene
    Useful.assert(args.scene != null, 'args.scene cannot be null');
    scene = args.scene;
    root = new h2d.Object(scene);

    // create the state map
    all = new Map<String, State>();
    current = new State({
      name : "default"
    });

    // add the possible states to it
    Useful.assert(args.states != null, 'args.states cannot be null');
    for(state in args.states) {
      Useful.assert(!all.exists(state.name), 'The name ${state.name} already exists');
      all.set(state.name, state);
    }
  }

  public static function setCurrent(newStateName : String) : Void {
    Useful.assert(all != null, 'State map cannot be null');
    var newState = all.get(newStateName);
    Useful.assert(newState != null, 'No state called $newStateName exists');
    
    Useful.assert(current != null, 'A current state must exist');
    current.onLeave(newState);
    current.remove();

    root.addChild(newState);
    newState.onEnter(current);
    current = newState;
  }
  
  public static function triggerUpdate(dt : Float) : Void {
    Useful.assert(current != null, 'A current state must exist');

    // screen shake
    shake -= 10*dt;
    if(shake < 0) {
      shake = 0;
    }
    else {
      root.x = (2 * Math.random() - 1) * shake;
      root.y = (2 * Math.random() - 1) * shake;
    }

    // freeze or update
    freeze -= dt;
    if(freeze < 0) {
      freeze = 0;
      current.onUpdate(dt);
    }
  }

  public static function triggerEvent(event : hxd.Event) {
    Useful.assert(current != null, 'A current state must exist');
    current.onEvent(event);
  }

  public static function triggerResize(width : Float, height : Float) {
    // scale to user's screen size
    viewScale = Math.min(width/WIDTH, height/HEIGHT);
    scene.setScale(viewScale);
    scene.x = (width - WIDTH*viewScale) / 2;
    scene.y = (height - HEIGHT*viewScale) / 2;
  }

  public static function addFreeze(amount : Float) : Void {
    freeze += amount;
  }

  public static function addShake(amount : Float) : Void {
    shake += amount;
  }

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    name : String
  }) {
    super();

    Useful.assert(args.name != null, 'A name must be specified');
    name = args.name;
  }

  // ------------------------------------------------------------
  // VIRTUAL METHODS
  // ------------------------------------------------------------

  private function onLeave(newState : State) : Void {
    // override me
  }

  private function onEnter(oldState : State) : Void {
    // override me
  }

  public function onUpdate(dt : Float) : Void {
    // override me
  }

  public function onEvent(event : hxd.Event) : Void {
    // override me
  }

}