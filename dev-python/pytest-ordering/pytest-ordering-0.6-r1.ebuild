# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="pytest plugin to run your tests in a specific order"
HOMEPAGE="
	https://github.com/ftobia/pytest-ordering/
	https://pypi.org/project/pytest-ordering/
"
SRC_URI="
	https://github.com/ftobia/pytest-ordering/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-pytest-6.patch"
	"${FILESDIR}/${P}-marks.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source
