# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python module for spawning child apps and responding to expected patterns"
HOMEPAGE="
	https://pexpect.readthedocs.io/
	https://pypi.org/project/pexpect/
	https://github.com/pexpect/pexpect/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="examples"

RDEPEND="
	>=dev-python/ptyprocess-0.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-github-alt

PATCHES=(
	# https://github.com/pexpect/pexpect/pull/794
	"${FILESDIR}/${P}-py313.patch"
	# https://github.com/pexpect/pexpect/pull/808
	"${FILESDIR}/${P}-py314.patch"
)

src_test() {
	# workaround new readline defaults
	echo "set enable-bracketed-paste off" > "${T}"/inputrc || die
	local -x INPUTRC="${T}"/inputrc

	distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# flaky test on weaker arches
		tests/test_performance.py
		# requires zsh installed, not worth it
		tests/test_replwrap.py::REPLWrapTestCase::test_zsh
		# flaky
		tests/test_env.py::TestCaseEnv::test_spawn_uses_env
		# flaky & hangy
		tests/test_socket.py::ExpectTestCase::test_interrupt
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
