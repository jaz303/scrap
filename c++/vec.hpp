#include <iostream>
#include <math.h>

using namespace std;

template <class T>
class vec2
{
    friend ostream& operator<<(ostream &out, const vec2<T> &v) { out << '<' << v.x << ',' << v.y << '>'; return out; }
    
public:
    vec2() : x(0), y(0) { }
    vec2(T x_, T y_) : x(x_), y(y_) { }
    vec2(const vec2<T> &other) : x(other.x), y(other.y) { }
    
    bool        operator==(const vec2<T> &rhs) { return x == rhs.x && y == rhs.y; }
    bool        operator!=(const vec2<T> &rhs) { return x != rhs.x || y != rhs.y; }
    
    vec2<T>&    operator=(const vec2<T> &rhs) { if (this != &rhs) { x = rhs.x; y = rhs.y; } return *this; }
    
    vec2<T>     operator+(const vec2<T> &rhs) { vec2<T>(x + rhs.x, y + rhs.y); }
    vec2<T>     operator-(const vec2<T> &rhs) { vec2<T>(x - rhs.x, y - rhs.y); }
    vec2<T>     operator*(const T &rhs) { vec2<T>(x * rhs, y * rhs); }
    vec2<T>     operator/(const T &rhs) { vec2<T>(x / rhs, y / rhs); }
    
    bool        zero() const { return x == 0 && y == 0; }
    
    T           magnitude() const { return sqrt(x * x + y * y); }
    T           squared() const { return x * x + y * y; }
    
    vec2<T>     normalise() const { T m = magnitude(); return vec2<T>(x / m, y / m); }
    vec2<T>     limit(T max) const { T m = magnitude(); if (m > max) { T div = m / max; return vec2<T>(x / div, y / div); } else { return *this; } }
    
    T           distance(const vec2<T> &rhs) const { return sqrt((rhs.x - x) * (rhs.x - x) + (rhs.y - y) * (rhs.y - y)); }
    
    // heading
    // angleBetween
    // vectorBetween
    
    T           dot(const vec2<T> &other) const { return x * other.x + y * other.y; }
    
    const T x, y;
};

template <class T>
class vec3
{
    friend ostream& operator<<(ostream &out, const vec3<T> &v) { out << '<' << v.x << ',' << v.y << ',' << v.z << '>'; return out; }
    
public:
    vec3() : x(0), y(0), z(0) { }
    vec3(T x_, T y_, T z_) : x(x_), y(y_), z(z_) { }
    vec3(const vec3<T> &other) : x(other.x), y(other.y), z(other.z) { }
    
    bool        operator==(const vec3<T> &rhs) { return x == rhs.x && y == rhs.y && z == rhs.z; }
    bool        operator!=(const vec3<T> &rhs) { return x != rhs.x || y != rhs.y || z != rhs.z; }
    
    vec3<T>&    operator=(const vec3<T> &rhs) { if (this != &rhs) { x = rhs.x; y = rhs.y; z = rhs.z; } return *this; }
    
    vec3<T>     operator+(const vec3<T> &rhs) { vec3<T>(x + rhs.x, y + rhs.y, z + rhs.z); }
    vec3<T>     operator-(const vec3<T> &rhs) { vec3<T>(x - rhs.x, y - rhs.y, z - rhs.z); }
    vec3<T>     operator*(const T &rhs) { vec3<T>(x * rhs, y * rhs, z * rhs); }
    vec3<T>     operator/(const T &rhs) { vec3<T>(x / rhs, y / rhs, z / rhs); }
    
    bool        zero() const { return x == 0 && y == 0 && z == 0; }
    
    T           magnitude() const { return sqrt(x * x + y * y + z * z); }
    T           squared() const { return x * x + y * y + z * z; }
    
    vec3<T>     normalise() const { T m = magnitude(); return vec3<T>(x / m, y / m, z / m); }
    vec3<T>     limit(T max) const { T m = magnitude(); if (m > max) { T div = m / max; return vec3<T>(x / div, y / div, z / div); } else { return *this; } }
    
    T           distance(const vec3<T> &rhs) const { return sqrt((rhs.x - x) * (rhs.x - x) + (rhs.y - y) * (rhs.y - y) + (rhs.z - z) * (rhs.z - z)); }
    
    // heading
    // angleBetween
    // vectorBetween
    
    T           dot(const vec2<T> &other) const { return x * other.x + y * other.y + z * other.z; }
    vec3<T>     cross(const vec2<T> &other) const { return vec3(0, 0, 0); }
    
    const T x, y, z;
};

typedef vec2<int> vec2i;
typedef vec2<float> vec2f;
typedef vec2<double> vec2d;

typedef vec3<int> vec3i;
typedef vec3<float> vec3f;
typedef vec3<double> vec3d;