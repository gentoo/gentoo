# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Backports of the linecache module"
HOMEPAGE="https://github.com/testing-cabal/linecache2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest

src_prepare() {
	# eliminate unittest2 dep
	sed -i -e '/unittest/s:2 as.*::' linecache2/tests/test_linecache.py || die
	distutils-r1_src_prepare
}
