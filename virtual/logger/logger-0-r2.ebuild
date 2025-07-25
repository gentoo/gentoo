# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for system loggers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="systemd"

RDEPEND="
	systemd? ( >=sys-apps/systemd-38 )
	!systemd? ( || (
		app-admin/metalog
		app-admin/rsyslog
		app-admin/socklog
		app-admin/sysklogd
		app-admin/syslog-ng
		sys-apps/busybox[syslog]
	) )
"
