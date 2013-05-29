struct Point {
	x: float,
	y: float
}

fn main() {

	// point is created on stack
	let a = Point{x: 0f, y: 0f};

	// a is copied
	let b = a;

	// ~ is an 'owned box'... a uniquely owned allocation on the heap
	// purpose is to allow creation of recursive data structures or cheaply
	// pass around large objects
	let x = ~5;
	let mut y = ~5;
	*y += 2;

	// 'managed box'... lifetime is managed by task-local garbage collector
	// destroyed when no refs to box remain, no later than end of task
	// managed boxes don't have an owner - starts a new ownership tree
	let m = @5; // immutable
	let mut n = @5; // mutable variable, immutable box
	n = @10;

	let o = @mut 5; // immutable variable, mutable box
	*o = 10;

	let mut p = @mut 5; // mutable variable, mutable box
	*p += 20;
	p = @mut 30;

	let f = ~5; // owned box
	let g = f.clone(); // newly allocated box
	let h = f; // h now `owns` value. f can no longer be used.
	// the above is called "move semantics"
	// applies when ownership tree of copies value includes owned box
	// or a type with a custom destructor

}

// the & denotes a "borrowed pointer" - allows function to act on point,
// no matter how it was allocated (on stack, managed or owned box).
// there are limitations on what you can do with a borrowed pointer.
// can't send to another task, can free or change its type
fn compute_distance_sq(p1: &Point, p2: &Point) -> float {
	let dx = p1.x - p2.x;
	let dy = p2.y - p2.y;
	dx * dx + dy * dy
}

fn freeze() {
	let mut x = 5;
	{
		let y = &x; // x is frozen, cannot be modified
	}
	// x is unfrozen now
}

// other notes:
// dot operator automatically dereferences, as does indexing operator