# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE="examples"

RDEPEND="
	>=dev-python/ptyprocess-0.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-github-alt

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
	)

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				# TODO: changes in python3.13's prompt?
				tests/test_replwrap.py::REPLWrapTestCase::test_python
				tests/test_replwrap.py::REPLWrapTestCase::test_no_change_prompt
			)
			;;
	esac

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
