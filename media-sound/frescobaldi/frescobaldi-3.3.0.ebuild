# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 xdg

DESCRIPTION="A LilyPond sheet music text editor"
HOMEPAGE="https://www.frescobaldi.org/"
SRC_URI="https://github.com/frescobaldi/frescobaldi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

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
	emake -C i18n
	emake -C linux
}
