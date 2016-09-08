package state;

import object.*;
import system.*;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.display.BitmapDataChannel;
import flash.display.BitmapData;
using flixel.util.FlxSpriteUtil;
using util.SpriteUtil;

class PlayState extends FlxState
{
	public var player:Player;
	public var visibleRadius:Float;
	var _background:FlxSprite;
	var _terrain:FlxSprite;
	var _stone:FlxSprite;
	var _fog:FlxSprite;
	var _light:FlxSprite;

	//TileMap
	var _backgroundTileMap:FlxTilemap;
	var _tileMap:FlxTilemap;

	//Layers
	var _grpEntities:FlxTypedGroup<FlxSprite>;
	var _grpObastacles:FlxTypedGroup<FlxSprite>;
	var _grpCreatures:FlxTypedGroup<FlxSprite>;
	var _grpItems:FlxTypedGroup<Item>;
	var _grpTileMap:FlxTypedGroup<FlxSprite>;
		
	//Navigation
	var _cameraReturnTimer:Float = GameConfig.navigationCameraIdleReturnTime;
	public var navigation:Navigation;

	//HUD
	public var inventoryController:InventoryController;
	public var gameHUD:GameHUD;

	@:access(flixel.tile.FlxBaseTilemap)
	override public function create():Void
	{
		super.create();

		_grpEntities = new FlxTypedGroup<FlxSprite>();
		_grpObastacles = new FlxTypedGroup<FlxSprite>();
		_grpCreatures = new FlxTypedGroup<FlxSprite>();
		_grpItems = new FlxTypedGroup<Item>();
		//Tiled Map
		var tileLoader = new TiledLoader(AssetPaths.tilemap__tmx);

		_backgroundTileMap = tileLoader.loadTilemapLayer(AssetPaths.tileset__png, 32, 32, "BackgroundTile");
		add(_backgroundTileMap);

		_tileMap = tileLoader.loadTilemapLayer(AssetPaths.tileset__png, 32, 32, "ForegroundTile");
		_tileMap.setTileProperties(0, FlxObject.NONE, _tileMap._tileObjects.length - 1);
		_tileMap.setTileProperties(0, FlxObject.ANY);
		// _tileMap.setTileProperties(31, FlxObject.ANY);
		// _tileMap.setTileProperties(32, FlxObject.ANY);
		// _tileMap.setTileProperties(33, FlxObject.ANY);
		_tileMap.follow();
		add(_tileMap);
		tileLoader.loadObjectgroups(createObjects);


		add(_grpObastacles);
		add(_grpEntities);
		add(_grpItems);
		add(_grpCreatures);
		// player = new Player();
		// player.screenCenter(FlxAxes.XY);
		add(player);

		//Fog of war stuff
		_light = new FlxSprite();
		_light.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFF66, true);
		// add(_light);
		_fog = new FlxSprite();
		_fog.makeGraphic(FlxG.width, FlxG.height, 0x00000000, true);
		updateFogOfWar();
		
		add(_fog);

		//Navigation Stuff
		FlxG.camera.focusOn(player.getMidpoint());
		navigation = new Navigation(this);
		add(navigation);

		// FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN, 1);

		//HUD
		inventoryController = new InventoryController(this);
		inventoryController.playerInventory = player.inventory;
		gameHUD = new GameHUD(this);
		add(gameHUD);

		//Changing the mouse cursor test
		// var cursorSprite = new FlxSprite();
		// cursorSprite.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		// cursorSprite.drawCircle(7, 7, 7);
		// FlxG.mouse.load(cursorSprite.pixels);

		FlxG.watch.addMouse();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//Camera stuff
		FlxG.worldBounds.setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		//Collisions
		FlxG.collide(player, _stone, collidePlayerStone);
		FlxG.collide(player, _grpObastacles);
		FlxG.collide(player, _tileMap);
		//Animation must be updated after collision
		player.updateAnimation(elapsed);

		updateInput();

		updateFogOfWar();
	}

	override public function draw() {
		super.draw();
	}

	function createObjects(layer:String, data:Xml)
	{
		switch (layer) {
			case TiledParser.PLAYER_LAYER:
				player = TiledParser.parsePlayer(data);
			case TiledParser.ENTITY_LAYER:
				_grpEntities.add(TiledParser.parseEntity(data));
			case TiledParser.CREATURES_LAYER:
				_grpCreatures.add(TiledParser.parseEntity(data));
			case TiledParser.ENVIRONMENT_LAYER:
				_grpObastacles.add(TiledParser.parseEntity(data));
			case TiledParser.ITEMS_LAYER:
				_grpItems.add(TiledParser.parseItem(data));
			default:
				throw "Tried to load unknown layer: " + layer;
		}
	}

	function updateFogOfWar() {
		//Fog of war light
		var rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		visibleRadius = GameConfig.dayVisibilityRadius;
		// _light.setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		_light.pixels.fillRect(rect, 0xFFFFFF66);
		_light.drawCircle(player.getMidpoint().x - FlxG.camera.scroll.x, player.getMidpoint().y - FlxG.camera.scroll.y,
						  visibleRadius, 0xFFFFFF00);

		// Update objects visibility
		_grpEntities.forEach(function (obj:FlxSprite) {
			
			if (Std.is(obj, Entity)) {
				var entity:Entity = cast(obj, Entity);
				if (!entity.isVisibleInFog) {
					var distance:Float = player.getMidpoint().distanceTo(entity.getMidpoint());
					if (distance <= visibleRadius) {
						entity.visible = true;
					}
					else {
						entity.visible = false;
					}
				}
				if (entity.isOnScreen()) {
					if (entity.lightRadius > 0) {
						_light.drawCircle(entity.getMidpoint().x - FlxG.camera.scroll.x, entity.getMidpoint().y - FlxG.camera.scroll.y,
							  entity.lightRadius, 0xFFFFFF00);
					}
				}
			}
		});

		//Fog of war darkness
		_fog.setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		_fog.pixels.fillRect(rect, 0x00000000);
		_fog.pixels.copyChannel(_light.pixels, rect, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
	}

	function updateMask():Void
	{
		var _mask = new FlxSprite();
		_mask.drawCircle(player.getMidpoint().x, player.getMidpoint().y, 50, FlxColor.WHITE);
		// In each update, create a new mask based on the original
		// _fog's uncut rectangle, then cut a circle into it.
		var newMask = new FlxSprite();

		// Instead of cloning pixels (which will result in cached image)
		// we copy the cached _fog's bitmapData, then directly "reset"
		// the pixel data by drawing a fresh rectangle over it.
		newMask.loadGraphicFromSprite(_fog);
		newMask.pixels.fillRect(new Rectangle(0, 0, _mask.width,_mask.height), 0x660000FF);

		// Draw circles around more than one target
		FlxSpriteUtil.drawCircle(newMask, player.getMidpoint().x, player.getMidpoint().y, 50, FlxColor.WHITE);
		FlxSpriteUtil.drawCircle(newMask, _stone.getMidpoint().x, _stone.getMidpoint().y, 50, FlxColor.WHITE);

		// Draw onto the _mask
		invertedAlphaMaskFlxSprite(_fog, newMask, _mask);
	}

	function invertedAlphaMaskFlxSprite(sprite:FlxSprite, mask:FlxSprite, output:FlxSprite):FlxSprite
	{
		// Solution based on the discussion here:
		// https://groups.google.com/forum/#!topic/haxeflixel/fq7_Y6X2ngY
 
		// NOTE: The code below is the same as FlxSpriteUtil.alphaMaskFlxSprite(),
		// except it has an EXTRA section below.
 
		sprite.drawFrame();
		var data:BitmapData = sprite.pixels.clone();
		data.copyChannel(mask.pixels, new Rectangle(0, 0, sprite.width, sprite.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
 
		// EXTRA:
		// this code applies a -1 multiplier to the alpha channel,
		// turning the opaque circle into a transparent circle.
		data.colorTransform(new Rectangle(0, 0, sprite.width, sprite.height), new ColorTransform(0,0,0,-1,0,0,0,255));
		// end EXTRA
 
		output.pixels = data;
		return output;
	}

	function updateInput() {
		#if !FLX_NO_MOUSE
		//getting the topmost item
		var item:Item = null;
		_grpItems.forEach(function (obj:Item) {
			if (FlxG.mouse.overlaps(obj)) {
				item = obj;
			}
		});
		//Displaying item's actionText
		if (item != null) {
			if (item.actionText != null && visible == true) {
				gameHUD.displayActionText(item.actionText, item);
			}
		}
		//Taking item
		//Just open inventory for now
		if (FlxG.mouse.justReleased && item != null && item.interactive) {
			if (player.inventory.putItem(item)) {
				_grpItems.remove(item);
			}
		}
		#end
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justReleased.R) {
			FlxG.resetState();
		}
		else if (FlxG.keys.justReleased.I) {
			if (inventoryController.isOpen) {
				inventoryController.close();
			}
			else {
				inventoryController.open();
			}
		}
		#end
	}

	public function dropItem(item:Item, position:FlxPoint) {
		_grpItems.add(item);
		item.scrollFactor.set(1, 1);
		item.centerInPoint(position);
		item.y -= 32 + item.height / 2;
		item.interactive = false;
		FlxTween.tween(item, {y: position.y - item.height / 2}, 0.25, {ease: FlxEase.backIn, 
			onComplete:function(tween:FlxTween){
				item.interactive = true;
			}});
	}

	function collidePlayerStone(p:Player, s:FlxSprite)
	{
		FlxG.log.add("collidePlayerStone");
	}
}
