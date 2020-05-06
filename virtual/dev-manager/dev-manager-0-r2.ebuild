# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for the device filesystem manager"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND="
	|| (
		virtual/udev
		sys-apps/busybox[mdev]
		sys-fs/static-dev
	)"
