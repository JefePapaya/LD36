package object;

import system.Signals;
import flixel.FlxG;
import system.TiledParser;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;
using flixel.util.FlxSpriteUtil;

class Tree extends Entity
{
    public var woodCount:Int = 2;
    var _tween:FlxTween;
    var _damage:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, ?type:Int = -1) 
    {
        super(X, Y);

        woodCount = FlxG.random.int(GameConfig.TREE_MIN_DROP, GameConfig.TREE_MAX_DROP);
        //Initialize
        if (type == -1) {
            type = FlxG.random.int(0, 2);
        }
        _tween = null;
        health = 3;
        //Graphics
        loadGraphic(AssetPaths.tree__png, true, 64, 84);
        animation.add("snow", [0], 1, false);
        animation.add("dark", [1], 1, false);
        animation.add("light", [2], 1, false);
        animation.add("cut", [3], 1, false);
        setBounds();
        frame = frames.frames[type];
    }

    override public function setBounds() {
        offset.x = (width - 32) / 2;
        offset.y = height - 32;
        width = 32;
        height = 32;
        x += offset.x;
        y += offset.y;
    }

    override public function hurt(damage:Float) {
        if (_tween != null || health <= 0) {
            return;
        }
        _damage = damage;
        _tween = FlxTween.tween(this, {x: x+6}, 0.125, {onComplete: function(tween:FlxTween){
            _tween = FlxTween.tween(this, {x: x-6}, 0.125, {ease:FlxEase.backOut, onComplete: finishCutTween});
        }});
    }
    function finishCutTween(tween:FlxTween) {
        _tween = null;
        super.hurt(_damage);
    }

    override public function kill() {
        alive = false;
        flicker(0.25, null, null, false, function (effect:FlxFlicker){
            animation.play("cut");
            var excludeValues:Array<Int> = [0];
            for (i in 0...woodCount) {
                var wood = new Item(x, y);
                wood.name = Item.WOOD;
                var offset = Math.round(frameWidth/2);
                var xPos = Math.round(x) + FlxG.random.int(-offset, offset, excludeValues);
                excludeValues.push(xPos);
                var pos = new FlxPoint(xPos, y - wood.height);
                TiledParser.loadEntityGraphic(wood, Item.WOOD);
                Signals.drop.dispatch(wood, pos); 
            }
        }, null);
    }
}