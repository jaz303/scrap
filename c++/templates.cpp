#include <iostream>

//
// Recursive template

template <unsigned int N>
struct product {
    static unsigned int const VALUE = N * product<N-1>::VALUE;
};

template <>
struct product<1> {
    static unsigned int const VALUE = 1;
};

int recursive() {
    std::cout << "value is: " << product<5>::VALUE << std::endl;
}

//
// Partial specialization

template <class T>
class Foo {
public:
    void test(T val) {
        std::cout << "value is: " << val << std::endl;
    }
};

template <class T>
class Foo<T*> {
public:
    void test(T* val) {
        std::cout << "address is: " << val << ", value is: " << *val << std::endl;
    }
};

int partial() {
    int i = 10;
    
    Foo<int> f1;
    Foo<int*> f2;
    
    f1.test(i);
    f2.test(&i);
}

//
//

int main(int argc, char *argv[]) {
    recursive();
    partial();
    return 0;
}