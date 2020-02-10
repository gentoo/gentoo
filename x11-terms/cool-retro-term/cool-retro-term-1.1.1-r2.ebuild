# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

QTW_PN=qmltermwidget
QTW_PV=0.2.0
QTW_P=${QTW_PN}-${QTW_PV}

DESCRIPTION="terminal emulator which mimics the look and feel of the old cathode tube screens"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term"
SRC_URI="https://github.com/Swordfish90/cool-retro-term/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Swordfish90/qmltermwidget/archive/${QTW_PV}.tar.gz -> ${QTW_P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
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
	pushd qmltermwidget || die
	eapply "${FILESDIR}"/qmltermwidget-0.2.0-gcc-10.patch
	popd || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	# default attempts to install directly to /usr
	emake INSTALL_ROOT="${D}" install
	doman packaging/debian/cool-retro-term.1
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
