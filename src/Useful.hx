class Useful {

  public static inline function assert(check : Bool, message : String) : Void {
    if(!check) {
      trace('Assertion failed: ${message}');
    }
  }

  public static inline function clamp01(a : Float) {
    return a > 1 ? 1 : (a < 0 ? 0 : a);
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