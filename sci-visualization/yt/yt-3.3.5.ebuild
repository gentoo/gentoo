# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Astrophysical Simulation Analysis and Vizualization package"
HOMEPAGE="http://yt-project.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	>=dev-python/cython-0.24[${PYTHON_USEDEP}]
	>=dev-python/setuptools-20.0[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	append-flags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	nosetests -sv --exclude=test_flake8 || die "Tests fail with ${EPYTHON} ${PWD}"
	popd >/dev/null || die
}
