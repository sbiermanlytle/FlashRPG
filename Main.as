package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * @author Sebastian Bierman-Lytle
	*/
	public class Main extends Engine {
		
		public function Main():void {
			super(800, 600, 30, false);
			//FP.console.enable();
		}
		
		override public function init():void {
			trace("FlashPunk Engine has started successfully!");
			FP.screen.color = 0x000000;
			FP.world = new GameWorld();
			super.init();
		}
	}
}