# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Cross-platform, aesthetic, distraction-free markdown editor"
HOMEPAGE="https://wereturtle.github.io/ghostwriter/"
SRC_URI="https://github.com/wereturtle/ghostwriter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-text/hunspell
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/linguist-tools:5
"

DOCS=( CREDITS.md README.md )

src_prepare() {
	default

	sed -i -e "/^VERSION =/s/\$.*/${PV}/" ghostwriter.pro || die "failed to override version"
}

src_configure() {
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
