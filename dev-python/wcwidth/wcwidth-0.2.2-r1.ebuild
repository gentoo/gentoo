# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Measures number of Terminal column cells of wide-character codes"
HOMEPAGE="https://pypi.org/project/wcwidth/ https://github.com/jquast/wcwidth"
SRC_URI="
	https://github.com/jquast/wcwidth/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]
	' -2)"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--cov-append::' \
		-e 's:--cov-report=html::' \
		-e 's:--cov=wcwidth::' \
		-i tox.ini || die
	sed -i -e 's:test_package_version:_&:' tests/test_core.py || die
	distutils-r1_src_prepare
}
