# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="A virtual for the libjpeg.so.62 ABI for binary-only programs"
SLOT="62"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	|| (
		>=media-libs/libjpeg-turbo-1.3.0-r3:0[${MULTILIB_USEDEP}]
		>=media-libs/jpeg-6b-r12:62[${MULTILIB_USEDEP}]
	)"
