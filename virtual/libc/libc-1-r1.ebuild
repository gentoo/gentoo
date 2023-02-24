# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for the C library"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# explicitly depend on SLOT 2.2 of glibc, because it sets
# a different SLOT for cross-compiling
# Cygwin uses newlib, which lacks libcrypt
RDEPEND="
	!prefix-guest? (
		elibc_glibc? ( sys-libs/glibc:2.2 )
		elibc_musl? ( sys-libs/musl )
	)
	prefix-guest? (
		elibc_Cygwin? ( sys-libs/cygwin-crypt )
		!sys-libs/glibc
		!sys-libs/musl
	)"
