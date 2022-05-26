# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python docstring style checker"
HOMEPAGE="
	https://github.com/PyCQA/pydocstyle/
	https://pypi.org/project/pydocstyle/
"
SRC_URI="
	https://github.com/PyCQA/pydocstyle/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/snowballstemmer[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/toml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# Requires network to lookup github issues
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinxcontrib-issuetracker

PATCHES=(
	"${FILESDIR}"/pydocstyle-6.1.1-disarm-pip-install.patch
)
