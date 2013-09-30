package System
{
	public class Nullable_int
	{
		private var val:int;
		private const nullValue:int = -2147483647; 

		public function Nullable_int(initial:int = nullValue)
		{
			val = initial;
		}
		
		public function get Value():int
		{
			if (!HasValue)
				throw new Error("Tried to access the value of a null Nullable_Number");
				
			return val;
		}
		
		public function get HasValue():Boolean
		{
			return val != nullValue;
		}
		
		public function toString():String
		{
			if (!HasValue)
				return "";
			else
				return val.toString();
		}

	}
}