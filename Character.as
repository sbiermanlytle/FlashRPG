package  {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;

	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class Character extends Entity {
		
		//local data
		public var mID:int;
		protected var mWorld:GameWorld;
		public var mLocation:int
		public var isMoving:Boolean;
		public var isTalking:Boolean;
		protected var mMoveSpeed:int;
		protected var firstAnim:Boolean;
		public var mCoordinate:Point;
		public var mDirection:int;
		protected var mMoveDistance:int;
		protected var mImage:Spritemap;
		public var movedThroughDoor:Boolean;
		public var needToTurnAround:Boolean;
		
		public function Character(world:GameWorld, id:int, location:int, coordinate:Point, direction:int) {
			mWorld = world;
			mID = id;
			mLocation = location;
			mCoordinate = coordinate;
			mDirection = direction;
			x = coordinate.x * 50;
			y = coordinate.y * 50 - 25;
			isMoving = false;
			isTalking = false;
			movedThroughDoor = false;
			needToTurnAround = false;
			layer = -100;
		}
		
		
		override public function update():void {
			super.update();
			if (!isTalking && isMoving)
				updateMovement();
		}
		
		protected function initializeGraphics():void {
			graphic = mImage;
			mImage.add("walk down one", [4, 0], mMoveSpeed, false);
			mImage.add("walk up one", [5, 1], mMoveSpeed, false);
			mImage.add("walk down two", [8, 0], mMoveSpeed, false);
			mImage.add("walk up two", [9, 1], mMoveSpeed, false);
			mImage.add("walk left", [6, 10, 2], mMoveSpeed+4, false);
			mImage.add("walk right", [7, 11, 3], mMoveSpeed+4, false);
			mImage.add("stand down", [0], 0, false);
			mImage.add("stand up", [1], 0, false);
			mImage.add("stand left", [2], 0, false);
			mImage.add("stand right", [3], 0, false);
			setImageDirection(mDirection);
		}
		
		public function move(direction:int):Boolean {
			var destinationCoor:Point = new Point(mCoordinate.x, mCoordinate.y);
			mDirection = direction;
			switch (direction) {
				case GameWorld.RIGHT: {
					destinationCoor.x += 1;
					isMoving = mWorld.characterMoveRequest(this, destinationCoor);
					if (isMoving) mImage.play("walk right");
					else mImage.play("stand right");
					break; 
				}
				case GameWorld.LEFT: {
					destinationCoor.x -= 1;
					isMoving = mWorld.characterMoveRequest(this, destinationCoor);
					if (isMoving) mImage.play("walk left");
					else mImage.play("stand left");
					break; 
				}
				case GameWorld.UP: {
					destinationCoor.y -= 1;
					isMoving = mWorld.characterMoveRequest(this, destinationCoor);
					if (isMoving) {
						if (firstAnim) mImage.play("walk up one");
						else mImage.play("walk up two"); 
						firstAnim = !firstAnim;
					}
					else mImage.play("stand up");
					break;  
				}
				case GameWorld.DOWN: {
					destinationCoor.y += 1;
					isMoving = mWorld.characterMoveRequest(this, destinationCoor);
					if (isMoving) {
						if (firstAnim) mImage.play("walk down one");
						else mImage.play("walk down two"); 
						firstAnim = !firstAnim;
					}
					else mImage.play("stand down");
					break; 
				}
			}
			return isMoving;
		}
		
		private function updateMovement():void {
			var moveAmount:int = mMoveSpeed;
			if (50-mMoveDistance < mMoveSpeed) moveAmount = 50-mMoveDistance;
			switch (mDirection) {
				case GameWorld.RIGHT: { x += moveAmount; break; }
				case GameWorld.LEFT: { x -= moveAmount; break; }
				case GameWorld.UP: { y -= moveAmount; break; }
				case GameWorld.DOWN: { y += moveAmount; break; }
			}
			mMoveDistance += moveAmount;
			if (mMoveDistance == 50) {
				mMoveDistance = 0;
				switch(mDirection) {
					case GameWorld.RIGHT: { mCoordinate.x += 1; break; }
					case GameWorld.LEFT: { mCoordinate.x -= 1; break; }
					case GameWorld.UP: { mCoordinate.y -= 1; break; }
					case GameWorld.DOWN: { mCoordinate.y += 1; break; }
				}
				switch(mDirection) {
					case GameWorld.RIGHT: { mImage.play("stand right"); break; }
					case GameWorld.LEFT: { mImage.play("stand left"); break; }
					case GameWorld.UP: { mImage.play("stand up"); break; }
					case GameWorld.DOWN: { mImage.play("stand down"); break; }
				}
				if (movedThroughDoor){
					changeCoordinate(mWorld.changeLocation(mCoordinate));
					movedThroughDoor = false;
				}
				isMoving = needToTurnAround;
				needToTurnAround = false;
				if (isMoving) {
					switch(mDirection) {
						case GameWorld.UP: { 
							mDirection = GameWorld.DOWN; 
							if (firstAnim) mImage.play("walk down one"); 
							else mImage.play("walk down two"); 
							firstAnim = !firstAnim;
							break;
						}
						case GameWorld.DOWN: {
							mDirection = GameWorld.UP; 
							if (firstAnim) mImage.play("walk up one");
							else mImage.play("walk up two");
							firstAnim = !firstAnim;
							break;
						}
					}
				}
			}
		}
		
		protected function setImageDirection(direction:int):void {
			switch (direction) {
				case GameWorld.RIGHT: mImage.play("stand right"); return;
				case GameWorld.LEFT: mImage.play("stand left"); return;
				case GameWorld.UP: mImage.play("stand up"); return;
				case GameWorld.DOWN: mImage.play("stand down"); return;
			}
		}
		
		public function changeCoordinate(nuCoor:Point):void {
			mCoordinate = nuCoor;
			x = nuCoor.x*50; y = nuCoor.y*50-25;
		}
	
		public function initializeConversation(directionToTurnToward:int):void {
			isTalking = true;
			switch(directionToTurnToward) {
				case GameWorld.UP: setImageDirection(GameWorld.DOWN); break;
				case GameWorld.DOWN: setImageDirection(GameWorld.UP); break;
				case GameWorld.RIGHT: setImageDirection(GameWorld.LEFT); break;
				case GameWorld.LEFT: setImageDirection(GameWorld.RIGHT); break;
			}
		}
		
		public function endConversation():void {
			isTalking = false;
			setImageDirection(mDirection);
		}
	}
}