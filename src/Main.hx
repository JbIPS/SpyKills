package ;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.external.ExternalInterface;
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
		
		//ExternalInterface.addCallback("quit", quit);
		
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
			
			var container = new Sprite();
			container.x = 470;
			container.y = 1000;
			var poster = new Bitmap(Assets.getBitmapData("img/poster_menu.png"));
			container.addChild(poster);
			var title = new TextField();
			title.embedFonts = true;
			title.defaultTextFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 30, TextFormatAlign.CENTER);
			title.text = "Instructions";
			title.width = poster.width;
			title.y = 55;
			title.selectable = title.mouseEnabled = false;
			container.addChild(title);
			
			var text = new TextField();
			text.embedFonts = true;
			text.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway_cd.ttf").fontName, 17, TextFormatAlign.JUSTIFY);
			text.text = "Vous voilà devant les cibles.";
			text.text += "\nEn visant la tête, vous doublez les points et gagnez du temps.";
			text.text += "\nEn en ratant, vous perdez votre bonus. \n\nN'en laissez partir aucune intacte...";
			text.wordWrap = true;
			text.autoSize = TextFieldAutoSize.CENTER;
			text.selectable = text.mouseEnabled = false;
			text.width = poster.width -100;
			text.x = 50;
			text.y = 150;
			container.addChild(text);
			
			Actuate.tween(container, 1, { y: 100 } ).ease(Cubic.easeOut);
			Lib.current.addChild(container);		
		}
	}
	
	public static function quit() {
		while(Lib.current.numChildren > 0){
			Lib.current.removeChildAt(Lib.current.numChildren - 1);
		}
		ShootRoom.score = 0;
		ShootRoom.combo = 1;
		ShootRoom.accelerator = 1;
		new Main();
	}
	
}
