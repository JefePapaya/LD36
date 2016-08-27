package;

import flixel.FlxSprite;
import flixel.FlxG;

class Entity extends FlxSprite
{
	public var isVisibleInFog:Bool = true;
	public var lightRadius:Float = 0;

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
	}

	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
	}
}