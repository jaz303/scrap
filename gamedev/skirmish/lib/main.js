var vec2 = require('fd-vec2');

var canvas, ctx;
var bodies;
var walls;
var people;
var testRay;
var collisionPoint;

var CIRCLE = 1;
var SEGMENT = 2;
var RAY = 3;

function seg(x1, y1, x2, y2) {
	return {
		type: SEGMENT,
		p1: vec2.make(x1, y1),
		p2: vec2.make(x2, y2)
	};
}

function circle(cx, cy, r) {
	return {
		type: CIRCLE,
		center: vec2.make(cx, cy),
		radius: r,
		radiusSq: r * r
	};
}

window.init = function() {
	canvas = document.getElementById('canvas');
	ctx = canvas.getContext('2d');

	walls = [
		seg(20, 20, 400, 20),
		seg(20, 20, 20, 400),
		seg(20, 400, 50, 400),
		seg(50, 400, 50, 50),
		seg(50, 50, 400, 50),
		seg(400, 50, 400, 20),

		seg(200, 200, 250, 150),
		seg(250, 150, 300, 200),
		seg(300, 200, 250, 250),
		seg(250, 250, 200, 200),

		seg(520, 300, 550, 300),
		seg(550, 300, 550, 470),
		seg(550, 470, 250, 470),
		seg(250, 470, 250, 440),
		seg(250, 440, 520, 440),
		seg(520, 440, 520, 300)
	];

	people = [
		circle(100, 100, 15),
		circle(400, 300, 15),
		circle(350, 100, 15),
		circle(160, 450, 15)
	];

	var mouseIsDown = false;
	var mousePos = vec2.zero();

	canvas.addEventListener('mousedown', function(evt) {
		mouseIsDown = true;
		testRay = {
			type: RAY,
			origin: vec2.zero(),
			direction: vec2.zero()
		};
	});

	canvas.addEventListener('mouseup', function(evt) {
		mouseIsDown = false;
		testRay = null;
	});

	canvas.addEventListener('mousemove', function(evt) {
		mousePos.x = evt.offsetX;
		mousePos.y = evt.offsetY;
	});

	var lastTick = Date.now();

	setInterval(function() {
		var now = Date.now();
		if (now - lastTick <= 0) return;

		var delta = (now - lastTick) / 1000;

		collisionPoint = null;

		if (mouseIsDown) {
			var vec = mousePos.sub(people[0].center);
			vec.normalize_();

			testRay.direction.x = vec.x;
			testRay.direction.y = vec.y;

			vec.mul_(150 * delta);
			people[0].center.add_(vec);

			var mtv = vec2.make();

			for (var i = 1; i < people.length; ++i) {
				if (collideCircleCircle(people[i], people[0], mtv)) {
					people[0].center.add_(mtv);
				}
			}

			for (var i = 0; i < walls.length; ++i) {
				if (collideSegmentCircle(walls[i], people[0], mtv)) {
					mtv.x *= -1;
					mtv.y *= -1;
					people[0].center.add_(mtv);
				}
			}

			testRay.origin.x = people[0].center.x;
			testRay.origin.y = people[0].center.y;
			
			var closestDistanceSq = Infinity;
			var closestPoint = vec2.make();
			var closestBody = null;

			var point = vec2.make();

			for (var i = 0; i < walls.length; ++i) {
				if (intersectRaySegment(testRay, walls[i], point)) {
					var d = testRay.origin.distancesq(point);
					if (d < closestDistanceSq) {
						closestDistanceSq = d;
						closestPoint.x = point.x;
						closestPoint.y = point.y;
						closestBody = walls[i];
					}
				}
			}

			for (var i = 1; i < people.length; ++i) {
				if (intersectRayCircle(testRay, people[i], point)) {
					var d = testRay.origin.distancesq(point);
					if (d < closestDistanceSq) {
						closestDistanceSq = d;
						closestPoint.x = point.x;
						closestPoint.y = point.y;
						closestBody = walls[i];
					}
				}
			}

			if (closestBody) {
				collisionPoint = closestPoint;
			}
		}

		draw();

		lastTick = now;
	}, 1000 / 30);
}

function draw() {

	ctx.clearRect(0, 0, canvas.width, canvas.height);

	ctx.strokeStyle = '#000000';
	ctx.fillStyle = '#ffffff';

	function drawOne(b) {
		switch (b.type) {
			case CIRCLE:
				ctx.beginPath();
				ctx.arc(b.center.x, b.center.y, b.radius, 0, Math.PI * 2, false);
				ctx.fill();
				ctx.stroke();
				break;
			case SEGMENT:
				ctx.beginPath();
				ctx.moveTo(b.p1.x, b.p1.y);
				ctx.lineTo(b.p2.x, b.p2.y);
				ctx.stroke();
				break;
			case RAY:
				ctx.beginPath();
				ctx.moveTo(b.origin.x, b.origin.y);
				ctx.lineTo(b.origin.x + b.direction.x * 10000, b.origin.y + b.direction.y * 10000);
				ctx.stroke();
				break;
			default:
				throw new Error("unknown body type: " + b.type);
		}
	}

	if (testRay) {
		if (collisionPoint) {
			ctx.beginPath();
			ctx.moveTo(people[0].center.x, people[0].center.y);
			ctx.lineTo(collisionPoint.x, collisionPoint.y);
			ctx.stroke();
		} else {
			drawOne(testRay);
		}
	}

	walls.forEach(drawOne);
	people.forEach(drawOne);

	if (collisionPoint) {
		ctx.strokeStyle = '#ff0000';
		ctx.beginPath();
		ctx.moveTo(collisionPoint.x - 5, collisionPoint.y - 5);
		ctx.lineTo(collisionPoint.x + 5, collisionPoint.y + 5);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(collisionPoint.x - 5, collisionPoint.y + 5);
		ctx.lineTo(collisionPoint.x + 5, collisionPoint.y - 5);
		ctx.stroke();
	}

}

// TODO: optimise this
function intersectRaySegment(ray, segment, point) {
	var v1 = ray.origin.sub(segment.p1);
	var v2 = segment.p2.sub(segment.p1);
	var v3 = vec2.make(-ray.direction.y, ray.direction.x);
	var v2dotv3 = v2.dot(v3);

	var t1 = (v2.x*v1.y - v2.y*v1.x) / v2dotv3;
	var t2 = v1.dot(v3) / v2dotv3;

	if (t1 >= 0 && t2 >= 0 && t2 <= 1) {
		point.x = ray.origin.x + (t1 * ray.direction.x);
		point.y = ray.origin.y + (t1 * ray.direction.y);
		return true;
	}

	return false;
}

function intersectRayCircle(ray, circle, point) {

	var o = ray.origin.sub(circle.center);
	var s = ray.direction;

	// Transform to local coordinates
	// LocalP1 = LineP1 – CircleCentre
	// LocalP2 = LineP2 – CircleCentre
	// Precalculate this value. We use it often
	// P2MinusP1 = LocalP2 – LocalP1 

	// a = (P2MinusP1.X) * (P2MinusP1.X) + (P2MinusP1.Y) * (P2MinusP1.Y)
	var a = s.x*s.x + s.y*s.y;

	// b = 2 * ((P2MinusP1.X * LocalP1.X) + (P2MinusP1.Y * LocalP1.Y))
	var b = 2 * ((s.x * o.x) + (s.y * o.y));

	// c = (LocalP1.X * LocalP1.X) + (LocalP1.Y * LocalP1.Y) – (Radius * Radius)
	var c = (o.x * o.x) + (o.y * o.y) - circle.radius * circle.radius;

	var delta = b*b - (4*a*c);

	if (delta < 0) {
		return false;
	} else if (delta === 0) {
		var u = -b / (2 * a);
		point.x = ray.origin.x + (u * s.x);
		point.y = ray.origin.y + (u * s.y);
		return true;
	} else {
		var drt = Math.sqrt(delta);
		var u2 = (-b - drt) / (2 * a);
		point.x = ray.origin.x + (u2 * s.x);
		point.y = ray.origin.y + (u2 * s.y);

		return point.sub(ray.origin).dot(ray.direction) > 0;

		// return point.dot(ray.origin) > 0;
	}


	// if (delta < 0) // No intersection
	// 	return null;
	// else if (delta == 0) // One intersection
	// 	u = -b / (2 * a)
	// 	return LineP1 + (u * P2MinusP1)
	// 	/* Use LineP1 instead of LocalP1 because we want our answer in global
	// 	   space, not the circle's local space */
	// else if (delta > 0) // Two intersections
	// 	SquareRootDelta = sqrt(delta)

	// 	u1 = (-b + SquareRootDelta) / (2 * a)
	// 	u2 = (-b - SquareRootDelta) / (2 * a)

	// 	return { LineP1 + (u1 * P2MinusP1) ; LineP1 + (u2 * P2MinusP1)}



	// point.x = circle.center.x;
	// point.y = circle.center.y;
	// return true;
}

function collideCircleCircle(b1, b2, mtv) {
	vec2.sub(b2.center, b1.center, mtv);

	var totalRadius = b1.radius + b2.radius;
	if (mtv.magnitudesq() >= totalRadius*totalRadius) {
	    return false;
	}

	var mag = mtv.magnitude();
	
	mtv.div_(mag);
	mtv.mul_(-(mag - totalRadius));

	return true;
}

function collideSegmentCircle(segment, circle, mtv) {
	var segmentVector       = segment.p2.sub(segment.p1);
	var segmentEndToCentre  = circle.center.sub(segment.p1);

	var t = segmentEndToCentre.dot(segmentVector) / segmentVector.magnitudesq();
	if (t < 0) t = 0;
	if (t > 1) t = 1;

	var projected = segmentVector.mul(t);
	var closest = segment.p1.add(projected);
	var closestToCenter = circle.center.sub(closest);
	var distSq = vec2.magnitudesq(closestToCenter);

	if (distSq < circle.radius * circle.radius) {
		var dist = Math.sqrt(distSq);
		vec2.div(closestToCenter, dist, mtv);
	    mtv.mul_(dist - circle.radius);
		return true;
	} else {
		return false;
	}
}