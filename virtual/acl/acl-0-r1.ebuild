# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for acl support (sys/acl.h)"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="kernel_linux? ( sys-apps/acl[static-libs?] )
	kernel_FreeBSD? ( sys-freebsd/freebsd-lib )"
