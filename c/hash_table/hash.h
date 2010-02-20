#ifndef __HASH_H__
#define __HASH_H__

#include <string.h>

#define HASH_TABLE_DEFAULT_CAPACITY 512
#define HASH_TABLE_DEFAULT_MAX_LOAD 0.7

#define HASH_TABLE_HASH(key) unsigned long hash_code = (h->fn_khash(key) % h->table_size)
#define HASH_TABLE_HASH_SZ(key, sz) unsigned long hash_code = (h->fn_khash(key) % sz)
#define HASH_TABLE_KEY_CMP(l, r) ((h->fn_kcmp != NULL) ? (h->fn_kcmp(l, r) == 0) : (l == r))

typedef unsigned long(*ht_khash)(void*);
typedef int(*ht_kcmp)(void*, void*);
typedef size_t(*ht_ksize)(void*);
typedef void(*ht_kcopy)(void*, void*);

typedef struct hash_table_entry_t hash_table_entry_t;

struct hash_table_entry_t {
    void                *key;
    void                *value;
    hash_table_entry_t  *next;
};

typedef struct {
    
    /* callbacks */
    ht_khash            fn_khash;   /* hash function */
    ht_kcmp             fn_kcmp;    /* key comparator - if NULL, raw pointers will be compared */
    ht_ksize            fn_ksize;   /* size calculator - only required if fn_kcopy is set */
    ht_kcopy            fn_kcopy;   /* key copier - if NULL, keys will not be copied */
    
    /* table */
    hash_table_entry_t  **table;
    unsigned int        primes_ix;
    unsigned int        table_size;
    float               max_load;
    unsigned int        max_entries;
    
    /* number of items */
    unsigned int        count;

} hash_table_t;

/* 
 * create a new hash table with default initial capacity and load factor.
 * set up callbacks for non-copied string keys.
 */
hash_table_t* ht_create();

hash_table_t* ht_init(int initial_capacity, float max_load, ht_khash fn_khash, ht_kcmp fn_kcmp, ht_ksize fn_ksize, ht_kcopy fn_kcopy);
void ht_free(hash_table_t *h);

unsigned int ht_count(hash_table_t *h);

int ht_contains(hash_table_t *h, void* key);
void* ht_get(hash_table_t *h, void* key);
void ht_put(hash_table_t *h, void* key, void* value);
void* ht_remove(hash_table_t *h, void* key);

void ht_expand(hash_table_t *h);

/* hash functions */
unsigned long ht_hash_djb2(void* key);
unsigned long ht_hash_sdbm(void* key);

/* returns the size required to store a string */ 
size_t ht_string_size(void* data);

#endif