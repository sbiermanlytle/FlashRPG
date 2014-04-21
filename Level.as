package  {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import flash.utils.ByteArray;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class Level extends Entity {
		
		public static const IMPASSABLE:int = -1;
		public static const PASSABLE:int = -2;
		public static const DOOR:int = -3;
		public static const DOOR_IMPASSABLE:int = -4;
		public static const INFO:int = -5;
		
		protected var mWorld:GameWorld;
		protected var mLevelGrid:Array;
		public var mLocation:int;
		protected var mNPCData:XML;
		protected var mStrings:XML;
		
		public function Level(world:GameWorld, loctaion:int) {
			mWorld = world;
			mLocation = loctaion;
			mLevelGrid = new Array();
		}
		
		public function getMapImage():Class {
			return null;
		}
		
		public function getMapXMLData():Class {
			return null;
		}
		
		public function getCoordinateData(xCoor:int, yCoor:int):int {
			return mLevelGrid[xCoor][yCoor];
		}
		
		public function changeLocation(doorCoor:Point):Point {
			return null;
		}
		
		public function playerNeedsToTurnAround(doorCoor:Point):Boolean {
			return false;
		}
		
		public function openDoorIfNecessary(doorCoor:Point):void {
		}
		
		public function getInfoContent(x:int, y:int):String {
				return "";
		}
		
		private function getXMLData(xml:Class):XML {
			var ramData:ByteArray = new xml;
			var dataString:String = ramData.readUTFBytes(ramData.length);
			return new XML(dataString);
		}
		
		public function occupyNewCoordinate(oldCoor:Point, nuCoor:Point, id:int):void {
			mLevelGrid[oldCoor.x][oldCoor.y] = Level.PASSABLE;
			mLevelGrid[nuCoor.x][nuCoor.y] = id;
		}
		public function occupyCoordinate(coordinate:Point, id:int):void {
			mLevelGrid[coordinate.x][coordinate.y] = id;
		}
		
		protected function loadLevelGrid(xml:Class):void {
			var mapData:XML = loadXMLData(xml);
			var dataElement:XML;
			var dataList:XMLList = mapData.grid.element;
			
			for (var i:int = 0; i < int(mapData.width); i++) {
				var xArray:Array = new Array();
				for (var j:int = 0; j < int(mapData.height); j++) {
					xArray.push(0);
				}
				mLevelGrid.push(xArray);
			}
			
			var data:String;
			
			var x:int;
			var y:int;
			for each (dataElement in dataList) {
				x = dataElement.@x;
				y = dataElement.@y;
				data = dataElement.@type;
				if (data == "impassable") mLevelGrid[int(dataElement.@x)][int(dataElement.@y)] = Level.IMPASSABLE;
				else if (data == "door") mLevelGrid[int(dataElement.@x)][int(dataElement.@y)] = Level.DOOR;
				else if (data == "door-impassable") mLevelGrid[int(dataElement.@x)][int(dataElement.@y)] = Level.DOOR_IMPASSABLE;
				else if (data == "info") mLevelGrid[int(dataElement.@x)][int(dataElement.@y)] = Level.INFO;
				else  mLevelGrid[int(dataElement.@x)][int(dataElement.@y)] = Level.PASSABLE;
			}
		}
		
		protected function loadXMLData(xml:Class):XML {
			var ramData:ByteArray = new xml;
			var dataString:String = ramData.readUTFBytes(ramData.length);
			return new XML(dataString);
		}
		
		public function getNPCDialogue(key:String):String {
			var dataElement:XML;
			var dataList:XMLList = mStrings.element;
			for each (dataElement in dataList)
				if (String(dataElement.@ref) == key)
					return dataElement.@value;
			return "No String Found!!";
		}
		
		public function getPlayerDialogue(root:String):Array {
			var dataElement:XML;
			var dataList:XMLList = mStrings.element;
			var strings:Array = new Array();
			for each (dataElement in dataList)
				if (String(dataElement.@ref).slice(0, String(dataElement.@ref).length - 1) == root)
					strings.push(String(dataElement.@value));
			var key:int = int(Math.random() * 5 + 1);
			for each (dataElement in dataList)
				if (String(dataElement.@ref) == "NPC.0.goodbye" + key){
					strings.push(String(dataElement.@value));
					return strings;
				}
			return strings;
		}
	}
}