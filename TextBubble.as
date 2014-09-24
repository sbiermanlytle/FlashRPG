package  {
	import flash.display.Graphics;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.utils.Key;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class TextBubble extends Entity {
		
		[Embed(source = 'images/info_bubble.png')] private const InfoBubble_Image:Class;
		[Embed(source = 'images/dialogue_bubble.png')] private const DialogueBubble_Image:Class;
		[Embed(source = 'images/input_selector.png')] private const Input_Selector:Class;
		
		public static var SIGNPOST:int = 1;
		public static var NPC_DIALOGUE:int = 2;
		public static var PLAYER_DIALOGUE:int = 3;
		public static var USER_INPUT:int = 4;
		public static var CHAR_WIDTH:int = 15;
		
		public var mDialogueKey:int;
		public var mTextObjects:Array;
		public var mPrompt:TextObject;
		public var mSelector:Graphic;
		public var mBlanks:Array = new Array();
		public var mInputs:Array = new Array();
		public var mRow:int = 2;
		public var mCol:int = 1;
		public var mBlank:int = 1;
		public var mSubmit:Boolean = false;		
		
		
		
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
				case USER_INPUT: {					
					x = coor.x * 50 - 365;
					y = coor.y * 50 + 155;
					layer = -400;
					mSelector = new Image(Input_Selector);
					graphic = new Graphiclist(new Image(DialogueBubble_Image), mSelector);
					for (i = 0; i < text.length; i++) {
						if (text.substr(i, 2) == " _") {
							mBlanks.push(i + 1);
							mInputs.push("123");
						}
					}
					mPrompt = new TextObject(text, x + 30, y + 20);
					
					for (i = 0; i < strings.length; i++) {
						mTextObjects.push(new TextObject(strings[i], (x + 30) + ((i % 5) * 150), (y + 60) + (Math.floor(i / 5) * 30)));
					}
					mTextObjects.push(new TextObject("<Submit>", x + 650, y + 120));	
					
					
					mSelector.x = 55 + (mBlanks[0] * CHAR_WIDTH);
					mSelector.y = 45;
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
		
		public function changeInputSelection(direction:String):void {
			trace(mRow, mCol);
			if (direction == "up" && mRow > 1) {
				if (mRow == 2) {
					mPrompt.highlightText();
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
				}else {	
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
					if (mRow == Math.floor(mTextObjects.length / 5) + 2 && mCol == mTextObjects.length % 5) {
						mCol = 5;
					}
					mTextObjects[(mRow - 3) * 5 + (mCol - 1)].highlightText();
				}				
				mRow -= 1;
			}
			
			if (direction == "down" && mRow < (mTextObjects.length/5 + 1) && mCol <= mTextObjects.length % 5) {
				if (mRow == 1) {
					mRow += 1;
					mPrompt.unHighlightText();
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].highlightText();					
				}else if (mTextObjects.length > ((mRow - 1) * 5) + mCol - 1) {
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
					mRow += 1;
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].highlightText();											
				}
			}else if (direction == "down" && ((mRow * 5) + (mCol - 1)) > mTextObjects.length) {
				trace("flag");
				mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
				mRow = Math.floor(mTextObjects.length / 5) + 2;
				mCol = mTextObjects.length % 5;
				mTextObjects[(mRow - 2) * 5 + (mCol - 1)].highlightText();											
			}
			
			if (direction == "left") {
				if (mRow == 1 && mBlank > 1) {
					mBlank -= 1;
					mSelector.x = 55 + (mBlanks[mBlank - 1] * CHAR_WIDTH);
				}else if ((mRow == 2 && mCol > 1) || (mRow > 2)) {
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
					if (mCol == 1) {
						mRow -= 1;
						mCol = 5;
					}else { mCol -= 1;}
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].highlightText();
				}
			}
			
			if (direction == "right") {
				if (mRow == 1 && mBlank < mBlanks.length) {
					mBlank += 1;
					mSelector.x = 55 + (mBlanks[mBlank - 1] * CHAR_WIDTH);
				}else if (mRow > 1 && mTextObjects.length > ((mRow - 2) * 5 + mCol)) {
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].unHighlightText();
					if (mCol == 5) {
						mRow += 1;
						mCol = 1;
					}else { mCol += 1;}
					mTextObjects[(mRow - 2) * 5 + (mCol - 1)].highlightText();
				}
			}			
		}
		
		public function handleInput(deleteInput:Boolean):void {
			var newInput:String;
			var wasHighlighted:Boolean;
			if (deleteInput) {
				if (mRow == 1) {
					mPrompt.mText.text = mPrompt.mText.text.slice(0, mBlanks[mBlank - 1] + 1) + mPrompt.mText.text.slice(mBlanks[mBlank - 1] + mInputs[mBlank - 1].length + 1, mPrompt.mText.text.length);
					mInputs[mBlank - 1] = "123";
					mPrompt.mText.text = mPrompt.mText.text.slice(0, mBlanks[mBlank - 1] + 1) + "___" + mPrompt.mText.text.slice(mBlanks[mBlank - 1] + 1, mPrompt.mText.text.length);					
					mBlanks = new Array();
					for (var i:int = 0; i < mPrompt.mText.text.length; i++) {
						if (mPrompt.mText.text.substr(i, 2) == " _") {
							mBlanks.push(i + 1);							
						}
					}
				}
			}else {
				if (mRow > 1 && mTextObjects[mTextObjects.length - 1].isHighlighted == false ) {
					mPrompt.mText.text = mPrompt.mText.text.slice(0, mBlanks[mBlank - 1] + 1) + mPrompt.mText.text.slice(mBlanks[mBlank - 1] + mInputs[mBlank - 1].length + 1, mPrompt.mText.text.length);
					mInputs[mBlank - 1] = mTextObjects[(mRow - 2) * 5 + (mCol - 1)].mText.text;
					mPrompt.mText.text = mPrompt.mText.text.slice(0, mBlanks[mBlank - 1] + 1) + mInputs[mBlank - 1] + mPrompt.mText.text.slice(mBlanks[mBlank - 1] + 1, mPrompt.mText.text.length);
					mBlanks = new Array();
					for (i = 0; i < mPrompt.mText.text.length; i++) {
						if (mPrompt.mText.text.substr(i, 2) == " _") {
							mBlanks.push(i + 1);							
						}
					}
					
				}else if (mTextObjects[mTextObjects.length - 1].isHighlighted == true) {
					mSubmit = true;
					for (i = 0; i < mPrompt.mText.text.length; i++) {
						if (mPrompt.mText.text.charAt(i) == "_") {
							mPrompt.mText.text = mPrompt.mText.text.replace("_", "");				
						}
					}					
				}
			}
			wasHighlighted = mPrompt.isHighlighted;
			mPrompt = new TextObject(mPrompt.mText.text, x + 30, y + 20);	
			if (wasHighlighted) { mPrompt.highlightText()};
			
		}
		
	}
}