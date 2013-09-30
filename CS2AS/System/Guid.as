package System
{
	import flash.utils.ByteArray;
	
	public class Guid
	{
		private var guid:ByteArray; //Store a guid as 16 byte array
		
		public function Guid(data:ByteArray = null)
		{
			if (data == null)
			{
				guid = new ByteArray();
			}
			else
			{
				if (data.length != 16)
					throw new Error("Invalid length");
				guid = data;
			}
		}

		public function ToByteArray():ByteArray
		{
			return guid;
		}
		
		public function toString():String
		{
			return guid.toString();
		}
		
		public static function NewGuid():Guid
		{
			//This isn't a real guid generation routine.  
			//Instead, we just take the easy way out and generate 16 random bytes
			//This is good enough for many uses, but for real guid generation you'll have to do better
			var g:ByteArray = new ByteArray();
			for(var i:int = 0; i < 16; i++)
				g[i] = Math.random() * 256;
			return new Guid(g);
		}
	}
}