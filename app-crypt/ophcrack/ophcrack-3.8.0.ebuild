# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs qmake-utils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="https://ophcrack.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug qt5 +tables"

DEPEND="
	dev-libs/openssl:0=
	dev-libs/expat
	net-libs/netwib
	qt5? (
		dev-qt/qtcharts:5
		dev-qt/qtgui:5
	)"
RDEPEND="
	${DEPEND}
	tables? ( app-crypt/ophcrack-tables )"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/ophcrack-ar.patch )

src_configure() {
	tc-export AR

	# bug #765229
	export PATH="$(qt5_get_bindir):${PATH}"

	econf \
		$(use_enable debug) \
		$(use_enable qt5 gui)
}

src_install() {
	default

	newicon src/gui/pixmaps/os.xpm ophcrack.xpm
	make_desktop_entry "${PN}" OphCrack ophcrack
}
