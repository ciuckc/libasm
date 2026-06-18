#include <assert.h>
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

extern size_t ft_strlen(const char* str);
extern char* ft_strcpy(char* dst, const char* src);
extern int ft_strcmp(const char* s1, const char* s2);
extern int ft_write(int fd, const void* buf, size_t count);
extern ssize_t ft_read(int fd, void* buf, size_t count);

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

int main(void)
{
    test_ft_strlen();
    test_ft_strcpy();
    test_ft_strcmp();
    test_ft_write();
    test_ft_read();
}
