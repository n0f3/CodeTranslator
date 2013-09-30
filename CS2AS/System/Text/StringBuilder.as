package System.Text
{
	public class StringBuilder
	{
		private var buffer:String;
		
		public function StringBuilder(initial:* = null)
		{
			if (initial == null)
			{
				buffer = "";
				return;
			}

			if (typeof(initial) == "string")
				buffer = initial;
			else
				throw new Error("Invalid init");
		}
		
		public function Insert(location:int, ins:String):void
		{
			buffer = buffer.substring(0, location) + ins + buffer.substring(location + ins.length);
		}
		
		public function toString():String
		{
			return buffer;  
		}
		
		public function Append(append:String):void
		{
			buffer += append;
		}
		
		public function InsertChar(location:int, char:int):void
		{
			Insert(location, String.fromCharCode(char));
		}
		
		public function AppendChar(char:int):void
		{
			Append(String.fromCharCode(char));
		}
	}
}