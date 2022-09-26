# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P="path-${PV}"
DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path/ https://github.com/jaraco/path"
SRC_URI="mirror://pypi/p/path/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	!<dev-python/pytest-shutil-1.7.0-r1
	!<dev-python/pytest-virtualenv-1.7.0-r1
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# unreliable, not really meaningful for end users
	test_path.py::TestPerformance
)
