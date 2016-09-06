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

	//Map generation
}