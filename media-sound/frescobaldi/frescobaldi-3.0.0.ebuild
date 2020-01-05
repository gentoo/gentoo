# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="A LilyPond sheet music text editor"
HOMEPAGE="http://www.frescobaldi.org/"
SRC_URI="https://github.com/wbsoft/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# 	portmidi? ( media-libs/portmidi[${PYTHON_USEDEP}] ) # bug 550820
DEPEND="
	dev-python/PyQt5[gui,network,printsupport,svg,webkit,widgets,${PYTHON_USEDEP}]
	>=dev-python/python-ly-0.9.4[${PYTHON_USEDEP}]
	dev-python/python-poppler-qt5[${PYTHON_USEDEP}]
	>=media-sound/lilypond-2.14.2"
RDEPEND="${DEPEND}
	x11-themes/tango-icon-theme
"

python_prepare_all() {
	rm -r frescobaldi_app/icons/Tango || die "failed to remove tango icon theme"
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
