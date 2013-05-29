use core::libc::{calloc, free, c_void, size_t};

fn main() {
	// unsafe keyword is a promise to the compiler that
	// unsafety does not leak out of the block
	unsafe {
		let a = calloc(1, int::bytes as size_t);
		let d;
		{
			let b = calloc(1, int::bytes as size_t);
			let c = calloc(1, int::bytes as size_t);
			d = c;
			free(b);
		}
		free(d);
		free(a);
	}
}

// blob struct with private pointer to data
struct Blob { priv ptr: *c_void }

// impl seems to allow us to attach methods to struct
impl Blob {
	fn new() -> Blob {
		unsafe { Blob{ptr: calloc(1, int::bytes as size_t)} }
	}
}

// not sure what this does? a trait maybe?
impl Drop for Blob {
	fn finalize(&self) {
		unsafe { free(self.ptr); }
	}
}

fn foo() {
	let a = Blob::new();
	let d;
	{
		let b = Blob::new();
		let c = Blob::new();
		d = c; // move ownership to d
	} // b is destroyed here
	// d, a destroyed here
}

// no idea what any of this means.
fn bar() {
	let a = ~0;
	let d;
	{
		let b = ~0;
		let c = ~0;
		d = c;
	}
}