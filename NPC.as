package  {
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class NPC extends Character {
		
		//Images
		[Embed(source = 'images/scientist_spritesheet.png')] private const ScientistImages:Class;
		public var sprScientist:Spritemap = new Spritemap(ScientistImages, 50, 73);
		[Embed(source = 'images/red_yellow_girl_spritesheet.png')] private const RedYellowGirlImages:Class;
		public var sprRedYellowGirl:Spritemap = new Spritemap(RedYellowGirlImages, 50, 67);
		[Embed(source = 'images/green_woman_spritesheet.png')] private const GreenWomanImages:Class;
		public var sprGreenWoman:Spritemap = new Spritemap(GreenWomanImages, 50, 65);
		[Embed(source = 'images/blue_green_boy_spritesheet.png')] private const BlueGreenBoyImages:Class;
		public var sprBlueGreenBoy:Spritemap = new Spritemap(BlueGreenBoyImages, 50, 67);
		[Embed(source = 'images/bald_man_spritesheet.png')] private const BaldManImages:Class;
		public var sprBaldMan:Spritemap = new Spritemap(BaldManImages, 50, 73);
		
		//Characters
		public static var SCIENTIST:int = 0; 
		public static var RED_YELLOW_GIRL:int = 1;
		public static var GREEN_WOMAN:int = 2; 
		public static var BLUE_GREEN_BOY:int = 3;
		public static var BALD_MAN:int = 4;
		
		//local data
		private var mPaths:Array;
		private var mCurrentPath:Array;
		private var mCurrentPathIndex:int;
		
		public function NPC(world:GameWorld, location:int, coordinate:Point, direction:int, id:int, character:int, paths:Array) {
			if (coordinate == null) {
				var i:int = (int)(Math.random() * paths.length);
				coordinate = new Point(paths[i][0].x, paths[i][0].y);
			}
			super(world, id, location, coordinate, direction);
			mImage = getImage(character);
			mPaths = paths;
			mMoveSpeed = 4;
			super.initializeGraphics();
			mCurrentPathIndex = 1;
			layer = -100;
		}
		
		override public function update():void {
			super.update();
			if (!isTalking && mCurrentPath == null && mPaths != null && Math.random() < .005) {
				var i:int;
				while (mCurrentPath == null) {
					i = (int)(Math.random() * mPaths.length);
					if (mPaths[i][0].x == mCoordinate.x && mPaths[i][0].y == mCoordinate.y)
						mCurrentPath = mPaths[i];
				}
			}
			if (!isTalking && !isMoving && mCurrentPath != null) {
				if (mCurrentPathIndex == mCurrentPath.length) {
					mCurrentPath = null;
					mCurrentPathIndex = 1;
				}
				else {
					mDirection = mCurrentPath[mCurrentPathIndex];
					if (mCurrentPathIndex == mCurrentPath.length - 1){
						setImageDirection(mDirection);
						mCurrentPathIndex++;
					}
					else if (super.move(mDirection))
						mCurrentPathIndex++;
				}
			}
		}
		
		private function getImage(character:int):Spritemap {
			switch (character) {
				case NPC.SCIENTIST: { y -= 5; return sprScientist; }
				case NPC.RED_YELLOW_GIRL: return sprRedYellowGirl;
				case NPC.GREEN_WOMAN: return sprGreenWoman;
				case NPC.BALD_MAN: { y -= 5;  return sprBaldMan; }
				case NPC.BLUE_GREEN_BOY: return sprBlueGreenBoy;
			}
			return null;
		}
	}
}