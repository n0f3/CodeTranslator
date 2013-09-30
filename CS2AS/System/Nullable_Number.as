package System
{
	public class Nullable_Number
	{
		private var val:Number;
		private const nullValue:Number = -2147483647; 
		
		public function Nullable_Number(initial:Number = nullValue)
		{
			val = initial;
		}
		
		public function get Value():Number
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