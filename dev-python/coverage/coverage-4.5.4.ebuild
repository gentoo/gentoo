# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="https://coverage.readthedocs.io/en/latest/ https://pypi.org/project/coverage/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="
	>=dev-python/setuptools-18.4[${PYTHON_USEDEP}]
	test? (
		dev-python/PyContracts[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/unittest-mixins-1.4[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# avoid the dep on xdist
	sed -i -e '/^addopts/s:-n3::' setup.cfg || die
	distutils-r1_src_prepare
}

python_compile() {
	if [[ ${EPYTHON} == python2.7 ]]; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing
	"${EPYTHON}" igor.py test_with_tracer py || die
	"${EPYTHON}" igor.py test_with_tracer c || die
}
