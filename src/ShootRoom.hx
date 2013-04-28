package;

import com.eclecticdesignstudio.motion.Actuate;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
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
	public static var score: Int = 0;
	public static var combo (default, setCombo): Int = 1;
	public static var accelerator: Float=1;
	public static var startTime: Int;
	private static var hud: Sprite = new Sprite();
	
	private var targets: Array<Target>;
	private var lastTarget: Int;
	private var hitScreen: Sprite;
	private var cursor: Sprite;
	
	private var scoreField: TextField;
	private var timerField: TextField;
	private var comboField: TextField;

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
		
		scoreField = new TextField();
		scoreField.embedFonts = true;
		timerField = new TextField();
		timerField.embedFonts = true;
		comboField = new TextField();
		comboField.embedFonts = true;
	}
	
	private function onShoot(e:MouseEvent):Void 
	{
		Assets.getSound("sfx/shot.mp3").play();
	}

	private function init(e) 
	{
		var gunSight = new Bitmap(Assets.getBitmapData("img/gun_sight.png"));
		Mouse.hide();
		cursor = new Sprite();
		cursor.addChild(gunSight);
		cursor.x = mouseX - gunSight.width/2;
		cursor.y = mouseY -gunSight.height/2;
		cursor.mouseChildren = cursor.mouseEnabled = false;
		Lib.current.addChild(cursor);
		cursor.startDrag();
		
		var background = new ShootObject(Assets.getBitmapData("img/background.png"), 0.5);
		addChild(background);
		
		hud.x = 50;
		hud.y = 25;
		hud.graphics.beginFill(0xFF0000, 0.4);
		hud.graphics.drawRoundRect(0, 0, 100, 80, 10, 10);
		hud.graphics.endFill();
		
		var scoreFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 20, 0x0062FF, false);
		scoreField.selectable = scoreField.mouseEnabled = false;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.x = 10;
		scoreField.y = 10;
		hud.addChild(scoreField);
		
		comboField.selectable = scoreField.mouseEnabled = false;
		comboField.defaultTextFormat = scoreFormat;
		comboField.x = scoreField.x;
		comboField.y = scoreField.y+40;
		hud.addChild(comboField);
		
		timerField.defaultTextFormat = scoreFormat;
		timerField.selectable = timerField.mouseEnabled = false;
		timerField.y = scoreField.y + 20;
		timerField.x = scoreField.x;
		hud.addChild(timerField);
		
		addChild(hud);
		
		var target = new Target("metal");
		targets.push(target);
		var target2 = new Target("wooden", 0.5);
		var mask2 = new Bitmap(Assets.getBitmapData("img/target.png"));
		mask2.x = woodenCratePos.x+30;
		mask2.y = woodenCratePos.y - target2.height;
		target2.mask = mask2;
		addChild(mask2);
		addChild(target2);
		targets.push(target2);
		var target3 = new Target("column");
		var mask3 = new Bitmap(Assets.getBitmapData("img/target.png"));
		mask3.x = columnPos.x - target3.width;
		mask3.y = columnPos.y+100;
		target3.mask = mask3;
		targets.push(target3);
		var target4 = new Target("barrel");
		var mask4 = new Bitmap(Assets.getBitmapData("img/target.png"));
		mask4.x = barrelPos.x;
		mask4.y = barrelPos.y - target4.height;
		target4.mask = mask4;
		addChild(mask4);
		addChild(target4);
		targets.push(target4);
		
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
		addChild(woodenCrate);
		addChild(mask3);
		addChild(target3);
		addChild(column);
		addChild(target);
		addChild(metalCrate);
		
		startTime = Lib.getTimer ();
	}
	
	public static function setCombo(combo: Int): Int
	{
		ShootRoom.combo = combo;
		if (combo == 5)
			Assets.getSound("sfx/megakill.mp3").play();
		else if (combo == 10)
			Assets.getSound("sfx/monsterkill.mp3").play();
		else if (combo == 20)
			Assets.getSound("sfx/wickedsick.mp3").play();
		
		hud.graphics.clear();
		var red: Int = Math.round(Math.max(255 - (12.75 * combo), 0));
		var green: Int = Math.round(Math.min(12.75 * combo, 255));
		var color = (red & 0xFF) << 16 | (green & 0xFF) << 8 | (00 & 0xFF);
		hud.graphics.beginFill(color,0.4);
		hud.graphics.drawRoundRect(0, 0, 100, 80, 10, 10);
		hud.graphics.endFill();
		
		return combo;
	}
	
	private function onEnterFrame(e: Event) : Void 
	{
		var remainingTime = 30 - Math.round((Lib.getTimer() - startTime) / 1000);
		if(remainingTime > 0){
			if (Lib.getTimer() - lastTarget > 2000*accelerator)  {
				var index = 0;
				do{
					index = Math.floor(Math.random() * 4);
				}while (!targets[index].available);
				targets[index].pop();
				lastTarget = Lib.getTimer();
			}
			for(target in targets){
				if (target.popped && ((Lib.getTimer() - target.aliveTime) > 5000*accelerator)){
					target.push();
					combo = 1;
				}
			}
			timerField.text = remainingTime + "s";
			scoreField.text = score + "pts";
			comboField.text = "x" + ShootRoom.combo;
			if(accelerator > 0.2)
				accelerator -= 0.0009;
		}
		else {
			cursor.stopDrag();
			Mouse.show();
			if(cursor.parent != null)
				cursor.parent.removeChild(cursor);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.CLICK, onShoot);
			addChild(EndScreen.instance);
		}
	}
}

typedef Position = { 
	var x: Float;
	var y: Float;
}