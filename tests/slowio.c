#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>

#define DELAY_MS 500

static void delay() {
    struct timespec ts;
    ts.tv_sec = 0;
    ts.tv_nsec = DELAY_MS * 1000000;
    nanosleep(&ts, NULL);
}

ssize_t write(int fd, const void *buf, size_t count) {
    static ssize_t (*real_write)(int, const void *, size_t) = NULL;
    if (!real_write) real_write = dlsym(RTLD_NEXT, "write");

    fprintf(stderr, "[slowio] write(%d, %zu bytes)\n", fd, count);
    delay();
    return real_write(fd, buf, count);
}

ssize_t read(int fd, void *buf, size_t count) {
    static ssize_t (*real_read)(int, void *, size_t) = NULL;
    if (!real_read) real_read = dlsym(RTLD_NEXT, "read");
    return real_read(fd, buf, count);
}

