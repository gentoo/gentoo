# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="GTK-based GUI to configure a space navigator device"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/spacenav/spacenavd%20config%20gui/${PN}%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND="x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	app-misc/spacenavd[X]"

src_configure() {
	econf --disable-debug --disable-opt
}

src_compile() {
	emake CC="$(tc-getCC)"
}
