package System
{
	public class Enumerable
	{
		public static function Range(start:int, count:int):Array
		{
			var ret:Array = new Array();
			for(var i:int = 0; i < count;i++)
				ret.push(i + start);
			return ret;
		}
	}
}