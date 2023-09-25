# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="
	https://github.com/pypa/setuptools_scm/
	https://pypi.org/project/setuptools-scm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

# there's an optional dep on rich for cute logs
RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-vcs/git
		!sparc? (
			dev-vcs/mercurial
		)
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# the usual nondescript gpg-agent failure
		testing/test_git.py::test_git_getdate_signed_commit

		# fetching from the Internet
		testing/test_regressions.py::test_pip_download

		# calls flake8, unpredictable
		testing/test_functions.py::test_dump_version_flake8
	)

	if has_version dev-python/nose; then
		EPYTEST_DESELECT+=(
			# https://bugs.gentoo.org/892639
			testing/test_integration.py::test_pyproject_support
		)
	fi

	epytest
}
