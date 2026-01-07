# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs xdg

# probably change every release
PID="1/3/0/3/13035936"

DESCRIPTION="Stellar simulation program"
HOMEPAGE="http://www.kornelix.com/galaxy.html"
SRC_URI="http://www.kornelix.com/uploads/${PID}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CXX PKG_CONFIG
	append-cxxflags -pthread
	append-ldflags -pthread
}
