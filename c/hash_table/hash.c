#include "hash.h"

#include <stdlib.h>

/* http://planetmath.org/encyclopedia/GoodHashTablePrimes.html */
static const unsigned int primes[] = {
    53,
    97,
    193,
    389,
    769,
    1543,
    3079,
    6151,
    12289,
    24593,
    49157,
    98317,
    196613,
    393241,
    786433,
    1572869,
    3145739,
    6291469,
    12582917,
    25165843,
    50331653,
    100663319,
    201326611,
    402653189,
    805306457,
    1610612741,
    0
};

hash_table_t* ht_create() {
    return ht_init(0, /* use default capacity */
                   0, /* use default max load factor */
                   &ht_hash_djb2,
                   (ht_kcmp) &strcmp,
                   NULL,
                   NULL);
}

hash_table_t* ht_init(int initial_capacity, float max_load, ht_khash fn_khash, ht_kcmp fn_kcmp, ht_ksize fn_ksize, ht_kcopy fn_kcopy) {
    
    hash_table_t *h = malloc(sizeof(hash_table_t));
    if (h == NULL) {
        return NULL;
    }
    
    h->fn_khash = fn_khash;
    h->fn_kcmp  = fn_kcmp;
    h->fn_ksize = fn_ksize;
    h->fn_kcopy = fn_kcopy;
    
    if (initial_capacity <= 0) {
        initial_capacity = HASH_TABLE_DEFAULT_CAPACITY;
    }
    
    if (max_load <= 0) {
        max_load = HASH_TABLE_DEFAULT_MAX_LOAD;
    }
    
    h->primes_ix = 0;
    while (primes[h->primes_ix] < initial_capacity) h->primes_ix++;
    
    h->table_size = primes[h->primes_ix];
    h->table = calloc(h->table_size, sizeof(hash_table_entry_t*));
    if (h->table == NULL) {
        free(h);
        return NULL;
    }
    
    h->max_load = max_load;
    h->max_entries = h->max_load * h->table_size;
    
    h->count = 0;
    
    return h;

}

void ht_free(hash_table_t *h) {
    int i;
    for (i = 0; i < h->table_size; i++) {
        hash_table_entry_t *entry = h->table[i];
        while (entry) {
            hash_table_entry_t *next = entry->next;
            free(entry);
            entry = next;
        }
    }
    free(h->table);
    free(h);
}

unsigned int ht_count(hash_table_t *h) {
    return h->count;
}

int ht_contains(hash_table_t *h, void* key) {
    HASH_TABLE_HASH(key);
    hash_table_entry_t *entry = h->table[hash_code];
    while (entry != NULL) {
        if (HASH_TABLE_KEY_CMP(entry->key, key)) {
            return 1;
        }
        entry = entry->next;
    }
    return 0;
}

void* ht_get(hash_table_t *h, void* key) {
    HASH_TABLE_HASH(key);
    hash_table_entry_t *entry = h->table[hash_code];
    while (entry != NULL) {
        if (HASH_TABLE_KEY_CMP(entry->key, key)) {
            return entry->value;
        }
        entry = entry->next;
    }
    return NULL;
}

void ht_put(hash_table_t *h, void* key, void* value) {
    
    if (++h->count > h->max_entries) {
        ht_expand(h);
    }
    
    HASH_TABLE_HASH(key);
    hash_table_entry_t *entry = h->table[hash_code];
    
    while (entry != NULL) {
        if (HASH_TABLE_KEY_CMP(entry->key, key)) {
            entry->value = value;
            return;
        }
        entry = entry->next;
    }
    
    entry = malloc(sizeof(hash_table_entry_t));
    if (entry == NULL) return;
    
    if (h->fn_kcopy != NULL) {
        entry->key = malloc(h->fn_ksize(key));
        h->fn_kcopy(key, entry->key);
    } else {
        entry->key = key;
    }
    
    entry->value = value;
    entry->next = h->table[hash_code];
    h->table[hash_code] = entry;
    
}

void* ht_remove(hash_table_t *h, void* key) {

    void *value = NULL;

    HASH_TABLE_HASH(key);
    hash_table_entry_t *entry = h->table[hash_code];
    
    hash_table_entry_t *prev = NULL;
    while (entry != NULL) {
        if (HASH_TABLE_KEY_CMP(key, entry->key)) {
            h->count--;
            value = entry->value;
            if (h->fn_kcopy != NULL) {
                free(entry->key);
            }
            if (prev == NULL) {
                h->table[hash_code] = entry->next;
            } else {
                prev->next = entry->next;
            }
            free(entry);
        }
        prev = entry;
        entry = entry->next;
    }
    
    return value;

}

void ht_expand(hash_table_t *h) {
    
    unsigned int        new_size    = primes[h->primes_ix + 1];
    hash_table_entry_t  **new_table = calloc(new_size, sizeof(hash_table_entry_t*));
    
    if (new_table == NULL) return;
    
    int i;
    for (i = 0; i < h->table_size; i++) {
        hash_table_entry_t *entry = h->table[i];
        while (entry != NULL) {
            hash_table_entry_t *next = entry->next;
            HASH_TABLE_HASH_SZ(entry->key, new_size);
            entry->next = new_table[hash_code];
            new_table[hash_code] = entry;
            entry = next;
        }
    }
    
    free(h->table);
    h->table = new_table;
    
    h->primes_ix++;
    h->table_size = new_size;
    h->max_entries = h->max_load * h->table_size;
    
}

/* hash functions from http://www.cse.yorku.ca/~oz/hash.html */

unsigned long ht_hash_djb2(void* key) {
    
    unsigned char *str = (unsigned char *)key;
    unsigned long hash = 5381;
    
    int c;
    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;

}
  
unsigned long ht_hash_sdbm(void* key) {
    
    unsigned char *str = (unsigned char *)key;
    unsigned long hash = 0;

    int c;
    while (c = *str++)
        hash = c + (hash << 6) + (hash << 16) - hash;

    return hash;

}

size_t ht_string_size(void* data) {
    return (strlen(data) + 1) * sizeof(char);
}
