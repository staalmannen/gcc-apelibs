#include <unistd.h>
#include <errno.h>

/*
 * BUG: LINK_MAX==1 isn't really allowed
 */
int
link(const char *c, const char *n)
{
	errno = EMLINK;
	return -1;
}
