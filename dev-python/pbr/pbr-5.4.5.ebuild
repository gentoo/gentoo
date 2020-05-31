# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

# git is needed for tests, see https://bugs.launchpad.net/pbr/+bug/1326682 and https://bugs.gentoo.org/show_bug.cgi?id=561038
# docutils is needed for sphinx exceptions... https://bugs.gentoo.org/show_bug.cgi?id=603848
# stestr is run as external tool
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
			>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
			>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			>=dev-python/testresources-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
			>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
			<dev-python/virtualenv-20[${PYTHON_USEDEP}]
			>=dev-python/stestr-2.1.0
			dev-vcs/git
		' -3)
	)"
PDEPEND=""

# This normally actually belongs here.
python_prepare_all() {
	# TODO: investigate
	sed -e s':test_console_script_develop:_&:' \
		-e s':test_console_script_install:_&:' \
		-i pbr/tests/test_core.py || die
	# broken on pypy3
	# https://bugs.launchpad.net/pbr/+bug/1881479
	sed -e 's:test_generates_c_extensions:_&:' \
		-i pbr/tests/test_packaging.py || die
	rm pbr/tests/test_wsgi.py || die "couldn't remove wsgi network tests"

	distutils-r1_python_prepare_all
}

python_test() {
	if ! python_is_python3; then
		ewarn "Skipping tests on ${EPYTHON} to unblock circular deps."
		ewarn "Please run tests manually."
		return
	fi

	distutils_install_for_testing
	local -x PATH=${TEST_DIR}/scripts:${PATH}

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	stestr init || die "stestr init failed under ${EPYTHON}"
	stestr run || die "stestr run failed under ${EPYTHON}"
}
