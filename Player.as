package {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import flash.geom.Point;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class Player extends Character {
		
		[Embed(source = 'images/maleherosheet.png')] private const PlayerImages:Class;
		public var sprMaleHero:Spritemap = new Spritemap(PlayerImages, 50, 68);
		public var isInputting:Boolean = false;
		
		public function Player(world:GameWorld, id:int, location:int, coordinate:Point, direction:int) {
			super(world, id, location, coordinate, direction);
			mImage = sprMaleHero;
			mMoveSpeed = 6;
			super.initializeGraphics();
			layer = -200;
		}
		
		override public function update():void {
			super.update();
		}
	}

}