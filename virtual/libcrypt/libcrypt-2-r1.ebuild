# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for libcrypt.so"

SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND="
	!prefix-guest? (
		elibc_glibc? ( sys-libs/libxcrypt[system(-),static-libs(-)?,${MULTILIB_USEDEP}] )
		elibc_musl? ( sys-libs/libxcrypt[system(-),static-libs(-)?] )
	)
"
