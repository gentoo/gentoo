# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 xdg

DESCRIPTION="A LilyPond sheet music text editor"
HOMEPAGE="https://www.frescobaldi.org/"
SRC_URI="https://github.com/wbsoft/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/PyQt5[gui,network,printsupport,svg,widgets,${PYTHON_USEDEP}]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	dev-python/python-ly[${PYTHON_USEDEP}]
	dev-python/python-poppler-qt5[${PYTHON_USEDEP}]
	dev-python/qpageview[${PYTHON_USEDEP}]
	media-sound/lilypond"
RDEPEND="${DEPEND}
	x11-themes/tango-icon-theme
"

python_prepare_all() {
	rm -r frescobaldi_app/icons/Tango || die "failed to remove tango icon theme"
	distutils-r1_python_prepare_all
}
