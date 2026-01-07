# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for libcrypt.so"

SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND="
	!prefix-guest? (
		elibc_glibc? ( sys-libs/glibc[crypt(-),static-libs(+)?] )
		elibc_musl? ( sys-libs/musl )
	)
"
