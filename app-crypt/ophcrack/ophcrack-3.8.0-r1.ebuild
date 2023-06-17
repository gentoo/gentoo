# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop qmake-utils xdg

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="https://ophcrack.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui +tables"

DEPEND="
	dev-libs/openssl:=
	dev-libs/expat
	net-libs/netwib
	gui? (
		dev-qt/qtcharts:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
RDEPEND="
	${DEPEND}
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
	# bug #765229
	use gui && export PATH="$(qt5_get_bindir):${PATH}"

	econf $(use_enable gui)
}

src_install() {
	default

	if use gui; then
		newicon src/gui/pixmaps/os.xpm ophcrack.xpm
		make_desktop_entry "${PN}" OphCrack ophcrack
	fi
}
