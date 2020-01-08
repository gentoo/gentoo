# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="A hack for test fixtures, needed for hypothesis inside py.test"
HOMEPAGE="https://github.com/untitaker/pytest-subtesthack/"
# pypi tarball misses tests
SRC_URI="https://github.com/untitaker/pytest-subtesthack/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing
	py.test -v || die "Tests fail with ${EPYTHON}"
}
