#include <sys/types.h>
#include <unistd.h>
#include <errno.h>

int
fsync(int i)
{
	errno = EINVAL;
	return -1;
}
