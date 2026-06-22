#include <assert.h>
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern size_t ft_strlen(const char* str);
extern char* ft_strcpy(char* dst, const char* src);
extern int ft_strcmp(const char* s1, const char* s2);
extern int ft_write(int fd, const void* buf, size_t count);
extern ssize_t ft_read(int fd, void* buf, size_t count);
extern char* ft_strdup(const char* str);

#ifdef BONUS
extern int ft_atoi_base(const char* arg, const char* base);

static void test_ft_atoi_base(void) {
    // basic decimal
    assert(ft_atoi_base("42", "0123456789") == 42);
    assert(ft_atoi_base("0", "0123456789") == 0);
    assert(ft_atoi_base("1000", "0123456789") == 1000);
    assert(ft_atoi_base("007", "0123456789") == 7);

    // signs
    assert(ft_atoi_base("-42", "0123456789") == -42);
    assert(ft_atoi_base("+42", "0123456789") == 42);
    assert(ft_atoi_base("-0", "0123456789") == 0);

    // sign with no digits after
    assert(ft_atoi_base("+", "0123456789") == 0);
    assert(ft_atoi_base("-", "0123456789") == 0);

    // whitespace
    assert(ft_atoi_base("  42", "0123456789") == 42);
    assert(ft_atoi_base("   42", "0123456789") == 42);
    assert(ft_atoi_base("\t42", "0123456789") == 42);
    assert(ft_atoi_base("\n42", "0123456789") == 42);
    assert(ft_atoi_base("\t \r\n  42", "0123456789") == 42);
    assert(ft_atoi_base("  -42", "0123456789") == -42);
    assert(ft_atoi_base("  +42", "0123456789") == 42);

    // stops at char not in base
    assert(ft_atoi_base("12x34", "0123456789") == 12);
    assert(ft_atoi_base("42abc", "0123456789") == 42);

    // empty input
    assert(ft_atoi_base("", "0123456789") == 0);

    // other bases
    assert(ft_atoi_base("101010", "01") == 42);
    assert(ft_atoi_base("2a", "0123456789abcdef") == 42);
    assert(ft_atoi_base("ff", "0123456789abcdef") == 255);
    assert(ft_atoi_base("2A", "0123456789ABCDEF") == 42);

    // invalid base (len <= 1)
    assert(ft_atoi_base("42", "0") == 0);
    assert(ft_atoi_base("42", "") == 0);

    printf("ft_atoi_base GOOD\n");
}
#endif

static void test_ft_strcmp(void) {
    assert(ft_strcmp("", "") == 0);
    assert(ft_strcmp("abc", "abc") == 0);
    assert(ft_strcmp("a", "z") < 0);
    assert(ft_strcmp("z", "a") > 0);
    assert(ft_strcmp("abc", "abd") < 0);
    assert(ft_strcmp("abc", "ab") > 0);
    assert(ft_strcmp("ab", "abc") < 0);
    assert(ft_strcmp("ABC", "abc") < 0);
    printf("ft_strcmp GOOD\n");
}

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

static void test_ft_write(void) {
    ssize_t bytes_written;

    bytes_written = ft_write(1, "hello from ft_write\n", 20);
    assert(bytes_written == 20);

    bytes_written = ft_write(1, "", 0);
    assert(bytes_written == 0);

    errno = 0;
    bytes_written = ft_write(-1, "bad fd", 6);
    assert(bytes_written == -1);
    assert(errno == EBADF);

    printf("ft_write GOOD\n");
}

static void test_ft_read(void) {
    int pipefd[2];
    char buf[64];
    ssize_t n;

    assert(pipe(pipefd) == 0);
    write(pipefd[1], "hello", 5);
    close(pipefd[1]);

    n = ft_read(pipefd[0], buf, 5);
    assert(n == 5);
    assert(memcmp(buf, "hello", 5) == 0);
    close(pipefd[0]);

    assert(pipe(pipefd) == 0);
    close(pipefd[1]);
    n = ft_read(pipefd[0], buf, 0);
    assert(n == 0);
    close(pipefd[0]);

    assert(pipe(pipefd) == 0);
    write(pipefd[1], "hello world", 11);
    close(pipefd[1]);
    n = ft_read(pipefd[0], buf, 5);
    assert(n == 5);
    assert(memcmp(buf, "hello", 5) == 0);
    close(pipefd[0]);

    assert(pipe(pipefd) == 0);
    close(pipefd[1]);
    n = ft_read(pipefd[0], buf, 10);
    assert(n == 0);
    close(pipefd[0]);

    errno = 0;
    n = ft_read(-1, buf, 1);
    assert(n == -1);
    assert(errno == EBADF);

    printf("ft_read GOOD\n");
}

static void test_ft_strdup(void) {
    char *dup;

    dup = ft_strdup("hello");
    assert(strcmp(dup, "hello") == 0);
    free(dup);

    dup = ft_strdup("");
    assert(strcmp(dup, "") == 0);
    free(dup);

    dup = ft_strdup("a");
    assert(strcmp(dup, "a") == 0);
    free(dup);

    dup = ft_strdup("hello\nworld\t!");
    assert(strcmp(dup, "hello\nworld\t!") == 0);
    free(dup);

    char *src = ft_strdup("independent copy");
    dup = ft_strdup(src);
    assert(dup != src);
    assert(strcmp(dup, src) == 0);
    free(src);
    free(dup);

    printf("ft_strdup GOOD\n");
}

int main(void)
{
    test_ft_strlen();
    test_ft_strcpy();
    test_ft_strcmp();
    test_ft_write();
    test_ft_read();
    test_ft_strdup();
#ifdef BONUS
    printf("-----------\n");
    printf("BONUS SIDE\n");
    printf("-----------\n");
    test_ft_atoi_base();
#endif
}
