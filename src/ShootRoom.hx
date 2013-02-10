package;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.ui.Mouse;

/**
 * ...
 * @author jb
 */

class ShootRoom extends Sprite
{
	public static var columnPos: Position = {x: 565, y:0};
	public static var barrelPos: Position = { x: 131, y: 338};
	public static var woodenCratePos: Position = {x: 366, y: 282};
	public static var metalCratePos: Position = {x: 270, y: 428};

	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		addEventListener(MouseEvent.CLICK, onShoot);
	}
	
	private function onShoot(e:MouseEvent):Void 
	{
		Assets.getSound("sfx/shot.mp3").play();
	}

	private function init(e) 
	{
		var gunSight = new Bitmap(Assets.getBitmapData("img/gun_sight.png"));
		Mouse.hide();
		var cursor = new Sprite();
		cursor.addChild(gunSight);
		cursor.x = mouseX - gunSight.width/2;
		cursor.y = mouseY -gunSight.height/2;
		cursor.mouseChildren = cursor.mouseEnabled = false;
		Lib.current.addChild(cursor);
		cursor.startDrag();
		
		var background = new ShootObject(Assets.getBitmapData("img/background.png"));
		addChild(background);
		
		
		var target = new Target("metal");
		var target2 = new Target("wooden");
		var mask2 = new Bitmap(Assets.getBitmapData("img/barrel.png"));
		mask2.height += target2.height - 100;
		mask2.x = woodenCratePos.x;
		mask2.y = woodenCratePos.y - target2.height;
		target2.mask = mask2;
		addChild(mask2);
		addChild(target2);
		var target3 = new Target("column");
		var mask3 = new Bitmap(Assets.getBitmapData("img/column.png"));
		mask3.width += target3.width - 100;
		mask3.x = columnPos.x - target3.width;
		mask3.y = columnPos.y;
		target3.mask = mask3;
		addChild(mask3);
		addChild(target3);
		var target4 = new Target("barrel");
		var mask4 = new Bitmap(Assets.getBitmapData("img/barrel.png"));
		mask4.height += target4.height - 50;
		mask4.x = barrelPos.x;
		mask4.y = barrelPos.y - target4.height;
		target4.mask = mask4;
		addChild(mask4);
		addChild(target4);
		
		var barrel = new ShootObject(Assets.getBitmapData("img/barrel.png"));
		barrel.x = barrelPos.x;
		barrel.y = barrelPos.y;
		var column = new ShootObject(Assets.getBitmapData("img/column.png"));
		column.x = columnPos.x;
		column.y = columnPos.y;
		var metalCrate = new ShootObject(Assets.getBitmapData("img/metal_crate.png"));
		metalCrate.x = metalCratePos.x;
		metalCrate.y = metalCratePos.y;
		var woodenCrate = new ShootObject(Assets.getBitmapData("img/wooden_crates.png"));
		woodenCrate.x = woodenCratePos.x;
		woodenCrate.y = woodenCratePos.y;
		
		addChild(barrel);
		addChild(column);
		addChild(woodenCrate);
		addChild(target);
		addChild(metalCrate);
		
		start();
	}
	
	private function start() : Void 
	{
	}
}

typedef Position = { 
	var x: Float;
	var y: Float;
}