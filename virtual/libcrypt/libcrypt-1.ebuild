# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for libcrypt.so"

SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+static-libs"

DEPEND="
	elibc_glibc? (
		|| (
			>=sys-libs/glibc-2.30-r2[crypt(-),static-libs(+)?]
			<sys-libs/glibc-2.30-r2
		)
	)
	elibc_musl? ( sys-libs/musl )
	elibc_uclibc? ( sys-libs/uclibc-ng )
	elibc_Cygwin? ( sys-libs/cygwin-crypt )
"
RDEPEND="${DEPEND}"
