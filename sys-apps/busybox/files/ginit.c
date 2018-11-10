/*
 * simple init to bootstrap sep-/usr
 *
 * Copyright (C) 2012-2013 Mike Frysinger <vapier@gentoo.org>
 *
 * Licensed under GPLv2 or later
 */

//applet:IF_GINIT(APPLET(ginit, BB_DIR_SBIN, BB_SUID_DROP))

//kbuild:lib-$(CONFIG_GINIT) += ginit.o

//config:config GINIT
//config:	bool "ginit"
//config:	default y
//config:	select MKDIR
//config:	select MDEV
//config:	select MOUNT
//config:	select MOUNTPOINT
//config:	help
//config:	  sep-/usr bootstrapper

//usage:#define ginit_trivial_usage NOUSAGE_STR
//usage:#define ginit_full_usage ""

#include "libbb.h"

#define eprintf(fmt, args...) printf("%s" fmt, "sep-usr init: ", ## args)

static void process_args(char **args)
{
	size_t i;

	eprintf("running: ");
	for (i = 0; args[i]; ++i) {
		/* String needs to be writable, so dupe it */
		args[i] = xstrdup(args[i]);
		printf("'%s' ", args[i]);
	}
	printf("\n");
}

int ginit_main(int argc UNUSED_PARAM, char **argv) MAIN_EXTERNALLY_VISIBLE;
int ginit_main(int argc UNUSED_PARAM, char **argv)
{
	FILE *mntlist;
	bool ismnted_dev, ismnted_sys, ismnted_usr;
	struct mntent *mntent;

	/*
	int fd = open("/dev/console", O_RDWR);
	if (fd >= 0) {
		dup2(fd, 0);
		dup2(fd, 1);
		dup2(fd, 2);
	}
	*/

	/* If given an argv[] with an applet name, run it instead.
	 * Makes recovering simple by doing: init=/ginit bb
	 */
	if (argv[1] && argv[1][0] != '/') {
		eprintf("running user requested applet %s\n", argv[1]);
		return spawn_and_wait(argv+1);
	}

#define saw(argv...) \
	({ \
		static const char *args[] = { argv, NULL }; \
		/* These casts are fine -- see process_args for mem setup */ \
		process_args((void *)args); \
		spawn_and_wait((void *)args); \
	})

	/* First setup basic /dev */
	if (saw("mountpoint", "-q", "/dev") != 0) {
		/* Try /etc/fstab */
		if (saw("mount", "-n", "/dev"))
			/* Then devtmpfs */
			if (saw("mount", "-n", "-t", "devtmpfs", "devtmpfs", "/dev"))
				/* Finally normal tmpfs */
				saw("mount", "-n", "-t", "tmpfs", "dev", "/dev");
	} else {
		eprintf("%s appears to be mounted; skipping its setup\n", "/dev");
	}

	/* If /dev is empty (e.g. tmpfs), run mdev to seed things */
	if (access("/dev/console", F_OK) != 0) {
		if (saw("mountpoint", "-q", "/sys") != 0) {
			if (saw("mount", "-n", "/sys"))
				saw("mount", "-n", "-t", "sysfs", "sysfs", "/sys");
		} else {
			eprintf("%s appears to be mounted; skipping its setup\n", "/sys");
		}

		/* Mount /proc as mdev will fork+exec /proc/self/exe */
		if (saw("mountpoint", "-q", "/proc") != 0) {
			/* Try /etc/fstab */
			if (saw("mount", "-n", "/proc"))
				saw("mount", "-n", "-t", "proc", "proc", "/proc");
		}

		saw("mdev", "-s");
	}

	/* Then seed the stuff we care about */
	saw("mkdir", "-p", "/dev/pts", "/dev/shm");

	/* Then mount /usr */
	if (saw("mountpoint", "-q", "/usr") != 0) {
		saw("mount", "-n", "/usr", "-o", "ro");
	} else {
		eprintf("%s appears to be mounted; skipping its setup\n", "/usr");
	}

	/* Now that we're all done, exec the real init */
	if (!argv[1]) {
		argv[0] = (void *)"/sbin/init";
		argv[1] = NULL;
	} else
		++argv;
	process_args(argv);
	return execv(argv[0], argv);
}
