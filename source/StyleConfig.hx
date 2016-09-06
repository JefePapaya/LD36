package;

import flixel.util.FlxColor;

//Config Style elements like Fonts, Colors, Sizes
class StyleConfig 
{
	//Fog of war
	public static var UNEXPLORED_COLOR:FlxColor = FlxColor.BLACK;
	public static var FOG_COLOR:FlxColor = FlxColor.BLACK;
	public static var FOG_ALPHA:Float = 0.6;

	//Inventory size
	public static var INVENTORY_WIDTH:Int = 300;
	public static var INVENTORY_HEIGHT:Int = 500;
	public static var INVENTORY_SLOTS_PER_ROW:Int = 4;
	public static var INVENTORY_SLOT_WIDTH:Int = 64;
	public static var INVENTORY_SLOT_HEIGHT:Int = 64;
	public static var INVENTORY_SLOT_SPACING_X:Int = 8;
	public static var INVENTORY_SLOT_SPACING_Y:Int = 8;
	
}