#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

int
lstat(const char *name, struct stat *ans)
{
	return stat(name, ans);
}

int
symlink(const char *name1, const char *name2)
{
	errno = EPERM;
	return -1;
}

int
readlink(const char *name, char *buf, int size)
{
	errno = EIO;
	return -1;
}
