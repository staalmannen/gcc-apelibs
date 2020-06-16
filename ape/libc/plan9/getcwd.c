#include "lib.h"
#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include "sys9.h"
#include "dir.h"

static char*
_getcwd(char *buf, size_t len)
{
	int fd;

	fd = _OPEN(".", OREAD);
	if(fd < 0) {
		errno = EACCES;
		return 0;
	}
	if(_FD2PATH(fd, buf, len) < 0) {
		errno = EIO;
		_CLOSE(fd);
		return 0;
	}
	_CLOSE(fd);

/* RSC: is this necessary? */
	if(buf[0] == '\0')
		strcpy(buf, "/");
	return buf;
}

char*
getcwd(char *buf, size_t len)
{
	if(buf == NULL) {
		buf = malloc(len);
		if(_getcwd(buf, len) != 0)
			return buf;
		free(buf);
		return 0;
	}
	return _getcwd(buf, len);
}
