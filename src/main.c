#include <stddef.h>
#include <stdio.h>

extern size_t ft_strlen(const char* str);

int main() {
    printf("%zu", ft_strlen("Hello, world!"));
}
