class Useful {

  #if debug
  public static function assert(check : Bool, message : String) : Void {
    if(!check) {
      trace('Assertion failed: ${message}');
    }
  }
  #else
  public static inline function assert(check : Bool, message : String) : Void {}
  #end


  public static inline function clamp01(a : Float) {
    return a > 1 ? 1 : (a < 0 ? 0 : a);
  }

  public static inline function dist(x1 : Float, y1 : Float, x2 : Float, y2 : Float) {
    var dx = x2 - x1;
    var dy = y2 - y1;
    return Math.sqrt(dx*dx + dy*dy);
  }

  public static inline function dist2(x1 : Float, y1 : Float, x2 : Float, y2 : Float) {
    var dx = x2 - x1;
    var dy = y2 - y1;
    return dx*dx + dy*dy;
  }

  public static inline function lerp(a : Float, b : Float, k : Float) : Float {
    k = clamp01(k);
    return b*k + (1 - k)*a;
  }

  public static function shuffle<T>(array : Array<T>) : Void {
    var i = array.length - 1;
    while(i >= 1) {
      var j = Std.random(i + 1);
      var swap = array[i];
      array[i] = array[j];
      array[j] = swap;
      i--;
    }
  }
}