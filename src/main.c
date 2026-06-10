#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

extern size_t ft_strlen(const char* str);

static void test_ft_strlen(void)
{
    assert(ft_strlen("Hello, world!") == strlen("Hello, world!"));
    assert(ft_strlen("") == 0);
    assert(ft_strlen("a") == 1);
    assert(ft_strlen("abc") == 3);
    printf("ft_strlen: OK\n");
}

int main(void)
{
    test_ft_strlen();
}
