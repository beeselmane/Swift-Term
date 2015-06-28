#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

static struct winsize wsize = {0, 0, 0, 0};

void updateTermInfo(void)
{
    if (ioctl(STDIN_FILENO, TIOCGWINSZ, &wsize))
        fprintf(stderr, "Note: ioctl() failed at %s in %s\n", __PRETTY_FUNCTION__, __FILE__);
}

int termColums(void)
{
    return wsize.ws_col;
}

int termRows(void)
{
    return wsize.ws_row;
}
