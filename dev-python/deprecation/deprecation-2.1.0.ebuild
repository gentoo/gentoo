# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A library to handle automated deprecations"
HOMEPAGE="https://deprecation.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests unittest

src_prepare() {
	sed -i -e 's:unittest2:unittest:' tests/test_deprecation.py || die
	distutils-r1_src_prepare
}
