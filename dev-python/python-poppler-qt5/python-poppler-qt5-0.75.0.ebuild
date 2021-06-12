# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1 qmake-utils

DESCRIPTION="Python binding for libpoppler-qt5"
HOMEPAGE="https://github.com/frescobaldi/python-poppler-qt5"
SRC_URI="https://github.com/frescobaldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-text/poppler[qt5]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
	<dev-python/sip-5:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_compile() {
	distutils-r1_python_compile build_ext --qmake-bin=$(qt5_get_bindir)/qmake
}

python_install() {
	export PATH=$(qt5_get_bindir):$PATH
	distutils-r1_python_install
}
