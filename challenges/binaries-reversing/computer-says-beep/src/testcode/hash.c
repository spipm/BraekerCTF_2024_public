#define PRIME 101 // A prime number for hashing


unsigned long rollingHash(unsigned char *str, int len)
{
    unsigned long hash = 73;
    int c;

    while (len > 0) {
        c = *str++;
        hash = (((hash << 5) + hash) + c) % 2147483647;
        len -= 1;
    }

    return hash;
}


#include <stdio.h>

int main() {

    printf("%ld\n", rollingHash((unsigned char*)"GetStdHandle", 12));
    printf("%#x\n", rollingHash((unsigned char*)"GetStdHandle", 12));

    printf("%ld\n", rollingHash((unsigned char*)"WriteFile", 9));
    printf("%#x\n", rollingHash((unsigned char*)"WriteFile", 9));


    printf("%ld\n", rollingHash((unsigned char*)"AddVectoredExceptionHandler", 27));
    printf("%#x\n", rollingHash((unsigned char*)"AddVectoredExceptionHandler", 27));

    printf("%#x\n", rollingHash((unsigned char*)"GetCommandLineA", 15));
    printf("%#x\n", rollingHash((unsigned char*)"GetCommandLineA", 15));


    // printf("%ld\n", rollingHash((char*)L"KERNEL32.DLL", 24));


    // printf("%ld\n", rollingHash((char*)L"NTDLL.DLL", 18));

    return 0;
}

    // printf("%ld\n", rollingHash((char*)"Beep", 4));


    // printf("%ld\n", rollingHash((char*)"CreateThread", 12));
