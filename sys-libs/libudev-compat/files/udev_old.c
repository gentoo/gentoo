/*
 * Copyright (C) 2015 Jonathan Callen <jcallen@gentoo.org>
 * Copyright (C) 2008-2010 Kay Sievers <kay.sievers@vrfy.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 */

#include <errno.h>
#include <stddef.h>

void *udev_monitor_new_from_socket(void *udev, const void *path) {
	errno = ENOSYS;
	return NULL;
}

void *udev_queue_get_failed_list_entry(void *udev_queue) {
	errno = ENOSYS;
	return NULL;
}

const char *udev_get_sys_path(void *udev) {
	if (!udev) return NULL;
	return "/sys";
}

const char *udev_get_dev_path(void *udev) {
	if (!udev) return NULL;
	return "/dev";
}

const char *udev_get_run_path(void *udev) {
	if (!udev) return NULL;
	return "/run/udev";
}
