# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Backports of the traceback module"
HOMEPAGE="https://github.com/testing-cabal/traceback2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"

RDEPEND="
	dev-python/linecache2[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

src_prepare() {
	# fails by line numbers on various py3 versions
	sed -i -e 's:test_context_suppression:_&:' \
		-e 's:test_format_locals:_&:' \
		-e 's:test_bad_indentation:_&:' \
		-e 's:test_encoded_file:_&:' \
		traceback2/tests/test_traceback.py || die
	distutils-r1_src_prepare
}
