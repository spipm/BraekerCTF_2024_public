#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {

    char secret[] = "brck{St1ll_n0th1ng_bUt_4_b4by_p4d}";
    size_t secret_length = strlen(secret);
    char *key = NULL;
    size_t read_length, buffer_length = 0;
    
    // Read One Time Key
    FILE *random_bytes = fopen("/dev/urandom", "rb");
    if (random_bytes == NULL)
        return 0;
    read_length = getline(&key, &buffer_length, random_bytes);
    fclose(random_bytes);

    // Encrypt
    for (int i = 0; i < secret_length; i++)
        secret[i] = secret[i] ^ key[i];

    free(key);

    // Security!
    if (read_length < secret_length) {
        return 0;
    }

    // Store encrypted secret
    FILE *output_file = fopen("./ciphertext", "ab");
    if (output_file == NULL)
        return 0;
    fwrite(secret, 1, secret_length, output_file);
    fclose(output_file);

    return 0;
}