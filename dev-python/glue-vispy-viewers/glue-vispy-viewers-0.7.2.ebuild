# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 virtualx

DESCRIPTION="Vispy-based viewers for Glue"
HOMEPAGE="https://github.com/glue-viz/glue-3d-viewer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="0"
IUSE="test"

DOCS=( README.rst CHANGES.md )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/glueviz[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP},designer,gui]
	sci-libs/scipy[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		  ${RDEPEND}
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	echo "backend: Agg" > matplotlibrc
	virtx py.test || die
}
