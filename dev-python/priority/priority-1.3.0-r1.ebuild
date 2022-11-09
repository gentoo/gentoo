# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A pure-Python implementation of the HTTP/2 priority tree"
HOMEPAGE="
	https://python-hyper.org/projects/priority/en/latest/
	https://github.com/python-hyper/priority/
	https://pypi.org/project/priority/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? ( >=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/priority-1.3.0-test-timeout.patch
)

distutils_enable_tests pytest
