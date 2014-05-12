package  {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class TextBubble extends Entity {
		
		[Embed(source = 'images/info_bubble.png')] private const InfoBubble_Image:Class;
		[Embed(source = 'images/dialogue_bubble.png')] private const DialogueBubble_Image:Class;
		
		public static var SIGNPOST:int = 1;
		public static var NPC_DIALOGUE:int = 2;
		public static var PLAYER_DIALOGUE:int = 3;
		
		public var mDialogueKey:int;
		public var mTextObjects:Array;
		
		public function TextBubble(bubbleType:int, coor:Point, text:String, strings:Array) {
			mTextObjects = new Array();
			switch(bubbleType) {
				case SIGNPOST: {
					x = coor.x * 50 - 190;
					y = coor.y * 50 - 160;
					layer = -400;
					graphic = new Image(InfoBubble_Image);
					mTextObjects.push(new TextObject(text, x+220-(text.length * 8), y + 40));
					break;
				}
				case NPC_DIALOGUE: {
					x = coor.x * 50 - 365;
					y = coor.y * 50 - 280;
					layer = -400;
					graphic = new Image(DialogueBubble_Image);
					mTextObjects.push(new TextObject(text, x+30, y+20));
					break;
				}
				case PLAYER_DIALOGUE: {
					x = coor.x * 50 - 365;
					y = coor.y * 50 + 155;
					layer = -400;
					graphic = new Image(DialogueBubble_Image);
					var yPos:int = y + 20;
					for (var i:int = 0; i < strings.length; i++, yPos +=30)
						mTextObjects.push(new TextObject(strings[i], x + 30, yPos));
					break;
				}
			}
		}
		
		public function changeTextSelection(up:Boolean):void {
			var keepLooking:Boolean = true;
			var i:int = 0;
			while (keepLooking){
				if (mTextObjects[i].isHighlighted)
					keepLooking = false;					
				if (keepLooking) i++;
			}
			if (up && i > 0) {
				mTextObjects[i].unHighlightText();
				mTextObjects[i - 1].highlightText();
				mDialogueKey = i - 1;
			}
			else if (!up && i < mTextObjects.length - 1) {
				mTextObjects[i].unHighlightText();
				mTextObjects[i + 1].highlightText();
				mDialogueKey = i + 1;
			}
		}
	}
}