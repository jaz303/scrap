#include <stdio.h>
#include <stdint.h>
#include <string.h>

const char *search_string = "accuse";
const int32_t A = 256;
const int32_t MOD = 65521;

int main(int argc, char *argv[]) {

    uint32_t line = 1;
    int32_t factor = 1;
    uint8_t drop[128];

    uint32_t search_str_len = strlen(search_string);
    int32_t search_hash = 0;
    for (int i = 0; i < search_str_len - 1; ++i) {
        factor = (factor * A) % MOD;
    }

    for (int i = 0; i < search_str_len; ++i) {
        search_hash = ((search_hash * A) + search_string[i]) % MOD;
    }

    printf("search string length: %d\n", search_str_len);
    printf("search hash: %d\n", search_hash);

    int32_t rolling_hash = 0;
    uint32_t pos = 0;

    while (!feof(stdin) && (pos < search_str_len)) {
        uint8_t ch = fgetc(stdin);
        if (ch == '\n') line++;
        rolling_hash = ((rolling_hash * A) + ch) % MOD;
        drop[pos++] = ch;
    }

    printf("initial hash: %d\n", rolling_hash);

    // TODO: should really check for a match at position 0 here

    while (!feof(stdin)) {
        uint8_t ch = fgetc(stdin);
        if (ch == '\n') line++;
        drop[(pos-1)%search_str_len] = ch;
        uint8_t drop_char = drop[pos%search_str_len];
        
        rolling_hash = ((A * (rolling_hash - (drop_char * factor))) + ch) % MOD;
        if (rolling_hash < 0) rolling_hash += MOD;

        if (rolling_hash == search_hash) {
            printf("potential match on line: %d\n", line);
        }
        pos++;
    }

    printf("lines: %d\n", line);

    return 0;
}
