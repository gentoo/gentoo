# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Simple VTXXX-compatible terminal emulator"
HOMEPAGE="https://pypi.python.org/pypi/pyte/ https://github.com/selectel/pyte"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/wcwidth[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test --verbose
}
