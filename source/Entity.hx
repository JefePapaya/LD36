package;

import flixel.FlxSprite;
import flixel.FlxG;

class Entity extends FlxSprite
{
	public var isVisibleInFog:Bool = true;
	public var lightRadius:Float = 0;
	public var actionText:String;
	public var actions:Array<ActionObject>;

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		actions = new Array<ActionObject>();
	}

	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		updateInput();
	}

	function updateInput() 
	{
		#if !FLX_NO_MOUSE
		if (FlxG.mouse.overlaps(this)) {
			if (actions.length > 0) {
				FlxG.log.add("actions length " + actions.length);
			}
			if (actionText != null && visible == true) {
				GameHUD.sharedInstance.displayActionText(actionText, this);
			}
			if (actions.length > 0 && (GameHUD.sharedInstance.actionMenu == null || GameHUD.sharedInstance.actionMenu.entity != this)) {
				GameHUD.sharedInstance.showActionMenu(this);
			}
		}
		#end
	}
}