package ;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.geom.Point;

/**
 * ...
 * @author jb
 */

class ShootObject extends Sprite
{

	public function new(bitmapData: BitmapData) 
	{
		super();
		addChild(new Bitmap(bitmapData));
		addEventListener(MouseEvent.CLICK, onHit);
	}
	
	public function init(point: Point) : Void 
	{
		x = point.x;
		y = point.y;
	}
	
	private function onHit(e: MouseEvent) : Void 
	{
		var hit = new Bitmap(Assets.getBitmapData("img/bullet_hole.png"));
		hit.x = e.localX - 5;
		hit.y = e.localY - 5;
		addChild(hit);
	}
	
}