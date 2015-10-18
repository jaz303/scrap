#include <stdio.h>
#include <stdint.h>
#include <string.h>

const char *search_string = "accuse me of such things";
const uint32_t A = 7;
const uint32_t N = 65521;

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

    uint32_t drop[128];
    
    uint32_t line = 1;
    
    uint32_t search_hash = 0;
    uint32_t search_str_len = strlen(search_string);
    for (int i = 0; i < search_str_len; ++i) {
        search_hash = (search_hash + (search_string[i] * ipow(A, search_str_len - (i+1)))) % N;
    }

    printf("search hash: %d\n", search_hash);

    uint32_t rolling_hash = 0;
    uint32_t pos = 0;

    while (!feof(stdin)) {
        uint8_t ch = fgetc(stdin);
        if (ch == '\n') line++;
        if (pos >= search_str_len) {
            drop[(pos-1)%search_str_len] = ch;
            rolling_hash = (((rolling_hash - drop[pos%search_str_len])*A)+ch) % N;
        } else {
            drop[pos] = (ch * ipow(A, search_str_len - (pos+1)));
            rolling_hash = (rolling_hash + drop[pos]) % N;
        }
        if (rolling_hash == search_hash) {
            printf("potential match on line: %d\n", line);
        }
        pos++;
    }

    printf("lines: %d\n", line);

    return 0;
}
