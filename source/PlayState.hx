package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.display.BitmapDataChannel;
import flash.display.BitmapData;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var player:Player;
	var _background:FlxSprite;
	var _terrain:FlxSprite;
	var _stone:FlxSprite;
	var _fog:FlxSprite;
	var _light:FlxSprite;

	//TileMap
	var _tileMap:FlxTilemap;

	//Layers
	var _grpObastacles:FlxTypedGroup<FlxSprite>;
	var _grpCreatures:FlxTypedGroup<FlxSprite>;
	var _grpTileMap:FlxTypedGroup<FlxSprite>;

	override public function create():Void
	{
		super.create();

		//Prototype start
		// _background = new FlxSprite();
		// _background.makeGraphic(FlxG.width, FlxG.height, 0xFF99BBCC, true);
		// add(_background);

		// _terrain  = new FlxSprite();
		// _terrain.makeGraphic(Math.round(FlxG.width * 0.5), Math.round(FlxG.height * 0.5), FlxColor.WHITE, true);
		// _terrain.x = FlxG.width * 0.25;
		// _terrain.y = FlxG.height * 0.25;
		// _terrain.width = FlxG.width * 0.5;
		// _terrain.height = FlxG.height * 0.5;
		// add(_terrain);

		// _stone  = new FlxSprite();
		// _stone.makeGraphic(32, 32, FlxColor.GRAY, true);
		// _stone.x = FlxG.width * 0.4;
		// _stone.y = FlxG.height * 0.4;
		// _stone.width = 32;
		// _stone.height = 32;
		// _stone.immovable = true;
		// _stone.centerOffsets();
		// add(_stone);
		//Prototype end

		//Tiled Map
		var tileLoader = new TiledLoader(AssetPaths.tilemap__tmx);
		_tileMap = tileLoader.loadTilemap(AssetPaths.tiles__png);
		_tileMap.setTileProperties(2, FlxObject.NONE);
		_tileMap.setTileProperties(3, FlxObject.ANY);
		_tileMap.follow();
		add(_tileMap);
		tileLoader.loadObjectgroups(createObjects);

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

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//Camera stuff
		FlxG.worldBounds.setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);

		updateInput();
		FlxG.collide(player, _stone, collidePlayerStone);
		FlxG.collide(player, _tileMap);
		//Animation must be updated after collision
		player.updateAnimation(elapsed);

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
			case TiledParser.BLOCK_LAYER:
				// _grpBlocks.add(TiledParser.parseBlock(data));
			case TiledParser.PORTAL_LAYER:
				// _grpPortals.add(TiledParser.parsePortal(data));
			default:
				throw "Tried to load unknown layer";
		}
	}

	function updateFogOfWar() {
		//Fog of war stuff
		var rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		// _light.setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		_light.pixels.fillRect(rect, 0xFFFFFF66);
		_light.drawCircle(player.getMidpoint().x - FlxG.camera.scroll.x, player.getMidpoint().y - FlxG.camera.scroll.y,
						  GameConfig.dayVisibilityRadius, 0xFFFFFF00);


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
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justReleased.R) {
			FlxG.resetState();
		}
		#end
	}

	function collidePlayerStone(p:Player, s:FlxSprite)
	{
		FlxG.log.add("collidePlayerStone");
	}
}
