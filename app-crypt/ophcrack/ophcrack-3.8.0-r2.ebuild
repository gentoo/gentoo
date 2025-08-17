# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="https://ophcrack.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tables"

DEPEND="
	dev-libs/expat
	dev-libs/openssl:=
	net-libs/netwib"
RDEPEND="${DEPEND}
	tables? ( app-crypt/ophcrack-tables )"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-gui # bug 960797
}
