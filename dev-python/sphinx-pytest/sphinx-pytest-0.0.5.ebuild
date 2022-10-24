# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Helpful pytest fixtures for Sphinx extensions"
HOMEPAGE="
	https://github.com/chrisjsewell/sphinx-pytest/
	https://pypi.org/project/sphinx_pytest/
"
SRC_URI="
	https://github.com/chrisjsewell/sphinx-pytest/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
