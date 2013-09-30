package System.Collections.Generic
{
	import flash.utils.Dictionary;
	
	public class HashSet
	{
		private var arr:Dictionary;
		private var count:int;
		
		public function HashSet()
		{
			arr = new Dictionary();
			count = 0;
		}

		public function Add(key:Object):void
		{
			if (!Contains(key))
			{
				arr[key] = 1;
				count++;
			}
		}
		
		public function Contains(key:Object):Boolean
		{
			return arr[key] != null;
		}
		
		public function Remove(key:Object):Boolean
		{
			if (Contains(key))
			{
				delete arr[key];
				count--;
				return true;
			}
			else
				return false;
		}
		
		public function Values():Array
		{
			var ret:Array = new Array();
			for(var i:* in arr)
				ret.push(i);
			return ret;
		}
		
		public function get length():int
		{
			return count;
		}
	}
}