# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTML parser based on the HTML5 specification"
HOMEPAGE="
	https://github.com/html5lib/html5lib-python/
	https://html5lib.readthedocs.io/
	https://pypi.org/project/html5lib/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-pytest6.patch
)

RDEPEND="
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-expect[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
