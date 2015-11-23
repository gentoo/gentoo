# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="PBR is a library that injects some useful and sensible default
behaviors into your setuptools run."
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/flake8-2.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}] )"
PDEPEND=">dev-python/pip-1.4[${PYTHON_USEDEP}]"

# Requ'd for testsuite
DISTUTILS_IN_SOURCE_BUILD=1

# This normally actually belongs here.
python_prepare_all() {
	# This test passes when run within the source and doesn't represent a failure, but rather
	# a gentoo sandbox constraint
	# Rm tests that rely upon the package being already installed and fail
	sed -e s':test_console_script_develop:_&:' \
		-e s':test_console_script_install:_&:' \
		-e s':test_sdist_extra_files:_&:' \
		-e s':test_command_hooks:_&:' \
		-e s':test_sdist_git_extra_files:_&:' \
		-i pbr/tests/test_core.py || die
	sed -e s':test_command_hooks:_&:' \
		-e s':test_global_setup_hooks:_&:' \
		-i pbr/tests/test_hooks.py || die
	einfo "rogue tests disabled"

	distutils-r1_python_prepare_all
}

python_test() {
	# Note; removed tests pass once package is emerged,
	# it's the suite's design that breaks form, not the tests' intended purpose
	testr init
	testr run || die "Testsuite failed under ${EPYTHON}"
}
