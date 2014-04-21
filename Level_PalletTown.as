package  {
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class Level_PalletTown extends Level{
		
		//Location Constants
		public static var TOWN:int = 1;
		public static var HOUSE_LEFT_DOWNSTAIRS:int = 2;
		public static var HOUSE_LEFT_UPSTAIRS:int = 3;
		public static var HOUSE_RIGHT_DOWNSTAIRS:int = 4;
		public static var HOUSE_RIGHT_UPSTAIRS:int = 5;
		public static var LAB:int = 6;
		
		//XML Data
		[Embed(source = "levels/pallet_town/xml/NPC_PalletTown.xml", mimeType = "application/octet-stream")] private static const NPC_XML:Class;
		[Embed(source = "levels/pallet_town/xml/STR_PalletTown.xml", mimeType = "application/octet-stream")] private static const STR_XML:Class;
		
		
		//Map Images & XML Data
		[Embed(source = 'levels/pallet_town/img/pallet_town.jpg')] private const PalletTown_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTown.xml", mimeType = "application/octet-stream")] private static const PalletTown_XML:Class;
		[Embed(source = 'levels/pallet_town/img/pallet_town_house_left_downstairs.jpg')] private const HouseLeftDownstairs_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTownHouseLeftDownstairs.xml", mimeType = "application/octet-stream")] private static const HouseLeftDownstairs_XML:Class;
		[Embed(source = 'levels/pallet_town/img/pallet_town_house_left_upstairs.jpg')] private const HouseLeftUpstairs_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTownHouseLeftUpstairs.xml", mimeType = "application/octet-stream")] private static const HouseLeftUpstairs_XML:Class;
		[Embed(source = 'levels/pallet_town/img/pallet_town_house_right_downstairs.jpg')] private const HouseRightDownstairs_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTownHouseRightDownstairs.xml", mimeType = "application/octet-stream")] private static const HouseRightDownstairs_XML:Class;
		[Embed(source = 'levels/pallet_town/img/pallet_town_house_right_upstairs.jpg')] private const HouseRightUpstairs_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTownHouseRightUpstairs.xml", mimeType = "application/octet-stream")] private static const HouseRightUpstairs_XML:Class;
		[Embed(source = 'levels/pallet_town/img/pallet_town_lab.jpg')] private const PalletTownLab_Image:Class;
		[Embed(source = "levels/pallet_town/xml/PalletTownLab.xml", mimeType = "application/octet-stream")] private static const PalletTownLab_XML:Class;
		
		//Map Animations
		[Embed(source = 'levels/pallet_town/img/pallet_town_house_door_anim.jpg')] private const HouseDoor_Anim:Class;
		public var houseDoorAnim:Spritemap = new Spritemap(HouseDoor_Anim, 50, 59);
		[Embed(source = 'levels/pallet_town/img/pallet_town_lab_door_anim.jpg')] private const LabDoor_Anim:Class;
		public var labDoorAnim:Spritemap = new Spritemap(LabDoor_Anim, 50, 59);
		
		public function Level_PalletTown(world:GameWorld, location:int) {
			super(world, location);
			graphic = new Image(getMapImage());
			loadLevelGrid(getMapXMLData());
			mNPCData = loadXMLData(NPC_XML);
			mStrings = loadXMLData(STR_XML);
			setAnimations();
			loadNPCs();
		}
		
		private function setAnimations():void {
			houseDoorAnim.add("open", [0, 1, 2, 3], 10, false);
			houseDoorAnim.add("close", [3, 2, 1, 0], 10, false);
			labDoorAnim.add("open", [0, 1, 2, 3], 10, false);
			labDoorAnim.add("close", [3, 2, 1, 0], 10, false);
		}
		
		override public function changeLocation(doorCoordinate:Point):Point {
			var playerStart:Point;
			switch(mLocation) {
				case Level_PalletTown.TOWN: {
					switch(doorCoordinate.x) {
						case 13: {
							mLocation = Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS;
							playerStart = new Point(8, 8); break;
						}
						case 15: {
							mLocation = Level_PalletTown.LAB;
							playerStart = new Point(7, 12); break;
						}
						case 22: {
							mLocation = Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS;
							playerStart = new Point(2, 8); break;
						}
					}
					break;
				}
				case Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS: {
					switch(doorCoordinate.y) {
						case 2: {
							mLocation = Level_PalletTown.HOUSE_LEFT_UPSTAIRS;
							playerStart = new Point(7, 1); break;
						}
						case 9: {
							mLocation = Level_PalletTown.TOWN;
							mWorld.createAnimation(new Point(13, 12), houseDoorAnim, "close", mLocation);
							playerStart = new Point(13, 12);
							break;
						}
					}
					break;
				}
				case Level_PalletTown.HOUSE_LEFT_UPSTAIRS: {
					mLocation = Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS;
					playerStart = new Point(8, 2); break;
				}
				case Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS: {
					switch(doorCoordinate.y) {
						case 2: {
							mLocation = Level_PalletTown.HOUSE_RIGHT_UPSTAIRS;
							playerStart = new Point(1, 1); break;
						}
						case 9: {
							mLocation = Level_PalletTown.TOWN;
							mWorld.createAnimation(new Point(22, 12), houseDoorAnim, "close", mLocation);
							playerStart = new Point(22, 12); break;
						}
					}
					break;
				}
				case Level_PalletTown.HOUSE_RIGHT_UPSTAIRS: {
					mLocation = Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS;
					playerStart = new Point(2, 2); break;
				}
				case Level_PalletTown.LAB: {
					mLocation = Level_PalletTown.TOWN;
					mWorld.createAnimation(new Point(15, 20), labDoorAnim, "close", mLocation);
					playerStart = new Point(15, 20); break;
				}
			}
			graphic = new Image(getMapImage());
			mLevelGrid = new Array();
			loadLevelGrid(getMapXMLData());
			mWorld.removeNPCs();
			loadNPCs();
			return playerStart;
		}
		
		override public function openDoorIfNecessary(doorCoor:Point):void {
			if (doorCoor.y == 12) mWorld.createAnimation(doorCoor, houseDoorAnim, "open", mLocation);
			else if (doorCoor.y == 20) mWorld.createAnimation(doorCoor, labDoorAnim, "open", mLocation);
		}
		
		override public function playerNeedsToTurnAround(doorCoor:Point):Boolean {
			switch (mLocation) {
				case Level_PalletTown.HOUSE_LEFT_UPSTAIRS: return true;
				case Level_PalletTown.HOUSE_RIGHT_UPSTAIRS: return true;
				case Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS: {
					if (doorCoor.y == 2) return true;
					else return false;
				}
				case Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS: {
					if (doorCoor.y == 2) return true;
					else return false;
				}
			}
			return false;
		}
		
		override public function getMapImage():Class {
			switch (mLocation) {
				case Level_PalletTown.TOWN: return PalletTown_Image;
				case Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS: return HouseLeftDownstairs_Image;
				case Level_PalletTown.HOUSE_LEFT_UPSTAIRS: return HouseLeftUpstairs_Image;
				case Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS: return HouseRightDownstairs_Image;
				case Level_PalletTown.HOUSE_RIGHT_UPSTAIRS: return HouseRightUpstairs_Image;
				case Level_PalletTown.LAB: return PalletTownLab_Image;
			}
			return null;
		}
		
		override public function getMapXMLData():Class {
			switch (mLocation) {
				case Level_PalletTown.TOWN: return PalletTown_XML;
				case Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS: return HouseLeftDownstairs_XML;
				case Level_PalletTown.HOUSE_LEFT_UPSTAIRS: return HouseLeftUpstairs_XML;
				case Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS: return HouseRightDownstairs_XML;
				case Level_PalletTown.HOUSE_RIGHT_UPSTAIRS: return HouseRightUpstairs_XML;
				case Level_PalletTown.LAB: return PalletTownLab_XML;
			}
			return null;
		}
		
		override public function getInfoContent(x:int, y:int):String {
			switch(mLocation) {
				case Level_PalletTown.TOWN: {
					switch(x) {
						case 15: return "Your House";
						case 20: return "Some other persons house";
						case 23: return "Pallet Town Square";
						case 14: return "Pallet Town Lab";
					}
				}
			}
			return "";
		}
		
		private function loadNPCs():void {
			switch(mLocation) {
				case Level_PalletTown.LAB: {
					mWorld.createNPC(mLocation, null, GameWorld.UP, 2, NPC.SCIENTIST,
						[[new Point(0, 8), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.DOWN, GameWorld.DOWN, GameWorld.LEFT], 
						[new Point(0, 8), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT, GameWorld.UP, GameWorld.UP, GameWorld.UP],
						[new Point(0, 8), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP],
						[new Point(2, 10), GameWorld.UP, GameWorld.UP, GameWorld.LEFT, GameWorld.LEFT, GameWorld.UP],
						[new Point(2, 10), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.LEFT, GameWorld.LEFT, GameWorld.UP, GameWorld.LEFT, GameWorld.UP, GameWorld.UP],
						[new Point(2, 10), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.UP, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.UP],
						[new Point(1, 2), GameWorld.DOWN, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.UP],
						[new Point(1, 2), GameWorld.DOWN, GameWorld.DOWN, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT],
						[new Point(7, 2), GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT, GameWorld.DOWN, GameWorld.LEFT, GameWorld.LEFT, GameWorld.UP, GameWorld.UP],
						[new Point(7, 2), GameWorld.LEFT, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.DOWN, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT]]);
					mWorld.createNPC(mLocation, new Point(10, 10), GameWorld.RIGHT, 5, NPC.SCIENTIST, null);
					return;
				}
				case Level_PalletTown.HOUSE_RIGHT_UPSTAIRS: {
					mWorld.createNPC(mLocation, new Point(7, 2), GameWorld.UP, 3, NPC.RED_YELLOW_GIRL, null);
					return;
				}
				case Level_PalletTown.TOWN: {
					mWorld.createNPC(mLocation, new Point(22, 17), GameWorld.DOWN, 4, NPC.BLUE_GREEN_BOY, 
					[[new Point(22, 17), GameWorld.UP, GameWorld.UP],
					[new Point(22, 16), GameWorld.DOWN, GameWorld.DOWN],
					[new Point(22, 16), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.RIGHT],
					[new Point(24, 16), GameWorld.LEFT, GameWorld.LEFT, GameWorld.LEFT]]);
					return;
				}
				case Level_PalletTown.HOUSE_LEFT_DOWNSTAIRS: {
					mWorld.createNPC(mLocation, null, GameWorld.RIGHT, 1,  NPC.GREEN_WOMAN, 
					[[new Point(2, 6), GameWorld.UP, GameWorld.LEFT, GameWorld.UP, GameWorld.UP, GameWorld.UP],
					[new Point(1, 3), GameWorld.DOWN, GameWorld.DOWN, GameWorld.RIGHT, GameWorld.DOWN, GameWorld.RIGHT]]);
					return;
				}
				case Level_PalletTown.HOUSE_RIGHT_DOWNSTAIRS: {
					mWorld.createNPC(mLocation, null, GameWorld.LEFT, 6, NPC.BALD_MAN, 
					[[new Point(8, 6), GameWorld.UP, GameWorld.RIGHT, GameWorld.UP, GameWorld.UP, GameWorld.LEFT, GameWorld.LEFT, GameWorld.UP],
					[new Point(7, 3), GameWorld.RIGHT, GameWorld.RIGHT, GameWorld.DOWN, GameWorld.DOWN, GameWorld.LEFT, GameWorld.DOWN, GameWorld.LEFT]]);
					return;
				}
			}
		}
	}
}