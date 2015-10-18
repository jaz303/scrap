#include <stdio.h>
#include <string.h>
#include <stdint.h>

const int A = 7;
const int N = 31;

int ipow(uint32_t base, uint32_t exp) {
    uint32_t result = 1;
    while (exp != 0) {
        if ((exp & 1) == 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }
    return result;
}

int main(int argc, char *argv[]) {
    
    const char *str = "foobar";
    int len = strlen(str);
   
    uint32_t hash = 0;
    for (int i = 0; i < len; ++i) {
        hash = (hash + str[i] * ipow(A, i)) % N;
    }

    printf("hash: %d\n", hash);

    return 0;
}
