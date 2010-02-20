#include <stdio.h>
#include "hash.h"

int main(int argc, char* argv[]) {
    
    hash_table_t *h = ht_create();
    
    ht_put(h, "foo", "bar");
    ht_put(h, "foo", "baz");
    ht_put(h, "bleem", "boof");
    
    printf("%s\n", (char*) ht_get(h, "foo"));
    printf("%s\n", (char*) ht_get(h, "bleem"));
    
    ht_free(h);
    
    return 0;

}