# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-space tools for LinuxPPS"
HOMEPAGE="https://github.com/redlab-i/pps-tools"
SRC_URI="https://github.com/redlab-i/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"

src_configure() {
	tc-export CC

	default
}
