# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 x86 ~amd64-linux ~x86-linux"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

# git is needed for tests, see https://bugs.launchpad.net/pbr/+bug/1326682 and https://bugs.gentoo.org/show_bug.cgi?id=561038
# docutils is needed for sphinx exceptions... https://bugs.gentoo.org/show_bug.cgi?id=603848
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
			!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
			>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
			>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.5.1[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.6.1[${PYTHON_USEDEP}]
			>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
			>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-13.1.0[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-vcs/git
		' -3)
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
	rm pbr/tests/test_wsgi.py || die "couldn't remove wsgi network tests"
	einfo "rogue tests disabled"
	sed -i '/^hacking/d' test-requirements.txt || die

	distutils-r1_python_prepare_all
}

python_test() {
	if ! python_is_python3; then
		ewarn "Skipping tests on ${EPYTHON} to unblock circular deps."
		ewarn "Please run tests manually."
		return
	fi

	distutils_install_for_testing

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}
