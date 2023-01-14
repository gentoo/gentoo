# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Easily freeze time in pytest test + fixtures"
HOMEPAGE="
	https://pypi.org/project/pytest-freezegun/
	https://github.com/ktosiek/pytest-freezegun/
"
SRC_URI="
	https://github.com/ktosiek/pytest-freezegun/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/freezegun[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/ktosiek/pytest-freezegun/pull/38
	"${FILESDIR}"/${P}-distutils-depr.patch
)
