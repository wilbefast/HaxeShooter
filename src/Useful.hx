class Useful {

  public static function assert(check : Bool, message : String) : Void {
    if(!check) {
      trace('Assertion failed: ${message}');
    }
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