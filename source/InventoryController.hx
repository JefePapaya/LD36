package;

import Inventory;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.FlxG;
using util.SpriteUtil;

class InventoryController extends FlxGroup
{
    public var playerInventory:Inventory;
    public var inventories:Array<Inventory>;
    public var parent:PlayState;

    //Inventory input
    var _inventory:Inventory;
    var _slot:Slot;
    var _item:Item;
    var _holding:Bool = false;
    var _doubleClickTimer:Float = 0.5;

    var _text:FlxText;
    var _grpInteractive:FlxTypedGroup<FlxSprite>;

    var _testInventory:Inventory = new Inventory();

    override public function new(state:PlayState)
    {
        super();

        inventories = new Array<Inventory>();
        parent = state;
        _text = new FlxText(0, 32, FlxG.width, "Inventory", 32);
        _text.alignment = FlxTextAlign.CENTER;
        _text.screenCenter(FlxAxes.X);
        _text.scrollFactor.set();
        add(_text);
        resetInput();
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);
        updateInput();
    }

    public function open(?aditionalInvetories:Array<Inventory> = null)
    {
       //Clean everything to start out fresh
       resetInput;
       _grpInteractive = new FlxTypedGroup<FlxSprite>();
       forEach(function (member:FlxBasic) {
           if (Std.is(member, Inventory)) {
               remove(member);
           }
       });
       inventories = new Array<Inventory>();
       if (aditionalInvetories != null) {
           inventories.concat(aditionalInvetories);
       }

       //Inventory setup
        if (playerInventory != null) {
            playerInventory.setPosition(FlxG.width - playerInventory.width, (FlxG.height - playerInventory.height) / 2);
            inventories.push(playerInventory);
            //Test TODO: Remove
            _testInventory.setPosition(0, (FlxG.height - _testInventory.height) / 2);
            inventories.push(_testInventory);
        }

        for (inv in inventories) {
            _grpInteractive.add(inv.container);
            add(inv);
        }

        //Set scrollfactor to 0 like any HUD
        forEach(function (member:FlxBasic) {
           if (Std.is(member, Inventory)) {
               if (Std.is(member, FlxSprite)) {
                   (cast (member, FlxSprite)).scrollFactor.set();
               }
           }
       });
    }

    /**
        Controls the item flow in inventories
    **/
    function updateInput() 
    {
        #if !FLX_NO_KEYBOARD
        //justpressed -> select item
        //  -> yep
        //  TODO: double click use

        //pressed -> move Item
        //  -> just that


        //justreleased -> drop item
        //  -> grab
        //  -> drop
        //  -> reorder


        if (FlxG.keys.justReleased.ESCAPE) {
            parent.closeInventory();
        }
        #end
        #if !FLX_NO_MOUSE
        updateInventoryInput();
        // if (updateInventoryInput()) {
            
        // }
        if (FlxG.mouse.justReleased) {
            if (!FlxG.mouse.overlaps(_grpInteractive)) {
                parent.closeInventory();
            }
        }
        #end
    }

    function updateInventoryInput()
    {
        var inventory:Inventory = null;
        for (inv in inventories) {
            if (FlxG.mouse.overlaps(inv.container)) {
                inventory = inv;
            }
        }

        //Drag item around
        if (FlxG.mouse.pressed && _item != null) {
            _item.centerInPoint(FlxG.mouse.getScreenPosition());
            _holding = true;
        }
        if (inventory != null && FlxG.mouse.overlaps(inventory.container)) {
            if (FlxG.mouse.justReleased && _item != null) {
                //Place item
                var slot = inventory.getSlotAtPosition(FlxG.mouse.getScreenPosition());
                var tempItem = slot.item;
                if (_slot != null && _item != null) {
                    if (_inventory != inventory) {
                        _inventory.removeItem(_item);
                        inventory.putItem(_item);
                    }
                    else {
                        _slot.item = tempItem;
                        slot.item = _item;
                        inventory.updateItemPositions();
                    }
                }
                resetInput();
            }
            else if (FlxG.mouse.justPressed && _item == null) {
                //Select Item
                _slot = inventory.getSlotAtPosition(FlxG.mouse.getScreenPosition());
                _inventory = inventory;
                if (_slot != null && _slot.item != null) {
                    _item = _slot.item;
                    inventory.removeItem(_item);
                    add(_item);
                }
            }
            else if (!_holding){
                //Clean up
                resetInput();
            }
        }
    }

    function resetInput() {
        _slot = null;
        _item = null;
        _inventory = null;
        _holding = false;
        _doubleClickTimer = 0.5;
        remove(_item);
    }
}