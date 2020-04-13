using h3d.Vector;

class Title extends State {

  public override function new() {
    super({
      name : "title"
    });
  }

  public override function onEnter(previousState : State) {
    // show title
    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = "CLICK TO PLAY";
    label.textAlign = Center;
    label.color = new Vector(1, 1, 1);
    label.x = State.scene.width / 2;
    label.y = State.scene.height / 2;
  }

  public override function onLeave(newState : State) {
    // hide v
    removeChildren();
  }

  public override function onEvent(event : hxd.Event) {
    // start the game
    switch(event.kind) {
      case EPush:
        if(event.button == 0) {
          State.setCurrent("game");
        }
      case _:
        // do nothing
    }
  }
}