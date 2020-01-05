# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# It is the developer's intention that backports.unittest_mock will be
# used even for Python 3: https://github.com/jaraco/jaraco.timing/pull/1
PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_PN="${MY_PN//-/_}"
DESCRIPTION="Backport of unittest.mock"
HOMEPAGE="https://github.com/jaraco/backports.unittest_mock"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-python/backports[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="!test? ( test )"

distutils_enable_sphinx docs \
	'>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}':" setup.py || die
	sed -r -i "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+)[[:space:]]*::" \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Override pytest options to skip flake8
	pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

python_install() {
	# avoid a collision with dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
