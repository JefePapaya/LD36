package system;

import flixel.util.FlxSignal;
import object.Item;
import flixel.math.FlxPoint;

class Signals
{
    public static var drop = new FlxTypedSignal<Item->FlxPoint->Void>(); 
}