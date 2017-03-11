# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Distributed testing and loop-on-failing modes"
HOMEPAGE="https://pypi.python.org/pypi/pytest-xdist https://github.com/pytest-dev/pytest-xdist"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	>=dev-python/execnet-1.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/readme[${PYTHON_USEDEP}]
	)
"

# Optional test dep:
# dev-python/pexpect[${PYTHON_USEDEP}]

PATCHES=(
	"${FILESDIR}"/1.15.0-test_manytests_to_one_import_error.patch
)

python_prepare_all() {
	# pexpect fail
	sed -i -e 's/test_xfail_passes/_&/' testing/test_looponfail.py
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	py.test -vv || die "Tests failed under ${EPYTHON}"
}
