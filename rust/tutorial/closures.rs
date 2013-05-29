fn main() {

	fn call_closure_with_ten(b: &fn(int)) {
		b(10);
	}

	let captured_var = 20;
	let closure = |arg| println(fmt!("captured_var=%d, arg=%d", captured_var, arg));

	call_closure_with_ten(closure);


	let square = |x: int| -> uint { x * x as uint };

	// stack closures. very efficient.
	// refer to captured locals by pointer.
	// can only be used as arguments.
	// cannot be stored in data structures or returned from functions.
	let mut max = 0;
	[1,2,3].map(|x| if *x > max { max = *x });

	// managed closures.
	// does not directly access env - copies closed vars into private
	// data structure. therefore cannot assign or observe updates.
	// `@fn` denotes managed closure
	fn mk_appender(suffix: ~str) -> @fn(~str) -> ~str {
		return |s| s + suffix;
	}

	let shout = mk_appender(~"!");
	io::println(shout(~"hey ho, let's go"));

	// owned closures are denoted ~fn.
	// hold things that can safely be sent between processes.
	// copy values but also own them.
	// useful for spawning tasks

	// can also declare closure args as &fn - compatible with any closure type

	// special rules for do and for with closures

}



