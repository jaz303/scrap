struct Point {
	x: float,
	y: float
}

// essentially a safe tagged-union
enum Shape {
	Pixel(Point),
	Circle(Point, float),
	Rectangle(Point, Point)
}

// the above could also be written as structs:
enum StructShape {
	SPixel { position: Point },
	SCircle { center: Point, radius: float },
	SRectangle { top_left: Point, top_right: Point }
}

// no need to parameterise enum members
enum Direction {
	North, East, South, West
}

// or we can assign values directly
// if a value is omitted, it defaults to the value of the previous variant
// plus one. if the first variant does not not have a value, it is zero
// (these are "C-like" enumerations. they can be cast to ints.)
enum Color {
	Red 	= 0xff0000,
	Green	= 0x00ff00,
	Blue	= 0x0000ff
}

fn main() {

	let mut mypoint = Point { x: 1.0, y: 1.0 };
	let origin = Point { x: 0.0, y: 0.0 };

	mypoint.x = 0.0;

	match mypoint {
		// trailing ", _" indicates we we are not interested in the rest of the struct
		Point { x: 0.0, _ }			=> io::println("x is zero!"),
		Point { x: xx, y: yy }		=> io::println(xx.to_str() + " " + yy.to_str())
	}

	let mycircle = Circle(origin, 10f);


	// tuples are just like structs except their members do not have names
	let tup: (int,int,int) = (10,20,30);

	// can also have Tuple Structs. they are named, e.g.
	// Bar(1,2) != Foo(1,2)
	struct MyBar(int, int);
	struct MyFoo(int, int);

	// single field => "newtype"
	// this is a distinct int type
	struct GizmoId(int);
	let my_gizmo_id: GizmoId = GizmoId(10);
	let gizmo_int: int = *my_gizmo_id;

	// types are being inferred here
	let hello = "hello"; // local var, immutable
	let mut count = 0; // local var, mutable

	// explicit types
	static monster_factor : float = 57.8; // static variables require types
	let monster_size = monster_factor * 10.0; 
	let monster_size : int = 50; // this declaration shadows the one on the previous line

	// if statement as expression
	// note there are no semicolons on each branch, but a semicolon terminating the
	// if statement. this is important.
	let foo = 10;
	let bar =
		if foo < 10 {
			20
		} else if foo < 20 {
			30
		} else {
			40
		};

	loop {
		while count < 10 {
			io::println(fmt!("count: %?", count));
			count += 1;
		}

		// match must be exhaustive
		match 20 {
			0		=> io::println("zero!"),
			1 | 2 	=> io::println("1 or 2"),
			3..10 	=> io::println("three to ten"),
			_		=> io::println("who knows?")
		}

		return;
	}

}

// to get at the contents of an enum with multiple variants, need to use destructuring
fn area(sh: Shape) -> float {
	match sh {
		Pixel(*) // the '*' here says all fields are ignored
			=> 0f,
		Circle(_, size) // underscore ignores a single field
			=> float::consts::pi * size * size,
		Rectangle(Point { x: x1, y: y1 }, Point { x: x2, y: y2 })
			=> (x2 - x1) * (y2 - y1)
	}
}

fn mk_tuple() -> (float, float) {
	return (1.0f, 2.0f);
}

// (float, float) is a tuple of 2 floats
fn angle(vector: (float, float)) -> float {
	let pi = float::consts::pi;

	// let can also destructure
	let (foo, bar) = mk_tuple();

	// destructuring
	// note the guard on the first arm
	match vector {
		(0f, y) if y < 0f	=> 1.5 * pi,
		(0f, y)				=> 0.5 * pi,
		(x, y)				=> float::atan(y / x)
	}
}


fn foo() {
	// can do any combination of (i,u) and (8,16,32,64)
	// literals can be decimal, hex or binary
	let a = 1;
	let b = 10i;
	let c = 100u;
	let d = 1000i32;
	let e = 500u64;

	let f : float = 1.0;
	let g : f32 = 2.0;
	let h : f64 = 4.0;

	// casting
	let i : uint = g as uint;

	//io::println(fmt!("%d %d %d %d %d %f %f %f %u", a, b, c, d, e, f, g, h, i));
}


fn is_four(x: int) -> bool {
	x == 4 // no need for a return statement here
}