# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( pypy3 python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A small 'shelve' like datastore with concurrency support"
HOMEPAGE="
	https://github.com/ipython/pickleshare/
	https://pypi.org/project/pickleshare/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/path-6.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
