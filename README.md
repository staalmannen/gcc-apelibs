This file is part of the port of the Plan 9 APE libraries to use GCC.
These libraries are distributed under the terms of the Plan 9 License,
which you should already have a copy of.

# What is APE?

APE is the Ansi Posix Environment of Plan 9.  Plan 9 uses its own
system call interface, and APE is provided in order to provide support
for programs written for Posix style systems.  In the Plan 9
distribution, the APE sources are found under /sys/src/ape.  They are
compiled and used with Plan 9's native compiler.

# Using gcc-apelibs natively on Plan9
## prerequisites: native gcc and binutils available on your system

This set of sources is intended to be placed under /sys/src/gnu/ape
instead.  It has been modified so as to compile under GCC, and to use
GCC's calling conventions.  This neccessitated some changes to the
system call wrappers in particular, along with other minor changes
throughout the libraries.

To build, you will need gcc already installed on your Plan 9 system.
This is available in binary form in a separate archive.  Then, just
type "mk install" and the libraries will be compiled and installed
under /$objtype/lib/gnu (objtype currently must be 386).  A simple "mk
clean" afterwards will remove all intermediate files.


# Using gcc-apelibs in a cross-compiler
## prerequisites: gcc and binutils built for a plan9 target

TODO: makefiles will be written for simple compilation of the APE 
libraries on other hosts using a plan9-targeting cross compiler.
