package;

import flixel.FlxSprite;

class Item extends Entity
{
	public static inline var MEAT = "meat";
	public static inline var WOOD = "wood";
	public static inline var OIL =  "oil";
	public static inline var STONE = "stone";
	public static inline var FUR = "fur";
	public static inline var BERRY = "berry";
	public static inline var BERRIES = "berries";

    public var inventorySortOrder:String = "";
    public var decay:Int = 5;

	public function new(X:Float = 0, Y:Float = 0) 
    {
        super(X, Y);
    }
}