# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
COMMIT=50fb2eb9ea34cf94e3756b7ddfc601af023267d5
inherit distutils-r1 flag-o-matic qmake-utils vcs-snapshot

DESCRIPTION="A python binding for libpoppler-qt5"
HOMEPAGE="https://github.com/wbsoft/python-poppler-qt5"
SRC_URI="https://github.com/wbsoft/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-text/poppler[qt5]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_configure_all() {
	append-cxxflags -std=c++11
	mydistutilsargs=( build_ext --qmake-bin=$(qt5_get_bindir)/qmake )
}
