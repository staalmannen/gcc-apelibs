#include <sys/types.h>
#include <unistd.h>
#include <errno.h>

int
getgroups(int i, gid_t g[])
{
	errno = EINVAL;
	return -1;
}
