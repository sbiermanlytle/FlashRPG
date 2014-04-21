package  
{
	import flash.text.Font;
	import flash.text.TextField;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class TextObject extends Entity{
		
		public var mText:Text;
		public var isHighlighted:Boolean;
		
		public function TextObject(text:String, x:int, y:int) {
			mText = new Text(text, x, y, 0, 0);
			isHighlighted = false;
			Text.size = 25;
			layer = -400;
			graphic = mText;
		}
		
		public function changeText(nuText:String):void {
			mText.text = nuText;
		}
		
		public function highlightText():void {
			mText.color = 0xFFFF00;
			isHighlighted = true;
		}
		
		public function unHighlightText():void {
			mText.color = 0xFFFFFF;
			isHighlighted = false
		}
		
		/*public static function GetWidth(inStr:String, inFont:String, inTextFormat:TextFormat = null):Number {
            var tFormat:TextFormat;
			
            if(inTextFormat == null){
            tFormat = new TextFormat();
            tFormat.size = 12;
            tFormat.align = TextFormatAlign.LEFT;
            tFormat.font = inFont;
            tFormat.rightMargin = 1;

            }else{
           
                tFormat = inTextFormat;
               
            }
           
            var testField:TextField = new TextField();
            testField.autoSize = TextFieldAutoSize.LEFT;
            testField.multiline = false;
            testField.wordWrap = false;
            testField.embedFonts = true;
            testField.antiAliasType = AntiAliasType.ADVANCED;
            testField.defaultTextFormat = tFormat;
            testField.text = inStr;
           
            return Math.floor(testField.width);
        }
		
		public static function WordWrap(txt:String, wid:int, font:String):String {
			//txt: the text to wordwrap
			//wid: The maximum width of the text in pixels
			//font: The font to use when measuring width (assumes font size of 12)
			var buffer:String = "";
			var i:int;
			
			for (i = 0; i <= txt.length; i += 1) {
				buffer += txt.substr(i, 1);			// Add txt to buffer, one character at a time.
				if (GetWidth(buffer, font) > wid) {	// If the text is widerthan given "wid".
					i = buffer.lastIndexOf(" ");	// move back to the last space.
					buffer = buffer.slice(0, i);	// delete everything after it.
					buffer += "\n";					// Add a line break.
					if (txt.substr(i + 1, 1) == " ") i += 1;	//If there's a space after the next line, skip it.
				}
				
			}
			return buffer;		//return complete text with line breaks.
		}*/
	}

}