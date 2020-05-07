import h2d.Interactive;
import hxd.Res;
import haxe.Ucs2;
import js.html.MouseEvent;
import h2d.Object;

class Main extends hxd.App {
    static function main() : Void {
      new Main();
    }

    private var loaded = false;

    override function init() : Void {
      
#if js
      // initialise Heaps resource manager
      var loader = new hxd.net.BinaryLoader("res.pak");
      loader.load();

      loader.onError = function(message : String) {
        trace("Failed to load PAK file", message);
      }
      loader.onLoaded = function(bytes : haxe.io.Bytes) {
        var fs = new hxd.fmt.pak.FileSystem();
        fs.addPak(new hxd.fmt.pak.FileSystem.FileInput(bytes));
        hxd.Res.loader = new hxd.res.Loader(fs);
        onAssetsLoaded();
      }
#else
      hxd.Res.initLocal();
      onAssetsLoaded();
#end
    }

    private function onAssetsLoaded() {
      var atlas = Res.foreground;
      
      // set up viewport with letterbox
      s2d.scaleMode = LetterBox(State.WIDTH, State.HEIGHT, false, Center, Center);
      var mask = new h2d.Mask(State.WIDTH, State.HEIGHT, s2d);

      // hide the cursor
      var interactive = new Interactive(State.WIDTH, State.HEIGHT, s2d);
      interactive.cursor = Hide;
      
      // initialise state machine
      State.init({
        parent : mask,
        states : [ new TitleScreen(), new GameScreen(), new ScoreScreen() ]
      });
      State.setCurrent("title");

      // hook up events
      var window = hxd.Window.getInstance();
      window.addEventTarget(State.triggerEvent);

      // ready to run update logic
      loaded = true;
    }

    private override function update(dt : Float) : Void {
      if(loaded) {
        State.triggerUpdate(dt, s2d.mouseX, s2d.mouseY);
      }
    }
}