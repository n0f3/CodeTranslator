package System.Collections.Generic
{
	import flash.utils.Dictionary;
	
	public class CSDictionary
	{
		private var store:Dictionary;
		private var numItems:int = 0;
		
		public function CSDictionary(ignoredLength:int = 0)
		{
			store = new Dictionary();
		}
		
		public function Clear():void
		{
			store = new Dictionary();
			numItems = 0;
		}
		
		public function ContainsKey(key:Object):Boolean
		{
			return store[key] != null;
		}
		
		public function Add(key:Object, value:Object):void
		{
			if (ContainsKey(key))
				throw new Error("Duplicate item added");
			store[key] = value;
			numItems++;
		}
		
		public function GetValue(key:Object):*
		{
			if (!ContainsKey(key))
				throw new Error("Attempt to get a value that does not exist");
			return store[key];
		}
		
		public function KeyValues():Array
		{
			var ret:Array = new Array();
			for(var i:* in store)
				ret.push(new KeyValuePair(i, store[i]));
			return ret;
		}
		
		public function SetValue(key:Object, value:Object):void
		{
			if (!ContainsKey(key))
				numItems++;
				
			store[key] = value;
		}
		
		public function get length():int
		{
			return numItems;
		}
		
		public function Remove(key:Object):Boolean
		{
			if (!ContainsKey(key))
				return false;
			delete store[key];
			numItems--;
			return true;
		}
		
		public function get Keys():Array
		{
			var ret:Array = new Array();
			for (var i:* in store)
				ret.push(i);
			return ret;
		}
		
		public function get Values():Array
		{
			var ret:Array = new Array();
			for each (var i:* in store)
				ret.push(i);
			return ret;
		}
		public function Clone():CSDictionary
		{
			var ret:CSDictionary = new CSDictionary();
			for(var i:* in store)
				ret.Add(i, store[i]);
			return ret;
		}
	}
}