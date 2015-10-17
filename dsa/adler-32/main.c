#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    const int ADLER_MOD = 65521;
    uint32_t a = 1, b = 0;
    while (!feof(stdin)) {
        uint8_t byte = fgetc(stdin);
        a = (a + byte) % ADLER_MOD;
        b = (b + a) % ADLER_MOD;
    }
    uint32_t hash = (a << 16) | b;
    printf("hash: %d\n", hash);
    return 0;
}
