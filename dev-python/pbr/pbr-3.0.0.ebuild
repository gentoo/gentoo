# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86 ~amd64-linux ~x86-linux"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# git is needed for tests, see https://bugs.launchpad.net/pbr/+bug/1326682 and https://bugs.gentoo.org/show_bug.cgi?id=561038
# docutils is needed for sphinx exceptions... https://bugs.gentoo.org/show_bug.cgi?id=603848
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.5.1[$(python_gen_usedep 'python2_7' 'python3_4' 'python3_5' 'python3_6')]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-13.1.0[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-vcs/git
	)"
PDEPEND=""

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
	sed \
		-e "s:test_wsgi_script_install:_&:" \
		-i pbr/tests/test_wsgi.py || die
	einfo "rogue tests disabled"
	sed -i '/^hacking/d' test-requirements.txt || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}
