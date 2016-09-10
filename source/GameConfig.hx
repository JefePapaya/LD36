package;

class GameConfig {
	//Player
	public static var playerSpeed:Float = 150;
	public static var playerDrag:Float = 1600;

	//Fog of war
	public static var dayVisibilityRadius:Float = 200; //In pixels
	public static var nightVisibilityRadius:Float = 20;
	public static var torchVisibilityRadius:Float = 120;
	public static var fireLightRadius:Float = 50;

	//Navigation
	public static var navigationBorderWidth:Float = 4; // In pixels
	public static var navigationScrollSpeed:Float = 160;
	public static var navigationCameraIdleReturnTime:Float = 4;

	//Inventory
	public static var INVENTORY_PLAYER_NUM_SLOTS:Int = 12;
	public static var inventoryHouseNumSlots:Int = 24;
	public static var inventoryDropNumSlots:Int = 12;
	
	//Drops
	public static var TREE_MIN_DROP:Int = 2;
	public static var TREE_MAX_DROP:Int = 2;
	public static var BUSH_MIN_DROP:Int = 1;
	public static var BUSH_MAX_DROP:Int = 1;
	public static var WOLF_MIN_MEAT:Int = 1;
	public static var WOLF_MAX_MEAT:Int = 2;
	public static var WOLF_MIN_FUR:Int = 0;
	public static var WOLF_MAX_FUR:Int = 1;

	//Map generation
}