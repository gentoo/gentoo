# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A sphinx extension for embedding block diagrams using blockdiag"
HOMEPAGE="https://github.com/blockdiag/sphinxcontrib-blockdiag"
SRC_URI="https://github.com/blockdiag/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=dev-python/blockdiag-1.5.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${COMMON_DEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/sphinx-testing[${PYTHON_USEDEP}]
	)"
RDEPEND="${COMMON_DEPEND}
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i -e /build-base/d setup.cfg || die
	# Those tests are known-broken upstream
	# https://github.com/blockdiag/sphinxcontrib-blockdiag/pull/11
	rm tests/test_latex.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
