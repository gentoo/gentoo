# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A small 'shelve' like datastore with concurrency support"
HOMEPAGE="https://github.com/pickleshare/pickleshare"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/path-6.2[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
