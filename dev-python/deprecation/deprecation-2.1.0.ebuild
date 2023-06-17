# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A library to handle automated deprecations"
HOMEPAGE="https://deprecation.readthedocs.io/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests unittest

src_prepare() {
	sed -i -e 's:unittest2:unittest:' tests/test_deprecation.py || die
	distutils-r1_src_prepare
}
