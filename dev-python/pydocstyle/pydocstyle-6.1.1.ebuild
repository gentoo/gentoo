# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Python docstring style checker"
HOMEPAGE="https://github.com/PyCQA/pydocstyle/"
SRC_URI="https://github.com/PyCQA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="dev-python/snowballstemmer[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/toml[${PYTHON_USEDEP}] )"

distutils_enable_tests --install pytest
# Requires network to lookup github issues
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinxcontrib-issuetracker

PATCHES=(
	"${FILESDIR}"/pydocstyle-6.1.1-disarm-pip-install.patch
)
