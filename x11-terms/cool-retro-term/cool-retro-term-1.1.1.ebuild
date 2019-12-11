# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils

QTW_PN=qmltermwidget
QTW_PV=0.2.0
QTW_P=${QTW_PN}-${QTW_PV}

DESCRIPTION="terminal emulator which mimics the look and feel of the old cathode tube screens"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term"
SRC_URI="https://github.com/Swordfish90/cool-retro-term/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Swordfish90/qmltermwidget/archive/${QTW_PV}.tar.gz -> ${QTW_P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	rmdir qmltermwidget || die
	mv "${WORKDIR}/${QTW_P}" qmltermwidget || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	# default attempts to install directly to /usr
	emake INSTALL_ROOT="${D}" install
	doman packaging/debian/cool-retro-term.1
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
