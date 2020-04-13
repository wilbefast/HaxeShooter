import h2d.Scene;

class State extends h2d.Object {

  // ------------------------------------------------------------
  // STATIC VARIABLES
  // ------------------------------------------------------------

  private static var current : State;
  private static var all : Map<String, State>;
  private static var scene : h2d.Scene;

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

    scene.addChild(newState);
    newState.onEnter(current);
    current = newState;
  }
  
  public static function triggerUpdate(dt : Float) : Void {
    Useful.assert(current != null, 'A current state must exist');
    current.onUpdate(dt);
  }

  public static function triggerEvent(event : hxd.Event) {
    Useful.assert(current != null, 'A current state must exist');
    current.onEvent(event);
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