# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
LANGS="cs de en es fa he it ru uk pl pt af"

inherit cmake-utils

DESCRIPTION="Qt4 GUI configuration tool for Wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}%20${PV}/${PF}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +icoutils +wineappdb -dbus gnome kde"

for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	dev-util/cmake"

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	icoutils? ( >=media-gfx/icoutils-0.26.0 )
	sys-fs/fuseiso
	kde? ( kde-apps/kdesu:4 )
	gnome? ( x11-libs/gksu )
	dbus? ( dev-qt/qtdbus:4 )"

DOCS="README AUTHORS ChangeLog"

S="${WORKDIR}/${PF}"

src_configure() {
	mycmakeargs="${mycmakeargs} \
		$(cmake-utils_use debug DEBUG) \
		$(cmake-utils_use_with icoutils ICOUTILS) \
		$(cmake-utils_use_with wineappdb WINEAPPDB) \
		$(cmake-utils_use_with dbus DBUS)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			find "${D}" -name "${PN}_${x}*.qm" -exec rm {} \;
		fi
	done
}
