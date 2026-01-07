# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for libminizip.so providers"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND="
	static-libs? (
		>=sys-libs/zlib-1.3.1[${MULTILIB_USEDEP},minizip,static-libs]
	)
	!static-libs? (
		|| (
			>=sys-libs/zlib-1.3.1[${MULTILIB_USEDEP},minizip]
			sys-libs/minizip-ng[${MULTILIB_USEDEP},compat]
		)
	)
"
