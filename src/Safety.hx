#if macro
import haxe.macro.Context;
import safety.macro.SafeAst;
#end

import haxe.Unsafe;

class Safety {

	/**
	 *  Returns `value` if it is not `null`. Otherwise returns `defaultValue`.
	 */
	static public inline function or<T>(value:Null<T>, defaultValue:T):T {
		return value == null ? defaultValue : (value:Unsafe<T>);
	}

	/**
	 *  Returns `value` if it is not `null`. Otherwise throws an exception.
	 *  @throws NullPointerException if `value` is `null`.
	 */
	static public inline function sure<T>(value:Null<T>):T {
		return value == null ? throw new safety.NullPointerException('Null pointer in .sure() call') : (value:Unsafe<T>);
	}

	/**
	 *  Just returns `value` without any checks, but typed as not-nullable. Use at your own risk.
	 */
	static public inline function unsafe<T>(value:Null<T>):T {
		return (value:Unsafe<T>);
	}

	/**
	 *  Applies `callback` to `value` and returns the result if `value` is not `null`.
	 *  Returns `null` otherwise.
	 */
	static public inline function let<T,V>(value:Null<T>, callback:T->V):Null<V> {
		return value == null ? null : callback((value:Unsafe<T>));
	}

	/**
	 *  Passes `value` to `callback` if `value` is not null.
	 */
	static public inline function run<T>(value:Null<T>, callback:T->Void) {
		if(value != null) callback((value:Unsafe<T>));
	}

	/**
	 *  Applies `callback` to `value` if `value` is not `null`.
	 *  Returns `value`.
	 */
	static public inline function apply<T>(value:Null<T>, callback:T->Void):Null<T> {
		if(value != null) callback((value:Unsafe<T>));
		return value;
	}

#if macro

	/**
	 *  Add this call to hxml to make public methods in specified `path` to throw `NullPointerException`
	 *  if someone passes `null` as an argument value and that argument is not nullable.
	 *  ```
	 *  public function job(str:String) {...}
	 *  <...>
	 *  job(null); //throws safety.NullPointerException
	 *  ```
	 *  Example for hxml:
	 *  ```
	 *  --macro Safety.safeApi('my.pack', true)
	 *  ```
	 *  @param path - Dot-path of a package or a fully qualified type name.
	 *  @param recursive - Should we also apply to all sub-packages of `path`?
	 */
	static public function safeApi(path:String, recursive:Bool = true) {
		SafeAst.addSafeApi(path, recursive);
	}

	/**
	 *  Add this call to hxml to enable safe navigation operator `!.`:
	 *  ```
	 *  var s:Null<String> = null;
	 *  trace(s!.length); //null
	 *  s = 'wow';
	 *  trace(s!.length); //3
	 *  ```
	 *  Example for hxml:
	 *  ```
	 *  --macro Safety.safeNavigation('my.pack', true)
	 *  ```
	 *  @param path - Dot-path of a package or a fully qualified type name.
	 *  @param recursive - Should we also apply to all sub-packages/sub-types of `path`?
	 */
	static public function safeNavigation(path:String, recursive:Bool = true) {
		SafeAst.addSafeNavigation(path, recursive);
	}

	/**
	 *  Add this call to hxml to enable auto-casting all array declarations to `SafeArray`:
	 *  Example for hxml:
	 *  ```
	 *  --macro Safety.safeArray('my.pack', true)
	 *  ```
	 *  @param path - Dot-path of a package or a fully qualified type name.
	 *  @param recursive - Should we also apply to all sub-packages/sub-types of `path`?
	 */
	static public function safeArray(path:String, recursive:Bool = true) {
		SafeAst.addSafeArray(path, recursive);
	}

	/**
	 * Check if compilation is running in display mode.
	 */
	@:allow(safety)
	static function isDisplay():Bool {
		#if display
			return true;
		#end
		return Context.defined('display');
	}
#end
}