package;

import com.eclecticdesignstudio.motion.Actuate;
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
	public static var metalCratePos: Position = { x: 270, y: 428 };
	
	private var targets: Array<Target>;
	private var startTime: Int;
	private var lastTarget: Int;
	private var hitScreen: Sprite;

	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		targets = new Array<Target>();
		addEventListener(MouseEvent.CLICK, onShoot);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
		
		var background = new ShootObject(Assets.getBitmapData("img/background.png"), 0.5);
		addChild(background);
		
		
		var target = new Target("metal");
		targets.push(target);
		var target2 = new Target("wooden", 0.5);
		var mask2 = new Bitmap(Assets.getBitmapData("img/barrel.png"));
		mask2.height += target2.height - 100;
		mask2.x = woodenCratePos.x;
		mask2.y = woodenCratePos.y - target2.height;
		target2.mask = mask2;
		addChild(mask2);
		addChild(target2);
		targets.push(target2);
		var target3 = new Target("column");
		var mask3 = new Bitmap(Assets.getBitmapData("img/column.png"));
		mask3.width += target3.width - 100;
		mask3.x = columnPos.x - target3.width;
		mask3.y = columnPos.y;
		target3.mask = mask3;
		addChild(mask3);
		addChild(target3);
		targets.push(target3);
		var target4 = new Target("barrel");
		var mask4 = new Bitmap(Assets.getBitmapData("img/barrel.png"));
		mask4.height += target4.height - 50;
		mask4.x = barrelPos.x;
		mask4.y = barrelPos.y - target4.height;
		target4.mask = mask4;
		addChild(mask4);
		addChild(target4);
		targets.push(target4);
		
		for (target in targets) {
			target.addEventListener(HitEvent.HIT, hit);
		}
		
		var barrel = new ShootObject(Assets.getBitmapData("img/barrel.png"));
		barrel.x = barrelPos.x;
		barrel.y = barrelPos.y;
		var column = new ShootObject(Assets.getBitmapData("img/column.png"));
		column.x = columnPos.x;
		column.y = columnPos.y;
		var metalCrate = new ShootObject(Assets.getBitmapData("img/metal_crate.png"));
		metalCrate.x = metalCratePos.x;
		metalCrate.y = metalCratePos.y;
		var woodenCrate = new ShootObject(Assets.getBitmapData("img/wooden_crates.png"), 0.5);
		woodenCrate.x = woodenCratePos.x;
		woodenCrate.y = woodenCratePos.y;
		
		addChild(barrel);
		addChild(column);
		addChild(woodenCrate);
		addChild(target);
		addChild(metalCrate);
		
		hitScreen = new Sprite();
		hitScreen.graphics.beginFill(0xFF0000);
		hitScreen.graphics.drawRect(0, 0, width, height);
		hitScreen.graphics.endFill();
		hitScreen.visible = false;
		addChild(hitScreen);
		
		startTime = Lib.getTimer ();
	}
	
	private function onEnterFrame(e: Event) : Void 
	{
		var remainingTime = 90 - Math.round((Lib.getTimer() - startTime) / 1000);
		if (Lib.getTimer() - lastTarget > 2000)  {
			var index = 0;
			do{
				index = Math.floor(Math.random() * 4);
			}while (!targets[index].pop());
				lastTarget = Lib.getTimer();
		}
		for(target in targets){
			if (target.popped && Lib.getTimer() - target.aliveTime > 5000){
				target.push();
			}
		}
	}
	
	private function hit(e: HitEvent) : Void 
	{
		//Actuate.tween(hitScreen, 0.1, { alpha: 0.5 } ).repeat(1).reflect();
	}
}

typedef Position = { 
	var x: Float;
	var y: Float;
}

/**
.onComplete(function()
		{
			hitScreen.visible = false;
			//Actuate.tween(hitScreen, 0.2, { alpha: 0 } );
		});
		*/