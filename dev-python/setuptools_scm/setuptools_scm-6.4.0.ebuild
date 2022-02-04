# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="
	https://github.com/pypa/setuptools_scm/
	https://pypi.org/project/setuptools-scm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
BDEPEND="
	!!<dev-python/setuptools_scm-2
	test? (
		>dev-python/virtualenv-20[${PYTHON_USEDEP}]
		dev-vcs/git
		!sparc? ( dev-vcs/mercurial )
	)"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fetching from the Internet
	testing/test_regressions.py::test_pip_download
	testing/test_setuptools_support.py
	# known broken; https://github.com/pypa/setuptools_scm/issues/668
	testing/test_integration.py::test_provides_toml_exta
)
