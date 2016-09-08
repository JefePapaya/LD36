package system;

import state.PlayState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Navigation extends FlxObject
{
	var _cameraReturnTimer:Float = 0;
	var _movementTimer:Float = 3;
	var _playState:PlayState;

	override public function new(state:PlayState)
	{
		super();
		_playState = state;
		FlxG.camera.follow(_playState.player, TOPDOWN, 0.5);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateInput();
	}

	function updateInput() {
		#if !FLX_NO_MOUSE
		var threshold = GameConfig.navigationBorderWidth;
		var distance = GameConfig.navigationScrollSpeed * FlxG.elapsed;
		var cameraPos = new FlxPoint(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		if (FlxG.mouse.getScreenPosition().x <= threshold) {
			FlxG.camera.scroll.x -= distance;
		}
		else if (FlxG.mouse.getScreenPosition().x >= FlxG.width - threshold) {
			FlxG.camera.scroll.x += distance;
		}
		if (FlxG.mouse.getScreenPosition().y <= threshold) {
			FlxG.camera.scroll.y -= distance;
		}
		else if (FlxG.mouse.getScreenPosition().y >= FlxG.height - threshold) {
			FlxG.camera.scroll.y += distance;
		}
		if (cameraPos.distanceTo(FlxG.camera.scroll) > 0) {
			_cameraReturnTimer = GameConfig.navigationCameraIdleReturnTime;
		}
		else {
			_cameraReturnTimer -= FlxG.elapsed;
		}
		if (_cameraReturnTimer <= 0) {
			moveTowardsPlayer(true);
		}
		else {
			moveTowardsPlayer(false);
		}
		#end
	}

	public function moveTowardsPlayer(move:Bool) {
		if (move || (_playState.player.isOnScreen() && _playState.player.velocity.distanceTo(FlxPoint.get()) > 0) ) {	
			_cameraReturnTimer = 0;
			_movementTimer -= FlxG.elapsed;
			// if (_movementTimer <= 0) {
			// 	FlxG.camera.follow(_playState.player, TOPDOWN, 0.5);
			// }
			// else {
				FlxG.camera.follow(_playState.player, TOPDOWN, 0.05);
			// }
		}
		else {
			FlxG.camera.follow(null, TOPDOWN, 1);
			_movementTimer = 3;
		}
	}
}