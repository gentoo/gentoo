# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for libcrypt.so"

SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	!prefix-guest? (
		elibc_glibc? ( sys-libs/libxcrypt[system(-),static-libs(-)?,${MULTILIB_USEDEP}] )
		elibc_musl? ( sys-libs/libxcrypt[system(-),static-libs(-)?] )
	)
	elibc_Cygwin? ( sys-libs/cygwin-crypt )
"
