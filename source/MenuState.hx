package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var text = new FlxText(0, 0, FlxG.width, "Best Game Ever - LD#36 !", 32);
		text.screenCenter(FlxAxes.XY);
		text.alignment = FlxTextAlign.CENTER;
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
