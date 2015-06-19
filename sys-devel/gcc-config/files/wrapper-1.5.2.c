/*
 * Copyright 1999-2011 Gentoo Foundation
 * Distributed under the terms of the GNU General Public License v2
 * $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-config/files/wrapper-1.5.2.c,v 1.2 2011/06/18 18:46:23 vapier Exp $
 * Author: Martin Schlemmer <azarah@gentoo.org>
 * az's lackey: Mike Frysinger <vapier@gentoo.org>
 */

#ifdef DEBUG
# define USE_DEBUG 1
#else
# define USE_DEBUG 0
#endif

#include <errno.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#define GCC_CONFIG "/usr/bin/gcc-config"
#define ENVD_BASE  "/etc/env.d/05gcc"

#define ARRAY_SIZE(arr) (sizeof(arr)/sizeof(arr[0]))

/* basename(3) is allowed to modify memory */
#undef basename
#define basename(path) \
({ \
	char *__path = path; \
	char *__ret = strrchr(__path, '/'); \
	__ret ? __ret + 1 : __path; \
})

struct wrapper_data {
	const char *name;
	char *fullname, *bin, *path;
};

static const struct {
	const char *alias;
	const char *target;
} wrapper_aliases[] = {
	{ "cc",  "gcc" },
	{ "f77", "gfortran" },
	{ "f95", "gfortran" },
};

#define wrapper_warn(fmt, ...) fprintf(stderr, "%s" fmt "\n", "gcc-config: ", ## __VA_ARGS__)
#define wrapper_err(fmt, ...) ({ wrapper_warn("%s" fmt, "error: ", ## __VA_ARGS__); exit(1); })
#define wrapper_errp(fmt, ...) wrapper_err(fmt ": %s", ## __VA_ARGS__, strerror(errno))
#define wrapper_dbg(fmt, ...) ({ if (USE_DEBUG) wrapper_warn(fmt, ## __VA_ARGS__); })

#define xmemwrap(func, proto, use) \
static void *x ## func proto \
{ \
	void *ret = func use; \
	if (!ret) \
		wrapper_err(#func "%s", ": out of memory"); \
	return ret; \
}
xmemwrap(malloc, (size_t size), (size))
xmemwrap(strdup, (const char *s), (s))

/* check_for_target checks in path for the file we are seeking
 * it returns 1 if found (with data->bin setup), 0 if not and
 * negative on error
 */
static int check_for_target(char *path, struct wrapper_data *data)
{
	struct stat sbuf;
	char str[PATH_MAX + 1];
	size_t path_len = strlen(path);
	size_t len = path_len + strlen(data->name) + 2;

	if (sizeof(str) < len)
		wrapper_warn("path too long: %s", path);

	strcpy(str, path);
	str[path_len] = '/';
	str[path_len+1] = '\0';
	strcat(str, data->name);

	/* Stat possible file to check that
	 * 1) it exist and is a regular file, and
	 * 2) it is not the wrapper itself, and
	 * 3) it is in a /gcc-bin/ directory tree
	 */
	if (strcmp(str, data->fullname) != 0 &&
	    strstr(str, "/gcc-bin/") != NULL &&
	    stat(str, &sbuf) == 0 &&
	    (S_ISREG(sbuf.st_mode) || S_ISLNK(sbuf.st_mode)))
	{
		wrapper_dbg("%s: found in %s", data->name, path);
		data->bin = xstrdup(str);
		return 1;
	}

	wrapper_dbg("%s: did not find in %s", data->name, path);
	return 0;
}

static int find_target_in_path(struct wrapper_data *data)
{
	char *token = NULL, *state = NULL;
	char *str;

	if (data->path == NULL)
		return 0;

	/* Make a copy since strtok_r will modify path */
	str = xstrdup(data->path);

	/* Find the first file with suitable name in PATH.  The idea here is
	 * that we do not want to bind ourselfs to something static like the
	 * default profile, or some odd environment variable, but want to be
	 * able to build something with a non default gcc by just tweaking
	 * the PATH ... */
	token = strtok_r(str, ":", &state);
	while (token != NULL) {
		if (check_for_target(token, data))
			return 1;
		token = strtok_r(NULL, ":", &state);
	}

	wrapper_dbg("%s: did not find in PATH", data->name);
	return 0;
}

/* find_target_in_envd parses /etc/env.d/05gcc, and tries to
 * extract PATH, which is set to the current profile's bin
 * directory ...
 */
static int find_target_in_envd(struct wrapper_data *data, int cross_compile)
{
	FILE *envfile = NULL;
	char *token = NULL, *state;
	char str[PATH_MAX + 1];
	char *strp = str;
	char envd_file[PATH_MAX + 1];

	if (!cross_compile) {
		/* for the sake of speed, we'll keep a symlink around for
		 * the native compiler.  #190260
		 */
		snprintf(envd_file, sizeof(envd_file)-1, "/etc/env.d/gcc/.NATIVE");
	} else {
		char *ctarget, *end = strrchr(data->name, '-');
		if (end == NULL)
			return 0;
		ctarget = xstrdup(data->name);
		ctarget[end - data->name] = '\0';
		snprintf(envd_file, PATH_MAX, "%s-%s", ENVD_BASE, ctarget);
		free(ctarget);
	}

	envfile = fopen(envd_file, "r");
	if (envfile == NULL)
		return 0;

	while (fgets(strp, PATH_MAX, envfile) != NULL) {
		/* Keep reading ENVD_FILE until we get a line that
		 * starts with 'GCC_PATH=' ... keep 'PATH=' around
		 * for older gcc versions.
		 */
		if (strncmp(strp, "GCC_PATH=", strlen("GCC_PATH=")) &&
		    strncmp(strp, "PATH=", strlen("PATH=")))
			continue;

		token = strtok_r(strp, "=", &state);
		if ((token != NULL) && token[0])
			/* The second token should be the value of PATH .. */
			token = strtok_r(NULL, "=", &state);
		else
			goto bail;

		if ((token != NULL) && token[0]) {
			strp = token;
			/* A bash variable may be unquoted, quoted with " or
			 * quoted with ', so extract the value without those ..
			 */
			token = strtok(strp, "\n\"\'");

			while (token != NULL) {
				if (check_for_target(token, data)) {
					fclose(envfile);
					return 1;
				}

				token = strtok(NULL, "\n\"\'");
			}
		}

		strp = str;
	}

 bail:
	fclose(envfile);
	return (cross_compile ? 0 : find_target_in_envd(data, 1));
}

static void find_wrapper_target(struct wrapper_data *data)
{
	if (find_target_in_path(data))
		return;

	if (find_target_in_envd(data, 0))
		return;

	/* Only our wrapper is in PATH, so get the CC path using
	 * gcc-config and execute the real binary in there ...
	 */
	FILE *inpipe = popen(GCC_CONFIG " --get-bin-path", "r");
	if (inpipe == NULL)
		wrapper_errp("could not open pipe");

	char str[PATH_MAX + 1];
	if (fgets(str, PATH_MAX, inpipe) == 0)
		wrapper_errp("could not get compiler binary path");

	/* chomp! */
	size_t plen = strlen(str);
	if (str[plen-1] == '\n')
		str[plen-1] = '\0';

	data->bin = xmalloc(plen + 1 + strlen(data->name) + 1);
	sprintf(data->bin, "%s/%s", str, data->name);

	pclose(inpipe);
}

/* This function modifies PATH to have gcc's bin path appended */
static void modify_path(struct wrapper_data *data)
{
	char *newpath = NULL, *token = NULL, *state;
	char dname_data[PATH_MAX + 1], str[PATH_MAX + 1];
	char *str2 = dname_data, *dname = dname_data;
	size_t len = 0;

	if (data->bin == NULL)
		return;

	if (data->path == NULL)
		return;

	snprintf(str2, PATH_MAX + 1, "%s", data->bin);

	if ((dname = dirname(str2)) == NULL)
		return;

	/* Make a copy since strtok_r will modify path */
	snprintf(str, PATH_MAX + 1, "%s", data->path);

	token = strtok_r(str, ":", &state);

	/* Check if we already appended our bin location to PATH */
	if ((token != NULL) && token[0])
		if (!strcmp(token, dname))
			return;

	len = strlen(dname) + strlen(data->path) + 2 + strlen("PATH") + 1;

	newpath = xmalloc(len);
	memset(newpath, 0, len);

	snprintf(newpath, len, "PATH=%s:%s", dname, data->path);
	putenv(newpath);
}

int main(int argc, char *argv[])
{
	struct wrapper_data data;

	memset(&data, 0, sizeof(data));

	if (getenv("PATH"))
		data.path = xstrdup(getenv("PATH"));

	/* What should we find ? */
	data.name = basename(argv[0]);

	/* Allow for common compiler names like cc->gcc */
	size_t i;
	for (i = 0; i < ARRAY_SIZE(wrapper_aliases); ++i)
		if (!strcmp(data.name, wrapper_aliases[i].alias))
			data.name = wrapper_aliases[i].target;

	/* What is the full name of our wrapper? */
	data.fullname = xmalloc(strlen(data.name) + sizeof("/usr/bin/") + 1);
	sprintf(data.fullname, "/usr/bin/%s", data.name);

	find_wrapper_target(&data);

	modify_path(&data);

	free(data.path);
	data.path = NULL;

	/* Set argv[0] to the correct binary, else gcc can't find internal headers
	 * http://bugs.gentoo.org/8132
	 */
	argv[0] = data.bin;

	/* Ok, lets do it one more time ... */
	execv(data.bin, argv);

	/* shouldn't have made it here if things worked ... */
	wrapper_err("could not run/locate '%s'", data.name);

	return 123;
}
