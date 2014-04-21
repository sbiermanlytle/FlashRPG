package  {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class MapAnimation extends Entity {
		
		public var mLocation:int;
		public var mImage:Spritemap;
		
		public function MapAnimation(coordinate:Point, image:Spritemap, anim:String, location:int) {
			x = coordinate.x*50;
			y = coordinate.y * 50;
			mImage = image;
			graphic = mImage;
			mLocation = location;
			mImage.play(anim);
		}
	}
}