package  {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;

	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class GameWorld extends World {
		
		//direction constants
		public static var RIGHT:int = 1;
		public static var LEFT:int = 2;
		public static var UP:int = 3;
		public static var DOWN:int = 4;
		
		//game objects
		private var mPlayer:Player;
		private var mLevel:Level;
		private var moveSpeed:int;
		private var mNPCs:Array;
		private var mMapAnimations:Array;
		private var mInfoBubble:TextBubble;
		private var mNPCDialogueBubble:TextBubble;
		private var mPlayerDialogueBubble:TextBubble;
		private var mTalkingNPCKey:int;
		private var mDialoguePath:Array = new Array();
		private var mPlayerDialogueReference:String;
		private var mNPCDialogueReference:String;
		private var mKeyBeingPressed:Boolean = false;
		
		
		
		public function GameWorld() {
			mMapAnimations = new Array();
			mNPCs = new Array();
			mLevel = new Level_PalletTown(this, Level_PalletTown.HOUSE_LEFT_UPSTAIRS);
			add(mLevel);
			mPlayer = new Player(this, 0, mLevel.mLocation, new Point(5, 3), GameWorld.DOWN);
			add(mPlayer);
			mLevel.occupyCoordinate(mPlayer.mCoordinate, mPlayer.mID);
		}
		
		override public function update():void {
			super.update();
			checkInput();
			if (mPlayer.isMoving || camera.x != mPlayer.x - 375 || camera.y != mPlayer.y - 265)
				updateCamera();
			if (mMapAnimations.length > 0)
				updateMapAnimations();
		}
		
		private function updateMapAnimations():void {
			for (var i:int = 0; i < mMapAnimations.length; i++) {
				if (mMapAnimations[i].mImage.complete || mMapAnimations[i].mLocation != mLevel.mLocation) {
					remove(mMapAnimations[i]);
					mMapAnimations.splice(i, 1);
				}
			}
		}
		
		private function checkInput():void {
			if (!mPlayer.isMoving && !mPlayer.isTalking) {
				//Check player movement
				if (Input.check(Key.RIGHT) || Input.check(Key.D))
					movePlayer(GameWorld.RIGHT);
				else if (Input.check(Key.LEFT) || Input.check(Key.A))
					movePlayer(GameWorld.LEFT);
				else if (Input.check(Key.UP) || Input.check(Key.W))
					movePlayer(GameWorld.UP);
				else if (Input.check(Key.DOWN) || Input.check(Key.S))
					movePlayer(GameWorld.DOWN);
				//Check Action key (E)
				else if (Input.check(Key.E))
					handleActionKey();
			}
			else if (mPlayer.isTalking) {
				if (Input.check(Key.ENTER) || Input.check(Key.D)){
					if (mKeyBeingPressed == false) {
						handleDialogue();
						mKeyBeingPressed = true;
					}
				}
				else if (Input.check(Key.W) || Input.check(Key.UP)){
					if (mKeyBeingPressed == false){
						mPlayerDialogueBubble.changeTextSelection(true);
						mKeyBeingPressed = true;
					}
				}
				else if (Input.check(Key.S) || Input.check(Key.DOWN)){
					if (mKeyBeingPressed == false) {
						mPlayerDialogueBubble.changeTextSelection(false);
						mKeyBeingPressed = true;
					}
				}
				else mKeyBeingPressed = false;
				
			}
		}
		
		private function movePlayer(direction:int):void {
			if (mInfoBubble != null) {
				remove(mInfoBubble);
				remove(mInfoBubble.mTextObjects[0]);
				mInfoBubble = null;
			}
			mPlayer.move(direction);
		}
		
		private function handleActionKey():void {
			var actionX:int = mPlayer.mCoordinate.x;
			var actionY:int = mPlayer.mCoordinate.y;
			switch (mPlayer.mDirection) {
				case GameWorld.UP: { actionY -= 1; break; }
				case GameWorld.DOWN: { actionY += 1; break; }
				case GameWorld.LEFT: { actionX -= 1; break; }
				case GameWorld.RIGHT: { actionX += 1; break; }
			}
			var gridData:int = mLevel.getCoordinateData(actionX, actionY);
			if (gridData == Level.INFO && mPlayer.mDirection == GameWorld.UP) {
				createInfoBubble(mLevel.getInfoContent(actionX, actionY));
			}
			else if (gridData > 0) {
				for (var i:int = 0; i < mNPCs.length; i++)
					if (mNPCs[i].mID == gridData) { mNPCs[i].initializeConversation(mPlayer.mDirection); mTalkingNPCKey = i; }
				mPlayer.isTalking = true;
				createDialogueBubbles();
			}
		}
		
		private function updateCamera():void {
			camera.x = mPlayer.x - 375;
			camera.y = mPlayer.y - 265;
		}
		
		public function changeLocation(doorCoor:Point):Point {
			return mLevel.changeLocation(doorCoor);
		}
		
		public function characterMoveRequest(character:Character, coor:Point):Boolean {
			if (coor.x < 0 || coor.y < 0)
				return false;
			var yCoorDown:int = coor.y + 1;
			var yCoorUp:int = coor.y - 1;
			for each (var npc:NPC in mNPCs) {
				if (npc != character && npc.mCoordinate.x == coor.x) {
					if (npc.mCoordinate.y == coor.y)
						return false;
					else if (npc.mCoordinate.y == yCoorDown) {
						character.layer = -100;
						npc.layer = -200;
					}
					else if (npc.mCoordinate.y == yCoorUp) {
						character.layer = -200;
						npc.layer = -100;
					}
				}
				else if (npc == character) {
					if (yCoorDown == mPlayer.mCoordinate.y) {
						character.layer = -100;
						mPlayer.layer = -200;
					}
					else if (yCoorUp == mPlayer.mCoordinate.y) {
						character.layer = -200;
						mPlayer.layer = -100;
					}
				}
			}
			var coordinateData:int = mLevel.getCoordinateData(coor.x, coor.y);
			if (character == mPlayer) {
				switch (coordinateData) {
				case Level.PASSABLE: { mLevel.occupyNewCoordinate(character.mCoordinate, coor, character.mID); return true; }
				case Level.DOOR: { 
					mPlayer.movedThroughDoor = true;
					mLevel.openDoorIfNecessary(coor);
					if (mLevel.playerNeedsToTurnAround(coor)) mPlayer.needToTurnAround = true;
					return true;
				}
				case Level.DOOR_IMPASSABLE: {
					mPlayer.changeCoordinate(changeLocation(coor));
					return true;
				}
				case Level.IMPASSABLE: return false;
				}
			}
			else {
				if (coor.x == mPlayer.mCoordinate.x && coor.y == mPlayer.mCoordinate.y)
					return false;
				switch (coordinateData) {
				case Level.PASSABLE: { mLevel.occupyNewCoordinate(character.mCoordinate, coor, character.mID); return true; }
				case Level.DOOR: return true;
				}
				return false;
			}
			return false;
		}
		
		public function createAnimation(coordinate:Point, images:Spritemap, anim:String, location:int):void {
			var nuAnim:MapAnimation = new MapAnimation(coordinate, images, anim, location);
			add(nuAnim);
			mMapAnimations.push(nuAnim);
		}
		public function createNPC(location:int, coordinate:Point, direction:int, id:int, character:int, paths:Array):void {
			var nuNPC:NPC = new NPC (this, location, coordinate, direction, id, character, paths);
			mNPCs.push(nuNPC);
			add(nuNPC);
			mLevel.occupyCoordinate(nuNPC.mCoordinate, nuNPC.mID);
		}
		public function removeNPCs():void {
			for each (var npc:NPC in mNPCs)
				remove(npc);
			mNPCs.splice(0, mNPCs.length);
		}
		
		public function createInfoBubble(content:String):void {
			if (mInfoBubble == null) {
				mInfoBubble = new TextBubble(TextBubble.SIGNPOST, mPlayer.mCoordinate, content, null);
				add(mInfoBubble);
				add(mInfoBubble.mTextObjects[0]);
			}
		}
		
		public function createDialogueBubbles():void {
			mNPCDialogueBubble = new TextBubble(TextBubble.NPC_DIALOGUE, mPlayer.mCoordinate, mLevel.getNPCDialogue("NPC." + mNPCs[mTalkingNPCKey].mID + ".line"), null);
			add(mNPCDialogueBubble);
			add(mNPCDialogueBubble.mTextObjects[0]);
			
			mPlayerDialogueBubble = new TextBubble(TextBubble.PLAYER_DIALOGUE, mPlayer.mCoordinate, "", mLevel.getPlayerDialogue("NPC." + mNPCs[mTalkingNPCKey].mID + ".response"));
			mPlayerDialogueBubble.mTextObjects[0].highlightText();
			add(mPlayerDialogueBubble);
			for (var i:int = 0; i < mPlayerDialogueBubble.mTextObjects.length; i++)
				add(mPlayerDialogueBubble.mTextObjects[i]);
				
			mPlayerDialogueBubble.mDialogueKey = 0;
		}
		
		private function handleDialogue():void {
			if (mPlayerDialogueBubble.mDialogueKey == mPlayerDialogueBubble.mTextObjects.length - 1){
			exitDialogue();
			}
			else{
				mDialoguePath.push(mPlayerDialogueBubble.mDialogueKey + 1);
				remove(mNPCDialogueBubble);
				remove(mNPCDialogueBubble.mTextObjects[0]);
				remove(mPlayerDialogueBubble);
				for (var i:int = 0; i < mPlayerDialogueBubble.mTextObjects.length; i++)
				remove(mPlayerDialogueBubble.mTextObjects[i]);
				
				mNPCDialogueReference = "NPC." + mNPCs[mTalkingNPCKey].mID + ".line";
				mPlayerDialogueReference = "NPC." + mNPCs[mTalkingNPCKey].mID + ".response";
				
				for (i = 0; i < mDialoguePath.length; i++)
				{
					mNPCDialogueReference = mNPCDialogueReference + "." + mDialoguePath[i];
					mPlayerDialogueReference = mPlayerDialogueReference + "." + mDialoguePath[i];
				}
				
				
				
										
				mNPCDialogueBubble = new TextBubble(TextBubble.NPC_DIALOGUE, mPlayer.mCoordinate, mLevel.getNPCDialogue(mNPCDialogueReference), null);
				add(mNPCDialogueBubble);
				add(mNPCDialogueBubble.mTextObjects[0]);
				
				mPlayerDialogueBubble = new TextBubble(TextBubble.PLAYER_DIALOGUE, mPlayer.mCoordinate, "", mLevel.getPlayerDialogue(mPlayerDialogueReference));
				mPlayerDialogueBubble.mTextObjects[0].highlightText();
				add(mPlayerDialogueBubble);
				for (i = 0; i < mPlayerDialogueBubble.mTextObjects.length; i++)
				add(mPlayerDialogueBubble.mTextObjects[i]);
			}
		}
		
		private function exitDialogue():void {
			mPlayer.endConversation();
			mNPCs[mTalkingNPCKey].endConversation();
			remove(mNPCDialogueBubble);
			remove(mNPCDialogueBubble.mTextObjects[0]);
			remove(mPlayerDialogueBubble);
			for (var i:int = 0; i < mPlayerDialogueBubble.mTextObjects.length; i++)
				remove(mPlayerDialogueBubble.mTextObjects[i]);
				
			mDialoguePath.length = 0;
			
		}
	}
}