#include <termios.h>

speed_t
cfgetospeed(const struct termios *t)
{
	return B0;
}

int
cfsetospeed(struct termios *t, speed_t s)
{
	return 0;
}

speed_t
cfgetispeed(const struct termios *t)
{
	return B0;
}

int
cfsetispeed(struct termios *t, speed_t s)
{
	return 0;
}

