package ;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author jb
 */

class Main extends Sprite 
{
	
	private static var instr: Bool = false;
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		var bg = new Bitmap(Assets.getBitmapData("img/bckgd_menu.png"));
		Lib.current.addChild(bg);
        
		var format = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 25, 0xFFFFFF, true, TextFormatAlign.CENTER);
		var newButton: TextField = new TextField();
		newButton.embedFonts = true;
		newButton.autoSize = TextFieldAutoSize.CENTER;
		//newButton.border = true;
		newButton.selectable = false;
		newButton.defaultTextFormat = format;
		newButton.text = "NEW GAME";
		
		var button1 = new Sprite();
		button1.buttonMode = true;
		button1.mouseChildren = false;
		button1.addChild(newButton);
        button1.addEventListener(MouseEvent.CLICK, startMethod);
        button1.x = 270;
        button1.y = 150;
		button1.graphics.beginFill(0, 0.01);
		button1.graphics.drawRect(-45, 0, button1.width + 65, button1.height);
		button1.graphics.endFill();
        Lib.current.addChild(button1);

        var instrButton = new TextField();
		instrButton.embedFonts = true;
		instrButton.autoSize = TextFieldAutoSize.CENTER;
		instrButton.defaultTextFormat = format;
		//instrButton.border = true;
		instrButton.selectable = false;
		instrButton.text = "INSTRUCTIONS";
        
		var button2 = new Sprite();
		button2.buttonMode = true;
		button2.mouseChildren = false;
		button2.addChild(instrButton);
        button2.x = 240;
        button2.y = 340;
        button2.addEventListener(MouseEvent.CLICK, showInstr);
		button2.graphics.beginFill(0,0.01);
		button2.graphics.drawRect(-65, 0, button1.width + 30, button1.height);
		button2.graphics.endFill();
        Lib.current.addChild(button2);
		
		
		//Lib.current.addChild(new ShootRoom());
	}
	
	public static function startMethod(e: MouseEvent) : Void 
	{
		while (Lib.current.numChildren > 0)
			Lib.current.removeChildAt(Lib.current.numChildren - 1);
		
		Lib.current.addChild(new ShootRoom());
	}
	
	public static function showInstr(e: MouseEvent) : Void 
	{
		if(!instr){
			var poster = new Bitmap(Assets.getBitmapData("img/poster_menu.png"));
			poster.x = 470;
			poster.y = 1000;
			Actuate.tween(poster, 1, { y: 100 } ).ease(Cubic.easeOut);
			Lib.current.addChild(poster);		
		}
	}
	
}
