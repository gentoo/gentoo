# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Qt music player"
HOMEPAGE="https://flavio.tordini.org/musique"
SRC_URI="https://github.com/flaviotordini/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	media-libs/phonon[qt5(+)]
	media-libs/taglib
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES TODO )

PATCHES=( "${FILESDIR}/${P}-unbundle-qtsingleapplication.patch" )

src_prepare() {
	rm -r src/qtsingleapplication || die
	default
}

src_configure() {
	eqmake5 ${PN}.pro PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
