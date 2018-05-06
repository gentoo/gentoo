# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx flag-o-matic

DESCRIPTION="Enthought Tool Suite: Interactive plotting toolkit"
HOMEPAGE="http://docs.enthought.com/chaco/
	https://github.com/enthought/chaco
	https://pypi.python.org/pypi/chaco"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/enable-4.4.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

python_prepare_all() {
	append-cflags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	VIRTUALX_COMMAND="nosetests" virtualmake
}
