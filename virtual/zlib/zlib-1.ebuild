# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for libz.so providers"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minizip static-libs"

RDEPEND="
	|| (
		sys-libs/zlib[${MULTILIB_USEDEP},minizip?,static-libs?]
		(
			sys-libs/zlib-ng[${MULTILIB_USEDEP},compat,static-libs(-)?]
			minizip? (
				sys-libs/minizip-ng[${MULTILIB_USEDEP},compat,static-libs(-)?]
			)
		)
	)
"
