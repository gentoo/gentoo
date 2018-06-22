# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils xdg-utils

DESCRIPTION="Graphical wireless scanning for Linux"
HOMEPAGE="https://sourceforge.net/projects/linssid/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="policykit"

DEPEND="dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	x11-libs/qwt:6[opengl,qt5,svg]"

RDEPEND="net-wireless/iw
	x11-libs/libxkbcommon[X]
	policykit? ( sys-auth/polkit )
	!policykit? ( app-admin/sudo
		x11-libs/gksu )
	${DEPEND}"

S="${WORKDIR}/${P}/${PN}-app"

DOCS=( README_${PV} )

src_prepare() {
	# Use system qwt for compiling
	sed -i -e 's/CONFIG += release/CONFIG += release qwt/' linssid-app.pro || die

	# Fix lib path for x11-libs/qwt
	if use amd64; then
		sed -i -e "s/lib\/libqwt-qt5.so.6/\/$(get_libdir)\/libqwt6-qt5.so.6/" linssid-app.pro || die
	fi

	# Enable 'gksu' when a user don't want policykit
	if ! use policykit; then
		sed -i -e 's/Exec=.*/Exec=gksu linssid/' linssid.desktop || die
	fi

	default
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
