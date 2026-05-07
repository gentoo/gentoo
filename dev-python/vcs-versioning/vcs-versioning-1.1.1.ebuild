# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pypa/setuptools-scm
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Core VCS versioning functionality from setuptools-scm"
HOMEPAGE="
	https://github.com/pypa/setuptools-scm/
	https://pypi.org/project/vcs-versioning/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/packaging-20[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/packaging-20[${PYTHON_USEDEP}]
	test? (
		>=dev-python/setuptools-scm-10[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# the usual nondescript gpg-agent failure
	testing_vcs/test_git.py::test_git_getdate_signed_commit
)
