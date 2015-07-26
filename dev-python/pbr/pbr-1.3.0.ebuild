# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pbr/pbr-1.3.0.ebuild,v 1.2 2015/07/26 15:30:18 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"
RDEPEND="dev-python/pip[${PYTHON_USEDEP}]"

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
	# Note; Tests, that have been removed, pass once package is emerged.
	esetup.py testr
}
