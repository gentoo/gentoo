# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_VERIFY_REPO=https://github.com/pypa/setuptools-scm
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="
	https://github.com/pypa/setuptools-scm/
	https://pypi.org/project/setuptools-scm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

# there's an optional dep on rich for cute logs
RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-64[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# the usual nondescript gpg-agent failure
	testing/test_git.py::test_git_getdate_signed_commit

	# fetching from the Internet
	testing/test_integration.py::test_xmlsec_download_regression
	testing/test_regressions.py::test_pip_download

	# calls flake8, unpredictable
	testing/test_functions.py::test_dump_version_flake8

	# incompatible with current mypy version
	testing/test_functions.py::test_dump_version_mypy
)
