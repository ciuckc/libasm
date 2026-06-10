#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

extern size_t ft_strlen(const char* str);

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
}
