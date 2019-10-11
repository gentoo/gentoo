# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for system loggers"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="|| (
	app-admin/metalog
	app-admin/rsyslog
	app-admin/socklog
	app-admin/sysklogd
	app-admin/syslog-ng
	sys-freebsd/freebsd-usbin
	sys-apps/busybox[syslog]
	>=sys-apps/systemd-38
)"
