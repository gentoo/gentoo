# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual to select between libjpeg-turbo and IJG jpeg for source-based packages"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND="
	>=media-libs/libjpeg-turbo-1.5.3-r2:0[static-libs?,${MULTILIB_USEDEP}]
"
