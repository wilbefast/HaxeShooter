import format.gif.Data.Frame;
import h2d.Scene;

class State extends h2d.Object {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  public static inline var WIDTH : Int = 1366;
  public static inline var HEIGHT : Int = 664;

  // ------------------------------------------------------------
  // STATIC VARIABLES
  // ------------------------------------------------------------

  // state management
  private static var current : State;
  private static var all : Map<String, State>;
  
  // juice
  private static var freeze = 0.0;
  private static var shake = 0.0;
  private static var root : h2d.Object;

  // text
  public static var smallFont : h2d.Font;
  public static var bigFont : h2d.Font;

  // game logic
  private static var score : Int = 0;

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  public static function init(args : {
    parent : h2d.Object,
    states : Array<State>
  }) {
    // don't initialise twice
    Useful.assert(all == null, 'State has already been initialised');

    // create the root node
    Useful.assert(args.parent != null, 'args.parent cannot be null');
    root = new h2d.Object(args.parent);

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

    // create the fonts
    smallFont = hxd.res.DefaultFont.get().clone();
    smallFont.resizeTo(24);
    smallFont.setOffset(0, -12);
    bigFont = hxd.res.DefaultFont.get().clone();
    bigFont.resizeTo(48);
    bigFont.setOffset(0, -24);
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
  
  public static function triggerUpdate(dt : Float, mouseX : Float, mouseY : Float) : Void {
    Useful.assert(current != null, 'A current state must exist');

    // freeze or update
    freeze -= dt;
    if(freeze < 0) {
      freeze = 0;
    }
    else {
      dt *= Math.max(0, 1 - freeze);
    }
    
    // screen shake
    shake -= 10*dt;
    if(shake < 0) {
      shake = 0;
    }
    else {
      root.x = (2 * Math.random() - 1) * shake;
      root.y = (2 * Math.random() - 1) * shake;
    }
    
    // update the current state
    current.onUpdate(dt, mouseX, mouseY);
  }

  public static function triggerEvent(event : hxd.Event) {
    Useful.assert(current != null, 'A current state must exist');
    current.onEvent(event);
  }

  public static function addFreeze(amount : Float) : Void {
    freeze = Math.max(freeze, amount);
  }

  public static function addShake(amount : Float) : Void {
    shake = Math.max(shake, amount);
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

  public function onUpdate(dt : Float, mouseX : Float, mouseY : Float) : Void {
    // override me
  }

  public function onEvent(event : hxd.Event) : Void {
    // override me
  }

}