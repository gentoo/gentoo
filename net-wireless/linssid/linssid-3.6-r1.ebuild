# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Graphical wireless scanning for Linux"
HOMEPAGE="https://sourceforge.net/projects/linssid/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	x11-libs/qwt:6[opengl,qt5(+),svg]
"

RDEPEND="
	${DEPEND}
	net-wireless/iw
	sys-auth/polkit
	x11-libs/libxkbcommon[X]
"

S="${WORKDIR}/${P}/${PN}-app"

DOCS=( README_${PV} )

src_prepare() {
	default

	# Fix lib path for x11-libs/qwt and use system qwt for compiling
	sed -e '/libqwt-qt5.so.6/c\LIBS += -lqwt6-qt5' -e 's/CONFIG += release/& qwt/' -i linssid-app.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
