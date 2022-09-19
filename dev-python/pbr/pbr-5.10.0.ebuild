# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{8..11} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Inject some useful and sensible default behaviors into setuptools"
HOMEPAGE="
	https://opendev.org/openstack/pbr/
	https://github.com/openstack/pbr/
	https://pypi.org/project/pbr/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/setuptools-60.5.0[${PYTHON_USEDEP}]
"
# git is needed for tests, see https://bugs.launchpad.net/pbr/+bug/1326682 and https://bugs.gentoo.org/show_bug.cgi?id=561038
# docutils is needed for sphinx exceptions... https://bugs.gentoo.org/show_bug.cgi?id=603848
# stestr is run as external tool
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
			>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
			>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			>=dev-python/testresources-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
			>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20.0.3[${PYTHON_USEDEP}]
			dev-vcs/git
		' "${PYTHON_TESTED[@]}")
	)"

distutils_enable_tests unittest

python_prepare_all() {
	# TODO: investigate
	sed -e 's:test_console_script_develop:_&:' \
		-e 's:test_console_script_install:_&:' \
		-e 's:test_setup_py_keywords:_&:' \
		-i pbr/tests/test_core.py || die
	# network
	rm pbr/tests/test_wsgi.py || die
	# installs random packages via pip from the Internet
	sed -e 's:test_requirement_parsing:_&:' \
		-e 's:test_pep_517_support:_&:' \
		-i pbr/tests/test_packaging.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Testing on ${EPYTHON} is not supported at the moment"
		return
	fi

	eunittest -b
}
