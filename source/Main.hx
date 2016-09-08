package;

import flixel.FlxGame;
import state.PlayState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(800, 600, PlayState, 1, 60, 60, true, true));
	}
}