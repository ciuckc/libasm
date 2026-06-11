#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

extern size_t ft_strlen(const char* str);
extern char* ft_strcpy(char* dst, const char* src);

static void test_ft_strcpy(void) {
    char buffer[64];
    char expected[64];

    strcpy(expected, "Hello, world!");
    ft_strcpy(buffer, "Hello, world!");
    assert(strcmp(buffer, expected) == 0);

    strcpy(expected, "");
    ft_strcpy(buffer, "");
    assert(strcmp(buffer, expected) == 0);

    strcpy(expected, "a");
    ft_strcpy(buffer, "a");
    assert(strcmp(buffer, expected) == 0);

    strcpy(expected, "hello\nworld\t!");
    ft_strcpy(buffer, "hello\nworld\t!");
    assert(strcmp(buffer, expected) == 0);

    strcpy(expected, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
    ft_strcpy(buffer, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
    assert(strcmp(buffer, expected) == 0);

    char *ret = ft_strcpy(buffer, "return value");
    assert(ret == buffer);

    printf("ft_strcpy GOOD\n");
}

static void test_ft_strlen(void) {
    assert(ft_strlen("Hello, world!") == strlen("Hello, world!"));
    assert(ft_strlen("") == strlen(""));
    assert(ft_strlen("a") == strlen("a"));
    assert(ft_strlen("abc") == strlen("abc"));
    assert(ft_strlen("\0\0\0\0") == strlen("\0\0\0\0\0"));
    printf("ft_strlen GOOD\n");
}

int main(void)
{
    test_ft_strlen();
    test_ft_strcpy();
}
