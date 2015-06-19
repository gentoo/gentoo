/*
 * filefuncs.c - Builtin functions that provide initial minimal iterface
 *		 to the file system.
 *
 * Arnold Robbins, update for 3.1, Mon Nov 23 12:53:39 EST 1998
 */

/*
 * Copyright (C) 2001 the Free Software Foundation, Inc.
 * 
 * This file is part of GAWK, the GNU implementation of the
 * AWK Programming Language.
 * 
 * GAWK is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * GAWK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
 */

/*
 * Copyright 1999-2004 Gentoo Foundation
 * Distributed under the terms of the GNU General Public License v2
 * Author:  Martin Schlemmer <azarah@gentoo.org>, Nov 2002
 * $Header: /var/cvsroot/gentoo-x86/sys-apps/gawk/files/filefuncs/filefuncs.c,v 1.3 2005/05/06 01:35:53 vapier Exp $
 * 
 * Extended with: do_symlink()
 *                do_unlink()
 *                do_mkdir()
 *                do_rmdir()
 *
 * for use in the Gentoo rcscripts
 *
 */

#include "awk.h"

#include <unistd.h>

/*  do_chdir --- provide dynamically loaded chdir() builtin for gawk */

static NODE *
do_chdir(tree)
NODE *tree;
{
	NODE *newdir;
	int ret = -1;

	if  (do_lint && tree->param_cnt > 1)
		lintwarn("chdir: called with too many arguments");

	newdir = get_argument(tree, 0);
	if (newdir != NULL) {
		(void) force_string(newdir);
		ret = chdir(newdir->stptr);
		if (ret < 0)
			update_ERRNO();

		free_temp(newdir);
	} else if (do_lint)
		lintwarn("chdir: called with no arguments");


	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));

	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);
}

/*  do_symlink --- provide dynamically loaded symlink() builtin for gawk */

static NODE *
do_symlink(tree)
NODE *tree;
{
	NODE *oldpath, *newpath;
	int ret = -1;

	if (do_lint && tree->param_cnt > 2)
		lintwarn("symlink: called with too many arguments");

	oldpath = get_argument(tree, 0);
	newpath = get_argument(tree, 1);
	if ((oldpath != NULL) && (newpath)) {
		(void) force_string(oldpath);
		(void) force_string(newpath);
		ret = symlink(oldpath->stptr, newpath->stptr);
		if (ret < 0)
			update_ERRNO();

		free_temp(oldpath);
		free_temp(newpath);
	} else if (do_lint)
		lintwarn("symlink: called with not enough arguments");
	
	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));
	
	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);	
}

/* do_unlink --- provide dynamically loaded unlink() builtin for gawk */

static NODE *
do_unlink(tree)
NODE *tree;
{
	NODE *pathname;
	int ret = -1;

	if (do_lint && tree->param_cnt > 1)
		lintwarn("unlink: called with too many arguments");

	pathname = get_argument(tree, 0);
	if (pathname != NULL) {
		(void) force_string(pathname);
		ret = unlink(pathname->stptr);
		if (ret < 0)
			update_ERRNO();

		free_temp(pathname);
	} else if (do_lint)
		lintwarn("unlink: called with no arguments");

	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));

	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);
}

/* do_mkdir --- provide dynamically loaded mkdir() builtin for gawk */

static NODE *
do_mkdir(tree)
NODE *tree;
{
	NODE *pathname, *mode;
	int ret = -1;

	if (do_lint && tree->param_cnt > 2)
		lintwarn("mkdir: called with too many arguments");

	pathname = get_argument(tree, 0);
	mode = get_argument(tree, 1);
	if ((pathname != NULL) && (mode != NULL)) {
		(void) force_string(pathname);
		(void) force_number(mode);
		ret = mkdir(pathname->stptr, mode->numbr);
		if (ret < 0)
			update_ERRNO();

		free_temp(pathname);
		free_temp(mode);
	} else if (do_lint)
		lintwarn("mkdir: called with not enough arguments");

	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));

	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);
}

/* do_rmdir --- provide dynamically loaded rmdir() builtin for gawk */

static NODE *
do_rmdir(tree)
NODE *tree;
{
	NODE *pathname;
	int ret = -1;

	if (do_lint && tree->param_cnt > 1)
		lintwarn("rmdir: called with too many arguments");

	pathname = get_argument(tree, 0);
	if (pathname != NULL) {
		(void) force_string(pathname);
		ret = rmdir(pathname->stptr);
		if (ret < 0)
			update_ERRNO();

		free_temp(pathname);
	} else if (do_lint)
		lintwarn("rmdir: called with no arguments");

	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));

	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);
}

/* format_mode --- turn a stat mode field into something readable */

static char *
format_mode(fmode)
unsigned long fmode;
{
	static char outbuf[12];
	int i;

	strcpy(outbuf, "----------");
	/* first, get the file type */
	i = 0;
	switch (fmode & S_IFMT) {
#ifdef S_IFSOCK
	case S_IFSOCK:
		outbuf[i] = 's';
		break;
#endif
#ifdef S_IFLNK
	case S_IFLNK:
		outbuf[i] = 'l';
		break;
#endif
	case S_IFREG:
		outbuf[i] = '-';	/* redundant */
		break;
	case S_IFBLK:
		outbuf[i] = 'b';
		break;
	case S_IFDIR:
		outbuf[i] = 'd';
		break;
#ifdef S_IFDOOR	/* Solaris weirdness */
	case S_IFDOOR:
		outbuf[i] = 'D';
		break;
#endif /* S_IFDOOR */
	case S_IFCHR:
		outbuf[i] = 'c';
		break;
#ifdef S_IFIFO
	case S_IFIFO:
		outbuf[i] = 'p';
		break;
#endif
	}

	i++;
	if ((fmode & S_IRUSR) != 0)
		outbuf[i] = 'r';
	i++;
	if ((fmode & S_IWUSR) != 0)
		outbuf[i] = 'w';
	i++;
	if ((fmode & S_IXUSR) != 0)
		outbuf[i] = 'x';
	i++;

	if ((fmode & S_IRGRP) != 0)
		outbuf[i] = 'r';
	i++;
	if ((fmode & S_IWGRP) != 0)
		outbuf[i] = 'w';
	i++;
	if ((fmode & S_IXGRP) != 0)
		outbuf[i] = 'x';
	i++;

	if ((fmode & S_IROTH) != 0)
		outbuf[i] = 'r';
	i++;
	if ((fmode & S_IWOTH) != 0)
		outbuf[i] = 'w';
	i++;
	if ((fmode & S_IXOTH) != 0)
		outbuf[i] = 'x';
	i++;

	outbuf[i] = '\0';

	if ((fmode & S_ISUID) != 0) {
		if (outbuf[3] == 'x')
			outbuf[3] = 's';
		else
			outbuf[3] = 'S';
	}

	/* setgid without execute == locking */
	if ((fmode & S_ISGID) != 0) {
		if (outbuf[6] == 'x')
			outbuf[6] = 's';
		else
			outbuf[6] = 'l';
	}

	if ((fmode & S_ISVTX) != 0) {
		if (outbuf[9] == 'x')
			outbuf[9] = 't';
		else
			outbuf[9] = 'T';
	}

	return outbuf;
}

/* do_stat --- provide a stat() function for gawk */

static NODE *
do_stat(tree)
NODE *tree;
{
	NODE *file, *array;
	struct stat sbuf;
	int ret;
	NODE **aptr;
	char *pmode;	/* printable mode */
	char *type = "unknown";

	/* check arg count */
	if (tree->param_cnt != 2)
		fatal(
	"stat: called with incorrect number of arguments (%d), should be 2",
			tree->param_cnt);

	/* directory is first arg, array to hold results is second */
	file = get_argument(tree, 0);
	array = get_argument(tree, 1);

	/* empty out the array */
	assoc_clear(array);

	/* lstat the file, if error, set ERRNO and return */
	(void) force_string(file);
	ret = lstat(file->stptr, & sbuf);
	if (ret < 0) {
		update_ERRNO();

		set_value(tmp_number((AWKNUM) ret));

		free_temp(file);
		return tmp_number((AWKNUM) 0);
	}

	/* fill in the array */
	aptr = assoc_lookup(array, tmp_string("name", 4), FALSE);
	*aptr = dupnode(file);

	aptr = assoc_lookup(array, tmp_string("dev", 3), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_dev);

	aptr = assoc_lookup(array, tmp_string("ino", 3), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_ino);

	aptr = assoc_lookup(array, tmp_string("mode", 4), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_mode);

	aptr = assoc_lookup(array, tmp_string("nlink", 5), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_nlink);

	aptr = assoc_lookup(array, tmp_string("uid", 3), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_uid);

	aptr = assoc_lookup(array, tmp_string("gid", 3), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_gid);

	aptr = assoc_lookup(array, tmp_string("size", 4), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_size);

	aptr = assoc_lookup(array, tmp_string("blocks", 6), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_blocks);

	aptr = assoc_lookup(array, tmp_string("atime", 5), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_atime);

	aptr = assoc_lookup(array, tmp_string("mtime", 5), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_mtime);

	aptr = assoc_lookup(array, tmp_string("ctime", 5), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_ctime);

	/* for block and character devices, add rdev, major and minor numbers */
	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode)) {
		aptr = assoc_lookup(array, tmp_string("rdev", 4), FALSE);
		*aptr = make_number((AWKNUM) sbuf.st_rdev);

		aptr = assoc_lookup(array, tmp_string("major", 5), FALSE);
		*aptr = make_number((AWKNUM) major(sbuf.st_rdev));

		aptr = assoc_lookup(array, tmp_string("minor", 5), FALSE);
		*aptr = make_number((AWKNUM) minor(sbuf.st_rdev));
	}

#ifdef HAVE_ST_BLKSIZE
	aptr = assoc_lookup(array, tmp_string("blksize", 7), FALSE);
	*aptr = make_number((AWKNUM) sbuf.st_blksize);
#endif /* HAVE_ST_BLKSIZE */

	aptr = assoc_lookup(array, tmp_string("pmode", 5), FALSE);
	pmode = format_mode(sbuf.st_mode);
	*aptr = make_string(pmode, strlen(pmode));

	/* for symbolic links, add a linkval field */
	if (S_ISLNK(sbuf.st_mode)) {
		char buf[BUFSIZ*2];
		int linksize;

		linksize = readlink(file->stptr, buf, sizeof buf);
		/* should make this smarter */
		if (linksize == sizeof(buf))
			fatal("size of symbolic link too big");
		buf[linksize] = '\0';

		aptr = assoc_lookup(array, tmp_string("linkval", 7), FALSE);
		*aptr = make_string(buf, linksize);
	}

	/* add a type field */
	switch (sbuf.st_mode & S_IFMT) {
#ifdef S_IFSOCK
	case S_IFSOCK:
		type = "socket";
		break;
#endif
#ifdef S_IFLNK
	case S_IFLNK:
		type = "symlink";
		break;
#endif
	case S_IFREG:
		type = "file";
		break;
	case S_IFBLK:
		type = "blockdev";
		break;
	case S_IFDIR:
		type = "directory";
		break;
#ifdef S_IFDOOR
	case S_IFDOOR:
		type = "door";
		break;
#endif
	case S_IFCHR:
		type = "chardev";
		break;
#ifdef S_IFIFO
	case S_IFIFO:
		type = "fifo";
		break;
#endif
	}

	aptr = assoc_lookup(array, tmp_string("type", 4), FALSE);
	*aptr = make_string(type, strlen(type));

	free_temp(file);

	/* Set the return value */
	set_value(tmp_number((AWKNUM) ret));

	/* Just to make the interpreter happy */
	return tmp_number((AWKNUM) 0);
}

/* dlload --- load new builtins in this library */

NODE *
dlload(tree, dl)
NODE *tree;
void *dl;
{
	make_builtin("chdir", do_chdir, 1);
	make_builtin("symlink", do_symlink, 2);
	make_builtin("unlink", do_unlink, 1);
	make_builtin("mkdir", do_mkdir, 2);
	make_builtin("rmdir", do_rmdir, 1);
	make_builtin("stat", do_stat, 2);

	return tmp_number((AWKNUM) 0);
}

