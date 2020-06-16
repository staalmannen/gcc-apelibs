#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<unistd.h>
#include	<errno.h>
#include	<sys/types.h>
#include	<fcntl.h>
#include	"sys9.h"

enum {
	Profoff,			/* No profiling */
	Profuser,			/* Measure user time only (default) */
	Profkernel,			/* Measure user + kernel time */
	Proftime,			/* Measure total time */
	Profsample,			/* Use clock interrupt to sample (default when there is no cycle counter) */
}; /* what */

typedef long long vlong;
typedef unsigned long ulong;
typedef unsigned long long uvlong;

extern  long*   _clock;
extern	void*	sbrk(ulong);
extern	long	_callpc(void**);
extern	long	_savearg(void);

static ulong	khz;
static ulong	perr;
static int	havecycles;

typedef	struct	Plink	Plink;
struct	Plink
{
	Plink	*old;
	Plink	*down;
	Plink	*link;
	long	pc;
	long	count;
	vlong	time;
};

struct
{
        Plink   *pp;            /* known to be 0(ptr) */
        Plink   *next;          /* known to be 4(ptr) */
        Plink   *last;
        Plink   *first;
} __prof;

ulong
_profin(void)
{
	void *dummy;
	long pc;
	Plink *pp, *p;
	ulong arg;
	vlong t;

	arg = _savearg();
	pc = _callpc(&dummy);
	pp = __prof.pp;
	if(pp == 0)
		return arg;

	for(p=pp->down; p; p=p->link)
		if(p->pc == pc)
			goto out;
	p = __prof.next + 1;
	if(p >= __prof.last){
		__prof.pp = 0;
		perr++;
		return arg;
	}
	__prof.next = p;
	p->link = pp->down;
	pp->down = p;
	p->pc = pc;
	p->old = pp;
	p->down = 0;
	p->count = 0;
	p->time = 0LL;

out:
	__prof.pp = p;
	p->count++;
	p->time += *_clock;	
	return arg;		/* disgusting linkage */
}

ulong
_profout(void)
{
	Plink *p;
	ulong arg;
	vlong t;

	arg = _savearg();
	p = __prof.pp;
	if(p) {
                p->time -= *_clock;
                __prof.pp = p->old;
        }
	return arg;
}

/* stdio may not be ready for us yet */
static void
err(char *fmt, ...)
{
	int fd;
	va_list arg;
	char buf[128];

	if((fd = open("/dev/cons", OWRITE)) == -1)
		return;
	va_start(arg, fmt);
	/*
	 * C99 now requires *snprintf to return the number of characters
	 * that *would* have been emitted, had there been room for them,
	 * or a negative value on an `encoding error'.  Arrgh!
	 */
	vsnprintf(buf, sizeof buf, fmt, arg);
	va_end(arg);
	write(fd, buf, strlen(buf));
	close(fd);
}

void
_profdump(void)
{
	int f;
	long n;
	Plink *p;
	char *vp;

	__prof.pp = 0;
        f = creat("prof.out", 0666);
	if(f < 0) {
		err("prof.out: cannot create - %s\n", strerror(errno));
		return;
	}
	__prof.first->time = -*_clock;
	vp = (char*)__prof.first;

	for(p = __prof.first; p <= __prof.next; p++) {

		/*
		 * short down
		 */
		n = 0xffff;
		if(p->down)
			n = p->down - __prof.first;
		vp[0] = n>>8;
		vp[1] = n;

		/*
		 * short right
		 */
		n = 0xffff;
		if(p->link)
			n = p->link - __prof.first;
		vp[2] = n>>8;
		vp[3] = n;
		vp += 4;

		/*
		 * long pc
		 */
		n = p->pc;
		vp[0] = n>>24;
		vp[1] = n>>16;
		vp[2] = n>>8;
		vp[3] = n;
		vp += 4;

		/*
		 * long count
		 */
		n = p->count;
		vp[0] = n>>24;
		vp[1] = n>>16;
		vp[2] = n>>8;
		vp[3] = n;
		vp += 4;

		/*
		 * vlong time
		 */
		if (havecycles){
			n = (vlong)(p->time / (vlong)khz);
		}else
			n = p->time;

		vp[0] = n>>24;
		vp[1] = n>>16;
		vp[2] = n>>8;
		vp[3] = n;
		vp += 4;
	}
	write(f, (char*)__prof.first, vp - (char*)__prof.first);
	close(f);

}

void
_profinit(int entries, int what)
{
	if (what == 0)
		return;	/* Profiling not linked in */
	__prof.pp = NULL;
	__prof.first = calloc(entries*sizeof(Plink),1);
	__prof.last = __prof.first + entries;
	__prof.next = __prof.first;
	*_clock = 1;
}

void
_profmain(void)
{
	char ename[50];
	int n, f;

	n = 2000;
	f = _OPEN("/env/profsize", OREAD);
	if(f >= 0) {
		memset(ename, 0, sizeof(ename));
		_READ(f, ename, sizeof(ename)-1);
		_CLOSE(f);
		n = atol(ename);
	}
	__prof.first = sbrk(n*sizeof(Plink));
	__prof.last = sbrk(0);
	__prof.next = __prof.first;
	__prof.pp = NULL;
	atexit(_profdump);
	*_clock = 1;
}

void prof(void (*fn)(void*), void *arg, int entries, int what)
{
	_profinit(entries, what);
	__prof.pp = __prof.next;
	fn(arg);
	_profdump();
}


