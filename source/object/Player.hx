package object;

import system.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	public var speed:Float;
	public var inventory:Inventory;

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);

		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("wdown", [0, 1, 0, 2], 6, false);
		animation.add("wlr", [3, 4, 3, 5], 6, false);
		animation.add("wup", [6, 7, 6, 8], 6, false);

		//Inventory
		inventory = new Inventory();

		//Setup stuff from config
		drag.x = drag.y = GameConfig.playerDrag;
		speed = GameConfig.playerSpeed;

		//Debug
		FlxG.watch.add(this, "velocity");
	}

	override public function update(elapsed:Float) 
	{
		updateMovement();
		super.update(elapsed);	
	}

	override public function updateAnimation(elapsed)
	{

		switch (facing) {
			case FlxObject.LEFT, FlxObject.RIGHT:
				animation.play("wlr");
			case FlxObject.UP:
				animation.play("wup");
			case FlxObject.DOWN:
				animation.play("wdown");
		}
		//Make the player stand still if not moving
		if (animation.curAnim != null && velocity.x == 0 && velocity.y == 0) {
			animation.curAnim.curFrame = 0;
			animation.curAnim.pause();
		}
		super.updateAnimation(elapsed);
	}

	public function getItem(item:Entity)
	{
		if (getMidpoint().distanceTo(item.getMidpoint()) > width * 2) {
			GameHUD.sharedInstance.displayStatusText(Strings.ACTION_TOO_FAR);
		}
		else {
			//gets the item
		}
	}

	function updateMovement() 
	{		
		var up = false;
		var down = false;
		var left = false;
		var right = false;

		#if !FLX_NO_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		#end
		//Oposite directions cancel out
		if (up && down) {
			up = down = false;
		}
		if (left && right) {
			left = right = false;
		}
		//If player is inputing movement
		if (up || down || left || right) {
			var movingAngle:Float = 0;
			if (up) {
				movingAngle = -90;
				facing = FlxObject.UP;
				if (left) {
					movingAngle -= 45;
				}
				else if (right) {
					movingAngle += 45;
				}
			}
			else if (down) {
				movingAngle = 90;
				facing = FlxObject.DOWN;
				if (left) {
					movingAngle += 45;
				}
				else if (right) {
					movingAngle -= 45;
				}
			}
			else if (left) {
				movingAngle = 180;
				facing = FlxObject.LEFT;
			}
			else if (right) {
				movingAngle = 0;
				facing = FlxObject.RIGHT;
			}	
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), movingAngle);
		}
	}
}