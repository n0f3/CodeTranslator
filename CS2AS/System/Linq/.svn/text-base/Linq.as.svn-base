package System.Linq
{
	import System.Collections.Generic.CSDictionary;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	
	public final class Linq
	{
		public static function All(a:Array):Boolean
		{
			for each(var val:* in a)
				if (!val)
					return false;
			return true;
		}
		
		public static function AllWhere(a:Array, evalItem:Function):Boolean
		{
			for each(var val:* in a)
				if (!evalItem(val))
					return false;
			return true;
		}
		
		public static function OfType(a:Array, typeName:String):Array
		{
			var ret:Array = new Array();
			for each(var val:* in a)
			{
				var valName:String = getQualifiedClassName(val);
				var sepIndex:int = valName.indexOf("::");
				if (sepIndex != -1)
					valName = valName.substr(sepIndex + 2);
					
				if (valName == typeName)
					ret.push(val);
			}
			return ret;
		}
		
		public static function SelectMany(a:Array, select:Function):Array
		{
			var ret:Array = new Array();
			for each (var outer:* in a)
				for each (var inner:* in select(outer))
					ret.push(inner);
			return ret;
		}
		
		public static function Except(a:Array, except:Array):Array
		{
			//Convert except to keys
			var keys:Array = new Array();
			for each(var e:* in except)
				keys[e] = 1;
				
			var ret:Array = new Array();
				
			for each(var val:* in a)
				if (!keys.hasOwnProperty(val))
					ret.push(val);
			return ret;
		}
		public static function Concat(a:Array, b:Array):Array
		{
			var ret:Array = new Array();
			for each(var val1:* in a)
				ret.push(val1);
			for each(var val2:* in b)
				ret.push(val2);
			return ret;
		}
		
		public static function First(a:Array):*
		{
			for each(var val:* in a)
				return val;
			throw new Error("No items");
		}
		public static function FirstWhere(a:Array, where:Function):*
		{
			for each(var val:* in a)
				if (where(val))
					return val;

			throw new Error("Not found");
		}
		public static function FirstOrDefault(a:Array, where:Function):*
		{
			for each(var val:* in a)
				if (where(val))
					return val;

			return null;
		}
		public static function ElementAt(a:Array, loc:int):*
		{
			for each(var val:* in a)
				if (loc-- == 0)
					return val;
			throw new Error("Out of range");
		}
		public static function Last(a:Array):*
		{
			var last:* = null;
			
			for each(var val:* in a)
				last = val;
			if (last == null)
				throw new Error("No items");
			return last;
		}
		public static function Single(a:Array):*
		{
			var item:* = null;
			for each(var val:* in a)
			{
				if (item != null)
					throw new Error("Multiple items");
				item = val;
			}
			if (item == null)
				throw new Error("No items");
			return item;
		}
		public static function SingleOrDefault(a:Array, where:Function):*
		{
			var item:* = null;
			for each(var val:* in a)
			{
				if (!where(val))
					continue;
				
				if (item != null)
					throw new Error("Multiple items");
				item = val;
			}
			return item;
		}
		
		public static function SingleWhere(a:Array, where:Function):*
		{
			var item:* = null;
			for each(var val:* in a)
			{
				if (!where(val))
					continue;
				
				if (item != null)
					throw new Error("Multiple items");
				item = val;
			}
			if (item == null)
				throw new Error("No items");
			return item;
		}
		public static function Count(a:Array):int
		{
			var ret:int = 0;
			for each(var val:* in a)
				ret++;
			return ret;
		}
		public static function Where(a:Array, where:Function):Array
		{
			var ret:Array = new Array();
			
			for each(var val:* in a)
				if (where(val))
					ret.push(val);

			return ret;
		}
		public static function CountWhere(a:Array, where:Function):int
		{
			var ret:int = 0;
			
			for each(var val:* in a)
				if (where(val))
					ret++;

			return ret;
		}
		public static function Select(a:Array, func:Function):Array
		{
			var ret:Array = new Array();
			
			for each(var val:* in a)
				ret.push(func(val));

			return ret;
		}

		public static function ToArray(a:Array):Array
		{
			return ToList(a);
		}
		public static function ToList(a:Array):Array
		{
			var ret:Array = new Array(a.length);
			for (var k:Object in a)
				ret[k] = a[k];
			return ret;
		}
		
		public static function ToDictionary(a:Array, getKey:Function, getVal:Function):CSDictionary
		{
			var ret:CSDictionary = new CSDictionary();
			
			for each(var val:* in a)
				ret.Add(getKey(val), getVal(val));
				
			return ret;
		}
		public static function Any(a:Array):Boolean
		{
			for each(var val:* in a)
				return true;
			return false;
		}
		public static function AnyWhere(a:Array, func:Function):Boolean
		{
			for each(var val:* in a)
				if (func(val))
					return true;
			return false;
		}
		public static function Distinct(a:Array):Array
		{
			var ret:Array = new Array();
			var hash:Array = new Array();
			
			for each(var val:* in a)
				if (!hash.hasOwnProperty(val))
				{
					hash[val] = 1;
					ret.push(val);
				}
			return ret;
		}
		public static function GroupBy(a:Array, func:Function):Array
		{
			var dict:Dictionary = new Dictionary();
			for each(var val:* in a)
			{
				var groupBy:* = func(val);
				
				var grouping:Grouping;
				if (dict[groupBy] == null)
				{
					grouping = new Grouping(groupBy, []);
					dict[groupBy] = grouping;
				}
				else
					grouping = dict[groupBy];
					
				grouping.vals.push(val);
			}
			
			var ret:Array = new Array();
			
			for each(var dictVal:* in dict)
				ret.push(dictVal);
			
			return ret;
		}
		
		public static function Max(a:Array):*
		{
			var ret:Number = Number.MIN_VALUE;
			for each(var i:* in a)
				if (i > ret)
					ret = i;
					
			if (ret == Number.MIN_VALUE)
				throw new Error("No items");
			return ret;
		}
		public static function Min(a:Array):*
		{
			var ret:Number = Number.MAX_VALUE;
			for each(var i:* in a)
				if (i < ret)
					ret = i;
					
			if (ret == Number.MAX_VALUE)
				throw new Error("No items");
			return ret;
		}
		public static function CompareTo(a:*, b:*):int
		{
			return a - b; 
		}
		public static function OrderBy(a:Array, selector:Function):Array
		{
			//Hack: We assume the original passed-in array isn't needed anymore, so we modify it. Linq is supposed to be immutable, but we don't use this for OrderBy.
			a.sort(function (a:*, b:*):int
			{
				var aRet:* = selector(a);
				var bRet:* = selector(b);
				if (aRet > bRet)
					return 1;
				else if (aRet < bRet)
					return -1;
				else
					return 0;
			});
			return a;
		}
		public static function OrderByDescending(a:Array, selector:Function):Array
		{
			var ret:Array = OrderBy(a, selector);
			ret.reverse();
			return ret;
		}
		public static function Sum(a:Array):Number
		{
			var ret:Number = 0;
			for each(var i:* in a)
				ret += i;
			return ret;
		}
	}
}