package {
	import flash.geom.Point;
	
	/**
	 * @author Michael S. Li
	 */
	public class PointNode {
		
		private var point:Point;
		private var precursor:PointNode = null;
			
		public function PointNode(pt:Point) {
			point = pt;
		}
		
		public function getX():int {
			return point.x;
		}
		
		public function getY():int {
			return point.y;
		}
		
		public function setPrecursor(pc:PointNode):void {
			precursor = pc;
		}
		
		public function getPrecursor():PointNode {
			return precursor;
		}
	}
	
}